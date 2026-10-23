<?php
session_start();
if (!isset($_SESSION['id_usuario'])) {
    header("Location: index.php");
    exit();
}

require_once "config/conexion.php";

// Encabezados HTTP para forzar la descarga en formato CSV/Excel con BOM UTF-8
header('Content-Type: text/csv; charset=utf-8');
header('Content-Disposition: attachment; filename=Reporte_Salidas_eCatering_' . date('Y-m-d_H-i') . '.csv');

// Abrir salida de datos
$output = fopen('php://output', 'w');

// Insertar BOM de UTF-8 para que Excel abra los acentos correctamente
fprintf($output, chr(0xEF).chr(0xBB).chr(0xBF));

// Encabezados de las columnas del archivo Excel
fputcsv($output, [
    'ID Salida', 
    'Fecha / Hora', 
    'Nombre del Insumo', 
    'Cantidad Despachada', 
    'Unidad de Medida', 
    'Embarcación / Destino', 
    'Autorizado / Registrado Por', 
    'Observaciones'
]);

// Consulta a la base de datos
$sql = "SELECT s.id_salida, s.fecha_salida, i.nombre_insumo, s.cantidad_salida, i.unidad_medida, 
               s.ubicacion_destino, u.nombre AS usuario_nombre, s.observaciones
        FROM salidas_insumos s
        INNER JOIN inventario i ON s.id_producto = i.id_producto
        INNER JOIN usuarios u ON s.id_usuario = u.id_usuario
        ORDER BY s.fecha_salida DESC";

$res = $conexion->query($sql);

if ($res && $res->num_rows > 0) {
    while ($row = $res->fetch_assoc()) {
        fputcsv($output, [
            $row['id_salida'],
            date('d/m/Y H:i', strtotime($row['fecha_salida'])),
            $row['nombre_insumo'],
            number_format($row['cantidad_salida'], 2, '.', ''),
            $row['unidad_medida'],
            $row['ubicacion_destino'],
            $row['usuario_nombre'],
            !empty($row['observaciones']) ? $row['observaciones'] : 'Sin observaciones'
        ]);
    }
}

fclose($output);
exit();
?>