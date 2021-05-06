CREATE TABLE Contributeur
(
Id_Contrib INTEGER PRIMARY KEY,
Nom VARCHAR,
Prenom VARCHAR,
Type VARCHAR CHECK (Type IN ('Réalisateur', 'Producteur'))
);

CREATE TABLE Distributeur
(
Id_Distrib INTEGER PRIMARY KEY NOT NULL,
Nom VARCHAR
);

CREATE TABLE Film
(
Id_Film INTEGER PRIMARY KEY NOT NULL,
Titre VARCHAR,
Date_Sortie DATE,
Age_Min INTEGER,
Genre VARCHAR CHECK (Genre IN ('Horreur', 'Policier', 'Thriller', 'Comique', 'Animation')),
IdDistrib INTEGER,
FOREIGN KEY (IdDistrib) REFERENCES Distributeur(Id_Distrib)
);

CREATE TABLE Contribue
(
IdFilm INTEGER,
IdContrib INTEGER,
FOREIGN KEY (IdFilm) REFERENCES Film(Id_Film),
FOREIGN KEY (IdContrib) REFERENCES Contributeur(Id_Contrib)
);

CREATE TABLE Vendeur
(
Id_Cine INTEGER PRIMARY KEY,
Nom VARCHAR NOT NULL,
Prenom VARCHAR NOT NULL
);

CREATE TABLE Salle
(
Numero INTEGER PRIMARY KEY NOT NULL,
Nbr_Places INTEGER,
CHECK (Nbr_Places >= 0)
);

CREATE TABLE Séance
(
Id_Proj INTEGER PRIMARY KEY NOT NULL,
Date_Proj DATE,
Heure TIME (0),
IdFilm INTEGER,
IdSalle INTEGER,
Langue VARCHAR CHECK (Langue IN ('VO', 'VF', 'VOSTFR')),
FOREIGN KEY (IdFilm) REFERENCES Film(Id_Film),
FOREIGN KEY (IdSalle) REFERENCES Salle(Numero)
);

CREATE TABLE Spectateur
(
Id_Spec INTEGER PRIMARY KEY NOT NULL,
Nom VARCHAR ,
Prenom VARCHAR,
Adresse VARCHAR,
Dernier_Rechargement DATE,
Solde INTEGER,
IdProj INTEGER,
Type VARCHAR CHECK (Type IN ('Normal', 'Adhérent')),
FOREIGN KEY (IdProj) REFERENCES Séance(Id_Proj),
CHECK (NOT ((Type ='Normal') AND ((Adresse IS NOT NULL) OR (Dernier_Rechargement IS NOT NULL) OR (Solde IS NOT NULL)))),
CHECK (NOT ((Type ='Adhérent') AND ((Adresse IS NULL) OR (Dernier_Rechargement IS NULL) OR (Solde IS NULL)))),
CHECK ( NOT ( (Type ='Adhérent') AND (Dernier_Rechargement > NOW() ) OR (Solde < 0) ) )
);

CREATE TABLE Produit
(
Id_Prod INTEGER PRIMARY KEY,
Nom VARCHAR NOT NULL,
Prix FLOAT,
Type VARCHAR CHECK (Type IN ('Boisson', 'Alimentaire')),
CHECK (Prix > 0)
);

CREATE TABLE Entrée
(
Num_Entree INTEGER PRIMARY KEY NOT NULL,
Num INTEGER,
Tarif VARCHAR CHECK (Tarif IN ('Tarif_Etudiant', 'Tarif_Adulte', 'Tarif_Enfant', 'Tarif_Dimanche','Abonnement')),
FOREIGN KEY (Num) REFERENCES Salle(Numero)
);


CREATE TABLE Note_Spec
(
Note INTEGER,
IdFilm INTEGER,
IdSpec INTEGER,
FOREIGN KEY (IdSpec) REFERENCES Spectateur(Id_Spec),
FOREIGN KEY (IdFilm) REFERENCES Film(Id_Film),
CHECK ( (Note = 0) OR ((1 <= Note) AND (Note <= 5)))
);

CREATE TABLE Vente
(
Id_Vente INTEGER PRIMARY KEY,
IdSpec INTEGER,
IdCine INTEGER,
IdProd INTEGER,
NumEntree INTEGER,
FOREIGN KEY (IdSpec) REFERENCES Spectateur(Id_Spec),
FOREIGN KEY (IdCine) REFERENCES Vendeur(Id_Cine),
FOREIGN KEY (IdProd) REFERENCES Produit(Id_Prod),
FOREIGN KEY (NumEntree) REFERENCES Entrée(Num_Entree)
);

INSERT INTO Distributeur VALUES ('1','Warner Bros');
INSERT INTO Distributeur VALUES ('2','Disney');

INSERT INTO Film VALUES ('0', 'Terminator', TO_DATE('2000/06/06','yyyy/mm/dd'), '16','Thriller', '1');
INSERT INTO Film VALUES ('1', 'Kill Bill', TO_DATE('1980/11/28','yyyy/mm/dd'), '16','Thriller', '1');
INSERT INTO Film VALUES ('2', 'Le Roi Lion', TO_DATE('1985/07/12','yyyy/mm/dd'), '3','Animation', '2');

INSERT INTO Contributeur VALUES ('1', 'Spielberg', 'Steven','Réalisateur');
INSERT INTO Contributeur VALUES ('2','Z','Jay','Producteur');
INSERT INTO Contributeur VALUES ('3','West','Kanye','Producteur');

INSERT INTO Contribue VALUES ('0', '1');
INSERT INTO Contribue VALUES ('0', '2');
INSERT INTO Contribue VALUES ('1', '2');
INSERT INTO Contribue VALUES ('1', '3');
INSERT INTO Contribue VALUES ('2', '3');

INSERT INTO Vendeur VALUES ('0', 'Dupont', 'Jeanne');
INSERT INTO Vendeur VALUES ('1', 'Kujo', 'Jotaro');

INSERT INTO Salle VALUES ('1', '200');
INSERT INTO Salle VALUES ('2', '250');
INSERT INTO Salle VALUES ('3', '10');

INSERT INTO Séance VALUES ('0', TO_DATE('2020/05/31','yyyy/mm/dd'), '16:30:00', '0','1', 'VOSTFR');
INSERT INTO Séance VALUES ('1', TO_DATE('2020/05/31','yyyy/mm/dd'), '10:30:00', '1','1', 'VF');
INSERT INTO Séance VALUES ('2', TO_DATE('2020/05/31','yyyy/mm/dd'), '16:30:00', '1','2','VOSTFR');
INSERT INTO Séance VALUES ('3', TO_DATE('2020/05/31','yyyy/mm/dd'), '20:30:00', '2','3','VOSTFR');
INSERT INTO Séance VALUES ('4', TO_DATE('2020/05/31','yyyy/mm/dd'), '22:30:00', '2','2', 'VO');

INSERT INTO Spectateur VALUES ('0','Jean','Edouard', 'edouard.jean@gmail.com', TO_DATE('2020/05/25','yyyy/mm/dd'), '6', '0', 'Adhérent');
INSERT INTO Spectateur VALUES ('1', 'Paul', 'Jean', NULL, NULL, NULL, '2', 'Normal');
INSERT INTO Spectateur VALUES ('2', 'Grace', 'Stéphane', NULL, NULL, NULL, '2', 'Normal');
INSERT INTO Spectateur VALUES ('3', 'Zhang','Aline','micheal.jackson@git.ma', TO_DATE('2020/05/20','yyyy/mm/dd'), '2', '1', 'Adhérent');

INSERT INTO Produit VALUES ('0', 'Coca Cola', '2.50','Boisson');
INSERT INTO Produit VALUES ('1', 'PopCorn', '1.50','Alimentaire');
INSERT INTO Produit VALUES ('2', 'Ice Tea', '2.50','Boisson');

INSERT INTO Entrée VALUES ('0', '1', 'Tarif_Etudiant');
INSERT INTO Entrée VALUES ('1', '2', 'Tarif_Etudiant');
INSERT INTO Entrée VALUES ('2', '2', 'Tarif_Adulte');
INSERT INTO Entrée VALUES ('3', '3', 'Tarif_Adulte');

INSERT INTO Note_Spec VALUES ('5', '2', '0');
INSERT INTO Note_Spec VALUES ('0', '2', '1');
INSERT INTO Note_Spec VALUES ('4', '1', '3');
INSERT INTO Note_Spec VALUES ('0', '0', '2');

INSERT INTO Vente Values ('0', '0', '0', '0', NULL);
INSERT INTO Vente Values ('1', '2', '1', '2', NULL);
INSERT INTO Vente Values ('2', '1', '0', '2', NULL);
INSERT INTO Vente Values ('3', '3', '1', NULL, '2');
INSERT INTO Vente Values ('4', '2', '1', NULL, '1');
INSERT INTO Vente Values ('5', '1', '0', NULL, '3');

/* Vue nous montrant les différents contributeurs d'un film et leur rôle dans la contribution */
CREATE VIEW Contribution (Nom_Film, Contributeur, Rôle) AS
SELECT f.Titre, c.Nom, c.Type
FROM Film f, Contributeur c, Contribue
WHERE Contribue.IdContrib = c.Id_Contrib
AND Contribue.IdFilm = f.Id_Film
GROUP BY f.Titre, c.Nom, c.Type;

/*Vue nous montrant les différents spectateurs non adhérent présents un jour donné*/
CREATE VIEW Non_Adhérent (Nom, Prénom, Tarif) AS
SELECT s.Nom, s.Prenom, e.Tarif
FROM Spectateur s, Entrée e, Vente v
WHERE s.Id_Spec = v.IdSpec
AND e.Num_Entree = v.NumEntree
AND s.Type <> 'Adhérent'
GROUP BY s.Nom, s.Prenom, e.Tarif;

/* Vue nous montrant les difféents spectateurs adhérent présents un jour donnée*/
CREATE VIEW Adhérents (Nom, Prénom, Solde) AS
SELECT s.Nom, s.Prenom, s.Solde
FROM Spectateur s
WHERE s.Type = 'Adhérent'
GROUP BY s.Nom, s.Prenom, s.Solde;

/*Vue nous montrant le nombre de spectateurs présents dans les salles du cinema, la salle 3 est une salle test pour montrer que le pourcentage fonctionne*/
CREATE VIEW Entrées (Salle, Nombre_Spectateurs, Pourcentage_Occupation) AS
SELECT s.Numero, Count(e.Num_Entree), 100*Count(e.Num_Entree)/s.Nbr_Places
FROM Entrée e JOIN Salle s
ON s.Numero = e.Num
GROUP BY s.Numero
ORDER BY s.Numero;

/* Vue nous montrant les films distribués par les différents distributeurs*/
CREATE VIEW Distribution (Film, Distributeur) AS
SELECT f.Titre, d.Nom
FROM Film AS f JOIN Distributeur AS d
ON f.IdDistrib = d.Id_Distrib
GROUP BY f.Titre, d.Nom;

/*Vue nous montrant les différentes notes données par les spectateurs et le titre du film noté */
CREATE VIEW Notes (Nom_Spectateur, Film, Note) AS
SELECT s.Nom, Film.Titre, n.Note
FROM Film, Spectateur s JOIN Note_Spec n
ON n.IdSpec = s.Id_Spec
WHERE n.IdFilm = Film.Id_Film
GROUP BY  s.Nom, Film.Titre, n.Note;

/*Vue nous donnant la moyenne obtenue par chaque film*/
CREATE VIEW Moyenne_Film(Film, Moyenne) AS
SELECT f.Titre, sum(n.Note)/count(n.Note)
FROM Film f JOIN Note_Spec n
ON n.IdFilm = f.Id_Film
GROUP BY f.Titre;

/*Vue nous montrant les séances du prévues*/
CREATE VIEW Séances_Prévues ( Heure, Film, Langue, Salle) AS
SELECT s.Heure, f.Titre, s.Langue, Salle.Numero
FROM Film f, Salle JOIN Séance s
ON Salle.Numero = s.IdSalle
WHERE f.Id_Film = s.IdFilm
ORDER BY s.Heure, f.Titre, s.Langue, Salle.Numero;

/*Vue nous montrant les différents produits achetés par les spectateurs*/
CREATE VIEW Achats_Produits (Spectateur, Produit, Prix) AS
SELECT s.Prenom, p.Nom, p.prix
FROM Produit p, Spectateur s INNER JOIN Vente
ON s.Id_Spec = Vente.IdSpec
WHERE p.Id_Prod = Vente.IdProd
ORDER BY s.Prenom, p.Nom, p.prix;

/* Attribution des rôles*/
CREATE ROLE Informaticien;
CREATE ROLE Spectateur_Adhérent;
CREATE ROLE Manager;
CREATE ROLE Vendeur;
GRANT ALL ON Vendeur TO Informaticien;
GRANT ALL ON Film, Contributeur, Distributeur, Salle, Séance, Entrée, Contribue, Spectateur, Produit, Note_Spec, Vente TO Informaticien;
GRANT SELECT ON Film, Séances_Prévues, Distribution, Spectateur TO Spectateur_Adhérent;
GRANT SELECT ON Produit, Séances_Prévues, Vendeur, Vente TO Vendeur;
GRANT UPDATE ON Spectateur, Adhérents, Non_Adhérent, Produits, Vente TO Vendeur;
GRANT UPDATE ON Vendeur, Séance, Film TO Manager;
GRANT SELECT ON Vente, Produits, Adhérents, Non_Adhérent TO Manager;
