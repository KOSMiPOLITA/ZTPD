--CW1

--A

select lpad('-',2*(level-1),'|-') || t.owner||'.'||t.type_name||' (FINAL:'||t.final||
', INSTANTIABLE:'||t.instantiable||', ATTRIBUTES:'||t.attributes||', METHODS:'||t.methods||')'
from all_types t
start with t.type_name = 'ST_GEOMETRY'
connect by prior t.type_name = t.supertype_name
and prior t.owner = t.owner;

--B

select distinct m.method_name
from all_type_methods m
where m.type_name like 'ST_POLYGON'
and m.owner = 'MDSYS'
order by 1;

--C

create table MYST_MAJOR_CITIES (
    FIPS_CNTRY VARCHAR2(2),
    CITY_NAME VARCHAR2(40),
    STGEOM ST_POINT
);

--D

insert into MYST_MAJOR_CITIES
select C.FIPS_CNTRY, C.CITY_NAME,
TREAT(ST_POINT.FROM_SDO_GEOM(C.GEOM) AS ST_POINT) STGEOM
from MAJOR_CITIES C;

--CW2

--A
insert into MYST_MAJOR_CITIES values(
    'PL', 'Szczyrk', TREAT(ST_POINT.FROM_WKT('POINT(19.036107 49.718655)') as ST_POINT)
);

--B

select name, ST_GEOMETRY.FROM_SDO_GEOM(geom).GET_WKT() as WKT from rivers;

--C

select SDO_UTIL.TO_GMLGEOMETRY(c.stgeom.get_sdo_geom()) from MYST_MAJOR_CITIES c
where city_name = 'Szczyrk';

--CW3

--A

create table MYST_COUNTRY_BOUNDARIES(
FIPS_CNTRY VARCHAR2(2),
CNTRY_NAME VARCHAR2(40),
STGEOM ST_MULTIPOLYGON
);

--B

insert into MYST_COUNTRY_BOUNDARIES 
select FIPS_CNTRY, CNTRY_NAME, 
ST_MULTIPOLYGON(c.GEOM) STGEOM
from COUNTRY_BOUNDARIES c;


--C

select c.stgeom.ST_GeometryType() as TYP_OBIEKTU, count(*) as ILE from MYST_COUNTRY_BOUNDARIES c group by c.stgeom.ST_GeometryType();

--D

select c.STGEOM.ST_ISSIMPLE() from MYST_COUNTRY_BOUNDARIES c;

--CW4

--A

select B.CNTRY_NAME, count(*)
from MYST_COUNTRY_BOUNDARIES B,
MYST_MAJOR_CITIES C
where C.CITY_NAME <> 'Szczyrk' and B.STGEOM.ST_CONTAINS(C.STGEOM) = 1
group by B.CNTRY_NAME;

--B

select A.CNTRY_NAME A_NAME, B.CNTRY_NAME B_NAME
from MYST_COUNTRY_BOUNDARIES A,
MYST_COUNTRY_BOUNDARIES B
where A.STGEOM.ST_TOUCHES(B.STGEOM) = 1
and B.CNTRY_NAME = 'Czech Republic';

--C

select distinct B.CNTRY_NAME, R.name
from MYST_COUNTRY_BOUNDARIES B, RIVERS R
where B.CNTRY_NAME = 'Czech Republic'
and ST_LINESTRING(R.GEOM).ST_INTERSECTS(B.STGEOM) = 1;

--D
select A.STGEOM.ST_UNION(B.STGEOM) CZECHOSLOWACJA
from MYST_COUNTRY_BOUNDARIES A, MYST_COUNTRY_BOUNDARIES B
where A.CNTRY_NAME = 'Czech Republic'
and B.CNTRY_NAME = 'Slovakia';

--EPrzetwarzanie danych przestrzennych SQL-MM

select TREAT(B.STGEOM.ST_DIFFERENCE(ST_GEOMETRY(W.GEOM)) as ST_POLYGON).ST_GeometryType()
from MYST_COUNTRY_BOUNDARIES B, WATER_BODIES W
where B.CNTRY_NAME = 'Hungary'
and W.name = 'Balaton';

--CW5

--A

select B.CNTRY_NAME A_NAME, count(*)
from MYST_COUNTRY_BOUNDARIES B, MYST_MAJOR_CITIES C
where SDO_WITHIN_DISTANCE(C.STGEOM, B.STGEOM,
'distance=100 unit=km') = 'TRUE'
and C.CITY_NAME <> 'Szczyrk' and B.CNTRY_NAME = 'Poland'
group by B.CNTRY_NAME;

--B

insert into USER_SDO_GEOM_METADATA 
select 'MYST_MAJOR_CITIES', 'STGEOM', a.diminfo, a.srid
from USER_SDO_GEOM_METADATA a
where a.table_name = 'MAJOR_CITIES';

--C

create index MYST_MAJOR_CITIES_IDX on
MYST_MAJOR_CITIES(STGEOM)
indextype IS MDSYS.SPATIAL_INDEX;

--D

explain plan for
select B.CNTRY_NAME A_NAME, count(*)
from MYST_COUNTRY_BOUNDARIES B, MYST_MAJOR_CITIES C
where SDO_WITHIN_DISTANCE(C.STGEOM, B.STGEOM,
'distance=100 unit=km') = 'TRUE'
and C.CITY_NAME <> 'Szczyrk' and B.CNTRY_NAME = 'Poland'
group by B.CNTRY_NAME;

select plan_table_output from table(dbms_xplan.display('plan_table', null, 'basic'));
