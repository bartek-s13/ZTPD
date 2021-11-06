--1
CREATE TABLE DOKUMENTY (
ID NUMBER(12) PRIMARY KEY,
DOKUMENT CLOB
);

--2
DECLARE
x CLOB := 'Oto tekst. ';
BEGIN   
    FOR i in 1..10000 LOOP
        x := x || 'Oto tekst. ';
    END LOOP;
    insert into DOKUMENTY 
    VALUES(1, x);
END;

--3
--a
select * from DOKUMENTY;
--b
select UPPER(DOKUMENT) from DOKUMENTY;
--c
select LENGTH(DOKUMENT) from DOKUMENTY;
--d
select  DBMS_LOB.GETLENGTH(DOKUMENT) from DOKUMENTY;
--e
select  SUBSTR(DOKUMENT,5,1000) from DOKUMENTY;
--f
select  DBMS_LOB.SUBSTR(DOKUMENT,1000,5) from DOKUMENTY;

--4
insert into DOKUMENTY VALUES(2, EMPTY_CLOB());

--5
insert into DOKUMENTY VALUES(3, NULL);

--8
DECLARE
    lobd clob;
    doc BFILE := BFILENAME('ZSBD_DIR','dokument.txt');
    doffset integer := 1;
    soffset integer := 1;
    langctx integer := 0;
    warn integer := null;
BEGIN
    SELECT DOKUMENT INTO lobd
    FROM DOKUMENTY
    where id=2
    FOR UPDATE;
    
    DBMS_LOB.fileopen(doc, DBMS_LOB.file_readonly);
    DBMS_LOB.LOADCLOBFROMFILE(lobd,doc,DBMS_LOB.GETLENGTH(doc), doffset, soffset, 0, langctx, warn);
    DBMS_LOB.FILECLOSE(doc);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Status operacji: '||warn);
END;

--9
UPDATE DOKUMENTY 
SET dokument=TO_CLOB(BFILENAME('ZSBD_DIR','dokument.txt'))
where id=3;

--10
select * from dokumenty;
--11
select  DBMS_LOB.GETLENGTH(DOKUMENT) from DOKUMENTY;
--12 
DROP TABLE DOKUMENTY;

--13
CREATE OR REPLACE PROCEDURE  CLOB_CENSOR (to_change IN OUT clob, to_replace VARCHAR2) IS
replacement VARCHAR2(250);
BEGIN
    replacement := rpad('.',LENGTH(to_replace),'.');
    WHILE DBMS_LOB.INSTR(to_change, to_replace) > 0
    LOOP
        DBMS_LOB.WRITE(to_change, LENGTH(to_replace), DBMS_LOB.INSTR(to_change, to_replace), replacement);
    END LOOP;    
END;

--14 
CREATE TABLE BIOGRAPHIES as SELECT * FROM ZSBD_TOOLS.BIOGRAPHIES;

BEGIN
    SELECT BIO
    INTO v_clob
    FROM BIOGRAPHIES
    WHERE ID = 1
    FOR UPDATE;
    CLOB_CENSOR(v_clob, 'Cimrman');
END;

DECLARE
input_text clob ;

BEGIN
SELECT bio into input_text from BIOGRAPHIES where person='Jara Cimrman' for update;
CLOB_CENSOR(input_text, 'Cimrman') ;
END;

SELECT bio from BIOGRAPHIES where person='Jara Cimrman';

--15
DROP TABLE BIOGRAPHIES;
