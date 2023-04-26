CREATE TABLE Item(
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

CREATE TABLE Genre(
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);

CREATE TABLE MusicAlbum(
  id INTEGER PRIMARY KEY,
  on_spotify BOOLEAN NOT NULL,
  item_id INTEGER NOT NULL,

  FOREIGN KEY (item_id) REFERENCES Item(id)
);
