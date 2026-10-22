<?php
session_start();
if (!isset($_SESSION['id_usuario'])) {
    header("Location: index.php");
    exit();
}

require_once "config/conexion.php";

$filas_validadas = [];
$total_filas = 0;
$total_correctas = 0;
$total_errores = 0;
$nombre_archivo_subido = "";

// Función para pre-generar un SKU de muestra visual
function simularSKU($conexion, $tipo_rubro, $offset = 0) {
    $prefix = ($tipo_rubro === 'No Comestible') ? 'NC-' : 'COM-';
    $sql = "SELECT codigo_sku FROM inventario WHERE codigo_sku LIKE '$prefix%' ORDER BY id_producto DESC LIMIT 1";
    $res = $conexion->query($sql);
    
    $nuevo_numero = 1;
    if ($res && $res->num_rows > 0) {
        $row = $res->fetch_assoc();
        $ultimo = $row['codigo_sku'];
        $numero = intval(substr($ultimo, strlen($prefix)));
        $nuevo_numero = $numero + 1;
    }
    $nuevo_numero += $offset;
    return $prefix . str_pad($nuevo_numero, 4, '0', STR_PAD_LEFT);
}

// Función auxiliar para calcular el estado de stock correctamente
function calcularEstadoStockVisual($cantidad, $stock_minimo, $stock_maximo = 0) {
    $cantidad = floatval($cantidad);
    $stock_minimo = floatval($stock_minimo);
    $stock_maximo = floatval($stock_maximo);

    if ($cantidad <= 0) {
        return 'Agotado';
    } elseif ($stock_maximo > 0 && $cantidad > $stock_maximo) {
        return 'Sobreabastecido';
    } elseif ($cantidad <= $stock_minimo) {
        return 'Por Agotarse';
    } else {
        return 'Disponible';
    }
}

// 1. Fase de Validación Previa (Pre-check)
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_FILES['archivo_masivo'])) {
    if ($_FILES['archivo_masivo']['error'] === UPLOAD_ERR_OK) {
        $nombre_archivo_subido = $_FILES['archivo_masivo']['name'];
        $tmp_name = $_FILES['archivo_masivo']['tmp_name'];

        if (($gestor = fopen($tmp_name, "r")) !== FALSE) {
            // Leer encabezado
            $encabezado = fgetcsv($gestor, 1000, ",");
            
            $offset_com = 0;
            $offset_nc = 0;

            while (($datos = fgetcsv($gestor, 1000, ",")) !== FALSE) {
                if (count($datos) < 5) continue; // Saltar filas vacías o corruptas

                $total_filas++;
                
                $codigo_sku = trim($datos[0] ?? '');
                $nombre_ins = trim($datos[1] ?? '');
                $tipo_rubro = trim($datos[2] ?? 'Comestible');
                $categoria  = trim($datos[3] ?? '');
                $cant_raw   = str_replace([' ', ','], ['', '.'], trim($datos[4] ?? '0'));
                $unidad     = trim($datos[5] ?? 'Unidad');
                $stock_min_raw = str_replace([' ', ','], ['', '.'], trim($datos[6] ?? '0'));
                $stock_max_raw = str_replace([' ', ','], ['', '.'], trim($datos[7] ?? '0'));

                $cantidad = floatval($cant_raw);
                $stock_min = floatval($stock_min_raw);
                $stock_max = floatval($stock_max_raw);

                $errores_fila = [];

                // Validaciones
                if (empty($nombre_ins)) {
                    $errores_fila[] = "Falta el nombre del insumo.";
                }
                if ($cantidad <= 0) {
                    $errores_fila[] = "La cantidad debe ser mayor a 0.";
                }
                if (empty($categoria)) {
                    $errores_fila[] = "Categoría no especificada.";
                }

                // Autogeneración de SKU visual si viene vacío
                if (empty($codigo_sku)) {
                    if ($tipo_rubro === 'No Comestible') {
                        $codigo_sku = simularSKU($conexion, 'No Comestible', $offset_nc);
                        $offset_nc++;
                    } else {
                        $codigo_sku = simularSKU($conexion, 'Comestible', $offset_com);
                        $offset_com++;
                    }
                }

                $estado_calculado = calcularEstadoStockVisual($cantidad, $stock_min, $stock_max);

                $es_valida = empty($errores_fila);
                if ($es_valida) {
                    $total_correctas++;
                } else {
                    $total_errores++;
                }

                $filas_validadas[] = [
                    'codigo_sku'    => $codigo_sku,
                    'nombre_insumo' => $nombre_ins,
                    'tipo_rubro'    => $tipo_rubro,
                    'categoria'     => $categoria,
                    'cantidad'      => $cantidad,
                    'unidad_medida' => $unidad,
                    'stock_minimo'  => $stock_min,
                    'stock_maximo'  => $stock_max,
                    'estado'        => $estado_calculado,
                    'valida'        => $es_valida,
                    'errores'       => implode(" | ", $errores_fila)
                ];
            }
            fclose($gestor);
        }
    }
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>eCatering - Carga Masiva y Validación</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary px-4 shadow-sm">
        <a class="navbar-brand fw-bold" href="dashboard.php">eCatering System</a>
        <div class="ms-auto d-flex align-items-center text-white">
            <span class="me-3"><strong><?php echo htmlspecialchars($_SESSION['nombre']); ?></strong></span>
            <a href="inventario.php" class="btn btn-outline-light btn-sm me-2">Volver al Inventario</a>
        </div>
    </nav>

    <div class="container my-4">
        
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold text-primary mb-0"><i class="bi bi-cloud-upload me-2"></i>Carga Masiva</h3>
                <p class="text-muted small mb-0">Módulo para pre-validación y asignación automática de código</p>
            </div>
            <div>
                <a href="plantilla_carga.csv" class="btn btn-outline-success btn-sm fw-bold download-link" download>
                    <i class="bi bi-download me-1"></i> Descargar Plantilla
                </a>
            </div>
        </div>

        <!-- Card de Selección de Archivo -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-body">
                <form method="POST" action="carga_masiva.php" enctype="multipart/form-data" class="row g-3 align-items-center">
                    <div class="col-md-8">
                        <label class="form-label fw-bold small"><i class="bi bi-file-earmark-spreadsheet me-1"></i>Seleccionar Archivo de Inventario (.CSV)</label>
                        <input type="file" name="archivo_masivo" class="form-control" accept=".csv" required>
                    </div>
                    <div class="col-md-4 mt-auto">
                        <button type="submit" class="btn btn-primary w-100 fw-bold shadow-sm">
                            <i class="bi bi-search-heart me-1"></i> Analizar
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Resultados de Pre-Validación -->
        <?php if (!empty($filas_validadas)): ?>
            
            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="card border-0 bg-primary text-white shadow-sm p-3">
                        <h6 class="text-white-50 small mb-1">Total Registros Leídos</h6>
                        <h2 class="fw-bold mb-0"><?php echo $total_filas; ?></h2>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card border-0 bg-success text-white shadow-sm p-3">
                        <h6 class="text-white-50 small mb-1">Válidos para Carga</h6>
                        <h2 class="fw-bold mb-0"><?php echo $total_correctas; ?></h2>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card border-0 bg-danger text-white shadow-sm p-3">
                        <h6 class="text-white-50 small mb-1">Con Errores (Omitidos)</h6>
                        <h2 class="fw-bold mb-0"><?php echo $total_errores; ?></h2>
                    </div>
                </div>
            </div>

            <!-- Tabla Resumen de Vista Previa -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                    <h6 class="fw-bold text-secondary mb-0"><i class="bi bi-table me-2"></i>Vista Previa de Validación de Datos</h6>
                    <span class="badge bg-info text-dark">Archivo: <?php echo htmlspecialchars($nombre_archivo_subido); ?></span>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0 small">
                            <thead class="table-dark">
                                <tr>
                                    <th>Estatus</th>
                                    <th>Código</th>
                                    <th>Insumo</th>
                                    <th>Rubro</th>
                                    <th>Categoría</th>
                                    <th>Cantidad</th>
                                    <th>Estado Previsto</th>
                                    <th>Detalle / Errores</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($filas_validadas as $row): ?>
                                    <tr class="<?php echo $row['valida'] ? '' : 'table-danger'; ?>">
                                        <td>
                                            <?php if ($row['valida']): ?>
                                                <span class="badge bg-success"><i class="bi bi-check-circle me-1"></i> Correcto</span>
                                            <?php else: ?>
                                                <span class="badge bg-danger"><i class="bi bi-x-circle me-1"></i> Error</span>
                                            <?php endif; ?>
                                        </td>
                                        <td><code><?php echo htmlspecialchars($row['codigo_sku']); ?></code></td>
                                        <td class="fw-bold"><?php echo htmlspecialchars($row['nombre_insumo'] ?: '---'); ?></td>
                                        <td><span class="badge bg-secondary"><?php echo htmlspecialchars($row['tipo_rubro']); ?></span></td>
                                        <td><?php echo htmlspecialchars($row['categoria'] ?: '---'); ?></td>
                                        <td class="fw-bold text-primary"><?php echo number_format($row['cantidad'], 2); ?></td>
                                        <td>
                                            <?php 
                                                $est = $row['estado'];
                                                $badge_bg = 'bg-success';
                                                if ($est === 'Agotado') $badge_bg = 'bg-danger';
                                                elseif ($est === 'Por Agotarse') $badge_bg = 'bg-warning text-dark';
                                                elseif ($est === 'Sobreabastecido') $badge_bg = 'bg-info text-dark';
                                            ?>
                                            <span class="badge <?php echo $badge_bg; ?>"><?php echo $est; ?></span>
                                        </td>
                                        <td>
                                            <?php if ($row['valida']): ?>
                                                <span class="text-success small fw-semibold"><i class="bi bi-shield-check me-1"></i> Listo </span>
                                            <?php else: ?>
                                                <span class="text-danger small fw-bold"><i class="bi bi-exclamation-triangle me-1"></i> <?php echo htmlspecialchars($row['errores']); ?></span>
                                            <?php endif; ?>
                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Botón para Inyección Definitiva -->
            <?php if ($total_correctas > 0): ?>
                <div class="card border-0 shadow-sm p-3 bg-white d-flex flex-row justify-content-between align-items-center">
                    <div>
                        <h6 class="fw-bold mb-0 text-success"><i class="bi bi-check2-all me-1"></i> ¿Todo se ve bien?</h6>
                        <small class="text-muted">Se procesarán <?php echo $total_correctas; ?> registros válidos en la base de datos.</small>
                    </div>
                    <form method="POST" action="procesar_carga_masiva.php">
                        <input type="hidden" name="nombre_archivo" value="<?php echo htmlspecialchars($nombre_archivo_subido); ?>">
                        <input type="hidden" name="datos_validados" value="<?php echo htmlspecialchars(json_encode($filas_validadas)); ?>">
                        <button type="submit" name="confirmar_carga" class="btn btn-success btn-lg fw-bold px-4 shadow-sm">
                            <i class="bi bi-box-arrow-in-down me-2"></i> Confirmar y Procesar
                        </button>
                    </form>
                </div>
            <?php endif; ?>

        <?php endif; ?>

    </div>

</body>
</html>