<?php
session_start();
if (!isset($_SESSION['id_usuario'])) {
    header("Location: index.php");
    exit();
}

require_once "config/conexion.php";

// Encabezados HTTP para forzar la descarga en formato CSV/Excel con BOM UTF-8
header('Content-Type: text/csv; charset=utf-8');
header('Content-Disposition: attachment; filename=Reporte_Entradas_eCatering_' . date('Y-m-d_H-i') . '.csv');

// Abrir salida de datos
$output = fopen('php://output', 'w');

// Insertar BOM de UTF-8 para que Excel abra los acentos correctamente
fprintf($output, chr(0xEF).chr(0xBB).chr(0xBF));

// Encabezados de la tabla Excel
fputcsv($output, [
    'ID Entrada', 
    'Fecha / Hora', 
    'Nombre del Insumo', 
    'Cantidad Recibida', 
    'Unidad de Medida', 
    'Proveedor / Contratista', 
    'N° Factura / Orden', 
    'Fecha Vencimiento (PEPS)', 
    'Registrado Por', 
    'Observaciones / Estado del Lote'
]);

// Consulta a la base de datos
$sql = "SELECT e.id_entrada, e.fecha_entrada, i.nombre_insumo, e.cantidad, i.unidad_medida, 
               e.proveedor, e.num_factura_orden, e.fecha_vencimiento, u.nombre AS usuario_nombre, e.observaciones
        FROM entradas_insumos e
        INNER JOIN inventario i ON e.id_producto = i.id_producto
        INNER JOIN usuarios u ON e.id_usuario = u.id_usuario
        ORDER BY e.fecha_entrada DESC";

$res = $conexion->query($sql);

if ($res && $res->num_rows > 0) {
    while ($row = $res->fetch_assoc()) {
        fputcsv($output, [
            $row['id_entrada'],
            date('d/m/Y H:i', strtotime($row['fecha_entrada'])),
            $row['nombre_insumo'],
            number_format($row['cantidad'], 2, '.', ''),
            $row['unidad_medida'],
            $row['proveedor'],
            !empty($row['num_factura_orden']) ? $row['num_factura_orden'] : 'N/A',
            !empty($row['fecha_vencimiento']) ? date('d/m/Y', strtotime($row['fecha_vencimiento'])) : 'Sin Fecha',
            $row['usuario_nombre'],
            !empty($row['observaciones']) ? $row['observaciones'] : 'Sin observaciones'
        ]);
    }
}

fclose($output);
exit();
?>