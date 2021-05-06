<?php

$c = oci_connect("system", "database2020", "localhost/XE");

if (!$c) {
    $m = oci_error();
trigger_error('Could not connect to database: '. $m['message'], E_USER_ERROR); }



echo <<<EOD
  <head>
	<title>Meniu principal</title>
  </head>
  <body>
  <h1> PROIECT LA BAZE DE DATE - MARES ANA-MARIA - CTI, GRUPA 253 </h1>
  <h2> MENIU PRINCIPAL </h2> <br> 
  
  <a href="a)meniu.php">Subpunctul a)</a>  <br>
  <a href="b)meniu.php"> Subpunctul b) </a>  <br>
  <a href="c)meniu.php"> Subpunctul c) </a>  <br>
  <a href="d)meniu.php"> Subpunctul d) </a>  <br>
  <a href="e)meniu.php"> Subpunctul e) </a>  <br>
  <a href="f)meniu.php"> Subpunctul f) </a>  <br>
  </body>
EOD;


?>



