<?php
$c = oci_connect("system", "database2020", "localhost/XE");

if (!$c) {
    $m = oci_error();
trigger_error('Could not connect to database: '. $m['message'], E_USER_ERROR); }

$s = oci_parse($c, "select distinct p.id_produs, nume_produs, pret, nume_furnizor
from produse p
join retete r on r.id_produs = p.id_produs
join ingrediente i on i.id_ingredient = r.id_ingredient
join furnizori f on f.id_furnizor = i.id_furnizor
where f.oras is not null
  and p.pret >= 15
order by id_produs");

echo <<<EOD
	<h1> Afisarea rezultatului unei cereri care extrage informatii din cel puțin 3 tabele si le filtreaza cu ajutorul a cel putin 2 conditii. </h1>
	<h2> Cerinta:  Afisati id-ul, numele si pretul produselor care au pretul mai mare sau egal cu 15 lei si care contin cel putin un ingredient provenit de la un furnizor roman. Afisati si numele furnizorului.</h2>
	<p>  Cererea SQL scrisa este: </p>
	<p> select distinct p.id_produs, nume_produs, pret, nume_furnizor </p> 
    <p> from produse p </p> 
    <p> join retete r on r.id_produs = p.id_produs </p> 
	<p> join ingrediente i on i.id_ingredient = r.id_ingredient </p> 
    <p> join furnizori f on f.id_furnizor = i.id_furnizor </p>
	<p> where f.oras is not null </p>
	<p>   and p.pret >= 15 </p>
	<p> order by id_produs; </p>
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