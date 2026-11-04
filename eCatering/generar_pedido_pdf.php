<?php
session_start();
if (!isset($_SESSION['id_usuario'])) {
    header("Location: index.php");
    exit();
}

require_once "config/conexion.php";

if (!isset($_GET['id']) || empty($_GET['id'])) {
    die("ID de requisición no especificado.");
}

$id_solicitud = intval($_GET['id']);
$sql = "SELECT * FROM solicitudes_catering WHERE id_solicitud = $id_solicitud";
$res = $conexion->query($sql);

if (!$res || $res->num_rows === 0) {
    die("Requisición no encontrada.");
}

$pedido = $res->fetch_assoc();

// Parsear Proveedor y Líneas
$lineas = explode("\n", str_replace("\r", "", $pedido['observaciones']));
$proveedor_nombre = "No especificado";
$items_por_rubro = [];

foreach ($lineas as $linea) {
    $linea = trim($linea);
    if (empty($linea)) continue;

    // Detectar si la línea contiene el Proveedor
    if (strpos($linea, "PROVEEDOR:") === 0) {
        $proveedor_nombre = trim(str_replace("PROVEEDOR:", "", $linea));
        continue;
    }

    $partes = explode("|", $linea);
    if (count($partes) >= 6) {
        $rubro     = trim($partes[0]);
        $insumo    = trim($partes[1]);
        $empaque   = trim($partes[2]);
        $contenido = trim($partes[3]);
        $cant      = floatval(trim($partes[4]));
        $precio    = floatval(trim($partes[5]));
    } else {
        $rubro     = "General";
        $insumo    = $linea;
        $empaque   = "Unid";
        $contenido = "";
        $cant      = 1;
        $precio    = 0;
    }

    $importe = $cant * $precio;

    $items_por_rubro[$rubro][] = [
        'insumo'    => $insumo,
        'empaque'   => $empaque,
        'contenido' => $contenido,
        'cantidad'  => $cant,
        'precio'    => $precio,
        'importe'   => $importe
    ];
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Orden de Compra - <?php echo htmlspecialchars($pedido['codigo_solicitud']); ?></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fa;
            color: #212529;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .invoice-card {
            max-width: 850px;
            margin: 30px auto;
            background: #ffffff;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            padding: 40px;
        }
        .table-catering {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
            margin-bottom: 25px;
        }
        .table-catering th {
            background-color: #f4f4f4;
            color: #333;
            font-weight: 600;
            padding: 10px 14px;
            border: 1px solid #e2e2e2;
        }
        .table-catering td {
            padding: 10px 14px;
            border: 1px solid #e2e2e2;
            vertical-align: middle;
        }
        .rubro-header {
            background-color: #0d6efd !important;
            color: #ffffff !important;
            font-weight: bold;
            font-size: 0.95rem;
        }
        .total-row td {
            font-weight: bold;
            font-size: 1.1rem;
            background-color: #ffffff !important;
        }
        @media print {
            .no-print { display: none !important; }
            body { background-color: #ffffff; }
            .invoice-card { box-shadow: none; padding: 0; margin: 0; max-width: 100%; }
        }
    </style>
</head>
<body>

    <div class="text-center my-4 no-print">
        <button onclick="window.print()" class="btn btn-primary fw-bold shadow-sm me-2">
            <i class="bi bi-printer-fill me-1"></i> Imprimir / Guardar en PDF
        </button>
        <a href="solicitudes.php" class="btn btn-outline-secondary shadow-sm">
            <i class="bi bi-arrow-left me-1"></i> Volver a Pedidos
        </a>
    </div>

    <div class="invoice-card">
        <!-- Encabezado Corporativo -->
        <div class="row align-items-center mb-4 pb-3 border-bottom">
            <div class="col-7">
                <h3 class="fw-bold text-primary mb-1">eCatering System</h3>
                <p class="text-muted small mb-0">Maritime Contractors de Venezuela, C.A.</p>
                <p class="text-muted small">Departamento de Catering & Logística Marítima</p>
            </div>
            <div class="col-5 text-end">
                <span class="badge bg-primary fs-6 px-3 py-2"><?php echo htmlspecialchars($pedido['codigo_solicitud']); ?></span>
                <p class="text-muted small mt-2 mb-0"><strong>F. Solicitud:</strong> <?php echo date('d/m/Y', strtotime($pedido['fecha_solicitud'])); ?></p>
                <p class="text-muted small mb-0"><strong>F. Entrega:</strong> <?php echo date('d/m/Y', strtotime($pedido['fecha_entrega'])); ?></p>
            </div>
        </div>

        <!-- Ubicación y PROVEEDOR -->
        <div class="row mb-4 p-3 bg-light rounded border mx-0">
            <div class="col-6">
                <p class="mb-1 text-secondary small fw-bold"><i class="bi bi-geo-alt-fill me-1"></i> EMBARCACIÓN / DESTINO:</p>
                <h5 class="fw-bold text-dark mb-0"><?php echo htmlspecialchars($pedido['ubicacion_embarcacion']); ?></h5>
            </div>
            <div class="col-6 text-end">
                <p class="mb-1 text-secondary small fw-bold"><i class="bi bi-truck me-1"></i> PROVEEDOR ASIGNADO:</p>
                <h5 class="fw-bold text-primary mb-0"><?php echo htmlspecialchars($proveedor_nombre); ?></h5>
            </div>
        </div>

        <!-- TABLA CLASIFICADA POR RUBROS Y PRESENTACIÓN -->
        <div class="table-responsive">
            <table class="table-catering">
                <thead>
                    <tr>
                        <th>Producto / Insumo</th>
                        <th class="text-center" style="width: 25%;">Presentación / Ref.</th>
                        <th class="text-center" style="width: 12%;">Cant.</th>
                        <th class="text-end" style="width: 18%;">Precio Pres.</th>
                        <th class="text-end" style="width: 18%;">Importe</th>
                    </tr>
                </thead>
                <tbody>
                    <?php 
                    $subtotal_general = 0;
                    if (!empty($items_por_rubro)):
                        foreach ($items_por_rubro as $nombre_rubro => $productos_rubro):
                    ?>
                        <!-- Header del Rubro -->
                        <tr>
                            <td colspan="5" class="rubro-header">
                                <i class="bi bi-tag-fill me-2"></i><?php echo htmlspecialchars($nombre_rubro); ?>
                            </td>
                        </tr>
                        <?php 
                        foreach ($productos_rubro as $item): 
                            $subtotal_general += $item['importe'];
                            $ref_contenido = !empty($item['contenido']) ? " ({$item['contenido']})" : "";
                        ?>
                            <tr>
                                <td class="ps-4 fw-semibold"><?php echo htmlspecialchars($item['insumo']); ?></td>
                                <td class="text-center text-muted small">
                                    <?php echo htmlspecialchars($item['empaque']) . htmlspecialchars($ref_contenido); ?>
                                </td>
                                <td class="text-center fw-bold"><?php echo intval($item['cantidad']); ?></td>
                                <td class="text-end"><?php echo $item['precio'] > 0 ? '$' . number_format($item['precio'], 2, ',', '.') : '—'; ?></td>
                                <td class="text-end fw-bold"><?php echo $item['importe'] > 0 ? '$' . number_format($item['importe'], 2, ',', '.') : '—'; ?></td>
                            </tr>
                        <?php endforeach; ?>
                    <?php 
                        endforeach; 
                    else: 
                    ?>
                        <tr>
                            <td colspan="5" class="text-center text-muted py-3">No hay productos desglosados en este pedido.</td>
                        </tr>
                    <?php endif; ?>

                    <!-- Total General -->
                    <tr class="total-row">
                        <td colspan="4" class="text-start fw-bold">Total General del Pedido</td>
                        <td class="text-end fw-bold text-primary">
                            <?php echo '$' . number_format($subtotal_general, 2, ',', '.'); ?>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- Sección de Firmas de Conformidad -->
        <div class="row mt-5 pt-4 text-center">
            <div class="col-6">
                <div style="border-top: 1px solid #ccc; width: 80%; margin: auto; padding-top: 8px;">
                    <p class="fw-bold mb-0 small">Firma / Capitán de Embarcación</p>
                    <span class="text-muted extra-small" style="font-size: 11px;">Solicitado y Conforme</span>
                </div>
            </div>
            <div class="col-6">
                <div style="border-top: 1px solid #ccc; width: 80%; margin: auto; padding-top: 8px;">
                    <p class="fw-bold mb-0 small">Firma / Supervisor de Catering</p>
                    <span class="text-muted extra-small" style="font-size: 11px;">Despachado y Aprobado</span>
                </div>
            </div>
        </div>
    </div>

</body>
</html>