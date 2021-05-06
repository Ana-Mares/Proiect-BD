<?php
$c = oci_connect("system", "database2020", "localhost/XE");

if (!$c) {
    $m = oci_error();
trigger_error('Could not connect to database: '. $m['message'], E_USER_ERROR); }

$s = oci_parse($c, "select * from programe_fidelitate order by id_prog_fid");

oci_execute($s);

echo <<<EOD
	<title> Meniu subpunctul a) programe_fidelitate</title>
  </head>
  <body>
  <h2> MENIU SUBPUNCTUL a), TABELUL PROGRAME_FIDELITATE</h2>
  
	<p> Sorteaza (crescator si descrescator, pe aceeasi pagina) dupa: </p>
	<a href="a)programe_fidelitate.php"> id_prog_fid (pagina actuala)</a>  <br>
    <a href="a)programe_fidelitateprocent_reducere.php"> procent_reducere </a>  <br>
    <a href="a)programe_fidelitatecost_anual.php"> cost_anual </a>  <br>

	<br>
	<a href="meniu.php"> Revenire la meniul principal </a>  <br> <br> <br>
	<a href="a)meniu.php"> Revenire la meniul subpunctului a) </a>  <br>
	<h3> Tabelul PROGRAME_FIDELITATE sortat crescator, dupa ID_PROG_FID	: </h3>
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

$s = oci_parse($c, "select *from programe_fidelitate order by ID_PROG_FID desc");
oci_execute($s);


echo "<h3> <br> Tabelul PROGRAME_FIDELITATE sortat descrescator, dupa ID_PROG_FID: </h3>";
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