DROP TABLE ProfessorenTab
/
DROP TABLE StudentenTab
/
DROP TABLE Pr�fungenTab
/
DROP TABLE AssistentenTab
/
DROP TABLE VorlesungenTab
/
DROP TYPE VorlesungsListenTyp FORCE
/
DROP TYPE VorlesungenTyp FORCE
/
DROP TYPE Pr�fungenTyp FORCE
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
CREATE TYPE Pr�fungenTyp
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
  h�rt VorlesungsListenTyp,
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
  MEMBER FUNCTION AnzH�rer RETURN NUMBER
)
/

CREATE OR REPLACE TYPE Pr�fungenTyp AS OBJECT (
  Pr�fling REF StudentenTyp,
  Inhalt REF VorlesungenTyp,
  Pr�fer REF ProfessorenTyp,
  Note DECIMAL(3,2),
  Datum Date,
  MEMBER FUNCTION verschieben(ne�rTermin Date) RETURN DATE 
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
      FOR i in 1..SELF.h�rt.COUNT LOOP
         UTL_REF.SELECT_OBJECT(h�rt(i),vorl);  -- explizite  Dereferenzierung 
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
MEMBER FUNCTION AnzH�rer RETURN NUMBER is  
   BEGIN  
      RETURN 100.0;
   END;
END;
/
 
CREATE OR REPLACE TYPE BODY Pr�fungenTyp AS 
MEMBER FUNCTION verschieben(ne�rTermin Date) RETURN Date is  
   BEGIN  
      --Datum neu setzen 
      RETURN ne�rTermin;
   END;
END;
/
 
CREATE TABLE ProfessorenTab OF ProfessorenTyp (PersNr PRIMARY KEY);

CREATE TABLE StudentenTab OF StudentenTyp (MatrNr PRIMARY KEY)
    NESTED TABLE h�rt STORE AS BelegungsTab;

CREATE TABLE Pr�fungenTab OF Pr�fungenTyp;

CREATE TABLE VorlesungenTab OF VorlesungenTyp
    NESTED TABLE Voraussetzungen STORE AS Vorg�ngerTab;

CREATE TABLE AssistentenTab of AssistentenTyp;


--
--Einf�gereihefolge:
--1. Professoren
--2. Vorlesungen
--3. Studenten
--4. Assistenten
--5. Pr�fungen





