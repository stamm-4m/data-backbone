-- Resources table data added 2026-04-24
INSERT INTO public.resources (id, name) VALUES ('10000000-0000-0000-0000-000000000001', 'Organization');
INSERT INTO public.resources (id, name) VALUES ('20000000-0000-0000-0000-000000000002', 'Department');
INSERT INTO public.resources (id, name) VALUES ('30000000-0000-0000-0000-000000000003', 'Laboratory');
INSERT INTO public.resources (id, name) VALUES ('40000000-0000-0000-0000-000000000004', 'Project');
INSERT INTO public.resources (id, name) VALUES ('50000000-0000-0000-0000-000000000005', 'Experiment');
INSERT INTO public.resources (id, name) VALUES ('60000000-0000-0000-0000-000000000006', 'Model');
INSERT INTO public.resources (id, name) VALUES ('70000000-0000-0000-0000-000000000007', 'User');
--
-- PostgreSQL database dump
--

\restrict Isa7fq2AXa7HNlcQ2ONMpuADMH9i5QffGsvqTCoxUXynIeRpcj5YbSwfVJGwesd

-- Dumped from database version 18.3 (Ubuntu 18.3-1.pgdg22.04+1)
-- Dumped by pg_dump version 18.1

-- Started on 2026-04-10 17:53:25

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4068 (class 0 OID 19933)
-- Dependencies: 300
-- Data for Name: actuators; Type: TABLE DATA; Schema: public; Owner: stamm
--



--
-- TOC entry 4065 (class 0 OID 19900)
-- Dependencies: 297
-- Data for Name: equipments; Type: TABLE DATA; Schema: public; Owner: stamm
--



--
-- TOC entry 4064 (class 0 OID 19889)
-- Dependencies: 296
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: stamm
--

INSERT INTO public.projects (id, name, description, created_at, stamm_modules_id, project_id) VALUES ('56d5fec2-b1bb-442d-99b1-b1aba59206cf', 'IndPenSim', 'The dataset used in this work corresponds to a series of experiments that were subsequently utilized to produce a simulation of industrial- scale penicillin fermentation processes (Paul and Thomas, 1996) which describes all the component balances relating to the process variables (Goldrick et al., 2015, 2019). The dataset generated from the industrial-scale penicillin fermentation (IndPenSim) includes 100 batches with each dataset comprising 2238 variables of which 39 variables correspond to process variables (manual and automatic control and online and offline measurements) and the remaining 2199 spond to Raman spectra. Per batch sensors recorded data every 12 min with the average batch length being approximately 230 h. Out of the 100 batches, the first 90 batches were operated under “normal” conditions using three different control strategies: (I) controlled by a recipe driven approach; (II) controlled by an operator and (III) controlled by an Advanced Process Control (APC). The last 10 batches contains faults, resulting in process deviations (Goldrick et al., 2019).', '2026-03-26 00:07:38.933245', NULL, 'P0001');
INSERT INTO public.projects (id, name, description, created_at, stamm_modules_id, project_id) VALUES ('4b6b2911-bddd-4f02-b7f3-64920350e975', 'Bioindustry_E.Coli', 'Soft-sensing project for recombinant nanobody production in Escherichia coli (strains WK6: CH10-12 and NbF12-10), using experimental data from 7 fed-batch runs carried out in 5 L bioreactors (Sartorius) with 2 L working volume. Online variables were monitored with MFCS BioPAT (sampling every 5 s) and off-gas was analyzed with an INNOVA 1313 gas analyzer (every 5 min). Offline biomass measurements are used as ground-truth to train/validate soft sensors. For the first stage of this project, we focus only on biomass estimation using 10 online variables (temperature, pH, pO2, pressure, agitation, glucose feed setup, substrate weight, base weight, ACIT, O2 Gas out). Data source: IBISBA Knowledge Hub dataset (see ''data_sources'').', '2026-03-26 00:07:38.933245', NULL, 'P0002');


--
-- TOC entry 4066 (class 0 OID 19911)
-- Dependencies: 298
-- Data for Name: experiments; Type: TABLE DATA; Schema: public; Owner: stamm
--



--
-- TOC entry 4073 (class 0 OID 19981)
-- Dependencies: 305
-- Data for Name: run; Type: TABLE DATA; Schema: public; Owner: stamm
--



--
-- TOC entry 4070 (class 0 OID 19952)
-- Dependencies: 302
-- Data for Name: actuator_states; Type: TABLE DATA; Schema: public; Owner: stamm
--



--
-- TOC entry 4087 (class 0 OID 20081)
-- Dependencies: 319
-- Data for Name: alerts; Type: TABLE DATA; Schema: public; Owner: stamm
--



--
-- TOC entry 4078 (class 0 OID 20013)
-- Dependencies: 310
-- Data for Name: annotations; Type: TABLE DATA; Schema: public; Owner: stamm
--



--
-- TOC entry 4079 (class 0 OID 20021)
-- Dependencies: 311
-- Data for Name: dynamic_model; Type: TABLE DATA; Schema: public; Owner: stamm
--



--
-- TOC entry 4067 (class 0 OID 19922)
-- Dependencies: 299
-- Data for Name: sensors; Type: TABLE DATA; Schema: public; Owner: stamm
--



--
-- TOC entry 4075 (class 0 OID 19995)
-- Dependencies: 307
-- Data for Name: equipment_components; Type: TABLE DATA; Schema: public; Owner: stamm
--



--
-- TOC entry 4084 (class 0 OID 20062)
-- Dependencies: 316
-- Data for Name: laboratories; Type: TABLE DATA; Schema: public; Owner: stamm
--

INSERT INTO public.laboratories (id, name, location) VALUES ('b957d5c0-f6ae-4d4e-82f0-73ffaa199609', 'Lab 1', 'Tolouse');
INSERT INTO public.laboratories (id, name, location) VALUES ('6af0f1ae-cc28-4398-ab2c-607dc86ba6f0', 'Lab 2', 'Paris');


--
-- TOC entry 4086 (class 0 OID 20078)
-- Dependencies: 318
-- Data for Name: laboratory_project; Type: TABLE DATA; Schema: public; Owner: stamm
--

INSERT INTO public.laboratory_project (laboratory_id, project_id, id) VALUES ('b957d5c0-f6ae-4d4e-82f0-73ffaa199609', '56d5fec2-b1bb-442d-99b1-b1aba59206cf', '6062be19-04a9-44bf-b976-55f1d319a3d9');
INSERT INTO public.laboratory_project (laboratory_id, project_id, id) VALUES ('6af0f1ae-cc28-4398-ab2c-607dc86ba6f0', '4b6b2911-bddd-4f02-b7f3-64920350e975', '5a841cf9-42fc-472f-a43c-79c02d125a78');


--
-- TOC entry 4083 (class 0 OID 20053)
-- Dependencies: 315
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: stamm
--

-- New permissions added 2026-04-24
-- Organization
INSERT INTO public.permissions (id, name, description) VALUES ('b1a1e1a0-0001-4000-8000-000000000001', 'organization:write', 'Write organization data');
INSERT INTO public.permissions (id, name, description) VALUES ('b1a1e1a0-0002-4000-8000-000000000002', 'organization:edit', 'Edit organization data');
INSERT INTO public.permissions (id, name, description) VALUES ('b1a1e1a0-0003-4000-8000-000000000003', 'organization:read', 'Read organization data');
-- Departments
INSERT INTO public.permissions (id, name, description) VALUES ('b1a1e1a0-0004-4000-8000-000000000004', 'departments:write', 'Write department data');
INSERT INTO public.permissions (id, name, description) VALUES ('b1a1e1a0-0005-4000-8000-000000000005', 'departments:edit', 'Edit department data');
INSERT INTO public.permissions (id, name, description) VALUES ('b1a1e1a0-0006-4000-8000-000000000006', 'departments:read', 'Read department data');
-- Laboratory
INSERT INTO public.permissions (id, name, description) VALUES ('b1a1e1a0-0007-4000-8000-000000000007', 'laboratory:write', 'Write laboratory data');
INSERT INTO public.permissions (id, name, description) VALUES ('b1a1e1a0-0008-4000-8000-000000000008', 'laboratory:edit', 'Edit laboratory data');
INSERT INTO public.permissions (id, name, description) VALUES ('b1a1e1a0-0009-4000-8000-000000000009', 'laboratory:read', 'Read laboratory data');
-- Project
INSERT INTO public.permissions (id, name, description) VALUES ('b1a1e1a0-0010-4000-8000-000000000010', 'project:write', 'Write project data');
INSERT INTO public.permissions (id, name, description) VALUES ('b1a1e1a0-0011-4000-8000-000000000011', 'project:edit', 'Edit project data');
INSERT INTO public.permissions (id, name, description) VALUES ('b1a1e1a0-0012-4000-8000-000000000012', 'project:read', 'Read project data');
-- Experiments
INSERT INTO public.permissions (id, name, description) VALUES ('b1a1e1a0-0013-4000-8000-000000000013', 'experiments:write', 'Write experiments data');
INSERT INTO public.permissions (id, name, description) VALUES ('b1a1e1a0-0014-4000-8000-000000000014', 'experiments:edit', 'Edit experiments data');
INSERT INTO public.permissions (id, name, description) VALUES ('b1a1e1a0-0015-4000-8000-000000000015', 'experiments:read', 'Read experiments data');
-- Models
INSERT INTO public.permissions (id, name, description) VALUES ('b1a1e1a0-0016-4000-8000-000000000016', 'models:write', 'Write models data');
INSERT INTO public.permissions (id, name, description) VALUES ('b1a1e1a0-0017-4000-8000-000000000017', 'models:edit', 'Edit models data');
INSERT INTO public.permissions (id, name, description) VALUES ('b1a1e1a0-0018-4000-8000-000000000018', 'models:read', 'Read models data');
INSERT INTO public.permissions (id, name, description) VALUES ('b1a1e1a0-0019-4000-8000-000000000019', 'models:deploy', 'Deploy models');
-- Users
INSERT INTO public.permissions (id, name, description) VALUES ('b1a1e1a0-0020-4000-8000-000000000020', 'users:write', 'Write users data');
INSERT INTO public.permissions (id, name, description) VALUES ('b1a1e1a0-0021-4000-8000-000000000021', 'users:edit', 'Edit users data');
INSERT INTO public.permissions (id, name, description) VALUES ('b1a1e1a0-0022-4000-8000-000000000022', 'users:read', 'Read users data');


--
-- TOC entry 4071 (class 0 OID 19960)
-- Dependencies: 303
-- Data for Name: soft_sensors; Type: TABLE DATA; Schema: public; Owner: stamm
--



--
-- TOC entry 4072 (class 0 OID 19973)
-- Dependencies: 304
-- Data for Name: predictions; Type: TABLE DATA; Schema: public; Owner: stamm
--



--
-- TOC entry 4080 (class 0 OID 20030)
-- Dependencies: 312
-- Data for Name: project_dynamic_models; Type: TABLE DATA; Schema: public; Owner: stamm
--



--
-- TOC entry 4074 (class 0 OID 19988)
-- Dependencies: 306
-- Data for Name: project_soft_sensors; Type: TABLE DATA; Schema: public; Owner: stamm
--



--
-- TOC entry 4063 (class 0 OID 19875)
-- Dependencies: 295
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: stamm
--

INSERT INTO public.users (id, full_name, email, password_hash, external_provider, external_id, created_at, is_active) VALUES ('ec300c7b-2250-4efa-b9d3-6a7fa7714ee7', 'string', 'user@example.com', '$2b$12$mrpteS07rvJJWcmpMC3g/OTImBcULqW81ExBjGuGoCssehvRIC7ZS', NULL, NULL, '2026-03-21 02:27:53.425286', true);
INSERT INTO public.users (id, full_name, email, password_hash, external_provider, external_id, created_at, is_active) VALUES ('02924cec-292a-4518-9943-f78da6b5b8b4', 'Viewer User', 'viewer@example.com', '$2b$12$mrpteS07rvJJWcmpMC3g/OTImBcULqW81ExBjGuGoCssehvRIC7ZS', NULL, NULL, '2026-03-25 22:36:39.806539', true);
INSERT INTO public.users (id, full_name, email, password_hash, external_provider, external_id, created_at, is_active) VALUES ('424add51-e989-4af5-86bd-75a2cb461274', 'Admin User', 'admin@example.com', '$2b$12$mrpteS07rvJJWcmpMC3g/OTImBcULqW81ExBjGuGoCssehvRIC7ZS', NULL, NULL, '2026-03-25 22:36:39.806539', true);


--
-- TOC entry 4088 (class 0 OID 20321)
-- Dependencies: 320
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: public; Owner: stamm
--

INSERT INTO public.refresh_tokens (id, user_id, token, expires_at, revoked) VALUES ('75a7ffb0-21bc-48c2-9688-000a11bfd027', '424add51-e989-4af5-86bd-75a2cb461274', 'dHQNbI_Zv5ABH9nWnWKnbb_Q2T_bgZz4XbWtWhfg22T-brfRxJZUeItcz4N67BHfii1rwGLZLC8cfC4BX2YtWA', '2026-04-02 23:36:37.928987', false);
INSERT INTO public.refresh_tokens (id, user_id, token, expires_at, revoked) VALUES ('a2ea0cd2-651d-43eb-873b-92859c518d53', '424add51-e989-4af5-86bd-75a2cb461274', '0ohL_xbwrcV5pBDJKIEWM5p9vgxif93ARYAPIj4ylI-6hFTVEp00KylFeRUEky6g-rLpfJ56OdenpFL3BQwYVQ', '2026-04-03 15:16:03.501172', false);
INSERT INTO public.refresh_tokens (id, user_id, token, expires_at, revoked) VALUES ('a4e275d4-768d-4b6d-9899-96a0839819dc', '424add51-e989-4af5-86bd-75a2cb461274', '57zu3wM7WyoIIIWFaZyvFVNT7-Pi8yAiRgNgCRIClNdx3Hq5AxI2snDHrMXpkb268ks5jPHidF2ScPeG28KpnA', '2026-04-04 00:03:16.228881', false);
INSERT INTO public.refresh_tokens (id, user_id, token, expires_at, revoked) VALUES ('9ad980ae-adfa-4fd3-88c8-fb0424756ff5', '424add51-e989-4af5-86bd-75a2cb461274', 'dxpmQnmCpY8n9o_Xw-w_hQlzoo9SgUmG9cvwK0Fcna-UmlCvLJNewINKHjZ9LnxACyAQ0uzfOd8_-Bnir-CR6w', '2026-04-07 12:50:55.320584', false);
INSERT INTO public.refresh_tokens (id, user_id, token, expires_at, revoked) VALUES ('cc2c2ebd-5952-4491-a2fe-edf81a369a12', '424add51-e989-4af5-86bd-75a2cb461274', 'NnK3eaxmnLaOWrzCgiheN51146A1HYt4pHm3jQ80b3QhpdQLdR8FV5QVq1hAm0to47H4KkwwBN5K6o8nKZaIpg', '2026-04-07 13:07:31.575553', false);
INSERT INTO public.refresh_tokens (id, user_id, token, expires_at, revoked) VALUES ('64717c45-4f92-4fbd-8a65-f7d03b3f4a1e', '424add51-e989-4af5-86bd-75a2cb461274', 'baRCob-vJOHqR0TwUqdUFlHSM53gfpTt9MoSgUr1mBUoMn3eVMspq5WAnoy2-mR0zAegUsWfnvQEEWcsP9U4kw', '2026-04-07 15:37:52.061618', false);
INSERT INTO public.refresh_tokens (id, user_id, token, expires_at, revoked) VALUES ('91a6d72a-4aec-4bec-a6a7-1c19f6f15155', '424add51-e989-4af5-86bd-75a2cb461274', 'eM0qsuXqfq6Z6astfUwrdw2uBO05yv1u-qIecviAcNq0DjS4kASfTIV7kXztU1zciY7kNNW54gkmd6iGbEM3QA', '2026-04-15 04:04:58.510255', false);
INSERT INTO public.refresh_tokens (id, user_id, token, expires_at, revoked) VALUES ('13d33b99-c2c8-4a8f-9cf3-d88665a820a5', '424add51-e989-4af5-86bd-75a2cb461274', 'aaajQWjGtYxBOhchDxxAmKKNo85KpzvgmZizemCRW-9n9RYyjs--K9P-0z2SfZghBdp07uU9a4GpgI5EVX6Kqg', '2026-04-15 04:04:58.52549', false);
INSERT INTO public.refresh_tokens (id, user_id, token, expires_at, revoked) VALUES ('6fb766e7-6bf6-4cf5-83c0-0eb3d2f66fc3', '424add51-e989-4af5-86bd-75a2cb461274', 'Gih5DuoB4aiHzVatbMFf-LwAGPnVAOvvs2-dajMEkcvJ7Bl1_noKFLwt3aRMalLxjUsemyJE2rx0WDBUxb-eJA', '2026-04-15 04:04:58.510255', false);
INSERT INTO public.refresh_tokens (id, user_id, token, expires_at, revoked) VALUES ('649bb784-40df-473c-a721-ecc24ec9187a', '424add51-e989-4af5-86bd-75a2cb461274', 'W1vmLtldjefFDuki88jSVoXzZuYN_aw8ii8sElW6xdMK7O-Z_pDhb-KxdSHoMNlAbqICysj_2EnTLSu9R177-A', '2026-04-16 03:51:53.387303', false);
INSERT INTO public.refresh_tokens (id, user_id, token, expires_at, revoked) VALUES ('04e12093-00fe-4a0f-9db5-e78c7e0999cc', '424add51-e989-4af5-86bd-75a2cb461274', '0jLWcryOB8IwWIlkkFNy9WM_LRUIpgrpXvkYNpVYUOGHCqJFrYRSiGR2YytrUYwZdokPf8LJD0c4il_5U_TMIQ', '2026-04-16 14:32:11.761966', false);
INSERT INTO public.refresh_tokens (id, user_id, token, expires_at, revoked) VALUES ('2c19feb0-a25b-4d9a-a003-0780f998c8c8', '424add51-e989-4af5-86bd-75a2cb461274', 'lVTLonivbr_T4pgEAJDd_2B5EBGsRgcyB8uTNdmSn9gMGisfBCHxMLxrprREm7K58v5c2WML8y4Uw4xyZ_WeRw', '2026-04-16 17:12:20.251316', false);
INSERT INTO public.refresh_tokens (id, user_id, token, expires_at, revoked) VALUES ('99b890f1-91bc-4335-a40f-9cb37d5a0629', '424add51-e989-4af5-86bd-75a2cb461274', 'ghwhtRa1sMBFr8KqIn4_cyLsXmAmQ-IF8JJDfKfRRpOjPR5vSJksIO0V47M4yUY-A_49Nsongw6dnwg5DnomvQ', '2026-04-16 17:32:46.850043', false);
INSERT INTO public.refresh_tokens (id, user_id, token, expires_at, revoked) VALUES ('885437bb-f56a-4f14-be00-cef6b42c6d05', '424add51-e989-4af5-86bd-75a2cb461274', 'd6gS5zLBN7ZdeZMTtEFf7man_s1cikAJ3DBV7CvdK26vUdG-LLJ0NKeGe2cT8STPTuad9PcWhlD5x7NLKWw7ZQ', '2026-04-16 23:36:50.24907', false);
INSERT INTO public.refresh_tokens (id, user_id, token, expires_at, revoked) VALUES ('bbd62297-f196-44ea-b20e-3fac5c76efd3', '424add51-e989-4af5-86bd-75a2cb461274', 'JRw2kUf32DtpuF2EEwu85wSrGr7OvhvRZQ16FLKn_RWxK3wkBraXTB25G9sjUubAVrhh39B58KyfQyit04OmLg', '2026-04-16 23:59:13.66985', false);
INSERT INTO public.refresh_tokens (id, user_id, token, expires_at, revoked) VALUES ('fe448f9f-55a2-433a-9f80-02841d79d58d', '424add51-e989-4af5-86bd-75a2cb461274', 'csXYmnlw9xhEZsaOMw7um4CyfWxkLXVVk1me1ztqyMt9XnBqadVAa1aAQgSvSkgc2g6r1DlP0M1rhV0rQ8Klhg', '2026-04-16 23:59:42.49799', false);
INSERT INTO public.refresh_tokens (id, user_id, token, expires_at, revoked) VALUES ('5edf40a1-d8f7-448e-89d8-276253d0810a', '424add51-e989-4af5-86bd-75a2cb461274', 'JYGHtaeMumHKjYMA7WoNueshumxmfi6TzeChWMTZpXRZCKATVOpgGB26MOZKNLB1MsIZr5_lgLYRWHmcbiNIew', '2026-04-17 01:37:44.68798', false);
INSERT INTO public.refresh_tokens (id, user_id, token, expires_at, revoked) VALUES ('1431e6d5-479c-436c-96ee-b3ea7879483a', '424add51-e989-4af5-86bd-75a2cb461274', 'jIUrHFISfCrRoLraWkBVw6PbxM92yUYV6xM5PjJFiHMBKAA0l_XcLt5B2CJR0ouCpoDjsJYvfB-WlOGv0rMp4w', '2026-04-17 01:58:16.739794', false);
INSERT INTO public.refresh_tokens (id, user_id, token, expires_at, revoked) VALUES ('19e4648f-bad9-4763-b6de-b485931e422f', '424add51-e989-4af5-86bd-75a2cb461274', 'Q_OLafYBn8eNiaQHx_rP5HCwSsUYdtUBJvHl5aiLiOJ2xoTwAyXcWsGqlxFXOA-JitDdeaiTDWplXv2_zgcwkw', '2026-04-17 01:59:06.712984', false);
INSERT INTO public.refresh_tokens (id, user_id, token, expires_at, revoked) VALUES ('919c65fe-1dd8-4443-a4cf-f84e619a165c', '424add51-e989-4af5-86bd-75a2cb461274', 'gJjoyRJsHMOt01nIuwgHVI7vFB5wfmq2fBH_T5nxC4cuVL7R7aMGlYc-JnBKKD3Nihj3refQjyElWgiXy_J-Iw', '2026-04-17 02:45:11.70924', false);


--
-- TOC entry 4082 (class 0 OID 20044)
-- Dependencies: 314
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: stamm
--

-- New roles added 2026-04-24
INSERT INTO public.roles (id, name, description) VALUES ('11111111-1111-1111-1111-111111111111', 'super_admin', 'Super administrator with all permissions');
INSERT INTO public.roles (id, name, description) VALUES ('22222222-2222-2222-2222-222222222222', 'admin', 'Administrator with management permissions');
INSERT INTO public.roles (id, name, description) VALUES ('33333333-3333-3333-3333-333333333333', 'modeler', 'Modeler with permissions to create and manage models');
INSERT INTO public.roles (id, name, description) VALUES ('44444444-4444-4444-4444-444444444444', 'operator', 'Operator with permissions to operate and view data');


--
-- TOC entry 4085 (class 0 OID 20071)
-- Dependencies: 317
-- Data for Name: role_permission; Type: TABLE DATA; Schema: public; Owner: stamm
--

INSERT INTO public.role_permission (id, role_id, permission_id) VALUES ('7bf2cd84-b828-4474-8894-469a70b3ebb6', '23ed8a1d-f372-42f9-ade4-23f18bb9b8c2', '350bc802-befd-49fd-bb12-d4d0785e7c21');
INSERT INTO public.role_permission (id, role_id, permission_id) VALUES ('426e64e6-e8a7-457d-b334-b1f874507c03', '23ed8a1d-f372-42f9-ade4-23f18bb9b8c2', 'a25a6b98-4f3e-4611-9910-8e160c9741d4');


--
-- TOC entry 4069 (class 0 OID 19944)
-- Dependencies: 301
-- Data for Name: sensor_readings; Type: TABLE DATA; Schema: public; Owner: stamm
--



--
-- TOC entry 4081 (class 0 OID 20037)
-- Dependencies: 313
-- Data for Name: simulations; Type: TABLE DATA; Schema: public; Owner: stamm
--



--
-- TOC entry 4076 (class 0 OID 20001)
-- Dependencies: 308
-- Data for Name: soft_sensor_metrics; Type: TABLE DATA; Schema: public; Owner: stamm
--



--
-- TOC entry 4077 (class 0 OID 20010)
-- Dependencies: 309
-- Data for Name: user_role; Type: TABLE DATA; Schema: public; Owner: stamm
--

INSERT INTO public.user_role (user_id, role_id, laboratory_id, created_at, updated_at, id) VALUES ('424add51-e989-4af5-86bd-75a2cb461274', '23ed8a1d-f372-42f9-ade4-23f18bb9b8c2', 'b957d5c0-f6ae-4d4e-82f0-73ffaa199609', '2026-03-26 17:55:59.939526', NULL, '6c4f857e-587c-4cc5-8869-0a4d04d13234');




-- Completed on 2026-04-10 17:53:55

--
-- PostgreSQL database dump complete
--

\unrestrict Isa7fq2AXa7HNlcQ2ONMpuADMH9i5QffGsvqTCoxUXynIeRpcj5YbSwfVJGwesd

