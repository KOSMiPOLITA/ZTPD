select * from USER_SDO_GEOM_METADATA;

--cw1

--A

insert into USER_SDO_GEOM_METADATA values(
    'FIGURY',
    'KSZTALT',
    MDSYS.SDO_DIM_ARRAY(
    MDSYS.SDO_DIM_ELEMENT('X', 0, 9, 0.01),
    MDSYS.SDO_DIM_ELEMENT('Y', 0, 8, 0.01)),
    NULL );
    
delete from USER_SDO_GEOM_METADATA where srid = 0;
    
--B

select SDO_TUNE.ESTIMATE_RTREE_INDEX_SIZE(3000000,8192,10,2,0) from dual; 

--C

create index figury_idx
on figury(ksztalt)
indextype is MDSYS.SPATIAL_INDEX_V2;

drop index figury_idx;

--D

select ID from FIGURY
where SDO_FILTER(KSZTALT, SDO_GEOMETRY(2001,null,SDO_POINT_TYPE(3,3,null),null,null)) = 'TRUE';

--E

select ID from FIGURY where SDO_RELATE(KSZTALT, SDO_GEOMETRY(2001,null, SDO_POINT_TYPE(3,3,null), null,null), 'mask=ANYINTERACT') = 'TRUE';

--CW2

--A

select A.CITY_NAME MIASTO, SDO_NN_DISTANCE(1) DISTANCE
from MAJOR_CITIES A
where SDO_NN(
    GEOM, (select m.geom from MAJOR_CITIES m where CITY_NAME='Warsaw'),
'sdo_num_res=10 unit=km',1) = 'TRUE' and city_name <> 'Warsaw';

--B

select C.CITY_NAME
from MAJOR_CITIES C
where SDO_WITHIN_DISTANCE(C.GEOM,(select m.geom from MAJOR_CITIES m where CITY_NAME='Warsaw'),
'distance=100 unit=km') = 'TRUE' and city_name <> 'Warsaw';

--C

select b.cntry_name, c.city_name
from COUNTRY_BOUNDARIES b, MAJOR_CITIES c
where SDO_RELATE(c.GEOM, b.GEOM, 'mask=INSIDE') = 'TRUE' and b.cntry_name = 'Slovakia';

--D

select b.cntry_name, SDO_GEOM.SDO_DISTANCE(b.GEOM, c.GEOM, 1, 'unit=km') DISTANCE 
from COUNTRY_BOUNDARIES b, COUNTRY_BOUNDARIES c where SDO_RELATE(b.GEOM, c.GEOM, 'mask=TOUCH') != 'TRUE' and c.cntry_name = 'Poland' and b.cntry_name != 'Poland';

--CW3

--A

select B.CNTRY_NAME, SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(A.GEOM, B.GEOM, 1), 1, 'unit=km')
from COUNTRY_BOUNDARIES A, COUNTRY_BOUNDARIES B where A.CNTRY_NAME = 'Poland';

--B

select A.CNTRY_NAME from COUNTRY_BOUNDARIES A 
where SDO_GEOM.SDO_AREA(A.GEOM, 1, 'unit=SQ_KM') = (select max(SDO_GEOM.SDO_AREA(B.GEOM, 1, 'unit=SQ_KM')) from COUNTRY_BOUNDARIES B);

--C

select SDO_GEOM.SDO_AREA(SDO_AGGR_MBR(GEOM)) 
from MAJOR_CITIES where city_name in ('Warsaw', 'Lodz');

--D

select SDO_GEOM.SDO_UNION(A.GEOM, B.GEOM, 1).get_gtype() TYPE
from COUNTRY_BOUNDARIES A, MAJOR_CITIES B
where A.CNTRY_NAME = 'Poland'
and B.CITY_NAME = 'Prague';

--E

select * from (select a.city_name, cntry_name from major_cities a join COUNTRY_BOUNDARIES b using(cntry_name) order by
SDO_GEOM.SDO_DISTANCE(a.geom, sdo_geom.sdo_centroid(b.geom),1)
) where rownum = 1;

--F

SELECT name, SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(a.geom, b.geom, 1), 1, 'unit=km') AS distance
FROM country_boundaries a, rivers b WHERE a.cntry_name = 'Poland' AND SDO_RELATE(a.geom, b.geom, 'mask=OVERLAPBDYINTERSECT') = 'TRUE';
