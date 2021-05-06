<?php
$c = oci_connect("system", "database2020", "localhost/XE");

if (!$c) {
    $m = oci_error();
trigger_error('Could not connect to database: '. $m['message'], E_USER_ERROR); }


$d = oci_parse($c, "delete from furnizori where id_furnizor = 1 or id_furnizor = 3 or id_furnizor = 5");
$s1 = oci_parse ($c, "select * from furnizori order by id_furnizor");
$s2 = oci_parse ($c, "select * from ingrediente order by id_ingredient");
$s3 = oci_parse ($c, "select * from retete order by id_reteta");

echo <<<EOD
	<h1> Implementarea unei constrangeri de tipul on delete cascade si exemplificare din interfata. </h1>
	<h4> Descriere: se vor sterge din tabelul FURNIZORI inregistrarile cu atributul ID_FURNIZOR egal cu 1, cu 3 si cu 5. In urma stergerii, toate ingredientele care proveneau de la furnizorii stersi vor fi sterse (on delete cascade). </h4>
	<h4> La stergerea inregistrarilor din tabelul INGREDIENTE, toate inregistrarile din tabelul RETETE care contineau id-ul ingredientelor sterse vor avea atributul id_ingredient setat la NULL (on delete set null). </h4>
	<h4> Nu vor aparea modificari in alte tabele (cum ar fi tabelul PRODUSE), intrucat nu se sterg inregistrari din tabelul RETETE. </h4>
	<p>  Cererea SQL scrisa este: </p>
	<p> delete from furnizori where id_furnizor = 1 or id_furnizor = 3 or id_furnizor = 5</p> <br>
	<p> Cele doua tabele, inainte de stergere, sunt, dupa cum urmeaza: </p> 
EOD;

oci_execute($s1);

echo "<table border='1'>\n";
$ncols = oci_num_fields($s1);
echo "<tr>\n";
for ($i = 1; $i <= $ncols; ++$i) {
    $colname = oci_field_name($s1, $i);
    echo "  <th><b>".htmlspecialchars($colname,ENT_QUOTES|ENT_SUBSTITUTE)."</b></th>\n";
}
echo "</tr>\n";
 
while (($row = oci_fetch_array($s1, OCI_ASSOC+OCI_RETURN_NULLS)) != false) {
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

echo "</br></br>";
oci_execute($s2);

echo "<table border='1'>\n";
$ncols = oci_num_fields($s2);
echo "<tr>\n";
for ($i = 1; $i <= $ncols; ++$i) {
    $colname = oci_field_name($s2, $i);
    echo "  <th><b>".htmlspecialchars($colname,ENT_QUOTES|ENT_SUBSTITUTE)."</b></th>\n";
}
echo "</tr>\n";
 
while (($row = oci_fetch_array($s2, OCI_ASSOC+OCI_RETURN_NULLS)) != false) {
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

echo "</br></br>";
oci_execute($s3);

echo "<table border='1'>\n";
$ncols = oci_num_fields($s3);
echo "<tr>\n";
for ($i = 1; $i <= $ncols; ++$i) {
    $colname = oci_field_name($s3, $i);
    echo "  <th><b>".htmlspecialchars($colname,ENT_QUOTES|ENT_SUBSTITUTE)."</b></th>\n";
}
echo "</tr>\n";
 
while (($row = oci_fetch_array($s3, OCI_ASSOC+OCI_RETURN_NULLS)) != false) {
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


oci_execute($d);

echo <<<EOD
	<br> <br>
	<h2> A fost efectuata stergerea. </h2> 
	<p>  Dupa stergere, cele doua tabele sunt, dupa cum urmeaza:: </p>
	<br> <br>
EOD;


oci_execute($s1);

echo "<table border='1'>\n";
$ncols = oci_num_fields($s1);
echo "<tr>\n";
for ($i = 1; $i <= $ncols; ++$i) {
    $colname = oci_field_name($s1, $i);
    echo "  <th><b>".htmlspecialchars($colname,ENT_QUOTES|ENT_SUBSTITUTE)."</b></th>\n";
}
echo "</tr>\n";
 
while (($row = oci_fetch_array($s1, OCI_ASSOC+OCI_RETURN_NULLS)) != false) {
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

echo "</br></br>";
oci_execute($s2);

echo "<table border='1'>\n";
$ncols = oci_num_fields($s2);
echo "<tr>\n";
for ($i = 1; $i <= $ncols; ++$i) {
    $colname = oci_field_name($s2, $i);
    echo "  <th><b>".htmlspecialchars($colname,ENT_QUOTES|ENT_SUBSTITUTE)."</b></th>\n";
}
echo "</tr>\n";
 
while (($row = oci_fetch_array($s2, OCI_ASSOC+OCI_RETURN_NULLS)) != false) {
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

echo "</br></br>";
oci_execute($s3);

echo "<table border='1'>\n";
$ncols = oci_num_fields($s3);
echo "<tr>\n";
for ($i = 1; $i <= $ncols; ++$i) {
    $colname = oci_field_name($s3, $i);
    echo "  <th><b>".htmlspecialchars($colname,ENT_QUOTES|ENT_SUBSTITUTE)."</b></th>\n";
}
echo "</tr>\n";
 
while (($row = oci_fetch_array($s3, OCI_ASSOC+OCI_RETURN_NULLS)) != false) {
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
    <a href="e)meniu.php"> Revenire la meniul subpunctului e) </a>  <br>


EOD;

?>