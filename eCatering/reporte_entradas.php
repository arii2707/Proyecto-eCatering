<?php
session_start();
if (!isset($_SESSION['id_usuario'])) {
    header("Location: index.php");
    exit();
}

require_once "config/conexion.php";

header("Content-Type: application/vnd.ms-excel; charset=UTF-8");
header("Content-Disposition: attachment; filename=Reporte_Entradas_Insumos_" . date('Y-m-d_H-i') . ".xls");
header("Pragma: no-cache");
header("Expires: 0");

echo "\xEF\xBB\xBF";
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <style>
        table { border-collapse: collapse; width: 100%; font-family: Arial, sans-serif; }
        th { background-color: #198754; color: #ffffff; font-weight: bold; border: 1px solid #000000; padding: 8px; text-align: center; }
        td { border: 1px solid #cccccc; padding: 6px; text-align: left; }
        .text-center { text-align: center; }
        .text-success { color: #198754; font-weight: bold; }
        .header-title { font-size: 14pt; font-weight: bold; color: #198754; text-align: center; }
        .sub-title { font-size: 10pt; color: #555555; text-align: center; }
    </style>
</head>
<body>
    <table>
        <tr>
            <td colspan="7" class="header-title">MARITIME CONTRACTORS DE VENEZUELA, S.A.</td>
        </tr>
        <tr>
            <td colspan="7" class="sub-title">REPORTE DE ENTRADAS Y REABASTECIMIENTO DE INSUMOS</td>
        </tr>
        <tr>
            <td colspan="7" class="sub-title">Fecha de Emisión: <?php echo date('d/m/Y H:i:s'); ?></td>
        </tr>
        <tr><td colspan="7"></td></tr>
        <thead>
            <tr>
                <th>ID Entrada</th>
                <th>Fecha / Hora</th>
                <th>Insumo / Producto</th>
                <th>Cantidad Recibida</th>
                <th>Proveedor</th>
                <th>N° Factura / Orden</th>
                <th>Usuario Responsable</th>
            </tr>
        </thead>
        <tbody>
        <?php
        $sql = "SELECT e.*, i.nombre_insumo, i.unidad_medida, u.nombre AS usuario_nombre 
                FROM entradas_insumos e 
                INNER JOIN inventario i ON e.id_producto = i.id_producto 
                INNER JOIN usuarios u ON e.id_usuario = u.id_usuario 
                ORDER BY e.fecha_entrada DESC";

        $res = $conexion->query($sql);

        if ($res && $res->num_rows > 0) {
            while ($row = $res->fetch_assoc()) {
                echo "<tr>";
                echo "<td class='text-center'>#" . $row['id_entrada'] . "</td>";
                echo "<td class='text-center'>" . date('d/m/Y H:i', strtotime($row['fecha_entrada'])) . "</td>";
                echo "<td><strong>" . htmlspecialchars($row['nombre_insumo']) . "</strong></td>";
                echo "<td class='text-center text-success'>+" . number_format($row['cantidad'], 2) . " " . htmlspecialchars($row['unidad_medida']) . "</td>";
                echo "<td>" . htmlspecialchars($row['proveedor']) . "</td>";
                echo "<td class='text-center'>" . htmlspecialchars($row['num_factura_orden']) . "</td>";
                echo "<td>" . htmlspecialchars($row['usuario_nombre']) . "</td>";
                echo "</tr>";
            }
        } else {
            echo "<tr><td colspan='7' class='text-center'>No se encontraron registros de entradas.</td></tr>";
        }
        ?>
        </tbody>
    </table>
</body>
</html>