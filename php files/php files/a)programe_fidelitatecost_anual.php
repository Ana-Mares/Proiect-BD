<?php
$c = oci_connect("system", "database2020", "localhost/XE");

if (!$c) {
    $m = oci_error();
trigger_error('Could not connect to database: '. $m['message'], E_USER_ERROR); }

$s = oci_parse($c, "select * from programe_fidelitate order by COST_ANUAL");

oci_execute($s);

echo <<<EOD
	<h2> Sortarea tabelului PROGRAME_FIDELITATE dupa COST_ANUAL </h2>
	<a href="meniu.php"> Revenire la meniul principal </a>  <br>
    <a href="a)meniu.php"> Revenire la meniul subpunctului a) </a>  <br>
    <a href="a)programe_fidelitate.php"> Revenire la afisarea initiala a tabelului PROGRAME_FIDELITATE </a>  <br>
	
	<h3> Tabelul PROGRAME_FIDELITATE sortat crescator, dupa COST_ANUAL	: </h3>

EOD;

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



$s = oci_parse($c, "select *from programe_fidelitate order by COST_ANUAL desc");
oci_execute($s);


echo "<h3> <br> Tabelul PROGRAME_FIDELITATE sortat descrescator, dupa COST_ANUAL: </h3>";
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



?>