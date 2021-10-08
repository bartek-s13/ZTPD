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
create type wlasciciel as object (
    marka varchar2(100),
    model varchar2(100),
    auto samochod
);

CREATE TABLE wlasciciele OF wlasciciel;

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
