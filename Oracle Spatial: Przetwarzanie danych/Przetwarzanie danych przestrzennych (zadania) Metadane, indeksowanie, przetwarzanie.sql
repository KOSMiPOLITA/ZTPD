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
