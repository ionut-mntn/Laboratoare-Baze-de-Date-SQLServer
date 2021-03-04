DROP TABLE ProfessorenTab
/
DROP TABLE StudentenTab
/
DROP TABLE PrüfungenTab
/
DROP TABLE AssistentenTab
/
DROP TABLE VorlesungenTab
/
DROP TYPE VorlesungsListenTyp FORCE
/
DROP TYPE VorlesungenTyp FORCE
/
DROP TYPE PrüfungenTyp FORCE
/
DROP TYPE StudentenTyp FORCE
/
DROP TYPE AssistentenTyp FORCE
/
DROP TYPE ProfessorenTyp FORCE
/

CREATE TYPE ProfessorenTyp
/
CREATE TYPE VorlesungenTyp
/
CREATE TYPE PrüfungenTyp
/
CREATE TYPE AssistentenTyp
/
CREATE TYPE AngestellteTyp
/

CREATE TYPE VorlesungsListenTyp AS TABLE OF REF VorlesungenTyp
/

CREATE OR REPLACE TYPE StudentenTyp AS OBJECT (
  MatrNr NUMBER,
  Name VARCHAR(20),
  Semester NUMBER,
  hört VorlesungsListenTyp,
  -- MEMBER FUNCTION Notenschnitt RETURN NUMBER, 
  MEMBER FUNCTION SummeWochenstunden RETURN NUMBER
)
/

CREATE OR REPLACE TYPE VorlesungenTyp AS OBJECT (
  VorlNr NUMBER,
  TITEL VARCHAR(20),
  SWS NUMBER,
  gelesenVon REF ProfessorenTyp,   
  Voraussetzungen VorlesungsListenTyp,
  MEMBER FUNCTION DurchfallQuote RETURN NUMBER,
  MEMBER FUNCTION AnzHörer RETURN NUMBER
)
/

CREATE OR REPLACE TYPE PrüfungenTyp AS OBJECT (
  Prüfling REF StudentenTyp,
  Inhalt REF VorlesungenTyp,
  Prüfer REF ProfessorenTyp,
  Note DECIMAL(3,2),
  Datum Date,
  MEMBER FUNCTION verschieben(neürTermin Date) RETURN DATE 
)
/

CREATE OR REPLACE TYPE ProfessorenTyp AS OBJECT (
  PersNr NUMBER,
  Name VARCHAR(20),
  Rang CHAR(2),
  Raum Number,
  MEMBER FUNCTION Notenschnitt RETURN NUMBER,
  MEMBER FUNCTION GEHALT RETURN NUMBER
)
/

CREATE OR REPLACE TYPE AssistentenTyp AS OBJECT (
  PersNr NUMBER,
  Name VARCHAR(20),
  Fachgebiet VARCHAR(20),
  Boss REF ProfessorenTyp,
  MEMBER FUNCTION Gehalt RETURN NUMBER
)
/ 

CREATE OR REPLACE TYPE BODY StudentenTyp AS 
MEMBER FUNCTION SummeWochenstunden RETURN NUMBER is  
      i             INTEGER;  
      vorl          VorlesungenTyp;  
      Total         NUMBER := 0;  
   
   BEGIN  
      FOR i in 1..SELF.hört.COUNT LOOP
         UTL_REF.SELECT_OBJECT(hört(i),vorl);  -- explizite  Dereferenzierung 
         TOTAL := TOTAL + vorl.SWS;  
    END LOOP;  
      RETURN Total;  
   END;
END;
/
  

CREATE OR REPLACE TYPE BODY ProfessorenTyp AS 
MEMBER FUNCTION Notenschnitt RETURN NUMBER is  
   BEGIN  
      RETURN 1.0;
   END;
MEMBER FUNCTION Gehalt RETURN NUMBER is  
   BEGIN  
      RETURN 1000.0;
   END;
END;
/
 
CREATE OR REPLACE TYPE BODY AssistentenTyp AS 
MEMBER FUNCTION Gehalt RETURN NUMBER is  
   BEGIN  
      RETURN 500.0;
   END;
END;
/
 

CREATE OR REPLACE TYPE BODY VorlesungenTyp AS 
MEMBER FUNCTION DurchfallQuote RETURN NUMBER is  
   BEGIN  
      RETURN 0.0;
   END;
MEMBER FUNCTION AnzHörer RETURN NUMBER is  
   BEGIN  
      RETURN 100.0;
   END;
END;
/
 
CREATE OR REPLACE TYPE BODY PrüfungenTyp AS 
MEMBER FUNCTION verschieben(neürTermin Date) RETURN Date is  
   BEGIN  
      --Datum neu setzen 
      RETURN neürTermin;
   END;
END;
/
 
CREATE TABLE ProfessorenTab OF ProfessorenTyp (PersNr PRIMARY KEY);

CREATE TABLE StudentenTab OF StudentenTyp (MatrNr PRIMARY KEY)
    NESTED TABLE hört STORE AS BelegungsTab;

CREATE TABLE PrüfungenTab OF PrüfungenTyp;

CREATE TABLE VorlesungenTab OF VorlesungenTyp
    NESTED TABLE Voraussetzungen STORE AS VorgängerTab;

CREATE TABLE AssistentenTab of AssistentenTyp;


--
--Einfügereihefolge:
--1. Professoren
--2. Vorlesungen
--3. Studenten
--4. Assistenten
--5. Prüfungen





