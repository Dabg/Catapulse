-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Mon Sep 28 14:52:19 2015
-- 

;
BEGIN TRANSACTION;
--
-- Table: roles
--
CREATE TABLE roles (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar(100) NOT NULL,
  active tinyint NOT NULL DEFAULT 1
);
CREATE UNIQUE INDEX name_unique ON roles (name);
--
-- Table: users
--
CREATE TABLE users (
  id INTEGER PRIMARY KEY NOT NULL,
  username varchar(40) NOT NULL,
  name varchar(40),
  website varchar(100),
  password varchar(100) NOT NULL,
  email varchar(100) NOT NULL,
  tzone varchar(100),
  created timestamp NOT NULL,
  active tinyint DEFAULT 0
);
CREATE UNIQUE INDEX username_unique ON users (username);
--
-- Table: role_roles
--
CREATE TABLE role_roles (
  role_id integer NOT NULL,
  inherits_from_id integer NOT NULL,
  PRIMARY KEY (role_id, inherits_from_id),
  FOREIGN KEY (inherits_from_id) REFERENCES roles(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX role_roles_idx_inherits_from_id ON role_roles (inherits_from_id);
CREATE INDEX role_roles_idx_role_id ON role_roles (role_id);
--
-- Table: user_roles
--
CREATE TABLE user_roles (
  user_id integer NOT NULL,
  role_id integer NOT NULL,
  PRIMARY KEY (user_id, role_id),
  FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX user_roles_idx_role_id ON user_roles (role_id);
CREATE INDEX user_roles_idx_user_id ON user_roles (user_id);
COMMIT;
