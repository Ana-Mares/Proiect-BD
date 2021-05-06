<?php
$c = oci_connect("system", "database2020", "localhost/XE");

if (!$c) {
    $m = oci_error();
trigger_error('Could not connect to database: '. $m['message'], E_USER_ERROR); }

$x = oci_parse($c, "ALTER SESSION SET NLS_DATE_FORMAT='DD-MM-YYYY HH24:MI:SS'");
oci_execute($x);

$s = oci_parse($c, "select id_comanda, data_comanda, id_client, nume, prenume, procent_reducere
from comenzi com
join clienti_fideli cf on com.id_client_fidel = cf.id_client
join programe_fidelitate pf on cf.id_program = pf.id_prog_fid
where procent_reducere > 5
  and data_comanda < to_date('01-12-2020 00:00:00', 'dd-mm-yyyy hh24:mi:ss')");

echo <<<EOD
	<h1> Afisarea rezultatului unei cereri care extrage informatii din cel puțin 3 tabele si le filtreaza cu ajutorul a cel putin 2 conditii. </h1>
	<h2> Cerinta:  Afisati id-ul comenzii, data acesteia, id-ul, numele si prenumele clientului fidel si procentul de reducere aplicat, pentru comenzile inregistrate inainte de luna decembrie din 2020 si pentru care procentul de reducere este mai mare decat 5. </h2>
	<p>  Cererea SQL scrisa este: </p>
	<p> select id_comanda, id_client, nume, prenume, procent_reducere </p> 
	<p> from comenzi com </p> 
    <p> join clienti_fideli cf on com.id_client_fidel = cf.id_client </p> 
    <p> join programe_fidelitate pf on cf.id_program = pf.id_prog_fid </p> 
	<p> where procent_reducere > 5 </p> 
    <p> and data_comanda < to_date('01-12-2020 00:00:00', 'dd-mm-yyyy hh24:mi:ss'); </p>
EOD;

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
    <a href="c)meniu.php"> Revenire la meniul subpunctului c) </a>  <br>


EOD;

?>
