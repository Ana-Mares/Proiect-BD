<?php
$c = oci_connect("system", "database2020", "localhost/XE");

if (!$c) {
    $m = oci_error();
trigger_error('Could not connect to database: '. $m['message'], E_USER_ERROR); }

$x = oci_parse($c, "ALTER SESSION SET NLS_DATE_FORMAT='DD-MM-YYYY HH24:MI:SS'");
oci_execute($x);

$v = oci_parse($c, "create or replace view comenzi_nr_bucati as
select com.id_comanda, data_comanda, sum(dc.nr_bucati) TOTAL_BUCATI
from detalii_comenzi dc
join comenzi com on com.id_comanda = dc.id_comanda
group by com.id_comanda, data_comanda
order by id_comanda");

$s = oci_parse($c, "select * from comenzi_nr_bucati order by id_comanda");


echo <<<EOD
	<h1>  Utilizarea vizualizarilor (cel putin 2 vizualizari: compusa care sa permita operatii LMD, respectiv complexa). </h1>
	<h2> Vizualizarea COMENZI_NR_BUCATI contine: id-ul si data fiecarei comenzi, precum si numarul de produse (bucati) comandate, in total, pentru fiecare comanda (ordonate crescator, in functie de ID_COMANDA). </h2>
	<p>  Cererea SQL scrisa pentru crearea vizualizarii este: </p>
	<p> create or replace view comenzi_nr_bucati as </p> 
	<p> select com.id_comanda, data_comanda, sum(dc.nr_bucati) TOTAL_BUCATI </p> 
    <p> from detalii_comenzi dc </p> 
    <p> join comenzi com on com.id_comanda = dc.id_comanda </p> 
	<p> group by com.id_comanda, data_comanda > 5 </p> 
    <p> order by id_comanda; </p>
	<br>
	<h3> Aceasta vizualizare este una complexa, asadar nu se pot realiza operatii LMD asupra sa. </h3>
	<h3> Aceasta vizualizare este una complexa, asadar nu se pot realiza operatii LMD asupra sa. </h3>
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