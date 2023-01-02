CREATE type CONS_STATE AS ENUM (
    'to do',
    'designing',
    'sculpting',
    'crafting',
    'painting',
    'forging',
    'finished'
);


CREATE TABLE IF NOT EXISTS country (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        surface_area INTEGER NOT NULL
    );

CREATE TABLE IF NOT EXISTS garage (
        id VARCHAR(3) PRIMARY KEY,
        street_address VARCHAR(255) NOT NULL,
        slots SMALLINT NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT NOW(),
        updated_at TIMESTAMP NOT NULL DEFAULT NOW()
    );

CREATE TABLE IF NOT EXISTS sled_model (
        id SERIAL PRIMARY KEY,
        manufacturer VARCHAR(255) NOT NULL,
        code VARCHAR(255) NOT NULL UNIQUE
    );
CREATE TABLE IF NOT EXISTS sled (
        id SERIAL PRIMARY KEY,
        buy_date TIMESTAMP NOT NULL,
        garage_id VARCHAR(3) NOT NULL,
        model_id INTEGER NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT NOW(),
        updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
        FOREIGN KEY (garage_id) REFERENCES garage (id),
        FOREIGN KEY (model_id) REFERENCES sled_model (id)
    );

CREATE TABLE IF NOT EXISTS delegate (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        surname VARCHAR(255) NOT NULL,
        wage REAL NOT NULL,
        working_from DATE NOT NULL DEFAULT NOW(),
        working_to DATE DEFAULT NULL,
        birth_date DATE NOT NULL,
        country_id INTEGER NOT NULL,
        sled_id INTEGER NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT NOW(),
        updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
        FOREIGN KEY (country_id) REFERENCES country (id),
        FOREIGN KEY (sled_id) REFERENCES sled (id),
        CHECK (working_from < working_to),
        CHECK (wage > 0)
    );
CREATE TABLE IF NOT EXISTS reindeer (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        birth_date DATE NOT NULL,
        death_date DATE DEFAULT NULL,
        sled_id INTEGER NOT NULL,
        father_id INTEGER,
        mother_id INTEGER,
        created_at TIMESTAMP NOT NULL DEFAULT NOW(),
        updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
        FOREIGN KEY (sled_id) REFERENCES sled (id),
        FOREIGN KEY (father_id) REFERENCES reindeer (id),
        FOREIGN KEY (mother_id) REFERENCES reindeer (id),
        CHECK(death_date > birth_date)
    );

CREATE TABLE IF NOT EXISTS child (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        surname VARCHAR(255) NOT NULL,
        birth_date DATE NOT NULL,
        street VARCHAR(255) NOT NULL,
        city VARCHAR(255) NOT NULL,
        zip VARCHAR(255) NOT NULL,
        country_id INTEGER NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT NOW(),
        updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
        FOREIGN KEY (country_id) REFERENCES country (id)
    );
CREATE TABLE IF NOT EXISTS period_of_goodness (
        id SERIAL PRIMARY KEY,
        good_from SMALLINT NOT NULL,
        good_to SMALLINT DEFAULT NULL,
        child_id INTEGER NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT NOW(),
        updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
        FOREIGN KEY (child_id) REFERENCES child (id),
        CHECK (good_to > good_from)
    );

CREATE TABLE IF NOT EXISTS delivery (
        id SERIAL PRIMARY KEY,
        leaving_time TIMESTAMP DEFAULT NULL,
        delivery_time TIMESTAMP DEFAULT NULL,
        delegate_id INTEGER NOT NULL,
        child_id INTEGER NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT NOW(),
        updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
        FOREIGN KEY (delegate_id) REFERENCES delegate (id),
        FOREIGN KEY (child_id) REFERENCES child (id),
        CHECK (leaving_time < delivery_time)
    );

CREATE TABLE IF NOT EXISTS workshop (
        id VARCHAR(3) PRIMARY KEY,
        street_address VARCHAR(255) NOT NULL,
        capacity INTEGER NOT NULL DEFAULT 0,
        open_at TIME NOT NULL,
        close_at TIME NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT NOW(),
        updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
        CHECK (open_at < close_at)
    );
CREATE TABLE IF NOT EXISTS elf (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        surname VARCHAR(255) NOT NULL,
        wage REAL NOT NULL,
        working_from DATE NOT NULL,
        working_to DATE DEFAULT NULL,
        birth_date DATE NOT NULL,
        workshop_id VARCHAR(3) NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT NOW(),
        updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
        FOREIGN KEY (workshop_id) REFERENCES workshop (id),
        CHECK (wage > 0),
        CHECK (working_from < working_to)
    );

CREATE TABLE IF NOT EXISTS gift (
        id SERIAL PRIMARY KEY,
        construction_state CONS_STATE NOT NULL,
        name VARCHAR(100) NOT NULL,
        delivery_id INTEGER NOT NULL,
        elf_id INTEGER NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT NOW(),
        updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
        FOREIGN KEY (delivery_id) REFERENCES delivery (id),
        FOREIGN KEY (elf_id) REFERENCES elf (id)
    );

CREATE TABLE IF NOT EXISTS warehouse (
        id VARCHAR(3) PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        streetAddress VARCHAR(255) NOT NULL,
        open_at TIME NOT NULL,
        close_at TIME NOT NULL,
        capacity INTEGER NOT NULL DEFAULT 0,
        created_at TIMESTAMP NOT NULL DEFAULT NOW(),
        updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
        CHECK (open_at < close_at)
    );

CREATE TABLE IF NOT EXISTS supplier (
        id SERIAL PRIMARY KEY,
        company_name VARCHAR(255) NOT NULL,
        street VARCHAR(255) NOT NULL,
        city VARCHAR(255) NOT NULL,
        country_id INTEGER NOT NULL,
        zip VARCHAR(7) NOT NULL,
        phone VARCHAR(15) NOT NULL,
        email VARCHAR(255) NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT NOW(),
        updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
        FOREIGN KEY (country_id) REFERENCES country (id)
    );

CREATE TABLE IF NOT EXISTS material_category (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        warehouse_id VARCHAR(3) NOT NULL,
        supplier_id INTEGER NOT NULL,
        FOREIGN KEY (warehouse_id) REFERENCES warehouse (id),
        FOREIGN KEY (supplier_id) REFERENCES supplier (id)
    );

CREATE TABLE IF NOT EXISTS material (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        stock INTEGER NOT NULL DEFAULT 0,
        category_id INTEGER NOT NULL,
        unit_cost INTEGER NOT NULL,
        created_at TIMESTAMP NOT NULL DEFAULT NOW(),
        updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
        FOREIGN KEY (category_id) REFERENCES material_category (id),
        CHECK (stock >= 0),
        CHECK (unit_cost >= 0)
    );

CREATE TABLE IF NOT EXISTS gift_material (
        id SERIAL PRIMARY KEY,
        material_quantity INTEGER NOT NULL DEFAULT 0,
        unit_of_measurement VARCHAR(64) NOT NULL,
        gift_id INTEGER NOT NULL,
        material_id INTEGER NOT NULL,
        FOREIGN KEY (gift_id) REFERENCES gift (id),
        FOREIGN KEY (material_id) REFERENCES material (id),
        CHECK (material_quantity > 0)
    );
