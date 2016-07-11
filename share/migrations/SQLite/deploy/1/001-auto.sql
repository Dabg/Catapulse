-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Mon Jul 11 18:33:33 2016
-- 

;
BEGIN TRANSACTION;
--
-- Table: blocks
--
CREATE TABLE blocks (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar(32) NOT NULL,
  file varchar(255) NOT NULL,
  parent_id int NOT NULL DEFAULT 0,
  position int,
  active tinyint NOT NULL DEFAULT 1
);
CREATE UNIQUE INDEX name_unique ON blocks (name);
--
-- Table: obj_operation
--
CREATE TABLE obj_operation (
  typeobj_id integer NOT NULL,
  obj_id integer NOT NULL,
  operation_id integer NOT NULL,
  FOREIGN KEY (operation_id) REFERENCES operation(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (typeobj_id) REFERENCES typeobj(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX obj_operation_idx_operation_id ON obj_operation (operation_id);
CREATE INDEX obj_operation_idx_typeobj_id ON obj_operation (typeobj_id);
CREATE UNIQUE INDEX typeobj_obj_op_unique ON obj_operation (typeobj_id, obj_id, operation_id);
--
-- Table: operation
--
CREATE TABLE operation (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar(100) NOT NULL,
  active tinyint NOT NULL DEFAULT 1
);
CREATE UNIQUE INDEX name ON operation (name);
--
-- Table: pagetype
--
CREATE TABLE pagetype (
  id INTEGER PRIMARY KEY NOT NULL,
  name VARCHAR(40) NOT NULL,
  path VARCHAR(100),
  active tinyint NOT NULL DEFAULT 0
);
--
-- Table: permission
--
CREATE TABLE permission (
  id INTEGER PRIMARY KEY NOT NULL,
  role_id integer NOT NULL,
  typeobj_id integer NOT NULL,
  obj_id integer NOT NULL,
  operation_id integer NOT NULL,
  value integer,
  inheritable integer,
  FOREIGN KEY (operation_id) REFERENCES operation(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (typeobj_id) REFERENCES typeobj(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX permission_idx_operation_id ON permission (operation_id);
CREATE INDEX permission_idx_role_id ON permission (role_id);
CREATE INDEX permission_idx_typeobj_id ON permission (typeobj_id);
CREATE UNIQUE INDEX object_role_operation_unique ON permission (typeobj_id, obj_id, role_id, operation_id);
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
-- Table: roles
--
CREATE TABLE roles (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar(100) NOT NULL,
  active tinyint NOT NULL DEFAULT 1
);
CREATE UNIQUE INDEX name_unique02 ON roles (name);
--
-- Table: tag
--
CREATE TABLE tag (
  id INTEGER PRIMARY KEY NOT NULL,
  name VARCHAR(100) NOT NULL,
  active tinyint NOT NULL DEFAULT 0
);
--
-- Table: template_blocks
--
CREATE TABLE template_blocks (
  template_id integer NOT NULL,
  block_id integer NOT NULL,
  PRIMARY KEY (template_id, block_id),
  FOREIGN KEY (block_id) REFERENCES blocks(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (template_id) REFERENCES templates(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX template_blocks_idx_block_id ON template_blocks (block_id);
CREATE INDEX template_blocks_idx_template_id ON template_blocks (template_id);
--
-- Table: templates
--
CREATE TABLE templates (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar(32) NOT NULL,
  file varchar(255) NOT NULL,
  wrapper varchar(32) NOT NULL,
  parent_id int NOT NULL DEFAULT 0,
  position int,
  active tinyint NOT NULL DEFAULT 1
);
CREATE UNIQUE INDEX name_unique03 ON templates (name);
--
-- Table: typeobj
--
CREATE TABLE typeobj (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar NOT NULL,
  active integer NOT NULL
);
CREATE UNIQUE INDEX name_unique04 ON typeobj (name);
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
--
-- Table: users
--
CREATE TABLE users (
  id INTEGER PRIMARY KEY NOT NULL,
  username varchar(40) NOT NULL,
  name varchar(40),
  website varchar(100),
  password VARCHAR(100) NOT NULL,
  email varchar(100) NOT NULL,
  tzone varchar(100),
  created timestamp NOT NULL,
  active tinyint DEFAULT 0
);
CREATE UNIQUE INDEX username_unique ON users (username);
--
-- Table: content
--
CREATE TABLE content (
  page INTEGER NOT NULL,
  version INTEGER NOT NULL,
  creator INTEGER NOT NULL,
  created BIGINT(100) NOT NULL,
  status VARCHAR(20) NOT NULL,
  release_date BIGINT(100) NOT NULL,
  remove_date BIGINT(100),
  type VARCHAR(200),
  abstract TEXT(4000),
  comments TEXT(4000),
  body TEXT NOT NULL,
  precompiled TEXT,
  PRIMARY KEY (page, version),
  FOREIGN KEY (creator) REFERENCES users(id),
  FOREIGN KEY (page) REFERENCES pages(id)
);
CREATE INDEX content_idx_creator ON content (creator);
CREATE INDEX content_idx_page ON content (page);
--
-- Table: pages
--
CREATE TABLE pages (
  id INTEGER PRIMARY KEY NOT NULL,
  title varchar(255),
  name varchar,
  parent_id integer NOT NULL DEFAULT 0,
  type integer NOT NULL,
  template integer NOT NULL,
  created timestamp NOT NULL,
  active tinyint NOT NULL DEFAULT 0,
  version INTEGER,
  FOREIGN KEY (parent_id) REFERENCES pages(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (id, version) REFERENCES content(page, version) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (template) REFERENCES templates(id),
  FOREIGN KEY (type) REFERENCES pagetype(id)
);
CREATE INDEX pages_idx_parent_id ON pages (parent_id);
CREATE INDEX pages_idx_id_version ON pages (id, version);
CREATE INDEX pages_idx_template ON pages (template);
CREATE INDEX pages_idx_type ON pages (type);
CREATE UNIQUE INDEX name_parent_unique ON pages (name, parent_id);
--
-- Table: comment
--
CREATE TABLE comment (
  id INTEGER PRIMARY KEY NOT NULL,
  parent_id integer DEFAULT 0,
  poster INTEGER NOT NULL,
  page_id INTEGER NOT NULL,
  created datetime NOT NULL,
  modified datetime,
  body TEXT NOT NULL,
  FOREIGN KEY (parent_id) REFERENCES comment(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (page_id) REFERENCES pages(id),
  FOREIGN KEY (poster) REFERENCES users(id)
);
CREATE INDEX comment_idx_parent_id ON comment (parent_id);
CREATE INDEX comment_idx_page_id ON comment (page_id);
CREATE INDEX comment_idx_poster ON comment (poster);
COMMIT;
