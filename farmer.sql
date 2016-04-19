create database farmerapp
  \c farmerapp


  CREATE TABLE items (
    id SERIAL4 PRIMARY KEY,
    name VARCHAR(100),
    category VARCHAR(100),
    description VARCHAR(1000),
    sold_status VARCHAR(100) NOT NULL,
    Image_url VARCHAR (500),
    price VARCHAR (100)
  );


  INSERT INTO items (name, category, description, sold_status, image_url, price)
  VALUES ('McCormick Farmall', 'tractor','Beautiful tractor, good runner,
    exceptional build quality, contact for more info', 'false','http://www.todaysphoto.org/potd/rusty-old-tractor.jpg', 500 );

    INSERT INTO items (name, category, description, sold_status, image_url, price)
    VALUES ('John Deere', 'Combine harvester','A quality combine harvester, good runner.', 'false',
      'http://photo.jellyfields.com/image/16364441463/z/rick-craig,watching-another-sunset,rural-truck-afternoon-rusty-combine-northdakota-masseyharris-nikond3200-internationalharvester-townercounty.jpg', 10000 );

      CREATE TABLE users (
        id SERIAL4 PRIMARY KEY,
        user_name VARCHAR (100) NOT NULL
        email VARCHAR(60) NOT NULL,
        password_digest VARCHAR(400) NOT NULL
      );
