<?php
$c = oci_connect("system", "database2020", "localhost/XE");

if (!$c) {
    $m = oci_error();
trigger_error('Could not connect to database: '. $m['message'], E_USER_ERROR); }


$d = oci_parse($c, "delete from programe_fidelitate where id_prog_fid = 2");
$s1 = oci_parse ($c, "select * from programe_fidelitate order by id_prog_fid");
$s2 = oci_parse ($c, "select * from clienti_fideli order by id_client");

echo <<<EOD
	<h1> Implementarea unei constrangeri de tipul on delete cascade si exemplificare din interfata. </h1>
	<h4> Descriere: se va sterge din tabelul PROGRAME_FIDELITATE inregistrarea cu atributul ID_PROG_FID egal cu 2. In urma stergerii, toti clientii fideli care apartineau programului cu id-ul 2 vor avea atributul ID_PROGRAM setat la NULL (on delete set null) </h4>
	<h4> Vor aparea modificari numai asupra acestor doua tabele, intrucat nu se sterg inregistrari din tabelul CLIENTI_FIDELI. </h4> 
	<p>  Cererea SQL scrisa este: </p>
	<p> delete from programe_fidelitate where id_prog_fid = 2 </p> <br>
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


oci_execute($d);

echo <<<EOD
	<br> <br>
	<h2> A fost efectuata stergerea. </h2> 
	<p>  Dupa stergere, cele doua tabele sunt, dupa cum urmeaza: </p>
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



echo <<<EOD
	<br> <br>
	<p> Mai departe doriti: </p>
	<a href="meniu.php"> Revenire la meniul principal </a>  <br>
    <a href="e)meniu.php"> Revenire la meniul subpunctului e) </a>  <br>


EOD;

?>