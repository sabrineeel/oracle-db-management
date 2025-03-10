
-------------------------------------Partie I : Création des Tablespaces et des utilisateurs --------------------------------------------------------------
--1-Créer deux Tablespaces IOT_TBS et IOT_TempTBS
--IOT_TBS --
create  tablespace IOT_TBS 
datafile 'C:\IOT_TBS.dat' 
size 100M
Autoextend on 
online;

--IOT_TempTBS--
create  temporary  tablespace IOT_TempTBS 
tempfile  'C:\IOT_TempTBS.dat' 
size 100M 
Autoextend on ;

--2-Créer un utilisateur DBAIOT en lui attribuant les deux tablespaces créés précédemment
create user DBAIOT  identified by sabrinel 
default tablespace IOT_TBS 
temporary tablespace  IOT_TempTBS;

--3-Donner tous les privilèges à cet utilisateur.
grant all privileges to DBAIOT;



---------------------------------Partie 2 : Langage de définition de données--------------------------------------------------------------------------------------
--4. Créer les relations de base avec toutes les contraintes d’intégrité. 

-- création de la table user
create table utilisateur (-- ici, j'ai changé le nom de la table de "user" en "utilisateur" pour éviter un conflit avec le mot réservé "USER" dans Oracle.
    iduser number primary key,
    lastname varchar2(50) ,
    firstname varchar2(50),
    email varchar2(50) 
);

-- création de la table service
create table service (
    idservice number primary key,
    name varchar2(50),
    servicetype varchar2(50)
);

-- création de la table thing
create table thing (
    mac char(17) primary key,
    iduser number ,
    thingtype varchar2(50),
    param number,
    constraint fk_iduser foreign key (iduser) references utilisateur(iduser) on delete cascade
);

-- création de la table subscribe
create table subscribe (
    iduser number ,
    idservice number ,
    constraint pk_cleprimaire primary key (iduser, idservice),
    constraint fk_iduser2 foreign key (iduser) references utilisateur(iduser) on delete cascade,
    constraint fk_idservice foreign key (idservice) references service(idservice) on delete cascade
);

--5. Ajouter l’attribut ADRESSUSER de type chaine de caractères dans la relation USER.
alter table utilisateur 
add adressuser varchar2(50);
--6. Ajouter la contrainte not null pour les attributs ADRESSUSER et LASTNAME de la relation USER.

-- Ajouter la contrainte NOT NULL pour l'attribut ADRESSUSER
alter table utilisateur 
modify adressuser varchar2(50) not null;

-- Ajouter la contrainte NOT NULL pour l'attribut LASTNAME
alter table utilisateur 
modify lastname varchar2(50) not null;

--7. Modifier la longueur de l’attribut ADRESSUSER (agrandir, réduire). 
-- agrandir
alter table utilisateur 
modify adressuser varchar2(150);
--réduire
alter table utilisateur 
modify adressuser varchar2(45);

--8. Renommer la colonne ADRESSUSER dans la table USER par ADRUSER. Vérifier. 

alter table utilisateur 
rename column adressuser to adruser;
--verification 
describe utilisateur;

--9. Supprimer la colonne ADRUSER dans la table USER. Vérifier la suppression.
alter table utilisateur 
drop column adruser;
--verification
describe utilisateur;

--10. Un utilisateur s’inscrit à un service pour une période délimitée par un début et fin. Donner les instructions SQL pour répondre à ce besoin.
alter table subscribe
add (
    debut_date date  default sysdate, --la date actuelle par defaut dans le cas ou  les champs ne sont pas renseignés
    fin_date date default (sysdate + 365) --un an après la date actuelle
);

---------------------------------Partie 3 : Langage de manipulation de données--------------------------------------------------------------------------------------

--11. Remplir toutes les tables par les instances représentées ci-dessus. Quels sont les problèmes rencontrés ?


-- Insertion des données dans la table utilisateur
insert into utilisateur (iduser, lastname, firstname, email) values (1, 'Souad', 'MESBAH', 'souad.mesbah@gmail.com');
insert into utilisateur (iduser, lastname, firstname, email) values (2,  'Younes', 'CHALAH','younes.chalah@gmail.com');
insert into utilisateur (iduser, lastname, firstname, email) values (3, 'Chahinaz', 'MELEK','chahinaz.melek@gmail.com');
insert into utilisateur (iduser, lastname, firstname, email) values (4, 'Samia', 'OUALI', 'samia.ouali@gmail.com');
insert into utilisateur (iduser, lastname, firstname, email) values (5, 'Djamel', 'MATI','djamel.mati@gmail.com');
insert into utilisateur (iduser, lastname, firstname, email) values (6, 'Assia', 'HORRA','assia.horra@gmail.com');
insert into utilisateur (iduser, lastname, firstname, email) values (7, 'Lamine', 'MERABAT','Lamine.MERABAT@gmail.com');
insert into utilisateur (iduser, lastname, firstname, email) values (8, 'Seddik', 'HMIA', 'seddik.hmia@gmail.com');
insert into utilisateur (iduser, lastname, firstname, email) values (9, 'Widad', 'TOUATI', 'widad.touati@gmail.com');
-- Insertion des données dans la table service
insert into service (idservice, name, servicetype) values (1, 'myKWHome', 'smarthome');
insert into service (idservice, name, servicetype) values (2, 'FridgAlert', 'smarthome');
insert into service (idservice, name, servicetype) values (3, 'RUNstats', 'quantifiedself');
insert into service (idservice, name, servicetype) values (4, 'traCARE', 'quantifiedself');
insert into service (idservice, name) values (5, 'dogWATCH');
insert into service (idservice, name) values (6, 'CarUse');
-- Insertion des données dans la table thing 
insert into thing (mac, iduser, thingtype, param) values ('f0:de:f1:39:7f:17', 1,NULL, NULL);
insert into thing (mac, iduser, thingtype, param) values ('f0:de:f1:39:7f:18', 2, NULL, NULL);
insert into thing (mac, iduser, thingtype, param) values ('f0:de:f1:39:7f:19', 2, 'thingtempo', 60);
insert into thing (mac, iduser, thingtype, param) values ('f0:de:f1:39:7f:25', 10, NULL, NULL); --erreur d'insertion
insert into thing (mac, iduser, thingtype, param) values ('f0:de:f1:39:7f:20', 2, 'thingtempo', 1.5);
insert into thing (mac, iduser, thingtype, param) values ('f0:de:f1:39:7f:21', 4, NULL,NULL);
insert into thing (mac, iduser, thingtype, param) values ('f0:de:f1:39:7f:22', 4, NULL, NULL);
-- Insertion des données dans la table subscribe
insert into subscribe (iduser, idservice) values (2, 1);
insert into subscribe (iduser, idservice) values (2, 2);
insert into subscribe (iduser, idservice) values (1, 3);
insert into subscribe (iduser, idservice) values (3, 7); --erreur d'insertion

------------------------------------- Partie 4 : Gestion des utilisateurs -----------------------------------------------------------------

--1. Connectez vous avec l’utilisateur DBAIOT et créez un autre utilisateur : Admin en lui donnant les mêmes tablespace que DBAIOT.
connect  DBAIOT/sabrinel
create user admin identified by adm
default tablespace IOT_TBS
temporary tablespace IOT_TempTBS;

--2. Connectez-vous à l’aide cet utilisateur. Que remarquez-vous ?
connect admin/adm
--3. Donnez le droit de création d’une session pour cet utilisateur (Create Session) et reconnectez-vous.
connect DBAIOT/sabrinel
grant create session to admin;
connect admin/adm
 
--4. Donnez les privilèges suivants à Admin: créer des tables, des utilisateurs. Vérifiez.
connect DBAIOT/sabrinel
grant create table, create user to admin;
-- vérification 
select * from user_sys_privs;

--5. Exécutez la requête Q1 suivante : Select * from DBAIOT.utilisateur ; Que remarquez-vous ?
connect admin/adm
Select * from DBAIOT.utilisateur ;
--6. Donnez le droit de lecture à cet utilisateur pour la table USERS. Exécutez la requête Q1 maintenant.
connect  DBAIOT/sabrinel
grant select on utilisateur to admin;
-- SET LINESIZE 200; --affichage
Select * from DBAIOT.utilisateur ;
--7. On veut créer une vue USER_THING qui sauvegarde pour chaque utilisateur ses objets connectés. Que faut-il faire ?Que remarquez-vous ?
create view user_thing as
select u.iduser, u.firstname, u.lastname, t.thing_name, t.thing_type
from utilisateur u
join things t on u.iduser = t.user_id;
--8. Donnez le droit de création de vue à cet utilisateur, le droit de lecture sur la table THING et réessayez de refaire lacréation de la vue.
connect DBAIOT/sabrinel
grant create view to admin;
grant select on DBAIOT.utilisateur to admin;
grant select on DBAIOT.thing to admin;
connect admin/adm

create view user_thing as 
select u.iduser, u.lastname, t.mac, t.thingtype 
from DBAIOT.utilisateur u 
join DBAIOT.thing t on u.iduser = t.iduser;

--9)	Créez un index NAMESERVICE_IX sur l’attribut NAME de la table SERVICE. Que remarquez-vous ?
create index nameservice_ix on service(name);	
--10)	Donnez le droit de création d’index à Admin pour la table SERIVCE, ensuite réessayez de créer l’index. Que se passe-til ?
connect DBAIOT/sabrinel;
grant create any index to admin;
grant select on DBAIOT.service to admin;
connect admin/adm;
create index nameservice_ix on DBAIOT.service(name);

connect dbaiot/sabrinel
connect admin/adm;
Alter user admin QUOTA UNLIMITED on IOT_TBS 
create index nameservice_ix on DBAIOT.service(name);
--11)	Enlevez les privilèges précédemment accordés.
connect DBAIOT/sabrinel;
-- privilege de creation d'index
revoke create any index from admin;
-- le privilege SELECT sur la table SERVICE
revoke select on DBAIOT.service from admin;
-- le privilege SELECT sur la table UTILISATEUR
revoke select on DBAIOT.utilisateur from admin;
-- le privilege SELECT sur la table thing
grant select on DBAIOT.thing to admin;
--le privilege de creation de vue
revoke create view from admin;
-- le privilege de creation de session
revoke create session from admin;
-- les privileges de creation de table et d'utilisateur
revoke create table, create user from admin; 
-- les privileges table space 
revoke unlimited tablespace from admin;

--12)	Vérifiez que les privilèges ont bien été supprimés. 
connect DBAIOT/sabrinel;
grant create session to admin;
connect admin/adm
select * from user_sys_privs;
revoke create session from admin;
--13)	Créez un profil « IOT_Profil »  

Create PROFILE IOT_Profil limit
SESSIONS_PER_USER           3                        -- 3 sessions simultanées autorisées
    CPU_PER_SESSION             35                       -- Un appel système ne peut pas consommer plus de 35 secondes de CPU
    CONNECT_TIME                5400                     -- Chaque session ne peut excéder 90 minutes (60*90=5400 secondes)
    LOGICAL_READS_PER_SESSION   1200                     -- Un appel système ne peut lire plus de 1200 blocs de données en mémoire et sur le disque
    PRIVATE_SGA              25600                         -- 25 KB of memory in SGA (in bytes)
    IDLE_TIME                   30                       -- 30 minutes d'inactivité maximum autorisées par session
    FAILED_LOGIN_ATTEMPTS       5                        -- 5 tentatives de connexion avant blocage du compte
    PASSWORD_LIFE_TIME          50                       -- Le mot de passe est valable pendant 50 jours
    PASSWORD_REUSE_TIME         40                       -- Il faut attendre 40 jours avant qu'un mot de passe puisse être réutilisé
    PASSWORD_LOCK_TIME          1                        -- 1 jour d'interdiction d'accès après 5 tentatives échouées de connexion
    PASSWORD_GRACE_TIME         5;                        -- La période de grâce pour prolonger l'utilisation du mot de passe avant son changement est de 5 jours





--14)	Affectez ce profil à l’utilisateur Admin. 
alter user admin profile iot_profil;

--15)	Créez le rôle : « SUBSCRIBE_MANAGER » qui peut voir les tables USERS, SERVICE et peut modifier les lignes de la table SUBSCRIBE. 

create role subscribe_manager;
grant select on dbaiot.utilisateur to subscribe_manager;
grant select on dbaiot.service to subscribe_manager;
grant update,delete,insert on dbaiot.subscribe to subscribe_manager;

--16)	Assignez ce rôle à Admin. Vérifier que les autorisations assignées au rôle SUBSCRIBE_MANAGER , ont été bien transférées sur l’utilisateur à Admin.

grant subscribe_manager to admin;
-- Vérifier les privilèges associés à l'utilisateur Admin
select * from user_tab_privs where grantee = 'ADMIN';
select * from user_sys_privs where grantee = 'ADMIN';
select * from user_role_privs where grantee = 'ADMIN';

------------------------------------- Partie 5 : Dictionnaire de données -----------------------------------------------------------------

--1. Connecter en tant que « System ». Lister le catalogue « DICT ». Il contient combien d’instances ? Donner sa structure ?(Describe DICT; select * from dict;)
connect system/1234;

select * from dict;
-- le dictionnaire contient 
-- table_name | comments

select count(*) from dict;

describe dict;


--2. Donner le rôle et la structure des tables (ou vues) suivantes : ALL_TAB_COLUMNS, USER_USERS,
--ALL_CONSTRAINTS et USER_TAB_PRIVS. 

describe all_tab_columns;
select comments from dict where table_name = 'all_tab_columns';
describe user_users;
select comments from dict where table_name = 'user_users';
describe all_constraints;
select comments from dict where table_name = 'all_constraints';
describe user_tab_privs;
select comments from dict where table_name = 'user_tab_privs';

--3. Trouver le nom d’utilisateur avec lequel vous êtes connecté (sans utiliser show user, en utilisant le dictionnaire)?
select username from user_users;
--4. Comparer la structure et le contenu des tables ALL_TAB_COLUMNS et USER_ TAB_COLUMNS ?
describe all_tab_columns;
describe user_tab_columns;

--5. Vérifiez que les tables de la partie 1 ont été réellement créées (afficher la liste des tables de l'utilisateur connecté) ? Donner
--toutes les informations sur ces tables ?

select table_name from user_tables;

--table utilisateur 
select table_name, column_name, data_type, data_length, nullable
from all_tab_columns
where owner = 'DBAIOT'
 and  table_name = 'UTILISATEUR ';
 --table service
 select table_name, column_name, data_type, data_length, nullable
from all_tab_columns
where owner = 'DBAIOT'
 and  table_name = 'SERVICE';
 --table thing
 select table_name, column_name, data_type, data_length, nullable
from all_tab_columns
where owner = 'DBAIOT'
 and  table_name = 'THING';
 --table suscribe
 select table_name, column_name, data_type, data_length, nullable
from all_tab_columns
where owner = 'DBAIOT'
 and  table_name = 'SUBSCRIBE ';

--6. Lister les tables de l’utilisateur « system » et celles de l’utilisateur DBAIOT (l’utilisateur de la partie 1).
select table_name from user_tables; 
select  table_name from all_tables
where owner = 'DBAIOT';
--7. Donner la description des attributs des tables THING et SUBSCRIBE (Exploiter la table USER_TAB_COLUMNS).
select  table_name,  column_name,  data_type,  data_length,  nullable
from all_tab_columns
where owner = 'DBAIOT' and table_name in ('THING', 'SUBSCRIBE')
order by  table_name, column_id;

--8. Comment peut-on vérifie qu’il y a une référence de clé étrangère entre les tables THING et SUBSCRIBE?
select constraint_name, constraint_type from user_constraints where table_name in ('thing','service');

--9. Donner toutes les contraintes créées lors de la partie et les informations qui les caractérisent (Exploitez la table USER_CONSTRAINTS);
select constraint_name,constraint_type,table_name,status,deferrable,deferred,validated 
from  all_constraints
where  owner = 'DBAIOT';
--10. Retrouver toutes les informations permettant de recréer la table SUBSCRIBE.
 --attribut+type
select column_name, data_type, data_length, nullable
from user_tab_columns
where owner = 'DBAIOT' and table_name = 'SUBSCRIBE';
 --contraint
select  constraint_name,  constraint_type, table_name, status, deferrable, deferred, validated
from user_constraints
where owner = 'DBAIOT' and table_name = 'SUBSCRIBE';
 --cle primaire
select column_name from all_cons_columns
where constraint_name = ( select  constraint_name  from all_constraints
  where owner = 'DBAIOT' and table_name = 'SUBSCRIBE' constraint_type = 'P');


--11. Trouver tous les privilèges accordés à Admin (comme on les a supprimé dans la partie 2, recréez 2 privilèges système et un privilège objet pour admin et les afficher en tant que admin et en tant que system).
grant create session to admin;
grant create table to admin;
grant select on dbaiot.utilisateur to admin;
connect admin/adm
select * from user_tab_privs;
connect system/1234
select * from dba_sys_privs where grantee = 'ADMIN';
 --12. Trouver les rôles donnés à l’utilisateur Admin.
select *  from  dba_role_privs where  grantee = 'ADMIN';

--13. Trouver tous les objets appartenant à Admin.
select object_name, object_type from all_objects
where owner = 'ADMIN';

--14. L’administrateur cherche le propriétaire de la table SUBSCRIBE, comment il pourra le trouver ?
connect admin/adm
select owner, table_name from all_tables
where table_name = 'SUBSCRIBE';

--15. Donner la taille en Ko de la table SUBSCRIBE (utiliser desc user_segments;).
connect system/1234
select segment_name,   segment_type,   bytes / 1024 as size_kb
from dba_segments
where segment_name = 'SUBSCRIBE' and owner = 'DBAIOT';

--16. Vérifier l’effet produit par chacune des commandes de définition de données de la partie 1 sur le dictionnaire :
--Créez un nouvel utilisateur comme dans la partie 1, donner lui tous les privilèges ensuite connectez-vous avec cet utilisateur
--que vous venez de créer 

connect system/1234;
create user newUser identified by saber;
grant connect , resource,dba to newUser;

connect newUser/saber
select * from all_users;
select * from user_sys_privs;
select * from user_tab_privs;
select * from user_role_privs;
select * from user_objects;

