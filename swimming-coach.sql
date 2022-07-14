# Create database
CREATE DATABASE swimming_coach;

# Use database
USE swimming_coach;

# Create table for students
CREATE TABLE students (
  student_id int unsigned auto_increment primary key,
  name varchar(100) not null,
  date_of_birth date not null,
  parent_id int unsigned not null
) engine = innodb;

# Create table for parents 
CREATE TABLE parents (
  parent_id int unsigned auto_increment primary key,
  name varchar(100) not null,
  contact_number varchar(10) not null,
  occupation varchar(100)
) engine = innodb;

# Create table for addresses
CREATE TABLE addresses (
  address_id int unsigned auto_increment primary key,
  block_number varchar(100) not null,
  street_name varchar(100) not null,
  postal_code varchar(100) not null,
  parent_id int unsigned
) engine = innodb;

# Create table for available_payment_types 
CREATE TABLE available_payment_types (
  available_payment_types_id int unsigned auto_increment primary key,
  payment_type varchar(255) not null,
  parent_id int unsigned not null
) engine = innodb;

# Create table for attendances
CREATE TABLE attendances (
  attendance_id int unsigned auto_increment primary key,
  student_id int unsigned not null,
  session_id int unsigned not null
) engine = innodb;

# Create table for sessions
CREATE TABLE sessions (
  session_id int unsigned auto_increment primary key,
  date_time datetime not null,
  location_id int unsigned not null
) engine = innodb;

# Create table for locations
CREATE TABLE locations (
  location_id mediumint unsigned auto_increment primary key,
  name varchar(100) not null,
  address varchar(255) not null
) engine = innodb;

# Create table for payments
CREATE TABLE payments (
  payment_id int unsigned auto_increment primary key,
  payment_mode varchar(255) not null,
  amount float unsigned not null,
  parent_id int unsigned not null,
  session_id int unsigned not null,
  student_id int unsigned not null
) engine = innodb;

ALTER TABLE students ADD constraint fk_students_parents
  foreign key (parent_id) references parents(parent_id);

ALTER TABLE addresses ADD constraint fk_addresses_parents
  foreign key (parent_id) references parents(parent_id);

ALTER TABLE available_payment_types ADD constraint fk_available_payment_types_parents
  foreign key (parent_id) references parents(parent_id);

ALTER TABLE attendances ADD constraint fk_attendances_students
  foreign key (student_id) references students(student_id);

ALTER TABLE attendances ADD constraint fk_attendances_sessions
  foreign key (session_id) references sessions(session_id);

ALTER TABLE sessions ADD constraint fk_sessions_locations
  foreign key (location_id) references locations(location_id);

ALTER TABLE payments ADD constraint fk_payments_parents
  foreign key (parent_id) references parents(parent_id);

ALTER TABLE payments ADD constraint fk_payments_sessions
  foreign key (session_id) references sessions(session_id);

ALTER TABLE payments ADD constraint fk_payments_students
  foreign key (student_id) references students(student_id);


----------------------------------------------

INSERT INTO parents (
  name, contact_number, occupation
) VALUES (
  "John", "123456789", "Taxi driver"
);

--- Insert multiple parents
INSERT INTO parents 
(name, contact_number, occupation)
VALUES 
  ("Mary", "12341234", "Teacher"),
  ("Snow", "12345123", "Doctor");

INSERT INTO locations (name, address)
VALUES ('Yishun Swimming Complex', 'Yishun Ave 4');

-- METHOD 1 of Creating a table with a foreign key
-- Create the table with the foreign key column but not setting it as a foreign key
CREATE TABLE addresses (
  address_id int unsigned auto_increment primary key,
  parent_id int unsigned NOT NULL,
  block_number varchar(6) NOT NULL,
  street_name varchar(255) NOT NULL,
  unit_number varchar(100) NOT NULL,
  postal_code varchar(10) NOT NULL
) engine = innodb;

-- Add in the foreign key relationship to the parent_id
-- ALTER TABLE <table name> ADD CONSTRAINT <name of contraint> FOREIGN KEY (<column of altered table>) REFERENCES <other table name>(<column of other table>)
-- Another syntax: addresses.parent_id will refer to parents.parent_id
-- NOTE: The name of the constraint must be UNIQUE throughout the database
ALTER TABLE addresses ADD CONSTRAINT fk_addresses_parents FOREIGN KEY(parent_id) REFERENCES parents(parent_id)

-- METHOD 2: Create and add foreign key at the same time
-- Note: mysql will auto create a constraint name for us in this case
CREATE TABLE students (
  student_id int unsigned auto_increment primary key,
  name varchar(100) NOT NULL,
  date_of_birth DATE NOT NULL,
  parent_id int unsigned not null,
  foreign key (parent_id) references parents(parent_id)
) engine = innodb;

INSERT INTO students (
  name, date_of_birth, parent_id
) VALUES (
  'Sally', '2010-12-22', 1
);

CREATE TABLE sessions (
  session_id int unsigned auto_increment primary key,
  datetime datetime not null,
  location_id mediumint unsigned not null,
  foreign key (location_id) references locations(location_id)
) engine = innodb;