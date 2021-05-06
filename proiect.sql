drop table retete;
drop table detalii_promotii;
drop table detalii_comenzi;
drop table produse;
drop table ingrediente;
drop table furnizori;
drop table promotii;
drop table comenzi;
drop table clienti_fideli;
drop table programe_fidelitate;
drop table angajati;
ALTER SESSION SET NLS_DATE_FORMAT='DD-MM-YYYY HH24:MI:SS';


----------------
create table angajati
( id_angajat number(4) constraint pk_angajati primary key,
  nume varchar2(20) constraint nume_ang_nn not null,
  prenume varchar2(15) constraint prenume_ang_nn not null,
  prenume2 varchar2 (15),
  cnp number(13) constraint cnp_nn not null constraint vf_cnp_u unique,
  tip_job varchar2(15) constraint tip_job_nn not null,
  data_angajare date constraint data_ang_nn not null,
  telefon number(11),
  email varchar2(30) constraint email_ang_nn not null constraint email_ang_u unique,
  salariu number(5) constraint salariu_nn not null constraint salariu_poz check (salariu > 0) );
  
 ----------------
create table programe_fidelitate
( id_prog_fid number(2) constraint pk_prog_fid primary key,
  procent_reducere number(2) constraint proc_red_nn not null constraint proc_red_u unique 
                             constraint proc_red_poz check (procent_reducere > 0) constraint valid_proc_red check (procent_reducere < 100 ),
  cost_anual number(2) constraint cost_anul_nn not null constraint cost_anual_poz check (cost_anual > 0) );
  
----------------                       
create table clienti_fideli
( id_client number(6) constraint clienti_fideli_pk primary key,
  id_program number(2) constraint fk_prog_fid references programe_fidelitate(id_prog_fid) on delete set null,
  nume varchar2(20) constraint nume_client_nn not null,
  prenume varchar2(15) constraint prenume_client_nn not null,
  email varchar2(30) constraint email_client_u unique,
  telefon number(11) constraint telefon_client_nn not null constraint telefon_client_u unique,
  data_aderare date constraint data_aderare_nn not null);

----------------
create table comenzi
( id_comanda number(8) constraint comenzi_pk primary key,
  id_angajat number(4) constraint fk_angajati references angajati(id_angajat) on delete set null,
  id_client_fidel number(6) constraint fk_clienti_fideli references clienti_fideli(id_client) on delete set null,
  nr_bon number(5) constraint nr_bon_nn not null,
  data_comanda date constraint data_comanda_nn not null,
  tip_plata varchar(4) constraint tip_plata_nn not null,
  constraint valid_nr_bon_data unique (nr_bon, data_comanda),
  constraint valid_tip_plata check ( lower(tip_plata) = 'card' or lower(tip_plata) = 'cash' ) );

----------------
create table promotii
( id_promotie number(5) constraint promotii_pk primary key,
  data_incepere date constraint data_incepere_nn not null,
  data_terminare date constraint data_terminare_nn not null,
  tip_promotie varchar2(10) constraint tip_promo_nn not null,
  procent number(2) default 0 constraint procent_nn not null,
  valoare number(5,2) default 0 constraint valoare_nn not null,
  constraint valid_data check ( data_incepere < data_terminare),
  constraint valid_procent_promo check (procent >= 0 and procent < 100 ),
  constraint valoare_poz check (valoare >= 0),
  constraint valid_promotie check ( (procent != 0 and valoare = 0) or (procent = 0 and valoare != 0)),
  constraint valid_tip_promo check ( lower(tip_promotie) = 'procentual' or  lower(tip_promotie) = 'valoric') );
  
----------------
create table furnizori
( id_furnizor number(3) constraint furnizori_pk primary key,
  nume_furnizor varchar2(30) constraint nume_furnizor_nn not null,
  tara varchar2(30),
  oras varchar2(30),
  email_contact varchar2(35) constraint email_furnizor_nn not null constraint email_furnizor_u unique,
  telefon_contact number(15),
  constraint valid_tara_oras check ( (tara is null and oras is not null) or (tara is not null and oras is null)) );

----------------
create table ingrediente
( id_ingredient number(5) constraint ingrediente_pk primary key,
  id_furnizor number(3) constraint fk_furnizori references furnizori(id_furnizor) on delete cascade constraint id_furnizor_nn not null,
  nume_ingredient varchar2(30) constraint nume_ingredient_nn not null constraint nume_ingredient_u unique,
  pret_unitate number(10,2) constraint pret_unitate_nn not null,
  gramaj_unitate number(8,2) constraint gramaj_unitate_nn not null,
  constraint pret_ingred_poz check (pret_unitate > 0),
  constraint gramaj_poz check (gramaj_unitate > 0) );
  
----------------
create table produse
( id_produs number(6) constraint produse_pk primary key,
  nume_produs varchar(50) constraint nume_prod_nn not null,
  pret number(5,2) constraint pret_nn not null,
  gramaj number(4) constraint gramaj_prod_nn not null,
  constraint pret_prod_poz check (pret > 0),
  constraint valid_produs unique (nume_produs, pret),
  constraint gramaj_prod_poz check (gramaj > 0) );
  
-------------
create table detalii_comenzi
( id_det_com number(10) constraint detalii_comenzi_pk primary key,
  id_comanda number(8) constraint fk_comenzi references comenzi(id_comanda) on delete cascade constraint id_comanda_nn not null,
  id_produs number(6) constraint fk_produse_comenzi references produse(id_produs) on delete set null,
  nr_bucati number(3) default 1 constraint nr_buc_nn not null constraint nr_buc_poz check ( nr_bucati > 0 ) );
  
----------------
create table detalii_promotii
( id_det_promo number(8) constraint detalii_promotii_pk primary key,
  id_promotie number(5) constraint fk_promotii references promotii(id_promotie) on delete cascade constraint id_promotie_nn not null,
  id_produs number(6) constraint fk_produse_promotii references produse(id_produs) on delete cascade constraint id_produs_promo_nn not null,
  constraint valid_det_promo unique (id_promotie, id_produs) );
  
----------------
create table retete
( id_reteta number(10) constraint retete_pk primary key,
  id_produs number(6) constraint fk_produse_retete references produse(id_produs) on delete cascade constraint id_produs_rette_nn not null,
  id_ingredient number(5) constraint fk_ingrediente references ingrediente(id_ingredient) on delete set null);
  

----------------
insert into angajati
  values (1, 'Andreescu', 'Andreea', 'Maria', 2900225245388, 'administratie', to_date( '20-10-2019', 'dd-mm-yyyy'), 40700000001, 'aandreescu@ceainarie.ro', 5000);
insert into angajati
  values (2, 'Marinescu', 'Marian', '', 1860724194314, 'administratie', to_date ('20-10-2019', 'dd-mm-yyyy'), 40700000002, 'mmarinescu@ceainarie.ro', 4000);
insert into angajati
  values (3, 'Danielescu', 'Daniel', 'Dan', 5000914324223, 'bucatarie', to_date ('21-10-2019', 'dd-mm-yyyy'), 40711111111, 'ddanielescu@ceainarie.ro', 2500);
insert into angajati
  values (4, 'Florescu', 'Floarea', '', 2960416246188, 'servire', to_date ('21-10-2019', 'dd-mm-yyyy'), 40722222221, 'fflorescu@ceainarie.ro', 2600);
insert into angajati
  values (5, 'Crinescu', 'Crina', 'Diana', 2840919179576, 'curatenie', to_date('21-10-2019', 'dd-mm-yyyy'), 40733333331, 'ccrinescu@ceainarie.ro', 2400);
insert into angajati
  values (6, 'Razvanescu', 'Razvan', 'Damian', 1970611111094, 'servire', to_date('21-10-2019', 'dd-mm-yyyy'), 40722222222, 'rrazvanescu@ceainarie.ro', 2650);
insert into angajati
  values (7, 'Bogdanescu', 'Bogdan', 'Daniel', 1931120400606, 'servire', to_date('13-02-2020', 'dd-mm-yyyy'), 40722222222, 'bbogdanescu@ceainarie.ro', 2450);
insert into angajati
  values (8, 'Ionescu', 'Ioana', '', 2941029287836, 'bucatarie', to_date('13-02-2020', 'dd-mm-yyyy'), 40711111112, 'iionescu@ceainarie.ro', 3000);
insert into angajati
  values (9, 'Corinescu', 'Corina', '', 2860218106086, 'administratie', to_date('13-02-2020', 'dd-mm-yyyy'), 40700000003, 'ccorinescu@ceainarie.ro', 4200);
insert into angajati
  values (10, 'Teodorescu', 'Teodora' , '', 6000712359019, 'servire', to_date('10-03-2020', 'dd-mm-yyyy'), 40722222223, 'tteodorescu@ceainarie.ro', 1200);
insert into angajati
  values (11, 'Cezarescu', 'Cezara', 'Camelia', 6010624397351, 'servire', to_date('10-03-2020', 'dd-mm-yyyy'), 40722222224, 'ccezarescu@ceainarie.ro', 1200);
insert into angajati
  values (12, 'Alexandrescu', 'Alexandru', '', 1980318184855, 'bucatarie', to_date('10-03-2020', 'dd-mm-yyyy'), 40711111113, 'aalexandrescu@ceainari.ro', 1300);

----------------
insert into programe_fidelitate
  values (1, 3, 12);
insert into programe_fidelitate
  values (2, 6, 20);
insert into programe_fidelitate
  values (3, 15, 45);
  
----------------
insert into clienti_fideli
  values (1, 1, 'Mihailescu', 'Constantin', 'con_mih@gmail.com', 40799999999, to_date('23-10-2019', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (2, 1, 'Constantinescu', 'Mihai', 'mih_con@gmail.com', 40799999998, to_date('23-10-2019', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (3, 2, 'Dumitrescu', 'George', 'geo_dum@gmail.com', 40799999997, to_date('23-10-2019', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (4, 1, 'Georgescu', 'Dumitra', '', 40799999996, to_date('23-10-2019', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (5, 1, 'Angelescu', 'Radu', 'rad_ang@gmail.com', 40799999995, to_date('24-10-2019', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (6, 3, 'Radulescu', 'Angela', 'ang_rad@gmail.com', 40799999994, to_date('24-10-2019', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (7, 1, 'Para', 'Daniela', 'dan_par@gmail.com', 40799999993, to_date('24-10-2019', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (8, 1, 'Corcodusa', 'Dominic', 'dom_cor@gmail.com', 40799999992, to_date('24-10-2019', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (9, 2, 'Strugure', 'Mihaela', 'mih_stru@gmail.com', 40799999991, to_date('24-10-2019', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (10, 3, 'Pruna', 'Orlando', 'orl_pru@gmail.com', 40799999990, to_date('24-10-2019', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (11, 1, 'Capsuna', 'Adela', '', 40799999989, to_date('24-10-2019', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (12, 2, 'Duda', 'Denisa', 'den_dud@gmail.com', 40799999988, to_date('26-10-2019', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (13, 1, 'Afin', 'Monica', 'mon_afi@gmail.com', 40799999987, to_date('26-10-2019', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (14, 1, 'Visin', 'Ionut', 'ion_vis@gmail.com', 40799999986, to_date('26-10-2019', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (15, 2, 'Oltean', 'Valentina', 'val_olt@gmail.com', 40799999985, to_date('26-10-2019', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (16, 1, 'Muresanu', 'Eduard', '', 40799999984, to_date('26-10-2019', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (17, 3, 'Moldoveanu', 'Ofelia', 'ofe_mol@gmail.com', 40799999983, to_date('26-10-2019', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (18, 2, 'Moldoveanu', 'Dorian', '', 40799999982, to_date('26-10-2019', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (19, 1, 'Ardeleanu', 'Laura', '', 40799999981, to_date('26-10-2019', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (20, 1, 'Galateanu', 'Narcisa', 'nar_gal@gmail.com', 40799999980, to_date('26-10-2019', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (21, 2, 'Bucuresteanu', 'Beatrice', '', 40799999979, to_date('27-10-2019', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (22, 2, 'Moldovan', 'Ovidiu', 'ovi_mol@gmail.com', 40799999978, to_date('27-10-2019', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (23, 1, 'Ionescu', 'Claudiu', 'cla_ion@gmail.com', 40799999977, to_date('27-10-2019', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (24, 1, 'Suceveanu', 'Matei', '', 40799999976, to_date('27-10-2019', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (25, 1, 'Georgescu', 'Daniela', 'dan_geo@gmail.com', 40799999975, to_date('27-10-2019', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (26, 3, 'Lupu', 'Matei', 'mat_lup@gmail.com', 40799999974, to_date('27-10-2019', 'dd-mm-yyyy'));
------
insert into clienti_fideli
  values (104, 1, 'Bursuc', 'Nicolae', 'nic_burs@yahoo.com', 40799999896, to_date('12-03-2020', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (105, 2, 'Iepure', 'Monica', '', 40799999895, to_date('12-03-2020', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (106, 1, 'Racu', 'Ioana', 'ioa_raa@gmail.com', 40799999894, to_date('12-03-2020', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (107, 2, 'Corbu', 'Miruna', '', 40799999893, to_date('13-03-2020', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (108, 3, 'Dihoru', 'Cosmin', 'cos_dih@yahoo.com', 40799999892, to_date('13-03-2020', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (109, 1, 'Vulpoiu', 'Andreea', '', 40799999891, to_date('13-03-2020', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (110, 1, 'Lupu', 'Angela', 'ang_lup@gmail.com', 40799999890, to_date('13-03-2020', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (111, 1, 'Licurici', 'Daniela', 'dan_lic', 40799999889, to_date('13-03-2020', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (112, 2, 'Ursu', 'George', 'geo_urs@gmail.com', 40799999888, to_date('14-03-2020', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (153, 1, 'Brad', 'Mihai', '', 40799999847, to_date('14-03-2020', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (154, 1, 'Brad', 'Magdalena', 'mag_bra@gmail.com', 40799999846, to_date('14-03-2020', 'dd-mm-yyyy'));
------
insert into clienti_fideli
  values (405, 1, 'Ionescu', 'Tereza', '', 40799999845, to_date('10-11-2020', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (406, 1, 'Corbu', 'Gabriela', 'gab_cor@yahoo.com', 40799999844, to_date('14-11-2020', 'dd-mm-yyyy'));
insert into clienti_fideli
  values (407, 2, 'Mihailescu', 'Stefan', 'ste_mih@gmail.com', 40799999843, to_date('14-11-2020', 'dd-mm-yyyy'));

----------------
insert into comenzi
  values (1, 4, '' , 1, to_date('23-10-2019 08:40:32', 'dd-mm-yyyy hh24:mi:ss'), 'card');
insert into comenzi
  values (2, 4, '', 2, to_date('23-10-2019 10:32:11', 'dd-mm-yyyy hh24:mi:ss'), 'card');
insert into comenzi
  values (3, 4, 1, 3, to_date('23-10-2019 13:55:02', 'dd-mm-yyyy hh24:mi:ss'), 'cash');
insert into comenzi
  values (4, 6, 2, 4, to_date('23-10-2019 14:03:11', 'dd-mm-yyyy hh24:mi:ss'), 'card');
insert into comenzi
  values (5, 6, '', 5, to_date('23-10-2019 16:00:24', 'dd-mm-yyyy hh24:mi:ss'), 'cash');
insert into comenzi
  values (6, 4, '' , 6, to_date('24-10-2019 08:25:42', 'dd-mm-yyyy hh24:mi:ss'), 'card');
insert into comenzi
  values (7, 4, 3, 7, to_date('24-10-2019 08:35:10', 'dd-mm-yyyy hh24:mi:ss'), 'card');
insert into comenzi
  values (8, 6, 4, 8, to_date('24-10-2019 08:37:56', 'dd-mm-yyyy hh24:mi:ss'), 'card');
insert into comenzi
  values (9, 6, '', 9, to_date('24-10-2019 9:03:21', 'dd-mm-yyyy hh24:mi:ss'), 'card');
insert into comenzi
  values (10, 6, '', 10, to_date('24-10-2019 10:00:00', 'dd-mm-yyyy hh24:mi:ss'), 'cash');
insert into comenzi
  values (11, 4, 5 , 11, to_date('24-10-2019 11:20:36', 'dd-mm-yyyy hh24:mi:ss'), 'cash');
insert into comenzi
  values (12, 4, 7, 12, to_date('24-10-2019 12:12:16', 'dd-mm-yyyy hh24:mi:ss'), 'card');
insert into comenzi
  values (13, 6, '', 13, to_date('24-10-2019 12:15:02', 'dd-mm-yyyy hh24:mi:ss'), 'cash');
insert into comenzi
  values (14, 4, 11, 14, to_date('24-10-2019 13:03:11', 'dd-mm-yyyy hh24:mi:ss'), 'card');
insert into comenzi
  values (15, 6, '', 15, to_date('24-10-2019 13:50:24', 'dd-mm-yyyy hh24:mi:ss'), 'cash');
insert into comenzi
  values (16, 4, 5 , 16, to_date('24-10-2019 15:20:36', 'dd-mm-yyyy hh24:mi:ss'), 'cash');
insert into comenzi
  values (17, 6, 7, 17, to_date('24-10-2019 15:57:15', 'dd-mm-yyyy hh24:mi:ss'), 'card');
insert into comenzi
  values (18, 6, '', 18, to_date('24-10-2019 17:10:02', 'dd-mm-yyyy hh24:mi:ss'), 'card');
------
insert into comenzi
  values (983, 4, 104, 983, to_date('12-03-2020 15:25:45', 'dd-mm-yyyy hh24:mi:ss'), 'cash');
insert into comenzi
  values (984, 4, 10, 984, to_date('12-03-2020 15:43:11', 'dd-mm-yyyy hh24:mi:ss'), 'card');
insert into comenzi
  values (985, 6, 106, 985, to_date('12-03-2020 16:20:46', 'dd-mm-yyyy hh24:mi:ss'), 'cash');
insert into comenzi
  values (986, 6, 107 , 986, to_date('13-03-2020 08:10:35', 'dd-mm-yyyy hh24:mi:ss'), 'cash');
insert into comenzi
  values (987, 4, '', 987, to_date('13-03-2020 08:11:40', 'dd-mm-yyyy hh24:mi:ss'), 'card');
insert into comenzi
  values (988, 4, 16, 988, to_date('13-03-2020 08:50:02', 'dd-mm-yyyy hh24:mi:ss'), 'card');
insert into comenzi
  values (989, 6, 2 , 989, to_date('13-03-2020 09:20:35', 'dd-mm-yyyy hh24:mi:ss'), 'cash');
------
insert into comenzi
  values (14011, 7, 405, 14011, to_date('04-12-2020 16:20:46', 'dd-mm-yyyy hh24:mi:ss'), 'card');
insert into comenzi
  values (14012, 7, '' , 14012, to_date('04-12-2020 08:10:35', 'dd-mm-yyyy hh24:mi:ss'), 'cash');
insert into comenzi
  values (14013, 10, 1, 14013, to_date('05-12-2020 08:11:40', 'dd-mm-yyyy hh24:mi:ss'), 'card');
insert into comenzi
  values (14014, 7, 407, 14014, to_date('05-12-2020 08:50:02', 'dd-mm-yyyy hh24:mi:ss'), 'card');
------
insert into comenzi
  values (14998, 11, 110, 14998, to_date(sysdate, 'dd-mm-yyyy hh24:mi:ss'), 'card');
insert into comenzi
  values (14999, 7, '', 14999, to_date(sysdate, 'dd-mm-yyyy hh24:mi:ss'), 'card');

----------------
insert into promotii
  values (1, to_date('02-11-2019 00:00:00', 'dd-mm-yyyy hh24:mi:ss'), to_date('02-11-2019 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'procentual', 10, default); 
insert into promotii
  values (2, to_date('01-12-2019 00:00:00', 'dd-mm-yyyy hh24:mi:ss'),  to_date('01-12-2019 14:00:00', 'dd-mm-yyyy hh24:mi:ss'), 'procentual', 5, default);
insert into promotii 
  values (3, to_date('01-12-2019 00:00:00', 'dd-mm-yyyy hh24:mi:ss'),  to_date('01-12-2019 14:00:00', 'dd-mm-yyyy hh24:mi:ss'), 'valoric', default, 4);
-----
insert into promotii
  values (13, to_date('08-03-2020 00:00:00', 'dd-mm-yyyy hh24:mi:ss'),  to_date('08-03-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'procentual', 20, default);
insert into promotii
  values (14, to_date('12-03-2020 00:00:00', 'dd-mm-yyyy hh24:mi:ss'),  to_date('13-03-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'procentual', 13, default);
insert into promotii
  values (15, to_date('20-03-2020 00:00:00', 'dd-mm-yyyy hh24:mi:ss'),  to_date('20-03-2020 12:00:00', 'dd-mm-yyyy hh24:mi:ss'), 'valoric', default, 5);
-----
insert into promotii
  values (25, to_date('01-07-2020 00:00:00', 'dd-mm-yyyy hh24:mi:ss'),  to_date('02-07-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'valoric', default, 3);
insert into promotii
  values (26, to_date('17-07-2020 00:00:00', 'dd-mm-yyyy hh24:mi:ss'),  to_date('17-07-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'procentual', 15, default);
insert into promotii
  values (27, to_date('21-07-2020 00:00:00', 'dd-mm-yyyy hh24:mi:ss'),  to_date('21-07-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'procentual', 19, default);
-----
insert into promotii
  values (60, to_date('03-12-2020 00:00:00', 'dd-mm-yyyy hh24:mi:ss'),  to_date('06-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'valoric', default, 6);
insert into promotii
  values (61, to_date('06-12-2020 00:00:00', 'dd-mm-yyyy hh24:mi:ss'),  to_date('06-12-2020 23:59:59', 'dd-mm-yyyy hh24:mi:ss'), 'procentual', 6, default);


----------------
insert into furnizori
  values (1, 'Tea Stories', 'Germania', '', 'hello@teastories.com', 4999000333111);
insert into furnizori
  values (2, 'Teallure', 'Franta', '', 'hello@teallure.fr', 33552211000);
insert into furnizori
  values (3, 'WarmDrinks', 'Spania', '', 'hello@warmdr.com', 3434343434);
insert into furnizori
  values (4, 'ShopRight', '', 'Ilfov', 'salut@shopright.ro', 40777777777);
insert into furnizori
  values (5, 'Dulcegaria', '', 'Sibiu', 'salut@dulcegaria.ro', 40707070707);

----------------
insert into ingrediente
  values (1, 1, 'Rooibos', 21, 100);
insert into ingrediente
  values (2, 1, 'Ceai verde', 23.5, 100);
insert into ingrediente
  values (3, 1, 'Ceai verde sencha', 25.5, 100);
insert into ingrediente
  values (4, 1, 'Ceai verde matcha', 27.85, 100);
insert into ingrediente
  values (5, 1, 'Ceai negru', 26.25, 100);
insert into ingrediente 
  values (6, 1, 'Earl Grey', 22.7, 100);
insert into ingrediente
  values (7, 1, 'Oolong', 22, 100);
insert into ingrediente
  values (8, 1, 'Ceai alb', 28.2, 100);
insert into ingrediente
  values (9, 2, 'Menta', 19.8, 100);
insert into ingrediente
  values (10, 2, 'Lamaie', 10, 50);
insert into ingrediente
  values (11, 2, 'Cirese', 11.2, 50);
insert into ingrediente 
  values (12, 2, 'Bucati de mere', 13.9, 100);
insert into ingrediente
  values (13, 2, 'Iasomie', 8.35, 50);
insert into ingrediente
  values (14, 2, 'Hibiscus', 14.45, 100);
insert into ingrediente
  values (15, 2, 'Piper', 7.6, 50);
insert into ingrediente
  values (16, 2, 'Galbenele', 17.85, 100);
insert into ingrediente
  values (17, 2, 'Bucati de vanilie', 11.3, 50);
insert into ingrediente
  values (18, 2, 'Coji de portocala', 7.96, 50);
insert into ingrediente
  values (19, 2, 'Ghimbir', 9.21, 50);
insert into ingrediente
  values (20, 2, 'Bucati de capsune', 10.3, 50);
insert into ingrediente
  values (21, 2, 'Bucati de cocos', 8.91, 50);
insert into ingrediente
  values (22, 2, 'Bucati de scortisoara', 10.2, 50);
insert into ingrediente
  values (23, 2, 'Bucati de caramel', 8.72, 50);
insert into ingrediente
  values (24, 2, 'Musetel', 20.4, 100);
insert into ingrediente
  values (25, 2, 'Roinita', 8.3, 50);
insert into ingrediente
  values (26, 2, 'Petale de trandafir', 9.36, 50);
insert into ingrediente
  values (27, 2, 'Fenicul', 8.05, 50);
insert into ingrediente
  values (28, 2, 'Afine', 7.48, 50);
insert into ingrediente
  values (29, 2, 'Macese', 8.3, 50);
insert into ingrediente
  values (30, 2, 'Visine', 8.72, 50);
insert into ingrediente
  values (31, 2, 'Ananas', 9.08, 50);
insert into ingrediente
  values (32, 2, 'Bergamota', 9.20, 50);
insert into ingrediente
  values (33, 2, 'Lemn dulce', 8.96, 50);
insert into ingrediente 
  values (34, 2, 'Arome', 6.34, 50);
insert into ingrediente
  values (35, 3, 'Espresso', 150, 1000);
insert into ingrediente
  values (36, 3, 'Espresso decafeinizat', 155, 1000);
insert into ingrediente 
  values (37, 4, 'Lapte', 6.7, 1000);
insert into ingrediente
  values (38, 4, 'Spuma de lapte', 6.7, 1000);
insert into ingrediente
  values (39, 4, 'Frisca', 5, 200);
insert into ingrediente
  values (40, 3, 'Pudra de ciocolata', 52, 500);
insert into ingrediente
  values (41, 4, 'Zahar brun', 5.10, 500);
insert into ingrediente
  values (42, 4, 'Whiskey irlandez', 110, 1000);
insert into ingrediente
  values (43, 4, 'Rom', 62.5, 700);
insert into ingrediente
  values (44, 3, 'Sirop de caramel', 12.3, 200);
insert into ingrediente
  values (46, 3, 'Scortisoara', 15.87, 100);
insert into ingrediente
  values (47, 3, 'Cafea solubila', 17, 100);
insert into ingrediente
  values (48, 4, 'Apa plata', 2.38, 330);
insert into ingrediente
  values (49, 4, 'Apa minerala', 2.43, 330);
insert into ingrediente
  values (50, 4, 'Coca Cola', 2.66, 330);
insert into ingrediente
  values (51, 4, 'Coca Cola Zero', 2.71, 330);
insert into ingrediente
  values (52, 4, 'Pepsi', 2.66, 330);
insert into ingrediente
  values (53, 4, 'Pepsi Twist', 2.92, 330);
insert into ingrediente
  values (54, 4, 'Mirinda', 2.59, 330);
insert into ingrediente
  values (55, 4, 'Prigat Nectar', 2.86, 330);
insert into ingrediente
  values (56, 4, 'Lamai', 3.5, 1000);
insert into ingrediente
  values (57, 4, 'Portocale', 4.56, 1000);
insert into ingrediente
  values (58, 4, 'Mere', 3.38, 1000);
insert into ingrediente
  values (59, 4, 'Inghetata cicolata', 21.54, 1000);
insert into ingrediente
  values (60, 4, 'Inghetata capsune', 24.2, 1000);
insert into ingrediente
  values (61, 4, 'Inghetata vanilie', 23.22, 1000);
insert into ingrediente 
  values (62, 5, 'Dulceata', 11.37, 250);
insert into ingrediente
  values (63, 5, 'Turta dulce', 4.2, 100);
insert into ingrediente
  values (64, 5, 'Cheesecake cu fructe de padure', 78.43, 1000);
insert into ingrediente
  values (65, 5, 'Placinta cu mere', 65.78, 1000);
insert into ingrediente
  values (66, 5, 'Salam de biscuiti', 60.32, 1000);
insert into ingrediente
  values (67, 4, 'Mix de fruncte uscate', 83.21, 1000);
insert into ingrediente
  values (68, 4, 'Mix de alune', 106.5, 1000);
insert into ingrediente
  values (69, 2, 'Fursecuri pentru ceai', 4.25, 100);
insert into ingrediente
  values (70, 4, 'Biscuiti cu nuca si ciocolata', 6.2, 100);
insert into ingrediente
  values (71, 4, 'Sandvis cu pui', 5.2, 200);
insert into ingrediente
  values (72, 4, 'Sandvis caprese', 4.45, 200);
insert into ingrediente
  values (73, 4, 'Vin rosu', 27.4, 750);
insert into ingrediente
  values (74, 4, 'Vin alb', 28.8, 750);
insert into ingrediente
  values (75, 4, 'Sampanie', 26.88, 750);
insert into ingrediente
  values (76, 4, 'Lichior', 45.55, 700);
insert into ingrediente
  values (77, 4, 'Whiskey', 53.2, 700);
insert into ingrediente
  values (78, 4, 'Ton', 81.4, 1000);
insert into ingrediente
  values (79, 4, 'Rosii', 5.42, 1000);
insert into ingrediente
  values (80, 4, 'Porumb', 12.45, 500);
insert into ingrediente
  values (81, 4, 'Salata iceberg', 6.27, 250);
insert into ingrediente 
  values (82, 4, 'Piept de pui', 21.4, 1000);
insert into ingrediente
  values (83, 4, 'Ardei gras', 8.2, 1000);
insert into ingrediente
  values (84, 4, 'Ciuperci', 5.27, 500);
insert into ingrediente
  values (85, 4, 'Castraveti', 4.98, 1000);
insert into ingrediente
  values (86, 4, 'Branza feta', 61.2, 1000);
insert into ingrediente
  values (87, 4, 'Branza mozzarella', 40.24, 1000);
insert into ingrediente
  values (88, 4, 'Ulei de masline', 34.29, 1000);
insert into ingrediente
  values (89, 4, 'Busuioc', 24.2, 100);
insert into ingrediente 
  values (90, 4, 'Oregano', 18.47, 100);
insert into ingrediente
  values (91, 4, 'Miere', 43.2, 1000);

----------------
insert into produse
  values (1, 'Analiza matematica', 15, 400);
insert into produse
  values (2, 'Algebra si geometrie', 14, 400);
insert into produse
  values (3, 'Programarea calculatoarelor', 15, 400);
insert into produse
  values (4, 'Fizica', 14, 400);
insert into produse
  values (5, 'Proiectare logica', 16, 450);
insert into produse
  values (6, 'Matematici speciale', 14, 400);
insert into produse
  values (7, 'Calcul numeric', 15, 450);
insert into produse
  values (8, 'Tehnici de programare', 16, 400);
insert into produse
  values (9, 'Proiectare asistata de calculator', 15, 400);
insert into produse
  values (10, 'Utilizarea sistemelor de operare', 15, 400);
insert into produse
  values (11, 'Bazele electrotehnicii', 14, 400);
insert into produse
  values (12, 'Printare si modelare 3D', 16, 400);
insert into produse
  values (13, 'Structuri de date si algoritmi', 14, 400);
insert into produse
  values (14, 'Programare orientata pe obiecte', 16, 400);
insert into produse
  values (15, 'Baze de date', 16, 350);
insert into produse
  values (16, 'Fundamente ale retelelor de calculatoare', 15, 400);
insert into produse
  values (17, 'Elemente de electronica analogica', 14, 400);
insert into produse
  values (18, 'Teoria sistemelor', 14, 400);
insert into produse
  values (19, 'Probabilitati si statistica', 14, 400);
insert into produse
  values (20, 'Elemente avansate de programare', 15, 400);
insert into produse
  values (21, 'Fundamente ale rutarii in retea', 14, 400);
insert into produse
  values (22, 'Electronica digitala', 16, 400);
insert into produse
  values (23, 'Calculatoare numerice', 15, 400);
insert into produse
  values (24, 'Managementul si dezvoltarea carierei', 14, 400);
insert into produse
  values (25, 'Introducere in robotica', 16, 350);
insert into produse
  values (26, 'Gandire etica si critica academica', 15, 400);
insert into produse
  values (27, 'Educatie fizica', 15, 400);
insert into produse
  values (28, 'Limba engleza', 14, 400);
insert into produse
  values (29, 'Espresso', 10, 120);
insert into produse
  values (30, 'Espresso dublu', 17, 250);
insert into produse
  values (31, 'Espresso decafeinizat', 10, 120);
insert into produse
  values (32, 'Caffe latte', 16, 250);
insert into produse
  values (33, 'Cappuccino', 15, 250);
insert into produse
  values (34, 'Cappuccino vienez', 17, 250);
insert into produse
  values (35, 'Cappuccino decafeinizat', 15, 250);
insert into produse
  values (36, 'Irish coffee', 19, 200);
insert into produse
  values (37, 'Frappe', 23, 350);
insert into produse
  values (38, 'Frappe cu sirop de caramel', 25, 200);
insert into produse
  values (39, 'Ciocolata calda', 18, 300);
insert into produse
  values (40, 'Apa plata', 15, 330);
insert into produse
  values (41, 'Apa minerala', 14, 330);
insert into produse
  values (42, 'Coca Cola', 15, 330);
insert into produse
  values (43, 'Coca Cola Zero', 14, 330);
insert into produse
  values (44, 'Pepsi', 16, 330);
insert into produse
  values (45, 'Pepsi Twist', 14, 330);
insert into produse
  values (46, 'Mirinda', 15, 330);
insert into produse
  values (47, 'Prigat Nectar', 16, 330);
insert into produse
  values (48, 'Rom', 9, 40);
insert into produse
  values (49, 'Lichior', 9, 40);
insert into produse
  values (50, 'Whiskey', 9, 40);
insert into produse
  values (51, 'Vin rosu', 21, 250);
insert into produse
  values (52, 'Vin alb', 21, 250);
insert into produse
  values (53, 'Sampanie', 22, 250);
insert into produse
  values (54, 'Fresh de portocale', 21, 300);
insert into produse
  values (55, 'Fresh de mere', 21, 300);
insert into produse
  values (56, 'Limonada', 21, 300);
insert into produse
  values (57, 'Dulceata', 20, 100);
insert into produse
  values (59, 'Turta dulce', 10, 100);
insert into produse
  values (60, 'Cheesecake cu fructe de padure', 16, 120);
insert into produse
  values (61, 'Placinta cu mere', 14, 120);
insert into produse
  values (62, 'Salam de biscuiti', 10, 100);
insert into produse
  values (63, 'Mix de fruncte uscate', 17, 75);
insert into produse
  values (64, 'Mix de alune', 16, 75);
insert into produse
  values (65, 'Fursecuri pentru ceai', 8, 75);
insert into produse
  values (66, 'Biscuiti cu nuca si ciocolata', 10, 75);
insert into produse
  values (67, 'Sandvis cu pui', 17, 200);
insert into produse
  values (68, 'Sandvis caprese', 16, 200);
insert into produse
  values (69, 'Salata caprese', 30, 250);
insert into produse
  values (70, 'Salata de ton', 34, 250);
insert into produse
  values (71, 'Salata de pui', 33, 250);
insert into produse
  values (72, 'Salata de vara', 32, 250);
insert into produse
  values (73, 'Proiectarea bazelor de date', 15, 400);
insert into produse
  values (74, 'Sisteme de operare', 14, 350);
insert into produse
  values (75, 'Inteligenta artificiala', 16, 400);
insert into produse
  values (76, 'Arhitectura sistemelor de calcul', 14, 400);
insert into produse
  values (77, 'Grafica pe calculator', 14, 400);
insert into produse
  values (78, 'Cloud computing', 15, 350);
insert into produse
  values (79, 'Comunicare si relatii publice', 14, 400);
insert into produse
  values (80, 'Miere', 3, 15);
insert into produse
  values (81, 'Zahar brun', 3, 5);

----------------
insert into detalii_comenzi
  values (1, 1, 5, 2);
insert into detalii_comenzi
  values (2, 1, 65, 2);
insert into detalii_comenzi
  values (3, 1, 23, 1);
insert into detalii_comenzi
  values (4, 2, 46, 1);
insert into detalii_comenzi
  values (5, 2, 15, 4);
insert into detalii_comenzi
  values (6, 3, 33, 2);
insert into detalii_comenzi
  values (7, 3, 22, 2);
insert into detalii_comenzi
  values (8, 3, 68, 1);
insert into detalii_comenzi
  values (9, 4, 7, 1);
insert into detalii_comenzi
  values (10, 4, 29, 2);
insert into detalii_comenzi
  values (11, 4, 41, 1);
insert into detalii_comenzi
  values (12, 5, 3, 1);
insert into detalii_comenzi
  values (13, 6, 17, 1);
insert into detalii_comenzi
  values (14, 6, 38, 1);
insert into detalii_comenzi
  values (15, 7, 31, 1);
insert into detalii_comenzi
  values (16, 7, 22, 1);
insert into detalii_comenzi
  values (17, 7, 37, 1);
insert into detalii_comenzi
  values (18, 7, 80, 2);
insert into detalii_comenzi
  values (19, 8, 4, 1);
insert into detalii_comenzi
  values (20, 8, 9, 2);
insert into detalii_comenzi
  values (21, 8, 15, 1);
insert into detalii_comenzi
  values (22, 9, 38, 2);
insert into detalii_comenzi
  values (23, 10, 24, 2);
insert into detalii_comenzi
  values (24, 10, 6, 2);
insert into detalii_comenzi
  values (25, 10, 59, 3);
insert into detalii_comenzi
  values (26, 10, 65, 1);
insert into detalii_comenzi
  values (27, 10, 74, 1);
insert into detalii_comenzi
  values (28, 11, 20, 2);
insert into detalii_comenzi
  values (29, 11, 36, 1);
insert into detalii_comenzi
  values (30, 11, 59, 2);
insert into detalii_comenzi
  values (31, 12, 4, 2);
insert into detalii_comenzi
  values (32, 12, 71, 1);
insert into detalii_comenzi
  values (33, 12, 72, 1);
insert into detalii_comenzi
  values (34, 13, 46, 1);
insert into detalii_comenzi
  values (35, 13, 15, 2);
insert into detalii_comenzi
  values (36, 13, 60, 2);
insert into detalii_comenzi
  values (37, 13, 64, 1);
insert into detalii_comenzi
  values (38, 14, 44, 2);
insert into detalii_comenzi
  values (39, 14, 25, 2);
insert into detalii_comenzi
  values (40, 15, 37, 4);
insert into detalii_comenzi
  values (41, 15, 12, 2);
insert into detalii_comenzi
  values (42, 15, 68, 2);
insert into detalii_comenzi
  values (43, 16, 8, 2);
insert into detalii_comenzi
  values (44, 17, 23, 2);
insert into detalii_comenzi
  values (45, 17, 43, 1);
insert into detalii_comenzi
  values (46, 17, 70, 2);
insert into detalii_comenzi
  values (47, 18, 21, 1);
insert into detalii_comenzi
  values (48, 18, 19, 1);
insert into detalii_comenzi
  values (49, 18, 80, 1);
insert into detalii_comenzi
  values (50, 18, 66, 2);
insert into detalii_comenzi
  values (51, 983, 8, 2);
insert into detalii_comenzi
  values (52, 983, 45, 1);
insert into detalii_comenzi
  values (53, 983, 27, 1);
insert into detalii_comenzi
  values (54, 984, 20, 2);
insert into detalii_comenzi
  values (55, 985, 24, 3);
insert into detalii_comenzi
  values (56, 985, 49, 2);
insert into detalii_comenzi
  values (57, 986, 30, 1);
insert into detalii_comenzi
  values (58, 986, 75, 2);
insert into detalii_comenzi
  values (59, 986, 59, 2);
insert into detalii_comenzi
  values (60, 987, 8, 1);
insert into detalii_comenzi
  values (61, 987, 27, 2);
insert into detalii_comenzi
  values (62, 987, 57, 1);
insert into detalii_comenzi
  values (63, 988, 21, 3);
insert into detalii_comenzi
  values (64, 988, 63, 1);
insert into detalii_comenzi
  values (65, 989, 26, 1);
insert into detalii_comenzi
  values (66, 989, 59, 2);
insert into detalii_comenzi
  values (67, 14011, 2, 2);
insert into detalii_comenzi
  values (68, 14011, 51, 2);
insert into detalii_comenzi
  values (69, 14011, 61, 3);
insert into detalii_comenzi
  values (70, 14012, 31, 1);
insert into detalii_comenzi
  values (71, 14012, 21, 1);
insert into detalii_comenzi
  values (72, 14012, 40, 1);
insert into detalii_comenzi
  values (73, 14012, 56, 2);
insert into detalii_comenzi
  values (74, 14012, 64, 3);
insert into detalii_comenzi
  values (75, 14012, 62, 2);
insert into detalii_comenzi
  values (76, 14013, 22, 1);
insert into detalii_comenzi
  values (77, 14013, 40, 2);
insert into detalii_comenzi
  values (78, 14013, 69, 2);
insert into detalii_comenzi
  values (79, 14013, 74, 2);
insert into detalii_comenzi
  values (80, 14013, 1, 1);
insert into detalii_comenzi
  values (81, 14014, 27, 1);
insert into detalii_comenzi
  values (82, 14014, 4, 2);
insert into detalii_comenzi
  values (83, 14014, 55, 1);
insert into detalii_comenzi
  values (84, 14014, 60, 3);
insert into detalii_comenzi
  values (85, 14998, 23, 2);
insert into detalii_comenzi
  values (86, 14998, 34, 1);
insert into detalii_comenzi
  values (87, 14998, 63, 2);
insert into detalii_comenzi
  values (88, 14998, 76, 2);
insert into detalii_comenzi
  values (89, 14999, 32, 2);
insert into detalii_comenzi
  values (90, 14999, 12, 2);
insert into detalii_comenzi
  values (91, 14998, 26, 1);
  
----------------
insert into detalii_promotii
  values(1, 1, 1);
insert into detalii_promotii
  values(2, 1, 2);
insert into detalii_promotii
  values(3, 1, 3);
insert into detalii_promotii
  values(4, 1, 4);
insert into detalii_promotii
  values(5, 1, 5);
insert into detalii_promotii
  values(6, 1, 6);
insert into detalii_promotii
  values(7, 1, 7);
insert into detalii_promotii
  values(8, 1, 8);
insert into detalii_promotii
  values(9, 1, 9);
insert into detalii_promotii
  values(10, 1, 10);
insert into detalii_promotii
  values(11, 1, 11);
insert into detalii_promotii
  values(12, 1, 12);
insert into detalii_promotii
  values(13, 1, 13);
insert into detalii_promotii
  values(14, 1, 14);
insert into detalii_promotii
  values(15, 1, 15);
insert into detalii_promotii
  values(16, 1, 16);
insert into detalii_promotii
  values(17, 1, 17);
insert into detalii_promotii
  values(18, 1, 18);
insert into detalii_promotii
  values(19, 1, 19);
insert into detalii_promotii
  values(20, 1, 20);
insert into detalii_promotii
  values(21, 1, 21);
insert into detalii_promotii
  values(22, 1, 22);
insert into detalii_promotii
  values(23, 1, 23);
insert into detalii_promotii
  values(24, 1, 24);
insert into detalii_promotii
  values(25, 1, 25);
insert into detalii_promotii
  values(26, 1, 26);
insert into detalii_promotii
  values(27, 1, 27);
insert into detalii_promotii
  values(28, 1, 28);
insert into detalii_promotii
  values(29, 1, 73);
insert into detalii_promotii
  values(30, 1, 74);
insert into detalii_promotii
  values(31, 1, 75);
insert into detalii_promotii
  values(32, 1, 76);
insert into detalii_promotii
  values(33, 1, 77);
insert into detalii_promotii
  values(34, 1, 78);
insert into detalii_promotii
  values(35, 1, 79);
insert into detalii_promotii
  values(36, 1, 80);
insert into detalii_promotii
  values(37, 1, 81);
insert into detalii_promotii
  values(38, 2, 67);
insert into detalii_promotii
  values(39, 2, 68);
insert into detalii_promotii
  values(40, 2, 69);
insert into detalii_promotii
  values(41, 2, 70);
insert into detalii_promotii
  values(42, 2, 71);
insert into detalii_promotii
  values(43, 2, 72);
insert into detalii_promotii
  values(44, 3, 54);
insert into detalii_promotii
  values(45, 3, 55);
insert into detalii_promotii
  values(46, 3, 56);
insert into detalii_promotii
  values(47, 3, 57);
insert into detalii_promotii
  values(48, 3, 59);
insert into detalii_promotii
  values(49, 13, 4);
insert into detalii_promotii
  values(50, 13, 6);
insert into detalii_promotii
  values(51, 13, 7);
insert into detalii_promotii
  values(52, 13, 8);
insert into detalii_promotii
  values(53, 13, 11);
insert into detalii_promotii
  values(54, 13, 12);
insert into detalii_promotii
  values(55, 13, 15);
insert into detalii_promotii
  values(56, 13, 26);
insert into detalii_promotii
  values(57, 13, 27);
insert into detalii_promotii
  values(58, 13, 28);
insert into detalii_promotii
  values(59, 13, 51);
insert into detalii_promotii
  values(60, 13, 52);
insert into detalii_promotii
  values(61, 13, 80);
insert into detalii_promotii
  values(62, 13, 77);
insert into detalii_promotii
  values(63, 14, 13);
insert into detalii_promotii
  values(64, 14, 26);
insert into detalii_promotii
  values(65, 14, 39);
insert into detalii_promotii
  values(66, 14, 52);
insert into detalii_promotii
  values(67, 14, 65);
insert into detalii_promotii
  values(68, 14, 78);
insert into detalii_promotii
  values(69, 15, 30);
insert into detalii_promotii
  values(70, 15, 32);
insert into detalii_promotii
  values(71, 15, 33);
insert into detalii_promotii
  values(72, 15, 34);
insert into detalii_promotii
  values(73, 15, 35);
insert into detalii_promotii
  values(74, 15, 36);
insert into detalii_promotii
  values(75, 15, 37);
insert into detalii_promotii
  values(76, 15, 38);
insert into detalii_promotii
  values(77, 15, 39);
insert into detalii_promotii
  values(78, 25, 6);
insert into detalii_promotii
  values(79, 25, 7);
insert into detalii_promotii
  values(80, 25, 8);
insert into detalii_promotii
  values(81, 25, 9);
insert into detalii_promotii
  values(82, 25, 10);
insert into detalii_promotii
  values(83, 25, 11);
insert into detalii_promotii
  values(84, 25, 12);
insert into detalii_promotii
  values(85, 25, 27);
insert into detalii_promotii
  values(86, 25, 28);
insert into detalii_promotii
  values(87, 26, 57);
insert into detalii_promotii
  values(89, 26, 59);
insert into detalii_promotii
  values(90, 26, 60);
insert into detalii_promotii
  values(91, 26, 61);
insert into detalii_promotii
  values(92, 26, 62);
insert into detalii_promotii
  values(93, 26, 65);
insert into detalii_promotii
  values(94, 26, 66);
insert into detalii_promotii
  values(95, 26, 80);
insert into detalii_promotii
  values(96, 26, 81);
insert into detalii_promotii
  values(97, 27, 36);
insert into detalii_promotii
  values(98, 27, 37);
insert into detalii_promotii
  values(99, 27, 38);
insert into detalii_promotii
  values(100, 27, 51);
insert into detalii_promotii
  values(101, 27, 52);
insert into detalii_promotii
  values(102, 27, 53);
insert into detalii_promotii
  values(103, 27, 54);
insert into detalii_promotii
  values(104, 27, 55);
insert into detalii_promotii
  values(105, 27, 56);
insert into detalii_promotii
  values(106, 27, 57);
insert into detalii_promotii
  values(107, 27, 69);
insert into detalii_promotii
  values(108, 27, 70);
insert into detalii_promotii
  values(109, 27, 71);
insert into detalii_promotii
  values(110, 27, 72);
insert into detalii_promotii
  values(111, 60, 54);
insert into detalii_promotii
  values(112, 60, 55);
insert into detalii_promotii
  values(113, 60, 56);
insert into detalii_promotii
  values(114, 60, 57);
insert into detalii_promotii
  values(115, 61, 5);
insert into detalii_promotii
  values(116, 61, 8);
insert into detalii_promotii
  values(117, 61, 12);
insert into detalii_promotii
  values(118, 61, 14);
insert into detalii_promotii
  values(119, 61, 15);
insert into detalii_promotii
  values(120, 61, 17);

----------------  
insert into retete
  values(1, 1, 6);
insert into retete
  values(2, 1, 26);
insert into retete
  values(3, 1, 91);
insert into retete
  values(4, 2, 8);
insert into retete
  values(5, 2, 34);
insert into retete
  values(6, 2, 91);
insert into retete
  values(7, 3, 4);
insert into retete
  values(8, 3, 91);
insert into retete
  values(9, 4, 2);
insert into retete
  values(10, 4, 21);
insert into retete
  values(11, 4, 26);
insert into retete
  values(12, 4, 91);
insert into retete
  values(13, 5, 1);
insert into retete
  values(14, 5, 23);
insert into retete
  values(15, 5, 91);
insert into retete
  values(16, 6, 3);
insert into retete
  values(17, 6, 91);
insert into retete
  values(18, 7, 2);
insert into retete
  values(19, 7, 10);
insert into retete
  values(20, 7, 32);
insert into retete
  values(21, 7, 91);
insert into retete
  values(22, 8, 9);
insert into retete
  values(23, 8, 19);
insert into retete
  values(24, 8, 91);
insert into retete
  values(25, 9, 2);
insert into retete
  values(26, 9, 13);
insert into retete
  values(27, 9, 34);
insert into retete
  values(28, 9, 91);
insert into retete
  values(29, 10, 12);
insert into retete
  values(30, 10, 14);
insert into retete
  values(31, 10, 31);
insert into retete
  values(32, 10, 91);
insert into retete
  values(33, 11, 19);
insert into retete
  values(34, 11, 33);
insert into retete
  values(35, 11, 9);
insert into retete
  values(36, 11, 91);
insert into retete
  values(37, 12, 5);
insert into retete
  values(38, 12, 23);
insert into retete
  values(39, 12, 26);
insert into retete
  values(40, 12, 91);
insert into retete
  values(41, 13, 7);
insert into retete
  values(42, 13, 91);
insert into retete
  values(43, 14, 9);
insert into retete
  values(44, 14, 27);
insert into retete
  values(45, 14, 28);
insert into retete
  values(46, 14, 91);
insert into retete
  values(47, 15, 1);
insert into retete
  values(48, 15, 18);
insert into retete
  values(49, 15, 10);
insert into retete
  values(50, 15, 22);
insert into retete
  values(51, 15, 91);
insert into retete
  values(52, 16, 12);
insert into retete
  values(53, 16, 22);
insert into retete
  values(54, 16, 21);
insert into retete
  values(55, 16, 91);
insert into retete
  values(56, 17, 6);
insert into retete
  values(57, 17, 91);
insert into retete
  values(58, 18, 9);
insert into retete
  values(59, 18, 25);
insert into retete
  values(60, 18, 17);
insert into retete
  values(61, 18, 91);
insert into retete
  values(62, 19, 12);
insert into retete
  values(63, 19, 11);
insert into retete
  values(64, 19, 20);
insert into retete
  values(65, 19, 91);
insert into retete
  values(66, 20, 1);
insert into retete
  values(67, 20, 26);
insert into retete
  values(68, 20, 15);
insert into retete
  values(69, 20, 19);
insert into retete
  values(70, 20, 91);
insert into retete
  values(71, 21, 16);
insert into retete
  values(72, 21, 25);
insert into retete
  values(73, 21, 91);
insert into retete
  values(74, 22, 5);
insert into retete
  values(75, 22, 18);
insert into retete
  values(76, 22, 17);
insert into retete
  values(77, 22, 91);
insert into retete
  values(78, 23, 12);
insert into retete
  values(79, 23, 20);
insert into retete
  values(80, 23, 29);
insert into retete
  values(81, 23, 91);
insert into retete
  values(82, 24, 6);
insert into retete
  values(83, 25, 20);
insert into retete
  values(84, 25, 33);
insert into retete
  values(85, 25, 91);
insert into retete
  values(86, 26, 27);
insert into retete
  values(87, 26, 23);
insert into retete
  values(88, 26, 91);
insert into retete
  values(89, 27, 1);
insert into retete
  values(90, 27, 11);
insert into retete
  values(91, 27, 17);
insert into retete
  values(92, 27, 91);
insert into retete
  values(93, 28, 6);
insert into retete
  values(94, 28, 91);
insert into retete
  values(95, 29, 35);
insert into retete
  values(96, 30, 35);
insert into retete
  values(97, 31, 36);
insert into retete
  values(98, 32, 35);
insert into retete
  values(99, 32, 37);
insert into retete
  values(100, 33, 35);
insert into retete
  values(101, 33, 37);
insert into retete
  values(102, 33, 38);
insert into retete
  values(103, 34, 35);
insert into retete
  values(104, 34, 37);
insert into retete
  values(105, 34, 39);
insert into retete
  values(106, 35, 36);
insert into retete
  values(107, 35, 37);
insert into retete
  values(108, 35, 38);
insert into retete
  values(109, 36, 35);
insert into retete
  values(110, 36, 42);
insert into retete
  values(111, 36, 41);
insert into retete
  values(112, 36, 38);
insert into retete
  values(113, 37, 47);
insert into retete
  values(114, 37, 37);
insert into retete
  values(115, 37, 39);
insert into retete
  values(116, 38, 47);
insert into retete
  values(117, 38, 37);
insert into retete
  values(118, 38, 39);
insert into retete
  values(119, 38, 44);
insert into retete
  values(120, 39, 40);
insert into retete
  values(121, 39, 34);
insert into retete
  values(122, 39, 46);
insert into retete
  values(123, 40, 48);
insert into retete
  values(124, 41, 49);
insert into retete
  values(125, 42, 50);
insert into retete
  values(126, 43, 51);
insert into retete
  values(127, 44, 52);
insert into retete
  values(128, 45, 53);
insert into retete
  values(129, 46, 54);
insert into retete
  values(130, 47, 55);
insert into retete
  values(131, 48, 43);
insert into retete
  values(132, 49, 76);
insert into retete
  values(133, 50, 77);
insert into retete
  values(134, 51, 73);
insert into retete
  values(135, 52, 74);
insert into retete
  values(136, 53, 75);
insert into retete
  values(137, 54, 57);
insert into retete
  values(138, 55, 58);
insert into retete
  values(139, 56, 56);
insert into retete
  values(140, 56, 91);
insert into retete
  values(141, 57, 62);
insert into retete
  values(142, 59, 63);
insert into retete
  values(143, 60, 64);
insert into retete
  values(144, 61, 65);
insert into retete
  values(145, 62, 66);
insert into retete
  values(146, 63, 67);
insert into retete
  values(147, 64, 68);
insert into retete
  values(148, 65, 69);
insert into retete
  values(149, 66, 70);
insert into retete
  values(150, 67, 71);
insert into retete
  values(151, 68, 72);
insert into retete
  values(152, 69, 87);
insert into retete
  values(153, 69, 79);
insert into retete
  values(154, 69, 88);
insert into retete
  values(155, 69, 89);
insert into retete
  values(156, 70, 81);
insert into retete
  values(157, 70, 78);
insert into retete
  values(158, 70, 79);
insert into retete
  values(159, 70, 80);
insert into retete
  values(160, 71, 81);
insert into retete
  values(161, 71, 82);
insert into retete
  values(162, 71, 84);
insert into retete
  values(163, 71, 83);
insert into retete
  values(164, 71, 88);
insert into retete
  values(165, 72, 81);
insert into retete
  values(166, 72, 79);
insert into retete
  values(167, 72, 86);
insert into retete
  values(168, 72, 85);
insert into retete
  values(169, 72, 83);
insert into retete
  values(170, 72, 88);
insert into retete
  values(171, 73, 2);
insert into retete
  values(172, 73, 7);
insert into retete
  values(173, 73, 12);
insert into retete
  values(174, 73, 22);
insert into retete
  values(175, 73, 91);
insert into retete
  values(176, 74, 3);
insert into retete
  values(177, 74, 8);
insert into retete
  values(178, 74, 13);
insert into retete
  values(179, 74, 17);
insert into retete
  values(180, 74, 91);
insert into retete
  values(181, 75, 12);
insert into retete
  values(182, 75, 29);
insert into retete
  values(183, 75, 22);
insert into retete
  values(184, 75, 20);
insert into retete
  values(185, 75, 15);
insert into retete
  values(186, 75, 91);
insert into retete
  values(187, 76, 14);
insert into retete
  values(188, 76, 12);
insert into retete
  values(189, 76, 31);
insert into retete
  values(190, 76, 21);
insert into retete
  values(191, 76, 91);
insert into retete
  values(192, 77, 2);
insert into retete
  values(193, 77, 5);
insert into retete
  values(194, 77, 26);
insert into retete
  values(195, 77, 13);
insert into retete
  values(196, 77, 91);
insert into retete
  values(197, 78, 5);
insert into retete
  values(198, 78, 11);
insert into retete
  values(199, 78, 25);
insert into retete
  values(200, 78, 91);
insert into retete
  values(201, 79, 20);
insert into retete
  values(202, 79, 10);
insert into retete
  values(203, 79, 29);
insert into retete
  values(204, 79, 12);
insert into retete
  values(205, 79, 23);
insert into retete
  values(206, 79, 18);
insert into retete
  values(207, 79, 91);
insert into retete
  values(208, 80, 91);
insert into retete
  values(209, 81, 41);
  
insert into retete
  values (210, 24, 91);
  
commit;