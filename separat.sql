select *from produse order by id_produs desc





-------------------------------------------------------------------------------------------------
---PARTEA A III-A---

--a)
select * 
from angajati;

select * 
from clienti_fideli;

select * 
from comenzi;

select * 
from detalii_comenzi;

select * 
from detalii_promotii;

select * 
from furnizori;

select * 
from ingrediente;

select * 
from produse
order by pret;

select * 
from programe_fidelitate;

select * 
from promotii;

select * 
from retete;


--b)


--c)
--1.

select id_comanda, data_comanda, id_client, nume, prenume, procent_reducere
from comenzi com
join clienti_fideli cf on com.id_client_fidel = cf.id_client
join programe_fidelitate pf on cf.id_program = pf.id_prog_fid
where procent_reducere > 5
  and data_comanda < to_date('01-12-2020 00:00:00', 'dd-mm-yyyy hh24:mi:ss');

--2.
select distinct p.id_produs, nume_produs, pret, nume_furnizor
from produse p
join retete r on r.id_produs = p.id_produs
join ingrediente i on i.id_ingredient = r.id_ingredient
join furnizori f on f.id_furnizor = i.id_furnizor
where f.oras is not null
  and p.pret >= 15
order by id_produs;

--d)
--1.
select nume_produs, count(r.id_ingredient) "NR_INGREDIENTE"
from produse p
join retete r on r.id_produs = p.id_produs
join ingrediente i on i.id_ingredient = r.id_ingredient
join furnizori f on f.id_furnizor = i.id_furnizor
where f.tara is not null
having count(r.id_ingredient) = (select count(id_ingredient)
                                  from produse
                                  join retete using(id_produs )
                                  join ingrediente using(id_ingredient)
                                  where nume_produs = p.nume_produs
                                  group by nume_produs )
group by nume_produs;

select r.id_produs, nume_produs, count(r.id_ingredient) NR_INGREDIENTE
from produse p
join retete r on r.id_produs = p.id_produs
join ingrediente i on i.id_ingredient = r.id_ingredient
join furnizori f on f.id_furnizor = i.id_furnizor
where f.tara is not null
having count(r.id_ingredient) = (select count(id_ingredient)
                                  from produse
                                  join retete using(id_produs )
                                  join ingrediente using(id_ingredient)
                                  where nume_produs = p.nume_produs
                                  group by nume_produs )
group by r.id_produs, nume_produs
order by r.id_produs;

delete from programe_fidelitate where id_prog_fid = 2;
rollback;


--f)
--1.
create or replace view comenzi_nr_bucati as
select com.id_comanda, data_comanda, sum(dc.nr_bucati) TOTAL_BUCATI
from detalii_comenzi dc
join comenzi com on com.id_comanda = dc.id_comanda
group by com.id_comanda, data_comanda
order by id_comanda;

--2.
/*
select round(avg(salariu),2)
from angajati

select round(avg(salariu),2)
from angajati
where lower(tip_job) != 'administratie'
*/

create or replace view salariu_mediu_job as 
select tip_job, count(id_angajat) as NUMAR_ANGAJATI, round(avg(salariu),2) as SALARIU_MEDIU
from angajati
group by tip_job;


--3.
create or replace view comenzi_detaliate as
    with info_comenzi as (
    select distinct com.id_comanda, com.data_comanda, dc.id_det_com, prod.pret, dc.nr_bucati, com.id_client_fidel, cf.id_program, pf.procent_reducere
    from programe_fidelitate pf 
     right join clienti_fideli cf on cf.id_program = pf.id_prog_fid
     right join comenzi com on com.id_client_fidel = cf.id_client
     right join detalii_comenzi dc on dc.id_comanda = com.id_comanda
     left join produse prod on prod.id_produs = dc.id_produs
     left join detalii_promotii dp on dp.id_produs = prod.id_produs
     left join promotii prom on prom.id_promotie = dp.id_promotie
    order by com.id_comanda),
    
     promotii_valabile as (
      select com.id_comanda, com.data_comanda, prom.data_incepere, prom.data_terminare, prom.valoare, prom. procent
      from comenzi com
      right join detalii_comenzi dc on dc.id_comanda = com.id_comanda
      left join produse prod on prod.id_produs = dc.id_produs
      left join detalii_promotii dp on dp.id_produs = prod.id_produs
      left join promotii prom on prom.id_promotie = dp.id_promotie
      where com.data_comanda between prom.data_incepere AND prom.data_terminare)
    
    select info.id_comanda, info.data_comanda, info.id_det_com, info.pret, info.nr_bucati, info.id_client_fidel, info.id_program, info.procent_reducere, pv.valoare as valoare_promo, pv.procent as procent_promo, sum ( info.nr_bucati * (info.pret )) suma_partiala
    from info_comenzi info
    left join promotii_valabile pv on pv.id_comanda = info.id_comanda
    group by info.id_comanda, info.id_det_com, info.pret, info.nr_bucati, info.id_client_fidel, info.id_program, info.procent_reducere, info.data_comanda, pv.valoare, pv.procent
    order by id_comanda;
----

select id_comanda, sum( nvl(100-procent_reducere, 100)/100*(suma_partiala-nvl(procent_promo/100*pret, 0)-nvl(valoare_promo, 0)) ) as valoare_comanda
from comenzi_detaliate
group by id_comanda
order by id_comanda

--4
create or replace view clienti_program_fidelitate as
select * 
from clienti_fideli
left join programe_fidelitate on id_program = id_prog_fid
order by id_client;

insert into clienti_program_fidelitate (id_client, id_program, nume, prenume, email, telefon, data_aderare)
values (500, 1, 'Dan', 'Mihai', '', 123456, sysdate);
commit;

delete from clienti_program_fidelitate
where id_client <= 5
commit;

update clienti_program_fidelitate
set email = 'email@email.email'
where id_client = 10
commit;


--5
create or replace view comenzi_angajati as
select c.id_comanda, c.nr_bon, c.data_comanda, c.id_angajat, c.tip_plata, a.nume as nume_angajat, a.prenume as prenume_angajat, a.tip_job 
from comenzi c
left join angajati a on c.id_angajat = a.id_angajat
order by c.id_comanda;

insert into comenzi_angajati (id_comanda, nr_bon, data_comanda,  id_angajat, tip_plata)
values (50, 50, sysdate, 5, 'card');
commit;

delete from comenzi_angajati
where data_comanda > to_date('01-01-2021 00:00:00', 'dd-mm-yyyy hh24:mi:ss');
commit;

update comenzi_angajati
set id_angajat = 7
where id_angajat = 10;
commit;