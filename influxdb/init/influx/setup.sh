#!/bin/sh
set -eu

echo "[init] InfluxDB post-setup…"

# === Required env ===
: "${INFLUXDB_URL:?missing INFLUXDB_URL (e.g., http://influxdb:8086)}"
: "${INFLUXDB_ADMIN_TOKEN:?missing INFLUXDB_ADMIN_TOKEN}"
: "${INFLUXDB_ORG:?missing INFLUXDB_ORG}"

# === Buckets & retention (0 = infinite) ===
RAW_BUCKET="${RAW_BUCKET:-stamm_raw}"
RAW_RETENTION="${RAW_RETENTION:-0}"

PRED_BUCKET="${PREDICTIONS_BUCKET:-stamm_predictions}"
PRED_RETENTION="${PREDICTIONS_RETENTION:-0}"

META_BUCKET="${METADATA_BUCKET:-stamm_metadata}"
META_RETENTION="${METADATA_RETENTION:-0}"

# === Token labels ===
RAW_RW_TOKEN_NAME="${RAW_RW_TOKEN_NAME:-stamm_raw_rw}"
PRED_RW_TOKEN_NAME="${PRED_RW_TOKEN_NAME:-stamm_predictions_rw}"
META_RW_TOKEN_NAME="${META_RW_TOKEN_NAME:-stamm_metadata_rw}"

RAW_RO_TOKEN_NAME="${RAW_RO_TOKEN_NAME:-stamm_raw_ro}"
PRED_RO_TOKEN_NAME="${PRED_RO_TOKEN_NAME:-stamm_predictions_ro}"
META_RO_TOKEN_NAME="${META_RO_TOKEN_NAME:-stamm_metadata_ro}"

SECRETS_DIR="/opt/secrets"
mkdir -p "${SECRETS_DIR}"

# Influx CLI uses INFLUX_TOKEN
export INFLUX_TOKEN="${INFLUXDB_ADMIN_TOKEN}"

bucket_exists() {
  influx bucket find --host "${INFLUXDB_URL}" --org "${INFLUXDB_ORG}" --name "$1" >/dev/null 2>&1
}

ensure_bucket() {
  name="$1"; retention="$2"
  if bucket_exists "${name}"; then
    echo "[init] Bucket '${name}' already exists."
  else
    echo "[init] Creating bucket '${name}' (retention=${retention})…"
    if [ "${retention}" = "0" ]; then
      influx bucket create --host "${INFLUXDB_URL}" --org "${INFLUXDB_ORG}" --name "${name}"
    else
      influx bucket create --host "${INFLUXDB_URL}" --org "${INFLUXDB_ORG}" --name "${name}" --retention "${retention}"
    fi
  fi
}

# Obtiene el ID leyendo la salida en tabla (sin --json), 1ª fila de datos, 1ª columna (ID hex)
bucket_id() {
  influx bucket find --host "${INFLUXDB_URL}" --org "${INFLUXDB_ORG}" --name "$1" \
  | awk 'NR>1 && $1 ~ /^[0-9a-fA-F]+$/ {print $1; exit 0}'
}

create_rw_token() {
  label="$1"; bid="$2"; file="$3"
  if [ -z "${bid}" ]; then
    echo "[init][warn] Empty bucket ID when creating RW token '${label}'. Listing buckets for debugging:"
    influx bucket list --host "${INFLUXDB_URL}" --org "${INFLUXDB_ORG}" || true
    exit 1
  fi
  echo "[init] Creating RW token '${label}' for bucket id=${bid}…"
  influx auth create --host "${INFLUXDB_URL}" --org "${INFLUXDB_ORG}" \
    --description "${label}" --read-bucket "${bid}" --write-bucket "${bid}" \
  | awk -F'\t' 'NR>1 && NF>=1 {print $1; exit 0}' | tee "${file}" >/dev/null
}

create_ro_token() {
  label="$1"; bid="$2"; file="$3"
  if [ -z "${bid}" ]; then
    echo "[init][warn] Empty bucket ID when creating RO token '${label}'. Listing buckets for debugging:"
    influx bucket list --host "${INFLUXDB_URL}" --org "${INFLUXDB_ORG}" || true
    exit 1
  fi
  echo "[init] Creating RO token '${label}' for bucket id=${bid}…"
  influx auth create --host "${INFLUXDB_URL}" --org "${INFLUXDB_ORG}" \
    --description "${label}" --read-bucket "${bid}" \
  | awk -F'\t' 'NR>1 && NF>=1 {print $1; exit 0}' | tee "${file}" >/dev/null
}

echo "[init] Ensuring buckets…"
ensure_bucket "${RAW_BUCKET}"  "${RAW_RETENTION}"
ensure_bucket "${PRED_BUCKET}" "${PRED_RETENTION}"
ensure_bucket "${META_BUCKET}" "${META_RETENTION}"

RAW_ID="$(bucket_id "${RAW_BUCKET}")"
PRED_ID="$(bucket_id "${PRED_BUCKET}")"
META_ID="$(bucket_id "${META_BUCKET}")"
echo "[init] Bucket IDs: raw=${RAW_ID:-<none>} pred=${PRED_ID:-<none>} meta=${META_ID:-<none>}"

echo "[init] Generating tokens…"
create_rw_token "${RAW_RW_TOKEN_NAME}"  "${RAW_ID}"  "${SECRETS_DIR}/raw_rw.token"
create_rw_token "${PRED_RW_TOKEN_NAME}" "${PRED_ID}" "${SECRETS_DIR}/predictions_rw.token"
create_rw_token "${META_RW_TOKEN_NAME}" "${META_ID}" "${SECRETS_DIR}/metadata_rw.token"

[ -n "${RAW_RO_TOKEN_NAME}" ]  && create_ro_token "${RAW_RO_TOKEN_NAME}"  "${RAW_ID}"  "${SECRETS_DIR}/raw_ro.token"         || true
[ -n "${PRED_RO_TOKEN_NAME}" ] && create_ro_token "${PRED_RO_TOKEN_NAME}" "${PRED_ID}" "${SECRETS_DIR}/predictions_ro.token" || true
[ -n "${META_RO_TOKEN_NAME}" ] && create_ro_token "${META_RO_TOKEN_NAME}" "${META_ID}" "${SECRETS_DIR}/metadata_ro.token"    || true

echo "[init] Done. Tokens written to ${SECRETS_DIR}/*.token"