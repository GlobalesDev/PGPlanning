<?php
session_start();
$dbtype		= 'mysql';
$dbhost 	= 'localhost';
$dbname		= 'pgplanning';
$dbuser		= 'pgPlanning';
$dbpass		= 'g10B4lPlanning';

// database connection
$conexion = new PDO("mysql:host=$dbhost;dbname=$dbname;charset=UTF8",$dbuser,$dbpass);
$conexion->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

function conectar($consulta, $bd = null){
	if (!isset($bd)){ $bd=conectbd(); }
	$bd->select_db("pgplanning");
	$result=$bd->query($consulta) or die ("Error en la consulta: ".$consulta);
	return $result;
}

function doQuery($consulta, $bd = null){
	if (!isset($bd)){ $bd=conectbd(); }
	$bd->select_db("pgplanning");
	if ($result=$bd->query($consulta)){
		return false;
	}else{
		return $bd->errno;
	}
}

function conectbd($usr="pgPlanning", $psw="g10B4lPlanning"){
	$conn = new mysqli("localhost",$usr,$psw);
	$conn->set_charset('utf8');
	return $conn;
}