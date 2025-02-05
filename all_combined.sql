CREATE TABLE province(
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    capital_id INT NOT NULL,
    location POINT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE city(
    id          SERIAL          PRIMARY KEY,
    name        VARCHAR(255)    NOT NULL,
    province_id INT             NOT NULL,
    location                    POINT,
    created_at  TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (province_id) REFERENCES province(id) ON DELETE CASCADE
);

CREATE TABLE certificate(
    id                      SERIAL          PRIMARY KEY,
    title                   VARCHAR(255)    NOT NULL,
    description             TEXT,
    issued_by               VARCHAR(255),
    validity_period_in_year SMALLINT,
    background_uri          TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE specialist_service_certificate(
    service_id  INT,
    specialist_id INT,
    certificate_id INT,
    is_certified BOOLEAN,
    expires_in DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (specialist_id, service_id, certificate_id),
    FOREIGN KEY (service_id, specialist_id) REFERENCES specialist_service(specialist_id, service_id) ON DELETE CASCADE,
    FOREIGN KEY (certificate_id)            REFERENCES certificate(id) ON DELETE CASCADE
);

CREATE TYPE available_place_enum AS ENUM('customer', 'specialist', 'both');

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
	available_at		available_place_enum,
	image_uri			TEXT,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

	UNIQUE (category_id, subcategory_name, name),
	FOREIGN KEY (category_id, subcategory_name) REFERENCES subcategory(category_id, name)
);


CREATE TYPE sex_enum AS ENUM('male', 'female');

CREATE TABLE specialist(
    id                  SERIAL          PRIMARY KEY,
    first_name          VARCHAR(100)    NOT NULL,
    last_name           VARCHAR(100)    NOT NULL,
    phone_number        VARCHAR(20)     UNIQUE NOT NULL,
    sex                 sex_enum,
    image_uri           TEXT,
    city_id             INT,
    location            POINT,
    operating_radius    SMALLINT        CHECK(operating_radius > 0),
    service_category_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (city_id)               REFERENCES city(id)     ON DELETE SET NULL,
    FOREIGN KEY (service_category_id)   REFERENCES category(id) ON DELETE SET NULL
);


CREATE TABLE specialist_service(
    service_id      INT NOT NULL,
    specialist_id   INT NOT NULL,
    avalable_at     available_place_enum,
    offered_price   DECIMAL(12, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (service_id, specialist_id),
    FOREIGN KEY (service_id)    REFERENCES service(id)      ON DELETE CASCADE,
    FOREIGN KEY (specialist_id) REFERENCES specialist(id)   ON DELETE CASCADE
);



CREATE TYPE question_type_enum AS ENUM('descriptive', 'numeric', 'multiple choice');

CREATE TABLE question(
    id                          SERIAL  PRIMARY KEY,
    service_id                  INT     NOT NULL,
    text                        TEXT    NOT NULL,
    ordering                    SMALLINT,
    type                        question_type_enum,
    is_multiple_answer_allowed  BOOLEAN,
    created_at                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE choice (
    id          SERIAL      PRIMARY KEY,
    question_id INT         NOT NULL,
    text        TEXT,
    created_at  TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (question_id) REFERENCES question(id) ON DELETE CASCADE
);

CREATE TABLE customer(
    id              SERIAL          PRIMARY KEY,
    first_name      VARCHAR(255)    NOT NULL,
    last_name       VARCHAR(255)    NOT NULL,
    phone_number    VARCHAR(20)     UNIQUE NOT NULL,
    password        VARCHAR(72)     NOT NULL,
    city_id         INT,
    sex             sex_enum,
    birthdate       DATE,
    image_uri       TEXT,
    is_active       BOOLEAN         DEFAULT TRUE,
    created_at                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at                  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (city_id) REFERENCES city(id) ON DELETE SET NULL
);

