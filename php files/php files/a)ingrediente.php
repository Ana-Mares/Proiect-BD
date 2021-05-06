<?php
$c = oci_connect("system", "database2020", "localhost/XE");

if (!$c) {
    $m = oci_error();
trigger_error('Could not connect to database: '. $m['message'], E_USER_ERROR); }

$s = oci_parse($c, "select * from ingrediente order by id_ingredient");

oci_execute($s);


echo <<<EOD
	<title> Meniu subpunctul a) ingrediente</title>
  </head>
  <body>
  <h2> MENIU SUBPUNCTUL a), TABELUL INGREDIENTE</h2>
  
	<p> Sorteaza (crescator si descrescator, pe aceeasi pagina) dupa: </p>
	<a href="a)ingrediente.php"> id_ingredient (pagina actuala)</a>  <br>
    <a href="a)ingredienteid_furnizor.php"> id_furnizor </a>  <br>
    <a href="a)ingredientenume_ingredient.php"> nume_ingredient </a>  <br>
    <a href="a)ingredientepret_unitate.php"> pret_unitate </a>  <br>
	<a href="a)ingredientegramaj_unitate.php"> gramaj_unitate </a>  <br>

	<br>
	<a href="meniu.php"> Revenire la meniul principal </a>  <br>
	<a href="a)meniu.php"> Revenire la meniul subpunctului a) </a>  <br>	<br> <br> <br>
	<h3> Tabelul INGREDIENTE sortat crescator, dupa ID_INGREDIENT: </h3>
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



$s = oci_parse($c, "select *from ingrediente order by id_ingredient desc");
oci_execute($s);


echo "<h3> <br> Tabelul INGREDIENTE sortat descrescator, dupa ID_INGREDIENT: </h3>";
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