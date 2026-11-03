<?php
session_start();
require_once "config/conexion.php";

// Forzar la descarga como un archivo de Excel real (.xls)
header('Content-Type: application/vnd.ms-excel; charset=utf-8');
header('Content-Disposition: attachment; filename="inventario_ecatering_' . date('Y-m-d') . '.xls"');
header('Pragma: no-cache');
header('Expires: 0');
?>
<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <style>
        table { border-collapse: collapse; width: 100%; font-family: Arial, sans-serif; font-size: 11pt; }
        th { background-color: #198754; color: white; border: 1px solid #ddd; padding: 8px; text-align: center; }
        td { border: 1px solid #ddd; padding: 6px; }
        .text-center { text-align: center; }
        .fw-bold { font-weight: bold; }
    </style>
</head>
<body>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Tipo Rubro</th>
                <th>Nombre del Insumo</th>
                <th>Categoría</th>
                <th>Existencia Base</th>
                <th>Unidad de Medida</th>
                <th>Empaque / Presentación</th>
                <th>Contenido por Empaque</th>
                <th>Stock Mínimo</th>
                <th>Stock Máximo</th>
                <th>Estatus del Stock</th>
            </tr>
        </thead>
        <tbody>
            <?php
            $sql = "SELECT * FROM inventario ORDER BY tipo_rubro DESC, categoria ASC, nombre_insumo ASC";
            $res = $conexion->query($sql);

            if ($res && $res->num_rows > 0) {
                while ($row = $res->fetch_assoc()) {
                    echo "<tr>";
                    echo "<td class='text-center fw-bold'>{$row['id_producto']}</td>";
                    echo "<td>" . ($row['tipo_rubro'] ?? 'Consumible') . "</td>";
                    echo "<td class='fw-bold'>" . htmlspecialchars($row['nombre_insumo']) . "</td>";
                    echo "<td>" . htmlspecialchars($row['categoria']) . "</td>";
                    echo "<td class='text-center'>" . number_format($row['cantidad'], 2) . "</td>";
                    echo "<td class='text-center'>" . htmlspecialchars($row['unidad_medida']) . "</td>";
                    echo "<td class='text-center'>" . htmlspecialchars($row['unidad_empaque'] ?? 'Saco') . "</td>";
                    echo "<td class='text-center'>" . number_format($row['contenido_por_empaque'] ?? 1, 2) . "</td>";
                    echo "<td class='text-center'>" . number_format($row['stock_minimo'], 2) . "</td>";
                    echo "<td class='text-center'>" . number_format($row['stock_maximo'] ?? 0, 2) . "</td>";
                    echo "<td class='text-center'>" . htmlspecialchars($row['estado']) . "</td>";
                    echo "</tr>";
                }
            }
            ?>
        </tbody>
    </table>
</body>
</html>