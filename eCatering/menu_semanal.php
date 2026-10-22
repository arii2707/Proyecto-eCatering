<?php
session_start();
if (!isset($_SESSION['id_usuario'])) {
    header("Location: index.php");
    exit();
}

require_once "config/conexion.php";

$rol_usuario = $_SESSION['rol'] ?? '';
$es_coordinador = ($rol_usuario === 'Administrador' || $rol_usuario === 'Coord.(a) catering');

// Determinar rango de la semana actual (Lunes a Domingo)
$fecha_ref = $_GET['fecha'] ?? date('Y-m-d');
$ts = strtotime($fecha_ref);
$lunes = date('Y-m-d', strtotime('monday this week', $ts));
$domingo = date('Y-m-d', strtotime('sunday this week', $ts));
$semana_num = date('W', strtotime($lunes));

// Guardar / Actualizar Menú
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

    // Insertar detalle de platos por día y comida
    $dias = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    $tipos = ['Desayuno', 'Almuerzo', 'Cena', 'Nocturno'];

    foreach ($dias as $dia) {
        foreach ($tipos as $tipo) {
            $key = strtolower(str_replace(['é'], ['e'], $dia)) . '_' . strtolower($tipo);
            $p_principal = $conexion->real_escape_string($_POST[$key . '_principal'] ?? '');
            $guarnicion  = $conexion->real_escape_string($_POST[$key . '_guarnicion'] ?? '');
            $ensalada    = $conexion->real_escape_string($_POST[$key . '_ensalada'] ?? '');
            $postre      = $conexion->real_escape_string($_POST[$key . '_postre'] ?? '');

            if (!empty($p_principal)) {
                $conexion->query("INSERT INTO menu_diario_detalle (id_menu_semanal, dia_semana, tipo_comida, plato_principal, guarnicion, ensalada_sopa, postre_bebida)
                                  VALUES ($id_menu_semanal, '$dia', '$tipo', '$p_principal', '$guarnicion', '$ensalada', '$postre')");
            }
        }
    }

    registrarLog($conexion, $_SESSION['id_usuario'], "GESTION_MENU", "Actualizó la minuta del menú semanal N° $semana_num ($lunes al $domingo).");
    header("Location: menu_semanal.php?fecha=$lunes&mensaje=guardado");
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

$dias_semana = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
$tipos_comida = ['Desayuno', 'Almuerzo', 'Cena', 'Nocturno'];
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>eCatering - Planificación de Menú Semanal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        @media print {
            @page { size: letter landscape; margin: 10mm; }
            nav, .btn, .no-print { display: none !important; }
            body { background: #fff !important; font-size: 9pt; }
            .container { max-width: 100% !important; margin: 0 !important; width: 100% !important; }
            .card { border: 1px solid #333 !important; box-shadow: none !important; }
            .table th, .table td { border: 1px solid #333 !important; padding: 4px !important; }
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

        <!-- Encabezado -->
        <div class="d-flex justify-content-between align-items-center mb-3 no-print">
            <div>
                <h3 class="fw-bold text-primary mb-0"><i class="bi bi-journal-richtext me-2"></i>Menú Semanal de Catering</h3>
                <p class="text-muted small mb-0">Planificación operacional de minutas — Gabarra RIG-42</p>
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

        <!-- Selector de Semana -->
        <div class="card border-0 shadow-sm mb-4 no-print">
            <div class="card-body py-2 d-flex justify-content-between align-items-center">
                <a href="menu_semanal.php?fecha=<?php echo date('Y-m-d', strtotime('-1 week', strtotime($lunes))); ?>" class="btn btn-outline-primary btn-sm">
                    <i class="bi bi-chevron-left me-1"></i> Semana Anterior
                </a>
                <span class="fw-bold fs-6 text-dark">
                    <i class="bi bi-calendar-week me-2 text-primary"></i>
                    Semana N° <?php echo $semana_num; ?>: <?php echo date('d/m/Y', strtotime($lunes)); ?> al <?php echo date('d/m/Y', strtotime($domingo)); ?>
                </span>
                <a href="menu_semanal.php?fecha=<?php echo date('Y-m-d', strtotime('+1 week', strtotime($lunes))); ?>" class="btn btn-outline-primary btn-sm">
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

        <!-- Vista Cartelera / Tabla de Menú -->
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-primary text-white py-2 d-flex justify-content-between align-items-center">
                <span class="fw-bold fs-6">PROGRAMACIÓN DE MENÚ SEMANAL — GABARRA RIG-42</span>
                <small>Coordinador: <?php echo htmlspecialchars($menu_actual['coordinador_nombre'] ?? 'Por Asignar'); ?></small>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-bordered align-top mb-0">
                        <thead class="table-light text-center">
                            <tr>
                                <th style="width: 12%;">Servicio</th>
                                <?php foreach ($dias_semana as $idx => $dia): 
                                    $fecha_dia = date('d/m', strtotime("+$idx days", strtotime($lunes)));
                                ?>
                                    <th style="width: 12.5%;">
                                        <span class="d-block text-primary"><?php echo $dia; ?></span>
                                        <small class="text-muted fw-normal"><?php echo $fecha_dia; ?></small>
                                    </th>
                                <?php endforeach; ?>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($tipos_comida as $tipo): ?>
                                <tr>
                                    <td class="bg-light fw-bold text-center align-middle">
                                        <?php 
                                            if ($tipo === 'Desayuno') echo '<i class="bi bi-cup-hot text-warning d-block fs-5"></i>';
                                            elseif ($tipo === 'Almuerzo') echo '<i class="bi bi-sun text-danger d-block fs-5"></i>';
                                            elseif ($tipo === 'Cena') echo '<i class="bi bi-moon-stars text-primary d-block fs-5"></i>';
                                            else echo '<i class="bi bi-clock-history text-secondary d-block fs-5"></i>';
                                        ?>
                                        <?php echo $tipo; ?>
                                    </td>
                                    <?php foreach ($dias_semana as $dia): 
                                        $item = $detalles_menu[$dia][$tipo] ?? null;
                                    ?>
                                        <td class="small">
                                            <?php if ($item): ?>
                                                <strong class="text-dark d-block mb-1"><?php echo htmlspecialchars($item['plato_principal']); ?></strong>
                                                <?php if (!empty($item['guarnicion'])): ?>
                                                    <span class="text-muted d-block"><i class="bi bi-dot"></i> <?php echo htmlspecialchars($item['guarnicion']); ?></span>
                                                <?php endif; ?>
                                                <?php if (!empty($item['ensalada_sopa'])): ?>
                                                    <span class="text-muted d-block"><i class="bi bi-dot"></i> <?php echo htmlspecialchars($item['ensalada_sopa']); ?></span>
                                                <?php endif; ?>
                                                <?php if (!empty($item['postre_bebida'])): ?>
                                                    <span class="text-success d-block"><i class="bi bi-check2"></i> <?php echo htmlspecialchars($item['postre_bebida']); ?></span>
                                                <?php endif; ?>
                                            <?php else: ?>
                                                <span class="text-muted fst-italic">Sin programar</span>
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
                <div class="card-footer bg-white py-2">
                    <small class="fw-bold text-secondary">Observaciones / Recomendaciones Nutricionales:</small>
                    <p class="mb-0 small text-muted"><?php echo nl2br(htmlspecialchars($menu_actual['observaciones'])); ?></p>
                </div>
            <?php endif; ?>
        </div>

    </div>

    <!-- MODAL DE CONFIGURACIÓN DEL MENÚ (Solo Coordinador) -->
    <?php if ($es_coordinador): ?>
        <div class="modal fade" id="modalEditarMenu" tabindex="-1">
            <div class="modal-dialog modal-xl modal-dialog-scrollable">
                <div class="modal-content">
                    <form method="POST" action="menu_semanal.php?fecha=<?php echo $lunes; ?>">
                        <input type="hidden" name="guardar_menu" value="1">
                        <div class="modal-header bg-primary text-white">
                            <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square me-2"></i>Configurar Menú Semanal (Semana N° <?php echo $semana_num; ?>)</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            
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
                                        <h6 class="fw-bold text-primary mb-3">Menú para el día <?php echo $dia; ?></h6>
                                        
                                        <div class="row g-3">
                                            <?php foreach ($tipos_comida as $tipo): 
                                                $key = strtolower(str_replace(['é'], ['e'], $dia)) . '_' . strtolower($tipo);
                                                $curr = $detalles_menu[$dia][$tipo] ?? null;
                                            ?>
                                                <div class="col-md-6">
                                                    <div class="border rounded p-3 bg-light">
                                                        <h6 class="fw-bold text-secondary border-bottom pb-2"><?php echo $tipo; ?></h6>
                                                        <div class="mb-2">
                                                            <label class="form-label small fw-bold mb-1">Plato Principal</label>
                                                            <input type="text" name="<?php echo $key; ?>_principal" class="form-control form-control-sm" placeholder="Ej. Pabellón Criollo / Pollo al Horno" value="<?php echo htmlspecialchars($curr['plato_principal'] ?? ''); ?>">
                                                        </div>
                                                        <div class="mb-2">
                                                            <label class="form-label small fw-bold mb-1">Guarnición / Contorno</label>
                                                            <input type="text" name="<?php echo $key; ?>_guarnicion" class="form-control form-control-sm" placeholder="Ej. Arroz blanco, Tajadas" value="<?php echo htmlspecialchars($curr['guarnicion'] ?? ''); ?>">
                                                        </div>
                                                        <div class="mb-2">
                                                            <label class="form-label small fw-bold mb-1">Ensalada / Sopa</label>
                                                            <input type="text" name="<?php echo $key; ?>_ensalada" class="form-control form-control-sm" placeholder="Ej. Ensalada Mixta / Sopa de Res" value="<?php echo htmlspecialchars($curr['ensalada_sopa'] ?? ''); ?>">
                                                        </div>
                                                        <div>
                                                            <label class="form-label small fw-bold mb-1">Postre / Jugo</label>
                                                            <input type="text" name="<?php echo $key; ?>_postre" class="form-control form-control-sm" placeholder="Ej. Quesillo / Jugo de Guayaba" value="<?php echo htmlspecialchars($curr['postre_bebida'] ?? ''); ?>">
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
                                <textarea name="observaciones" class="form-control" rows="2" placeholder="Notas sobre alérgenos, opciones vegetarianas o recomendaciones..."><?php echo htmlspecialchars($menu_actual['observaciones'] ?? ''); ?></textarea>
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