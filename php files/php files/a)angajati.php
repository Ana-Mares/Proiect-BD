<?php
$c = oci_connect("system", "database2020", "localhost/XE");

if (!$c) {
    $m = oci_error();
trigger_error('Could not connect to database: '. $m['message'], E_USER_ERROR); }

$s = oci_parse($c, "select * from angajati order by id_angajat");

oci_execute($s);

echo <<<EOD
	<title> Meniu subpunctul a) angajati</title>
  </head>
  <body>
  <h2> MENIU SUBPUNCTUL a), TABELUL ANGAJATI</h2>
  
	<p> Sorteaza (crescator si descrescator, pe aceeasi pagina) dupa: </p>
	<a href="a)angajati.php"> id_angajat (pagina actuala)</a>  <br>
    <a href="a)angajatinume.php"> nume </a>  <br>
    <a href="a)angajatiprenume.php"> prenume </a>  <br>
    <a href="a)angajatiprenume2.php"> prenume2 </a>  <br>
    <a href="a)angajaticnp.php"> cnp </a>  <br>
    <a href="a)angajatitip_job.php"> tip_job </a>  <br>
    <a href="a)angajatidata_angajare.php"> data_angajare </a>  <br>
	<a href="a)angajatitelefon.php"> telefon </a>  <br>
	<a href="a)angajatiemail.php"> email </a>  <br>
	<a href="a)angajatisalariu.php"> salariu </a>  <br>
	
	<br>
	<a href="meniu.php"> Revenire la meniul principal </a>  <br>
	<a href="a)meniu.php"> Revenire la meniul subpunctului a) </a>  <br>	<br> <br> <br>
	<h3> Tabelul ANGAJATI sortat crescator, dupa ID_ANGAJAT: </h3>
	
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




$s = oci_parse($c, "select *from ANGAJATI order by ID_ANGAJAT desc");
oci_execute($s);


echo "<h3> <br> Tabelul ANGAJATI sortat descrescator, dupa ID_ANGAJAT: </h3>";
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