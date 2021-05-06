<?php
$c = oci_connect("system", "database2020", "localhost/XE");

if (!$c) {
    $m = oci_error();
trigger_error('Could not connect to database: '. $m['message'], E_USER_ERROR); }

$s = oci_parse($c, "select * from retete order by id_reteta");

oci_execute($s);


echo <<<EOD
	<title> Meniu subpunctul a) retete</title>
  </head>
  <body>
  <h2> MENIU SUBPUNCTUL a), TABELUL RETETE</h2>
  
	<p> Sorteaza (crescator si descrescator, pe aceeasi pagina) dupa: </p>
	<a href="a)retete.php"> id_reteta (pagina actuala)</a>  <br>
    <a href="a)reteteid_produs.php"> id_produs </a>  <br>
    <a href="a)reteteid_ingredient.php"> id_ingredient </a>  <br>

	<br>
	<a href="meniu.php"> Revenire la meniul principal </a>  <br>
	<a href="a)meniu.php"> Revenire la meniul subpunctului a) </a>  <br>	<br> <br> <br>
	<h3> Tabelul RETETE sortat crescator, dupa ID_RETETA: </h3>
	</body>
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





$s = oci_parse($c, "select *from RETETE order by ID_RETETA desc");
oci_execute($s);


echo "<h3> <br> Tabelul RETETE sortat descrescator, dupa ID_RETETA: </h3>";
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