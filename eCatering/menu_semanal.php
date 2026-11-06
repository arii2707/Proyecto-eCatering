<?php
session_start();
if (!isset($_SESSION['id_usuario'])) {
    header("Location: index.php");
    exit();
}

require_once "config/conexion.php";

$rol_usuario = $_SESSION['rol'] ?? '';
$es_coordinador = ($rol_usuario === 'Administrador' || $rol_usuario === 'Coord.(a) catering');

// Pestaña activa dentro del módulo ('menu' o 'estadisticas')
$tab_activo = $_GET['tab'] ?? 'menu';

// Determinar rango de la semana actual (Lunes a Domingo)
$fecha_ref = $_GET['fecha'] ?? date('Y-m-d');
$ts = strtotime($fecha_ref);
$lunes = date('Y-m-d', strtotime('monday this week', $ts));
$domingo = date('Y-m-d', strtotime('sunday this week', $ts));
$semana_num = date('W', strtotime($lunes));

// Guardar / Actualizar Menú con estructura totalmente desglosada y doble bebida
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['guardar_menu']) && $es_coordinador) {
    $id_coordinador = $_SESSION['id_usuario'];
    $observaciones  = $conexion->real_escape_string($_POST['observaciones'] ?? '');

    // Verificar si ya existe menú para esta semana
    $q_chk = $conexion->query("SELECT id_menu_semanal FROM menus_semanales WHERE fecha_inicio = '$lunes'");
    if ($q_chk && $q_chk->num_rows > 0) {
        $row_m = $q_chk->fetch_assoc();
        $id_menu_semanal = $row_m['id_menu_semanal'];
        $conexion->query("UPDATE menus_semanales SET observaciones = '$observaciones' WHERE id_menu_semanal = $id_menu_semanal");
        $conexion->query("DELETE FROM menu_diario_detalle WHERE id_menu_semanal = $id_menu_semanal");
    } else {
        $conexion->query("INSERT INTO menus_semanales (fecha_inicio, fecha_fin, semana_numero, observaciones, id_coordinador) 
                          VALUES ('$lunes', '$domingo', $semana_num, '$observaciones', $id_coordinador)");
        $id_menu_semanal = $conexion->insert_id;
    }

    $dias = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    $tipos = ['Desayuno', 'Almuerzo', 'Cena', 'Cena de Media Noche'];

    foreach ($dias as $dia) {
        foreach ($tipos as $tipo) {
            $prefix = strtolower(str_replace(['é'], ['e'], $dia)) . '_' . strtolower(str_replace(' ', '_', $tipo));
            
            $p1     = $conexion->real_escape_string($_POST[$prefix . '_p1'] ?? '');
            $p2     = $conexion->real_escape_string($_POST[$prefix . '_p2'] ?? '');
            $c1     = $conexion->real_escape_string($_POST[$prefix . '_c1'] ?? '');
            $c2     = $conexion->real_escape_string($_POST[$prefix . '_c2'] ?? '');
            $c3     = $conexion->real_escape_string($_POST[$prefix . '_c3'] ?? '');
            $sopa   = $conexion->real_escape_string($_POST[$prefix . '_sopa'] ?? '');
            $bebida1= $conexion->real_escape_string($_POST[$prefix . '_bebida1'] ?? '');
            $bebida2= $conexion->real_escape_string($_POST[$prefix . '_bebida2'] ?? '');
            $postre = $conexion->real_escape_string($_POST[$prefix . '_postre'] ?? '');
            $fruta  = $conexion->real_escape_string($_POST[$prefix . '_fruta'] ?? '');

            $plato_principal_full = trim($p1 . (!empty($p2) ? " / " . $p2 : ""));
            $guarnicion_full = trim($c1 . (!empty($c2) ? " / " . $c2 : "") . (!empty($c3) ? " / " . $c3 : ""));
            $ensalada_sopa_full = trim($sopa);
            
            $bebidas_str = trim($bebida1 . (!empty($bebida2) ? " / " . $bebida2 : ""));
            $postre_bebida_full = trim($bebidas_str . (!empty($postre) ? " [Postre: " . $postre . "]" : "") . (!empty($fruta) ? " [Fruta: " . $fruta . "]" : ""));

            if (!empty($plato_principal_full) || !empty($guarnicion_full) || !empty($bebidas_str)) {
                $conexion->query("INSERT INTO menu_diario_detalle 
                    (id_menu_semanal, dia_semana, tipo_comida, plato_principal, guarnicion, ensalada_sopa, postre_bebida)
                    VALUES ($id_menu_semanal, '$dia', '$tipo', '$plato_principal_full', '$guarnicion_full', '$ensalada_sopa_full', '$postre_bebida_full')");
            }
        }
    }

    header("Location: menu_semanal.php?fecha=$lunes&tab=menu&mensaje=guardado");
    exit();
}

// Consultar menú de la semana
$menu_actual = null;
$detalles_menu = [];

$res_m = $conexion->query("SELECT m.*, u.nombre AS coordinador_nombre 
                          FROM menus_semanales m 
                          LEFT JOIN usuarios u ON m.id_coordinador = u.id_usuario 
                          WHERE m.fecha_inicio = '$lunes'");
if ($res_m && $res_m->num_rows > 0) {
    $menu_actual = $res_m->fetch_assoc();
    $id_ms = $menu_actual['id_menu_semanal'];
    $res_d = $conexion->query("SELECT * FROM menu_diario_detalle WHERE id_menu_semanal = $id_ms");
    while ($d = $res_d->fetch_assoc()) {
        $detalles_menu[$d['dia_semana']][$d['tipo_comida']] = $d;
    }
}

// Función de cumplimiento real
function calcularPorcentajeValorReal($planificado, $aplicado) {
    $planificado = trim($planificado);
    $aplicado = trim($aplicado);

    if (empty($planificado)) return 100; 
    if (empty($aplicado)) return 0;

    $planLimpio = mb_strtolower(preg_replace('/\s+/', ' ', $planificado));
    $appLimpio = mb_strtolower(preg_replace('/\s+/', ' ', $aplicado));

    if ($planLimpio === $appLimpio) return 100;

    $planWords = preg_split('/[\s\/]+/', $planLimpio);
    $matches = 0;
    foreach ($planWords as $word) {
        if (mb_strlen($word) > 2 && mb_strpos($appLimpio, $word) !== false) {
            $matches++;
        }
    }

    $porcentaje = count($planWords) > 0 ? round(($matches / count($planWords)) * 100) : 0;
    if ($porcentaje > 100) return 100;
    if ($porcentaje < 20 && mb_strlen($aplicado) > 0) return 20;
    return $porcentaje;
}

$porcentajes_dias = [];
$dias_semana = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
$tipos_comida = ['Desayuno', 'Almuerzo', 'Cena', 'Cena de Media Noche'];

foreach ($dias_semana as $idx_d => $dia_n) {
    $fecha_iter = date('Y-m-d', strtotime("+$idx_d days", strtotime($lunes)));
    $q_serv = $conexion->query("SELECT menu_desayuno, menu_almuerzo, menu_cena, menu_medianoche FROM servicios_catering WHERE fecha = '$fecha_iter'");
    
    if ($q_serv && $q_serv->num_rows > 0) {
        $serv_data = $q_serv->fetch_assoc();
        
        $p_desayuno = calcularPorcentajeValorReal($detalles_menu[$dia_n]['Desayuno']['plato_principal'] ?? '', $serv_data['menu_desayuno'] ?? '');
        $p_almuerzo = calcularPorcentajeValorReal($detalles_menu[$dia_n]['Almuerzo']['plato_principal'] ?? '', $serv_data['menu_almuerzo'] ?? '');
        $p_cena = calcularPorcentajeValorReal($detalles_menu[$dia_n]['Cena']['plato_principal'] ?? '', $serv_data['menu_cena'] ?? '');
        $p_mn = calcularPorcentajeValorReal($detalles_menu[$dia_n]['Cena de Media Noche']['plato_principal'] ?? '', $serv_data['menu_medianoche'] ?? '');

        $porcentajes_dias[$dia_n] = round(($p_desayuno + $p_almuerzo + $p_cena + $p_mn) / 4);
    } else {
        $porcentajes_dias[$dia_n] = 0;
    }
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>eCatering - Planificación y Estadísticas de Menú</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
    :root {
        --pastel-desayuno-bg: #FEF3C7;
        --pastel-desayuno-text: #92400E;
        --pastel-almuerzo-bg: #FEE2E2;
        --pastel-almuerzo-text: #991B1B;
        --pastel-cena-bg: #E0F2FE;
        --pastel-cena-text: #075985;
        --pastel-medianoche-bg: #F3E8FF;
        --pastel-medianoche-text: #6B21A8;
        --header-bg: #1E293B;
        --border-color: #CBD5E1;
    }
    body { background-color: #F8FAFC !important; font-family: 'Segoe UI', system-ui, -apple-system, sans-serif; }
    .card-menu { border-radius: 12px; border: 1px solid var(--border-color); overflow: hidden; box-shadow: 0 4px 16px rgba(0, 0, 0, 0.04); }
    .header-cartelera { background-color: var(--header-bg) !important; color: #FFFFFF !important; padding: 14px 20px; }
    .table-menu th { background-color: #F1F5F9 !important; color: #334155; font-weight: 700; font-size: 0.85rem; border: 1px solid var(--border-color) !important; padding: 10px 4px !important; text-align: center; }
    .table-menu td { vertical-align: top; padding: 6px 8px !important; background-color: #FFFFFF !important; border: 1px solid var(--border-color) !important; font-size: 0.78rem; }
    .servicio-col { vertical-align: middle !important; text-align: center; width: 13%; background-color: #FFFFFF !important; font-weight: bold; }
    .badge-servicio { display: inline-flex; flex-direction: column; align-items: center; justify-content: center; padding: 6px; border-radius: 6px; width: 100%; font-weight: 700; font-size: 0.75rem; text-transform: uppercase; }
    .badge-desayuno { background-color: var(--pastel-desayuno-bg); color: var(--pastel-desayuno-text); }
    .badge-almuerzo { background-color: var(--pastel-almuerzo-bg); color: var(--pastel-almuerzo-text); }
    .badge-cena { background-color: var(--pastel-cena-bg); color: var(--pastel-cena-text); }
    .badge-medianoche { background-color: var(--pastel-medianoche-bg); color: var(--pastel-medianoche-text); }
    
    .menu-section-title { font-size: 0.68rem; font-weight: 700; text-transform: uppercase; color: #64748B; border-bottom: 1px solid #E2E8F0; margin-top: 4px; margin-bottom: 2px; padding-bottom: 1px; }
    .menu-item-line { display: block; color: #1E293B; margin-bottom: 1px; font-weight: 600; }
    .menu-sub-line { display: block; color: #475569; margin-bottom: 1px; }
    
    @media print {
        @page { 
            size: letter landscape; 
            margin: 4mm 6mm; /* Márgenes mínimos para ganar espacio vertical */
        }
        * { 
            -webkit-print-color-adjust: exact !important; 
            print-color-adjust: exact !important; 
        }
        nav, .btn, .no-print, .alert, .card-footer, .nav-tabs { 
            display: none !important; 
        }
        body { 
            background: #ffffff !important; 
            font-size: 7pt !important; /* Letra optimizada para que todo encaje en una sola hoja */
            color: #000 !important;
            margin: 0 !important;
        }
        .container { 
            max-width: 100% !important; 
            width: 100% !important; 
            margin: 0 !important; 
            padding: 0 !important; 
        }
        .card-menu {
            border: 1px solid #333 !important;
            box-shadow: none !important;
            margin-bottom: 0 !important;
        }
        .header-cartelera {
            padding: 6px 10px !important;
        }
        .table-menu th {
            padding: 4px 2px !important;
            font-size: 7.5pt !important;
        }
        .table-menu td {
            padding: 3px 4px !important; /* Celdas compactas */
            font-size: 7pt !important;
        }
        .menu-section-title {
            font-size: 6pt !important;
            margin-top: 2px !important;
            margin-bottom: 1px !important;
        }
        .badge-servicio {
            padding: 4px !important;
            font-size: 6.5pt !important;
        }
        .badge-servicio i {
            display: none !important; /* Ocultar iconos pequeños en impresión para ahorrar altura */
        }
    }
    </style>
</head>
<body class="bg-light">

    <nav class="navbar navbar-expand-lg navbar-dark bg-primary px-4 shadow-sm no-print">
        <a class="navbar-brand fw-bold" href="dashboard.php">eCatering System</a>
        <div class="ms-auto d-flex align-items-center text-white">
            <span class="me-3"><strong><?php echo htmlspecialchars($_SESSION['nombre']); ?></strong> (<?php echo htmlspecialchars($_SESSION['rol']); ?>)</span>
            <a href="dashboard.php" class="btn btn-outline-light btn-sm me-2">Volver al Panel</a>
            <a href="logout.php" class="btn btn-outline-light btn-sm">Cerrar Sesión</a>
        </div>
    </nav>

    <div class="container my-4">
        <div class="d-flex justify-content-between align-items-center mb-3 no-print">
            <div>
                <h3 class="fw-bold text-primary mb-0"><i class="bi bi-journal-richtext me-2"></i>Módulo de Menú y Estadísticas Semanales</h3>
                <p class="text-muted small mb-0">Minuta operacional y control de cumplimiento — Gabarra RIG-42</p>
            </div>
            <div class="d-flex gap-2">
                <button onclick="window.print();" class="btn btn-outline-secondary btn-sm fw-bold">
                    <i class="bi bi-printer me-1"></i> Imprimir Cartelera
                </button>
                <?php if ($es_coordinador): ?>
                    <button class="btn btn-primary btn-sm fw-bold" data-bs-toggle="modal" data-bs-target="#modalEditarMenu">
                        <i class="bi bi-pencil-square me-1"></i> Configurar Menú
                    </button>
                <?php endif; ?>
            </div>
        </div>

        <ul class="nav nav-tabs mb-4 no-print">
            <li class="nav-item">
                <a class="nav-link <?php echo ($tab_activo === 'menu') ? 'active fw-bold' : ''; ?>" href="menu_semanal.php?fecha=<?php echo $lunes; ?>&tab=menu">
                    <i class="bi bi-calendar-week me-1"></i> Cartelera de Menú Semanal
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <?php echo ($tab_activo === 'estadisticas') ? 'active fw-bold' : ''; ?>" href="menu_semanal.php?fecha=<?php echo $lunes; ?>&tab=estadisticas">
                    <i class="bi bi-bar-chart-fill me-1"></i> Gráficas y Valores de Cumplimiento
                </a>
            </li>
        </ul>

        <div class="card border-0 shadow-sm mb-4 no-print">
            <div class="card-body py-2 d-flex justify-content-between align-items-center">
                <a href="menu_semanal.php?fecha=<?php echo date('Y-m-d', strtotime('-1 week', strtotime($lunes))); ?>&tab=<?php echo $tab_activo; ?>" class="btn btn-outline-primary btn-sm">
                    <i class="bi bi-chevron-left me-1"></i> Semana Anterior
                </a>
                <span class="fw-bold fs-6 text-dark">
                    <i class="bi bi-calendar-event me-2 text-primary"></i>
                    Semana N° <?php echo $semana_num; ?>: <?php echo date('d/m/Y', strtotime($lunes)); ?> al <?php echo date('d/m/Y', strtotime($domingo)); ?>
                </span>
                <a href="menu_semanal.php?fecha=<?php echo date('Y-m-d', strtotime('+1 week', strtotime($lunes))); ?>&tab=<?php echo $tab_activo; ?>" class="btn btn-outline-primary btn-sm">
                    Semana Siguiente <i class="bi bi-chevron-right ms-1"></i>
                </a>
            </div>
        </div>

        <?php if (isset($_GET['mensaje']) && $_GET['mensaje'] === 'guardado'): ?>
            <div class="alert alert-success alert-dismissible fade show no-print" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i> ¡Menú semanal guardado y publicado correctamente!
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <?php endif; ?>

        <!-- CONTENIDO PESTAÑA 1: CARTELERA DESGLOSADA -->
        <?php if ($tab_activo === 'menu'): ?>
            <div class="card card-menu">
                <div class="header-cartelera d-flex justify-content-between align-items-center">
                    <span class="fw-bold fs-6 tracking-wide">PROGRAMACIÓN DETALLADA DE MENÚ — GABARRA RIG-42</span>
                    <small class="fw-semibold text-white-50">Coordinador: <?php echo htmlspecialchars($menu_actual['coordinador_nombre'] ?? 'Por Asignar'); ?></small>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-bordered table-menu align-top">
                            <thead>
                                <tr>
                                    <th>Servicio</th>
                                    <?php foreach ($dias_semana as $idx => $dia): 
                                        $fecha_dia = date('d/m', strtotime("+$idx days", strtotime($lunes)));
                                    ?>
                                        <th style="width: 12.5%;">
                                            <span class="d-block"><?php echo $dia; ?></span>
                                            <small class="text-muted fw-normal"><?php echo $fecha_dia; ?></small>
                                        </th>
                                    <?php endforeach; ?>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($tipos_comida as $tipo): 
                                    $badge_clase = '';
                                    if ($tipo === 'Desayuno') $badge_clase = 'badge-desayuno';
                                    elseif ($tipo === 'Almuerzo') $badge_clase = 'badge-almuerzo';
                                    elseif ($tipo === 'Cena') $badge_clase = 'badge-cena';
                                    else $badge_clase = 'badge-medianoche';
                                ?>
                                    <tr>
                                        <td class="servicio-col">
                                            <div class="badge-servicio <?php echo $badge_clase; ?>">
                                                <?php 
                                                    if ($tipo === 'Desayuno') echo '<i class="bi bi-cup-hot fs-5 mb-1"></i>';
                                                    elseif ($tipo === 'Almuerzo') echo '<i class="bi bi-sun fs-5 mb-1"></i>';
                                                    elseif ($tipo === 'Cena') echo '<i class="bi bi-moon-stars fs-5 mb-1"></i>';
                                                    else echo '<i class="bi bi-clock-history fs-5 mb-1"></i>';
                                                ?>
                                                <span><?php echo $tipo; ?></span>
                                            </div>
                                        </td>
                                        <?php foreach ($dias_semana as $dia): 
                                            $item = $detalles_menu[$dia][$tipo] ?? null;
                                        ?>
                                            <td>
                                                <?php if ($item): ?>
                                                    <?php if (!empty($item['plato_principal'])): ?>
                                                        <div class="menu-section-title">Plato / Proteína</div>
                                                        <?php foreach(explode('/', $item['plato_principal']) as $p): ?>
                                                            <span class="menu-item-line">• <?php echo trim($p); ?></span>
                                                        <?php endforeach; ?>
                                                    <?php endif; ?>

                                                    <?php if (!empty($item['guarnicion'])): ?>
                                                        <div class="menu-section-title">Contornos</div>
                                                        <?php foreach(explode('/', $item['guarnicion']) as $g): ?>
                                                            <span class="menu-sub-line">• <?php echo trim($g); ?></span>
                                                        <?php endforeach; ?>
                                                    <?php endif; ?>

                                                    <?php if (!empty($item['ensalada_sopa'])): ?>
                                                        <div class="menu-section-title">Sopa / Crema</div>
                                                        <span class="menu-sub-line">• <?php echo htmlspecialchars($item['ensalada_sopa']); ?></span>
                                                    <?php endif; ?>

                                                    <?php if (!empty($item['postre_bebida'])): ?>
                                                        <div class="menu-section-title">Bebidas / Extras</div>
                                                        <span class="menu-sub-line text-success fw-semibold">✔ <?php echo htmlspecialchars($item['postre_bebida']); ?></span>
                                                    <?php endif; ?>
                                                <?php else: ?>
                                                    <span class="text-muted fst-italic small">Sin programar</span>
                                                <?php endif; ?>
                                            </td>
                                        <?php endforeach; ?>
                                    </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>
                </div>
                <?php if (!empty($menu_actual['observaciones'])): ?>
                    <div class="card-footer bg-white py-2 border-top">
                        <small class="fw-bold text-secondary">Observaciones / Recomendaciones Nutricionales:</small>
                        <p class="mb-0 small text-muted"><?php echo nl2br(htmlspecialchars($menu_actual['observaciones'])); ?></p>
                    </div>
                <?php endif; ?>
            </div>

        <!-- CONTENIDO PESTAÑA 2: ESTADÍSTICAS -->
        <?php elseif ($tab_activo === 'estadisticas'): ?>
            <div class="row g-4">
                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-header bg-white py-3">
                            <h5 class="fw-bold text-primary mb-0"><i class="bi bi-graph-up-arrow me-2"></i>Comportamiento y Porcentaje Real de Cumplimiento Semanal</h5>
                            <small class="text-muted">Cálculo basado en los registros reales de servicios diarios</small>
                        </div>
                        <div class="card-body">
                            <canvas id="graficoCumplimiento" height="130"></canvas>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-header bg-white py-3">
                            <h5 class="fw-bold text-secondary mb-0"><i class="bi bi-table me-2"></i>Valores Reales por Día</h5>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0 text-center">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Día</th>
                                            <th>Fecha</th>
                                            <th>Cumplimiento Real</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php foreach ($dias_semana as $idx => $dia): 
                                            $f_dia = date('d/m/Y', strtotime("+$idx days", strtotime($lunes)));
                                            $pct = $porcentajes_dias[$dia] ?? 0;
                                        ?>
                                            <tr>
                                                <td class="fw-bold text-start ps-3"><?php echo $dia; ?></td>
                                                <td><?php echo $f_dia; ?></td>
                                                <td>
                                                    <span class="badge <?php echo ($pct >= 80) ? 'bg-success' : (($pct >= 40) ? 'bg-warning text-dark' : (($pct > 0) ? 'bg-danger' : 'bg-secondary')); ?>">
                                                        <?php echo $pct > 0 ? $pct . '%' : 'Sin registro'; ?>
                                                    </span>
                                                </td>
                                            </tr>
                                        <?php endforeach; ?>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <script>
                document.addEventListener("DOMContentLoaded", function () {
                    const ctx = document.getElementById('graficoCumplimiento').getContext('2d');
                    new Chart(ctx, {
                        type: 'bar',
                        data: {
                            labels: ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'],
                            datasets: [{
                                label: '% Cumplimiento Real de Minuta',
                                data: [<?php echo implode(',', array_values($porcentajes_dias)); ?>],
                                backgroundColor: 'rgba(13, 110, 253, 0.7)',
                                borderColor: 'rgba(13, 110, 253, 1)',
                                borderWidth: 2,
                                borderRadius: 6
                            }]
                        },
                        options: {
                            responsive: true,
                            scales: {
                                y: {
                                    beginAtZero: true,
                                    max: 100
                                }
                            }
                        }
                    });
                });
            </script>
        <?php endif; ?>
    </div>

    <!-- MODAL DE CONFIGURACIÓN DEL MENÚ  -->
    <?php if ($es_coordinador): ?>
        <div class="modal fade" id="modalEditarMenu" tabindex="-1">
            <div class="modal-dialog modal-xl modal-dialog-scrollable">
                <div class="modal-content">
                    <form method="POST" action="menu_semanal.php?fecha=<?php echo $lunes; ?>&tab=menu">
                        <input type="hidden" name="guardar_menu" value="1">
                        <div class="modal-header bg-primary text-white">
                            <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square me-2"></i>Configurar Menú Desglosado (Semana N° <?php echo $semana_num; ?>)</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body" style="max-height: 75vh; overflow-y: auto;">   
                            <ul class="nav nav-pills mb-3" id="menuTabs" role="tablist">
                                <?php foreach ($dias_semana as $idx => $dia): ?>
                                    <li class="nav-item">
                                        <button class="nav-link <?php echo ($idx === 0) ? 'active' : ''; ?>" id="tab-<?php echo $idx; ?>" data-bs-toggle="tab" data-bs-target="#dia-<?php echo $idx; ?>" type="button">
                                            <?php echo $dia; ?>
                                        </button>
                                    </li>
                                <?php endforeach; ?>
                            </ul>
                    
                            <div class="tab-content" id="menuTabsContent">
                                <?php foreach ($dias_semana as $idx => $dia): ?>
                                    <div class="tab-pane fade <?php echo ($idx === 0) ? 'show active' : ''; ?>" id="dia-<?php echo $idx; ?>">
                                        <h6 class="fw-bold text-primary mb-3">Minuta detallada para el día <?php echo $dia; ?></h6>
                                        <div class="row g-3">
                                            <?php foreach ($tipos_comida as $tipo): 
                                                $prefix = strtolower(str_replace(['é'], ['e'], $dia)) . '_' . strtolower(str_replace(' ', '_', $tipo));
                                                
                                                // Recuperar valores actuales si existen en la base de datos
                                                $reg_actual = $detalles_menu[$dia][$tipo] ?? null;
                                                
                                                // Desglosar plato principal
                                                $p_arr = isset($reg_actual['plato_principal']) ? explode('/', $reg_actual['plato_principal']) : [];
                                                $val_p1 = trim($p_arr[0] ?? '');
                                                $val_p2 = trim($p_arr[1] ?? '');

                                                // Desglosar contornos
                                                $c_arr = isset($reg_actual['guarnicion']) ? explode('/', $reg_actual['guarnicion']) : [];
                                                $val_c1 = trim($c_arr[0] ?? '');
                                                $val_c2 = trim($c_arr[1] ?? '');
                                                $val_c3 = trim($c_arr[2] ?? '');

                                                $val_sopa = $reg_actual['ensalada_sopa'] ?? '';

                                                // Desglosar bebidas, postre y fruta almacenados en postre_bebida
                                                $pb_str = $reg_actual['postre_bebida'] ?? '';
                                                $val_bebida1 = '';
                                                $val_bebida2 = '';
                                                $val_postre = '';
                                                $val_fruta = '';

                                                if (!empty($pb_str)) {
                                                    // Extraer postre si existe formato [Postre: ...]
                                                    if (preg_match('/\[Postre:\s*([^\]]+)\]/i', $pb_str, $match_pos)) {
                                                        $val_postre = trim($match_pos[1]);
                                                        $pb_str = str_replace($match_pos[0], '', $pb_str);
                                                    }
                                                    // Extraer fruta si existe formato [Fruta: ...]
                                                    if (preg_match('/\[Fruta:\s*([^\]]+)\]/i', $pb_str, $match_fru)) {
                                                        $val_fruta = trim($match_fru[1]);
                                                        $pb_str = str_replace($match_fru[0], '', $pb_str);
                                                    }
                                                    // Lo que queda son las bebidas separadas por barras
                                                    $b_arr = explode('/', $pb_str);
                                                    $val_bebida1 = trim($b_arr[0] ?? '');
                                                    $val_bebida2 = trim($b_arr[1] ?? '');
                                                }
                                            ?>
                                                <div class="col-md-6">
                                                    <div class="border rounded p-3 bg-light">
                                                        <h6 class="fw-bold text-secondary border-bottom pb-2"><?php echo $tipo; ?></h6>
                                                        
                                                        <div class="row g-2 mb-2">
                                                            <div class="col-6">
                                                                <label class="form-label small fw-bold mb-1">Proteína / Opción 1</label>
                                                                <input type="text" name="<?php echo $prefix; ?>_p1" class="form-control form-control-sm" value="<?php echo htmlspecialchars($val_p1); ?>" placeholder="Ej. Arepa con pollo">
                                                            </div>
                                                            <div class="col-6">
                                                                <label class="form-label small fw-bold mb-1">Proteína / Opción 2</label>
                                                                <input type="text" name="<?php echo $prefix; ?>_p2" class="form-control form-control-sm" value="<?php echo htmlspecialchars($val_p2); ?>" placeholder="Ej. Club house">
                                                            </div>
                                                        </div>

                                                        <div class="row g-2 mb-2">
                                                            <div class="col-4">
                                                                <label class="form-label small fw-bold mb-1">Contorno 1</label>
                                                                <input type="text" name="<?php echo $prefix; ?>_c1" class="form-control form-control-sm" value="<?php echo htmlspecialchars($val_c1); ?>" placeholder="Arroz">
                                                            </div>
                                                            <div class="col-4">
                                                                <label class="form-label small fw-bold mb-1">Contorno 2</label>
                                                                <input type="text" name="<?php echo $prefix; ?>_c2" class="form-control form-control-sm" value="<?php echo htmlspecialchars($val_c2); ?>" placeholder="Puré">
                                                            </div>
                                                            <div class="col-4">
                                                                <label class="form-label small fw-bold mb-1">Contorno 3</label>
                                                                <input type="text" name="<?php echo $prefix; ?>_c3" class="form-control form-control-sm" value="<?php echo htmlspecialchars($val_c3); ?>" placeholder="Tajadas">
                                                            </div>
                                                        </div>

                                                        <div class="row g-2 mb-2">
                                                            <div class="col-12">
                                                                <label class="form-label small fw-bold mb-1">Sopa / Crema (Si aplica)</label>
                                                                <input type="text" name="<?php echo $prefix; ?>_sopa" class="form-control form-control-sm" value="<?php echo htmlspecialchars($val_sopa); ?>" placeholder="Sopa de res">
                                                            </div>
                                                        </div>

                                                        <div class="row g-2 mb-2">
                                                            <div class="col-6">
                                                                <label class="form-label small fw-bold mb-1">Bebida / Jugo 1</label>
                                                                <input type="text" name="<?php echo $prefix; ?>_bebida1" class="form-control form-control-sm" value="<?php echo htmlspecialchars($val_bebida1); ?>" placeholder="Café con leche">
                                                            </div>
                                                            <div class="col-6">
                                                                <label class="form-label small fw-bold mb-1">Bebida / Jugo 2</label>
                                                                <input type="text" name="<?php echo $prefix; ?>_bebida2" class="form-control form-control-sm" value="<?php echo htmlspecialchars($val_bebida2); ?>" placeholder="Jugo de patilla">
                                                            </div>
                                                        </div>

                                                        <div class="row g-2">
                                                            <div class="col-6">
                                                                <label class="form-label small fw-bold mb-1">Postre</label>
                                                                <input type="text" name="<?php echo $prefix; ?>_postre" class="form-control form-control-sm" value="<?php echo htmlspecialchars($val_postre); ?>" placeholder="Quesillo">
                                                            </div>
                                                            <div class="col-6">
                                                                <label class="form-label small fw-bold mb-1">Fruta</label>
                                                                <input type="text" name="<?php echo $prefix; ?>_fruta" class="form-control form-control-sm" value="<?php echo htmlspecialchars($val_fruta); ?>" placeholder="Cambur">
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            <?php endforeach; ?>
                                        </div>
                                    </div>
                                <?php endforeach; ?>
                            </div>

                            <div class="mt-4">
                                <label class="form-label fw-bold small">Observaciones Generales</label>
                                <textarea name="observaciones" class="form-control" rows="2" placeholder="Notas sobre alérgenos o recomendaciones..."><?php echo htmlspecialchars($menu_actual['observaciones'] ?? ''); ?></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                            <button type="submit" class="btn btn-primary fw-bold"><i class="bi bi-save me-1"></i> Guardar y Publicar Menú</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    <?php endif; ?>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>