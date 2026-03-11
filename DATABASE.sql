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
ALTER TABLE IF EXISTS public.role_premission DROP CONSTRAINT IF EXISTS fk_role_permission_role_id;
ALTER TABLE IF EXISTS public.role_premission DROP CONSTRAINT IF EXISTS fk_role_permission_permission_id;
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
DROP TABLE IF EXISTS public.role_premission CASCADE;
DROP TABLE IF EXISTS public.laboratory_project CASCADE;
DROP TABLE IF EXISTS public.alerts CASCADE;

-- CREATE tables
CREATE TABLE public.users (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    full_name text NOT NULL,
    email text NOT NULL,
    password_hash text,
    external_provider text,
    external_id text,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT users_pkey PRIMARY KEY (id),
    CONSTRAINT users_email_key UNIQUE (email)
);

CREATE TABLE public.projects (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name text NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT now(),
    stamm_modules_id uuid,
    CONSTRAINT projects_pkey PRIMARY KEY (id)
);

CREATE TABLE public.equipments (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name text NOT NULL,
    description text,
    brand text,
    model text,
    version text,
    created_at timestamp without time zone DEFAULT now(),
    PRIMARY KEY (id)
);

CREATE TABLE public.experiments (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    project_id uuid,
    equipment_id uuid,
    name text NOT NULL,
    description text,
    initial_conditions jsonb,
    set_points jsonb,
    start_time timestamp with time zone,
    end_time timestamp with time zone,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT experiments_pkey PRIMARY KEY (id)
);

CREATE TABLE public.sensors (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name text NOT NULL,
    unit text,
    description text,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT sensors_pkey PRIMARY KEY (id)
);

CREATE TABLE public.actuators (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    name text NOT NULL,
    unit text,
    description text,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT actuators_pkey PRIMARY KEY (id)
);

CREATE TABLE public.sensor_readings (
    "time" timestamp with time zone NOT NULL,
    run_id uuid NOT NULL,
    sensor_id uuid NOT NULL,
    value double precision,
    PRIMARY KEY ("time", run_id, sensor_id)
);

CREATE TABLE public.actuator_states (
    "time" timestamp with time zone NOT NULL,
    run_id uuid NOT NULL,
    actuator_id uuid NOT NULL,
    value double precision,
    PRIMARY KEY ("time", run_id, actuator_id)
);

CREATE TABLE public.soft_sensors (
    id uuid NOT NULL DEFAULT uuid_generate_v4(),
    path_metadata text NOT NULL,
    path_model text NOT NULL,
    CONSTRAINT ml_models_pkey PRIMARY KEY (id),
    CONSTRAINT ml_models_name_version_key UNIQUE (path_metadata, path_model)
);

CREATE TABLE public.predictions (
    "time" timestamp with time zone NOT NULL,
    run_id uuid NOT NULL,
    soft_sensor_id uuid NOT NULL,
    value double precision,
    PRIMARY KEY ("time", run_id, soft_sensor_id)
);

CREATE TABLE public.run (
    id uuid DEFAULT uuid_generate_v4(),
    experiment_id uuid,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    PRIMARY KEY (id)
);

CREATE TABLE public.project_soft_sensors (
    id uuid DEFAULT uuid_generate_v4(),
    project_id uuid,
    soft_sensor_id uuid,
    PRIMARY KEY (id)
);

CREATE TABLE public.equipment_components (
    id uuid,
    actuator_id uuid,
    sensor_id uuid,
    equipment_id uuid,
    PRIMARY KEY (id)
);

CREATE TABLE public.soft_sensor_metrics (
    id uuid DEFAULT uuid_generate_v4(),
    metric_name text,
    metric_value double precision,
    description text,
    experiment_id uuid,
    soft_sensor_id uuid,
    PRIMARY KEY (id)
);

CREATE TABLE public.user_role (
    user_id uuid,
    role_id uuid,
    laboratory_id uuid
);

CREATE TABLE public.annotations (
    id uuid,
    user_id uuid,
    tag text,
    comment text,
    run_id uuid,
    PRIMARY KEY (id)
);

CREATE TABLE public.dynamic_model (
    id uuid DEFAULT uuid_generate_v4(),
    name text,
    version text,
    url_endpoint text,
    information json,
    model_registry_id uuid,
    PRIMARY KEY (id)
);

CREATE TABLE public.project_dynamic_models (
    id uuid DEFAULT uuid_generate_v4(),
    project_id uuid,
    dynamic_model_id uuid,
    PRIMARY KEY (id)
);

CREATE TABLE public.simulations (
    id uuid DEFAULT uuid_generate_v4(),
    value double precision,
    "time" date,
    dynamic_model_id uuid,
    PRIMARY KEY (id)
);

CREATE TABLE public.roles (
    id uuid DEFAULT uuid_generate_v4(),
    name text,
    PRIMARY KEY (id)
);

CREATE TABLE public.permissions (
    id uuid DEFAULT uuid_generate_v4(),
    name text,
    description text,
    PRIMARY KEY (id)
);

CREATE TABLE public.laboratories (
    id uuid DEFAULT uuid_generate_v4(),
    name text,
    location text,
    PRIMARY KEY (id)
);

CREATE TABLE public.role_premission (
    role_id uuid,
    permission_id uuid,
    PRIMARY KEY (role_id, permission_id)
);

CREATE TABLE public.laboratory_project (
    laboratory_id uuid,
    project_id uuid
);

CREATE TABLE public.alerts (
    id uuid DEFAULT uuid_generate_v4(),
    condition text,
    messege text,
    experiment_id uuid,
    PRIMARY KEY (id)
);

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

-- Foreign keys (NOT VALID)
ALTER TABLE public.experiments ADD CONSTRAINT "FK_experiments_equiment_id"
    FOREIGN KEY (equipment_id) REFERENCES public.equipments(id) NOT VALID;

ALTER TABLE public.experiments ADD CONSTRAINT "FK_experiments_project_id"
    FOREIGN KEY (project_id) REFERENCES public.projects(id) NOT VALID;

ALTER TABLE public.sensor_readings ADD CONSTRAINT "FK_sensor_reading_sensor_id"
    FOREIGN KEY (sensor_id) REFERENCES public.sensors(id) NOT VALID;

ALTER TABLE public.sensor_readings ADD CONSTRAINT "FK_sensor_reading_run_id"
    FOREIGN KEY (run_id) REFERENCES public.run(id) NOT VALID;

ALTER TABLE public.actuator_states ADD CONSTRAINT "FK_actuator_states_actuator_id"
    FOREIGN KEY (actuator_id) REFERENCES public.actuators(id) NOT VALID;

ALTER TABLE public.actuator_states ADD CONSTRAINT "FK_actuator_states_run_id"
    FOREIGN KEY (run_id) REFERENCES public.run(id) NOT VALID;

ALTER TABLE public.predictions ADD CONSTRAINT "FK_predictions_soft_sensor_id"
    FOREIGN KEY (soft_sensor_id) REFERENCES public.soft_sensors(id) NOT VALID;

ALTER TABLE public.predictions ADD CONSTRAINT "FK_predictions_run_id"
    FOREIGN KEY (run_id) REFERENCES public.run(id) NOT VALID;

ALTER TABLE public.run ADD CONSTRAINT "FK_run_experiment_id"
    FOREIGN KEY (experiment_id) REFERENCES public.experiments(id) NOT VALID;

ALTER TABLE public.project_soft_sensors ADD CONSTRAINT "FK_project_soft_sensors_project_id"
    FOREIGN KEY (project_id) REFERENCES public.projects(id) NOT VALID;

ALTER TABLE public.project_soft_sensors ADD CONSTRAINT "FK_project_soft_sensors_soft_sensor_id"
    FOREIGN KEY (soft_sensor_id) REFERENCES public.soft_sensors(id) NOT VALID;

ALTER TABLE public.equipment_components ADD CONSTRAINT sensor_id
    FOREIGN KEY (sensor_id) REFERENCES public.sensors(id) NOT VALID;

ALTER TABLE public.equipment_components ADD CONSTRAINT actuator_id
    FOREIGN KEY (actuator_id) REFERENCES public.actuators(id) NOT VALID;

ALTER TABLE public.equipment_components ADD CONSTRAINT equipment_id
    FOREIGN KEY (equipment_id) REFERENCES public.equipments(id) NOT VALID;

ALTER TABLE public.soft_sensor_metrics ADD CONSTRAINT experiment_id
    FOREIGN KEY (experiment_id) REFERENCES public.experiments(id) NOT VALID;

ALTER TABLE public.soft_sensor_metrics ADD CONSTRAINT soft_sensor_id
    FOREIGN KEY (soft_sensor_id) REFERENCES public.soft_sensors(id) NOT VALID;

ALTER TABLE public.user_role ADD CONSTRAINT "FK_user_role_user_id"
    FOREIGN KEY (user_id) REFERENCES public.users(id) NOT VALID;

ALTER TABLE public.user_role ADD CONSTRAINT "FK_user_role_role_id"
    FOREIGN KEY (role_id) REFERENCES public.roles(id) NOT VALID;

ALTER TABLE public.user_role ADD CONSTRAINT "FK_user_role_laboratory_id"
    FOREIGN KEY (laboratory_id) REFERENCES public.laboratories(id) NOT VALID;

ALTER TABLE public.annotations ADD CONSTRAINT run_id
    FOREIGN KEY (run_id) REFERENCES public.run(id) NOT VALID;

ALTER TABLE public.project_dynamic_models ADD CONSTRAINT "FK_project_dynamic_models_project_id"
    FOREIGN KEY (project_id) REFERENCES public.projects(id) NOT VALID;

ALTER TABLE public.project_dynamic_models ADD CONSTRAINT "FK_project_dynamic_models_dynamic_model_id"
    FOREIGN KEY (dynamic_model_id) REFERENCES public.dynamic_model(id) NOT VALID;

ALTER TABLE public.simulations ADD CONSTRAINT dynamic_model_id
    FOREIGN KEY (dynamic_model_id) REFERENCES public.dynamic_model(id) NOT VALID;

ALTER TABLE public.role_premission ADD CONSTRAINT fk_role_permission_role_id
    FOREIGN KEY (role_id) REFERENCES public.roles(id) NOT VALID;

ALTER TABLE public.role_premission ADD CONSTRAINT fk_role_permission_permission_id
    FOREIGN KEY (permission_id) REFERENCES public.permissions(id) NOT VALID;

ALTER TABLE public.laboratory_project ADD CONSTRAINT "FK_laboratory_project_laboratory_id"
    FOREIGN KEY (laboratory_id) REFERENCES public.laboratories(id) NOT VALID;

ALTER TABLE public.laboratory_project ADD CONSTRAINT "FK_laboratory_project_project_id"
    FOREIGN KEY (project_id) REFERENCES public.projects(id) NOT VALID;

ALTER TABLE public.alerts ADD CONSTRAINT "FK_alerts_experiment_id"
    FOREIGN KEY (experiment_id) REFERENCES public.experiments(id) NOT VALID;

END;