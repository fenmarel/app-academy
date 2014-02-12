CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT,
  lname TEXT
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT,
  body TEXT,
  author_id INTEGER REFERENCES users(id)
);

CREATE TABLE question_followers (
  id INTEGER PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  question_id INTEGER REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER REFERENCES questions(id) NOT NULL,
  parent_id INTEGER REFERENCES replies(id),
  user_id INTEGER REFERENCES users(id),
  body TEXT
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER REFERENCES users(id),
  question_id INTEGER REFERENCES questions(id)
);

CREATE TABLE tags (
  id INTEGER PRIMARY KEY,
  tag_name TEXT
);

CREATE TABLE question_tags (
  id INTEGER PRIMARY KEY,
  question_id INTEGER REFERENCES questions(id),
  tag_id INTEGER REFERENCES tags(id)
);




-- Bunch of meaningless table data

INSERT INTO
  users (fname, lname)
VALUES
  ('Fuman', 'Chu');

INSERT INTO
  users (fname, lname)
VALUES
  ('C', 'J');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('What the what?', 'srsly guys.', 2);

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('You so smart!', 'LALALA question body away!', 2);

INSERT INTO
  question_followers(user_id, question_id)
VALUES
  (1, 1);

INSERT INTO
  question_followers(user_id, question_id)
VALUES
  (2, 1);

INSERT INTO
  replies (question_id, parent_id, user_id, body)
VALUES
  (1, NULL, 1, 'Sorry CJ.');

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  (2, 1);

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  (1, 1);

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  (2, 2);

INSERT INTO
  tags (tag_name)
VALUES
  ('html');

INSERT INTO
  tags (tag_name)
VALUES
  ('css');

INSERT INTO
  tags (tag_name)
VALUES
  ('ruby');

INSERT INTO
  tags (tag_name)
VALUES
  ('javascript');

INSERT INTO
  question_tags (question_id, tag_id)
VALUES
  (1, 3);

INSERT INTO
  question_tags (question_id, tag_id)
VALUES
  (2, 3);

INSERT INTO
  question_tags (question_id, tag_id)
VALUES
  (2, 2);

