# PostgreSQL / TimescaleDB Backbone — STAMM

This directory contains the **PostgreSQL + TimescaleDB** relational backbone for **STAMM**.
It is the work-in-progress counterpart of the InfluxDB stack, designed to capture the **operational and organisational context** that a pure time-series store cannot natively represent — experiments, runs, equipment, laboratories, organisations, users, dynamic models and simulations — alongside the same sensor, actuator and prediction streams modelled as TimescaleDB **hypertables**.

> **Status:** 🚧 Ongoing work. The schema is complete and self-contained; an accompanying Docker stack and bootstrap tokens (mirroring the InfluxDB setup) will be added in a future release.

---

## Folder structure

```
postgreSQL/
├─ DATABASE.sql     # Full schema: extensions, tables, constraints, hypertables, indexes
├─ clean_data.sql   # Reference data dump (projects etc.) for bootstrapping
├─ stamm_db.pgerd   # pgAdmin ERD of the schema
└─ README.md
```

---

## 1. Prerequisites

- **PostgreSQL 17 or 18** (tested on PostgreSQL 18.3).
- **TimescaleDB** extension installed on the target instance.
  Ubuntu/Debian install:
  ```bash
  sudo apt install timescaledb-2-postgresql-17
  ```
  Or use the official [`timescale/timescaledb:latest-pg17`](https://hub.docker.com/r/timescale/timescaledb) Docker image.
- **`uuid-ossp`** extension (shipped with PostgreSQL; enabled automatically by the script).
- `psql` CLI (or pgAdmin 4 / DBeaver) to run the scripts.

---

## 2. Quick start

Option A — using Docker (recommended for evaluation):

```bash
docker run -d --name stamm-pg \
  -e POSTGRES_USER=stamm \
  -e POSTGRES_PASSWORD=change_me_secure \
  -e POSTGRES_DB=stamm_db \
  -p 5432:5432 \
  timescale/timescaledb:latest-pg17
```

Option B — existing PostgreSQL server:

```bash
createdb stamm_db
```

Then, from this folder, run the schema:

```bash
psql "postgresql://stamm:change_me_secure@localhost:5432/stamm_db" -f DATABASE.sql
```

Optionally load the reference data (currently contains the two STAMM reference projects: IndPenSim and Bioindustry_E.Coli):

```bash
psql "postgresql://stamm:change_me_secure@localhost:5432/stamm_db" -f clean_data.sql
```

Verify the TimescaleDB hypertables were created:

```sql
SELECT hypertable_name FROM timescaledb_information.hypertables;
```

Expected output:
```
 hypertable_name
-----------------
 sensor_readings
 actuator_states
 predictions
```

---

## 3. Data model overview

The schema separates **long-lived project context** (relational, normalised) from **high-frequency observations** (time-partitioned hypertables).

### 3.1 Time-series core (TimescaleDB hypertables)

| Hypertable | Partition key | Composite PK | Purpose |
|---|---|---|---|
| `sensor_readings` | `time` (timestamptz) | `(time, run_id, sensor_id)` | Raw online sensor measurements |
| `actuator_states` | `time` (timestamptz) | `(time, run_id, actuator_id)` | Actuator set-points and states |
| `predictions`     | `time` (timestamptz) | `(time, run_id, soft_sensor_id)` | Soft-sensor model outputs |

Each hypertable has a dedicated composite index for efficient `run_id`-filtered, time-ordered queries.

### 3.2 Operational context

| Entity | Purpose |
|---|---|
| `projects` | Top-level scientific project (e.g. IndPenSim, Bioindustry_E.Coli) |
| `experiments` | Experimental design: initial conditions, set-points, start/end time |
| `runs` | Individual executions of an experiment on physical (or simulated) equipment |
| `experiments_equipments` | Many-to-many link between experiments and the instruments used |
| `equipments`, `equipment_components` | Instruments and their constituent sensors/actuators |
| `sensors`, `actuators` | Physical devices with unit, description, calibration metadata |
| `annotations` | Human-in-the-loop labels on data points (linked to `runs` and `users`) |
| `alerts` | Drift-detection or threshold alerts raised during an experiment |

### 3.3 Model registry

| Entity | Purpose |
|---|---|
| `soft_sensors` | Pointers to exported ML artefacts (`path_metadata`, `path_model`) |
| `project_soft_sensors` | Which soft sensors are registered for a given project |
| `soft_sensor_metrics` | Predictive-performance metrics per experiment per soft sensor |
| `dynamic_model` | Descriptors for ODE-based / hybrid models (name, version, endpoint) |
| `project_dynamic_models` | Link between projects and dynamic models |
| `simulations` | Recorded simulation runs of dynamic models |

### 3.4 Access control (RBAC + organisational hierarchy)

| Entity | Purpose |
|---|---|
| `users` | Accounts that author, run or validate experiments |
| `roles`, `permissions`, `role_permission` | Role-based access control |
| `user_role` | Links a user to a role scoped to a laboratory |
| `organizations`, `departments`, `organizations_departments` | Institutional hierarchy |
| `laboratories`, `laboratory_user`, `laboratory_project`, `department_laboratory` | Lab membership and project assignment |

---

## 4. Entity–relationship diagram

Open `stamm_db.pgerd` in **pgAdmin 4** (*Tools → ERD Tool → Load from ERD file*) to browse the full ERD graphically.

Key relationships:

```
projects ──< experiments ──< runs ──< sensor_readings     (hypertable)
                                  ├── actuator_states    (hypertable)
                                  └── predictions        (hypertable)

experiments ──< experiments_equipments >── equipments ──< equipment_components >── sensors
                                                                               └── actuators

projects ──< project_soft_sensors >── soft_sensors ──< soft_sensor_metrics
projects ──< project_dynamic_models >── dynamic_model ──< simulations

laboratories ──< laboratory_project >── projects
laboratories ──< laboratory_user >── users ──< user_role >── roles ──< role_permission >── permissions
```

---

## 5. Design rationale — why a second backbone?

A pure time-series store (InfluxDB) is excellent for high-rate ingestion and retention-tiered storage of raw observations, but cannot natively represent:

- **Experiments and their individual runs**, the instrumented equipment each run is executed on, and the laboratories, organisations and users that author or validate them.
- **Descriptors and simulation outputs of dynamic and hybrid models**, which need foreign-key links to projects and to the prediction streams they supervise.
- **Integrity constraints and joins** across these entities (cascade deletes, referential integrity, multi-entity joins in a single query).

The PostgreSQL/TimescaleDB schema adds all of these as first-class entities and links them through foreign keys to the raw, actuator and prediction streams, so that **an experiment, a soft-sensor deployment and the corresponding dynamic-model simulation can be reconstructed together in a single SQL query**.

---

## 6. Resetting the database

To drop everything and reinitialise:

```bash
psql "postgresql://stamm:change_me_secure@localhost:5432/stamm_db" -f DATABASE.sql
```

`DATABASE.sql` begins with `DROP SCHEMA IF EXISTS public CASCADE` followed by `CREATE SCHEMA public`, so re-running it is a destructive reset.

---

## 7. Roadmap

- [ ] `docker-compose.yaml` matching the InfluxDB stack (PostgreSQL 17 + TimescaleDB + init container)
- [ ] `.env.example` with DB credentials and admin-token setup
- [ ] Automated initialisation script (equivalent of `influxdb/init/influx/setup.sh`)
- [ ] REST/GraphQL access layer for dashboards and Airflow
- [ ] Migration tooling (e.g. Alembic / Flyway) for future schema changes
- [ ] Integration tests against the IndPenSim reference batches

---

## 8. Related resources

- **STAMM main repository**: <https://github.com/stamm-4m>
- **STAMM documentation**: <https://stamm.inrae.fr>
- **InfluxDB stack** (sibling): [`../influxdb/`](../influxdb/)
- **TimescaleDB documentation**: <https://docs.tigerdata.com/>

---

## Licence

Apache License 2.0 — see the repository [LICENSE](../LICENSE).
