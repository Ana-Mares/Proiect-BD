<?php
$c = oci_connect("system", "database2020", "localhost/XE");

if (!$c) {
    $m = oci_error();
trigger_error('Could not connect to database: '. $m['message'], E_USER_ERROR); }

$x = oci_parse($c, "ALTER SESSION SET NLS_DATE_FORMAT='DD-MM-YYYY HH24:MI:SS'");
oci_execute($x);

$s = oci_parse($c, "select * from PROMOTII order by ID_PROMOTIE");

oci_execute($s);

echo <<<EOD
	<title> Meniu subpunctul a) promotii</title>
  </head>
  <body>
  <h2> MENIU SUBPUNCTUL a), TABELUL PROMOTII</h2>
  
	<p> Sorteaza (crescator si descrescator, pe aceeasi pagina) dupa: </p>
	<a href="a)promotii.php"> id_promotie (pagina actuala)</a>  <br>
    <a href="a)promotiidata_incepere.php"> data_incepere </a>  <br>
    <a href="a)promotiidata_terminare.php"> data_terminare </a>  <br>
    <a href="a)promotiitip_promotie.php"> tip_promotie </a>  <br>
    <a href="a)promotiiprocent.php"> procent </a>  <br>
    <a href="a)promotiivaloare.php"> valoare </a>  <br>

	<br>
	<a href="meniu.php"> Revenire la meniul principal </a>  <br> <br> <br>
	<a href="a)meniu.php"> Revenire la meniul subpunctului a) </a>  <br>
	<h3> Tabelul PROMOTII sortat crescator, dupa ID_PROMOTIE: </h3>
	</body>
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



$s = oci_parse($c, "select *from PROMOTII order by ID_PROMOTIE desc");
oci_execute($s);


echo "<h3> <br> Tabelul PROMOTII sortat descrescator, dupa ID_PROMOTIE: </h3>";
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