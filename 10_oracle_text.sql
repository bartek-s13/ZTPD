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
SELECT * FROM CYTATY
WHERE CONTAINS(TEKST, 'near((optymista, pesymista),3)')>0;

--7
SELECT * FROM CYTATY
WHERE CONTAINS(TEKST, 'near((optymista, pesymista),10)')>0;

--8
SELECT * FROM CYTATY 
WHERE CONTAINS(TEKST, 'życi%') > 0;

--9
SELECT AUTOR, TEKST, SCORE(1) as DOPASOWANIE FROM CYTATY 
WHERE CONTAINS(TEKST, 'życi%', 1) > 0;

--10
SELECT AUTOR, TEKST, SCORE(1) as DOPASOWANIE FROM CYTATY 
WHERE CONTAINS(TEKST, 'życi%', 1) > 0
ORDER BY SCORE(1) DESC
FETCH FIRST ROW ONLY;

--11
SELECT AUTOR, TEKST FROM CYTATY 
WHERE CONTAINS(TEKST, 'FUZZY(probelm)') > 0;

--12
INSERT INTO CYTATY
VALUES(39, 'Bertrand Russell', 'To smutne, że głupcy są tacy pewni siebie, a ludzie rozsądni tacy pełni wątpliwości.');
COMMIT;

--13
SELECT * FROM CYTATY 
WHERE CONTAINS(TEKST, 'głupcy') > 0;

--14
SELECT * FROM DR$CYTATY_IDX$I;

--15
DROP INDEX CYTATY_IDX;

create index CYTATY_IDX on CYTATY(TEKST)
indextype is CTXSYS.CONTEXT;

--16
SELECT * FROM CYTATY 
WHERE CONTAINS(TEKST, 'głupcy') > 0;

--17
DROP INDEX CYTATY_IDX;
DROP TABLE CYTATY;

--Zaawansowane indeksowanie i wyszukiwanie
--1
CREATE TABLE QUOTES AS
SELECT * FROM ZSBD_TOOLS.QUOTES;

--2
create index QUOTES_IDX on QUOTES(TEXT)
indextype is CTXSYS.CONTEXT;

--3
SELECT * FROM QUOTES 
WHERE CONTAINS(TEXT, 'work') > 0;

SELECT * FROM QUOTES 
WHERE CONTAINS(TEXT, '$work') > 0;

SELECT * FROM QUOTES 
WHERE CONTAINS(TEXT, 'working') > 0;

SELECT * FROM QUOTES 
WHERE CONTAINS(TEXT, '$working') > 0;

--4
SELECT * FROM QUOTES 
WHERE CONTAINS(TEXT, 'it') > 0;

--5
SELECT * FROM CTX_STOPLISTS;

--6
SELECT * FROM CTX_STOPWORDS;

--7
DROP INDEX QUOTES_IDX;
create index QUOTES_IDX on QUOTES(TEXT)
indextype is CTXSYS.CONTEXT
PARAMETERS('stoplist CTXSYS.EMPTY_STOPLIST');

--8
SELECT * FROM QUOTES 
WHERE CONTAINS(TEXT, 'it') > 0;

--9
SELECT * FROM QUOTES 
WHERE CONTAINS(TEXT, 'fool and humans') > 0;

--10
SELECT * FROM QUOTES 
WHERE CONTAINS(TEXT, 'fool and computer') > 0;

--11
SELECT * FROM QUOTES 
WHERE CONTAINS(TEXT, '(fool and computer) within SENTENCE') > 0;

--12
DROP INDEX QUOTES_IDX;

--13
begin
 ctx_ddl.create_section_group('nullgroup', 'NULL_SECTION_GROUP');
 ctx_ddl.add_special_section('nullgroup', 'SENTENCE');
 ctx_ddl.add_special_section('nullgroup', 'PARAGRAPH');
end;

--14
create index QUOTES_IDX on QUOTES(TEXT)
indextype is CTXSYS.CONTEXT
PARAMETERS('stoplist CTXSYS.EMPTY_STOPLIST
            section group nullgroup');
            
--15
SELECT * FROM QUOTES 
WHERE CONTAINS(TEXT, '(fool and humans) within SENTENCE') > 0;

SELECT * FROM QUOTES 
WHERE CONTAINS(TEXT, '(fool and computer) within SENTENCE') > 0;

--16
SELECT * FROM QUOTES 
WHERE CONTAINS(TEXT, 'humans') > 0;

--17
DROP INDEX QUOTES_IDX;

begin
 ctx_ddl.create_preference('lex_z_m','BASIC_LEXER');
 ctx_ddl.set_attribute('lex_z_m',
 'printjoins', '-');
 ctx_ddl.set_attribute ('lex_z_m',
 'index_text', 'YES');
end;

create index QUOTES_IDX on QUOTES(TEXT)
indextype is CTXSYS.CONTEXT
PARAMETERS('stoplist CTXSYS.EMPTY_STOPLIST
            section group nullgroup
            LEXER lex_z_m');
            
--18
SELECT * FROM QUOTES 
WHERE CONTAINS(TEXT, 'humans') > 0;

--19
SELECT * FROM QUOTES 
WHERE CONTAINS(TEXT, 'non\-humans') > 0;

--20 
DROP TABLE QUOTES;

BEGIN
ctx_ddl.drop_preference('lex_z_m');
END;
