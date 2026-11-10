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

// ... Tu código actual de conexión a la base de datos ...

// Función Global de Auditoría (Logs del Sistema)
function registrarLog($conexion, $id_usuario, $accion, $descripcion) {
    $accion_clean = $conexion->real_escape_string($accion);
    $desc_clean   = $conexion->real_escape_string($descripcion);
    $id_user_val  = intval($id_usuario);
    
    $sql = "INSERT INTO logs_sistema (id_usuario, accion, descripcion, fecha_hora) 
            VALUES ($id_user_val, '$accion_clean', '$desc_clean', NOW())";
    $conexion->query($sql);
}
?>

