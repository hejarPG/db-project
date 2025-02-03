CREATE TABLE category(
	id 			SERIAL 			PRIMARY KEY,
	name		VARCHAR(255)  	NOT NULL,
	image_uri	TEXT,
	max_price	DECIMAL(12, 2),
	min_price	DECIMAL(12, 2),
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE subcategory(
	category_id INT,
	name		VARCHAR(255),
	image_uri	TEXT,

	PRIMARY KEY (category_id, name),
	FOREIGN KEY (category_id) REFERENCES category(id) ON DELETE CASCADE,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE service(
	id 					SERIAL 			PRIMARY KEY,
	category_id 		INT,
	subcategory_name	VARCHAR(255),
	name 				VARCHAR(255) 	NOT NULL,
	description 		TEXT,
	available_at		avalable_palce_enum,
	image_uri			TEXT,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

	UNIQUE (category_id, subcategory_name, name),
	FOREIGN KEY (category_id, subcategory_name) REFERENCES subcategory(category_id, name)
);

-- DROP TABLE service CASCADE;
-- DROP TABLE subcategory CASCADE;
-- DROP TABLE category CASCADE;

-- SELECT * FROM service