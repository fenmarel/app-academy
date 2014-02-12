CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

INSERT INTO
  users (fname, lname)
VALUES
  ("Ned", "Ruggeri"), ("Kush", "Patel"), ("Earl", "Cat");

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

-- Insert seed questions
INSERT INTO
  questions (title, body, author_id)
SELECT
  "Ned Question", "NED NED NED", users.id
FROM
  users
WHERE
  users.fname = "Ned" AND users.lname = "Ruggeri";

INSERT INTO
  questions (title, body, author_id)
SELECT
  "Kush Question", "KUSH KUSH KUSH", users.id
FROM
  users
WHERE
  users.fname = "Kush" AND users.lname = "Patel";

INSERT INTO
  questions (title, body, author_id)
SELECT
  "Earl Question", "MEOW MEOW MEOW", users.id
FROM
  users
WHERE
  users.fname = "Earl" AND users.lname = "Cat";

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

-- Create follows
INSERT INTO
  question_follows (user_id, question_id)
SELECT
  users.id, questions.id
FROM
  users
JOIN
  questions
WHERE
  (users.fname = "Ned" AND users.lname = "Ruggeri"
    AND questions.title = "Earl Question");

INSERT INTO
  question_follows (user_id, question_id)
SELECT
  users.id, questions.id
FROM
  users
JOIN
  questions
WHERE
  (users.fname = "Kush" AND users.lname = "Patel"
    AND questions.title = "Earl Question");

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_reply_id INTEGER,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)
);

INSERT INTO
  question_likes (user_id, question_id)
SELECT
  users.id, questions.id
FROM
  users
JOIN
  questions
WHERE
  (users.fname = "Kush" AND users.lname = "Patel"
    AND questions.title = "Earl Question");

-- create tags
CREATE TABLE tags (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

INSERT INTO tags (name) VALUES ("Ruby");
INSERT INTO tags (name) VALUES ("Javascript");
INSERT INTO tags (name) VALUES ("CSS");
INSERT INTO tags (name) VALUES ("HTML");

CREATE TABLE question_tags (
  id INTEGER PRIMARY KEY,
  question_id INTEGER,
  tag_id INTEGER
);

INSERT INTO question_tags (question_id, tag_id) VALUES (1, 1);
INSERT INTO question_tags (question_id, tag_id) VALUES (1, 2);
INSERT INTO question_tags (question_id, tag_id) VALUES (1, 3);
INSERT INTO question_tags (question_id, tag_id) VALUES (1, 4);
INSERT INTO question_tags (question_id, tag_id) VALUES (2, 3);
INSERT INTO question_tags (question_id, tag_id) VALUES (2, 4);

INSERT INTO question_likes (user_id, question_id) VALUES (1, 1);
INSERT INTO question_likes (user_id, question_id) VALUES (1, 2);