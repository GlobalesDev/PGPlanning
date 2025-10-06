<?php
define("PATH","/PGTime/");
define("SITIO","PGPlanning Fichajes");
define("PCURL","http://localhost/PGTime/JSON/");

function jsonConnToJson($data, $path){
	$ch = curl_init(PCURL.$path);
	$data = json_encode($data );
	curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");
	curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
	//curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0); // esto tiene que estar deshabilitado, es solo para las pruebas de SSL
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
	curl_setopt($ch, CURLOPT_HTTPHEADER, array(
		'Content-Type: application/json',
		'Accept: application/json',
		'Content-Length: ' . strlen($data))
	);
	return curl_exec($ch);
}

function jsonConn($data, $path){
	return json_decode(jsonConnToJson($data, $path));
}