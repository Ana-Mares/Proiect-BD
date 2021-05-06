<?php
$c = oci_connect("system", "database2020", "localhost/XE");

if (!$c) {
    $m = oci_error();
trigger_error('Could not connect to database: '. $m['message'], E_USER_ERROR); }

$s = oci_parse($c, "select * from clienti_fideli order by id_client");

oci_execute($s);


echo <<<EOD
	<title> Meniu subpunctul a) clienti_fideli</title>
  </head>
  <body>
  <h2> MENIU SUBPUNCTUL a), TABELUL CLIENTI_FIDELI</h2>
  
	<p> Sorteaza (crescator si descrescator, pe aceeasi pagina) dupa: </p>
	<a href="a)clienti_fideli.php"> id_client (pagina actuala) </a>  <br>
    <a href="a)clienti_fideliid_program.php"> id_program </a>  <br>
    <a href="a)clienti_fidelinume.php"> nume </a>  <br>
    <a href="a)clienti_fideliprenume.php"> prenume </a>  <br>
    <a href="a)clienti_fideliemail.php"> email </a>  <br>
    <a href="a)clienti_fidelitelefon.php"> telefon </a>  <br>
    <a href="a)clienti_fidelidata_aderare.php"> data_aderare </a>  <br>

	<br>
	<a href="meniu.php"> Revenire la meniul principal </a>  <br>
	<a href="a)meniu.php"> Revenire la meniul subpunctului a) </a>  <br>	<br> <br> <br>
	<h3> Tabelul CLIENTI_FIDELI sortat crescator, dupa ID_CLIENT: </h3>
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


$s = oci_parse($c, "select *from CLIENTI_FIDELI order by ID_CLIENT desc");
oci_execute($s);


echo "<h3> <br> Tabelul CLIENTI_FIDELI sortat descrescator, dupa ID_CLIENT: </h3>";
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