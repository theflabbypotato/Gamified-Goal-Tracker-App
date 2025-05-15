--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3
-- Dumped by pg_dump version 17.0

-- Started on 2025-05-15 12:38:56 EDT

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 24613)
-- Name: goal_logs; Type: TABLE; Schema: public; Owner: evan
--

CREATE TABLE public.goal_logs (
    id integer NOT NULL,
    goal_id integer,
    date date DEFAULT CURRENT_DATE,
    minutes_logged integer,
    completed boolean DEFAULT false
);


ALTER TABLE public.goal_logs OWNER TO evan;

--
-- TOC entry 218 (class 1259 OID 24612)
-- Name: goal_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: evan
--

CREATE SEQUENCE public.goal_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.goal_logs_id_seq OWNER TO evan;

--
-- TOC entry 3622 (class 0 OID 0)
-- Dependencies: 218
-- Name: goal_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: evan
--

ALTER SEQUENCE public.goal_logs_id_seq OWNED BY public.goal_logs.id;


--
-- TOC entry 217 (class 1259 OID 24601)
-- Name: goals; Type: TABLE; Schema: public; Owner: evan
--

CREATE TABLE public.goals (
    id integer NOT NULL,
    user_id integer,
    name character varying(255),
    daily_minutes integer,
    description text,
    skill_id integer
);


ALTER TABLE public.goals OWNER TO evan;

--
-- TOC entry 216 (class 1259 OID 24600)
-- Name: goals_id_seq; Type: SEQUENCE; Schema: public; Owner: evan
--

CREATE SEQUENCE public.goals_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.goals_id_seq OWNER TO evan;

--
-- TOC entry 3623 (class 0 OID 0)
-- Dependencies: 216
-- Name: goals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: evan
--

ALTER SEQUENCE public.goals_id_seq OWNED BY public.goals.id;


--
-- TOC entry 221 (class 1259 OID 24628)
-- Name: skills; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.skills (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    image_url text
);


ALTER TABLE public.skills OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 24627)
-- Name: skills_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.skills_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.skills_id_seq OWNER TO postgres;

--
-- TOC entry 3625 (class 0 OID 0)
-- Dependencies: 220
-- Name: skills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.skills_id_seq OWNED BY public.skills.id;


--
-- TOC entry 215 (class 1259 OID 24594)
-- Name: users; Type: TABLE; Schema: public; Owner: evan
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(100)
);


ALTER TABLE public.users OWNER TO evan;

--
-- TOC entry 214 (class 1259 OID 24593)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: evan
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO evan;

--
-- TOC entry 3627 (class 0 OID 0)
-- Dependencies: 214
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: evan
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 3452 (class 2604 OID 24616)
-- Name: goal_logs id; Type: DEFAULT; Schema: public; Owner: evan
--

ALTER TABLE ONLY public.goal_logs ALTER COLUMN id SET DEFAULT nextval('public.goal_logs_id_seq'::regclass);


--
-- TOC entry 3451 (class 2604 OID 24604)
-- Name: goals id; Type: DEFAULT; Schema: public; Owner: evan
--

ALTER TABLE ONLY public.goals ALTER COLUMN id SET DEFAULT nextval('public.goals_id_seq'::regclass);


--
-- TOC entry 3455 (class 2604 OID 24631)
-- Name: skills id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skills ALTER COLUMN id SET DEFAULT nextval('public.skills_id_seq'::regclass);


--
-- TOC entry 3450 (class 2604 OID 24597)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: evan
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3614 (class 0 OID 24613)
-- Dependencies: 219
-- Data for Name: goal_logs; Type: TABLE DATA; Schema: public; Owner: evan
--



--
-- TOC entry 3612 (class 0 OID 24601)
-- Dependencies: 217
-- Data for Name: goals; Type: TABLE DATA; Schema: public; Owner: evan
--



--
-- TOC entry 3616 (class 0 OID 24628)
-- Dependencies: 221
-- Data for Name: skills; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3610 (class 0 OID 24594)
-- Dependencies: 215
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: evan
--



--
-- TOC entry 3628 (class 0 OID 0)
-- Dependencies: 218
-- Name: goal_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: evan
--

SELECT pg_catalog.setval('public.goal_logs_id_seq', 9, true);


--
-- TOC entry 3629 (class 0 OID 0)
-- Dependencies: 216
-- Name: goals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: evan
--

SELECT pg_catalog.setval('public.goals_id_seq', 13, true);


--
-- TOC entry 3630 (class 0 OID 0)
-- Dependencies: 220
-- Name: skills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.skills_id_seq', 19, true);


--
-- TOC entry 3631 (class 0 OID 0)
-- Dependencies: 214
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: evan
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- TOC entry 3461 (class 2606 OID 24618)
-- Name: goal_logs goal_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: evan
--

ALTER TABLE ONLY public.goal_logs
    ADD CONSTRAINT goal_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 3459 (class 2606 OID 24606)
-- Name: goals goals_pkey; Type: CONSTRAINT; Schema: public; Owner: evan
--

ALTER TABLE ONLY public.goals
    ADD CONSTRAINT goals_pkey PRIMARY KEY (id);


--
-- TOC entry 3463 (class 2606 OID 24633)
-- Name: skills skills_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skills
    ADD CONSTRAINT skills_pkey PRIMARY KEY (id);


--
-- TOC entry 3457 (class 2606 OID 24599)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: evan
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3466 (class 2606 OID 24619)
-- Name: goal_logs goal_logs_goal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: evan
--

ALTER TABLE ONLY public.goal_logs
    ADD CONSTRAINT goal_logs_goal_id_fkey FOREIGN KEY (goal_id) REFERENCES public.goals(id);


--
-- TOC entry 3464 (class 2606 OID 24634)
-- Name: goals goals_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: evan
--

ALTER TABLE ONLY public.goals
    ADD CONSTRAINT goals_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skills(id);


--
-- TOC entry 3465 (class 2606 OID 24607)
-- Name: goals goals_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: evan
--

ALTER TABLE ONLY public.goals
    ADD CONSTRAINT goals_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 3624 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE skills; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.skills TO evan;


--
-- TOC entry 3626 (class 0 OID 0)
-- Dependencies: 220
-- Name: SEQUENCE skills_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.skills_id_seq TO evan;


-- Completed on 2025-05-15 12:38:57 EDT

--
-- PostgreSQL database dump complete
--

