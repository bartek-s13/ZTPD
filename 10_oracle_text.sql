--1
CREATE TABLE CYTATY AS
SELECT * FROM ZSBD_TOOLS.CYTATY;

--2
SELECT * FROM CYTATY
WHERE lower(TEKST) LIKE '%pesymista%' 
AND  lower(TEKST) LIKE '%optymista%';

--3
create index CYTATY_IDX on CYTATY(TEKST)
indextype is CTXSYS.CONTEXT;

--4
SELECT * FROM CYTATY
WHERE CONTAINS(TEKST, 'optymista and pesymista')>0;

--5
SELECT * FROM CYTATY
WHERE CONTAINS(TEKST, 'pesymista not optymista')>0;

--6
