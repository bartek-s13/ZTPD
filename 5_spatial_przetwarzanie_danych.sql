--1
--A
INSERT INTO USER_SDO_GEOM_METADATA
VALUES (
'FIGURY', 'KSZTALT',
MDSYS.SDO_DIM_ARRAY(
MDSYS.SDO_DIM_ELEMENT('X', 0, 20, 0.01),
MDSYS.SDO_DIM_ELEMENT('Y', 0, 20, 0.01) ),
NULL );

--B
select sdo_tune.estimate_rtree_index_size(3000000,8192,10,2,0) from FIGURY;

--C
CREATE INDEX figura_spatial_idx
ON FIGURY(KSZTALT)
INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2;

--D
select ID
from FIGURY
where SDO_FILTER(KSZTALT,
SDO_GEOMETRY(2001,null,
 SDO_POINT_TYPE(3,3,null),
 null,null)) = 'TRUE';
 
--Nie
--SDO_FILTER  daje w wyniku zbiór "kandydatów", dla indeksu r-tree

--E
select ID
from FIGURY
where SDO_RELATE(KSZTALT,
 SDO_GEOMETRY(2001,null,
 SDO_POINT_TYPE(3,3,null),
 null,null),
 'mask=ANYINTERACT') = 'TRUE';
 
--Tak
select GEOM from MAJOR_CITIES WHERE CITY_NAME = 'Warsaw';

--2
--A
select A.CITY_NAME, SDO_NN_DISTANCE(1) DISTANCE
from MAJOR_CITIES A
where SDO_NN(GEOM,(select GEOM from MAJOR_CITIES WHERE CITY_NAME = 'Warsaw'),
 'sdo_num_res=10 unit=km',1) = 'TRUE' and A.CITY_NAME <> 'Warsaw';
 
 --B
 select C.CITY_NAME
from MAJOR_CITIES C
where SDO_WITHIN_DISTANCE(C.GEOM,
(select GEOM from MAJOR_CITIES WHERE CITY_NAME = 'Warsaw') ,
 'distance=100 unit=km') = 'TRUE' and C.CITY_NAME <> 'Warsaw';
 
 --C
select distinct B.CNTRY_NAME, C.CITY_NAME
from COUNTRY_BOUNDARIES B, MAJOR_CITIES C
where B.CNTRY_NAME = 'Slovakia' and SDO_RELATE(B.GEOM, C.GEOM, 'mask=CONTAINS')  = 'TRUE';

--D 
SELECT 
    CNTRY_NAME,
    SDO_GEOM.SDO_DISTANCE(GEOM, (SELECT GEOM FROM COUNTRY_BOUNDARIES WHERE CNTRY_NAME = 'Poland'), 1, 'unit=km')
FROM COUNTRY_BOUNDARIES 
WHERE not SDO_RELATE(GEOM,(SELECT GEOM FROM COUNTRY_BOUNDARIES WHERE CNTRY_NAME = 'Poland'), 'mask=EQUAL')  = 'TRUE';

--3
--A
select 
 B.CNTRY_NAME,
 ROUND(SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(A.GEOM, B.GEOM, 1), 1, 'unit=km'))
from COUNTRY_BOUNDARIES A,
 COUNTRY_BOUNDARIES B
where A.CNTRY_NAME = 'Poland' AND SDO_RELATE(A.GEOM,B.GEOM, 'mask=TOUCH')  = 'TRUE';

--B
SELECT 
    CNTRY_NAME
FROM COUNTRY_BOUNDARIES 
WHERE SDO_GEOM.SDO_AREA(GEOM) = (SELECT MAX(SDO_GEOM.SDO_AREA(GEOM)) FROM COUNTRY_BOUNDARIES);

--C
SELECT
    ROUND(SDO_GEOM.SDO_AREA(SDO_GEOM.SDO_MBR( SDO_GEOM.SDO_UNION(A.GEOM, B.GEOM, 1)),1, 'unit=SQ_KM'), 5) SQ_KM    
FROM MAJOR_CITIES A, MAJOR_CITIES B
WHERE A.CITY_NAME = 'Warsaw' AND B.CITY_NAME = 'Lodz';

--D
SELECT 
    SDO_GEOM.SDO_UNION(A.GEOM, B.GEOM, 1).GET_DIMS() ||
    SDO_GEOM.SDO_UNION(A.GEOM, B.GEOM, 1).GET_LRS_DIM() ||
    LPAD(SDO_GEOM.SDO_UNION(A.GEOM, B.GEOM, 1).GET_GTYPE(), 2, '0') geom
FROM MAJOR_CITIES A, COUNTRY_BOUNDARIES B
WHERE A.CITY_NAME = 'Prague' AND B.CNTRY_NAME = 'Poland';

--E
SELECT M.CITY_NAME, P.CNTRY_NAME
FROM MAJOR_CITIES M JOIN COUNTRY_BOUNDARIES P ON M.CNTRY_NAME = P.CNTRY_NAME
WHERE SDO_GEOM.SDO_DISTANCE(SDO_GEOM.SDO_CENTROID(P.GEOM,1), M.GEOM,1) =
(SELECT
        MIN(SDO_GEOM.SDO_DISTANCE(SDO_GEOM.SDO_CENTROID(PP.GEOM,1), MM.GEOM,1))
        FROM MAJOR_CITIES MM JOIN COUNTRY_BOUNDARIES PP ON MM.CNTRY_NAME = PP.CNTRY_NAME);

--F
select R.name,
SUM(SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(R.GEOM, B.GEOM, 1), 1, 'unit=km')) DLUGOSC
from COUNTRY_BOUNDARIES B, RIVERS R
where B.CNTRY_NAME = 'Poland'AND SDO_RELATE(B.GEOM, R.GEOM, 'mask=ANYINTERACT') = 'TRUE'
GROUP BY R.name;
