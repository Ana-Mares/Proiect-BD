<?php
$c = oci_connect("system", "database2020", "localhost/XE");

if (!$c) {
    $m = oci_error();
trigger_error('Could not connect to database: '. $m['message'], E_USER_ERROR); }

$x = oci_parse($c, "ALTER SESSION SET NLS_DATE_FORMAT='DD-MM-YYYY HH24:MI:SS'");
oci_execute($x);

$v = oci_parse($c, "create or replace view comenzi_detaliate as
    with info_comenzi as (
    select distinct com.id_comanda, com.data_comanda, dc.id_det_com, prod.pret, dc.nr_bucati, com.id_client_fidel, cf.id_program, pf.procent_reducere
    from programe_fidelitate pf 
     right join clienti_fideli cf on cf.id_program = pf.id_prog_fid
     right join comenzi com on com.id_client_fidel = cf.id_client
     right join detalii_comenzi dc on dc.id_comanda = com.id_comanda
     left join produse prod on prod.id_produs = dc.id_produs
     left join detalii_promotii dp on dp.id_produs = prod.id_produs
     left join promotii prom on prom.id_promotie = dp.id_promotie
    order by com.id_comanda),
    
     promotii_valabile as (
      select com.id_comanda, com.data_comanda, prom.data_incepere, prom.data_terminare, prom.valoare, prom. procent
      from comenzi com
      right join detalii_comenzi dc on dc.id_comanda = com.id_comanda
      left join produse prod on prod.id_produs = dc.id_produs
      left join detalii_promotii dp on dp.id_produs = prod.id_produs
      left join promotii prom on prom.id_promotie = dp.id_promotie
      where com.data_comanda between prom.data_incepere AND prom.data_terminare)
    
    select info.id_comanda, info.data_comanda, info.id_det_com, info.pret, info.nr_bucati, info.id_client_fidel, info.id_program, info.procent_reducere, pv.valoare as valoare_promo, pv.procent as procent_promo, sum ( info.nr_bucati * (info.pret )) suma_partiala
    from info_comenzi info
    left join promotii_valabile pv on pv.id_comanda = info.id_comanda
    group by info.id_comanda, info.id_det_com, info.pret, info.nr_bucati, info.id_client_fidel, info.id_program, info.procent_reducere, info.data_comanda, pv.valoare, pv.procent
    order by id_comanda");

$s = oci_parse($c, "select * from comenzi_detaliate order by id_comanda");


$s2 = oci_parse($c, "select id_comanda, sum( nvl(100-procent_reducere, 100)/100*(suma_partiala-nvl(procent_promo/100*pret, 0)-nvl(valoare_promo, 0)) ) as valoare_comanda
from comenzi_detaliate
group by id_comanda
order by id_comanda");


echo <<<EOD
	<h1>  Utilizarea vizualizarilor (cel putin 2 vizualizari: compusa care sa permita operatii LMD, respectiv complexa). </h1>
	<h2> Vizualizarea COMENZI_DETALIATE contine diverse informatii legate de comenzi, dintre care: id-ul, data, numarul de bucati din fiecare produs, pretul produselor, informatii despre clientii fideli, programele de fidelitate si promotiile existente, precum si valoarea platita pentru fiecare produs dintr-o comanda (nr_bucati*pret), ordonate crescator in functie de ID_COMANDA. </h2>
	<h3> Aceasta vizualizare este folosita pentru a calcula valoarea finala a ficarei comenzi in parte. </h3> 
	<br>
	<p> Cererea SQL scrisa pentru crearea vizualizarii este: </p>
	<p> create or replace view comenzi_detaliate as  </p> 
	<p> with info_comenzi as ( </p> 
    <p> select distinct com.id_comanda, com.data_comanda, dc.id_det_com, prod.pret, dc.nr_bucati, com.id_client_fidel, cf.id_program, pf.procent_reducere </p> 
    <p> from programe_fidelitate pf  </p> 
	<p> right join clienti_fideli cf on cf.id_program = pf.id_prog_fid </p>
	<p> right join comenzi com on com.id_client_fidel = cf.id_client </p> 
	<p> right join detalii_comenzi dc on dc.id_comanda = com.id_comanda </p> 
    <p> left join produse prod on prod.id_produs = dc.id_produs </p> 
    <p> left join detalii_promotii dp on dp.id_produs = prod.id_produs </p> 
	<p> left join promotii prom on prom.id_promotie = dp.id_promotie </p>
	<p> order by com.id_comanda),  </p> 
	<br>
    <p> promotii_valabile as ( </p> 
    <p> select com.id_comanda, com.data_comanda, prom.data_incepere, prom.data_terminare, prom.valoare, prom. procent </p> 
	<p> from comenzi com </p>
	<p> right join detalii_comenzi dc on dc.id_comanda = com.id_comanda </p> 
	<p> left join produse prod on prod.id_produs = dc.id_produs </p> 
    <p> left join detalii_promotii dp on dp.id_produs = prod.id_produs </p> 
    <p> left join promotii prom on prom.id_promotie = dp.id_promotie </p> 
	<p> where com.data_comanda between prom.data_incepere AND prom.data_terminare) </p>
	<br> 
	<p> select info.id_comanda, info.data_comanda, info.id_det_com, info.pret, info.nr_bucati, info.id_client_fidel, info.id_program, info.procent_reducere, pv.valoare as valoare_promo, pv.procent as procent_promo, sum ( info.nr_bucati * (info.pret )) suma_partiala </p> 
    <p> from info_comenzi info </p> 
    <p> left join promotii_valabile pv on pv.id_comanda = info.id_comanda </p> 
	<p> group by info.id_comanda, info.id_det_com, info.pret, info.nr_bucati, info.id_client_fidel, info.id_program, info.procent_reducere, info.data_comanda, pv.valoare, pv.procent </p>
	<p> order by id_comanda;  </p> 
	<br> <br> 
    <p> Cererea SQL scrisa pentru determinarea valorii fiecarei comenzi in parte este:  </p> 
    <p> select id_comanda, sum( nvl(100-procent_reducere, 100)/100*(suma_partiala-nvl(procent_promo/100*pret, 0)-nvl(valoare_promo, 0)) ) as valoare_comanda </p> 
	<p> from comenzi_detaliate </p>
	<p> group by id_comanda  </p> 
	<p> order by id_comanda </p> 

	<br>
	<h4> Aceasta vizualizare este una complexa, asadar nu se pot realiza operatii LMD asupra sa. </h4>
	<br>
	<p> Vizualizarea construita este: </p>
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



echo "</br></br>";
echo "<p> In urma cererii detaliate mai sus s-a obtinut, pentru fiecare comanda, valoarea finala a acesteia: : </p>";
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
    <a href="f)meniu.php"> Revenire la meniul subpunctului f) </a>  <br>

EOD;

?>