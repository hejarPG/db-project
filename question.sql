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
