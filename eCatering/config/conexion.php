<?php
$host = "localhost";
$usuario = "root";
$password = "";
$database = "ecatering_db";

$conexion = new mysqli($host, $usuario, $password, $database);

if ($conexion->connect_error) {
    die("Error en la conexión a la base de datos: " . $conexion->connect_error);
}

$conexion->set_charset("utf8mb4");
?>