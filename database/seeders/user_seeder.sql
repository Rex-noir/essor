INSERT INTO users (username, email, password)
VALUES
  ('alice', 'alice@example.com', crypt('password123', gen_salt('bf'))),
  ('bob', 'bob@example.com', crypt('secret456', gen_salt('bf')));