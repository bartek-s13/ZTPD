--1
create type samochod as object (
    marka varchar2(20),
    model varchar2(20),
    kilometry number,
    data_produkcji date,
    cena number(10,2)
);

desc samochod;

CREATE TABLE samochody OF samochod;

INSERT INTO samochody VALUES
    (NEW samochod('MAZDA', '323', 12000, DATE '2000-09-22', 52000))
;

select * from samochody;

--2

CREATE TABLE wlasciciele (
    imie varchar2(100),
    nazwisko varchar2(100),
    auto samochod    
    );

DESC wlasciciele;

INSERT ALL
   INTO wlasciciele VALUES ('JAN', 'KOWALSKI', NEW samochod('FIAT', 'SEICENTO', 30000, DATE '2010-12-02', 19500))
   INTO wlasciciele VALUES ('ADAM', 'NOWAK', NEW samochod('OPEL', 'ASTRA', 34000, '2009-06-01', 33700))
SELECT 1 FROM DUAL;

select * from wlasciciele;

--3
ALTER TYPE samochod REPLACE AS OBJECT (
    marka varchar2(20),
    model varchar2(20),
    kilometry number,
    data_produkcji date,
    cena number(10,2),
    MEMBER FUNCTION wartosc RETURN NUMBER);
    
CREATE OR REPLACE TYPE BODY samochod AS
    MEMBER FUNCTION wartosc RETURN NUMBER IS
        BEGIN            
            RETURN cena * POWER(0.9, (EXTRACT (YEAR FROM CURRENT_DATE) -  EXTRACT (YEAR FROM data_produkcji)));
        END wartosc;
    END;
 SELECT s.marka, s.cena, s.wartosc() FROM SAMOCHODY s;
 
 --4
 ALTER TYPE samochod ADD MAP MEMBER FUNCTION odwzoruj
RETURN NUMBER CASCADE INCLUDING TABLE DATA;

CREATE OR REPLACE TYPE BODY samochod AS
    MEMBER FUNCTION wartosc RETURN NUMBER IS
        BEGIN            
            RETURN cena * POWER(0.9, (EXTRACT (YEAR FROM CURRENT_DATE) -  EXTRACT (YEAR FROM data_produkcji)));
        END wartosc;
    MAP MEMBER FUNCTION odwzoruj RETURN NUMBER IS
        BEGIN
        RETURN (EXTRACT (YEAR FROM CURRENT_DATE) -  EXTRACT (YEAR FROM data_produkcji)) + kilometry/10000;
        END odwzoruj;
END;

SELECT * FROM SAMOCHODY s ORDER BY VALUE(s);

--5
create type wlasciciel as object (
    imie varchar2(100),
    nazwisko varchar2(100)
);


alter type samochod add attribute(w ref wlasciciel) CASCADE INCLUDING TABLE DATA;
drop table wlasiciele;
create table wlasciciele of wlasciciel;

ALTER TABLE samochody ADD
SCOPE FOR(w) is wlasciciele;


INSERT ALL
   INTO wlasciciele VALUES (new wlasciciel('JAN', 'KOWALSKI'))
   INTO wlasciciele VALUES (new wlasciciel('ADAM', 'NOWAK'))
SELECT 1 FROM DUAL;

--TODO
--6
set SERVEROUT on;
DECLARE
 TYPE t_przedmioty IS VARRAY(10) OF VARCHAR2(20);
 moje_przedmioty t_przedmioty := t_przedmioty('');
BEGIN
 moje_przedmioty(1) := 'MATEMATYKA';
 moje_przedmioty.EXTEND(9);
 FOR i IN 2..10 LOOP
 moje_przedmioty(i) := 'PRZEDMIOT_' || i;
 END LOOP;
 FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
 END LOOP;
moje_przedmioty.TRIM(2);
 FOR i IN moje_przedmioty.FIRST()..moje_przedmioty.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moje_przedmioty(i));
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
 moje_przedmioty.EXTEND();
 moje_przedmioty(9) := 9;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
 moje_przedmioty.DELETE();
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_przedmioty.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_przedmioty.COUNT());
END;

--7
DECLARE
 TYPE tytuly IS VARRAY(10) OF VARCHAR2(20);
 moje_tytuly tytuly := tytuly('');
 BEGIN
  moje_tytuly(1) := 'TYTUL1';
  moje_tytuly.extend(3);
  moje_tytuly(2) := 'TYTUL2';
  moje_tytuly(3) := 'TYTUL3';
  moje_tytuly.trim(1);
END;

--8
set SERVEROUT on;
DECLARE
 TYPE t_wykladowcy IS TABLE OF VARCHAR2(20);
 moi_wykladowcy t_wykladowcy := t_wykladowcy();
BEGIN
 moi_wykladowcy.EXTEND(2);
 moi_wykladowcy(1) := 'MORZY';
 moi_wykladowcy(2) := 'WOJCIECHOWSKI';
 moi_wykladowcy.EXTEND(8);
 FOR i IN 3..10 LOOP
 moi_wykladowcy(i) := 'WYKLADOWCA_' || i;
 END LOOP;
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END LOOP;
 moi_wykladowcy.TRIM(2);
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END LOOP;
 moi_wykladowcy.DELETE(5,7);
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 IF moi_wykladowcy.EXISTS(i) THEN
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END IF;
 END LOOP;
 moi_wykladowcy(5) := 'ZAKRZEWICZ';
 moi_wykladowcy(6) := 'KROLIKOWSKI';
 moi_wykladowcy(7) := 'KOSZLAJDA';
 FOR i IN moi_wykladowcy.FIRST()..moi_wykladowcy.LAST() LOOP
 IF moi_wykladowcy.EXISTS(i) THEN
 DBMS_OUTPUT.PUT_LINE(moi_wykladowcy(i));
 END IF;
 END LOOP;
 DBMS_OUTPUT.PUT_LINE('Limit: ' || moi_wykladowcy.LIMIT());
 DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moi_wykladowcy.COUNT());
END;

--9

DECLARE
 TYPE t_miesiace IS TABLE OF VARCHAR2(20);
 miesiace t_miesiace := t_miesiace();
BEGIN
miesiace.extend(12);
miesiace(1) := 'styczen';
miesiace(2) := 'luty';
miesiace(3) := 'marzec';
miesiace(4) := 'kwiecien';
miesiace(5) := 'maj';
miesiace(6) := 'czerwiec';
miesiace(7) := 'lipiec';
miesiace(8) := 'sierpien';
miesiace(9) := 'wrzesien';
miesiace(10) := 'pazdziernik';
miesiace(11) := 'listopad';
miesiace(12) := 'grudzien';
miesiace.delete(3,6);
 FOR i IN miesiace.FIRST()..miesiace.LAST() LOOP
 IF miesiace.EXISTS(i) THEN
 DBMS_OUTPUT.PUT_LINE(miesiace(i));
 END IF;
 END LOOP;
END;

--11
CREATE TYPE koszyk_produktow AS TABLE OF VARCHAR2(50);

CREATE TYPE zakupy AS OBJECT (
 numer NUMBER,
 produkty koszyk_produktow );
 
CREATE TABLE tab_zakupy OF zakupy
NESTED TABLE produkty STORE AS produkty;

INSERT INTO tab_zakupy VALUES
(zakupy(1,koszyk_produktow('Prod1','Prod2','Prod3')));
INSERT INTO tab_zakupy VALUES
(zakupy(2,koszyk_produktow('Prod2','Prod3', 'Prod4')));

INSERT INTO tab_zakupy VALUES
(zakupy(3,koszyk_produktow('Prod3','Prod4', 'Prod5')));


SELECT z.numer, p.*
FROM tab_zakupy z, TABLE(z.produkty) p;

DELETE FROM  tab_zakupy 
WHERE numer in (
SELECT z.numer
FROM tab_zakupy z, TABLE(z.produkty) p
where p.column_value = 'Prod2');

--22

CREATE TYPE KSIAZKI_TAB AS TABLE OF VARCHAR2(50);

CREATE TYPE PISARZ AS OBJECT (
    ID_PISARZA NUMBER,
    NAZWISKO VARCHAR2(20),
    DATA_UR DATE,
    KSIAZKI KSIAZKI_TAB,
    MEMBER FUNCTION ILE_KSIAZEK RETURN NUMBER
);

CREATE OR REPLACE TYPE BODY PISARZ AS
 MEMBER FUNCTION ILE_KSIAZEK RETURN NUMBER IS
 BEGIN
 RETURN KSIAZKI.COUNT();
 END ILE_KSIAZEK;
END;


CREATE TYPE KSIAZKA AS OBJECT (
    ID_KSIAZKI NUMBER,
    ID_PISARZA REF PISARZ,
    TYTUL VARCHAR2(50),
    DATA_WYDANIA DATE,
    MEMBER FUNCTION ILE_LAT_OD_WYDANIA RETURN NUMBER
);

CREATE OR REPLACE TYPE BODY KSIAZKA AS
 MEMBER FUNCTION ILE_LAT_OD_WYDANIA RETURN NUMBER IS
 BEGIN
 RETURN (EXTRACT (YEAR FROM CURRENT_DATE) -  EXTRACT (YEAR FROM DATA_WYDANIA));
 END ILE_LAT_OD_WYDANIA;
END;

CREATE OR REPLACE VIEW PISARZE_V OF PISARZ
WITH OBJECT IDENTIFIER (ID_PISARZA)
AS SELECT ID_PISARZA, NAZWISKO, DATA_UR,
 CAST(MULTISET( SELECT TYTUL FROM KSIAZKI WHERE ID_PISARZA=P.ID_PISARZA ) AS
KSIAZKI_TAB  )
FROM PISARZE P;


select p.nazwisko, p.ile_ksiazek()
from PISARZE_V P;

CREATE OR REPLACE VIEW KSIAZKI_V OF KSIAZKA
WITH OBJECT IDENTIFIER (ID_KSIAZKI)
AS SELECT ID_KSIAZKI,
MAKE_REF(PISARZE_V,ID_PISARZA),
TYTUL,
DATA_WYDANIA
FROM KSIAZKI K;

--23
CREATE TYPE AUTO_OSOBOWE UNDER AUTO (
    liczba_miejsc number,
    klimatyzacja CHAR(3),
    OVERRIDING MEMBER FUNCTION WARTOSC RETURN NUMBER
);

CREATE OR REPLACE TYPE BODY AUTO_OSOBOWE AS
 OVERRIDING MEMBER FUNCTION WARTOSC RETURN NUMBER IS
 WIEK NUMBER;
 WARTOSC NUMBER;
 BEGIN
 WIEK := ROUND(MONTHS_BETWEEN(SYSDATE,DATA_PRODUKCJI)/12);
 WARTOSC := CENA - (WIEK * 0.1 * CENA);
 IF (WARTOSC < 0) THEN
 WARTOSC := 0;
 END IF;
 IF (klimatyzacja = 'TAK') THEN
 WARTOSC := WARTOSC * 1.5;
 END IF;
 RETURN WARTOSC;
 END WARTOSC;
END;

CREATE TYPE AUTO_CIEZAROWE UNDER AUTO (
    maksymalna_ladownosc_tony number,
    OVERRIDING MEMBER FUNCTION WARTOSC RETURN NUMBER
);

CREATE OR REPLACE TYPE BODY AUTO_CIEZAROWE AS
 OVERRIDING MEMBER FUNCTION WARTOSC RETURN NUMBER IS
 WIEK NUMBER;
 WARTOSC NUMBER;
 BEGIN
 WIEK := ROUND(MONTHS_BETWEEN(SYSDATE,DATA_PRODUKCJI)/12);
 WARTOSC := CENA - (WIEK * 0.1 * CENA);
 IF (WARTOSC < 0) THEN
 WARTOSC := 0;
 END IF;
 IF (maksymalna_ladownosc_tony > 10) THEN
 WARTOSC := WARTOSC * 2;
 END IF;
 RETURN WARTOSC;
 END WARTOSC;
END;


INSERT INTO AUTA VALUES (AUTO_OSOBOWE('FIAT','OSOBOWY1',60000,DATE '2015-11-30',25000, 5, 'TAK'));
INSERT INTO AUTA VALUES (AUTO_OSOBOWE('FORD','OSOBOWY2',80000,DATE '2016-05-10',45000, 7, 'NIE'));
INSERT INTO AUTA VALUES (AUTO_CIEZAROWE('FIAT','CIEZAROWY1',12000,DATE '2017-09-22',52000, 8));
INSERT INTO AUTA VALUES (AUTO_CIEZAROWE('FORD','CIEZAROWY2',12000,DATE '2018-09-22',52000, 12));

SELECT a.marka, a.wartosc() FROM AUTA a;
