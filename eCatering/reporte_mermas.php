<?php
session_start();
if (!isset($_SESSION['id_usuario'])) {
    header("Location: index.php");
    exit();
}

require_once "config/conexion.php";

// Encabezados para forzar la descarga en formato Excel (.xls) con codificación UTF-8
header("Content-Type: application/vnd.ms-excel; charset=UTF-8");
header("Content-Disposition: attachment; filename=Reporte_Control_Mermas_" . date('Y-m-d_H-i') . ".xls");
header("Pragma: no-cache");
header("Expires: 0");

echo "\xEF\xBB\xBF"; // UTF-8 BOM para Excel
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <style>
        table { border-collapse: collapse; width: 100%; font-family: Arial, sans-serif; }
        th { background-color: #1a252f; color: #ffffff; font-weight: bold; border: 1px solid #000000; padding: 8px; text-align: center; }
        td { border: 1px solid #cccccc; padding: 6px; text-align: left; }
        .text-center { text-align: center; }
        .text-danger { color: #dc3545; font-weight: bold; }
        .header-title { font-size: 14pt; font-weight: bold; color: #1a252f; text-align: center; }
        .sub-title { font-size: 10pt; color: #555555; text-align: center; }
    </style>
</head>
<body>
    <table>
        <tr>
            <td colspan="8" class="header-title">MARITIME CONTRACTORS DE VENEZUELA, S.A.</td>
        </tr>
        <tr>
            <td colspan="8" class="sub-title">REPORTE DE CONTROL DIARIO DE MERMAS</td>
        </tr>
        <tr>
            <td colspan="8" class="sub-title">Fecha de Emisión: <?php echo date('d/m/Y H:i:s'); ?></td>
        </tr>
        <tr><td colspan="8"></td></tr>
        <thead>
            <tr>
                <th>ID Merma</th>
                <th>Fecha / Hora</th>
                <th>Insumo / Producto</th>
                <th>Categoría</th>
                <th>Mermas (Unid.)</th>
                <th>Mermas (gr)</th>
                <th>Observaciones / Motivo</th>
                <th>Usuario Responsable</th>
            </tr>
        </thead>
        <tbody>
        <?php
        $sql = "SELECT m.id_merma, m.fecha_registro, i.nombre_insumo, i.categoria, m.cantidad_unid, m.peso_gramos, m.observaciones, u.nombre AS usuario_nombre
                FROM control_mermas m
                INNER JOIN inventario i ON m.id_producto = i.id_producto
                INNER JOIN usuarios u ON m.id_usuario = u.id_usuario
                ORDER BY m.fecha_registro DESC";

        $res = $conexion->query($sql);

        if ($res &&$res->num_rows > 0) {
            while ($row =$res->fetch_assoc()) {
                echo "<tr>";
                echo "<td class='text-center'>#" . $row['id_merma'] . "</td>";
                echo "<td class='text-center'>" . date('d/m/Y H:i', strtotime($row['fecha_registro'])) . "</td>";
                echo "<td><strong>" . htmlspecialchars($row['nombre_insumo']) . "</strong></td>";
                echo "<td class='text-center'>" . htmlspecialchars($row['categoria']) . "</td>";
                echo "<td class='text-center text-danger'>" . (($row['cantidad_unid'] > 0) ? number_format($row['cantidad_unid'], 2) : '-') . "</td>";
                echo "<td class='text-center text-danger'>" . (($row['peso_gramos'] > 0) ? number_format($row['peso_gramos'], 2) : '-') . "</td>";
                echo "<td>" . htmlspecialchars($row['observaciones']) . "</td>";
                echo "<td>" . htmlspecialchars($row['usuario_nombre']) . "</td>";
                echo "</tr>";
            }
        } else {
            echo "<tr><td colspan='8' class='text-center'>No se encontraron registros de mermas.</td></tr>";
        }
        ?>
        </tbody>
    </table>
</body>
</html>