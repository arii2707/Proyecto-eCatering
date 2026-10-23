<?php
session_start();
if (!isset($_SESSION['id_usuario'])) {
    header("Location: index.php");
    exit();
}

require_once "config/conexion.php";

// =========================================================================
// MODO 1: REPORTE INDIVIDUAL POR ID DE SERVICIO
// =========================================================================
if (isset($_GET['id']) && !empty($_GET['id'])) {

    $id_servicio = intval($_GET['id']);
    $sql = "SELECT * FROM servicios_catering WHERE id_servicio = $id_servicio";
    $res = $conexion->query($sql);

    if (!$res || $res->num_rows == 0) {
        die("Registro no encontrado.");
    }

    $data = $res->fetch_assoc();

    // Totales por grupo
    $tot_cli = $data['desayunos_cliente'] + $data['almuerzos_cliente'] + $data['cenas_cliente'] + $data['cena_medianoche_cliente'];
    $tot_ser = $data['desayunos_servicio'] + $data['almuerzos_servicio'] + $data['cenas_servicio'] + $data['cena_medianoche_servicio'];
    $tot_mar = $data['desayunos_maritime'] + $data['almuerzos_maritime'] + $data['cenas_maritime'] + $data['cena_medianoche_maritime'];

    // Totales por ración
    $tot_des = $data['desayunos_cliente'] + $data['desayunos_servicio'] + $data['desayunos_maritime'];
    $tot_alm = $data['almuerzos_cliente'] + $data['almuerzos_servicio'] + $data['almuerzos_maritime'];
    $tot_cen = $data['cenas_cliente'] + $data['cenas_servicio'] + $data['cenas_maritime'];
    $tot_cmn = $data['cena_medianoche_cliente'] + $data['cena_medianoche_servicio'] + $data['cena_medianoche_maritime'];
    $tot_alj = $data['alojamiento_cliente'] + $data['alojamiento_servicio'] + $data['alojamiento_maritime'];

    $gran_total_raciones = $tot_des + $tot_alm + $tot_cen + $tot_cmn;

    // Tarifas y Costos
    $tarifa_alim = floatval($data['tarifa_alimentacion'] ?? 0);
    $tarifa_aloj = floatval($data['tarifa_alojamiento'] ?? 0);
    $costo_alimentacion = $gran_total_raciones * $tarifa_alim;
    $costo_alojamiento = $tot_alj * $tarifa_aloj;
    $costo_total_dia = $costo_alimentacion + $costo_alojamiento;
    ?>

    <!DOCTYPE html>
    <html lang="es">
    <head>
        <meta charset="UTF-8">
        <title>Reporte_Catering_#<?php echo $data['id_servicio']; ?></title>
        <style>
            body { font-family: Arial, sans-serif; margin: 30px; font-size: 13px; color: #333; }
            .header { text-align: center; border-bottom: 2px solid #0d6efd; padding-bottom: 10px; margin-bottom: 20px; }
            .header h2 { margin: 0; color: #0d6efd; text-transform: uppercase; }
            .header p { margin: 3px 0 0 0; color: #666; font-size: 11px; }
            .info-box { width: 100%; margin-bottom: 20px; border-collapse: collapse; }
            .info-box td { padding: 6px; border: 1px solid #ddd; }
            .info-title { font-weight: bold; background-color: #f8f9fa; width: 20%; }
            .table-data { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
            .table-data th, .table-data td { border: 1px solid #000; padding: 8px; text-align: center; }
            .table-data th { background-color: #343a40; color: #fff; text-transform: uppercase; font-size: 11px; }
            .bg-group { font-weight: bold; text-align: left !important; padding-left: 10px !important; }
            .total-row { font-weight: bold; background-color: #e9ecef; }
            .footer { margin-top: 40px; width: 100%; border-collapse: collapse; }
            .footer td { width: 50%; text-align: center; padding-top: 50px; }
            .linea-firma { border-top: 1px solid #000; width: 70%; margin: 0 auto; padding-top: 5px; }
            @media print {
                .no-print { display: none; }
            }
        </style>
    </head>
    <body>

        <div class="no-print" style="margin-bottom: 20px; text-align: right;">
            <button onclick="window.print()" style="background-color: #0d6efd; color: white; border: none; padding: 10px 20px; cursor: pointer; border-radius: 4px; font-weight: bold;">
                🖨️ Imprimir / Guardar como PDF
            </button>
        </div>

        <div class="header">
            <h2>Reporte Diario de Servicio de Catering y Costos</h2>
            <p>SISTEMA DE GESTIÓN eCATERING - REGISTRO DE COMIDAS, ALOJAMIENTO Y TARIFAS</p>
        </div>

        <table class="info-box">
            <tr>
                <td class="info-title">N° REGISTRO:</td>
                <td><strong>#<?php echo $data['id_servicio']; ?></strong></td>
                <td class="info-title">FECHA SERVICIO:</td>
                <td><?php echo date('d/m/Y', strtotime($data['fecha'])); ?></td>
            </tr>
            <tr>
                <td class="info-title">UBICACIÓN:</td>
                <td colspan="3"><?php echo htmlspecialchars($data['ubicacion_embarcacion']); ?></td>
            </tr>
            <tr>
                <td class="info-title">TARIFAS:</td>
                <td colspan="3">
                    Alimentación (Plato): <strong>$<?php echo number_format($tarifa_alim, 2, ',', '.'); ?></strong> | 
                    Alojamiento (Cupo): <strong>$<?php echo number_format($tarifa_aloj, 2, ',', '.'); ?></strong>
                </td>
            </tr>
        </table>

        <h3>Cuadro Resumen de Comidas y Alojamiento por Grupos</h3>

        <table class="table-data">
            <thead>
                <tr>
                    <th style="width: 25%;">GRUPO / PERSONAL</th>
                    <th>DESAYUNOS</th>
                    <th>ALMUERZOS</th>
                    <th>CENAS</th>
                    <th>CENA M. NOCHE</th>
                    <th>ALOJAMIENTO</th>
                    <th>TOTAL RACIONES</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td class="bg-group">CLIENTE</td>
                    <td><?php echo $data['desayunos_cliente']; ?></td>
                    <td><?php echo $data['almuerzos_cliente']; ?></td>
                    <td><?php echo $data['cenas_cliente']; ?></td>
                    <td><?php echo $data['cena_medianoche_cliente']; ?></td>
                    <td><?php echo $data['alojamiento_cliente']; ?></td>
                    <td><strong><?php echo $tot_cli; ?></strong></td>
                </tr>
                <tr>
                    <td class="bg-group">EMPRESA DE SERVICIO</td>
                    <td><?php echo $data['desayunos_servicio']; ?></td>
                    <td><?php echo $data['almuerzos_servicio']; ?></td>
                    <td><?php echo $data['cenas_servicio']; ?></td>
                    <td><?php echo $data['cena_medianoche_servicio']; ?></td>
                    <td><?php echo $data['alojamiento_servicio']; ?></td>
                    <td><strong><?php echo $tot_ser; ?></strong></td>
                </tr>
                <tr>
                    <td class="bg-group">MARITIME</td>
                    <td><?php echo $data['desayunos_maritime']; ?></td>
                    <td><?php echo $data['almuerzos_maritime']; ?></td>
                    <td><?php echo $data['cenas_maritime']; ?></td>
                    <td><?php echo $data['cena_medianoche_maritime']; ?></td>
                    <td><?php echo $data['alojamiento_maritime']; ?></td>
                    <td><strong><?php echo $tot_mar; ?></strong></td>
                </tr>
            </tbody>
            <tfoot>
                <tr class="total-row">
                    <td style="text-align: left; padding-left: 10px;">TOTALES GENERALES</td>
                    <td><?php echo $tot_des; ?></td>
                    <td><?php echo $tot_alm; ?></td>
                    <td><?php echo $tot_cen; ?></td>
                    <td><?php echo $tot_cmn; ?></td>
                    <td style="background-color: #d1e7dd; color: #0f5132;"><?php echo $tot_alj; ?></td>
                    <td style="background-color: #d1e7dd; color: #0f5132;"><?php echo $gran_total_raciones; ?></td>
                </tr>
            </tfoot>
        </table>

        <!-- Resumen Financiero -->
        <table class="info-box" style="margin-top: 20px;">
            <tr style="background-color: #f8f9fa;">
                <td colspan="4" style="font-weight: bold; text-align: center; font-size: 14px; color: #0d6efd;">RESUMEN FINANCIERO DEL DÍA</td>
            </tr>
            <tr>
                <td class="info-title">Total Alimentación:</td>
                <td><?php echo $gran_total_raciones; ?> raciones × $<?php echo number_format($tarifa_alim, 2, ',', '.'); ?> = <strong>$<?php echo number_format($costo_alimentacion, 2, ',', '.'); ?></strong></td>
                <td class="info-title">Total Alojamiento:</td>
                <td><?php echo $tot_alj; ?> cupos × $<?php echo number_format($tarifa_aloj, 2, ',', '.'); ?> = <strong>$<?php echo number_format($costo_alojamiento, 2, ',', '.'); ?></strong></td>
            </tr>
            <tr>
                <td class="info-title" style="background-color: #d1e7dd; color: #0f5132;">COSTO TOTAL DÍA:</td>
                <td colspan="3" style="background-color: #d1e7dd; color: #0f5132; font-size: 15px; font-weight: bold;">
                    $<?php echo number_format($costo_total_dia, 2, ',', '.'); ?>
                </td>
            </tr>
        </table>

        <!-- Menús Aplicados -->
        <h3 style="margin-top: 20px;">Menús Aplicados</h3>
        <table class="table-data" style="text-align: left;">
            <thead>
                <tr>
                    <th style="width: 25%;">Turno</th>
                    <th>Detalle del Menú Registrado</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td style="font-weight: bold;">Desayuno</td>
                    <td><?php echo !empty($data['menu_desayuno']) ? htmlspecialchars($data['menu_desayuno']) : '<em style="color: #777;">Sin registrar</em>'; ?></td>
                </tr>
                <tr>
                    <td style="font-weight: bold;">Almuerzo</td>
                    <td><?php echo !empty($data['menu_almuerzo']) ? htmlspecialchars($data['menu_almuerzo']) : '<em style="color: #777;">Sin registrar</em>'; ?></td>
                </tr>
                <tr>
                    <td style="font-weight: bold;">Cena</td>
                    <td><?php echo !empty($data['menu_cena']) ? htmlspecialchars($data['menu_cena']) : '<em style="color: #777;">Sin registrar</em>'; ?></td>
                </tr>
                <tr>
                    <td style="font-weight: bold;">Media Noche</td>
                    <td><?php echo !empty($data['menu_medianoche']) ? htmlspecialchars($data['menu_medianoche']) : '<em style="color: #777;">Sin registrar</em>'; ?></td>
                </tr>
            </tbody>
        </table>

        <?php if (!empty($data['observaciones'])): ?>
            <div style="margin-top: 15px;">
                <strong>Observaciones / Novedades:</strong>
                <p style="border: 1px solid #ccc; padding: 10px; background-color: #fafafa; margin-top: 5px;">
                    <?php echo nl2br(htmlspecialchars($data['observaciones'])); ?>
                </p>
            </div>
        <?php endif; ?>

        <table class="footer">
            <tr>
                <td>
                    <div class="linea-firma">Emitido por</div>
                </td>
                <td>
                    <div class="linea-firma">Recibido por</div>
                </td>
            </tr>
        </table>

    </body>
    </html>
    <?php
    exit();
}

// =========================================================================
// MODO 2: REPORTE CONSOLIDADO POR RANGO DE FECHAS
// =========================================================================

$fecha_inicio = $_GET['fecha_inicio'] ?? '';
$fecha_fin = $_GET['fecha_fin'] ?? '';
$buscar = $_GET['buscar'] ?? '';

$donde = "WHERE 1=1";

if (!empty($fecha_inicio) && !empty($fecha_fin)) {
    $f_inicio_clean = $conexion->real_escape_string($fecha_inicio);
    $f_fin_clean = $conexion->real_escape_string($fecha_fin);
    $donde .= " AND fecha BETWEEN '$f_inicio_clean' AND '$f_fin_clean'";
} elseif (!empty($fecha_inicio)) {
    $f_inicio_clean = $conexion->real_escape_string($fecha_inicio);
    $donde .= " AND fecha >= '$f_inicio_clean'";
} elseif (!empty($fecha_fin)) {
    $f_fin_clean = $conexion->real_escape_string($fecha_fin);
    $donde .= " AND fecha <= '$f_fin_clean'";
}

if (!empty($buscar)) {
    $buscar_clean = $conexion->real_escape_string($buscar);
    $donde .= " AND ubicacion_embarcacion LIKE '%$buscar_clean%'";
}

// Registros diarios con cálculo de costos por fila
$sql = "SELECT *, 
        (desayunos_cliente + almuerzos_cliente + cenas_cliente + cena_medianoche_cliente + 
         desayunos_servicio + almuerzos_servicio + cenas_servicio + cena_medianoche_servicio + 
         desayunos_maritime + almuerzos_maritime + cenas_maritime + cena_medianoche_maritime) AS total_raciones,
        (alojamiento_cliente + alojamiento_servicio + alojamiento_maritime) AS total_alojamiento
        FROM servicios_catering 
        $donde 
        ORDER BY fecha ASC";

$resultado = $conexion->query($sql);

// Totales acumulados generales
$sql_totales = "SELECT 
        SUM(desayunos_cliente + almuerzos_cliente + cenas_cliente + cena_medianoche_cliente + 
            desayunos_servicio + almuerzos_servicio + cenas_servicio + cena_medianoche_servicio + 
            desayunos_maritime + almuerzos_maritime + cenas_maritime + cena_medianoche_maritime) AS gran_total_raciones,
        SUM(alojamiento_cliente + alojamiento_servicio + alojamiento_maritime) AS gran_total_alojamiento,
        COUNT(*) AS total_dias
        FROM servicios_catering 
        $donde";

$res_totales = $conexion->query($sql_totales);
$totales = $res_totales ? $res_totales->fetch_assoc() : [];

// Calcular costo total acumulado del período iterando los resultados
$costo_total_periodo = 0;
$registros_data = [];
if ($resultado && $resultado->num_rows > 0) {
    while ($row = $resultado->fetch_assoc()) {
        $raciones_dia = intval($row['total_raciones']);
        $aloj_dia = intval($row['total_alojamiento']);
        $t_alim = floatval($row['tarifa_alimentacion'] ?? 0);
        $t_aloj = floatval($row['tarifa_alojamiento'] ?? 0);
        
        $subtotal_dia = ($raciones_dia * $t_alim) + ($aloj_dia * $t_aloj);
        $row['costo_dia'] = $subtotal_dia;
        $costo_total_periodo += $subtotal_dia;
        
        $registros_data[] = $row;
    }
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Reporte_Consolidado_Catering</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 30px; font-size: 13px; color: #333; }
        .header { text-align: center; border-bottom: 2px solid #0d6efd; padding-bottom: 10px; margin-bottom: 20px; }
        .header h2 { margin: 0; color: #0d6efd; text-transform: uppercase; }
        .header p { margin: 3px 0 0 0; color: #666; font-size: 11px; }
        .info-box { width: 100%; margin-bottom: 20px; border-collapse: collapse; }
        .info-box td { padding: 6px; border: 1px solid #ddd; }
        .info-title { font-weight: bold; background-color: #f8f9fa; width: 20%; }
        .table-data { width: 100%; border-collapse: collapse; margin-bottom: 20px; }
        .table-data th, .table-data td { border: 1px solid #000; padding: 8px; text-align: center; }
        .table-data th { background-color: #343a40; color: #fff; text-transform: uppercase; font-size: 11px; }
        .total-row { font-weight: bold; background-color: #e9ecef; }
        .footer { margin-top: 40px; width: 100%; border-collapse: collapse; }
        .footer td { width: 50%; text-align: center; padding-top: 50px; }
        .linea-firma { border-top: 1px solid #000; width: 70%; margin: 0 auto; padding-top: 5px; }
        @media print {
            .no-print { display: none; }
        }
    </style>
</head>
<body>

    <div class="no-print" style="margin-bottom: 20px; text-align: right;">
        <button onclick="window.print()" style="background-color: #0d6efd; color: white; border: none; padding: 10px 20px; cursor: pointer; border-radius: 4px; font-weight: bold;">
            🖨️ Imprimir / Guardar como PDF
        </button>
    </div>

    <div class="header">
        <h2>Reporte Consolidado y Financiero de Catering</h2>
        <p>SISTEMA DE GESTIÓN eCATERING - ACUMULADO DE COMIDAS, ALOJAMIENTO Y COSTOS POR PERÍODO</p>
    </div>

    <table class="info-box">
        <tr>
            <td class="info-title">PERÍODO CONSULTADO:</td>
            <td>
                <strong>
                    <?php 
                        echo (!empty($fecha_inicio) ? date('d/m/Y', strtotime($fecha_inicio)) : 'Inicio') . 
                             ' al ' . 
                             (!empty($fecha_fin) ? date('d/m/Y', strtotime($fecha_fin)) : 'Hoy'); 
                    ?>
                </strong>
            </td>
            <td class="info-title">DÍAS REGISTRADOS:</td>
            <td><strong><?php echo number_format($totales['total_dias'] ?? 0); ?> día(s)</strong></td>
        </tr>
        <tr>
            <td class="info-title" style="background-color: #d1e7dd; color: #0f5132;">COSTO TOTAL PERÍODO:</td>
            <td colspan="3" style="background-color: #d1e7dd; color: #0f5132; font-weight: bold; font-size: 14px;">
                $<?php echo number_format($costo_total_periodo, 2, ',', '.'); ?>
            </td>
        </tr>
    </table>

    <h3>Detalle Diario, Raciones y Costos Acumulados</h3>

    <table class="table-data">
        <thead>
            <tr>
                <th>FECHA</th>
                <th>EMBARCACIÓN / UBICACIÓN</th>
                <th>RACIONES</th>
                <th>ALOJ.</th>
                <th>COSTO TOTAL ($)</th>
            </tr>
        </thead>
        <tbody>
            <?php if (!empty($registros_data)): ?>
                <?php foreach ($registros_data as $row): ?>
                    <tr>
                        <td><?php echo date('d/m/Y', strtotime($row['fecha'])); ?></td>
                        <td style="text-align: left; padding-left: 10px;"><?php echo htmlspecialchars($row['ubicacion_embarcacion']); ?></td>
                        <td><?php echo $row['total_raciones']; ?></td>
                        <td><?php echo $row['total_alojamiento']; ?></td>
                        <td><strong>$<?php echo number_format($row['costo_dia'], 2, ',', '.'); ?></strong></td>
                    </tr>
                <?php endforeach; ?>
            <?php else: ?>
                <tr>
                    <td colspan="5" style="padding: 15px; color: #777;">No se encontraron registros en el período seleccionado.</td>
                </tr>
            <?php endif; ?>
        </tbody>
        <tfoot>
            <tr class="total-row">
                <td colspan="2" style="text-align: right; padding-right: 15px;">TOTALES ACUMULADOS EN EL RANGO:</td>
                <td><?php echo number_format($totales['gran_total_raciones'] ?? 0); ?></td>
                <td style="background-color: #d1e7dd; color: #0f5132;"><?php echo number_format($totales['gran_total_alojamiento'] ?? 0); ?></td>
                <td style="background-color: #d1e7dd; color: #0f5132; font-size: 14px;">$<?php echo number_format($costo_total_periodo, 2, ',', '.'); ?></td>
            </tr>
        </tfoot>
    </table>

    <table class="footer">
        <tr>
            <td>
                <div class="linea-firma">Emitido por</div>
            </td>
            <td>
                <div class="linea-firma">Recibido por</div>
            </td>
        </tr>
    </table>

</body>
</html>