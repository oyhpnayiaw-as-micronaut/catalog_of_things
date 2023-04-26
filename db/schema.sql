CREATE TABLE Item (
  id INTEGER PRIMARY KEY,
  genre_id INTEGER NOT NULL,
  author_id INTEGER NOT NULL,
  label_id INTEGER NOT NULL,
  publish_date DATE NOT NULL,
  archived BOOLEAN NOT NULL,

  FOREIGN KEY (genre_id) REFERENCES Genre(id),
  FOREIGN KEY (author_id) REFERENCES Author(id),
  FOREIGN KEY (label_id) REFERENCES Label(id)
);

CREATE TABLE Label (
  id SERIAL PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  color VARCHAR(255) NOT NULL
);

CREATE TABLE Genre (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE Author (
  id SERIAL PRIMARY KEY,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL
);

CREATE TABLE Book (
  id SERIAL PRIMARY KEY,
  cover_state VARCHAR(255) NOT NULL,
  publisher VARCHAR(255) NOT NULL,
  item_id INTEGER NOT NULL,

  FOREIGN KEY (item_id) REFERENCES Item(id)
);

CREATE TABLE MusicAlbum (
  id SERIAL PRIMARY KEY,
  on_spotify BOOLEAN NOT NULL,
  item_id INTEGER NOT NULL,

  FOREIGN KEY (item_id) REFERENCES Item(id)
);

CREATE TABLE Game (
  id SERIAL PRIMARY KEY,
  multiplayer VARCHAR(255) NOT NULL,
  last_played_at DATE,
  item_id INTEGER NOT NULL,

  FOREIGN KEY (item_id) REFERENCES Item(id)
);
