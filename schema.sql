--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = ON;
SET check_function_bodies = FALSE;
SET client_min_messages = WARNING;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;

--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';

--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;

--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = FALSE;

--
-- Name: chat; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE FUNCTION clean_map_name(map TEXT)
  RETURNS TEXT AS $$
SELECT regexp_replace(map, '(_(a|b|beta|u|r|v|rc|final|comptf|ugc|f)?[0-9]*[a-z]?$)|([0-9]+[a-z]?$)', '', 'g');
$$ LANGUAGE SQL;


CREATE TABLE chat (
  id         INTEGER                     NOT NULL,
  demo_id    INTEGER                     NOT NULL,
  "from"     CHARACTER VARYING(255)      NOT NULL,
  text       CHARACTER VARYING(255)      NOT NULL,
  "time"     INTEGER                     NOT NULL
);

--
-- Name: chat_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE chat_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;

--
-- Name: chat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE chat_id_seq OWNED BY chat.id;

--
-- Name: demos; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE demos (
  id            INTEGER                                                NOT NULL,
  name          CHARACTER VARYING(255)                                 NOT NULL,
  url           CHARACTER VARYING(255)                                 NOT NULL,
  map           CHARACTER VARYING(255)                                 NOT NULL,
  red           CHARACTER VARYING(255)                                 NOT NULL,
  blu           CHARACTER VARYING(255)                                 NOT NULL,
  uploader      INTEGER                                                NOT NULL,
  duration      INTEGER                                                NOT NULL,
  created_at    TIMESTAMP WITHOUT TIME ZONE                            NOT NULL,
  updated_at    TIMESTAMP WITHOUT TIME ZONE                            NOT NULL,
  backend       CHARACTER VARYING(255)                                 NOT NULL,
  path          CHARACTER VARYING(255)                                 NOT NULL,
  "scoreBlue"   INTEGER DEFAULT 0                                      NOT NULL,
  "scoreRed"    INTEGER DEFAULT 0                                      NOT NULL,
  version       INTEGER DEFAULT 0                                      NOT NULL,
  server        CHARACTER VARYING(255) DEFAULT '' :: CHARACTER VARYING NOT NULL,
  nick          CHARACTER VARYING(255) DEFAULT '' :: CHARACTER VARYING NOT NULL,
  deleted_at    TIMESTAMP WITHOUT TIME ZONE,
  "playerCount" INTEGER DEFAULT 0                                      NOT NULL,
  hash          CHARACTER VARYING(255) DEFAULT '' :: CHARACTER VARYING NOT NULL,
  blue_team_id  INTEGER,
  red_team_id   INTEGER
);

--
-- Name: demos_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE demos_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;

--
-- Name: demos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE demos_id_seq OWNED BY demos.id;

--
-- Name: migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE migrations (
  migration CHARACTER VARYING(255) NOT NULL,
  batch     INTEGER                NOT NULL
);

--
-- Name: players; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE players (
  id           INTEGER                     NOT NULL,
  demo_id      INTEGER                     NOT NULL,
  demo_user_id INTEGER                     NOT NULL,
  user_id      INTEGER                     NOT NULL,
  name         CHARACTER VARYING(255)      NOT NULL,
  team         CHARACTER VARYING(255)      NOT NULL,
  class        CHARACTER VARYING(255)      NOT NULL,
  kills        INTEGER                     NOT NULL,
  assists      INTEGER                     NOT NULL,
  deaths       INTEGER                     NOT NULL
);

--
-- Name: players_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE players_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;

--
-- Name: players_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE players_id_seq OWNED BY players.id;

--
-- Name: storage_keys; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE storage_keys (
  id         INTEGER                     NOT NULL,
  userid     INTEGER                     NOT NULL,
  type       CHARACTER VARYING(255)      NOT NULL,
  token      CHARACTER VARYING(255)      NOT NULL,
  created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL
);

--
-- Name: storage_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE storage_keys_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;

--
-- Name: storage_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE storage_keys_id_seq OWNED BY storage_keys.id;

--
-- Name: teams; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE teams (
  id         INTEGER                     NOT NULL,
  profile_id INTEGER                     NOT NULL,
  name       CHARACTER VARYING(255)      NOT NULL,
  tag        CHARACTER VARYING(255)      NOT NULL,
  avatar     CHARACTER VARYING(255)      NOT NULL,
  steam      CHARACTER VARYING(255)      NOT NULL,
  league     CHARACTER VARYING(255)      NOT NULL,
  division   CHARACTER VARYING(255)      NOT NULL,
  created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  updated_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  CONSTRAINT teams_league_check CHECK (((league) :: TEXT = ANY
                                        ((ARRAY ['ugc' :: CHARACTER VARYING, 'etf2l' :: CHARACTER VARYING]) :: TEXT [])))
);

--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE teams_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;

--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE teams_id_seq OWNED BY teams.id;

--
-- Name: upload_blacklist; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE upload_blacklist (
  id          INTEGER NOT NULL,
  uploader_id INTEGER NOT NULL,
  reason      CHARACTER VARYING,
  block       BOOLEAN
);

--
-- Name: upload_blacklist_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE upload_blacklist_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;

--
-- Name: upload_blacklist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE upload_blacklist_id_seq OWNED BY upload_blacklist.id;

--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
  id         INTEGER                                   NOT NULL,
  steamid    CHARACTER VARYING(255)                    NOT NULL,
  name       CHARACTER VARYING(255)                    NOT NULL,
  avatar     CHARACTER VARYING(255)                    NOT NULL,
  token      CHARACTER VARYING(255)                    NOT NULL,
  created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL,
  updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT now() NOT NULL
);

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY chat
  ALTER COLUMN id SET DEFAULT nextval('chat_id_seq' :: REGCLASS);

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY demos
  ALTER COLUMN id SET DEFAULT nextval('demos_id_seq' :: REGCLASS);

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY players
  ALTER COLUMN id SET DEFAULT nextval('players_id_seq' :: REGCLASS);

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY storage_keys
  ALTER COLUMN id SET DEFAULT nextval('storage_keys_id_seq' :: REGCLASS);

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY teams
  ALTER COLUMN id SET DEFAULT nextval('teams_id_seq' :: REGCLASS);

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY upload_blacklist
  ALTER COLUMN id SET DEFAULT nextval('upload_blacklist_id_seq' :: REGCLASS);

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
  ALTER COLUMN id SET DEFAULT nextval('users_id_seq' :: REGCLASS);

--
-- Name: chat_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY chat
  ADD CONSTRAINT chat_pkey PRIMARY KEY (id);

--
-- Name: demos_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY demos
  ADD CONSTRAINT demos_pkey PRIMARY KEY (id);

--
-- Name: players_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY players
  ADD CONSTRAINT players_pkey PRIMARY KEY (id);

--
-- Name: storage_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY storage_keys
  ADD CONSTRAINT storage_keys_pkey PRIMARY KEY (id);

--
-- Name: teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY teams
  ADD CONSTRAINT teams_pkey PRIMARY KEY (id);

--
-- Name: upload_blacklist_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY upload_blacklist
  ADD CONSTRAINT upload_blacklist_pkey PRIMARY KEY (id);

--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
  ADD CONSTRAINT users_pkey PRIMARY KEY (id);

--
-- Name: alias_trgm_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX alias_trgm_idx
  ON players USING GIN (name gin_trgm_ops);

CREATE INDEX chat_demo_idx
  ON chat USING BTREE (demo_id);

--
-- Name: demos_blue_team_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX demos_blue_team_id_index
  ON demos USING BTREE (blue_team_id);

--
-- Name: demos_hash_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX demos_hash_index
  ON demos USING BTREE (hash);

CREATE INDEX demos_backend_index
  ON demos USING BTREE (backend);

--
-- Name: demos_playercount_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX demos_playercount_index
  ON demos USING BTREE ("playerCount");

--
-- Name: demos_red_team_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX demos_red_team_id_index
  ON demos USING BTREE (red_team_id);

--
-- Name: demos_uploader_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX demos_uploader_index
  ON demos USING BTREE (uploader);


CREATE INDEX demos_map_index
  ON demos USING BTREE (map);

CREATE INDEX demos_clean_map_index
  ON demos USING BTREE (clean_map_name(map));

CREATE INDEX demos_time_index
  ON demos USING BTREE (created_at);

--
-- Name: players_class_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX players_class_index
  ON players USING BTREE (class);

--
-- Name: players_demo_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX players_demo_id_index
  ON players USING BTREE (demo_id);

--
-- Name: players_name_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX players_name_index
  ON players USING BTREE (name);

--
-- Name: players_user_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX players_user_id_index
  ON players USING BTREE (user_id);

CREATE INDEX players_user_demo_id_index
  ON players USING BTREE (user_id, demo_id DESC);

--
-- Name: teams_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX teams_id_index
  ON teams USING BTREE (id);

--
-- Name: teams_profile_id_index; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX teams_profile_id_index
  ON teams USING BTREE (profile_id);

--
-- Name: upload_blacklist_uploader_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX upload_blacklist_uploader_id_idx
  ON upload_blacklist USING BTREE (uploader_id);

CREATE UNIQUE INDEX users_steamid_idx
  ON users USING BTREE (steamid);

CREATE UNIQUE INDEX users_token_idx
  ON users USING BTREE (token);


CREATE MATERIALIZED VIEW map_list AS
  SELECT DISTINCT
    (clean_map_name(map))      AS map,
    COUNT(clean_map_name(map)) AS count
  FROM demos
  GROUP BY clean_map_name(map)
  ORDER BY count DESC;

CREATE MATERIALIZED VIEW name_list AS
  SELECT user_id, p.name, count(demo_id) AS count, steamid
  FROM players p
  INNER JOIN users u ON u.id=p.user_id
  GROUP BY p.name, user_id, steamid;

CREATE INDEX alias_name_trgm_idx ON name_list USING GIN (name gin_trgm_ops);

CREATE MATERIALIZED VIEW users_named AS
  with names as
  (
    select name, count, user_id,
      rank() over (partition by user_id order by user_id, count desc) rn
    from name_list
  )
  select id, steamid, n.name, avatar, token
  from   names n
  inner join users u on u.id = n.user_id
  where  rn = 1;

--
-- PostgreSQL database dump complete
--

