<?php
session_start();
if (!isset($_SESSION['id_usuario'])) {
    header("Location: index.php");
    exit();
}

require_once "config/conexion.php";

// Encabezados HTTP para forzar la descarga del CSV con codificación UTF-8
header('Content-Type: text/csv; charset=utf-8');
header('Content-Disposition: attachment; filename=Reporte_Existencias_Inventario_' . date('Y-m-d_H-i') . '.csv');

// Abrir la salida estándar de PHP
$output = fopen('php://output', 'w');

// Insertar BOM de UTF-8 para que Excel reconozca los acentos y eñes correctamente
fprintf($output, chr(0xEF).chr(0xBB).chr(0xBF));

// Encabezados de columnas para el archivo CSV
fputcsv($output, [
    'ID Producto',
    'Nombre del Insumo',
    'Tipo de Rubro',
    'Categoría',
    'Existencia Base',
    'Unidad de Medida',
    'Empaque / Presentación',
    'Contenido por Empaque',
    'Stock Mínimo',
    'Stock Máximo',
    'Estatus del Stock'
]);

// Consulta completa del inventario ordenada por tipo de rubro y categoría
$sql = "SELECT id_producto, nombre_insumo, tipo_rubro, categoria, cantidad, unidad_medida, 
               unidad_empaque, contenido_por_empaque, stock_minimo, stock_maximo, estado
        FROM inventario 
        ORDER BY tipo_rubro DESC, categoria ASC, nombre_insumo ASC";

$res = $conexion->query($sql);

if ($res && $res->num_rows > 0) {
    while ($row = $res->fetch_assoc()) {
        fputcsv($output, [
            $row['id_producto'],
            $row['nombre_insumo'],
            !empty($row['tipo_rubro']) ? $row['tipo_rubro'] : 'Comestible',
            $row['categoria'],
            number_format($row['cantidad'], 2, '.', ''),
            $row['unidad_medida'],
            !empty($row['unidad_empaque']) ? $row['unidad_empaque'] : 'Saco',
            number_format($row['contenido_por_empaque'] ?? 1, 2, '.', ''),
            number_format($row['stock_minimo'], 2, '.', ''),
            number_format($row['stock_maximo'] ?? 0, 2, '.', ''),
            $row['estado']
        ]);
    }
}

fclose($output);
exit();
?>