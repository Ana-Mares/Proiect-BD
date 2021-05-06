<?php
$c = oci_connect("system", "database2020", "localhost/XE");

if (!$c) {
    $m = oci_error();
trigger_error('Could not connect to database: '. $m['message'], E_USER_ERROR); }

$x = oci_parse($c, "ALTER SESSION SET NLS_DATE_FORMAT='DD-MM-YYYY HH24:MI:SS'");
oci_execute($x);

$v = oci_parse($c, "create or replace view salariu_mediu_job as 
select tip_job, count(id_angajat) as NUMAR_ANGAJATI, round(avg(salariu),2) as SALARIU_MEDIU
from angajati
group by tip_job
order by tip_job");

$s = oci_parse($c, "select * from salariu_mediu_job order by tip_job");


echo <<<EOD
	<h1>  Utilizarea vizualizarilor (cel putin 2 vizualizari: compusa care sa permita operatii LMD, respectiv complexa). </h1>
	<h2> Vizualizarea SALARIU_MEDIU_JOB contine: tipurile de joburi existente, precum si numar de angajati si salariul mediu (rotunjit la doua zecimale) pentru fiecare tip de job (ordonate crescator in functie de TIP_JOB). </h2>
	<p>  Cererea SQL scrisa pentru crearea vizualizarii este: </p>
	<p> create or replace view salariu_mediu_job as  </p> 
	<p> select tip_job, count(id_angajat) as NUMAR_ANGAJATI, round(avg(salariu),2) as SALARIU_MEDIU </p> 
    <p> from angajati </p> 
    <p> group by tip_job </p> 
	<p> order by tip_job; </p>

	<br>
	<h4> Aceasta vizualizare este una complexa, asadar nu se pot realiza operatii LMD asupra sa. </h4>
	<br>
	<p> Vizualizarea construita este: </p>
EOD;

oci_execute($v);
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