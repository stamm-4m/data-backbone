# Data Backbone — STAMM

This repository hosts the **database backbone** of the [STAMM](https://github.com/stamm-4m) framework.
It provides reproducible, containerised database setups that every other STAMM module (Airflow orchestrator, model registry, dashboard, drift detectors, Node-RED producers) reads from and writes to.

Two backbones are maintained in parallel:

| Database | Version | Status | Purpose | Docs |
|---|---|---|---|---|
| **InfluxDB** | 2.7 | ✅ Supported | High-rate time-series ingestion of raw sensor, actuator and prediction streams | [`influxdb/`](./influxdb/) |
| **PostgreSQL + TimescaleDB** | 17 / 18 | 🚧 Ongoing work | Relational operational context (experiments, runs, equipment, users, dynamic models) + TimescaleDB hypertables for the same time-series | [`postgreSQL/`](./postgreSQL/) |

---

## Features

- 🔗 Multi-database architecture — pick the backbone(s) that fit your deployment
- 📈 InfluxDB 2.7 integration — reproducible Docker stack, auto-provisioned buckets and scoped tokens
- 🐘 PostgreSQL + TimescaleDB schema — experiments, runs, RBAC, dynamic models, plus three time-partitioned hypertables
- ⚙️ Modular and configurable connection management
- 🧩 Shared `stamm_net` Docker network, designed to be consumed by the other STAMM stacks

---

## Folder structure

```
data-backbone/
├─ influxdb/          # InfluxDB 2.7 Docker stack (ready to use)
│  ├─ docker-compose.yaml
│  ├─ .env.example
│  ├─ init/influx/setup.sh
│  └─ README.md
├─ postgreSQL/        # PostgreSQL + TimescaleDB schema (work in progress)
│  ├─ DATABASE.sql
│  ├─ clean_data.sql
│  ├─ stamm_db.pgerd
│  └─ README.md
├─ assets/
├─ LICENSE
└─ README.md
```

---

## Quick start (InfluxDB)

```bash
cd influxdb
cp .env.example .env
# edit .env and replace the placeholder admin token
docker compose up -d
```

Buckets (`stamm_raw`, `stamm_predictions`, `stamm_metadata`) and scoped tokens are provisioned automatically. See [`influxdb/README.md`](./influxdb/README.md) for the full walk-through including token rotation, unified data model and Flux query examples.

## Quick start (PostgreSQL / TimescaleDB)

```bash
docker run -d --name stamm-pg \
  -e POSTGRES_USER=stamm -e POSTGRES_PASSWORD=change_me_secure \
  -e POSTGRES_DB=stamm_db -p 5432:5432 \
  timescale/timescaledb:latest-pg17

psql postgresql://stamm:change_me_secure@localhost:5432/stamm_db -f postgreSQL/DATABASE.sql
```

See [`postgreSQL/README.md`](./postgreSQL/README.md) for the schema, ERD and design rationale.

---

## Design rationale

The InfluxDB and PostgreSQL backbones are **complementary, not alternatives**:

- **InfluxDB** excels at high-rate ingestion, retention-tiered storage and Flux-based analytical queries on the three STAMM buckets.
- **PostgreSQL + TimescaleDB** adds the operational and organisational context (projects, experiments, equipment, users, dynamic models) as first-class relational entities, while keeping the same time-series (`sensor_readings`, `actuator_states`, `predictions`) as TimescaleDB hypertables.

A deployment can run either backbone in isolation, or both side-by-side (e.g. Influx for real-time ingestion and Postgres for curated queryable context). A future release will add a unified ingest adapter that can write to both transparently.

---

## Licence

Released under the **Apache License 2.0** — see [LICENSE](./LICENSE).

---

## Citing STAMM

If STAMM contributes to your research, please cite the associated publication (submission under review for *SoftwareX*). Once published, the canonical BibTeX entry will be listed here and at <https://stamm.inrae.fr>.

---

## Contact

For questions about the data-backbone component, open an issue on this repository or email the STAMM corresponding author listed at <https://github.com/stamm-4m>.
