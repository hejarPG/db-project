CREATE TABLE descriptive_answer(
    order_id INT,
    question_id INT,
    answer TEXT,
    created_at      TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (order_id, question_id),
    FOREIGN KEY (order_id) REFERENCES "order"(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES question(id) ON DELETE CASCADE
);

CREATE TABLE numeric_answer(
    order_id    INT,
    question_id INT,
    answer      REAL,
    is_nullable BOOLEAN     DEFAULT FALSE,
    created_at  TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (order_id, question_id),
    FOREIGN KEY (order_id)    REFERENCES "order"(id)      ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES question(id)   ON DELETE CASCADE
);

CREATE TABLE multiple_choice_answer(
    order_id int,
    question_id int,
    choice_id int,
    created_at      TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (order_id, question_id, choice_id),
    FOREIGN KEY (order_id) REFERENCES "order"(id) ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES question(id) ON DELETE CASCADE,
    FOREIGN KEY (choice_id) REFERENCES choice(id) ON DELETE CASCADE
)