--1

create type samochod as object(
    marka varchar2(20), model varchar2(20), kilometry number,
    data_produkcji date, cena number(10, 2)
    );
    
desc samochod;

create table samochody of samochod;

desc samochody;

insert into samochody values(new samochod('Mazda', '323', 23, current_date, 10000));
insert into samochody values(new samochod('Ford', 'Focus', 10000, current_date, 1000.69));
insert into samochody values(new samochod('Ford', 'Focus', 10000, date '1997-01-01', 1000.69));

select * from samochody;

--2

create  table wlasciciele(
    imie varchar2(100), nazwisko varchar2(100), auto samochod
);

desc wlasciciel;

create table wlasciciele of wlasciciel;

insert into wlasciciele values('Eryk', 'Kosmala', new samochod('Ford', 'Focus', 10000, current_date, 1000.69));
insert into wlasciciele values('Marek', 'Kawa', new samochod('Ford', 'Mondeo', 10000, current_date, 1000.69));

select * from wlasciciele;

--3

alter type samochod replace as object(
    marka varchar2(20), model varchar2(20), kilometry number,
    data_produkcji date, cena number(10, 2),
    member function na_podstawie_wieku return number
    );
    
CREATE OR REPLACE TYPE BODY samochod AS
    MEMBER FUNCTION na_podstawie_wieku RETURN NUMBER IS
    BEGIN
        RETURN cena * power(0.9, EXTRACT (YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM data_produkcji));
    END na_podstawie_wieku;
END;

--4

alter type samochod replace as object(
    marka varchar2(20), model varchar2(20), kilometry number,
    data_produkcji date, cena number(10, 2),
    member function na_podstawie_wieku return number,
    map member function odwzoruj return number
    );

CREATE OR REPLACE TYPE BODY samochod AS
    MEMBER FUNCTION na_podstawie_wieku RETURN NUMBER IS
    BEGIN
        RETURN cena * power(0.9, EXTRACT (YEAR FROM CURRENT_DATE) - EXTRACT (YEAR FROM data_produkcji));
    END na_podstawie_wieku;
    MAP MEMBER FUNCTION odwzoruj RETURN NUMBER IS
    BEGIN
        RETURN EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM data_produkcji) + round(kilometry / 10000, 0);
    END odwzoruj;
END;

SELECT * FROM SAMOCHODY s ORDER BY VALUE(s);

--5

create or replace type wlasciciel as object(
    imie varchar2(100), nazwisko varchar2(100)
    );
    
alter type samochod add attribute posiadacz ref wlasciciel cascade;

--6

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
TYPE t_ksiazki IS VARRAY(10) OF VARCHAR2(20);
moje_ksiazki t_ksiazki := t_ksiazki('');
BEGIN
moje_ksiazki(1) := 'The Cloud R';
moje_ksiazki.EXTEND(9);
FOR i IN 2..10 LOOP
moje_ksiazki(i) := 'KRONIKA_' || i;
END LOOP;
FOR i IN moje_ksiazki.FIRST()..moje_ksiazki.LAST() LOOP
DBMS_OUTPUT.PUT_LINE(moje_ksiazki(i));
END LOOP;
moje_ksiazki.TRIM(2);
FOR i IN moje_ksiazki.FIRST()..moje_ksiazki.LAST() LOOP
DBMS_OUTPUT.PUT_LINE(moje_ksiazki(i));
END LOOP;
DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_ksiazki.LIMIT());
DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_ksiazki.COUNT());
moje_ksiazki.EXTEND();
moje_ksiazki(9) := 9;
DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_ksiazki.LIMIT());
DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_ksiazki.COUNT());
moje_ksiazki.DELETE();
DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_ksiazki.LIMIT());
DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_ksiazki.COUNT());
END;

--8

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
moje_miesiace t_miesiace := t_miesiace();
BEGIN
moje_miesiace.EXTEND(12);
moje_miesiace(1) := 'styczen';

moje_miesiace(2) := 'luty';

moje_miesiace(3) := 'marzec';

moje_miesiace(4) := 'april';

moje_miesiace(5) := 'maj';

moje_miesiace(6) := 'czerwiec';

moje_miesiace(7) := 'lipiec';

moje_miesiace(8) := 'sierpien';

moje_miesiace(9) := 'wrzesien';

moje_miesiace(10) := 'pizdziernik';

moje_miesiace(11) := 'listopad';

moje_miesiace(12) := 'grudzien';

FOR i IN moje_miesiace.FIRST()..moje_miesiace.LAST() LOOP
DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
END LOOP;
moje_miesiace.TRIM(2);
FOR i IN moje_miesiace.FIRST()..moje_miesiace.LAST() LOOP
DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
END LOOP;
moje_miesiace.DELETE(5,7);
DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_miesiace.LIMIT());
DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_miesiace.COUNT());
FOR i IN moje_miesiace.FIRST()..moje_miesiace.LAST() LOOP
IF moje_miesiace.EXISTS(i) THEN
DBMS_OUTPUT.PUT_LINE(moje_miesiace(i));
END IF;
END LOOP;
DBMS_OUTPUT.PUT_LINE('Limit: ' || moje_miesiace.LIMIT());
DBMS_OUTPUT.PUT_LINE('Liczba elementow: ' || moje_miesiace.COUNT());
END;

--zad 10

CREATE TYPE jezyki_obce AS VARRAY(10) OF VARCHAR2(20);
/
CREATE TYPE stypendium AS OBJECT (
nazwa VARCHAR2(50),
kraj VARCHAR2(30),
jezyki jezyki_obce );
/
CREATE TABLE stypendia OF stypendium;
INSERT INTO stypendia VALUES
('SOKRATES','FRANCJA',jezyki_obce('ANGIELSKI','FRANCUSKI','NIEMIECKI'));
INSERT INTO stypendia VALUES
('ERASMUS','NIEMCY',jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI'));
SELECT * FROM stypendia;
SELECT s.jezyki FROM stypendia s;
UPDATE STYPENDIA
SET jezyki = jezyki_obce('ANGIELSKI','NIEMIECKI','HISZPANSKI','FRANCUSKI')
WHERE nazwa = 'ERASMUS';
CREATE TYPE lista_egzaminow AS TABLE OF VARCHAR2(20);
/
CREATE TYPE semestr AS OBJECT (
numer NUMBER,
egzaminy lista_egzaminow );
/
CREATE TABLE semestry OF semestr
NESTED TABLE egzaminy STORE AS tab_egzaminy;
INSERT INTO semestry VALUES
(semestr(1,lista_egzaminow('MATEMATYKA','LOGIKA','ALGEBRA')));
INSERT INTO semestry VALUES
(semestr(2,lista_egzaminow('BAZY DANYCH','SYSTEMY OPERACYJNE')));
SELECT s.numer, e.*
FROM semestry s, TABLE(s.egzaminy) e;
SELECT e.*
FROM semestry s, TABLE ( s.egzaminy ) e;
SELECT * FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=1 );
INSERT INTO TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 )
VALUES ('METODY NUMERYCZNE');
UPDATE TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
SET e.column_value = 'SYSTEMY ROZPROSZONE'
WHERE e.column_value = 'SYSTEMY OPERACYJNE';
DELETE FROM TABLE ( SELECT s.egzaminy FROM semestry s WHERE numer=2 ) e
WHERE e.column_value = 'BAZY DANYCH';

--zad11

create type produkt as table of varchar(50);
create table zakupy (koszyk_zakupow produkt)
nested table koszyk_zakupow store as zakupy_lista;

insert into zakupy values (new produkt('a', 'b', 'c'));
insert into zakupy values (new produkt('a', 'b', 'd'));

select * from zakupy z where 'a' in koszyk_zakupow;

delete from zakupy
