BEGIN;

DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;

SET search_path TO public;

GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;

-- Extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS timescaledb;

-- DROP constraints
ALTER TABLE IF EXISTS public.experiments DROP CONSTRAINT IF EXISTS "FK_experiments_equiment_id";
ALTER TABLE IF EXISTS public.experiments DROP CONSTRAINT IF EXISTS "FK_experiments_project_id";
ALTER TABLE IF EXISTS public.sensor_readings DROP CONSTRAINT IF EXISTS "FK_sensor_reading_sensor_id";
ALTER TABLE IF EXISTS public.sensor_readings DROP CONSTRAINT IF EXISTS "FK_sensor_reading_run_id";
ALTER TABLE IF EXISTS public.actuator_states DROP CONSTRAINT IF EXISTS "FK_actuator_states_actuator_id";
ALTER TABLE IF EXISTS public.actuator_states DROP CONSTRAINT IF EXISTS "FK_actuator_states_run_id";
ALTER TABLE IF EXISTS public.predictions DROP CONSTRAINT IF EXISTS "FK_predictions_soft_sensor_id";
ALTER TABLE IF EXISTS public.predictions DROP CONSTRAINT IF EXISTS "FK_predictions_run_id";
ALTER TABLE IF EXISTS public.runs DROP CONSTRAINT IF EXISTS "FK_run_experiment_id";
ALTER TABLE IF EXISTS public.project_soft_sensors DROP CONSTRAINT IF EXISTS "FK_project_soft_sensors_project_id";
ALTER TABLE IF EXISTS public.project_soft_sensors DROP CONSTRAINT IF EXISTS "FK_project_soft_sensors_soft_sensor_id";
ALTER TABLE IF EXISTS public.equipment_components DROP CONSTRAINT IF EXISTS sensor_id;
ALTER TABLE IF EXISTS public.equipment_components DROP CONSTRAINT IF EXISTS actuator_id;
ALTER TABLE IF EXISTS public.equipment_components DROP CONSTRAINT IF EXISTS equipment_id;
ALTER TABLE IF EXISTS public.soft_sensor_metrics DROP CONSTRAINT IF EXISTS experiment_id;
ALTER TABLE IF EXISTS public.soft_sensor_metrics DROP CONSTRAINT IF EXISTS soft_sensor_id;
ALTER TABLE IF EXISTS public.user_role DROP CONSTRAINT IF EXISTS "FK_user_role_user_id";
ALTER TABLE IF EXISTS public.user_role DROP CONSTRAINT IF EXISTS "FK_user_role_role_id";
ALTER TABLE IF EXISTS public.user_role DROP CONSTRAINT IF EXISTS "FK_user_role_laboratory_id";
ALTER TABLE IF EXISTS public.annotations DROP CONSTRAINT IF EXISTS run_id;
ALTER TABLE IF EXISTS public.project_dynamic_models DROP CONSTRAINT IF EXISTS "FK_project_dynamic_models_project_id";
ALTER TABLE IF EXISTS public.project_dynamic_models DROP CONSTRAINT IF EXISTS "FK_project_dynamic_models_dynamic_model_id";
ALTER TABLE IF EXISTS public.simulations DROP CONSTRAINT IF EXISTS dynamic_model_id;
ALTER TABLE IF EXISTS public.role_permission DROP CONSTRAINT IF EXISTS fk_role_permission_role_id;
ALTER TABLE IF EXISTS public.role_permission DROP CONSTRAINT IF EXISTS fk_role_permission_permission_id;
ALTER TABLE IF EXISTS public.laboratory_project DROP CONSTRAINT IF EXISTS "FK_laboratory_project_laboratory_id";
ALTER TABLE IF EXISTS public.laboratory_project DROP CONSTRAINT IF EXISTS "FK_laboratory_project_project_id";
ALTER TABLE IF EXISTS public.alerts DROP CONSTRAINT IF EXISTS "FK_alerts_experiment_id";

-- DROP tables
DROP TABLE IF EXISTS public.users CASCADE;
DROP TABLE IF EXISTS public.projects CASCADE;
DROP TABLE IF EXISTS public.equipments CASCADE;
DROP TABLE IF EXISTS public.experiments CASCADE;
DROP TABLE IF EXISTS public.sensors CASCADE;
DROP TABLE IF EXISTS public.actuators CASCADE;
DROP TABLE IF EXISTS public.sensor_readings CASCADE;
DROP TABLE IF EXISTS public.actuator_states CASCADE;
DROP TABLE IF EXISTS public.soft_sensors CASCADE;
DROP TABLE IF EXISTS public.predictions CASCADE;
DROP TABLE IF EXISTS public.runs CASCADE;
DROP TABLE IF EXISTS public.project_soft_sensors CASCADE;
DROP TABLE IF EXISTS public.equipment_components CASCADE;
DROP TABLE IF EXISTS public.soft_sensor_metrics CASCADE;
DROP TABLE IF EXISTS public.user_role CASCADE;
DROP TABLE IF EXISTS public.annotations CASCADE;
DROP TABLE IF EXISTS public.dynamic_model CASCADE;
DROP TABLE IF EXISTS public.project_dynamic_models CASCADE;
DROP TABLE IF EXISTS public.simulations CASCADE;
DROP TABLE IF EXISTS public.roles CASCADE;
DROP TABLE IF EXISTS public.permissions CASCADE;
DROP TABLE IF EXISTS public.laboratories CASCADE;
DROP TABLE IF EXISTS public.role_permission CASCADE;
DROP TABLE IF EXISTS public.laboratory_project CASCADE;
DROP TABLE IF EXISTS public.alerts CASCADE;
DROP TABLE IF EXISTS public.experiments_equipments CASCADE;

-- CREATE tables and constraints

CREATE TABLE IF NOT EXISTS public.equipment_components
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    actuator_id uuid NOT NULL,
    sensor_id uuid NOT NULL,
    equipment_id uuid NOT NULL,
    CONSTRAINT equipment_components_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.actuators
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name text NOT NULL,
    unit text,
    description text,
    created_at timestamp DEFAULT now(),
    CONSTRAINT actuators_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.actuator_states
(
    "time" timestamptz NOT NULL,
    run_id uuid NOT NULL,
    actuator_id uuid NOT NULL,
    value double precision,
    CONSTRAINT actuator_states_pkey PRIMARY KEY ("time", run_id, actuator_id)
);

CREATE TABLE IF NOT EXISTS public.runs
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    experiment_id uuid NOT NULL,
    start_time timestamp,
    end_time timestamp,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.experiments
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    project_id uuid NOT NULL,
    name text NOT NULL,
    description text,
    initial_conditions jsonb,
    set_points jsonb,
    start_time timestamptz,
    end_time timestamptz,
    created_at timestamp DEFAULT now(),
    CONSTRAINT experiments_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.equipments
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name text NOT NULL,
    description text,
    brand text,
    model text,
    version text,
    created_at timestamp DEFAULT now(),
    CONSTRAINT equipments_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.projects
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name text NOT NULL,
    description text,
    created_at timestamp DEFAULT now(),
    stamm_modules_id uuid,
    CONSTRAINT projects_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.project_soft_sensors
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    project_id uuid NOT NULL,
    soft_sensor_id uuid NOT NULL,
    CONSTRAINT project_soft_sensors_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.soft_sensors
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    path_metadata text NOT NULL,
    path_model text NOT NULL,
    CONSTRAINT ml_soft_pkey PRIMARY KEY (id),
    CONSTRAINT ml_models_name_version_key UNIQUE (path_metadata, path_model)
);

CREATE TABLE IF NOT EXISTS public.predictions
(
    "time" timestamptz NOT NULL,
    run_id uuid NOT NULL,
    soft_sensor_id uuid NOT NULL,
    value double precision,
    CONSTRAINT predictions_pkey PRIMARY KEY ("time", run_id, soft_sensor_id)
);

CREATE TABLE IF NOT EXISTS public.soft_sensor_metrics
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    metric_name text,
    metric_value double precision,
    description text,
    experiment_id uuid NOT NULL,
    soft_sensor_id uuid NOT NULL,
    CONSTRAINT soft_sensor_metrics_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.project_dynamic_models
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    project_id uuid NOT NULL,
    dynamic_model_id uuid NOT NULL,
    CONSTRAINT project_dynamic_models_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.dynamic_model
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name text,
    version text,
    url_endpoint text,
    information json,
    model_registry_id uuid,
    CONSTRAINT dynamic_model_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.simulations
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    value double precision,
    "time" date,
    dynamic_model_id uuid NOT NULL,
    CONSTRAINT simulations_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.laboratory_project
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    laboratory_id uuid NOT NULL,
    project_id uuid NOT NULL,
    CONSTRAINT laboratory_project_pkey PRIMARY KEY (id),
    CONSTRAINT uq_laboratory_project UNIQUE (laboratory_id, project_id)
);

CREATE TABLE IF NOT EXISTS public.laboratories
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name text NOT NULL UNIQUE,
    location text,
    CONSTRAINT laboratories_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.user_role
(
    user_id uuid NOT NULL,
    role_id uuid NOT NULL,
    laboratory_id uuid NOT NULL,
    created_at timestamp,
    updated_at timestamp,
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    CONSTRAINT user_role_pkey PRIMARY KEY (id),
    CONSTRAINT uq_user_role UNIQUE (user_id, role_id, laboratory_id)
);

CREATE TABLE IF NOT EXISTS public.roles
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name text NOT NULL UNIQUE,
    description text,
    CONSTRAINT roles_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.role_permission
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    role_id uuid NOT NULL,
    permission_id uuid NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT uq_role_permission UNIQUE (role_id, permission_id)
);

CREATE TABLE IF NOT EXISTS public.permissions
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name text NOT NULL UNIQUE,
    description text,
    CONSTRAINT permissions_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.users
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    full_name text NOT NULL,
    email text NOT NULL,
    password_hash text,
    external_provider text,
    external_id text,
    created_at timestamp DEFAULT now(),
    is_active boolean DEFAULT true,
    CONSTRAINT users_pkey PRIMARY KEY (id),
    CONSTRAINT users_email_key UNIQUE (email)
);

CREATE TABLE IF NOT EXISTS public.alerts
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    condition text,
    message text,
    experiment_id uuid NOT NULL,
    CONSTRAINT alerts_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.sensor_readings
(
    "time" timestamptz NOT NULL,
    run_id uuid NOT NULL,
    sensor_id uuid NOT NULL,
    value double precision,
    CONSTRAINT sensor_readings_pkey PRIMARY KEY ("time", run_id, sensor_id)
);

CREATE TABLE IF NOT EXISTS public.sensors
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name text NOT NULL,
    unit text,
    description text,
    created_at timestamp DEFAULT now(),
    CONSTRAINT sensors_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.annotations
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    user_id uuid NOT NULL,
    tag text,
    comment text,
    run_id uuid NOT NULL,
    CONSTRAINT annotations_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.experiments_equipments
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    experiment_id uuid NOT NULL,
    equipment_id uuid NOT NULL,
    CONSTRAINT experiments_equipments_pkey PRIMARY KEY (id),
    CONSTRAINT uq_experiments_equipments UNIQUE (experiment_id, equipment_id)
);

CREATE TABLE IF NOT EXISTS public.organizations
(
    id uuid DEFAULT uuid_generate_v4(),
    name text NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    location text,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.departments
(
    id uuid DEFAULT uuid_generate_v4(),
    name text NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.organizations_departments
(
    id uuid DEFAULT uuid_generate_v4(),
    organization_id uuid,
    department_id uuid,
    PRIMARY KEY (id)
    UNIQUE (organization_id, department_id)
);

CREATE TABLE IF NOT EXISTS public.departments_users
(
    id uuid DEFAULT uuid_generate_v4(),
    department_id uuid,
    user_id uuid,
    PRIMARY KEY (id, department_id, user_id)
);


-- equipment_components
ALTER TABLE public.equipment_components
    ADD CONSTRAINT fk_equipment_components_actuator
    FOREIGN KEY (actuator_id) REFERENCES public.actuators (id) ON DELETE CASCADE;

ALTER TABLE public.equipment_components
    ADD CONSTRAINT fk_equipment_components_sensor
    FOREIGN KEY (sensor_id) REFERENCES public.sensors (id) ON DELETE CASCADE;

ALTER TABLE public.equipment_components
    ADD CONSTRAINT fk_equipment_components_equipment
    FOREIGN KEY (equipment_id) REFERENCES public.equipments (id) ON DELETE CASCADE;


-- actuator_states
ALTER TABLE public.actuator_states
    ADD CONSTRAINT fk_actuator_states_actuator
    FOREIGN KEY (actuator_id) REFERENCES public.actuators (id) ON DELETE CASCADE;

ALTER TABLE public.actuator_states
    ADD CONSTRAINT fk_actuator_states_run
    FOREIGN KEY (run_id) REFERENCES public.runs (id) ON DELETE CASCADE;


-- runs
ALTER TABLE public.runs
    ADD CONSTRAINT fk_run_experiment
    FOREIGN KEY (experiment_id) REFERENCES public.experiments (id) ON DELETE CASCADE;


-- experiments
ALTER TABLE public.experiments
    ADD CONSTRAINT fk_experiments_project
    FOREIGN KEY (project_id) REFERENCES public.projects (id) ON DELETE CASCADE;


-- project_soft_sensors
ALTER TABLE public.project_soft_sensors
    ADD CONSTRAINT fk_pss_project
    FOREIGN KEY (project_id) REFERENCES public.projects (id) ON DELETE CASCADE;

ALTER TABLE public.project_soft_sensors
    ADD CONSTRAINT fk_pss_soft_sensor
    FOREIGN KEY (soft_sensor_id) REFERENCES public.soft_sensors (id) ON DELETE CASCADE;


-- predictions
ALTER TABLE public.predictions
    ADD CONSTRAINT fk_predictions_run
    FOREIGN KEY (run_id) REFERENCES public.runs (id) ON DELETE CASCADE;

ALTER TABLE public.predictions
    ADD CONSTRAINT fk_predictions_soft_sensor
    FOREIGN KEY (soft_sensor_id) REFERENCES public.soft_sensors (id) ON DELETE CASCADE;


-- soft_sensor_metrics
ALTER TABLE public.soft_sensor_metrics
    ADD CONSTRAINT fk_ssm_experiment
    FOREIGN KEY (experiment_id) REFERENCES public.experiments (id) ON DELETE CASCADE;

ALTER TABLE public.soft_sensor_metrics
    ADD CONSTRAINT fk_ssm_soft_sensor
    FOREIGN KEY (soft_sensor_id) REFERENCES public.soft_sensors (id) ON DELETE CASCADE;


-- project_dynamic_models
ALTER TABLE public.project_dynamic_models
    ADD CONSTRAINT fk_pdm_project
    FOREIGN KEY (project_id) REFERENCES public.projects (id) ON DELETE CASCADE;

ALTER TABLE public.project_dynamic_models
    ADD CONSTRAINT fk_pdm_dynamic_model
    FOREIGN KEY (dynamic_model_id) REFERENCES public.dynamic_model (id) ON DELETE CASCADE;


-- simulations
ALTER TABLE public.simulations
    ADD CONSTRAINT fk_simulations_dynamic_model
    FOREIGN KEY (dynamic_model_id) REFERENCES public.dynamic_model (id) ON DELETE CASCADE;


-- laboratory_project
ALTER TABLE public.laboratory_project
    ADD CONSTRAINT fk_lp_laboratory
    FOREIGN KEY (laboratory_id) REFERENCES public.laboratories (id) ON DELETE CASCADE;

ALTER TABLE public.laboratory_project
    ADD CONSTRAINT fk_lp_project
    FOREIGN KEY (project_id) REFERENCES public.projects (id) ON DELETE CASCADE;


-- user_role
ALTER TABLE public.user_role
    ADD CONSTRAINT fk_user_role_user
    FOREIGN KEY (user_id) REFERENCES public.users (id) ON DELETE CASCADE;

ALTER TABLE public.user_role
    ADD CONSTRAINT fk_user_role_role
    FOREIGN KEY (role_id) REFERENCES public.roles (id) ON DELETE CASCADE;

ALTER TABLE public.user_role
    ADD CONSTRAINT fk_user_role_laboratory
    FOREIGN KEY (laboratory_id) REFERENCES public.laboratories (id) ON DELETE CASCADE;


-- role_permission
ALTER TABLE public.role_permission
    ADD CONSTRAINT fk_role_permission_role
    FOREIGN KEY (role_id) REFERENCES public.roles (id) ON DELETE CASCADE;

ALTER TABLE public.role_permission
    ADD CONSTRAINT fk_role_permission_permission
    FOREIGN KEY (permission_id) REFERENCES public.permissions (id) ON DELETE CASCADE;


-- alerts
ALTER TABLE public.alerts
    ADD CONSTRAINT fk_alerts_experiment
    FOREIGN KEY (experiment_id) REFERENCES public.experiments (id) ON DELETE CASCADE;


-- sensor_readings
ALTER TABLE public.sensor_readings
    ADD CONSTRAINT fk_sensor_readings_run
    FOREIGN KEY (run_id) REFERENCES public.runs (id) ON DELETE CASCADE;

ALTER TABLE public.sensor_readings
    ADD CONSTRAINT fk_sensor_readings_sensor
    FOREIGN KEY (sensor_id) REFERENCES public.sensors (id) ON DELETE CASCADE;


-- annotations
ALTER TABLE public.annotations
    ADD CONSTRAINT fk_annotations_run
    FOREIGN KEY (run_id) REFERENCES public.runs (id) ON DELETE CASCADE;

-- users
ALTER TABLE public.annotations
    ADD CONSTRAINT fk_annotations_user
    FOREIGN KEY (user_id) REFERENCES public.users (id) ON DELETE CASCADE;

-- experiments_equipments
ALTER TABLE public.experiments_equipments
    ADD CONSTRAINT fk_exp_eq_experiment
    FOREIGN KEY (experiment_id) REFERENCES public.experiments (id) ON DELETE CASCADE;

ALTER TABLE public.experiments_equipments
    ADD CONSTRAINT fk_exp_eq_equipment
    FOREIGN KEY (equipment_id) REFERENCES public.equipments (id) ON DELETE CASCADE;

ALTER TABLE IF EXISTS public.organizations_departments
    ADD CONSTRAINT "FK_organizations_departments_id_organizations" 
    FOREIGN KEY (organization_id) REFERENCES public.organizations (id) ON DELETE CASCADE;

ALTER TABLE IF EXISTS public.organizations_departments
    ADD CONSTRAINT "FK_organizations_departments_id_departments" 
    FOREIGN KEY (department_id) REFERENCES public.departments (id) ON DELETE CASCADE;

ALTER TABLE IF EXISTS public.departments_users
    ADD CONSTRAINT "FK_departments_users_id_department" 
    FOREIGN KEY (department_id) REFERENCES public.departments (id) ON DELETE CASCADE;

ALTER TABLE IF EXISTS public.departments_users
    ADD CONSTRAINT "FK_departments_users_id_user"
    FOREIGN KEY (user_id) REFERENCES public.users (id) ON DELETE CASCADE;

-- Hypertables
SELECT public.create_hypertable('sensor_readings', 'time', if_not_exists => TRUE);
SELECT public.create_hypertable('actuator_states', 'time', if_not_exists => TRUE);
SELECT public.create_hypertable('predictions', 'time', if_not_exists => TRUE);

CREATE INDEX idx_sensor_readings_run_time_sensor 
ON public.sensor_readings(run_id, time DESC, sensor_id);

CREATE INDEX idx_actuator_states_run_time_actuator 
ON public.actuator_states(run_id, time DESC, actuator_id);

CREATE INDEX idx_predictions_run_time_model 
ON public.predictions(run_id, time DESC, soft_sensor_id);

END;