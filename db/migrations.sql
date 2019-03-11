DROP DATABASE IF EXISTS try_catch_app_db;
CREATE DATABASE try_catch_app_db;

\c try_catch_app_db

CREATE TABLE users(
	id SERIAL PRIMARY KEY,
	username VARCHAR(128),
	email TEXT,
	bio TEXT,
	password_digest VARCHAR(60),
	reg_time BIGINT,
	is_admin BOOLEAN NOT NULL DEFAULT FALSE 
);

CREATE TABLE issues(
	id SERIAL PRIMARY KEY,
	name VARCHAR(255),
	description TEXT,
	owner_id INTEGER REFERENCES users(id) ON DELETE CASCADE 
);


CREATE TABLE notes(
	id SERIAL PRIMARY KEY,
	name VARCHAR(255),
	content TEXT, 
	issue_id INTEGER REFERENCES issues(id) ON DELETE CASCADE 
);


CREATE TABLE tags(
	id SERIAL PRIMARY KEY,
	content VARCHAR(255),
	issue_id INTEGER REFERENCES issues(id) ON DELETE CASCADE
);


CREATE TABLE collaborations(
	id SERIAL PRIMARY KEY,
	user_id INTEGER REFERENCES users(id) ON DELETE CASCADE, 
	collaborator_id INTEGER REFERENCES users(id) ON DELETE CASCADE 
);


CREATE TABLE shared_issues(
	id SERIAL PRIMARY KEY,
	owner_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
	issue_id INTEGER REFERENCES issues(id) ON DELETE CASCADE,
	collaborator_id INTEGER REFERENCES users(id) ON DELETE CASCADE
);


  -- activeStorage:  ????? 
  -- has_one_attached :avatar_image ??? 
-- OTHER MODELS: 

