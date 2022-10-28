--zad1

create table DOKUMENTY (
ID number(12) primary key,
DOKUMENT clob
);

--zad2

DECLARE
    lob clob;
    counter NUMBER := 1;
BEGIN
    lob := 'Oto tekst.';
    for counter in 2..100000
    LOOP
    lob := lob || 'Oto tekst.'; 
  END LOOP;
    INSERT INTO dokumenty
    values (1, lob);
    COMMIT;
END;

--zad3

--a)
select * from dokumenty;

--b)
select upper(dokument) from dokumenty;

--c)
select length(dokument) from dokumenty;

--d)
select dbms_lob.getlength(dokument) from dokumenty;

--e)
select substr(dokument, 5 ,1000) from dokumenty;

--f)
select dbms_lob.substr(dokument, 1000, 5) from dokumenty;

--zad4
insert into dokumenty values (2, EMPTY_CLOB());

--zad5
insert into dokumenty values (3, NULL);

--zad6

--a)
select * from dokumenty;

--b)
select upper(dokument) from dokumenty;

--c)
select length(dokument) from dokumenty;

--d)
select dbms_lob.getlength(dokument) from dokumenty;

--e)
select substr(dokument, 5 ,1000) from dokumenty;

--f)
select dbms_lob.substr(dokument, 1000, 5) from dokumenty;

--zad7
select * from all_directories;

--zad8
DECLARE
    lobd clob;
    fils BFILE := BFILENAME('ZSBD_DIR','dokument.txt');
    doffset integer := 1;
    soffset integer := 1;
    langctx integer := 0;
    warn integer := null;
BEGIN
    SELECT dokument INTO lobd FROM dokumenty
    WHERE id=2 FOR UPDATE;
    DBMS_LOB.fileopen(fils, DBMS_LOB.file_readonly);
    DBMS_LOB.LOADCLOBFROMFILE(lobd, fils, DBMS_LOB.LOBMAXSIZE,
    doffset, soffset, 873, langctx, warn); -- 873 to utf-8
    DBMS_LOB.FILECLOSE(fils);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Status operacji: '||warn);
END;

--zad9
update dokumenty set dokument = to_clob(BFILENAME('ZSBD_DIR','dokument.txt')) where id = 3;

--zad10
select * from dokumenty;

--zad11
select dbms_lob.getlength(dokument) from dokumenty;

--zad12 
drop table dokumenty;

--zad13
create or replace procedure CLOB_CENSOR (clob_in in out clob, text_to_replace in varchar2) as 
    temp integer := 0;
    buffer_temp varchar2(100) := '';
begin
    temp := DBMS_LOB.INSTR(clob_in, text_to_replace);
    buffer_temp := '';
    for counter in 1..length(text_to_replace)
    loop
        buffer_temp := buffer_temp || '.'; 
    end loop;
    while temp > 0
    loop
        DBMS_LOB.write(clob_in, temp, length(buffer_temp), buffer_temp);
        temp := DBMS_LOB.INSTR(clob_in, buffer_temp);
    end loop;
end CLOB_CENSOR;

--zad14
create table kopia_tabeli as select * from ZSBD_TOOLS.BIOGRAPHIES;
select * from kopia_tabeli;
desc kopia_tabeli;

declare
    lobd clob;
begin
    select bio into lobd from kopia_tabeli where id = 1 for update;
    clob_censor(lobd, 'Cimrman');
end;

select * from kopia_tabeli;

--zad15
drop table kopia_tabeli;
