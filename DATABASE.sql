BEGIN;

-- DROP constraints (si existen)
ALTER TABLE IF EXISTS public.experiments DROP CONSTRAINT IF EXISTS "FK_experiments_equiment_id";
ALTER TABLE IF EXISTS public.experiments DROP CONSTRAINT IF EXISTS "FK_experiments_project_id";
ALTER TABLE IF EXISTS public.sensor_readings DROP CONSTRAINT IF EXISTS "FK_sensor_reading_sensor_id";
ALTER TABLE IF EXISTS public.sensor_readings DROP CONSTRAINT IF EXISTS "FK_sensor_reading_run_id";
ALTER TABLE IF EXISTS public.actuator_states DROP CONSTRAINT IF EXISTS "FK_actuator_states_actuator_id";
ALTER TABLE IF EXISTS public.actuator_states DROP CONSTRAINT IF EXISTS "FK_actuator_states_run_id";
ALTER TABLE IF EXISTS public.predictions DROP CONSTRAINT IF EXISTS "FK_predictions_soft_sensor_id";
ALTER TABLE IF EXISTS public.predictions DROP CONSTRAINT IF EXISTS "FK_predictions_run_id";
ALTER TABLE IF EXISTS public.run DROP CONSTRAINT IF EXISTS "FK_run_experiment_id";
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
DROP TABLE IF EXISTS public.run CASCADE;
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

-- CREATE tables
CREATE TABLE IF NOT EXISTS public.equipment_components
(
    id uuid NOT NULL,
    actuator_id uuid,
    sensor_id uuid,
    equipment_id uuid,
    CONSTRAINT equipment_components_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.actuators
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name text COLLATE pg_catalog."default" NOT NULL,
    unit text COLLATE pg_catalog."default",
    description text COLLATE pg_catalog."default",
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT actuators_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.actuator_states
(
    "time" timestamp with time zone NOT NULL,
    run_id uuid NOT NULL,
    actuator_id uuid NOT NULL,
    value double precision,
    CONSTRAINT actuator_states_pkey PRIMARY KEY ("time", run_id, actuator_id)
);

CREATE TABLE IF NOT EXISTS public.run
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    experiment_id uuid,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    CONSTRAINT run_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.experiments
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    project_id uuid,
    name text COLLATE pg_catalog."default" NOT NULL,
    description text COLLATE pg_catalog."default",
    initial_conditions jsonb,
    set_points jsonb,
    start_time timestamp with time zone,
    end_time timestamp with time zone,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT experiments_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.equipments
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name text COLLATE pg_catalog."default" NOT NULL,
    description text COLLATE pg_catalog."default",
    brand text COLLATE pg_catalog."default",
    model text COLLATE pg_catalog."default",
    version text COLLATE pg_catalog."default",
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT equipments_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.projects
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name text COLLATE pg_catalog."default" NOT NULL,
    description text COLLATE pg_catalog."default",
    created_at timestamp without time zone DEFAULT now(),
    stamm_modules_id uuid,
    CONSTRAINT projects_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.project_soft_sensors
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    project_id uuid,
    soft_sensor_id uuid,
    CONSTRAINT project_soft_sensors_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.soft_sensors
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    path_metadata text COLLATE pg_catalog."default" NOT NULL,
    path_model text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT ml_models_pkey PRIMARY KEY (id),
    CONSTRAINT ml_models_name_version_key UNIQUE (path_metadata, path_model)
);

CREATE TABLE IF NOT EXISTS public.predictions
(
    "time" timestamp with time zone NOT NULL,
    run_id uuid NOT NULL,
    soft_sensor_id uuid NOT NULL,
    value double precision,
    CONSTRAINT predictions_pkey PRIMARY KEY ("time", run_id, soft_sensor_id)
);

CREATE TABLE IF NOT EXISTS public.soft_sensor_metrics
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    metric_name text COLLATE pg_catalog."default",
    metric_value double precision,
    description text COLLATE pg_catalog."default",
    experiment_id uuid,
    soft_sensor_id uuid,
    CONSTRAINT soft_sensor_metrics_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.project_dynamic_models
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    project_id uuid,
    dynamic_model_id uuid,
    CONSTRAINT project_dynamic_models_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.dynamic_model
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name text COLLATE pg_catalog."default",
    version text COLLATE pg_catalog."default",
    url_endpoint text COLLATE pg_catalog."default",
    information json,
    model_registry_id uuid,
    CONSTRAINT dynamic_model_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.simulations
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    value double precision,
    "time" date,
    dynamic_model_id uuid,
    CONSTRAINT simulations_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.laboratory_project
(
    laboratory_id uuid,
    project_id uuid
);

CREATE TABLE IF NOT EXISTS public.laboratories
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name text COLLATE pg_catalog."default",
    location text COLLATE pg_catalog."default",
    CONSTRAINT laboratories_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.user_role
(
    user_id uuid,
    role_id uuid,
    laboratory_id uuid,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id uuid NOT NULL,
    CONSTRAINT user_role_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.roles
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name text COLLATE pg_catalog."default",
    description text COLLATE pg_catalog."default",
    CONSTRAINT roles_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.role_permission
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    role_id uuid NOT NULL,
    permission_id uuid NOT NULL,
    CONSTRAINT role_permission_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.permissions
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name text COLLATE pg_catalog."default",
    description text COLLATE pg_catalog."default",
    CONSTRAINT permissions_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.users
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    full_name text COLLATE pg_catalog."default" NOT NULL,
    email text COLLATE pg_catalog."default" NOT NULL,
    password_hash text COLLATE pg_catalog."default",
    external_provider text COLLATE pg_catalog."default",
    external_id text COLLATE pg_catalog."default",
    created_at timestamp without time zone DEFAULT now(),
    is_active boolean,
    CONSTRAINT users_pkey PRIMARY KEY (id),
    CONSTRAINT users_email_key UNIQUE (email)
);

CREATE TABLE IF NOT EXISTS public.alerts
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    condition text COLLATE pg_catalog."default",
    messege text COLLATE pg_catalog."default",
    experiment_id uuid,
    CONSTRAINT alerts_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.sensor_readings
(
    "time" timestamp with time zone NOT NULL,
    run_id uuid NOT NULL,
    sensor_id uuid NOT NULL,
    value double precision,
    CONSTRAINT sensor_readings_pkey PRIMARY KEY ("time", run_id, sensor_id)
);

CREATE TABLE IF NOT EXISTS public.sensors
(
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name text COLLATE pg_catalog."default" NOT NULL,
    unit text COLLATE pg_catalog."default",
    description text COLLATE pg_catalog."default",
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT sensors_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.annotations
(
    id uuid NOT NULL,
    user_id uuid,
    tag text COLLATE pg_catalog."default",
    comment text COLLATE pg_catalog."default",
    run_id uuid,
    CONSTRAINT annotations_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS _timescaledb_cache.experoments_equipaments
(
    id uuid DEFAULT uuid_gene,
    experiment_id uuid NOT NULL,
    equipament_id uuid NOT NULL,
    PRIMARY KEY (id, experiment_id, equipament_id)
);

CREATE TABLE IF NOT EXISTS public.experiments_equipaments
(
    id uuid DEFAULT uuid_generate_v4(),
    experiment_id uuid NOT NULL,
    equipament_id uuid NOT NULL,
    PRIMARY KEY (id, experiment_id, equipament_id)
);

ALTER TABLE IF EXISTS public.equipment_components
    ADD CONSTRAINT actuator_id FOREIGN KEY (actuator_id)
    REFERENCES public.actuators (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.equipment_components
    ADD CONSTRAINT equipment_id FOREIGN KEY (equipment_id)
    REFERENCES public.equipments (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.equipment_components
    ADD CONSTRAINT sensor_id FOREIGN KEY (sensor_id)
    REFERENCES public.sensors (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.actuator_states
    ADD CONSTRAINT "FK_actuator_states_actuator_id" FOREIGN KEY (actuator_id)
    REFERENCES public.actuators (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.actuator_states
    ADD CONSTRAINT "FK_actuator_states_run_id" FOREIGN KEY (run_id)
    REFERENCES public.run (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.run
    ADD CONSTRAINT "FK_run_experiment_id" FOREIGN KEY (experiment_id)
    REFERENCES public.experiments (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.experiments
    ADD CONSTRAINT "FK_experiments_project_id" FOREIGN KEY (project_id)
    REFERENCES public.projects (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.project_soft_sensors
    ADD CONSTRAINT "FK_project_soft_sensors_project_id" FOREIGN KEY (project_id)
    REFERENCES public.projects (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.project_soft_sensors
    ADD CONSTRAINT "FK_project_soft_sensors_soft_sensor_id" FOREIGN KEY (soft_sensor_id)
    REFERENCES public.soft_sensors (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.predictions
    ADD CONSTRAINT "FK_predictions_run_id" FOREIGN KEY (run_id)
    REFERENCES public.run (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.predictions
    ADD CONSTRAINT "FK_predictions_soft_sensor_id" FOREIGN KEY (soft_sensor_id)
    REFERENCES public.soft_sensors (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.soft_sensor_metrics
    ADD CONSTRAINT experiment_id FOREIGN KEY (experiment_id)
    REFERENCES public.experiments (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.soft_sensor_metrics
    ADD CONSTRAINT soft_sensor_id FOREIGN KEY (soft_sensor_id)
    REFERENCES public.soft_sensors (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.project_dynamic_models
    ADD CONSTRAINT "FK_project_dynamic_models_dynamic_model_id" FOREIGN KEY (dynamic_model_id)
    REFERENCES public.dynamic_model (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.project_dynamic_models
    ADD CONSTRAINT "FK_project_dynamic_models_project_id" FOREIGN KEY (project_id)
    REFERENCES public.projects (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.simulations
    ADD CONSTRAINT dynamic_model_id FOREIGN KEY (dynamic_model_id)
    REFERENCES public.dynamic_model (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.laboratory_project
    ADD CONSTRAINT "FK_laboratory_project_laboratory_id" FOREIGN KEY (laboratory_id)
    REFERENCES public.laboratories (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.laboratory_project
    ADD CONSTRAINT "FK_laboratory_project_project_id" FOREIGN KEY (project_id)
    REFERENCES public.projects (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.user_role
    ADD CONSTRAINT "FK_user_role_laboratory_id" FOREIGN KEY (laboratory_id)
    REFERENCES public.laboratories (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.user_role
    ADD CONSTRAINT "FK_user_role_role_id" FOREIGN KEY (role_id)
    REFERENCES public.roles (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.user_role
    ADD CONSTRAINT "FK_user_role_user_id" FOREIGN KEY (user_id)
    REFERENCES public.users (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.role_permission
    ADD CONSTRAINT "FK_role_permission_premission_id" FOREIGN KEY (permission_id)
    REFERENCES public.permissions (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.role_permission
    ADD CONSTRAINT "FK_role_permission_role_id" FOREIGN KEY (role_id)
    REFERENCES public.roles (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.alerts
    ADD CONSTRAINT "FK_alerts_experiment_id" FOREIGN KEY (experiment_id)
    REFERENCES public.experiments (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.sensor_readings
    ADD CONSTRAINT "FK_sensor_reading_run_id" FOREIGN KEY (run_id)
    REFERENCES public.run (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.sensor_readings
    ADD CONSTRAINT "FK_sensor_reading_sensor_id" FOREIGN KEY (sensor_id)
    REFERENCES public.sensors (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.annotations
    ADD CONSTRAINT run_id FOREIGN KEY (run_id)
    REFERENCES public.run (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS _timescaledb_cache.experoments_equipaments
    ADD CONSTRAINT "FK_experiments_equipaments_experiments_id" FOREIGN KEY (id_experiment, experiment_id)
    REFERENCES public.experiments (id, id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS _timescaledb_cache.experoments_equipaments
    ADD CONSTRAINT "FK_experiments_equipaments_equipament_id" FOREIGN KEY (equipament_id)
    REFERENCES public.equipments (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.experiments_equipaments
    ADD CONSTRAINT "FK_experiments_equipaments_experiments_id" FOREIGN KEY (experiment_id)
    REFERENCES public.experiments (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS public.experiments_equipaments
    ADD CONSTRAINT "FK_experiments_equipaments_equipaments_id" FOREIGN KEY (equipament_id)
    REFERENCES public.equipments (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


-- Convertir en hypertables
SELECT create_hypertable('sensor_readings', 'time');
SELECT create_hypertable('actuator_states', 'time');
SELECT create_hypertable('predictions', 'time');

-- Índices para hypertables
CREATE INDEX IF NOT EXISTS idx_sensor_readings_sensor_time
    ON sensor_readings(sensor_id, time DESC);
CREATE INDEX IF NOT EXISTS idx_sensor_readings_run_time
    ON sensor_readings(run_id, time DESC);

CREATE INDEX IF NOT EXISTS idx_actuator_states_actuator_time
    ON actuator_states(actuator_id, time DESC);
CREATE INDEX IF NOT EXISTS idx_actuator_states_run_time
    ON actuator_states(run_id, time DESC);

CREATE INDEX IF NOT EXISTS idx_predictions_soft_sensor_time
    ON predictions(soft_sensor_id, time DESC);
CREATE INDEX IF NOT EXISTS idx_predictions_run_time
    ON predictions(run_id, time DESC);


END;