CREATE TABLE IF NOT EXISTS DiseaseType (
  id serial,
  description varchar(140) NOT NULL,
  PRIMARY KEY(id)
);
CREATE TABLE IF NOT EXISTS Country (
  cname varchar(50) NOT NULL UNIQUE,
  population bigint NOT NULL,
  PRIMARY KEY(cname)
);
CREATE TABLE IF NOT EXISTS Disease (
  disease_code varchar(50) NOT NULL UNIQUE,
  pathogen varchar(20) NOT NULL,
  description varchar(140) NOT NULL,
  id int NOT NULL,
  PRIMARY KEY(disease_code),
  FOREIGN KEY(id) REFERENCES DiseaseType(id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS Discover (
  cname varchar(50) NOT NULL,
  disease_code varchar(50) NOT NULL,
  first_enc_date date NOT NULL,
  FOREIGN KEY(disease_code) REFERENCES Disease(disease_code) ON DELETE CASCADE,
  FOREIGN KEY(cname) REFERENCES Country(cname) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS Users (
  email varchar(60) NOT NULL UNIQUE,
  name varchar(30) NOT NULL,
  surname varchar(40) NOT NULL,
  salary int NOT NULL,
  phone varchar(20) NOT NULL,
  cname varchar(50) NOT NULL,
  PRIMARY KEY(email),
  FOREIGN KEY(cname) REFERENCES Country(cname) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS PublicServant(
  email varchar(60) NOT NULL UNIQUE,
  department varchar(50) NOT NULL,
  FOREIGN KEY(email) REFERENCES Users(email) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS Doctor (
  email varchar(60) NOT NULL UNIQUE,
  degree varchar(20) NOT NULL,
  FOREIGN KEY(email) REFERENCES Users(email) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS Specialize (
  id integer NOT NULL,
  email varchar(60) NOT NULL,
  FOREIGN KEY(email) REFERENCES Doctor(email) ON DELETE CASCADE,
  FOREIGN KEY(id) REFERENCES DiseaseType(id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS Record (
  email varchar(60) NOT NULL,
  cname varchar(50) NOT NULL,
  disease_code varchar(50) NOT NULL,
  total_deaths integer NOT NULL,
  total_patients integer NOT NULL,
  FOREIGN KEY(disease_code) REFERENCES Disease(disease_code) ON DELETE CASCADE,
  FOREIGN KEY(cname) REFERENCES Country(cname) ON DELETE CASCADE,
  FOREIGN KEY(email) REFERENCES PublicServant(email) ON DELETE CASCADE
);



INSERT INTO DiseaseType (description) VALUES ( 'infectious diseases');
INSERT INTO DiseaseType (description) VALUES ( 'virology');
INSERT INTO DiseaseType (description) VALUES ( 'genetic');
INSERT INTO DiseaseType (description) VALUES ( 'autoimmune');
INSERT INTO DiseaseType (description) VALUES ( 'prions');
INSERT INTO DiseaseType (description) VALUES ( 'ophtolmologoical');
INSERT INTO DiseaseType (description) VALUES ( 'psychological');
INSERT INTO DiseaseType (description) VALUES ( 'fungology');
INSERT INTO DiseaseType (description) VALUES ( 'otolaryngology');
INSERT INTO DiseaseType (description) VALUES ( 'psychiatry');

INSERT INTO
  Disease (disease_code, pathogen, description, id)
VALUES
  (
    'A69.20',
    'bacteria',
    'Lyme disease is an infection that happens when an infected tick bites a human. Causes fever, headache, Body and joint aches.',
    1
  );

INSERT INTO
  Disease (disease_code, pathogen, description, id)
VALUES
  (
    'A65.14',
    'bacteria',
    'Suffacation. caused by bacteria',
    1
  );
INSERT INTO
  Disease (disease_code, pathogen, description, id)
VALUES
  (
    'ICD-10',
    'virus',
    'Common flu with high temperatures',
    2
  );
INSERT INTO
  Disease (disease_code, pathogen, description, id)
VALUES
  (
    'K-85.90',
    'zymogens',
    'Pancreatitis. Acute pancreatitis occurs when there is abnormal activation of digestive enzymes within the pancreas. ',
    6
  );
INSERT INTO
  Disease (disease_code, pathogen, description, id)
VALUES
  (
    'A81. 00.',
    'prion',
    'Creutzfeldt-Jakob diseasea. Brain damage',
    5
  );
INSERT INTO
  Disease (disease_code, pathogen, description, id)
VALUES
  (
    'B37. 9',
    'fungal',
    'Candidiasis is a fungal infection caused by a yeast (a type of fungus) called Candida.',
    8
  );
INSERT INTO
  Disease (disease_code, pathogen, description, id)
VALUES
  (
    'F33.4',
    'stress',
    'Depression is a mood disorder that causes a persistent feeling of sadness and loss of interest ',
    10
  );
INSERT INTO
  Disease (disease_code, pathogen, description, id)
VALUES
  (
    'J45',
    'bacteria',
    'Asthma is a condition in which your airways narrow and swell and may produce extra mucus.',
    1
  );
INSERT INTO
  Disease (disease_code, pathogen, description, id)
VALUES
  (
    'B20',
    'virus',
    'The human immunodeficiency viruses are two species of Lentivirus that infect humans and destroy immune system',
    2
  );
INSERT INTO
  Disease (disease_code, pathogen, description, id)
VALUES
  (
    'A33',
    'bacteria',
    '. When these bacteria enter the body, they produce a toxin that causes painful muscle contractions.',
    1
  );

INSERT INTO 
  Country (cname, population)
VALUES
  (
    'USA',
    333291537	
  );
INSERT INTO 
  Country (cname, population)
VALUES
  (
    'Japan',
    125927902	
  );
INSERT INTO 
  Country (cname, population)
VALUES
  (
    'Egypt',
    104085814	
  );
INSERT INTO 
  Country (cname, population)
VALUES
  (
    'Iran',
    85947407		
  );
INSERT INTO 
  Country (cname, population)
VALUES
  (
    'France',
    67960000		
  );
INSERT INTO 
  Country (cname, population)
VALUES
  (
    'South Korea',
    51638809	
  );
INSERT INTO 
  Country (cname, population)
VALUES
  (
    'Argentina',
    47327407
  );
INSERT INTO 
  Country (cname, population)
VALUES
  (
    'Ukraine',
    41130432		
  );
INSERT INTO 
  Country (cname, population)
VALUES
  (
    'Poland',
    37987000
  ); 
INSERT INTO 
  Country (cname, population)
VALUES
  (
    'Uzbekistan',
    37987000
  );
INSERT INTO discover (cname, disease_code, first_enc_date)
VALUES
('USA','A81. 00.','1999-07-12'),
('South Korea','A69.20','1987-07-22'),
('Poland','A33','1999-07-22'),
('Ukraine','F33.4','2000-07-22'),
('Argentina','B20','1986-07-22'),
('Poland','B37. 9','1988-07-22'),
('Ukraine','J45','1976-07-22'),
('Argentina','K-85.90','1456-07-22'),
('Iran','ICD-10','2022-07-22'),
('South Korea','A65.14','2022-07-22');


INSERT INTO
  Users (email, name, surname, salary, phone, cname)
VALUES('example1@gmail.com', 'Ardak', 'Aibek', 5000, '8777777777', 'Argentina');

INSERT INTO
  Users (email, name, surname, salary, phone, cname)
VALUES('example2@gmail.com', 'Aizdos', 'AZhibek', 6000, '8777777777', 'USA');

INSERT INTO
  Users (email, name, surname, salary, phone, cname)
VALUES('example3@gmail.com', 'Akebas', 'Malgashdar', 8000, '8777777777', 'Egypt');

INSERT INTO
  Users (email, name, surname, salary, phone, cname)
VALUES('example4@gmail.com', 'Akerke', 'Malevoich', 8000, '8777777777', 'Poland');

INSERT INTO
  Users (email, name, surname, salary, phone, cname)
VALUES('example5@gmail.com', 'Samal', 'Salemovna', 1110000, '8777777777', 'Ukraine');

INSERT INTO
  Users (email, name, surname, salary, phone, cname)
VALUES('example6@gmail.com', 'John', 'Doe', 1110000, '8777777777', 'USA');

INSERT INTO
  Users (email, name, surname, salary, phone, cname)
VALUES('example7@gmail.com', 'Johnathan', 'Monster', 1110000, '8777777777', 'Poland');

INSERT INTO
  Users (email, name, surname, salary, phone, cname)
VALUES('example9@gmail.com', 'Johnathan', 'Blaze', 1210000, '8777777777', 'Egypt');

INSERT INTO
  Users (email, name, surname, salary, phone, cname)
VALUES('example21@gmail.com', 'Aibek', 'Argul', 1210000, '8777777777', 'Egypt');

INSERT INTO
  Users (email, name, surname, salary, phone, cname)
VALUES('example10@gmail.com', 'Vladimir', 'Kim', 1110000, '8777777777', 'South Korea');

INSERT INTO
  Users (email, name, surname, salary, phone, cname)
VALUES('example8@gmail.com', 'Retera', 'Menera', 1110000, '8777777777', 'Poland');

INSERT INTO
  Users (email, name, surname, salary, phone, cname)
VALUES('example11@gmail.com', 'Alex', 'Mercer', 1110000, '8777777777', 'USA');

INSERT INTO
  Users (email, name, surname, salary, phone, cname)
VALUES('example12@gmail.com', 'Jason', 'Caleb', 1110000, '8777777777', 'USA');

INSERT INTO
  Users (email, name, surname, salary, phone, cname)
VALUES('example13@gmail.com', 'Kratos', 'Odinson', 1110000, '8777777777', 'Argentina');

INSERT INTO
  Users (email, name, surname, salary, phone, cname)
VALUES('example14@gmail.com', 'James', 'Bond', 12321312, '8777777777', 'USA');

INSERT INTO
  Users (email, name, surname, salary, phone, cname)
VALUES('example15@gmail.com', 'Aldar', 'Kose', 12321312, '8777777777', 'Argentina');

INSERT INTO
  Users (email, name, surname, salary, phone, cname)
VALUES('example16@gmail.com', 'Serjan', 'Kose', 12321312, '8777777777', 'Argentina');

INSERT INTO
  Users (email, name, surname, salary, phone, cname)
VALUES('example17@gmail.com', 'Kamal', 'Kose', 12321312, '8777777777', 'Argentina');

INSERT INTO
  Users (email, name, surname, salary, phone, cname)
VALUES('example18@gmail.com', 'Perdak', 'Kose', 12321312, '8777777777', 'Argentina');

INSERT INTO
  Users (email, name, surname, salary, phone, cname)
VALUES('example19@gmail.com', 'Ardak', 'Kose', 12321312, '8777777777', 'Argentina');

INSERT INTO
  Users (email, name, surname, salary, phone, cname)
VALUES('example20@gmail.com', 'Samal', 'Kose', 12321312, '8777777777', 'Argentina');

INSERT INTO
  PublicServant (email, department)
VALUES('example1@gmail.com', 'department1');

INSERT INTO
  PublicServant (email, department)
VALUES('example2@gmail.com', 'department2');

INSERT INTO
  PublicServant (email, department)
VALUES('example3@gmail.com', 'department3');

INSERT INTO
  PublicServant (email, department)
VALUES('example4@gmail.com', 'department4');

INSERT INTO
  PublicServant (email, department)
VALUES('example5@gmail.com', 'department4');

INSERT INTO
  PublicServant (email, department)
VALUES('example6@gmail.com', 'department3');

INSERT INTO
  PublicServant (email, department)
VALUES('example7@gmail.com', 'department2');

INSERT INTO
  PublicServant (email, department)
VALUES('example9@gmail.com', 'department2');

INSERT INTO
  PublicServant (email, department)
VALUES('example10@gmail.com', 'department4');

INSERT INTO
  PublicServant (email, department)
VALUES('example8@gmail.com', 'department3');

INSERT INTO
  Doctor (email, degree)
VALUES('example11@gmail.com', 'highest');

INSERT INTO
  Doctor (email, degree)
VALUES('example12@gmail.com', 'highest');

INSERT INTO
  Doctor (email, degree)
VALUES('example13@gmail.com', 'highest');

INSERT INTO
  Doctor (email, degree)
VALUES('example14@gmail.com', 'highest');

INSERT INTO
  Doctor (email, degree)
VALUES('example15@gmail.com', 'highest');

INSERT INTO
  Doctor (email, degree)
VALUES('example16@gmail.com', 'medium');

INSERT INTO
  Doctor (email, degree)
VALUES('example17@gmail.com', 'medium');

INSERT INTO
  Doctor (email, degree)
VALUES('example19@gmail.com', 'medium');

INSERT INTO
  Doctor (email, degree)
VALUES('example18@gmail.com', 'lowest');

INSERT INTO
  Doctor (email, degree)
VALUES('example20@gmail.com', 'lowest');


INSERT INTO Specialize (id, email) VALUES (1, 'example11@gmail.com');
INSERT INTO Specialize (id, email) VALUES (2, 'example12@gmail.com');
INSERT INTO Specialize (id, email) VALUES (3, 'example13@gmail.com');
INSERT INTO Specialize (id, email) VALUES (4, 'example14@gmail.com');
INSERT INTO Specialize (id, email) VALUES (5, 'example15@gmail.com');
INSERT INTO Specialize (id, email) VALUES (6, 'example16@gmail.com');
INSERT INTO Specialize (id, email) VALUES (7, 'example17@gmail.com');
INSERT INTO Specialize (id, email) VALUES (8, 'example18@gmail.com');

INSERT INTO
  Record (
    email,
    cname,
    disease_code,
    total_deaths,
    total_patients
  )
VALUES
  ('example1@gmail.com',
   'Argentina',
   'A65.14',
   50000,
   60000
   );

   INSERT INTO
  Record (
    email,
    cname,
    disease_code,
    total_deaths,
    total_patients
  )
VALUES
  ('example10@gmail.com',
   'Argentina',
   'A65.14',
   50000,
   60000
   );
   
   
   
   
INSERT INTO
  Record (
    email,
    cname,
    disease_code,
    total_deaths,
    total_patients
  )
VALUES
  ('example9@gmail.com',
   'Argentina',
   'A65.14',
   50000,
   60000
   );
   
   
   
   
INSERT INTO
  Record (
    email,
    cname,
    disease_code,
    total_deaths,
    total_patients
  )
VALUES
  ('example8@gmail.com',
   'Argentina',
   'A65.14',
   50000,
   60000
   );
   
   
   
   
INSERT INTO
  Record (
    email,
    cname,
    disease_code,
    total_deaths,
    total_patients
  )
VALUES
  ('example7@gmail.com',
   'Argentina',
   'A65.14',
   50000,
   60000
   );
   
   
   
   
INSERT INTO
  Record (
    email,
    cname,
    disease_code,
    total_deaths,
    total_patients
  )
VALUES
  ('example6@gmail.com',
   'Argentina',
   'A65.14',
   50000,
   60000
   );
   
   
   
   
INSERT INTO
  Record (
    email,
    cname,
    disease_code,
    total_deaths,
    total_patients
  )
VALUES
  ('example5@gmail.com',
   'Argentina',
   'A65.14',
   50000,
   60000
   );
   
   
   
   
INSERT INTO
  Record (
    email,
    cname,
    disease_code,
    total_deaths,
    total_patients
  )
VALUES
  ('example4@gmail.com',
   'Argentina',
   'A65.14',
   50000,
   60000
   );
   
   
   
   
INSERT INTO
  Record (
    email,
    cname,
    disease_code,
    total_deaths,
    total_patients
  )
VALUES
  ('example3@gmail.com',
   'Argentina',
   'A65.14',
   50000,
   60000
   );
   
   
   
INSERT INTO
  Record (
    email,
    cname,
    disease_code,
    total_deaths,
    total_patients
  )
VALUES
  ('example2@gmail.com',
   'Argentina',
   'A65.14',
   50000,
   60000
   );