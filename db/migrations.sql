DROP DATABASE IF EXISTS try_catch_app_db;
CREATE DATABASE try_catch_app_db;

\c try_catch_app_db

CREATE TABLE users(
  id SERIAL PRIMARY KEY,
  username VARCHAR(128),
  email TEXT,
  bio TEXT,
  password_digest VARCHAR(60),
  is_admin BOOLEAN NOT NULL DEFAULT FALSE 
  -- activeStorage:  ????? 
  -- has_one_attached :avatar_image ??? 
);

-- OTHER MODELS: 