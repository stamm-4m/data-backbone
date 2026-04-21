<div style="text-align: center;">
  <img src="../assets/influxDB.png" alt="ML Repository Logo" width="200"/>
</div>

# InfluxDB 2.7 Stack — STAMM 

This directory contains the **InfluxDB 2.7 stack** used by **STAMM**.  
It provides a reproducible time-series database setup, automatically creates the required buckets, 
and generates secure tokens for integration with Airflow, dashboards, and data ingestion adapters.

---

## Folder Structure

```
influxdb/
├─ docker-compose.yaml
├─ .env.example
├─ init/
│  └─ influx/
│     └─ setup.sh
├─ secrets/
└─ README.md
```

Recommended `.gitignore` entries:
```
secrets/
.env
```

---

## 1. Prerequisites

- Docker and Docker Compose installed.  
- Port **8086** available.  
- No previous InfluxDB instance running on the same port.  

> The official InfluxDB image already includes both the CLI and `jq`.

---

## 2. Environment Configuration

Copy the example file and rename it:
   ```bash
   cp .env.example .env
   ```

Edit `.env` and fill in your values:
   ```bash
   INFLUXDB_URL=http://influxdb:8086
   INFLUXDB_ADMIN_USERNAME=admin
   INFLUXDB_ADMIN_PASSWORD=change_me_secure
   INFLUXDB_ADMIN_TOKEN=YOUR_RANDOM_ADMIN_TOKEN
   INFLUXDB_ORG=stamm_org
   ```

The script automatically creates the buckets:
   - `stamm_raw` – raw sensor and device data  
   - `stamm_predictions` – machine-learning model predictions  
   - `stamm_metadata` – metadata and registry information  

---

## 3. Deployment

Start the services:

```bash
docker compose up -d
```

- The `influxdb` service performs the initial setup (admin user + organization).  
- The `influxdb-init` service waits until InfluxDB is healthy, then creates the buckets and scoped tokens.  
- Tokens are written to the local folder `influxdb/secrets/`.

Check logs:

```bash
docker compose logs -f influxdb-init
```

You should see messages such as:
```
[init] Created bucket 'stamm_raw' (id=...)
[init] Creating RW token 'stamm_predictions_rw' for bucket id=...
[init] Done. Tokens written to /opt/secrets/*.token
```

---

## 4. Using Tokens in Other Stacks

Once generated, tokens can be used in other components such as Airflow or dashboards:

```
INFLUXDB_URL=http://influxdb:8086
INFLUXDB_ORG=stamm_org
INFLUXDB_TOKEN=<paste token content here>
```

Recommended usage:

| Purpose | Token | Permissions |
|----------|--------|-------------|
| Airflow writes predictions | `predictions_rw.token` | Read/Write |
| Dashboard reads raw data | `raw_ro.token` | Read-Only |
| Metadata management | `metadata_rw.token` | Read/Write |

---

## 5. Verify Through Web Interface

Access the InfluxDB UI at [http://localhost:8086](http://localhost:8086)

Login with the admin credentials defined in `.env` and verify:
- Organization: `stamm_org`
- Buckets: `stamm_raw`, `stamm_predictions`, `stamm_metadata`
- Tokens: listed under **Load Data → API Tokens**

---

## 6. Common Commands

| Action | Command |
|--------|----------|
| Show services | `docker compose ps` |
| View logs | `docker compose logs -f influxdb` |
| Restart InfluxDB | `docker compose restart influxdb` |
| Stop stack | `docker compose down` |
| Remove all data ⚠️ | `docker compose down -v && rm -rf secrets/*` |

---

## 7. Token Rotation

1. List current tokens:
   ```bash
   export INFLUX_TOKEN=<admin_token>
   influx auth list --org stamm_org
   ```
2. Delete an old token:
   ```bash
   influx auth delete --id <token_id>
   ```
3. Create a new token via CLI or UI.  
4. Update dependent services (Airflow, dashboards) with the new token.  
5. Restart those services:
   ```bash
   docker compose up -d
   ```

---

## 8. FAQ

**Why not create all buckets via environment variables?**  
The official InfluxDB image supports only one bucket during setup. The `influxdb-init` job creates all project buckets and tokens once the server is healthy.

**Can the admin token be reused everywhere?**  
Technically yes, but that’s not secure. Use scoped tokens per bucket for better access control and auditing.

**Where are data and tokens stored?**  
- Tokens → `influxdb/secrets/*.token`  
- Data/configuration → Docker volumes `influxdb-data` and `influxdb-config`

**How can I skip creating read-only tokens?**  
Leave the RO token names empty in `.env`.

---

## 9. Environment Variable Reference

| Variable | Description |
|-----------|--------------|
| **Admin setup** |  |
| `INFLUXDB_ADMIN_USERNAME`, `INFLUXDB_ADMIN_PASSWORD`, `INFLUXDB_ADMIN_TOKEN` | Admin credentials for first-time setup |
| **Organization** |  |
| `INFLUXDB_ORG` | Organization name |
| **Buckets** |  |
| `RAW_BUCKET`, `RAW_RETENTION` | Raw data bucket and retention duration |
| `PREDICTIONS_BUCKET`, `PREDICTIONS_RETENTION` | Predictions bucket and retention duration |
| `METADATA_BUCKET`, `METADATA_RETENTION` | Metadata bucket and retention duration |
| **Token labels** |  |
| `*_RW_TOKEN_NAME` | Label for read/write token |
| `*_RO_TOKEN_NAME` | Label for read-only token (optional) |

---

## 10. Data Model Overview

The **STAMM Data Model** defines how data are structured across all three buckets, ensuring consistent ingestion and querying by Airflow, dashboards, and analytical services.

### Bucket Summary

| Bucket | Measurement | Description |
|---------|--------------|-------------|
| `stamm_raw` | `device_obs` | Raw sensor, actuator, and computed variable data. |
| `stamm_predictions` | `device_obs` | Machine-learning model predictions. |
| `stamm_metadata` | `device_obs` | Metadata: units, display names, and precision. |

### stamm_raw

**Measurement:** `device_obs`  
**Tags:** `device_id`, `project_name`, `batch_id`, `source`, `observed_property`  
**Field:** `value` *(float)*  

**Example:**
```json
{
  "_measurement": "device_obs",
  "_field": "value",
  "observed_property": "temperature",
  "source": "sensor",
  "device_id": "R1",
  "batch_id": "batch_1",
  "project_name": "penicillin",
  "_time": "2025-05-06T12:00:00Z",
  "_value": 30.2
}
```

### stamm_predictions

**Measurement:** `device_obs`  
**Tags:** `device_id`, `project_name`, `batch_id`, `source=soft_sensor`, `observed_property`, `model_id`, `version`  
**Field:** `value` *(float)*  

**Example:**
```json
{
  "_measurement": "device_obs",
  "_field": "value",
  "observed_property": "penicillin_concentration",
  "source": "soft_sensor",
  "device_id": "R1",
  "batch_id": "batch_1",
  "project_name": "penicillin",
  "model_id": "svm",
  "version": "v1.2.3",
  "_time": "2025-05-06T12:00:00Z",
  "_value": 0.085
}
```

### stamm_metadata

**Measurement:** `device_obs`  
**Tags:** `device_id`, `project_name`, `observed_property`  
**Fields:**  
- `unit` *(string)* — e.g., "L/h", "rpm", "K"  
- `display_name` *(string)* — e.g., "Sugar Feed Rate", "Agitator", "Temperature"  
- `decimals` *(int)* — number of decimals to display  

**Example:**
```json
{
  "_measurement": "device_obs",
  "observed_property": "sugar_feed_rate",
  "device_id": "R1",
  "project_name": "penicillin",
  "unit": "L/h",
  "display_name": "Sugar Feed Rate",
  "decimals": 2
}
```

### 10.5 Unified Query Model

Because all buckets share the same measurement name (`device_obs`), unified queries can be executed seamlessly.

**Example Flux Query:**
```flux
from(bucket: "stamm_predictions")
  |> range(start: -7d)
  |> filter(fn: (r) => r._measurement == "device_obs" and r.source == "soft_sensor")
  |> filter(fn: (r) => r.observed_property == "penicillin_concentration")
```

---

### Summary

This InfluxDB 2.7 stack provides a secure, consistent, and fully documented database backend for the STAMM.  
Buckets, retention policies, and tokens are automatically provisioned, and the unified data model ensures compatibility between all STAMM components — data ingestion, Airflow orchestration, and dashboards.

### 📬 Contact

For questions, contact Alexander Astudillo at jairo.astudillo-lagos@inrae.fr