<?php
$c = oci_connect("system", "database2020", "localhost/XE");

if (!$c) {
    $m = oci_error();
trigger_error('Could not connect to database: '. $m['message'], E_USER_ERROR); }

$v = oci_parse($c, "create or replace view clienti_program_fidelitate as
select * 
from clienti_fideli
left join programe_fidelitate on id_program = id_prog_fid
order by id_client");

$s = oci_parse($c, "select * from clienti_program_fidelitate order by id_client");


echo <<<EOD
	<h1>  Utilizarea vizualizarilor (cel putin 2 vizualizari: compusa care sa permita operatii LMD, respectiv complexa). </h1>
	<h2> Vizualizarea CLIENTI_PROGRAM_FIDELITATE contine toate atributele celor doua entitati, facand un centralizator al datelor caracteristice clientilor, precumsi programelor de fidelitate la caze acestia participa. </h2>
	<p>  Cererea SQL scrisa pentru crearea vizualizarii este: </p>
	<p> create or replace view clienti_program_fidelitate as  </p> 
	<p> select *  </p> 
    <p> from clienti_fideli </p> 
    <p> left join programe_fidelitate on id_program = id_prog_fid </p> 
	<p> order by id_client; </p>

	<br>
	<h4> Aceasta vizualizare este una compusa, asadar se pot realiza operatii LMD asupra sa. </h4>
	<p> Un exemplu de INSERARE de date folosind aceasta vizualizare este: </p>
	<p> insert into clienti_program_fidelitate (id_client, id_program, nume, prenume, email, telefon, data_aderare)  </p> 
	<p> values (500, 1, 'Dan', 'Mihai', '', 123456, sysdate);  </p> 
	<p> commit;  </p><br>
	
    <p> Un exemplu de STERGERE de date folosind aceasta vizualizare este: </p>
	<p> delete from clienti_program_fidelitate  </p> 
	<p> where id_client <= 5;  </p> 
	<p> commit;  </p> <br>
	<br>
	
	<p> Un exemplu de MODIFICARE de date folosind aceasta vizualizare este: </p>
	<p> update clienti_program_fidelitate  </p> 
	<p> set email = 'email@email.email'  </p> 
	<p> where id_client = 10 ;  </p> 
	<p> commit;  </p><br>
	<br>
	<p> Aceste operatii au fost facute si testate in SQL Developer. </p <br>
	<h4> Vizualizarea construita este: </h4>
EOD;


oci_execute($v);
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
    <a href="f)meniu.php"> Revenire la meniul subpunctului f) </a>  <br>

EOD;

?>