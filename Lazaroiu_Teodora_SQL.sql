----------------------------------------------------------------------------------------
--- EXERCITIUL 4

--- Vom crea cele 13 tabele în SQL si vom adauga constrângerile pentru modelul de date

CREATE TABLE AEROPORTURI
(cod_IATA varchar2(3) CONSTRAINT aeroporturi_pk PRIMARY KEY,
cod_postal varchar2(6) NOT NULL,
nume varchar2(55) NOT NULL,
adresa varchar2(50),
telefon varchar2(10));

CREATE TABLE ORASE
(cod_postal varchar2(6) CONSTRAINT orase_pk PRIMARY KEY,
nume varchar2(15) NOT NULL,
cod_aeroport varchar2(3),
cod_regiune varchar2(3)); -- cheie externa din tabelul AEROPORTURI

-- odata ce a fost creat tabelul ORASE putem marca cheia externa in tabelul AEROPORTURI
ALTER TABLE AEROPORTURI
ADD CONSTRAINT aeroporturi_orase_fk FOREIGN KEY(cod_postal)
REFERENCES ORASE(cod_postal);

CREATE TABLE REGIUNI
(cod_regiune varchar2(3) CONSTRAINT regiuni_pk PRIMARY KEY,
nume varchar2(15) NOT NULL,
numar_aeroporturi number(2));

CREATE TABLE PILOTI
(id_pilot number(4) CONSTRAINT piloti_pk PRIMARY KEY,
cod_aeroport varchar2(3),
nume varchar2(30) NOT NULL,
prenume varchar2(30),
telefon varchar2(10) NOT NULL,
data_angajarii date DEFAULT sysdate,
salariu number(6),
CONSTRAINT piloti_aeroport_fk FOREIGN KEY(cod_aeroport)
REFERENCES AEROPORTURI(cod_IATA));

CREATE TABLE INSOTITORI
(id_insotitor_de_zbor number(4) CONSTRAINT insotitori_pk PRIMARY KEY,
cod_aeroport varchar2(3),
nume varchar2(30) NOT NULL,
prenume varchar2(30),
telefon varchar2(10) NOT NULL,
data_angajarii date DEFAULT sysdate,
salariu number(6),
CONSTRAINT insotitori_aeroport_fk FOREIGN KEY(cod_aeroport)
REFERENCES AEROPORTURI(cod_IATA));

CREATE TABLE CALATORII
(cod_calatorie number(6) CONSTRAINT calatorii_pk PRIMARY KEY,
cod_aeroport_plecare varchar2(3) NOT NULL,
cod_aeroport_sosire varchar2(3) NOT NULL,
id_pilot_principal number(4) NOT NULL,
id_pilot_secundar number(4) NOT NULL,
cod_avion number(4) NOT NULL,
data_plecarii date,
data_sosirii date,
CONSTRAINT calatorii_aeroport_fk1 FOREIGN KEY(cod_aeroport_plecare)
REFERENCES AEROPORTURI(cod_IATA),
CONSTRAINT calatorii_aeroport_fk2 FOREIGN KEY(cod_aeroport_sosire)
REFERENCES AEROPORTURI(cod_IATA),
-- cele doua coduri ale aeroporturilor vor fi chei externe din tabelul AEROPORTURI
CONSTRAINT calatorii_piloti_fk1 FOREIGN KEY(id_pilot_principal)
REFERENCES PILOTI(id_pilot),
CONSTRAINT calatorii_piloti_fk2 FOREIGN KEY(id_pilot_secundar)
REFERENCES PILOTI(id_pilot),
-- cele doua id-uri vor fi chei externe din tabelul PILOTI
CONSTRAINT valid_data_sosirii CHECK(data_sosirii > data_plecarii),
-- data sosirii trebuie sa fie mai mare decat data plecarii
CONSTRAINT distinct_aeroport CHECK (cod_aeroport_plecare != cod_aeroport_sosire),
-- aeroportul de plecare si cel de sosire trebuie sa fie diferite
CONSTRAINT distinct_pilot CHECK (id_pilot_principal != id_pilot_secundar)
-- trebuie sa existe 2 piloti distincti
);

CREATE TABLE AVIOANE
(cod_avion number(4) CONSTRAINT avioane_pk PRIMARY KEY,
model varchar2(30) NOT NULL,
cod_companie number(4) NOT NULL,
capacitate number(3),
viteza_de_croaziera number(4));

-- dupa ce am creat tabelul AVIOANE putem sa referim cheia externa "cod_avion"
-- in tabelul CALATORII

ALTER TABLE CALATORII
ADD CONSTRAINT calatorii_avioane_fk FOREIGN KEY(cod_avion)
REFERENCES AVIOANE(cod_avion);

CREATE TABLE COMPANII
(cod_companie number(4) CONSTRAINT companii_pk PRIMARY KEY,
nume varchar2(30) NOT NULL);

-- dupa ce am creat tabelul COMPANII putem sa referim cheia externa
--  "cod_companie" in tabelul AVIOANE

ALTER TABLE AVIOANE
ADD CONSTRAINT avioane_companii_fk FOREIGN KEY(cod_companie)
REFERENCES COMPANII(cod_companie);

CREATE TABLE CLASE
(cod_clasa number(2) CONSTRAINT clase_pk PRIMARY KEY,
nume varchar2(20) NOT NULL,
pret_aditional number(4),
facilitati varchar2(60));

CREATE TABLE PASAGERI
(id_pasager number(6) CONSTRAINT pasageri_pk PRIMARY KEY,
nume varchar2(30) NOT NULL,
prenume varchar2(30),
email varchar2(30),
telefon varchar2(10) NOT NULL,
data_nasterii date);

CREATE TABLE AVIOANE_AU_CLASE
(cod_clasa number(2),
cod_avion number(4),
capacitate number(3),
CONSTRAINT avioane_au_clase_clase_fk FOREIGN KEY(cod_clasa)
REFERENCES CLASE(cod_clasa),
-- referim cheia externa din tabelul CLASE
CONSTRAINT avioane_au_clase_avioane_fk FOREIGN KEY(cod_avion)
REFERENCES AVIOANE(cod_avion),
-- referim cheia externa din tabelul AVIOANE
CONSTRAINT avioane_au_clase_pk PRIMARY KEY(cod_clasa, cod_avion));
-- cheie primara compusa

CREATE TABLE REZERVA
(cod_clasa number(2),
cod_calatorie number(6),
id_pasager number(6),
cod_rezervare number(8),
pret_bilet number(4),
CONSTRAINT rezerva_clase_fk FOREIGN KEY(cod_clasa)
REFERENCES CLASE(cod_clasa),
-- cheie externa din tabelul CLASE
CONSTRAINT rezerva_calatori_fk FOREIGN KEY(cod_calatorie)
REFERENCES CALATORII(cod_calatorie),
-- cheie externa din tabelul CALATORII
CONSTRAINT rezerva_pasageri_fk FOREIGN KEY(id_pasager)
REFERENCES PASAGERI(id_pasager),
-- cheie externa din tabelul PASAGERI
CONSTRAINT rezerva_pk PRIMARY KEY(cod_clasa, cod_calatorie, id_pasager, cod_rezervare));
-- cheie primara compusa din 4 elemente

CREATE TABLE INSOTESC
(id_insotitor_de_zbor number(4),
cod_calatorie number(6),
sef_cabina number(4),
CONSTRAINT insotesc_insotitori_fk1 FOREIGN KEY(id_insotitor_de_zbor)
REFERENCES INSOTITORI(id_insotitor_de_zbor),
-- cheie externa din tabelul INSOTITORI
CONSTRAINT insotesc_calatorii_fk FOREIGN KEY(cod_calatorie)
REFERENCES CALATORII(cod_calatorie),
-- cheie externa din tabelul CALATORII
CONSTRAINT insotesc_insotitori_fk2 FOREIGN KEY(sef_cabina)
REFERENCES INSOTITORI(id_insotitor_de_zbor),
-- cheie externa din tabelul INSOTITORI
CONSTRAINT insotesc_pk PRIMARY KEY(id_insotitor_de_zbor, cod_calatorie));
-- cheie primara compusa

----------------------------------------------------------------------------------------
--- EXERCITIUL 5

--- Inserari in tabelul REGIUNI
INSERT INTO REGIUNI
VALUES ('MUN', 'Muntenia', 1);

INSERT INTO REGIUNI
VALUES ('TRA', 'Transilvania', 2);

INSERT INTO REGIUNI
VALUES ('MOL', 'Moldova', 1);

INSERT INTO REGIUNI
VALUES ('DOB', 'Dobrogea', 1);

INSERT INTO REGIUNI
VALUES ('BAN', 'Banat', 1);

INSERT INTO REGIUNI
VALUES ('OLT', 'Oltenia', 1);

INSERT INTO REGIUNI
VALUES ('CRI', 'Crisana', 1);

INSERT INTO REGIUNI
VALUES ('MAR', 'Maramures', 0);

--- Inserari in tabelul ORASE
INSERT INTO ORASE
VALUES (075150, 'Bucuresti', 'OTP', 'MUN');

INSERT INTO ORASE
VALUES (400397, 'Cluj', 'CLJ', 'TRA');

INSERT INTO ORASE
VALUES (700750, 'Iasi', 'IAS', 'MOL');

INSERT INTO ORASE
VALUES (907195, 'Constanta', 'CND', 'DOB');

INSERT INTO ORASE
VALUES (307200, 'Timisoara', 'TSR', 'BAN');

INSERT INTO ORASE
VALUES (410223, 'Oradea', 'OMR', 'CRI');

INSERT INTO ORASE
VALUES (200621, 'Craiova', 'CRA', 'OLT');

INSERT INTO ORASE
VALUES (550052, 'Sibiu', 'SBZ', 'TRA');

INSERT INTO ORASE
VALUES (110001, 'Pitesti', NULL, 'MUN');

--- Inserari in tabelul AEROPORTURI
INSERT INTO AEROPORTURI
VALUES('OTP', 075150, 'Henri Coanda International Airport', 'Calea Bucurestilor 224E', '0212041000');

INSERT INTO AEROPORTURI
VALUES('CLJ', 400397, 'Avram Iancu International Airport', 'Strada Traian Vuia 149-151', '0264307500');

INSERT INTO AEROPORTURI
VALUES('IAS', 700750, 'Iasi International Airport', 'Strada Moara de Vant 34', '0232271590');

INSERT INTO AEROPORTURI
VALUES('CND', 907195, 'Mihail Kogalniceanu International Airport', 'Strada Tudor Vladimirescu', '0241255100');

INSERT INTO AEROPORTURI
VALUES('TSR', 307200, 'Traian Vuia International Airport', 'Strada Aeroportului 2', '0256386089');

INSERT INTO AEROPORTURI
VALUES('OMR', 410223, 'Oradea International Airport', 'Calea Aradului 80', '0259416082');

INSERT INTO AEROPORTURI
VALUES('CRA', 200621, 'Craiova International Airport', 'Calea Bucuresti 325', '0754022508');

INSERT INTO AEROPORTURI
VALUES('SBZ', 550052, 'Sibiu International Airport', 'Soseaua Alba Iulia 73', '0269253135');

--- Adaugam constrangerea de FOREIGN KEY pentru cod_aeroporturi din tabelul ORASE
ALTER TABLE ORASE
ADD CONSTRAINT orase_aeroporturi_fk FOREIGN KEY(cod_aeroport)
REFERENCES AEROPORTURI(cod_IATA);

--- Adaugam constrangerea de FOREIGN KEY pentru cod_regiune din tabelul ORASE
ALTER TABLE ORASE
ADD CONSTRAINT orase_regiuni_fk FOREIGN KEY(cod_regiune)
REFERENCES REGIUNI(cod_regiune);

--- secventa pentru incrementarea atributului ID_PILOT din tabelul PILOTI
CREATE SEQUENCE SEQ_PILOTI
START WITH 120
INCREMENT by 10
MAXVALUE 9990
NOCYCLE;

--- Inserari in tabelul PILOTI
INSERT INTO PILOTI
VALUES (SEQ_PILOTI.NEXTVAL, 'OTP', 'Popescu', 'Mihai', '0723467897', to_date('04-05-2018','DD-MM-YYYY'), 100000);

INSERT INTO PILOTI
VALUES (SEQ_PILOTI.NEXTVAL, 'OTP', 'Dumitru', 'Andrei', '0773567890', to_date('07-09-2018','DD-MM-YYYY'), 150000);

INSERT INTO PILOTI
VALUES (SEQ_PILOTI.NEXTVAL, 'TSR', 'Marinescu', 'Adrian', '0793857856', to_date('05-02-2016','DD-MM-YYYY'), 550000);

INSERT INTO PILOTI
VALUES (SEQ_PILOTI.NEXTVAL, 'TSR', 'Coman', 'Stefania', '0775852235', to_date('05-12-2020','DD-MM-YYYY'), 200000);

INSERT INTO PILOTI
VALUES (SEQ_PILOTI.NEXTVAL, 'CLJ', 'Florescu', 'Mihai', '0788451775', to_date('07-12-2010','DD-MM-YYYY'), 500000);

INSERT INTO PILOTI
VALUES (SEQ_PILOTI.NEXTVAL, 'CLJ', 'Moise', 'Horia', '0788449075', to_date('23-06-2015','DD-MM-YYYY'), 350000);

INSERT INTO PILOTI
VALUES (SEQ_PILOTI.NEXTVAL, 'CLJ', 'Stoica', 'Irina', '0702390175', to_date('15-01-2021','DD-MM-YYYY'), 180000);

INSERT INTO PILOTI
VALUES (SEQ_PILOTI.NEXTVAL, 'IAS', 'Naum', 'Florin', '0712345175', to_date('15-11-2019','DD-MM-YYYY'), 250000);

INSERT INTO PILOTI
VALUES (SEQ_PILOTI.NEXTVAL, 'IAS', 'Olteanu', 'Paul', '0712743275', to_date('01-01-2014','DD-MM-YYYY'), 550000);

INSERT INTO PILOTI
VALUES (SEQ_PILOTI.NEXTVAL, 'CND', 'Avram', 'Daniel', '0766320275', to_date('01-06-2020','DD-MM-YYYY'), 222000);

INSERT INTO PILOTI
VALUES (SEQ_PILOTI.NEXTVAL, 'CND', 'Stefan', 'George', '0766320275', to_date('30-08-2013','DD-MM-YYYY'), 355000);

INSERT INTO PILOTI
VALUES (SEQ_PILOTI.NEXTVAL, 'CND', 'Stancu', 'Elena', '0733332146', to_date('01-05-2021','DD-MM-YYYY'), 99000);

INSERT INTO PILOTI
VALUES (SEQ_PILOTI.NEXTVAL, 'CRA', 'Mihailescu', 'Cosmin', '0754999146', to_date('01-05-2018','DD-MM-YYYY'), 340000);

INSERT INTO PILOTI
VALUES (SEQ_PILOTI.NEXTVAL, 'CRA', 'Olteanu', 'Valentin', '0765412146', to_date('17-04-2010','DD-MM-YYYY'), 450000);

--- secventa pentru incrementarea atributului ID_insotitor_DE_ZBOR din tabelul INSOTITORI
CREATE SEQUENCE SEQ_INSOTITORI
START WITH 10
INCREMENT by 10
MINVALUE 0
MAXVALUE 9990
NOCYCLE;

---Inserari in tabelul INSOTITORI
INSERT INTO INSOTITORI
VALUES (SEQ_INSOTITORI.NEXTVAL, 'OTP', 'Voiculescu', 'Alina', '0745678146', to_date('04-10-2018','DD-MM-YYYY'), 33000);

INSERT INTO INSOTITORI
VALUES (SEQ_INSOTITORI.NEXTVAL, 'OTP', 'Moisescu', 'Denisa', '0792218597', to_date('13-03-2019','DD-MM-YYYY'), 40000);

INSERT INTO INSOTITORI
VALUES (SEQ_INSOTITORI.NEXTVAL, 'OTP', 'Ionescu', 'Florin', '0726688610', to_date('02-04-2012','DD-MM-YYYY'), 90000);

INSERT INTO INSOTITORI
VALUES (SEQ_INSOTITORI.NEXTVAL, 'CLJ', 'Georgescu', 'Calin', '0768216950', to_date('01-07-2016','DD-MM-YYYY'), 80000);

INSERT INTO INSOTITORI
VALUES (SEQ_INSOTITORI.NEXTVAL, 'CLJ', 'Antonie', 'Mihaela', '0783717731', to_date('06-12-2020','DD-MM-YYYY'), 15000);

INSERT INTO INSOTITORI
VALUES (SEQ_INSOTITORI.NEXTVAL, 'TSR', 'Voica', 'Laura', '0766138430', to_date('31-01-2021','DD-MM-YYYY'), 13000);

INSERT INTO INSOTITORI
VALUES (SEQ_INSOTITORI.NEXTVAL, 'TSR', 'Enache', 'Maria', '0778767173', to_date('25-10-2015','DD-MM-YYYY'), 40000);

INSERT INTO INSOTITORI
VALUES (SEQ_INSOTITORI.NEXTVAL, 'IAS', 'Matache', 'Irina', '0762706994', to_date('20-03-2015','DD-MM-YYYY'), 45000);

INSERT INTO INSOTITORI
VALUES (SEQ_INSOTITORI.NEXTVAL, 'IAS', 'Mirea', 'Mihai', '0785072934', to_date('07-07-2019','DD-MM-YYYY'), 27000);

INSERT INTO INSOTITORI
VALUES (SEQ_INSOTITORI.NEXTVAL, 'CND', 'Lazar', 'Nicoleta', '0718538567', to_date('09-11-2018','DD-MM-YYYY'), 33000);

INSERT INTO INSOTITORI
VALUES (SEQ_INSOTITORI.NEXTVAL, 'CND', 'Florea', 'Stefania', '0784725925', to_date('23-09-2009','DD-MM-YYYY'), 80000);

INSERT INTO INSOTITORI
VALUES (SEQ_INSOTITORI.NEXTVAL, 'CRA', 'Miulescu', 'Ana', '0758812546', to_date('06-06-2020','DD-MM-YYYY'), 12000);

INSERT INTO INSOTITORI
VALUES (SEQ_INSOTITORI.NEXTVAL, 'SBZ', 'Diaconescu', 'Daniela', '0734456845', to_date('27-04-2018','DD-MM-YYYY'), 16000);

---Inserari in tabelul COMPANII
INSERT INTO COMPANII
VALUES (120, 'Tarom');

INSERT INTO COMPANII
VALUES (121, 'Blue Air');

INSERT INTO COMPANII
VALUES (122, 'Wizz Air');

INSERT INTO COMPANII
VALUES (123, 'KLM');

INSERT INTO COMPANII
VALUES (124, 'Ryanair');

INSERT INTO COMPANII
VALUES (125, 'Lufthansa');

---Inserari in tabelul AVIOANE
INSERT INTO AVIOANE
VALUES (1000, 'BOEING 737-700', 120, 149, 870);

INSERT INTO AVIOANE
VALUES (1001, 'BOEING 737-300', 120, 141, 800);

INSERT INTO AVIOANE
VALUES (1002, 'AIRBUS A318-111', 120, 132, 850);

INSERT INTO AVIOANE
VALUES (1003, 'ATR 42-500', 120, 52, 550);

INSERT INTO AVIOANE
VALUES (1004, 'BOEING 737-300', 121, 141, 800);

INSERT INTO AVIOANE
VALUES (1005, 'BOEING 737-500', 121, 126, 785);

INSERT INTO AVIOANE
VALUES (1006, 'BOEING 737-800', 121, 189, 823);

INSERT INTO AVIOANE
VALUES (1007, 'AIRBUS A320-200', 122, 186, 900);

INSERT INTO AVIOANE
VALUES (1008, 'AIRBUS A321-200', 122, 230, 840);

INSERT INTO AVIOANE
VALUES (1009, 'AIRBUS A330-200', 123, 185, 913);

INSERT INTO AVIOANE
VALUES (1010, 'BOEING 737-800', 124, 162, 946);

--- secventa pentru incrementarea atributului COD_CALATORIE din tabelul CALATORII
CREATE SEQUENCE SEQ_CALATORII
START WITH 1001
INCREMENT by 1
MAXVALUE 999999
NOCYCLE;

---Inserari in tabelul CALATORII
INSERT INTO CALATORII
VALUES (SEQ_CALATORII.NEXTVAL, 'OTP', 'CLJ', 120, 130, 1006, to_date('01-06-2021 07:30','DD-MM-YYYY HH24:MI'), to_date('01-06-2021 08:25','DD-MM-YYYY HH24:MI'));

INSERT INTO CALATORII
VALUES (SEQ_CALATORII.NEXTVAL, 'OTP', 'IAS', 120, 130, 1002, to_date('02-06-2021 08:00','DD-MM-YYYY HH24:MI'), to_date('02-06-2021 09:05','DD-MM-YYYY HH24:MI'));

INSERT INTO CALATORII
VALUES (SEQ_CALATORII.NEXTVAL, 'OTP', 'TSR', 120, 130, 1000, to_date('03-06-2021 21:00','DD-MM-YYYY HH24:MI'), to_date('03-06-2021 22:00','DD-MM-YYYY HH24:MI'));

INSERT INTO CALATORII
VALUES (SEQ_CALATORII.NEXTVAL, 'OTP', 'TSR', 120, 130, 1010, to_date('04-06-2021 07:30','DD-MM-YYYY HH24:MI'), to_date('04-06-2021 08:30','DD-MM-YYYY HH24:MI'));

INSERT INTO CALATORII
VALUES (SEQ_CALATORII.NEXTVAL, 'CLJ', 'IAS', 160, 180, 1003, to_date('27-05-2021 16:00','DD-MM-YYYY HH24:MI'), to_date('27-05-2021 16:55','DD-MM-YYYY HH24:MI'));

INSERT INTO CALATORII
VALUES (SEQ_CALATORII.NEXTVAL, 'CLJ', 'CND', 160, 170, 1008, to_date('30-05-2021 23:55','DD-MM-YYYY HH24:MI'), to_date('31-05-2021 00:30','DD-MM-YYYY HH24:MI'));

INSERT INTO CALATORII
VALUES (SEQ_CALATORII.NEXTVAL, 'IAS', 'CRA', 190, 200, 1009, to_date('04-06-2021 13:00','DD-MM-YYYY HH24:MI'), to_date('04-06-2021 14:10','DD-MM-YYYY HH24:MI'));

INSERT INTO CALATORII
VALUES (SEQ_CALATORII.NEXTVAL, 'IAS', 'OTP', 190, 200, 1002, to_date('05-06-2021 05:30','DD-MM-YYYY HH24:MI'), to_date('05-06-2021 06:40','DD-MM-YYYY HH24:MI'));

INSERT INTO CALATORII
VALUES (SEQ_CALATORII.NEXTVAL, 'CRA', 'IAS', 240, 250, 1010, to_date('04-06-2021 19:30','DD-MM-YYYY HH24:MI'), to_date('04-06-2021 20:40','DD-MM-YYYY HH24:MI'));

INSERT INTO CALATORII
VALUES (SEQ_CALATORII.NEXTVAL, 'CRA', 'CLJ', 240, 250, 1001, to_date('08-06-2021 09:45','DD-MM-YYYY HH24:MI'), to_date('08-06-2021 10:45','DD-MM-YYYY HH24:MI'));

INSERT INTO CALATORII
VALUES (SEQ_CALATORII.NEXTVAL, 'TSR', 'OTP', 140, 150, 1005, to_date('30-05-2021 07:40','DD-MM-YYYY HH24:MI'), to_date('30-05-2021 08:55','DD-MM-YYYY HH24:MI'));

INSERT INTO CALATORII
VALUES (SEQ_CALATORII.NEXTVAL, 'TSR', 'CND', 140, 150, 1007, to_date('28-05-2021 12:00','DD-MM-YYYY HH24:MI'), to_date('28-05-2021 13:45','DD-MM-YYYY HH24:MI'));

INSERT INTO CALATORII
VALUES (SEQ_CALATORII.NEXTVAL, 'OTP', 'OMR', 120, 130, 1003, to_date('11-06-2021 05:55','DD-MM-YYYY HH24:MI'), to_date('11-06-2021 07:20','DD-MM-YYYY HH24:MI'));

---Inserari in tabelul CLASE
INSERT INTO CLASE
VALUES (10, 'Economica', NULL, 'masuta retractabila');

INSERT INTO CLASE
VALUES (20, 'Business', 300, 'scaune ajustabile, o masa calda');

INSERT INTO CLASE
VALUES (30, 'First class', 500, 'lounge, meniu variat, paturi');

INSERT INTO CLASE
VALUES (40, 'Business Premium', 800, 'facilitati business, lounge');

INSERT INTO CLASE
VALUES (50, 'First Class Premium', 1000, 'facilitati first class, meniu lux');

--- secventa pentru incrementarea atributului ID_PASAGER din tabelul PASAGERI
CREATE SEQUENCE SEQ_PASAGERI
START WITH 1
INCREMENT by 1
MAXVALUE 999999
NOCYCLE;

---Inserari in tabelul PASAGERI
INSERT INTO PASAGERI
VALUES (SEQ_PASAGERI.NEXTVAL, 'Ionita', 'Alexandra', 'aionita@yahoo.com', '0741974529', to_date('03-05-2001','dd-mm-yyyy'));

INSERT INTO PASAGERI
VALUES (SEQ_PASAGERI.NEXTVAL, 'Moldoveanu', 'Victor', 'victor_m@yahoo.com', '0785483431', to_date('08-03-1980','dd-mm-yyyy'));

INSERT INTO PASAGERI
VALUES (SEQ_PASAGERI.NEXTVAL, 'Stoica', 'Valentin', 'valistoica@gmail.com', '0791459679', to_date('14-12-1996','dd-mm-yyyy'));

INSERT INTO PASAGERI
VALUES (SEQ_PASAGERI.NEXTVAL, 'Dabija', 'Adrian', 'dabadi@yahoo.com', '0760523629', to_date('06-07-1990','dd-mm-yyyy'));

INSERT INTO PASAGERI
VALUES (SEQ_PASAGERI.NEXTVAL, 'Barbu', 'Dumitru', 'dumitruB@yahoo.com', '0746888320', to_date('13-05-2000','dd-mm-yyyy'));

INSERT INTO PASAGERI
VALUES (SEQ_PASAGERI.NEXTVAL, 'Teodorescu', 'Eugen', 'eugen_t@yahoo.com', '0770522210', to_date('23-11-1965','dd-mm-yyyy'));

INSERT INTO PASAGERI
VALUES (SEQ_PASAGERI.NEXTVAL, 'Lupu', 'Maria', 'maria_lupu@yahoo.com', '0757241888', to_date('03-12-1977','dd-mm-yyyy'));

INSERT INTO PASAGERI
VALUES (SEQ_PASAGERI.NEXTVAL, 'Sava', 'Florentina', 'savaflo@gmail.com', '0766560779', to_date('29-06-2002','dd-mm-yyyy'));

INSERT INTO PASAGERI
VALUES (SEQ_PASAGERI.NEXTVAL, 'Nistor', 'Mariana', 'mariananistor@gmail.com', '0745582866', to_date('03-05-2001','dd-mm-yyyy'));

INSERT INTO PASAGERI
VALUES (SEQ_PASAGERI.NEXTVAL, 'Barbu', 'Ana Maria', 'anamariab@yahoo.com', '0788821557', to_date('31-01-1992','dd-mm-yyyy'));

INSERT INTO PASAGERI
VALUES (SEQ_PASAGERI.NEXTVAL, 'Dumitrescu', 'Andreea', 'andreea_dumi@yahoo.com', '0749267946', to_date('07-07-1979','dd-mm-yyyy'));

INSERT INTO PASAGERI
VALUES (SEQ_PASAGERI.NEXTVAL, 'Gheorghiu', 'Mihaela', 'mihaela.g@yahoo.com', '0727774485', to_date('24-11-1969','dd-mm-yyyy'));

INSERT INTO PASAGERI
VALUES (SEQ_PASAGERI.NEXTVAL, 'Pop', 'Rodica', 'rodica_pop@yahoo.com', '0791567138', to_date('16-04-1999','dd-mm-yyyy'));

INSERT INTO PASAGERI
VALUES (SEQ_PASAGERI.NEXTVAL, 'Constantinescu', 'Roxana', 'roxana.c@yahoo.com', '0743479564', to_date('12-12-1982','dd-mm-yyyy'));

INSERT INTO PASAGERI
VALUES (SEQ_PASAGERI.NEXTVAL, 'Dobre', 'Gabriela', 'gabi_dobre@gmail.com', '0765870667', to_date('28-02-1997','dd-mm-yyyy'));

INSERT INTO PASAGERI
VALUES (SEQ_PASAGERI.NEXTVAL, 'Ciobanu', 'Adriana', 'a.ciobanu@yahoo.com', '0732936930', to_date('03-11-1960','dd-mm-yyyy'));

INSERT INTO PASAGERI
VALUES (SEQ_PASAGERI.NEXTVAL, 'Toma', 'Claudia', 'claudia.toma@yahoo.com', '0736630215', to_date('16-09-1995','dd-mm-yyyy'));

INSERT INTO PASAGERI
VALUES (SEQ_PASAGERI.NEXTVAL, 'Stanescu', 'Constantin', 'ctin_stanescu@gmail.com', '0756729015', to_date('08-08-1955','dd-mm-yyyy'));

INSERT INTO PASAGERI
VALUES (SEQ_PASAGERI.NEXTVAL, 'Dima', 'Gheorghe', 'dima.gh@gmail.com', '0774034758', to_date('16-04-1968','dd-mm-yyyy'));

INSERT INTO PASAGERI
VALUES (SEQ_PASAGERI.NEXTVAL, 'Dumitrescu', 'Cristina', 'cristinaD@gmail.com', '0784550324', to_date('15-05-2000','dd-mm-yyyy'));

INSERT INTO PASAGERI
VALUES (SEQ_PASAGERI.NEXTVAL, 'Popescu', 'Elena', 'elenapop@yahoo.com', '0781236689', to_date('01-06-1985','dd-mm-yyyy'));


---Inserari in tabelul AVIOANE_AU_CLASE
INSERT INTO AVIOANE_AU_CLASE
VALUES (10, 1000, 100);

INSERT INTO AVIOANE_AU_CLASE
VALUES (20, 1000, 49);

INSERT INTO AVIOANE_AU_CLASE
VALUES (10, 1001, 141);

INSERT INTO AVIOANE_AU_CLASE
VALUES (10, 1002, 132);

INSERT INTO AVIOANE_AU_CLASE
VALUES (10, 1003, 52);

INSERT INTO AVIOANE_AU_CLASE
VALUES (10, 1004, 80);

INSERT INTO AVIOANE_AU_CLASE
VALUES (20, 1004, 61);

INSERT INTO AVIOANE_AU_CLASE
VALUES (10, 1005, 126);

INSERT INTO AVIOANE_AU_CLASE
VALUES (10, 1006, 100);

INSERT INTO AVIOANE_AU_CLASE
VALUES (20, 1006, 40);

INSERT INTO AVIOANE_AU_CLASE
VALUES (30, 1006, 49);

INSERT INTO AVIOANE_AU_CLASE
VALUES (10, 1007, 160);

INSERT INTO AVIOANE_AU_CLASE
VALUES (20, 1007, 26);

INSERT INTO AVIOANE_AU_CLASE
VALUES (10, 1008, 100);

INSERT INTO AVIOANE_AU_CLASE
VALUES (20, 1008, 100);

INSERT INTO AVIOANE_AU_CLASE
VALUES (30, 1008, 20);

INSERT INTO AVIOANE_AU_CLASE
VALUES (40, 1008, 10);

INSERT INTO AVIOANE_AU_CLASE
VALUES (10, 1009, 185);

INSERT INTO AVIOANE_AU_CLASE
VALUES (10, 1010, 162);

---Inserari in tabelul REZERVA
INSERT INTO REZERVA
VALUES (30, 1001, 2, 100001, 300);

INSERT INTO REZERVA
VALUES (30, 1001, 3, 100002, 300);

INSERT INTO REZERVA
VALUES (10, 1001, 15, 100003, 300);

INSERT INTO REZERVA
VALUES (10, 1010, 7, 100004, 200);

INSERT INTO REZERVA
VALUES (10, 1010, 10, 100005, 200);

INSERT INTO REZERVA
VALUES (10, 1010, 11, 100006, 200);

INSERT INTO REZERVA
VALUES (20, 1006, 5, 100007, 250);

INSERT INTO REZERVA
VALUES (40, 1006, 12, 100008, 250);

INSERT INTO REZERVA
VALUES (40, 1006, 13, 100009, 250);

INSERT INTO REZERVA
VALUES (30, 1006, 14, 100010, 250);

INSERT INTO REZERVA
VALUES (20, 1012, 1, 100011, 250);

INSERT INTO REZERVA
VALUES (10, 1012, 17, 100012, 250);

INSERT INTO REZERVA
VALUES (10, 1012, 18, 100013, 250);

INSERT INTO REZERVA
VALUES (10, 1012, 20, 100014, 250);

INSERT INTO REZERVA
VALUES (10, 1004, 4, 100015, 270);

INSERT INTO REZERVA
VALUES (10, 1004, 6, 100016, 270);

INSERT INTO REZERVA
VALUES (10, 1003, 16, 100017, 150);

INSERT INTO REZERVA
VALUES (20, 1003, 8, 100018, 150);

INSERT INTO REZERVA
VALUES (20, 1003, 9, 100019, 150);

INSERT INTO REZERVA
VALUES (10, 1013, 19, 100020, 150);

INSERT INTO REZERVA
VALUES (10, 1007, 10, 100021, 240);

INSERT INTO REZERVA
VALUES (10, 1007, 11, 100022, 240);

INSERT INTO REZERVA
VALUES (10, 1011, 2, 100023, 350);

INSERT INTO REZERVA
VALUES (10, 1011, 3, 100024, 350);

INSERT INTO REZERVA
VALUES (10, 1008, 19, 100025, 275);

INSERT INTO REZERVA
VALUES (10, 1008, 17, 100026, 275);

INSERT INTO REZERVA
VALUES (10, 1008, 18, 100027, 275);

---Inserari in tabelul INSOTESC
INSERT INTO INSOTESC
VALUES (10, 1001, 20);

INSERT INTO INSOTESC
VALUES (20, 1001, NULL);

INSERT INTO INSOTESC
VALUES (30, 1001, 20);

INSERT INTO INSOTESC
VALUES (10, 1003, NULL);

INSERT INTO INSOTESC
VALUES (30, 1003, 10);

INSERT INTO INSOTESC
VALUES (10, 1004, 20);

INSERT INTO INSOTESC
VALUES (20, 1004, NULL);

INSERT INTO INSOTESC
VALUES (40, 1005, NULL);

INSERT INTO INSOTESC
VALUES (40, 1006, NULL);

INSERT INTO INSOTESC
VALUES (50, 1006, 40);

INSERT INTO INSOTESC
VALUES (80, 1007, 90);

INSERT INTO INSOTESC
VALUES (90, 1007, NULL);

INSERT INTO INSOTESC
VALUES (90, 1008, NULL);

INSERT INTO INSOTESC
VALUES (120, 1009, NULL);

INSERT INTO INSOTESC
VALUES (120, 1010, NULL);

INSERT INTO INSOTESC
VALUES (60, 1011, NULL);

INSERT INTO INSOTESC
VALUES (70, 1011, 60);

INSERT INTO INSOTESC
VALUES (60, 1012, 70);

INSERT INTO INSOTESC
VALUES (70, 1012, NULL);

INSERT INTO INSOTESC
VALUES (20, 1013, NULL);

INSERT INTO INSOTESC
VALUES (30, 1013, 20);

COMMIT;

----------------------------------------------------------------------------------------
--- EXERCITIUL 6

--- Pentru fiecare aeroport sa se afiseze numele acestuia 
--- si salariul mediu al pilotilor ce lucreaza acolo

/
CREATE OR REPLACE PROCEDURE procedura1 IS

-- Vom crea un tip de date inregistrare pentru a pastra
-- codul aeroportului, numele acestuia si salariul mediu
    TYPE aeroport_record IS RECORD
    (cod AEROPORTURI.cod_iata%TYPE,
    nume AEROPORTURI.nume%TYPE,
    salariu_mediu PILOTI.salariu%TYPE);

-- Datele pentru toate aeroporturile vor fi salvate intr-un
-- tablou imbricat ce contine o coloana de tip inregistrare creat mai sus
    TYPE tablou_imbricat IS TABLE OF aeroport_record;
    
-- Vom folosi un vector pentru salvarea si calcularea
-- fiecarui salariu mediu al pilotilor in functie de aeroport
    TYPE vector IS VARRAY(8) OF PILOTI.salariu%TYPE;
    
-- Cu ajutorul unui circlu cursor vom parcurge
-- toate codurile de aeroporturi
    CURSOR c IS
        SELECT cod_iata
        FROM AEROPORTURI;
    
    t tablou_imbricat := tablou_imbricat();
    r aeroport_record;
    v vector := vector();
BEGIN
    
    FOR i IN c LOOP
    
-- Initial vom salva codul si numele aeroporturilor
-- in variabila de tip inregistrare declarata mai sus
        SELECT cod_iata, nume
        INTO r.cod, r.nume
        FROM AEROPORTURI
        WHERE i.cod_iata = cod_iata;

-- Calculam salariul mediu in functie de aeroport si
-- il salvam intr-un element din vector
        v.EXTEND;
        
        SELECT AVG(salariu)
        INTO v(v.LAST)
        FROM PILOTI
        WHERE cod_aeroport = i.cod_iata;
        
-- Copiem valoarea salariului mediu in
-- campul specific din variabila de tip inregistrare
        r.salariu_mediu := v(v.LAST);
        
-- Adaugam variabila de tip inregistrare curenta in
-- tabloul imbricat pentru a pastra toate valorile
        t.EXTEND;
        t(t.LAST) := r;
        
-- Afisam rezultatele in consola de output
        DBMS_OUTPUT.PUT_LINE ('La aeroportul ' || t(t.LAST).nume ||
        ' salariul mediu al pilotilor este de ' || t(t.last).salariu_mediu);
    END LOOP;
    
END procedura1;
/

EXECUTE procedura1;

----------------------------------------------------------------------------------------
--- EXERCITIUL 7

--- Sa se mareasca cu 10% salariul insotitorilor de zbor
--- care au fost angajati incepand cu anul 2018

/
CREATE OR REPLACE PROCEDURE procedura2 IS

-- Vom folosi un cursor SELECT FOR UPDATE
-- pentru a bloca liniile inainte ca acestea
-- sa fie actualizate cu noul salariul
    CURSOR c IS
    SELECT * FROM INSOTITORI
    WHERE TO_CHAR(data_angajarii, 'YYYY') >= 2018
    FOR UPDATE OF salariu NOWAIT;
    
-- Prin folosirea clauzei NOWAIT va fi returnata
-- o eroare in cazul in care liniile selectate
-- sunt deja blocate de catre alta comanda
    
BEGIN
    
-- Se foloseste un ciclu cursor pentru a
-- actualiza toate valorile selectate
    FOR i IN c LOOP
        UPDATE INSOTITORI
        SET salariu = salariu + ((salariu * 10) / 100)
        WHERE CURRENT OF c;
    END LOOP;
    
END procedura2;
/

SELECT * FROM INSOTITORI;

EXECUTE procedura2;

SELECT * FROM INSOTITORI;

ROLLBACK;

----------------------------------------------------------------------------------------
--- EXERCITIUL 8

-- Citindu-se numele unui pasager de la tastatura, sa se returneze
-- pretul total al rezervarii facute de acesta (pretul biletului +
-- pretul aditional pentru clasa, daca este cazul)

-- In cazul in care un pasager are mai multe rezervari,
-- se va returna suma tuturor preturilor totale

-- Se vor arunca erori in cazul in care: exista mai multi pasageri
-- cu numele dat, nu exista un pasager cu numele dat sau nu
-- exista rezervari facute de catre acest pasager

/
CREATE OR REPLACE FUNCTION functie1(v_nume PASAGERI.nume%TYPE)
RETURN REZERVA.pret_bilet%TYPE IS

    pret_total REZERVA.pret_bilet%TYPE;
    contor NUMBER;
BEGIN

-- Vom trata exceptiile la inceputul programului

-- Numaram cati pasageri exista cu numele dat ca parametru
    SELECT COUNT(*) INTO contor
    FROM PASAGERI WHERE INITCAP(v_nume) = INITCAP(nume);

-- Tratam cazul in care nu exista niciun pasager si
-- cazul in care exista mai multe pasageri cu numele dat
    IF contor = 0
    THEN RAISE_APPLICATION_ERROR(-20000, 'Nu exista un pasager cu acest nume');
    ELSIF contor > 1
    THEN RAISE_APPLICATION_ERROR(-20001, 'Exista mai multi pasageri cu acest nume');
    END IF;
    
-- Folosim aceiasi variabila pentru a numara cate rezervari exista
-- pentru pasagerul dat iar daca nu exista niciuna vom arunca o eroare
    SELECT COUNT(*) INTO contor
    FROM PASAGERI RIGHT OUTER JOIN REZERVA USING (id_pasager)
    WHERE INITCAP(v_nume) = INITCAP(nume);

    IF contor = 0
    THEN RAISE_APPLICATION_ERROR(-20002, 'Nu exista rezervari pe acest nume');
    END IF;

-- Functia de SUM va trata atat cazul in care exista o singura rezervare
-- dar si cazul in care exista mai multe iar functia NVL va inlocui posibila
-- valoare NULL a clasei cu codul 10 cu valoarea 0 pentru a o adauga la suma
    SELECT SUM(pret_bilet + NVL(pret_aditional, 0))
    INTO pret_total
    FROM REZERVA JOIN CLASE USING (cod_clasa) JOIN PASAGERI USING (id_pasager)
    WHERE INITCAP(v_nume) = INITCAP(PASAGERI.nume);
    
-- Sunt folosite 3 tabele pentru a accesa detalii despre pretul aditional al
-- clasei, numele pasagerilor si pretul biletului trecut in rezervare
    
-- Functia va returna valoarea calculata mai sus
    RETURN pret_total;
    
END functie1;
/

-- Are o singura rezervare (250 biletul + 300 pretul clasei)
SELECT functie1('IONITA') FROM DUAL;

-- Are doua rezervari: prima (300 biletul + 500 pretul clasei)
-- si a doua (350 biletul) cu totatul de 1150
SELECT functie1('Moldoveanu') FROM DUAL;

-- Nu exista un pasager cu acest nume deci vom primi eroare
SELECT functie1('Lazaroiu') FROM DUAL;

-- Exista 2 pasageri cu numele Barbu
-- deci ne va returna o eroare
SELECT functie1('Barbu') FROM DUAL;

-- Pasagerul exista insa nu are nicio rezervare
-- deci va ridica o eroare
SELECT functie1('popescu') FROM DUAL;

----------------------------------------------------------------------------------------
--- EXERCITIUL 9

--- Se da numele unui pilot ca parametru. Sa se afiseze numarul de calatorii
--- la care acesta a participat, numele aeroportului la care lucreaza
--- si numele orasului si al regiunii in care se afla aeroportul sau

/
CREATE OR REPLACE PROCEDURE procedura3 (nume_pilot PILOTI.nume%TYPE) IS

-- Vom declara variabilele in care vom salva
-- datele care trebuiesc selectate si afisate
    numar_calatorii NUMBER(4);
    nume_aeroport AEROPORTURI.nume%TYPE;
    nume_oras ORASE.nume%TYPE;
    nume_regiune REGIUNI.nume%TYPE;
    
BEGIN
    
-- Vom folosi un RIGHT JOIN intre CALATORII si PILOTI pentru
-- a include si pilotii care nu apar in tabelul de calatorii
-- (adica nu au facut nicio calatorie) dar apartin unui aeroport.
-- Conditia de JOIN intre aceastea verifica daca pilotul a fost
-- fie pilot principal, fie secundar si contorizeaza ambele cazuri

-- In continuare se face JOIN simplu cu tabelele AEROPORTURI, ORASE
-- si REGIUNI pentru a putea accesa si selecta numele acestora

    SELECT COUNT(cod_calatorie), a.nume, o.nume, r.nume
    INTO numar_calatorii, nume_aeroport, nume_oras, nume_regiune
    FROM CALATORII c RIGHT JOIN PILOTI p ON (id_pilot = id_pilot_principal OR
    id_pilot = id_pilot_secundar) JOIN AEROPORTURI a ON (p.cod_aeroport = cod_iata)
    JOIN ORASE o ON (o.cod_aeroport = cod_iata) JOIN REGIUNI r USING (cod_regiune)
    WHERE INITCAP(nume_pilot) = INITCAP(p.nume)
    GROUP BY a.nume, o.nume, r.nume;
    
-- Afisam in consola datele selectate mai sus
    DBMS_OUTPUT.PUT_LINE('Nume pilot: ' || INITCAP(nume_pilot));
    DBMS_OUTPUT.PUT_LINE('Numar de calatorii: ' || numar_calatorii);
    DBMS_OUTPUT.PUT_LINE('Numele aeroportului: ' || nume_aeroport);
    DBMS_OUTPUT.PUT_LINE('Orasul aeroportului in care lucreaza: ' || nume_oras);
    DBMS_OUTPUT.PUT_LINE('Regiunea in care se afla aeroportul: ' || nume_regiune);
    
EXCEPTION

    WHEN TOO_MANY_ROWS
    THEN RAISE_APPLICATION_ERROR(-20003, 'Exista mai multi piloti cu acest nume');
    WHEN NO_DATA_FOUND
    THEN RAISE_APPLICATION_ERROR(-20004, 'Nu exista piloti cu acest nume');
    
END procedura3;
/

EXECUTE procedura3('POPESCU');

-- Nu a facut nicio calatorie, deci va afisa 0
EXECUTE procedura3('avram');

-- Exista mai multi piloti cu numele Olteanu
-- deci programul va arunca o eroare
EXECUTE procedura3('Olteanu');

-- Nu exista un pilot cu numele Ionescu deci avem eroare
EXECUTE procedura3('Ionescu');

----------------------------------------------------------------------------------------
--- EXERCITIUL 10

-- Declansator care interzice stergerea
-- datelor din tabelul REZERVA

/
CREATE OR REPLACE TRIGGER trigger1
    BEFORE DELETE ON REZERVA
BEGIN
    RAISE_APPLICATION_ERROR(-20005, 'Nu se pot sterge date din tabelul REZERVA');
END;
/

DELETE FROM REZERVA
WHERE cod_rezervare = 100027;

----------------------------------------------------------------------------------------
--- EXERCITIUL 11

-- Declansator care interzice cresterea
-- pretului unui bilet cu mai mult de 100

/
CREATE OR REPLACE TRIGGER trigger2
    BEFORE UPDATE ON REZERVA
    FOR EACH ROW
BEGIN
    IF(:NEW.pret_bilet - :OLD.pret_bilet > 100)
    THEN RAISE_APPLICATION_ERROR(-20006, 'Pretul nu poate creste cu mai mult de 100');
    END IF;
END;
/

UPDATE REZERVA
SET pret_bilet = pret_bilet + 101
WHERE cod_rezervare = 100001;

----------------------------------------------------------------------------------------
--- EXERCITIUL 12

-- Declansator care afiseaza un mesaj de fiecare
-- data cand este rulata o comanda LDD

/
CREATE OR REPLACE TRIGGER trigger3
    AFTER CREATE OR ALTER OR DROP ON SCHEMA
BEGIN
    DBMS_OUTPUT.PUT_LINE('A FOST EFECTUATA O COMANDA LDD');
END;
/

ALTER TABLE PILOTI
ADD varsta NUMBER(2);

ALTER TABLE PILOTI
DROP COLUMN varsta;

-- Se va afisa mesajul in consola de 2 ori

----------------------------------------------------------------------------------------
--- EXERCITIUL 13

/
CREATE OR REPLACE PACKAGE pachet1 AS
    FUNCTION functie1(v_nume PASAGERI.nume%TYPE) RETURN REZERVA.pret_bilet%TYPE;
    PROCEDURE procedura1;
    PROCEDURE procedura2;
    PROCEDURE procedura3(nume_pilot PILOTI.nume%TYPE);
END pachet1;
/
CREATE OR REPLACE PACKAGE BODY pachet1 AS

-- Pretul total pentru rezervarile facute de un pasager
    FUNCTION functie1(v_nume PASAGERI.nume%TYPE)
    RETURN REZERVA.pret_bilet%TYPE IS
        pret_total REZERVA.pret_bilet%TYPE;
        contor NUMBER;
    BEGIN
        SELECT COUNT(*) INTO contor
        FROM PASAGERI WHERE INITCAP(v_nume) = INITCAP(nume);
    
        IF contor = 0
        THEN RAISE_APPLICATION_ERROR(-20000, 'Nu exista un pasager cu acest nume');
        ELSIF contor > 1
        THEN RAISE_APPLICATION_ERROR(-20001, 'Exista mai multi pasageri cu acest nume');
        END IF;
        
        SELECT COUNT(*) INTO contor
        FROM PASAGERI RIGHT OUTER JOIN REZERVA USING (id_pasager)
        WHERE INITCAP(v_nume) = INITCAP(nume);
    
        IF contor = 0
        THEN RAISE_APPLICATION_ERROR(-20002, 'Nu exista rezervari pe acest nume');
        END IF;
    
        SELECT SUM(pret_bilet + NVL(pret_aditional, 0))
        INTO pret_total
        FROM REZERVA JOIN CLASE USING (cod_clasa) JOIN PASAGERI USING (id_pasager)
        WHERE INITCAP(v_nume) = INITCAP(PASAGERI.nume);
        
        RETURN pret_total;
    END functie1;

-- Salariul mediu al pilotilor pentru fiecare aeroport
    PROCEDURE procedura1 IS
        TYPE aeroport_record IS RECORD
        (cod AEROPORTURI.cod_iata%TYPE,
        nume AEROPORTURI.nume%TYPE,
        salariu_mediu PILOTI.salariu%TYPE);
    
        TYPE tablou_imbricat IS TABLE OF aeroport_record;
        TYPE vector IS VARRAY(8) OF PILOTI.salariu%TYPE;
        CURSOR c IS
            SELECT cod_iata
            FROM AEROPORTURI;
        
        t tablou_imbricat := tablou_imbricat();
        r aeroport_record;
        v vector := vector();
    BEGIN
        FOR i IN c LOOP
            SELECT cod_iata, nume
            INTO r.cod, r.nume
            FROM AEROPORTURI
            WHERE i.cod_iata = cod_iata;
            
            v.EXTEND;
            
            SELECT AVG(salariu)
            INTO v(v.LAST)
            FROM PILOTI
            WHERE cod_aeroport = i.cod_iata;
            
            r.salariu_mediu := v(v.LAST);
            t.EXTEND;
            t(t.LAST) := r;
            
            DBMS_OUTPUT.PUT_LINE ('La aeroportul ' || t(t.LAST).nume ||
            'salariul mediu al pilotilor este de ' || t(t.last).salariu_mediu);
        END LOOP;
    END procedura1;
    
-- Mareste cu 10% salariul insotitorilor de zbor
-- angajati incepand cu anul 2018
    PROCEDURE procedura2 IS
        CURSOR c IS
        SELECT * FROM INSOTITORI
        WHERE TO_CHAR(data_angajarii, 'YYYY') >= 2018
        FOR UPDATE OF salariu NOWAIT;
    BEGIN
        FOR i IN c LOOP
            UPDATE INSOTITORI
            SET salariu = salariu + (salariu * 10)/100
            WHERE CURRENT OF c;
        END LOOP;
    END procedura2;
    
-- Detalii despre un pilot dat ca parametru
    PROCEDURE procedura3 (nume_pilot PILOTI.nume%TYPE) IS
        numar_calatorii NUMBER(4);
        nume_aeroport AEROPORTURI.nume%TYPE;
        nume_oras ORASE.nume%TYPE;
        nume_regiune REGIUNI.nume%TYPE;
    BEGIN
        SELECT COUNT(cod_calatorie), a.nume, o.nume, r.nume
        INTO numar_calatorii, nume_aeroport, nume_oras, nume_regiune
        FROM CALATORII c RIGHT JOIN PILOTI p ON (id_pilot = id_pilot_principal OR
        id_pilot = id_pilot_secundar) JOIN AEROPORTURI a ON (p.cod_aeroport = cod_iata)
        JOIN ORASE o ON (o.cod_aeroport = cod_iata) JOIN REGIUNI r USING (cod_regiune)
        WHERE INITCAP(nume_pilot) = INITCAP(p.nume)
        GROUP BY a.nume, o.nume, r.nume;
        
        DBMS_OUTPUT.PUT_LINE('Nume pilot: ' || INITCAP(nume_pilot));
        DBMS_OUTPUT.PUT_LINE('Numar de calatorii: ' || numar_calatorii);
        DBMS_OUTPUT.PUT_LINE('Numele aeroportului: ' || nume_aeroport);
        DBMS_OUTPUT.PUT_LINE('Orasul aeroportului in care lucreaza: ' || nume_oras);
        DBMS_OUTPUT.PUT_LINE('Regiunea in care se afla aeroportul: ' || nume_regiune);
    EXCEPTION
        WHEN TOO_MANY_ROWS
        THEN RAISE_APPLICATION_ERROR(-20003, 'Exista mai multi piloti cu acest nume');
        WHEN NO_DATA_FOUND
        THEN RAISE_APPLICATION_ERROR(-20004, 'Nu exista piloti cu acest nume');
    END procedura3;
    
END pachet1;
/

-- Pretul total pentru rezervarile facute de un pasager
SELECT pachet1.functie1('IONITA') FROM DUAL;

-- Salariul mediu al pilotilor pentru fiecare aeroport
EXECUTE pachet1.procedura1;

-- Mareste cu 10% salariul insotitorilor de zbor
-- angajati incepand cu anul 2018
EXECUTE pachet1.procedura2;

SELECT * FROM INSOTITORI;

ROLLBACK;

-- Detalii despre un pilot
EXECUTE pachet1.procedura3('POPESCU');

----------------------------------------------------------------------------------------
--- EXERCITIUL 14

-- Se creeaza un pachet ce contine un tabel imbricat
-- cu o coloana de tip inregistrare ce vor pastra date
-- despre angajatii aeroporturilor (piloti si insotitori)

-- Vor fi apelate 2 proceduri pentru a se introduce
-- datele in tabelul imbricat si se vor folosi 2 functii
-- pentru a calcula salariul mediul al angajatilor si
-- numarul de angajati care au salariul peste medie.
-- A doua functie se va folosi de prima.

/
CREATE OR REPLACE PACKAGE pachet2 AS
    TYPE angajati_record IS RECORD
    (nume PILOTI.nume%TYPE,
    prenume PILOTI.prenume%TYPE,
    cod_aeroport PILOTI.cod_aeroport%TYPE,
    salariu PILOTI.salariu%TYPE,
    titlu_job VARCHAR2(20));
    
    TYPE tablou_angajati IS TABLE OF angajati_record;
    
    t tablou_angajati := tablou_angajati();
    
    -- introduce date in tablou din tabelul PILOTI
    PROCEDURE procedura1_pachet;
    -- introduce date in tablou din tabelul INSOTITORI
    PROCEDURE procedura2_pachet;
    -- returneaza media salariilor angajatilor
    FUNCTION functie1_pachet RETURN NUMBER;
    -- returneaza numarul de angajati
    -- care au salariul peste medie
    FUNCTION functie2_pachet RETURN NUMBER;
END pachet2;
/

CREATE OR REPLACE PACKAGE BODY pachet2 AS
    
    -- preluarea datelor din tabelul PILOTI
    -- si introducerea lor in tablou
    PROCEDURE procedura1_pachet IS
        r angajati_record;
        CURSOR c IS
        SELECT id_pilot FROM PILOTI;
    BEGIN
        FOR i IN c LOOP
            SELECT nume, prenume, cod_aeroport, salariu, 'pilot'
            INTO r.nume, r.prenume, r.cod_aeroport, r.salariu, r.titlu_job
            FROM PILOTI WHERE id_pilot = i.id_pilot;
            
            t.EXTEND;
            t(t.LAST) := r;
        END LOOP;
    END procedura1_pachet;
    
    -- preluarea datelor din tabelul INSOTITORI
    -- si introducerea lor in tablou
    PROCEDURE procedura2_pachet IS
        r angajati_record;
        CURSOR c IS
        SELECT id_insotitor_de_zbor FROM INSOTITORI;
    BEGIN
        FOR i IN c LOOP
            SELECT nume, prenume, cod_aeroport, salariu, 'insotitor de zbor'
            INTO r.nume, r.prenume, r.cod_aeroport, r.salariu, r.titlu_job
            FROM INSOTITORI WHERE id_insotitor_de_zbor = i.id_insotitor_de_zbor;
            
            t.EXTEND;
            t(t.LAST) := r;
        END LOOP;
    END procedura2_pachet;
    
    -- functie ce calculeaza media salariilor angajatilor
    FUNCTION functie1_pachet RETURN NUMBER IS
        salariu NUMBER := 0;
    BEGIN
        FOR i IN t.FIRST..t.LAST LOOP
            salariu := salariu + t(i).salariu;
        END LOOP;
        
        salariu := ROUND(salariu / t.COUNT);
        
        RETURN salariu;
    END functie1_pachet;
    
    -- functie ce calculeaza numarul de angajati
    -- care au salariul mai mare decat media salariilor
    FUNCTION functie2_pachet RETURN NUMBER IS
        contor NUMBER := 0;
    BEGIN
        FOR i IN t.FIRST..t.LAST LOOP
            IF (t(i).salariu > functie1_pachet)
            THEN contor := contor + 1;
            END IF;
        END LOOP;
        RETURN contor;
    END functie2_pachet;

END pachet2;
/

-- Se vor rula cele 3 comenzi de mai jos in aceasta ordine
EXECUTE pachet2.procedura1_pachet;
EXECUTE pachet2.procedura2_pachet;

-- Numarul de angajati cu salariul peste medie
SELECT pachet2.functie2_pachet FROM dual;

-- Pentru resetarea valorilor din tablou se
-- va da DROP la pachet si se va recompila
DROP PACKAGE pachet2;