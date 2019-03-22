SET FOREIGN_KEY_CHECKS=0;

DROP TABLE IF EXISTS Profilo;
DROP TABLE IF EXISTS Caratteristiche;
DROP TABLE IF EXISTS PersonaggioUtente;
DROP TABLE IF EXISTS IANemica;
DROP TABLE IF EXISTS IANeutrale;
DROP TABLE IF EXISTS Oggetto;
DROP TABLE IF EXISTS Arma;
DROP TABLE IF EXISTS Armatura;
DROP TABLE IF EXISTS Consumabile;
DROP TABLE IF EXISTS Inventario;
DROP TABLE IF EXISTS Negozio;
DROP TABLE IF EXISTS DropPool;
DROP TABLE IF EXISTS Luogo;
DROP TABLE IF EXISTS Missione;
DROP TABLE IF EXISTS UbicazioneIANeutrale;
DROP TABLE IF EXISTS UbicazioneIANemica;
DROP TABLE IF EXISTS MissioneCompletata;
DROP TABLE IF EXISTS Premio;
DROP TABLE IF EXISTS CreatureDomate;
DROP TABLE IF EXISTS Classe;

SET FOREIGN_KEY_CHECKS=1;

CREATE TABLE Profilo(
email varchar(64) primary key,
nickname varchar(32) not null unique,
nome varchar(32) not null,
cognome varchar(32) not null,
dataNascita date not null,
sesso ENUM('M', 'F', 'A') not null
)ENGINE=InnoDB;

CREATE TABLE Caratteristiche(
id int auto_increment primary key,
vita tinyint not null,
forza tinyint not null,
destrezza tinyint not null,
resistenza tinyint not null
)ENGINE=InnoDB;

CREATE TABLE Classe(
id int auto_increment primary key,
nome varchar(64) not null,
descrizione text not null
)ENGINE=InnoDB;

CREATE TABLE PersonaggioUtente( 
numero int auto_increment primary key,
email varchar(64) not null,
denaro int default 0,
livello tinyint default 0,
xpCorrente int default 0,
xpProssimoLivello int default 0,
puntiSpendibili tinyint default 0,
caratteristiche int not null,
classe int not null,
foreign key(email) references Profilo(email) on update cascade,
foreign key(classe) references Classe(id), 
foreign key(caratteristiche) references Caratteristiche(id)
)ENGINE=InnoDB;

CREATE TABLE IANemica(
id int auto_increment primary key,
nome varchar(64) not null,
classe varchar(64) not null,
livello tinyint default 0,
domabile boolean not null,
caratteristiche int not null,
foreign key(caratteristiche) references Caratteristiche(id)
)ENGINE=InnoDB;

CREATE TABLE IANeutrale(
id int auto_increment primary key,
nome varchar(64) not null,
classe varchar(64) not null,
livello tinyint default 0,
caratteristiche int,
foreign key(caratteristiche) references Caratteristiche(id)
)ENGINE=InnoDB;

CREATE TABLE Oggetto(
id int auto_increment primary key,
nome varchar(64) UNIQUE not null,
descrizione text not null,
peso double not null
)ENGINE=InnoDB;

CREATE TABLE Arma(
id int primary key,
velocitaAttacco double not null,
danno int not null,
tipo varchar(64) not null,
foreign key (id) references Oggetto(id) on delete cascade
)ENGINE=InnoDB;

CREATE TABLE Armatura(
id int primary key,
difesa int not null,
tipo ENUM('testa','petto','gambe','piedi','mani') not null,
foreign key (id) references Oggetto(id) on delete cascade
)ENGINE=InnoDB;

CREATE TABLE Consumabile(
id int primary key,
effetto smallint,
tipo ENUM('vita', 'forza', 'destrezza', 'resistenza'),
foreign key (id) references Oggetto(id) on delete cascade
)ENGINE=InnoDB;

CREATE TABLE Inventario(
personaggioUtente int not null,
oggetto int not null,
equipaggiato boolean default 0,
quantita tinyint default 1,
foreign key (personaggioUtente) references PersonaggioUtente(numero),
foreign key (oggetto) references Oggetto(id),
primary key(personaggioUtente, oggetto)
)ENGINE=InnoDB;

CREATE TABLE Negozio(
iaNeutrale int not null,
oggetto int not null,
prezzo int not null,
foreign key (iaNeutrale) references IANeutrale(id),
foreign key (oggetto) references Oggetto(id),
primary key(iaNeutrale, oggetto)
)ENGINE=InnoDB;

CREATE TABLE DropPool(
iaNemica int not null,
oggetto int not null,
probabilita int not null,
foreign key (iaNemica) references IANemica(id),
foreign key (oggetto) references Oggetto(id),
primary key(iaNemica, oggetto)
)ENGINE=InnoDB;

CREATE TABLE Luogo(
id int auto_increment primary key,
nome varchar(64) unique,
descrizione text
)ENGINE=InnoDB;

CREATE TABLE Missione(
id int auto_increment primary key,
titolo varchar(64) UNIQUE not null,
descrizione text not null,
livelloNecessario int default 1,
luogo int not null,
iaNeutrale int,
foreign key (luogo) references Luogo(id),
foreign key(iaNeutrale) references IANeutrale(id)
)ENGINE=InnoDB;

CREATE TABLE UbicazioneIANeutrale(
iaNeutrale int not null,
luogo int not null,
foreign key(iaNeutrale) references IANeutrale(id),
foreign key (luogo) references Luogo(id),
primary key(iaNeutrale, luogo)
)ENGINE=InnoDB;

CREATE TABLE UbicazioneIANemica(
iaNemica int not null,
luogo int not null,
foreign key(iaNemica) references IANemica(id),
foreign key (luogo) references Luogo(id),
primary key(iaNemica, luogo)
)ENGINE=InnoDB;

CREATE TABLE MissioneCompletata(
missione int not null,
personaggioUtente int not null,
foreign key(missione) references Missione(id),
foreign key(personaggioUtente) references PersonaggioUtente(numero),
primary key(missione, personaggioUtente)
)ENGINE=InnoDB;

CREATE TABLE Premio(
missione int not null,
oggetto int not null,
quantita tinyint default 1,
foreign key(missione) references Missione(id),
foreign key(oggetto) references Oggetto(id),
primary key(missione, oggetto)
)ENGINE=InnoDB;

CREATE TABLE CreatureDomate(
personaggioUtente int not null,
iaNemica int not null,
foreign key(personaggioUtente) references PersonaggioUtente(numero),
foreign key(iaNemica) references IANemica(id),
primary key(personaggioUtente, iaNemica)
)ENGINE=InnoDB;



INSERT INTO Profilo (email,nickname,nome,cognome,dataNascita,sesso)
VALUES
('sample1@lol.com','nick0','nome0','cognome0','1900-01-01','M'),
('sample11@lol.com','nick10','nome10','cognome10','1992-04-02','F'),
('sample2@lol.com','nick1','nome1','cognome1','1990-01-04','M'),
('sample3@lol.com','nick2','nome2','cognome2','1999-01-08','M'),
('sample4@lol.com','nick3','nome3','cognome3','1984-01-01','F'),
('sample5@lol.com','nick4','nome4','cognome4','1994-01-10','M'),
('sample6@lol.com','nick5','nome5','cognome5','1967-05-06','A'),
('sample7@lol.com','nick6','nome6','cognome6','1992-04-02','F'),
('sample8@lol.com','nick7','nome7','cognome7','1977-09-25','A'),
('sample9@lol.com','nick8','nome8','cognome8','1989-04-14','M'),
('sample10@lol.com','nick9','nome9','cognome9','1967-05-06','F');


INSERT INTO Caratteristiche (vita,forza,destrezza,resistenza)
VALUES
(10,15,12,20),
(8,12,10,18),
(9,12,15,10),
(11,8,12,15),
(12,9,18,14),
(34,22,18,17),
(32,18,19,21),
(45,21,21,18),
(12,23,23,16),
(23,8,25,15),
(15,10,20,21),
(18,12,24,19);


INSERT INTO Classe(nome, descrizione)
VALUES
('mago','mago'),
('cavaliere','cavaliere'),
('strega','strega'),
('guerriero','guerriero');

INSERT INTO PersonaggioUtente (email,denaro,livello,xpCorrente,xpProssimoLivello,puntiSpendibili,caratteristiche,classe)
VALUES
('sample1@lol.com',100,20,453,234,2,1,1),
('sample4@lol.com',235,23,342,56,4,3,2),
('sample8@lol.com',46,21,534,578,7,2,1),
('sample9@lol.com',645,18,387,235,6,4,3),
('sample6@lol.com',45,2,345,47,3,5,4),
('sample1@lol.com',100,20,453,234,2,1,2),
('sample1@lol.com',235,23,342,56,4,3,3),
('sample1@lol.com',100,40,455,234,2,1,1),
('sample4@lol.com',235,23,342,56,4,3,1),
('sample4@lol.com',235,23,342,56,4,3,4);



INSERT INTO IANemica (nome,livello,domabile,caratteristiche)
VALUES
('enemy1',20,0,5),
('enemy2',24,0,6),
('enemy3',38,1,7),
('enemy4',21,1,8),
('enemy5',55,0,9);

INSERT INTO IANeutrale (nome,livello,caratteristiche)
VALUES
('neut1',8,NULL),
('neut2',20,11),
('neut3',60,NULL),
('neut4',15,12),
('neut5',10,NULL);

INSERT INTO Oggetto (nome,descrizione,peso)
VALUES
('spadaL','spada leggera',12),
('spadaP','spada pesante',20),
('mazza','mazza di legno',14),
('cura','pozione che ripristina la vita',2),
('boost','pozione che aumenta la resistenza',2),
('attacco','pozione che aumenta attacco',3),
('stivali','stivali leggeri',6),
('gambali','gambali pesanti',20),
('giacca','giacca rinforzata',16);


INSERT INTO Arma (id, velocitaAttacco, danno, tipo)
VALUES
(1,12,60,'arma leggera'),
(2,8,98,'arma pesante'),
(3,16,44,'arma leggera');

INSERT INTO Armatura (id, difesa, tipo)
VALUES
(7,20,'gambe'),
(8,30,'gambe'),
(9,80,'petto');

INSERT INTO Consumabile (id, effetto, tipo)
VALUES
(4,12,'vita'),
(5,20,'forza'),
(6,16,'destrezza');

INSERT INTO Inventario (personaggioUtente, oggetto, equipaggiato, quantita)
VALUES
(1,1,0,1),
(1,2,1,1),
(1,3,0,1),
(1,4,0,4),
(1,6,0,4),
(1,7,0,1),
(3,1,0,1),
(3,2,0,1),
(3,3,0,1),
(3,7,1,1),
(3,8,0,1),
(3,9,1,2),
(4,1,1,1),
(4,9,1,2),
(5,1,0,1),
(5,7,1,2);


INSERT INTO Negozio(iaNeutrale, oggetto, prezzo)
VALUES
(2,6,30),
(2,7,34),
(2,8,45),
(3,2,56),
(3,4,10),
(3,5,12),
(5,3,36),
(5,5,25),
(5,9,100);


INSERT INTO DropPool (iaNemica, oggetto, probabilita)
VALUES
(1,3,24),
(1,6,23),
(2,4,56),
(2,7,54),
(3,1,25),
(3,5,76),
(4,5,86),
(4,9,45),
(5,1,90),
(5,6,12);

INSERT INTO Luogo (nome, descrizione)
VALUES
('kaer morhen','tw3'),
('bianco frutteto','tw3'),
('novigrad','tw3'),
('ard skellige','tw3'),
('oxenfurt','tw3');


INSERT INTO Missione (titolo, descrizione, livelloNecessario, luogo, iaNeutrale)
VALUES
('titolo1','descr1',20,2,NULL),
('titolo2','descr2',25,4,2),
('titolo3','descr3',18,5,5),
('titolo4','descr4',22,3,NULL),
('titolo5','descr5',10,1,NULL);


INSERT INTO UbicazioneIANeutrale (iaNeutrale, luogo)
VALUES
(1,3),
(1,4),
(2,2),
(2,4),
(3,5),
(5,1),
(5,5);

INSERT INTO UbicazioneIANemica (iaNemica, luogo)
VALUES
(1,3),
(1,4),
(2,2),
(3,5),
(5,1);

INSERT INTO MissioneCompletata (missione, personaggioUtente)
VALUES
(1,1),
(1,3),
(2,1),
(2,3),
(3,3),
(3,4),
(3,5),
(4,1),
(4,5),
(5,1),
(5,3);


INSERT INTO Premio (missione, oggetto, quantita)
VALUES
(1,4,2),
(2,7,1),
(3,4,2),
(4,6,1),
(5,4,2),
(1,1,1),
(2,2,1),
(5,6,1);

INSERT INTO CreatureDomate (personaggioUtente, iaNemica)
VALUES
(1,3),
(1,4),
(3,3),
(4,3),
(5,4);


DROP VIEW IF EXISTS AlmenoDueMissioni;
CREATE VIEW AlmenoDueMissioni AS
SELECT pu.email, pu.numero
FROM PersonaggioUtente pu, MissioneCompletata m1
WHERE m1.personaggioUtente = pu.numero
GROUP BY pu.email, pu.numero
HAVING COUNT(m1.personaggioUtente) > 1;

DROP VIEW IF EXISTS IANeutNessunOggVenduto;
CREATE VIEW IANeutNessunOggVenduto AS
SELECT ian.id
FROM IANeutrale ian
WHERE ian.id NOT IN (SELECT n.iaNeutrale FROM Negozio n);

DROP VIEW IF EXISTS PersUtVitaMedia;
CREATE VIEW PersUtVitaMedia AS
SELECT pu.numero
FROM PersonaggioUtente pu, Caratteristiche c
WHERE pu.caratteristiche = c.id AND c.vita >= (SELECT AVG(c.vita) FROM Caratteristiche c, PersonaggioUtente pu
WHERE pu.caratteristiche = c.id);

DROP VIEW IF EXISTS ArmaPremio;
CREATE VIEW ArmaPremio AS
SELECT DISTINCT i.personaggioUtente
FROM Inventario i, Premio p, Arma a
WHERE i.oggetto = p.oggetto AND i.oggetto = a.id;

DROP VIEW IF EXISTS TutteLeArmi;
CREATE VIEW TutteLeArmi AS
SELECT i.personaggioUtente
FROM Inventario i, Arma a
WHERE i.oggetto = a.id
GROUP BY(i.personaggioUtente)
HAVING COUNT(i.oggetto) = (SELECT COUNT(*) FROM Arma);

DROP VIEW IF EXISTS ProfiliTrePersUtente;
CREATE VIEW ProfiliTrePersUtente AS
SELECT p.email
FROM Profilo p, PersonaggioUtente pu
WHERE p.email = pu.email AND pu.classe NOT IN 
(SELECT pu2.classe FROM PersonaggioUtente pu2 WHERE pu2.email = pu.email AND pu2.numero <> pu.numero) 
GROUP BY(p.email)
HAVING COUNT(pu.numero) > 2;

DROP VIEW IF EXISTS ProfiliTrePersUtenteBis;
CREATE VIEW ProfiliTrePersUtenteBis AS
SELECT p.email
FROM Profilo p, PersonaggioUtente pu
WHERE p.email = pu.email 
GROUP BY(p.email)
HAVING COUNT(DISTINCT pu.classe) > 2;

DROP VIEW IF EXISTS tempView1;
CREATE VIEW tempView1 AS
SELECT oggetto, SUM(quantita) as q FROM Inventario GROUP BY(oggetto);

DROP VIEW IF EXISTS OggPiuPosseduto;
CREATE VIEW OggPiuPosseduto AS
SELECT o.nome, qt.oggetto
FROM tempView1 as qt, Oggetto o
WHERE qt.oggetto = o.id AND qt.q = (SELECT MAX(q) FROM (tempView1))
GROUP BY(qt.oggetto);

DROP VIEW IF EXISTS DenaroNegozio;
CREATE VIEW DenaroNegozio AS
SELECT pu.numero as personaggioUtente, ian.id as iaNeutrale
FROM PersonaggioUtente pu, IANeutrale ian
WHERE pu.denaro >= (SELECT SUM(Negozio.prezzo) as prezzo FROM Negozio WHERE ian.id = Negozio.iaNeutrale);

DROP VIEW IF EXISTS IALuogoMissione;
CREATE VIEW IALuogoMissione AS
SELECT m.iaNeutrale
FROM Missione m
WHERE m.luogo IN (SELECT DISTINCT luogo FROM UbicazioneIANeutrale u WHERE u.iaNeutrale = m.iaNeutrale);

DROP VIEW IF EXISTS ForzaPeso;
CREATE VIEW ForzaPeso AS
SELECT pu.numero, o.nome
FROM PersonaggioUtente pu, Caratteristiche c, Armatura a, Oggetto o, Inventario i
WHERE pu.caratteristiche = c.id AND c.forza <= 
ANY(
SELECT o.peso FROM Inventario i, Oggetto o, Armatura a 
WHERE i.oggetto = o.id AND o.id = a.id AND i.personaggioUtente = pu.numero
)
AND o.id = a.id AND o.peso  >= c.forza AND pu.numero = i.personaggioUtente AND o.id = i.oggetto;


DROP VIEW IF EXISTS tempView;
CREATE VIEW tempView AS
SELECT SUM(i.quantita) as s, p.numero FROM PersonaggioUtente p LEFT JOIN Inventario i ON p.numero = i.personaggioUtente
GROUP BY p.numero;

DROP VIEW IF EXISTS MediaOggProfilo;
CREATE VIEW MediaOggProfilo AS
SELECT pu.email, t.s/COUNT(pu.numero) as media
FROM PersonaggioUtente pu, tempView t
WHERE pu.numero = t.numero
GROUP BY(pu.email);

DROP VIEW IF EXISTS CarattIANeutrale;
CREATE VIEW CarattIANeutrale AS
SELECT IANeutrale.id as IANeutrale, vita, forza, destrezza, resistenza
FROM IANeutrale LEFT JOIN Caratteristiche c ON c.id = IANeutrale.caratteristiche;

DROP FUNCTION IF EXISTS NOggettiInventario;
DELIMITER |
CREATE FUNCTION NOggettiInventario(IdGiocatore INT)
RETURNS INT
BEGIN
DECLARE nOggetti INT;
SELECT SUM(Inventario.quantita) INTO nOggetti
FROM Inventario
WHERE personaggioUtente=IdGiocatore AND equipaggiato=0;
RETURN nOggetti;
END|
DELIMITER ;

DROP FUNCTION IF EXISTS MissioniLuogo;
DELIMITER |
CREATE FUNCTION MissioniLuogo()
RETURNS INT
BEGIN
DECLARE nLuoghi INT;
SELECT COUNT(DISTINCT m.luogo) INTO nLuoghi
FROM MissioneCompletata mc, Missione m
WHERE mc.missione = m.id;
RETURN nLuoghi;
END|
DELIMITER ;

DROP FUNCTION IF EXISTS DBStats;
DELIMITER |
CREATE FUNCTION DBStats()
RETURNS text
BEGIN
DECLARE res text;
DECLARE profili LONG;
DECLARE persUtente LONG;
DECLARE oggTotali LONG;
DECLARE missCompletate LONG;
SELECT COUNT(*) INTO profili FROM Profilo;
SELECT COUNT(*) INTO persUtente FROM PersonaggioUtente;
SELECT SUM(quantita) INTO oggTotali FROM Inventario;
SELECT COUNT(*) INTO missCompletate FROM MissioneCompletata;
SELECT CONCAT('Profili totali: ', profili, char(10), 'Personaggi Utente totali: ', persUtente, char(10),
'Oggetti totali posseduti: ', oggTotali ,char(10), 'Missioni completate totali: ', missCompletate, char(10)) INTO res;
RETURN res;
END|
DELIMITER ;

DROP FUNCTION IF EXISTS LuoghiMissioniUtenti;
DELIMITER |
CREATE FUNCTION LuoghiMissioniUtenti(luogo INT)
RETURNS INT
BEGIN
DECLARE ret INT;
SELECT COUNT(*) INTO ret 
FROM MissioneCompletata mc, Missione m, PersonaggioUtente pu
WHERE m.luogo = luogo AND mc.missione = m.id AND mc.personaggioUtente = pu.numero;
RETURN ret;
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS IALuogo;
DELIMITER |
CREATE PROCEDURE IALuogo(idLuogo INT)
BEGIN
SELECT ian.id as id, ian.nome as nome, "IANeutrale"
FROM IANeutrale ian, UbicazioneIANeutrale ub
WHERE ian.id = ub.iaNeutrale AND ub.luogo = idLuogo
UNION
SELECT ian.id as id, ian.nome as nome, "IANemica"
FROM IANemica ian, UbicazioneIANemica ub
WHERE ian.id = ub.iaNemica AND ub.luogo = idLuogo;
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS OggettoArma;
DELIMITER |
CREATE PROCEDURE OggettoArma(nome varchar(64), descrizione text, peso double, velocitaAttacco double, danno int, tipo varchar(64))
BEGIN
DECLARE nId INT;
INSERT INTO Oggetto(nome,descrizione,peso) VALUES(nome,descrizione,peso);
SELECT MAX(id) INTO nId FROM Oggetto;
INSERT INTO Arma(id,velocitaAttacco,danno,tipo) VALUES(nId,velocitaAttacco,danno,tipo);
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS OggettoArmatura;
DELIMITER |
CREATE PROCEDURE OggettoArmatura(nome varchar(64), descrizione text, peso double, difesa int, tipo varchar(64))
BEGIN
DECLARE nId INT;
INSERT INTO Oggetto(nome,descrizione,peso) VALUES(nome,descrizione,peso);
SELECT MAX(id) INTO nId FROM Oggetto;
INSERT INTO Armatura(id,difesa,tipo) VALUES(nId,difesa,tipo);
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS OggettoConsumabile;
DELIMITER |
CREATE PROCEDURE OggettoConsumabile(nome varchar(64), descrizione text, peso double, effetto int, tipo varchar(64))
BEGIN
DECLARE nId INT;
INSERT INTO Oggetto(nome,descrizione,peso) VALUES(nome,descrizione,peso);
SELECT MAX(id) INTO nId FROM Oggetto;
INSERT INTO Consumabile(id,effetto,tipo) VALUES(nId,effetto,tipo);
END|
DELIMITER ;

DROP PROCEDURE IF EXISTS CreaPersonaggioUtente;
DELIMITER |
CREATE PROCEDURE CreaPersonaggioUtente(email varchar(64), classe int, vita tinyint, forza tinyint, destrezza tinyint, resistenza tinyint)
BEGIN
DECLARE nIdCar INT;
DECLARE EXIT HANDLER FOR SQLEXCEPTION ROLLBACK;
DECLARE EXIT HANDLER FOR SQLWARNING ROLLBACK;
START TRANSACTION;
SET autocommit = 0;
IF((vita + forza + destrezza + resistenza) > 50)
THEN
ROLLBACK;
ELSE
INSERT INTO Caratteristiche(vita,forza,destrezza,resistenza) VALUES(vita,forza,destrezza,resistenza);
SELECT MAX(id) INTO nIdCar FROM Caratteristiche;
INSERT INTO PersonaggioUtente(email,caratteristiche,classe) VALUES(email,nIdCar,classe);
END IF;
COMMIT;
END|
DELIMITER ;

DROP TRIGGER IF EXISTS CheckEquip;
DELIMITER |
CREATE TRIGGER CheckEquip BEFORE UPDATE ON Inventario
FOR EACH ROW
BEGIN
DECLARE countArma int;
SELECT COUNT(*) INTO countArma 
FROM Inventario i,Arma a 
WHERE i.oggetto = a.id AND i.personaggioUtente = NEW.personaggioUtente AND i.equipaggiato = TRUE;
IF((countArma >= 1) AND NEW.equipaggiato = TRUE)
THEN
SET NEW.equipaggiato = FALSE;
END IF;
END |
DELIMITER ;


DROP TRIGGER IF EXISTS MissionePremio;
DELIMITER |
CREATE TRIGGER MissionePremio AFTER INSERT ON MissioneCompletata 
FOR EACH ROW
BEGIN
DECLARE nPremiMiss INT;
DECLARE qta INT;
DECLARE idOggetto INT;
DECLARE i INT;
DECLARE qtaAttuale INT;
SELECT COUNT(*) INTO nPremiMiss FROM Premio p WHERE p.missione = new.missione;
SET i = 0;
REPEAT
SELECT p.oggetto INTO idOggetto FROM Premio p WHERE p.missione = new.missione limit i,1;
SELECT p.quantita INTO qta FROM Premio p WHERE p.missione = new.missione limit i,1;
SELECT SUM(quantita) INTO qtaAttuale FROM Inventario WHERE oggetto = idOggetto AND personaggioUtente = new.personaggioUtente;
IF(qtaAttuale > 0)
THEN
UPDATE Inventario SET quantita = (qtaAttuale + qta) WHERE  oggetto = idOggetto AND personaggioUtente = new.personaggioUtente;
ELSE
INSERT INTO Inventario(personaggioUtente, oggetto, equipaggiato, quantita) VALUES(new.personaggioUtente, idOggetto, '0', qta);
END IF;
SET i = (i + 1);
UNTIL (i = nPremiMiss)
END REPEAT;
END |
DELIMITER ;


DROP TRIGGER IF EXISTS DropPoolCreatDomata;
DELIMITER |
CREATE TRIGGER DropPoolCreatDomata AFTER INSERT ON CreatureDomate 
FOR EACH ROW
BEGIN
DECLARE nOggettiDrop INT;
DECLARE idOggetto INT;
DECLARE i INT;
DECLARE qtaAttuale INT;
DECLARE probabilita INT;
DECLARE random INT;
SELECT COUNT(*) INTO nOggettiDrop FROM DropPool dp WHERE dp.iaNemica = new.iaNemica; 
SET i = 0;
REPEAT
SELECT dp.oggetto INTO idOggetto FROM DropPool dp WHERE dp.iaNemica = new.iaNemica limit i,1;
SELECT dp.probabilita INTO probabilita FROM DropPool dp WHERE dp.iaNemica = new.iaNemica limit i,1;
SELECT SUM(quantita) INTO qtaAttuale FROM Inventario WHERE oggetto = idOggetto AND personaggioUtente = new.personaggioUtente;
SELECT FLOOR((RAND() * 101)) INTO random;
IF(qtaAttuale > 0 AND random <= probabilita)
THEN
UPDATE Inventario SET quantita = (qtaAttuale + 1) WHERE oggetto = idOggetto AND personaggioUtente = new.personaggioUtente;
END IF;
IF((qtaAttuale = 0 OR qtaAttuale IS NULL) AND random <= probabilita)
THEN
INSERT INTO Inventario(personaggioUtente, oggetto, equipaggiato, quantita) VALUES(new.personaggioUtente, idOggetto, '0', 1);
END IF;
SET i = (i + 1);
UNTIL (i = nOggettiDrop)
END REPEAT;
END |
DELIMITER ;


DROP TRIGGER IF EXISTS Gift;
DELIMITER |
CREATE TRIGGER Gift AFTER INSERT ON PersonaggioUtente
FOR EACH ROW
BEGIN
DECLARE dn date;
DECLARE ogg INT;
DECLARE oggTotali int;
DECLARE random int;
DECLARE nowDate date;
SELECT dataNascita INTO dn FROM Profilo WHERE email = new.email;
SELECT COUNT(*) INTO oggTotali FROM Consumabile;
SELECT FLOOR((RAND() * oggTotali)) INTO random;
SELECT id INTO ogg FROM Consumabile LIMIT random, 1;
SELECT NOW() INTO nowDate;
IF(MONTH(dn) = MONTH(nowDate) AND DAY(dn) = DAY(nowDate))
THEN
INSERT INTO Inventario(personaggioUtente,oggetto,equipaggiato,quantita) VALUES(new.numero,ogg,0,1);
END IF;
END |
DELIMITER ;


DROP TRIGGER IF EXISTS MaxPersonaggiUtente;
DELIMITER |
CREATE TRIGGER MaxPersonaggiUtente BEFORE INSERT ON PersonaggioUtente
FOR EACH ROW
BEGIN
DECLARE profiliTotali TINYINT;
SELECT COUNT(*) INTO profiliTotali FROM PersonaggioUtente WHERE email = new.email;
IF(profiliTotali >= 5)
THEN
INSERT INTO Profilo SELECT * FROM Profilo LIMIT 1; 
END IF;
END |
DELIMITER ;

