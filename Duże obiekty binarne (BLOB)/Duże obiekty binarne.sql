--zad1
create TABLE MOVIES(
    ID NUMBER(12) PRIMARY KEY,
    TITLE VARCHAR2(400) NOT NULL,
    CATEGORY VARCHAR2(50),
    YEAR CHAR(4),
    CAST VARCHAR2(4000),
    DIRECTOR VARCHAR2(4000),
    STORY VARCHAR2(4000),
    PRICE NUMBER(5,2),
    COVER BLOB,
    MIME_TYPE VARCHAR2(50)
);

--zad2
insert into MOVIES (ID, TITLE,CATEGORY,YEAR,CAST,DIRECTOR,STORY,PRICE,COVER,MIME_TYPE) 
select d.ID, d.TITLE, d.CATEGORY, trim(to_char(d.YEAR, '9999')) as YEAR, 
d.CAST, d.DIRECTOR, d.STORY, d.PRICE, c.IMAGE, c.MIME_TYPE from DESCRIPTIONS 
d FULL OUTER JOIN COVERS c on d.id = c.movie_id;

--zad3
select id, title from movies where cover is null;

--zad4
select id, title, dbms_lob.getlength(cover) as FILESIZE from movies where cover is not null;

--zad5
select id, title, dbms_lob.getlength(cover) as FILESIZE from movies where cover is null;

--zad6
select * from all_directories;

--zad7
update MOVIES set MIME_TYPE = 'image/jpeg', COVER = EMPTY_BLOB() where ID = '66';

--zad8
select id, title, dbms_lob.getlength(cover) as FILESIZE from movies where id in ('65', '66');

--zad9
DECLARE
    lobd blob;
    fils BFILE := BFILENAME('ZSBD_DIR','escape.jpg');
BEGIN
    SELECT cover INTO lobd
    FROM movies
    where id=66
    FOR UPDATE;
    DBMS_LOB.fileopen(fils, DBMS_LOB.file_readonly);
    DBMS_LOB.LOADFROMFILE(lobd,fils,DBMS_LOB.GETLENGTH(fils));
    DBMS_LOB.FILECLOSE(fils);
COMMIT;
END;

--zad10
create TABLE TEMP_COVERS(
    movie_id NUMBER(12),
    image BFILE,
    mime_type VARCHAR2(50)
);

--zad11
insert into temp_covers VALUES(65, BFILENAME('ZSBD_DIR','eagles.jpg'),'image/jpeg');

--zad12
select movie_id, dbms_lob.getlength(image) as FILESIZE from temp_covers;

--zad13
DECLARE
    lobd blob;
    fils BFILE;
    mime varchar2(250);
BEGIN
    SELECT image INTO fils
    FROM temp_covers
    where movie_id=65;
    
    SELECT mime_type INTO mime
    FROM temp_covers
    where movie_id=65;
    
    SELECT cover INTO lobd
    FROM movies
    where id=65
    FOR UPDATE;
    DBMS_LOB.fileopen(fils, DBMS_LOB.file_readonly);
    dbms_lob.createtemporary(lobd, TRUE);
    DBMS_LOB.LOADFROMFILE(lobd,fils,DBMS_LOB.GETLENGTH(fils));
    
    update movies set cover = lobd, mime_type = mime where id = 65;
    
    dbms_lob.freetemporary(lobd);
    DBMS_LOB.FILECLOSE(fils);
COMMIT;
END;

--zad14
select id, dbms_lob.getlength(cover) as FILESIZE from movies where id in ('65','66');

--zad15
drop table MOVIES;
drop table TEMP_COVERS;
