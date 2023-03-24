CREATE TABLE users (
  user_id INT PRIMARY KEY,
  name VARCHAR(255),
  pass VARCHAR(255),
  country VARCHAR(255)
);

CREATE TABLE recipes (
  recipe_id INT PRIMARY KEY,
  user_id INT,
  recipe_name VARCHAR(255),
  ingredients TEXT,
  instructions TEXT,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE mealplans (
  user_id INT PRIMARY KEY,
  Monday VARCHAR(255),
  Tuesday VARCHAR(255),
  Wednesday VARCHAR(255),
  ...,
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE bookmarks (
  user_id INT,
  recipe_id INT,
  PRIMARY KEY (user_id, recipe_id),
  FOREIGN KEY (user_id) REFERENCES users(user_id),
  FOREIGN KEY (recipe_id) REFERENCES recipes(recipe_id)
);
