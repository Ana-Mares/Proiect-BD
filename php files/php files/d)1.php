<?php
$c = oci_connect("system", "database2020", "localhost/XE");

if (!$c) {
    $m = oci_error();
trigger_error('Could not connect to database: '. $m['message'], E_USER_ERROR); }

$s = oci_parse($c, "select r.id_produs, nume_produs, count(r.id_ingredient) NR_INGREDIENTE
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
order by r.id_produs");

echo <<<EOD
	<h1> Afisarea rezultatului unei cereri care foloseste funcții grup și o clauza having </h1>
	<h2> Cerinta: Afisati id-ul, numele si numarul ingredientelor pentru produsele care au in componenta lor doar ingrediente provenite de la furnizori straini.</h2>
	<p>  Cererea SQL scrisa este: </p>
	<p> select r.id_produs, nume_produs, count(r.id_ingredient) NR_INGREDIENTE </p>
    <p> from produse p </p> 
    <p> join retete r on r.id_produs = p.id_produs </p> 
	<p> join ingrediente i on i.id_ingredient = r.id_ingredient </p> 
    <p> join furnizori f on f.id_furnizor = i.id_furnizor </p>
	<p> where f.tara is not null </p>
	<p> having count(r.id_ingredient) =  </p>
	<p>( select count(id_ingredient) </p>
	<p> from produse </p>
	<p> join retete using(id_produs ) </p>
	<p> join ingrediente using(id_ingredient) </p>
	<p> where nume_produs = p.nume_produs </p>
	<p> group by nume_produs ) </p>
	<p> group by r.id_produs, nume_produs </p>
	<p> order by r.id_produs; </p>

	
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
    <a href="d)meniu.php"> Revenire la meniul subpunctului d) </a>  <br>


EOD;

?>