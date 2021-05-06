<?php
$c = oci_connect("system", "database2020", "localhost/XE");

if (!$c) {
    $m = oci_error();
trigger_error('Could not connect to database: '. $m['message'], E_USER_ERROR); }

$v = oci_parse($c, "create or replace view comenzi_angajati as
select c.id_comanda, c.nr_bon, c.data_comanda, c.id_angajat, c.tip_plata, a.nume as nume_angajat, a.prenume as prenume_angajat, a.tip_job 
from comenzi c
left join angajati a on c.id_angajat = a.id_angajat
order by c.id_comanda");



echo <<<EOD
	<h1>  Utilizarea vizualizarilor (cel putin 2 vizualizari: compusa care sa permita operatii LMD, respectiv complexa). </h1>
	<h2> Vizualizarea COMENZI_ANGAJATI contine: id-ul si data comenzii, numarul bonului, id-ul angajatului si tipul de plata asociate fiecarei comenzi, precum si informatii despre angajatul care a preluat comanda - nume, prenume si tipul jobului. </h2>
	<p>  Cererea SQL scrisa pentru crearea vizualizarii este: </p>
	<p> create or replace view comenzi_angajati as  </p> 
	<p> select c.id_comanda, c.nr_bon, c.data_comanda, c.id_angajat, c.tip_plata, a.nume as nume_angajat, a.prenume as prenume_angajat, a.tip_job  </p> 
    <p> from comenzi c </p> 
    <p> left join angajati a on c.id_angajat = a.id_angajat </p> 
	<p> order by c.id_comandat; </p>

	<br>
	<h4> Aceasta vizualizare este una compusa, asadar se pot realiza operatii LMD asupra sa. </h4>
	<p> Un exemplu de INSERARE de date folosind aceasta vizualizare este: </p>
	<p> insert into comenzi_angajati (id_comanda, nr_bon, data_comanda,  id_angajat, tip_plata)  </p> 
	<p> values (50, 50, sysdate, 5, 'card');  </p> 
	<p> commit;  </p><br>
	
    <p> Un exemplu de STERGERE de date folosind aceasta vizualizare este: </p>
	<p> delete from comenzi_angajati  </p> 
	<p> where data_comanda > to_date('01-01-2021 00:00:00', 'dd-mm-yyyy hh24:mi:ss');  </p> 
	<p> commit;  </p> <br>
	<br>
	
	<p> Un exemplu de MODIFICARE de date folosind aceasta vizualizare este: </p>
	<p> update comenzi_angajati  </p> 
	<p> set id_angajat = 7  </p> 
	<p> where id_angajat = 10;  </p> 
	<p> commit;  </p><br>
	<br>
	<p> Aceste operatii au fost facute si testate in SQL Developer. </p <br>
	<h4> Vizualizarea construita este: </h4>
EOD;


oci_execute($v);

$s = oci_parse($c, "select * from comenzi_angajati order by id_comanda");
oci_execute($s);


echo "<table border='1'>\n";
$ncols = oci_num_fields($s);
echo "<tr>\n";
for ($i = 1; $i <= $ncols; ++$i) {
    $colname = oci_field_name($s, $i);
    echo "  <th><b>".htmlspecialchars($colname,ENT_QUOTES|ENT_SUBSTITUTE)."</b></th>\n";
}
echo "</tr>\n";
 
while (($row = oci_fetch_array($s, OCI_ASSOC+OCI_RETURN_NULLS)) != false) {
    echo "<tr>\n";
    foreach ($row as $item) {
        echo "<td>";
        echo $item!==null?htmlspecialchars($item, ENT_QUOTES|ENT_SUBSTITUTE):"&nbsp;";
        echo "</td>\n";
    }
    echo "</tr>\n";
}
echo "</table>\n";

print "</table>";

echo <<<EOD
	<br> <br>
	<p> Mai departe doriti: </p>
	<a href="meniu.php"> Revenire la meniul principal </a>  <br>
    <a href="f)meniu.php"> Revenire la meniul subpunctului f) </a>  <br>

EOD;

?>