/*
 * table for products + their possible colors, images, sizes.
 */
CREATE TABLE IF NOT EXISTS
  products (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    quantity INT DEFAULT 1 CHECK(quantity >= 0),
    availability BOOLEAN NOT NULL,
    item_sold INT NOT NULL DEFAULT 0, -- number of products sold
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
  );

CREATE TABLE IF NOT EXISTS  
  tags (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS tags_mapping (
    product_id INT,
    tag_id INT,
    PRIMARY KEY (product_id, tag_id),
    FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags (id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS
  colors (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL
  );

CREATE TABLE IF NOT EXISTS
  colors_mapping (
    product_id INT,
    color_id INT,
    PRIMARY KEY (product_id, color_id),
    FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (color_id) REFERENCES colors (id) ON DELETE CASCADE ON UPDATE CASCADE
  );

CREATE TABLE IF NOT EXISTS
  photos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    image VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE ON UPDATE CASCADE
  );

CREATE TABLE IF NOT EXISTS
  sizes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    size_name VARCHAR(20) NOT NULL UNIQUE
  );

CREATE TABLE IF NOT EXISTS
  sizes_mapping (
    product_id INT,
    size_id INT,
    PRIMARY KEY (product_id, size_id),
    FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (size_id) REFERENCES sizes (id) ON DELETE CASCADE ON UPDATE CASCADE
  );

-- ! END OF GENERIC PRODUCT TABLE
/*
 * subtables for the products table
 */
-- ! SPACESHIP TABLES
/*
TODO: add foreign key to the spaceparts of the ship, for a more detailed description of the ship!!!
 */
CREATE TABLE IF NOT EXISTS
  spaceships (
    product_id INT PRIMARY KEY,
    fuel_type VARCHAR(50) NOT NULL,
    capacity INT,
    speed INT NOT NULL,
    model VARCHAR(255) NOT NULL,
    size VARCHAR(255) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products (id)
  );

-- ! END OF SPACESHIP TABLES
-- ! SPACESUIT TABLES
/* CREATE TABLE IF NOT EXISTS
  spacesuits (
    product_id INT PRIMARY KEY,
    material VARCHAR(50),
    FOREIGN KEY (product_id) REFERENCES products (id)
  ); */

-- ! END OF SPACESUIT TABLES
/*
? queste si potrebbero anche omettere, da implementare come cosa facoltativa
? potremmo comunque lasciarli anche se a fine progetto non le usiamo che almeno sarebbe
? più completo il database, e potremmo giocarcelo come jolly all'orale per fare bella figura
? diciamo come una delle n funzionalità che il sito dovrebbe avere, ma che per ovvie ragioni non ha.

CREATE TABLE IF NOT EXISTS
  space_parts (
    product_id INT PRIMARY KEY,
    category VARCHAR(50),
    manufacturer VARCHAR(100),
    FOREIGN KEY (product_id) REFERENCES products (id)
  );

CREATE TABLE IF NOT EXISTS
  engines (
    product_id INT PRIMARY KEY,
    thrust_power DECIMAL(10, 2),
    fuel_efficiency DECIMAL(5, 2),
    FOREIGN KEY (product_id) REFERENCES products (id)
  );

CREATE TABLE IF NOT EXISTS
  navigation_systems (
    product_id INT PRIMARY KEY,
    gps_accuracy DECIMAL(5, 2),
    compatibility VARCHAR(100),
    FOREIGN KEY (product_id) REFERENCES products (id)
  );

CREATE TABLE IF NOT EXISTS
  life_support_systems (
    product_id INT PRIMARY KEY,
    oxygen_capacity INT,
    temperature_regulation BOOLEAN,
    FOREIGN KEY (product_id) REFERENCES products (id)
  );

CREATE TABLE IF NOT EXISTS
  spacecraft_components (
    product_id INT PRIMARY KEY,
    component_type VARCHAR(50),
    manufacturer VARCHAR(100),
    FOREIGN KEY (product_id) REFERENCES products (id)
  );
*/
-- ! END OF PRODUCT SUBTABLES/TABLES
/*
TODO: 
 */
CREATE TABLE IF NOT EXISTS
  users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );

CREATE TABLE IF NOT EXISTS user_details (
  user_id INT PRIMARY KEY,
  phone_number VARCHAR(20),
  profile_picture_url VARCHAR(255),
  birthdate DATE,
  bio TEXT,
  username VARCHAR(50) UNIQUE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS
  orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(50) DEFAULT 'Pending',
    FOREIGN KEY (user_id) REFERENCES users (id)
  );

CREATE TABLE IF NOT EXISTS
  order_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT DEFAULT 1 CHECK(quantity >= 0),
    subtotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders (id),
    FOREIGN KEY (product_id) REFERENCES products (id)
  );

CREATE TABLE IF NOT EXISTS
  reviews (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    product_id INT,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 10),
    title VARCHAR(255) NOT NULL,
    comment TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (product_id) REFERENCES products (id),
    UNIQUE (user_id, product_id)
  );

-- ! facoltive
CREATE TABLE IF NOT EXISTS
  addresses (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    address_line1 VARCHAR(255),
    address_line2 VARCHAR(255),
    city VARCHAR(100),
    postal_code VARCHAR(20),
    country VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES users (id)
  );

-- * user can have autologin in more than one device
CREATE TABLE IF NOT EXISTS
  sessions (
    user_id INT,
    session_token VARCHAR(255) PRIMARY KEY NOT NULL,
    expiration_date TIMESTAMP NOT NULL,
    remember_me BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users (id),
    UNIQUE(user_id, session_token)
  ); 

CREATE TABLE IF NOT EXISTS
  shopping_cart (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    product_id INT,
    quantity INT DEFAULT 1,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (product_id) REFERENCES products (id),
    UNIQUE (user_id, product_id) -- ! prevent duplicate entries (just have to change quantity value)
  );

/* CREATE TABLE IF NOT EXISTS
  wishlist (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    wishlist_token VARCHAR(255) UNIQUE,
    product_id INT,
    quantity INT DEFAULT 1,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (product_id) REFERENCES products (id),
    UNIQUE (user_id, product_id) -- ! prevent duplicate entries (just have to change quantity value)  
  );

CREATE TABLE IF NOT EXISTS
  wishlist_collaborators (
    id INT PRIMARY KEY AUTO_INCREMENT,
    wishlist_id INT,
    collaborator_id INT,
    can_edit BOOLEAN,
    FOREIGN KEY (wishlist_id) REFERENCES wishlist (id),
    FOREIGN KEY (collaborator_id) REFERENCES users (id),
    UNIQUE (collaborator_id, wishlist_id)
  ); */

/*
 * following tables are probably not implemented. just some thought for the future 
 */
/* -- ! changelog of what user do. it can be usefull to restore some data that users change by mistake
CREATE TABLE IF NOT EXISTS
  audit_trail (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT, -- User who made the change
    table_name VARCHAR(50) NOT NULL,
    record_id INT NOT NULL, -- ID of the modified record
    action VARCHAR(10) NOT NULL, -- 'INSERT', 'UPDATE', 'DELETE'
    old_data JSON, -- Old data before the change (for updates and deletes)
    new_data JSON, -- New data after the change (for inserts and updates)
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );

-- ! log of errors that occur in the application
CREATE TABLE IF NOT EXISTS
  error_log (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT, -- User who encountered the error (can be NULL)
    error_message TEXT NOT NULL,
    stack_trace TEXT, -- Detailed stack trace (if available)
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );

-- ! log of security events (error login, new device login, password change, etc.)
CREATE TABLE IF NOT EXISTS
  security_log (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT, -- User involved in the security event (can be NULL for system-level events)
    event_description VARCHAR(255) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );

-- ! log of performance events (slow queries, etc.) [very very very optional, we're not gonna do this for sure]
CREATE TABLE IF NOT EXISTS
  performance_log (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT, -- User (if applicable)
    action_description VARCHAR(255) NOT NULL,
    execution_time_ms INT, -- Execution time in milliseconds
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  );

-- ! log of user sessions (login, logout, etc.)
CREATE TABLE IF NOT EXISTS
  session_log (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT, -- User whose session is involved
    session_action VARCHAR(50) NOT NULL, -- 'Login', 'Logout', etc.
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
  ); */

/* CREATE VIEW spacesuits_detail_view AS
SELECT
    p.id AS product_id,
    p.name AS product_name,
    p.description AS product_description,
    p.price AS product_price,
    p.quantity AS product_quantity,
    p.availability AS product_availability,
    p.item_sold AS products_sold,
    pc.name AS color_name,
    pp.image AS product_image,
    ps.size_name AS size_name,
    ss.material AS spacesuit_material,
    AVG(r.rating) AS product_rating,
    p.created_at AS product_created_at,
    p.updated_at AS product_updated_at,
    t.name AS tag_name,
    
FROM
    products p
LEFT JOIN colors_mapping cm ON p.id = cm.product_id
LEFT JOIN colors pc ON cm.color_id = pc.id
LEFT JOIN photos pp ON p.id = pp.product_id
LEFT JOIN sizes_mapping sm ON p.id = sm.product_id
LEFT JOIN sizes ps ON sm.size_id = ps.id
LEFT JOIN reviews r ON p.id = r.product_id
LEFT JOIN tags_mapping tm ON p.id = tm.product_id
LEFT JOIN tags t ON tm.tag_id = t.id 
RIGHT JOIN spacesuits ss ON p.id = ss.product_id
GROUP BY p.id, s.size, pc.name, t.name_name; */
CREATE VIEW spaceships_detail_view AS
SELECT
    p.id AS product_id,
    p.name AS product_name,
    p.description AS product_description,
    p.price AS product_price,
    p.quantity AS product_quantity,
    p.availability AS product_availability,
    p.item_sold AS products_sold,
    pc.color_names AS color_names,
    pp.images AS product_images,
    ps.size_names AS size_names,
    s.fuel_type AS spaceship_fuel_type,
    s.capacity AS spaceship_capacity,
    s.speed AS spaceship_speed,
    s.model AS spaceship_model,
    AVG(r.rating) AS product_rating,
    pt.tag_names AS tag_names,
    latest_review.comment AS latest_comment, -- Add latest comment
    p.created_at AS product_created_at,
    p.updated_at AS product_updated_at
FROM
    products p
LEFT JOIN (
    SELECT product_id, GROUP_CONCAT(DISTINCT pc.name) AS color_names
    FROM colors_mapping cm
    LEFT JOIN colors pc ON cm.color_id = pc.id
    GROUP BY product_id
) pc ON p.id = pc.product_id
LEFT JOIN (
    SELECT product_id, GROUP_CONCAT(DISTINCT pp.image) AS images
    FROM photos pp
    GROUP BY product_id
) pp ON p.id = pp.product_id
LEFT JOIN (
    SELECT product_id, GROUP_CONCAT(DISTINCT ps.size_name) AS size_names
    FROM sizes_mapping sm
    LEFT JOIN sizes ps ON sm.size_id = ps.id
    GROUP BY product_id
) ps ON p.id = ps.product_id
LEFT JOIN reviews r ON p.id = r.product_id
LEFT JOIN (
    SELECT product_id, GROUP_CONCAT(DISTINCT t.name) AS tag_names
    FROM tags_mapping tm
    LEFT JOIN tags t ON tm.tag_id = t.id
    GROUP BY product_id
) pt ON p.id = pt.product_id
LEFT JOIN (
    SELECT r.product_id, r.comment
    FROM reviews r
    INNER JOIN (
        SELECT product_id, MAX(review_date) AS latest_review_date
        FROM reviews
        GROUP BY product_id
    ) latest ON r.product_id = latest.product_id AND r.review_date = latest.latest_review_date
) latest_review ON p.id = latest_review.product_id -- Join latest review
RIGHT JOIN spaceships s ON p.id = s.product_id
GROUP BY p.id, p.name, p.description, p.price, p.quantity, p.availability, p.item_sold, s.fuel_type, s.capacity, s.speed, s.model, p.created_at, p.updated_at, pp.images, latest_review.comment;




/*
  * INSERTO FOR THE TABLES
*/

INSERT INTO
  colors (name)
VALUES
  ('Red'),
  ('Blue'),
  ('Green'),
  ('Yellow'),
  ('Black'),
  ('White');

INSERT INTO
  sizes (size_name)
VALUES
  ('XXS'),
  ('XS'),
  ('S'),
  ('M'),
  ('L'),
  ('XL'),
  ('XXL'),
  ('XXXL');

INSERT INTO tags (name) VALUES ('Spaceship');
INSERT INTO tags (name) VALUES ('Spacecraft');
INSERT INTO tags (name) VALUES ('Interstellar Travel');
INSERT INTO tags (name) VALUES ('Space Exploration');
INSERT INTO tags (name) VALUES ('Alien Encounters');
INSERT INTO tags (name) VALUES ('Galactic Adventure');
INSERT INTO tags (name) VALUES ('Starship');
INSERT INTO tags (name) VALUES ('Futuristic Technology');
INSERT INTO tags (name) VALUES ('Extraterrestrial Life');
INSERT INTO tags (name) VALUES ('Deep Space');
INSERT INTO tags (name) VALUES ('Space Mission');
INSERT INTO tags (name) VALUES ('Astroengineering');
INSERT INTO tags (name) VALUES ('Intergalactic Travel');
INSERT INTO tags (name) VALUES ('Outer Space');
INSERT INTO tags (name) VALUES ('Space Adventure');

-- ! SPACESUITS INSERTS

-- Product B
/* INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Spacesuit Product B', 'Description for Spacesuit Product B', 59.99, 15, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 2);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 1);
INSERT INTO spacesuits (product_id, material) VALUES (@new_product_id, 'Advanced Fabric');

-- Continue the pattern for Spacesuit Products C to J

-- Product C
INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Spacesuit Product C', 'Description for Spacesuit Product C', 69.99, 20, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 3);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 3);
INSERT INTO spacesuits (product_id, material) VALUES (@new_product_id, 'Carbon Fiber');
 */
-- ! SPACESHIP INSERTS

-- Product B
/* INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Product B', 'Description for Product B', 24.99, 10, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 3);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 2);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 1);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Advanced Fuel', 120, 2500, 'Model B', 'Medium');

-- Product C

INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Product C', 'Description for Product C', 49.99, 20, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 2);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 5);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 7);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 12);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Quantum Fuel', 300, 4000, 'Model X', 'Large');

-- Product D

INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Product D', 'Description for Product D', 74.99, 15, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 4);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 7);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 2);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 9);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Plasma Drive', 200, 3500, 'Model Y', 'Extra Large');

-- Product E
INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Product E', 'Description for Product E', 99.99, 30, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 6);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 3);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 5);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Hyperdrive', 400, 5000, 'Model Z', 'Extra Large');

-- Product F
INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Product F', 'Description for Product F', 149.99, 25, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 1);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 8);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 8);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Warp Drive', 500, 6000, 'Model Alpha', 'Extra Extra Large');

-- Product G
INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Product G', 'Description for Product G', 64.99, 18, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 3);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 6);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 3);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 11);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Ion Propulsion', 250, 4500, 'Model Delta', 'Large');

-- Product H
INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Product H', 'Description for Product H', 39.99, 22, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 5);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 2);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 4);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 10);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Antimatter Drive', 300, 5500, 'Model Gamma', 'Medium');

-- Product I
INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Product I', 'Description for Product I', 129.99, 12, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 1);
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 2);
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 3);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 4);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 7);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 1);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 2);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 3);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 4);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Plasma Drive', 350, 4500, 'Model Omega', 'Extra Large');

-- Product J
INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Product J', 'Description for Product J', 89.99, 15, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 2);
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 4);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 3);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 6);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 5);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 6);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 7);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 8);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Quantum Fuel', 280, 3800, 'Model Beta', 'Large');

-- Product K
INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Product K', 'Description for Product K', 199.99, 8, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 3);
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 5);
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 6);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 2);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 5);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 9);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 10);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 11);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 12);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Warp Drive', 600, 7000, 'Model Sigma', 'Extra Extra Large');

-- Product L
INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Product L', 'Description for Product L', 149.99, 20, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 1);
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 4);
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 6);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 4);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 7);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 1);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 5);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 9);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 12);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Hyperdrive', 450, 5500, 'Model Epsilon', 'Extra Large'); */


INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Star Voyager B-3000 Advanced Shuttle', 'The Star Voyager B-3000 is an advanced shuttle designed for interstellar travel. Equipped with the latest in advanced fuel technology, this medium-sized ship features a capacity of 120 passengers, speeds up to 2500 km/h, and Model B engineering for reliable performance. Ideal for both personal and commercial use, it offers spacious interiors and state-of-the-art navigation systems.', 24.99, 10, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 3);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 2);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 1);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Advanced Fuel', 120, 2500, 'Model B', 'Medium');

INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Quantum Cruiser X-5000', 'Experience the pinnacle of space travel with the Quantum Cruiser X-5000. This large-sized spaceship is powered by Quantum Fuel, providing an impressive capacity of 300 passengers and reaching speeds of up to 4000 km/h. The Model X design ensures top-tier comfort and safety, making it the perfect choice for long-distance voyages and intergalactic exploration.', 49.99, 20, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 2);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 5);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 7);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 12);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Quantum Fuel', 300, 4000, 'Model X', 'Large');

INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Plasma Explorer Y-7500', 'The Plasma Explorer Y-7500 is engineered for extra-large missions and interstellar adventures. Featuring a powerful Plasma Drive, this ship accommodates up to 200 passengers and achieves speeds of 3500 km/h. With the latest Model Y enhancements, it promises superior performance, safety, and luxury, making it a top choice for space enthusiasts and commercial enterprises alike.', 74.99, 15, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 4);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 7);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 2);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 9);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Plasma Drive', 200, 3500, 'Model Y', 'Extra Large');

INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Hyperdrive Starship Z-9000', 'The Hyperdrive Starship Z-9000 represents the future of space travel. Equipped with cutting-edge Hyperdrive technology, this extra-large vessel can transport 400 passengers at incredible speeds of up to 5000 km/h. Model Z’s innovative design and spacious interiors ensure a luxurious and safe journey, perfect for extended interstellar expeditions.', 99.99, 30, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 6);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 3);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 5);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Hyperdrive', 400, 5000, 'Model Z', 'Extra Large');

INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Warp Drive Transport Alpha', 'The Warp Drive Transport Alpha is a marvel of modern engineering, designed for extra-extra-large capacities and extraordinary speeds. Featuring the revolutionary Warp Drive, it can carry 500 passengers and achieve speeds of 6000 km/h. Model Alpha’s advanced technology and robust build make it ideal for commercial space lines and ambitious explorers.', 149.99, 25, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 1);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 8);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 8);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Warp Drive', 500, 6000, 'Model Alpha', 'Extra Extra Large');

INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Ion Propulsion Freighter Delta', 'The Ion Propulsion Freighter Delta is designed for efficient long-range travel. This large freighter can carry up to 250 passengers and reaches speeds of 4500 km/h with its Ion Propulsion system. The Model Delta ensures high efficiency and reliability, making it a preferred choice for cargo and passenger transport across the galaxy.', 64.99, 18, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 3);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 6);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 3);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 11);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Ion Propulsion', 250, 4500, 'Model Delta', 'Large');

INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Antimatter Drive Cruiser Gamma', 'The Antimatter Drive Cruiser Gamma offers exceptional speed and capacity for medium-sized voyages. Powered by Antimatter Drive technology, it can transport 300 passengers at speeds of up to 5500 km/h. The Model Gamma combines efficiency, safety, and comfort, making it ideal for both private and commercial space travel.', 39.99, 22, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 5);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 2);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 4);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 10);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Antimatter Drive', 300, 5500, 'Model Gamma', 'Medium');

INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Plasma Drive Explorer Omega', 'The Plasma Drive Explorer Omega is an extra-large spaceship designed for extensive explorations. With a capacity of 350 passengers and speeds of 4500 km/h, its Plasma Drive ensures powerful and efficient travel. Model Omega’s cutting-edge features and spacious design make it a top choice for both commercial and personal space missions.', 129.99, 12, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 1);
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 2);
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 3);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 4);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 7);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 1);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 2);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 3);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 4);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Plasma Drive', 350, 4500, 'Model Omega', 'Extra Large');

INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Quantum Freighter Beta', 'The Quantum Freighter Beta is built for long-haul missions and extensive transport needs. Featuring Quantum Fuel technology, it can carry 280 passengers and reach speeds of 3800 km/h. The Model Beta provides reliable performance, making it an excellent choice for large-scale commercial operations and deep space explorations.', 89.99, 15, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 2);
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 4);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 3);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 6);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 5);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 6);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 7);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 8);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Quantum Fuel', 280, 3800, 'Model Beta', 'Large');

INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Warp Drive Cruiser Sigma', 'The Warp Drive Cruiser Sigma offers unparalleled speed and luxury. Designed for extra-extra-large capacities, it can transport 600 passengers at incredible speeds of 7000 km/h. The Model Sigma’s advanced Warp Drive technology ensures smooth and efficient travel, making it perfect for commercial airlines and luxury space cruises.', 199.99, 8, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 3);
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 5);
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 6);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 2);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 5);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 9);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 10);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 11);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 12);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Warp Drive', 600, 7000, 'Model Sigma', 'Extra Extra Large');

INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Hyperdrive Explorer Epsilon', 'The Hyperdrive Explorer Epsilon is designed for extensive explorations and intergalactic missions. This extra-large ship features a Hyperdrive engine, allowing it to carry 450 passengers at speeds of up to 5500 km/h. Model Epsilon’s advanced design and spacious interiors provide comfort and reliability for long-distance travel.', 149.99, 20, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 1);
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 4);
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 6);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 4);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 7);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 1);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 5);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 9);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 12);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Hyperdrive', 450, 5500, 'Model Epsilon', 'Extra Large');

INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Galactic Pioneer M-8000 Explorer', 'The Galactic Pioneer M-8000 Explorer is the perfect choice for ambitious space adventurers. This medium-sized spaceship features advanced propulsion technology, allowing it to reach speeds of up to 2600 km/h. With a capacity of 180 passengers, the Model M-8000 provides ample space and comfort, complete with cutting-edge navigation systems and safety features for reliable interstellar travel.', 119.99, 12, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 4);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 3);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 1);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 8);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Fusion Drive', 180, 2600, 'Model M-8000', 'Medium');

INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Stellar Navigator N-9500', 'The Stellar Navigator N-9500 is a large spaceship designed for deep-space exploration. Powered by Quantum Fuel, it offers a capacity of 350 passengers and a maximum speed of 4200 km/h. The Model N-9500’s innovative design includes luxurious interiors and advanced life-support systems, making it ideal for long-term missions and scientific expeditions.', 139.99, 20, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 5);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 6);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 4);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 10);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Quantum Fuel', 350, 4200, 'Model N-9500', 'Large');

INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Cosmic Voyager O-7200', 'The Cosmic Voyager O-7200 is designed for medium-sized space journeys, offering a perfect blend of speed and capacity. With a top speed of 3200 km/h and a passenger capacity of 200, it features a Plasma Drive for efficient travel. The Model O-7200 is equipped with state-of-the-art navigation and safety systems, ensuring a smooth and comfortable journey for all onboard.', 89.99, 25, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 2);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 4);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 2);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 7);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Plasma Drive', 200, 3200, 'Model O-7200', 'Medium');

INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Interstellar Transporter P-9900', 'The Interstellar Transporter P-9900 is a large vessel built for extensive passenger transport and long-haul travel. With a capacity of 400 passengers and a speed of 4500 km/h, it utilizes advanced Ion Propulsion technology. The Model P-9900 features luxurious cabins, entertainment systems, and comprehensive safety measures, making it perfect for commercial space travel.', 159.99, 10, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 3);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 7);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 5);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 9);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Ion Propulsion', 400, 4500, 'Model P-9900', 'Large');

INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Nebula Cruiser Q-7000', 'The Nebula Cruiser Q-7000 offers exceptional performance for large-scale space travel. Equipped with Hyperdrive technology, it can carry 500 passengers at speeds of 4700 km/h. The Model Q-7000’s advanced features include spacious interiors, modern navigation systems, and robust safety protocols, making it ideal for both commercial and exploratory missions.', 189.99, 15, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 4);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 8);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 6);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 11);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Hyperdrive', 500, 4700, 'Model Q-7000', 'Large');

INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Aurora Freighter R-8500', 'The Aurora Freighter R-8500 is engineered for extensive cargo and passenger transport. With a capacity of 600 passengers and speeds up to 5300 km/h, it utilizes Antimatter Drive technology. The Model R-8500 is designed for efficiency and reliability, featuring advanced cargo handling systems and luxurious passenger accommodations.', 209.99, 8, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 1);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 5);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 1);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 12);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Antimatter Drive', 600, 5300, 'Model R-8500', 'Extra Large');

INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Galaxy Explorer S-6000', 'The Galaxy Explorer S-6000 is designed for medium-sized missions, offering a balance of speed and capacity. Featuring advanced Fusion Drive technology, it can transport 220 passengers at speeds of up to 3800 km/h. The Model S-6000 provides state-of-the-art navigation and safety systems, ensuring a smooth and secure journey for all space travelers.', 99.99, 18, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 6);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 3);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 4);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 8);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Fusion Drive', 220, 3800, 'Model S-6000', 'Medium');

INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Lunar Freighter T-5000', 'The Lunar Freighter T-5000 is perfect for large-scale space transport. With a capacity of 400 passengers and a maximum speed of 4500 km/h, it features cutting-edge Ion Propulsion technology. The Model T-5000’s robust design includes advanced cargo handling and life-support systems, making it ideal for both commercial and long-distance space missions.', 159.99, 20, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 2);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 6);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 5);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 9);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Ion Propulsion', 400, 4500, 'Model T-5000', 'Large');

/* add from here */

INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Starliner U-4400', 'The Starliner U-4400 is a medium-sized spaceship crafted for optimal interstellar travel. Equipped with advanced Fusion Drive technology, it boasts a top speed of 3400 km/h and a capacity of 250 passengers. The U-4400’s sleek design incorporates state-of-the-art navigation and safety systems, ensuring both comfort and security on long voyages.', 129.99, 15, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 1);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 4);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 2);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 10);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Fusion Drive', 250, 3400, 'Model U-4400', 'Medium');

INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Solar Cruiser V-6000', 'The Solar Cruiser V-6000 is designed for large-scale explorations and transport missions. With a passenger capacity of 450 and a maximum speed of 5000 km/h, it features Hyperdrive technology for unmatched efficiency. The Model V-6000 offers luxurious interiors, advanced navigation systems, and comprehensive safety features, making it ideal for long-distance travel.', 179.99, 10, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 3);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 7);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 4);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 8);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Hyperdrive', 450, 5000, 'Model V-6000', 'Large');

INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Nebula Explorer W-7200', 'The Nebula Explorer W-7200 is perfect for medium-range space missions. Powered by advanced Quantum Fuel, it offers a capacity of 280 passengers and a speed of 4000 km/h. The Model W-7200’s innovative design includes modern navigation systems, safety protocols, and comfortable interiors, making it an excellent choice for scientific and exploratory missions.', 149.99, 18, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 5);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 3);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 3);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 7);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Quantum Fuel', 280, 4000, 'Model W-7200', 'Medium');


INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Galaxy Transporter X-8800', 'The Galaxy Transporter X-8800 is engineered for extensive passenger and cargo transport. Featuring advanced Ion Propulsion technology, it can accommodate 500 passengers and reach speeds of up to 5200 km/h. The Model X-8800 boasts luxurious amenities, cutting-edge navigation, and comprehensive safety systems, ideal for commercial and exploratory missions.', 199.99, 12, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 2);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 8);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 6);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 9);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Ion Propulsion', 500, 5200, 'Model X-8800', 'Large');

INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Cosmos Voyager Y-6600', 'The Cosmos Voyager Y-6600 is a top-tier spaceship designed for long-distance travel. Equipped with Antimatter Drive technology, it offers a capacity of 350 passengers and a maximum speed of 4500 km/h. The Model Y-6600’s sophisticated design includes spacious cabins, advanced life-support systems, and robust safety features, ensuring a comfortable and secure journey.', 159.99, 20, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 1);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 6);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 5);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 11);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Antimatter Drive', 350, 4500, 'Model Y-6600', 'Large');

INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Orion Freighter Z-9900', 'The Orion Freighter Z-9900 is designed for heavy-duty transport missions, featuring Warp Drive technology for superior efficiency. With a capacity of 700 passengers and speeds up to 6000 km/h, the Model Z-9900 offers spacious interiors, advanced cargo management systems, and state-of-the-art safety protocols, making it perfect for large-scale commercial and exploratory missions.', 249.99, 10, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 3);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 5);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 1);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 8);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Warp Drive', 700, 6000, 'Model Z-9900', 'Extra Large');

INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Intergalactic Explorer AA-3000', 'The Intergalactic Explorer AA-3000 is perfect for medium-range exploratory missions. Utilizing advanced Plasma Drive technology, it can carry 220 passengers at speeds of up to 3600 km/h. The Model AA-3000’s innovative design includes modern navigation systems, comprehensive safety features, and comfortable accommodations, making it ideal for both scientific and commercial explorations.', 119.99, 18, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 4);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 4);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 2);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 10);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Plasma Drive', 220, 3600, 'Model AA-3000', 'Medium');

INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Stellar Freighter BB-5000', 'The Stellar Freighter BB-5000 is designed for extensive transport missions. Featuring Fusion Drive technology, it can transport 450 passengers and reach speeds of up to 4800 km/h. The Model BB-5000’s robust design includes spacious interiors, advanced navigation systems, and comprehensive safety measures, making it perfect for large-scale commercial and exploratory missions.', 189.99, 12, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 2);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 7);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 3);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 9);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Fusion Drive', 450, 4800, 'Model BB-5000', 'Large');

INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Galactic Voyager CC-6600', 'The Galactic Voyager CC-6600 is engineered for long-distance travel, equipped with Hyperdrive technology. It can carry 400 passengers and reach speeds of up to 5000 km/h. The Model CC-6600’s sophisticated design includes luxurious interiors, advanced life-support systems, and robust safety features, ensuring a comfortable and secure journey.', 219.99, 15, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 1);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 6);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 5);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 8);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Hyperdrive', 400, 5000, 'Model CC-6600', 'Large');

INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Orion Transporter DD-8000', 'The Orion Transporter DD-8000 is designed for heavy-duty transport missions, featuring advanced Antimatter Drive technology. It can accommodate 500 passengers and reach speeds of up to 5800 km/h. The Model DD-8000’s robust design includes spacious interiors, advanced cargo management systems, and comprehensive safety protocols, making it perfect for large-scale commercial and exploratory missions.', 249.99, 10, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 3);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 5);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 1);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 11);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Antimatter Drive', 500, 5800, 'Model DD-8000', 'Extra Large');

INSERT INTO products (name, description, price, quantity, availability, item_sold)
VALUES ('Cosmos Freighter EE-9000', 'The Cosmos Freighter EE-9000 is the ultimate spaceship for extensive transport missions. Featuring advanced Warp Drive technology, it can transport 600 passengers and reach speeds of up to 6500 km/h. The Model EE-9000’s luxurious design includes spacious interiors, advanced navigation systems, and comprehensive safety measures, making it perfect for large-scale commercial and exploratory missions.', 299.99, 8, true, 0);
SET @new_product_id = LAST_INSERT_ID();
INSERT INTO colors_mapping (product_id, color_id) VALUES (@new_product_id, 2);
INSERT INTO sizes_mapping (product_id, size_id) VALUES (@new_product_id, 8);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 3);
INSERT INTO tags_mapping (product_id, tag_id) VALUES (@new_product_id, 12);
INSERT INTO spaceships (product_id, fuel_type, capacity, speed, model, size)
VALUES (@new_product_id, 'Warp Drive', 600, 6500, 'Model EE-9000', 'Extra Large');




/*esempio inserimento foto. caricarle in client/public/img*/

INSERT INTO `photos`( `product_id`, `image`) VALUES (1, 'falcon.jpeg');
INSERT INTO `photos`( `product_id`, `image`) VALUES (28, 'falcon.jpeg');



-- ! SOME USEFULL TRIGGERS
CREATE TRIGGER update_availability BEFORE
UPDATE ON products FOR EACH ROW
SET
  NEW.availability = IF (NEW.quantity <= 0, FALSE, TRUE);

-- ! END OF TRIGGERS