--
-- PostgreSQL database dump
--

-- Dumped from database version 15.3
-- Dumped by pg_dump version 17.0

-- Started on 2025-05-15 13:18:45 EDT

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
-- TOC entry 5 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: evan
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO evan;

--
-- TOC entry 3626 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: evan
--

COMMENT ON SCHEMA public IS 'standard public schema';


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
-- TOC entry 3627 (class 0 OID 0)
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
-- TOC entry 3628 (class 0 OID 0)
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
-- TOC entry 3630 (class 0 OID 0)
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
-- TOC entry 3632 (class 0 OID 0)
-- Dependencies: 214
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: evan
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 3456 (class 2604 OID 24616)
-- Name: goal_logs id; Type: DEFAULT; Schema: public; Owner: evan
--

ALTER TABLE ONLY public.goal_logs ALTER COLUMN id SET DEFAULT nextval('public.goal_logs_id_seq'::regclass);


--
-- TOC entry 3455 (class 2604 OID 24604)
-- Name: goals id; Type: DEFAULT; Schema: public; Owner: evan
--

ALTER TABLE ONLY public.goals ALTER COLUMN id SET DEFAULT nextval('public.goals_id_seq'::regclass);


--
-- TOC entry 3459 (class 2604 OID 24631)
-- Name: skills id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skills ALTER COLUMN id SET DEFAULT nextval('public.skills_id_seq'::regclass);


--
-- TOC entry 3454 (class 2604 OID 24597)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: evan
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 3618 (class 0 OID 24613)
-- Dependencies: 219
-- Data for Name: goal_logs; Type: TABLE DATA; Schema: public; Owner: evan
--

INSERT INTO public.goal_logs VALUES (10, 15, '2025-05-15', NULL, true);


--
-- TOC entry 3616 (class 0 OID 24601)
-- Dependencies: 217
-- Data for Name: goals; Type: TABLE DATA; Schema: public; Owner: evan
--

INSERT INTO public.goals VALUES (14, NULL, 'Make Music', 60, 'make music everyday', 21);
INSERT INTO public.goals VALUES (15, NULL, 'Play a match everday', 120, 'Hopefully consistently get better', 20);


--
-- TOC entry 3620 (class 0 OID 24628)
-- Dependencies: 221
-- Data for Name: skills; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.skills VALUES (20, 'Tennis', 'https://oaidalleapiprodscus.blob.core.windows.net/private/org-7lj4wyKIFQw5ijP7wzUT3GVA/user-i0v8JPDGF8xeelMNtCTcjSQg/img-x6YrKXRN0lMPBPq8u2H9TMjl.png?st=2025-05-15T16%3A01%3A28Z&se=2025-05-15T18%3A01%3A28Z&sp=r&sv=2024-08-04&sr=b&rscd=inline&rsct=image/png&skoid=cc612491-d948-4d2e-9821-2683df3719f5&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2025-05-15T01%3A14%3A52Z&ske=2025-05-16T01%3A14%3A52Z&sks=b&skv=2024-08-04&sig=ExVQUU7PWpwdXq6rYN5bfBmA4WXf8NlkQ17Y3p6YUgQ%3D');
INSERT INTO public.skills VALUES (21, 'Music', 'https://oaidalleapiprodscus.blob.core.windows.net/private/org-7lj4wyKIFQw5ijP7wzUT3GVA/user-i0v8JPDGF8xeelMNtCTcjSQg/img-gFwFf7qQZfrYDwVVPRzh6Tj9.png?st=2025-05-15T16%3A01%3A46Z&se=2025-05-15T18%3A01%3A46Z&sp=r&sv=2024-08-04&sr=b&rscd=inline&rsct=image/png&skoid=cc612491-d948-4d2e-9821-2683df3719f5&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2025-05-14T20%3A14%3A08Z&ske=2025-05-15T20%3A14%3A08Z&sks=b&skv=2024-08-04&sig=FiQbw1xrncIna9fs72O6OVJeMqWqgSPLmaXvwd4VLtw%3D');


--
-- TOC entry 3614 (class 0 OID 24594)
-- Dependencies: 215
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: evan
--



--
-- TOC entry 3633 (class 0 OID 0)
-- Dependencies: 218
-- Name: goal_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: evan
--

SELECT pg_catalog.setval('public.goal_logs_id_seq', 10, true);


--
-- TOC entry 3634 (class 0 OID 0)
-- Dependencies: 216
-- Name: goals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: evan
--

SELECT pg_catalog.setval('public.goals_id_seq', 15, true);


--
-- TOC entry 3635 (class 0 OID 0)
-- Dependencies: 220
-- Name: skills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.skills_id_seq', 21, true);


--
-- TOC entry 3636 (class 0 OID 0)
-- Dependencies: 214
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: evan
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- TOC entry 3465 (class 2606 OID 24618)
-- Name: goal_logs goal_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: evan
--

ALTER TABLE ONLY public.goal_logs
    ADD CONSTRAINT goal_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 3463 (class 2606 OID 24606)
-- Name: goals goals_pkey; Type: CONSTRAINT; Schema: public; Owner: evan
--

ALTER TABLE ONLY public.goals
    ADD CONSTRAINT goals_pkey PRIMARY KEY (id);


--
-- TOC entry 3467 (class 2606 OID 24633)
-- Name: skills skills_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skills
    ADD CONSTRAINT skills_pkey PRIMARY KEY (id);


--
-- TOC entry 3461 (class 2606 OID 24599)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: evan
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3470 (class 2606 OID 24619)
-- Name: goal_logs goal_logs_goal_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: evan
--

ALTER TABLE ONLY public.goal_logs
    ADD CONSTRAINT goal_logs_goal_id_fkey FOREIGN KEY (goal_id) REFERENCES public.goals(id);


--
-- TOC entry 3468 (class 2606 OID 24634)
-- Name: goals goals_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: evan
--

ALTER TABLE ONLY public.goals
    ADD CONSTRAINT goals_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skills(id);


--
-- TOC entry 3469 (class 2606 OID 24607)
-- Name: goals goals_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: evan
--

ALTER TABLE ONLY public.goals
    ADD CONSTRAINT goals_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 3629 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE skills; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.skills TO evan;


--
-- TOC entry 3631 (class 0 OID 0)
-- Dependencies: 220
-- Name: SEQUENCE skills_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.skills_id_seq TO evan;


-- Completed on 2025-05-15 13:18:46 EDT

--
-- PostgreSQL database dump complete
--

