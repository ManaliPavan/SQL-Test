using Apple;

CREATE SCHEMA hospital;

--1.create table
/*Create table-Doctor*/
CREATE TABLE hospital.doctor
(did int CONSTRAINT pkey PRIMARY KEY,
dname varchar(25),
daddress varchar(25),
qualification varchar(50),
noofpatient_handled int);

/*create table-PatientMaster*/
CREATE TABLE hospital.patientmaster
(pcode int CONSTRAINT pkey_patient PRIMARY KEY,
pname varchar(25),
paddr varchar(25),
age int,gender varchar(25),
bloodgroup varchar(25));

/*create table AdmittedPatient*/
CREATE TABLE hospital.admittedpatient
(Pcode int,CONSTRAINT fkey_adpatient  FOREIGN KEY (Pcode) REFERENCES hospital.patientmaster(Pcode),
Entry_date date,CONSTRAINT pkey_admitted PRIMARY KEY(Pcode,Entry_date),
Discharge_date date,
wardno int,
disease varchar(25),
did int,CONSTRAINT fkey_admitted FOREIGN KEY (did) REFERENCES hospital.doctor(did));

/*create table Bill*/
CREATE TABLE hospital.bill
(Pcode int,CONSTRAINT fkey_bill FOREIGN KEY (Pcode) REFERENCES hospital.patientmaster(Pcode),
bill_amount bigint,
CONSTRAINT pkey_bill PRIMARY KEY(Pcode,bill_amount));

/*Insert data*/
--9.
INSERT INTO hospital.doctor VALUES 
(11,'manali','pune','MBBS',890),
(22,'vrushali','pune','Dentist',890),
(33,'sonali','mumbai','MBBS',890),
(44,'monali','mumbai','Surgen',890),
(55,'mrunali','pune','Dentist',890);
INSERT INTO hospital.doctor VALUES 
(66,'mana','mumbai','MBBS',10);

INSERT INTO hospital.patientmaster VALUES
(6,'sanu','pune',29,'female','A+'),
(1,'manali','pune',23,'female','A+'),
(2,'sonali','pune',24,'female','A+'),
(3,'raj','mumbai',26,'male','B+'),
(4,'swaraj','thane',28,'male','B+'),
(5,'mrunali','pune',24,'female','AB+');

INSERT INTO hospital.admittedpatient VALUES
(1,'2029-09-09','2021-09-21',121,'covid19',11),
(1,'2021-09-09','2021-09-21',121,'cancer',11),
(2,'2021-12-09','2022-02-21',121,'cancer',11),
(3,'2021-09-09','2021-09-21',122,'wisdomtooth',22),
(4,'2022-09-09','2022-09-21',122,'wisdomtooth',22),
(5,'2023-09-09','2023-11-21',123,'major surgery',44),
(3,'2021-03-09','2021-02-21',123,'minor surgery',44),
(1,'2024-09-09','2024-09-21',122,'wisdomtooth',55);

INSERT INTO hospital.bill VALUES
(1,100000),
(2,200000),
(3,1000),
(4,1000),
(5,210000);

/*Queries*/

--2.select queries
SELECT * FROM hospital.doctor;
SELECT * FROM hospital.patientmaster;
SELECT * FROM hospital.admittedpatient;
SELECT * FROM hospital.bill;

--3.drop primary key in patientmaster
ALTER TABLE hospital.patientmaster 
DROP CONSTRAINT pkey_patient;

--4.Add col in admittedpatient
ALTER TABLE hospital.admittedpatient 
ADD discharge_date date;

--5.change data type
ALTER TABLE hospital.admittedpatient 
ALTER COLUMN wardno varchar(10);

--6.drop 1 foreign key in admittedpatient
ALTER TABLE hospital.admittedpatient 
DROP CONSTRAINT fkey_admitted;

--7.add foreign key with update and delete cascade in admittedpatient
ALTER TABLE hospital.admittedpatient 
ADD CONSTRAINT fkey_admitted FOREIGN KEY(did)
REFERENCES hospital.doctor(did)  ON UPDATE CASCADE ON DELETE CASCADE;

--8.add primary key in patientmaster
ALTER TABLE hospital.patientmaster 
ADD CONSTRAINT pkey_patient PRIMARY KEY(Pcode);

--10.no of doc.as per qual
SELECT qualification,COUNT(*) 'doctors' FROM hospital.doctor
GROUP BY qualification;

--11.doc qual==md or MBBS
SELECT * FROM hospital.doctor
WHERE qualification='md' or qualification='MBBS';

--12.patient with age=21 to 27 & bld.grp. =A+
SELECT * FROM hospital.patientmaster
WHERE bloodgroup='A+' AND age BETWEEN 21 AND 27;

--13.doc with add=mumbai handled patient=10
SELECT * FROM hospital.doctor 
WHERE daddress='mumbai' AND noofpatient_handled=10;

--14.count patient as per b.grp
SELECT bloodgroup,COUNT(*)'patients' FROM hospital.patientmaster 
GROUP BY bloodgroup;

--15.max(bill amount) & min(bill amount)
SELECT MIN(bill_amount)'Min BillAmount',MAX(bill_amount)'Max BillAmount' FROM hospital.bill;

--16.doc with noofpatient>10
SELECT * FROM hospital.doctor WHERE noofpatient_handled > 10;

--17.Patients from pune
SELECT * FROM hospital.patientmaster WHERE paddr='pune';

--18.patient with AB+ & female
SELECT * FROM hospital.patientmaster WHERE bloodgroup='AB+' AND gender='female';

--19.delete patient with wardno =4or 6 with disease covid 19
DELETE FROM hospital.admittedpatient WHERE wardno=4 OR wardno=6  AND disease='covid 19';

--20.remove all records from bill table
DELETE FROM hospital.bill;

--21.doctor details who treating patient in ward 3
SELECT D.did,D.dname,D.daddress,D.qualification,D.noofpatient_handled
FROM hospital.doctor D 
INNER JOIN hospital.admittedpatient AP  ON D.did=AP.did
WHERE wardno=123;

--22.patient disese=dengue & age<30 bldgrp=A
SELECT P.pcode,P.pname,P.paddr,P.age,P.gender,P.bloodgroup,AP.disease
FROM hospital.patientmaster  P 
INNER JOIN hospital.admittedpatient AP
ON P.pcode=AP.pcode 
WHERE age<30 AND bloodgroup='A' AND disease='dengue';

--23patient recovered from dengue and bill amt>10000
SELECT P.pcode,P.pname,P.paddr,P.age,P.gender,P.bloodgroup,AP.disease
FROM hospital.patientmaster  P 
INNER JOIN hospital.admittedpatient AP 
ON P.pcode=AP.pcode 
INNER JOIN hospital.bill B
ON P.pcode=B.pcode 
WHERE AP.disease='dengue' AND B.bill_amount>10000;

--24 patient with doc qual=MBBS
SELECT p.*
FROM hospital.patientmaster p 
INNER JOIN hospital.admittedpatient ap 
ON p.pcode=ap.Pcode
INNER JOIN hospital.doctor d
ON ap.did=d.did
WHERE d.qualification='MBBS';

