# Data Backbone
This repository contains the database component of the project. It centralizes database connection management, schema handling, and data access for other project modules.

### Overview

The goal of this module is to provide a flexible and extensible database interface that can connect to multiple database backends.
Currently, the implementation supports InfluxDB 2.7, and support for other databases (e.g., PostgreSQL, MySQL) can be easily added in the future.

## Getting started
Features:

To make it easy for you to get started with GitLab, here's a list of recommended next steps.
- 🔗 Multi-database architecture (extensible design)
- 📈 InfluxDB 2.7 integration (tested and functional)
- ⚙️ Modular and configurable connection management
- 🧩 Easy integration with other STAMM components


| Database   | Version | Status       | Notes                                           |
| ---------- | ------- | -----------  | ----------------------------------------------- |
| InfluxDB   | 2.7     | ✅ Supported | Used for time-series data storage and retrieval |
| Postgresql (TimescaleDB) | 17/18      | 🚧 Ongoing work   | Check the folder PostgreSQL  |
