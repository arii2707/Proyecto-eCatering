<?php
session_start();

if (!isset($_SESSION['id_usuario'])) {
    header("Location: index.php");
    exit();
}

require_once "config/conexion.php";

// 1. Alertas de Certificados de Salud
$sql_badge = "SELECT COUNT(*) AS total_alertas
              FROM certificados_salud
              WHERE fecha_vencimiento <= DATE_ADD(CURDATE(), INTERVAL 30 DAY)";
$res_badge = $conexion->query($sql_badge);
$total_alertas = $res_badge ? intval($res_badge->fetch_assoc()['total_alertas']) : 0;

// 2. Estadísticas rápidas de Servicios de Catering
$sql_catering = "SELECT
    COUNT(*) AS total_servicios,
    SUM(CASE WHEN fecha = CURDATE() THEN (desayunos_cliente + almuerzos_cliente + cenas_cliente + cena_medianoche_cliente + desayunos_servicio + almuerzos_servicio + cenas_servicio + cena_medianoche_servicio + desayunos_maritime + almuerzos_maritime + cenas_maritime + cena_medianoche_maritime) ELSE 0 END) AS raciones_hoy
FROM servicios_catering";
$res_catering = $conexion->query($sql_catering);
$stats_catering = $res_catering ? $res_catering->fetch_assoc() : ['total_servicios' => 0, 'raciones_hoy' => 0];

// 3. Consultar alertas de inventario
$sql_alertas = "SELECT COUNT(*) AS total_criticos FROM inventario WHERE estado = 'Por Agotarse' OR estado = 'Agotado'";
$res_alertas = $conexion->query($sql_alertas);
$cant_criticos = 0;
if ($res_alertas) {
    $row_a = $res_alertas->fetch_assoc();
    $cant_criticos = intval($row_a['total_criticos']);
}

// 4. Consultar comidas servidas hoy
$fecha_hoy = date('Y-m-d');
$sql_servicios_hoy = "SELECT SUM(
    desayunos_cliente + almuerzos_cliente + cenas_cliente + cena_medianoche_cliente + 
    desayunos_servicio + almuerzos_servicio + cenas_servicio + cena_medianoche_servicio + 
    desayunos_maritime + almuerzos_maritime + cenas_maritime + cena_medianoche_maritime
) AS total_hoy FROM servicios_catering WHERE fecha = '$fecha_hoy'";
$res_shoy = $conexion->query($sql_servicios_hoy);
$comensales_hoy = 0;
if ($res_shoy) {
    $row_sh = $res_shoy->fetch_assoc();
    $comensales_hoy = intval($row_sh['total_hoy'] ?? 0);
}

// 5. Consultar solicitudes pendientes
$sql_solicitudes_pend = "SELECT COUNT(*) AS pendientes FROM solicitudes_catering WHERE estado_solicitud = 'Pendiente'";
$res_sol_pend = $conexion->query($sql_solicitudes_pend);
$solicitudes_pendientes = $res_sol_pend ? intval($res_sol_pend->fetch_assoc()['pendientes']) : 0;

// 6. Consultar el consumo y costos de los últimos 7 días para la gráfica
$sql_grafica = "SELECT fecha, 
    SUM(desayunos_cliente + almuerzos_cliente + cenas_cliente + cena_medianoche_cliente + 
        desayunos_servicio + almuerzos_servicio + cenas_servicio + cena_medianoche_servicio + 
        desayunos_maritime + almuerzos_maritime + cenas_maritime + cena_medianoche_maritime) AS total_dia,
    SUM(alojamiento_cliente + alojamiento_servicio + alojamiento_maritime) AS total_aloj_dia,
    tarifa_alimentacion, tarifa_alojamiento
    FROM servicios_catering 
    GROUP BY fecha, tarifa_alimentacion, tarifa_alojamiento
    ORDER BY fecha DESC 
    LIMIT 7";
$res_grafica = $conexion->query($sql_grafica);

$fechas_arr = [];
$raciones_arr = [];
$costos_arr = [];

if ($res_grafica && $res_grafica->num_rows > 0) {
    $temp_data = [];
    while ($row_g = $res_grafica->fetch_assoc()) {
        $temp_data[] = $row_g;
    }
    $temp_data = array_reverse($temp_data);
    foreach ($temp_data as $d) {
        $fechas_arr[] = date('d/m', strtotime($d['fecha']));
        $raciones_arr[] = intval($d['total_dia']);
        
        $t_alim = floatval($d['tarifa_alimentacion'] ?? 0);
        $t_aloj = floatval($d['tarifa_alojamiento'] ?? 0);
        $subtotal = (intval($d['total_dia']) * $t_alim) + (intval($d['total_aloj_dia']) * $t_aloj);
        $costos_arr[] = $subtotal;
    }
}

// 7. Datos para los gráficos de Indicadores adicionales
$sql_consumo_rubro = "SELECT i.categoria, SUM(s.cantidad_salida) AS total_consumido
                      FROM salidas_insumos s
                      INNER JOIN inventario i ON s.id_producto = i.id_producto
                      GROUP BY i.categoria";
$res_consumo_rubro = $conexion->query($sql_consumo_rubro);

$labels_rubros_inv = [];
$cant_rubros_inv = [];
if ($res_consumo_rubro) {
    while ($r = $res_consumo_rubro->fetch_assoc()) {
        $labels_rubros_inv[] = $r['categoria'];
        $cant_rubros_inv[] = floatval($r['total_consumido']);
    }
}

$sql_estados_ped = "SELECT estado_solicitud, COUNT(*) AS total FROM solicitudes_catering GROUP BY estado_solicitud";
$res_estados_ped = $conexion->query($sql_estados_ped);
$estados_ped_map = ['Pendiente' => 0, 'En Proceso' => 0, 'Despachado' => 0, 'Cancelado' => 0];
if ($res_estados_ped) {
    while ($ep = $res_estados_ped->fetch_assoc()) {
        $estados_ped_map[$ep['estado_solicitud']] = intval($ep['total']);
    }
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>eCatering - Panel Principal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="bg-light">

    <!-- Navegación Superior -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary px-4 shadow-sm">
        <a class="navbar-brand fw-bold" href="dashboard.php">eCatering System</a>
        <div class="ms-auto d-flex align-items-center text-white">
            <span class="me-3">Bienvenido, <strong><?php echo $_SESSION['nombre']; ?></strong> (<?php echo $_SESSION['rol']; ?>)</span>
            
            <!-- Botón de Usuarios en el Nav -->
            <?php 
            $roles_admin = ['Coord.(a) catering', 'Superv.(a) catering', 'Administrador'];
            if (isset($_SESSION['rol']) && in_array($_SESSION['rol'], $roles_admin)): 
            ?>
                <a href="usuarios.php" class="btn btn-outline-light btn-sm me-3">
                    <i class="bi bi-people-fill me-1"></i> Usuarios
                </a>
            <?php endif; ?>
            
            <?php if ($_SESSION['rol'] === 'Administrador' || $_SESSION['rol'] === 'Coord.(a) catering'): ?>
                <a href="logs.php" class="btn btn-outline-light btn-sm me-2">
                    <i class="bi bi-shield-check me-1"></i> Bitácora / Audit
                </a>
            <?php endif; ?>

            <a href="logout.php" class="btn btn-outline-light btn-sm">Cerrar Sesión</a>
        </div>
    </nav>

    <div class="container my-5">
        <!-- Alerta de acceso denegado -->
        <?php if (isset($_GET['error']) && $_GET['error'] === 'acceso_denegado'): ?>
            <div class="alert alert-danger alert-dismissible fade show shadow-sm mb-4" role="alert">
                <i class="bi bi-shield-lock-fill me-2"></i> <strong>Acceso Denegado:</strong> No posees los permisos requeridos para acceder a la Gestión de Usuarios.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <?php endif; ?>

        <h3 class="mb-4 text-secondary">Bienvenido al sistema de gestión eCatering</h3>
        
        <!-- Grid de Módulos Principales -->
        <div class="row g-4 justify-content-center">
            
            <!-- Tarjeta 1: Gestión de Inventario -->
            <div class="col-12 col-md-6 col-lg-3">
                <div class="card border-0 shadow-sm h-100 text-center p-3">
                    <div class="card-body d-flex flex-column p-0">
                        <div class="mb-3">
                            <div class="bg-primary-subtle text-primary rounded-circle d-inline-flex p-3 mb-2">
                                <i class="bi bi-box-seam fs-2"></i>
                            </div>
                            <h5 class="fw-bold text-dark mb-1">Gestión de Inventario</h5>
                            <p class="text-muted small mb-0">Control de insumos y víveres para embarcaciones.</p>
                        </div>
                        
                        <div class="my-auto py-2">
                            <?php if ($cant_criticos > 0): ?>
                                <span class="badge bg-warning text-dark px-3 py-2 fw-semibold">
                                    <i class="bi bi-exclamation-triangle-fill me-1"></i> <?php echo $cant_criticos; ?> reponer / crítico
                                </span>
                            <?php else: ?>
                                <span class="badge bg-success px-3 py-2 fw-semibold">
                                    <i class="bi bi-check-circle-fill me-1"></i> Stock óptimo
                                </span>
                            <?php endif; ?>
                        </div>
                        
                        <div class="mt-auto pt-3">
                            <a href="inventario.php" class="btn btn-primary fw-bold w-100 shadow-sm">
                                Entrar <i class="bi bi-arrow-right ms-1"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tarjeta 2: Certificados de Salud -->
            <div class="col-12 col-md-6 col-lg-3">
                <div class="card border-0 shadow-sm h-100 text-center p-3">
                    <div class="card-body d-flex flex-column p-0">
                        <div class="mb-3">
                            <div class="bg-primary-subtle text-primary rounded-circle d-inline-flex p-3 mb-2">
                                <i class="bi bi-card-checklist fs-2"></i>
                            </div>
                            <h5 class="fw-bold text-dark mb-1">Certificados de Salud</h5>
                            <p class="text-muted small mb-0">Control de fechas y estatus por cuadrillas del personal.</p>
                        </div>
                        
                        <div class="my-auto py-2">
                            <?php if ($total_alertas > 0): ?>
                                <span class="badge bg-danger px-3 py-2 fw-semibold">
                                    <i class="bi bi-exclamation-octagon-fill me-1"></i> <?php echo $total_alertas; ?> por vencer / vencidos
                                </span>
                            <?php else: ?>
                                <span class="badge bg-success px-3 py-2 fw-semibold">
                                    <i class="bi bi-check-circle-fill me-1"></i> Todos vigentes
                                </span>
                            <?php endif; ?>
                        </div>
                        
                        <div class="mt-auto pt-3">
                            <a href="certificados.php" class="btn btn-primary fw-bold w-100 shadow-sm">
                                Entrar <i class="bi bi-arrow-right ms-1"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tarjeta 3: Servicios de Catering -->
            <div class="col-12 col-md-6 col-lg-3">
                <div class="card border-0 shadow-sm h-100 text-center p-3">
                    <div class="card-body d-flex flex-column p-0">
                        <div class="mb-3">
                            <div class="bg-primary-subtle text-primary rounded-circle d-inline-flex p-3 mb-2">
                                <i class="bi bi-check2-square fs-2"></i>
                            </div>
                            <h5 class="fw-bold text-dark mb-1">Servicios de Catering</h5>
                            <p class="text-muted small mb-0">Registro diario de comidas servidas y cierres.</p>
                        </div>
                        
                        <div class="my-auto py-2">
                            <span class="badge bg-success px-3 py-2 fw-semibold">
                                <i class="bi bi-egg-fried me-1"></i> <?php echo $comensales_hoy; ?> comidas servidas hoy
                            </span>
                        </div>
                        
                        <div class="mt-auto pt-3">
                            <a href="servicio_diario.php" class="btn btn-primary fw-bold w-100 shadow-sm">
                                Entrar <i class="bi bi-arrow-right ms-1"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tarjeta 4: Gestión de Pedidos -->
            <div class="col-12 col-md-6 col-lg-3">
                <div class="card border-0 shadow-sm h-100 text-center p-3">
                    <div class="card-body d-flex flex-column p-0">
                        <div class="mb-3">
                            <div class="bg-primary-subtle text-primary rounded-circle d-inline-flex p-3 mb-2">
                                <i class="bi bi-clipboard-check fs-2"></i>
                            </div>
                            <h5 class="fw-bold text-dark mb-1">Gestión Pedidos</h5>
                            <p class="text-muted small mb-0">Gestión y despachos de víveres para embarcaciones.</p>
                        </div>
                        
                        <div class="my-auto py-2">
                            <?php if ($solicitudes_pendientes > 0): ?>
                                <span class="badge bg-warning text-dark px-3 py-2 fw-semibold">
                                    <i class="bi bi-clock-history me-1"></i> <?php echo $solicitudes_pendientes; ?> pendientes
                                </span>
                            <?php else: ?>
                                <span class="badge bg-success px-3 py-2 fw-semibold">
                                    <i class="bi bi-check2-all me-1"></i> Solicitudes al día
                                </span>
                            <?php endif; ?>
                        </div>
                        
                        <div class="mt-auto pt-3">
                            <a href="solicitudes.php" class="btn btn-primary fw-bold w-100 shadow-sm">
                                Entrar <i class="bi bi-arrow-right ms-1"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>

        </div> <!-- Cierre del Grid row -->

        <!-- PANEL DE INDICADORES (4 GRÁFICAS DEL BATERÍA) -->
        <div class="row g-4 mt-4">
            <!-- 1. Consumos / Insumos por Rubro -->
            <div class="col-md-6">
                <div class="card border-0 shadow-sm p-4 h-100">
                    <h5 class="fw-bold text-dark mb-3">
                        <i class="bi bi-pie-chart-fill text-primary me-2"></i>Consumos del Taladro por Rubro
                    </h5>
                    <div style="position: relative; height: 260px; width: 100%;">
                        <canvas id="chartConsumosRubro"></canvas>
                    </div>
                </div>
            </div>

            <!-- 2. Servicios por Taladro (Estado de Pedidos) -->
            <div class="col-md-6">
                <div class="card border-0 shadow-sm p-4 h-100">
                    <h5 class="fw-bold text-dark mb-3">
                        <i class="bi bi-bar-chart-fill text-primary me-2"></i>Servicios / Pedidos por Estado
                    </h5>
                    <div style="position: relative; height: 260px; width: 100%;">
                        <canvas id="chartServiciosTaladro"></canvas>
                    </div>
                </div>
            </div>

            <!-- 3. Tendencia de Platos y Costos (Líneas) -->
            <div class="col-md-6">
                <div class="card border-0 shadow-sm p-4 h-100">
                    <h5 class="fw-bold text-dark mb-3">
                        <i class="bi bi-graph-up-arrow text-primary me-2"></i>Tendencia de Platos Servidos y Costos ($)
                    </h5>
                    <div style="position: relative; height: 260px; width: 100%;">
                        <canvas id="graficaRaciones"></canvas>
                    </div>
                </div>
            </div>

            <!-- 4. Reporte de Consumo Acumulado -->
            <div class="col-md-6">
                <div class="card border-0 shadow-sm p-4 h-100">
                    <h5 class="fw-bold text-dark mb-3">
                        <i class="bi bi-calendar-check-fill text-primary me-2"></i>Reporte de Consumo por Período
                    </h5>
                    <div style="position: relative; height: 260px; width: 100%;">
                        <canvas id="chartConsumosMes"></canvas>
                    </div>
                </div>
            </div>
        </div>

    </div>

<script>
    // 1. Gráfica Consumos por Rubro
    const labelsRubros = <?php echo json_encode($labels_rubros_inv); ?>;
    const cantRubros = <?php echo json_encode($cant_rubros_inv); ?>;
    new Chart(document.getElementById('chartConsumosRubro'), {
        type: 'doughnut',
        data: {
            labels: labelsRubros.length > 0 ? labelsRubros : ['Sin Insumos'],
            datasets: [{
                data: cantRubros.length > 0 ? cantRubros : [1],
                backgroundColor: ['#0d6efd', '#198754', '#ffc107', '#0dcaf0', '#6c757d', '#fd7e14']
            }]
        },
        options: { responsive: true, maintainAspectRatio: false }
    });

    // 2. Gráfica Servicios por Estado
    new Chart(document.getElementById('chartServiciosTaladro'), {
        type: 'bar',
        data: {
            labels: ['Pendientes', 'En Proceso', 'Despachados', 'Cancelados'],
            datasets: [{
                label: 'Pedidos',
                data: [
                    <?php echo $estados_ped_map['Pendiente']; ?>,
                    <?php echo $estados_ped_map['En Proceso']; ?>,
                    <?php echo $estados_ped_map['Despachado']; ?>,
                    <?php echo $estados_ped_map['Cancelado']; ?>
                ],
                backgroundColor: ['#ffc107', '#0dcaf0', '#198754', '#dc3545']
            }]
        },
        options: { responsive: true, maintainAspectRatio: false, plugins: { legend: { display: false } } }
    });

    // 3. Gráfica Tendencia de Raciones y Costos
    const ctx = document.getElementById('graficaRaciones').getContext('2d');
    new Chart(ctx, {
        type: 'line',
        data: {
            labels: <?php echo json_encode($fechas_arr); ?>,
            datasets: [{
                label: 'Raciones Servidas',
                data: <?php echo json_encode($raciones_arr); ?>,
                borderColor: '#0d6efd',
                backgroundColor: 'rgba(13, 110, 253, 0.1)',
                borderWidth: 3,
                tension: 0.4,
                fill: true,
                pointBackgroundColor: '#0d6efd',
                pointRadius: 4,
                yAxisID: 'y'
            }, {
                label: 'Costo Total ($)',
                data: <?php echo json_encode($costos_arr); ?>,
                borderColor: '#198754',
                backgroundColor: 'rgba(25, 135, 84, 0.1)',
                borderWidth: 3,
                tension: 0.4,
                fill: true,
                pointBackgroundColor: '#198754',
                pointRadius: 4,
                yAxisID: 'y1'
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                x: { grid: { display: false } },
                y: {
                    type: 'linear',
                    display: true,
                    position: 'left',
                    beginAtZero: true,
                    title: { display: true, text: 'Raciones' },
                    grid: { color: '#f1f1f1' },
                    ticks: { precision: 0 }
                },
                y1: {
                    type: 'linear',
                    display: true,
                    position: 'right',
                    beginAtZero: true,
                    grid: { drawOnChartArea: false },
                    title: { display: true, text: 'Costo ($)' }
                }
            },
            plugins: {
                legend: {
                    display: true,
                    position: 'top',
                    labels: { usePointStyle: true, boxWidth: 8 }
                }
            }
        }
    });

    // 4. Gráfica Reporte de Consumos por Período
    new Chart(document.getElementById('chartConsumosMes'), {
        type: 'bar',
        data: {
            labels: <?php echo json_encode($fechas_arr); ?>,
            datasets: [{
                label: 'Raciones Totales',
                data: <?php echo json_encode($raciones_arr); ?>,
                backgroundColor: '#ffc107'
            }]
        },
        options: {
            indexAxis: 'y',
            responsive: true,
            maintainAspectRatio: false
        }
    });
</script>
</body>
</html>