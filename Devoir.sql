s  /*Devoir Num 01 Bdd*/
 

CREATE TABLE Medecin (
    NumMedecin INT PRIMARY KEY,
    NomMedecin VARCHAR(10),
    Specialite VARCHAR(20)
);

CREATE TABLE Patient (
    NumPatient INT PRIMARY KEY,
    NomPatient VARCHAR(10),
    PrenomPatient VARCHAR(10),
    DateNaissance DATE
);

CREATE TABLE Consultation (
    NumConsultation INT PRIMARY KEY,
    NumPatient INT REFERENCES Patient(NumPatient),
    NumMedecin INT REFERENCES Medecin(NumMedecin),
    DateConsultation DATE,
    Diagnostic VARCHAR(100)
);

CREATE TABLE Prescription (
    NumConsultation INT REFERENCES Consultation(NumConsultation),
    Medicament VARCHAR(20),
    Posologie VARCHAR(100),
    PRIMARY KEY (NumConsultation, Medicament)
);


/* 2. Suppression de l’attribut Diagnostic de la table Consultation : */

ALTER TABLE Consultation DROP COLUMN Diagnostic;

    /* La Verification : */

    DESC Consultation; -- (ou bien SHOW COLUMNS FROM Consultation;)


/* 3. Ajout de la contrainte NOT NULL sur certains attributs */

ALTER TABLE Medecin MODIFY NomMedecin VARCHAR(10) NOT NULL;
ALTER TABLE Patient MODIFY NomPatient VARCHAR(10) NOT NULL;
ALTER TABLE Patient MODIFY PrenomPatient VARCHAR(10) NOT NULL;
ALTER TABLE Prescription MODIFY Medicament VARCHAR(20) NOT NULL;


/* 4. Modification de la longueur de l’attribut Spécialité : */

    /* a- Agrandir la longueur (par exemple passer de VARCHAR(20) à VARCHAR(30)): */
      
      ALTER TABLE Medecin MODIFY Specialite VARCHAR(30);

    /* b- Réduire  la longueur (par exemple passer de VARCHAR(20) à VARCHAR(10)): */ 

      ALTER TABLE Medecin MODIFY Specialite VARCHAR(10);


/* 5. Ajout de la colonne Diagnostic dans Consultation : */

ALTER TABLE Consultation ADD Diagnostic VARCHAR(100);

    /* La Verification : */

    DESC Consultation;


/* 6. Renommer NomMédecin en NomCompletMédecin dans Médecin : */

ALTER TABLE Medecin RENAME COLUMN NomMedecin TO NomCompletMedecin;

    /* La Verification : */

    DESC Medecin;


/* 7. Ajout de la contrainte sur Spécialité (I supposed that we dont add it lors de la creation de la table) : */

ALTER TABLE Medecin ADD CONSTRAINT chk_specialite 
CHECK (Specialite IN ('Généraliste', 'Cardiologue', 'Dermatologue', 'Neurologue'));


/* 8. Ajout de la contrainte sur Médicament (I supposed that we dont add it lors de la creation de la table) : */

ALTER TABLE Prescription ADD CONSTRAINT chk_medicament 
CHECK (Medicament IN ('Paracétamol', 'Ibuprofène','Antibiotique','Antihistaminique'));


/* 9. La contrainte : "DateConsultation est postérieure à DateNaissance" :*/

CREATE OR REPLACE TRIGGER trg_check_date_consultation
BEFORE INSERT OR UPDATE ON Consultation
FOR EACH ROW
DECLARE
    v_date_naissance DATE;
BEGIN
    SELECT DateNaissance INTO v_date_naissance
    FROM Patient
    WHERE NumPatient = :NEW.NumPatient;

    IF :NEW.DateConsultation <= v_date_naissance THEN
        RAISE_APPLICATION_ERROR(-20001, 'DateConsultation must be after DateNaissance.');
    END IF;
END;
/
