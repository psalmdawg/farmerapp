create database farmerapp
  \c farmerapp


  CREATE TABLE items (
    id SERIAL4 PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(100),
    description VARCHAR(1000),
    sold_status VARCHAR(100) NOT NULL,
    Image_url VARCHAR (500),
    price VARCHAR (100),
    user_id INTEGER
  );

  CREATE TABLE users (
    id SERIAL4 PRIMARY KEY,
    user_name VARCHAR (100) NOT NULL,
    email VARCHAR(60) NOT NULL,
    password_digest VARCHAR(400) NOT NULL
  );

  CREATE TABLE messages (
    id serial4 PRIMARY KEY,
    content VARCHAR(1000),
    sender_id INTEGER,
    receiver_id INTEGER,
    read_status BOOLEAN,
    related_item_id VARCHAR(5)
  )



  INSERT INTO items (name, category, description, sold_status, image_url, price, seller)
  VALUES ('McCormick Farmall', 'tractor','Beautiful tractor, good runner,
    exceptional build quality, contact for more info', 'false','http://www.todaysphoto.org/potd/rusty-old-tractor.jpg', 500 );

    INSERT INTO items (name, category, description, sold_status, image_url, price, seller)
    VALUES ('John Deere', 'Combine harvester','A quality combine harvester, good runner.', 'false',
      'http://photo.jellyfields.com/image/16364441463/z/rick-craig,watching-another-sunset,rural-truck-afternoon-rusty-combine-northdakota-masseyharris-nikond3200-internationalharvester-townercounty.jpg', 10000 );

      INSERT INTO items (name, category, description, sold_status, image_url, price, seller)
      VALUES ('unknown', 'Lawn mover','Decent lawn mower. In need of TLC, but I am sure it will run awesome again one day', 'false',
        'https://usercontent2.hubstatic.com/8890305_f520.jpg', 5 );

        INSERT INTO items (name, category, description, sold_status, image_url, price, seller)
        VALUES ('Toro', 'Racing Lawn mover','Quite a fast lawn mower. Cuts grass in half the time. Good for running away from wild animals', 'false',
          'http://www.theglobeandmail.com/news/british-columbia/article14631004.ece/BINARY/w620/gallery-lawnmowers1.JPG', 5 );
