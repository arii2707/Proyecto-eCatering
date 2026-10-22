<?php
session_start();
if (!isset($_SESSION['id_usuario'])) {
    header("Location: index.php");
    exit();
}

require_once "config/conexion.php";

$mensaje = "";
$error = "";

// Permisos permitidos para editar
$roles_permitidos = ['Administrador', 'Coord.(a) catering', 'Superv.(a) catering', 'Supervisor', 'Coordinador'];
$tiene_permiso = isset($_SESSION['rol']) && in_array($_SESSION['rol'], $roles_permitidos);

// Lógica para Procesar la Edición (Protegida en el servidor)
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['actualizar_servicio'])) {
    if (!$tiene_permiso) {
        $error = "No posees permisos para modificar este registro.";
    } else {
        $id_servicio   = intval($_POST['id_servicio']);
        $fecha         = $conexion->real_escape_string($_POST['fecha']);
        $ubicacion     = $conexion->real_escape_string($_POST['ubicacion_embarcacion']);
        $observaciones = $conexion->real_escape_string($_POST['observaciones']);

        // Tarifas unitarias del día
        $tarifa_alim   = floatval($_POST['tarifa_alimentacion']);
        $tarifa_aloj   = floatval($_POST['tarifa_alojamiento']);

        // Cliente
        $d_cli  = intval($_POST['desayunos_cliente']);
        $a_cli  = intval($_POST['almuerzos_cliente']);
        $c_cli  = intval($_POST['cenas_cliente']);
        $mn_cli = intval($_POST['cena_medianoche_cliente']);
        $al_cli = intval($_POST['alojamiento_cliente']);

        // Empresa de Servicio
        $d_ser  = intval($_POST['desayunos_servicio']);
        $a_ser  = intval($_POST['almuerzos_servicio']);
        $c_ser  = intval($_POST['cenas_servicio']);
        $mn_ser = intval($_POST['cena_medianoche_servicio']);
        $al_ser = intval($_POST['alojamiento_servicio']);

        // Maritime
        $d_mar  = intval($_POST['desayunos_maritime']);
        $a_mar  = intval($_POST['almuerzos_maritime']);
        $c_mar  = intval($_POST['cenas_maritime']);
        $mn_mar = intval($_POST['cena_medianoche_maritime']);
        $al_mar = intval($_POST['alojamiento_maritime']);

        // Menús Aplicados
        $m_desayuno   = $conexion->real_escape_string($_POST['menu_desayuno']);
        $m_almuerzo   = $conexion->real_escape_string($_POST['menu_almuerzo']);
        $m_cena       = $conexion->real_escape_string($_POST['menu_cena']);
        $m_medianoche = $conexion->real_escape_string($_POST['menu_medianoche']);

        $sql_update = "UPDATE servicios_catering SET 
                        fecha = '$fecha',
                        ubicacion_embarcacion = '$ubicacion',
                        tarifa_alimentacion = $tarifa_alim,
                        tarifa_alojamiento = $tarifa_aloj,
                        desayunos_cliente = $d_cli, almuerzos_cliente = $a_cli, cenas_cliente = $c_cli, cena_medianoche_cliente = $mn_cli, alojamiento_cliente = $al_cli,
                        desayunos_servicio = $d_ser, almuerzos_servicio = $a_ser, cenas_servicio = $c_ser, cena_medianoche_servicio = $mn_ser, alojamiento_servicio = $al_ser,
                        desayunos_maritime = $d_mar, almuerzos_maritime = $a_mar, cenas_maritime = $c_mar, cena_medianoche_maritime = $mn_mar, alojamiento_maritime = $al_mar,
                        menu_desayuno = '$m_desayuno', menu_almuerzo = '$m_almuerzo', menu_cena = '$m_cena', menu_medianoche = '$m_medianoche',
                        observaciones = '$observaciones'
                       WHERE id_servicio = $id_servicio";

        if ($conexion->query($sql_update)) {
            $mensaje = "¡Registro y tarifas actualizados correctamente!";
        } else {
            $error = "Error al actualizar el registro: " . $conexion->error;
        }
    }
}

// Filtros de fecha (por defecto muestra el mes actual)
$fecha_inicio = $_GET['fecha_inicio'] ?? date('Y-m-01');
$fecha_fin    = $_GET['fecha_fin'] ?? date('Y-m-t');

// Consulta de registros dentro del rango de fechas
$sql = "SELECT * FROM servicios_catering 
        WHERE fecha BETWEEN '$fecha_inicio' AND '$fecha_fin' 
        ORDER BY fecha DESC";
$resultado = $conexion->query($sql);
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>eCatering - Cierre y consulta de registros</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        .table-mini th, .table-mini td {
            font-size: 0.85rem;
            padding: 0.4rem;
        }
        @media print {
            .no-print {
                display: none !important;
            }
            .card {
                border: 1px solid #ccc !important;
                box-shadow: none !important;
                page-break-inside: avoid;
            }
        }
    </style>
</head>
<body class="bg-light">

    <!-- Navegación -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary px-4 shadow-sm no-print">
        <a class="navbar-brand fw-bold" href="dashboard.php">eCatering System</a>
        <div class="ms-auto d-flex align-items-center text-white">
            <span class="me-3"><strong><?php echo $_SESSION['nombre']; ?></strong></span>
            <a href="dashboard.php" class="btn btn-outline-light btn-sm me-2">Volver al Panel</a>
            <a href="logout.php" class="btn btn-outline-light btn-sm">Cerrar Sesión</a>
        </div>
    </nav>

    <div class="container my-4">
        <!-- Submenú de Navegación del Módulo -->
        <ul class="nav nav-tabs mb-4 no-print">
            <li class="nav-item">
                <a class="nav-link" href="servicio_diario.php">
                    <i class="bi bi-pencil-square me-1"></i> Registro de servicios
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link active fw-bold" href="cierre_registros.php">
                    <i class="bi bi-archive-fill me-1"></i> Cierre de registros
                </a>
            </li>
        </ul>

        <?php if ($mensaje): ?>
            <div class="alert alert-success alert-dismissible fade show no-print" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i><?php echo $mensaje; ?>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <?php endif; ?>

        <?php if ($error): ?>
            <div class="alert alert-danger alert-dismissible fade show no-print" role="alert">
                <i class="bi bi-exclamation-octagon-fill me-2"></i><?php echo $error; ?>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <?php endif; ?>

        <!-- Filtros de Búsqueda -->
        <div class="card border-0 shadow-sm mb-4 no-print">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h5 class="card-title fw-bold mb-0 text-primary">
                    <i class="bi bi-funnel-fill me-2"></i>Filtrar reportes por rango de fecha
                </h5>
            </div>
            <div class="card-body">
                <form method="GET" action="" class="row g-3 align-items-end">
                    <div class="col-md-4">
                        <label class="form-label fw-bold">Fecha desde:</label>
                        <input type="date" name="fecha_inicio" class="form-control" value="<?php echo $fecha_inicio; ?>" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-bold">Fecha Hasta:</label>
                        <input type="date" name="fecha_fin" class="form-control" value="<?php echo $fecha_fin; ?>" required>
                    </div>
                    <div class="col-md-4 d-flex gap-2">
                        <button type="submit" class="btn btn-primary fw-bold w-100">
                            <i class="bi bi-search me-1"></i> Buscar
                        </button>
                        <button type="button" onclick="window.print();" class="btn btn-outline-secondary fw-bold" title="Imprimir Vista">
                            <i class="bi bi-printer-fill"></i>
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Listado de Registros -->
        <h4 class="fw-bold mb-3 text-secondary">
            <i class="bi bi-journal-check me-2"></i>Historial de Servicios y Costos (<?php echo date('d/m/Y', strtotime($fecha_inicio)); ?> al <?php echo date('d/m/Y', strtotime($fecha_fin)); ?>)
        </h4>

        <?php if ($resultado && $resultado->num_rows > 0): ?>
            <?php while ($row = $resultado->fetch_assoc()): 
                // Totales por turno y grupo
                $tot_desayunos = $row['desayunos_cliente'] + $row['desayunos_servicio'] + $row['desayunos_maritime'];
                $tot_almuerzos = $row['almuerzos_cliente'] + $row['almuerzos_servicio'] + $row['almuerzos_maritime'];
                $tot_cenas     = $row['cenas_cliente'] + $row['cenas_servicio'] + $row['cenas_maritime'];
                $tot_mn        = $row['cena_medianoche_cliente'] + $row['cena_medianoche_servicio'] + $row['cena_medianoche_maritime'];
                $tot_aloj      = $row['alojamiento_cliente'] + $row['alojamiento_servicio'] + $row['alojamiento_maritime'];
                $gran_total_raciones = $tot_desayunos + $tot_almuerzos + $tot_cenas + $tot_mn;

                // Tarifas del registro
                $tarifa_alim = floatval($row['tarifa_alimentacion'] ?? 0);
                $tarifa_aloj = floatval($row['tarifa_alojamiento'] ?? 0);

                // Cálculos financieros
                $costo_alimentacion = $gran_total_raciones * $tarifa_alim;
                $costo_alojamiento = $tot_aloj * $tarifa_aloj;
                $costo_total_dia = $costo_alimentacion + $costo_alojamiento;
            ?>
                <div class="card border-0 shadow-sm mb-4">
                    <!-- Cabecera de la Tarjeta Diaria -->
                    <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center flex-wrap gap-2">
                        <div class="d-flex align-items-center gap-2">
                            <span class="badge bg-primary px-3 py-2 fs-6">
                                <i class="bi bi-calendar-event me-1"></i> <?php echo date('d/m/Y', strtotime($row['fecha'])); ?>
                            </span>
                            <strong class="text-dark"><i class="bi bi-geo-alt-fill text-danger me-1"></i> <?php echo htmlspecialchars($row['ubicacion_embarcacion']); ?></strong>
                        </div>
                        <div class="d-flex align-items-center gap-2 flex-wrap">
                            <span class="badge bg-success px-3 py-2 fs-6">
                                <i class="bi bi-cash-stack me-1"></i> Total Día: $<?php echo number_format($costo_total_dia, 2, ',', '.'); ?>
                            </span>
                            
                            <!-- Botón Editar -->
                            <button class="btn btn-warning btn-sm fw-bold ms-2 no-print" 
                                    onclick='intentarEditar(<?php echo json_encode($row); ?>, <?php echo $tiene_permiso ? "true" : "false"; ?>)'>
                                <i class="bi bi-pencil-square me-1"></i> Editar
                            </button>

                            <!-- Botón PDF Individual -->
                            <a href="generar_pdf_servicio.php?id=<?php echo $row['id_servicio']; ?>" target="_blank" class="btn btn-outline-danger btn-sm fw-bold no-print" title="Descargar PDF de este día">
                                <i class="bi bi-file-earmark-pdf-fill"></i> PDF
                            </a>
                        </div>
                    </div>

                    <div class="card-body">
                        <!-- Información de Tarifas Aplicadas -->
                        <div class="row mb-3 bg-light p-2 rounded border small">
                            <div class="col-md-6">
                                <span class="text-muted">Tarifa Alimentación (Plato):</span> <strong>$<?php echo number_format($tarifa_alim, 2, ',', '.'); ?></strong> (Total: $<?php echo number_format($costo_alimentacion, 2, ',', '.'); ?>)
                            </div>
                            <div class="col-md-6">
                                <span class="text-muted">Tarifa Alojamiento (Cupo):</span> <strong>$<?php echo number_format($tarifa_aloj, 2, ',', '.'); ?></strong> (Total: $<?php echo number_format($costo_alojamiento, 2, ',', '.'); ?>)
                            </div>
                        </div>

                        <!-- Detalle de Comensales por Grupo -->
                        <h6 class="fw-bold text-dark mb-2"><i class="bi bi-table me-1"></i> Detalle de Comensales por Grupo</h6>
                        <div class="table-responsive mb-3">
                            <table class="table table-bordered table-sm text-center align-middle table-mini mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th class="text-start ps-2">Grupo</th>
                                        <th>Desayunos</th>
                                        <th>Almuerzos</th>
                                        <th>Cenas</th>
                                        <th>Cena M. Noche</th>
                                        <th class="table-secondary">Alojamiento</th>
                                        <th class="table-secondary">Total Raciones</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="text-start ps-2 fw-bold text-warning">CLIENTE</td>
                                        <td><?php echo $row['desayunos_cliente']; ?></td>
                                        <td><?php echo $row['almuerzos_cliente']; ?></td>
                                        <td><?php echo $row['cenas_cliente']; ?></td>
                                        <td><?php echo $row['cena_medianoche_cliente']; ?></td>
                                        <td><?php echo $row['alojamiento_cliente']; ?></td>
                                        <td class="fw-bold bg-light"><?php echo ($row['desayunos_cliente'] + $row['almuerzos_cliente'] + $row['cenas_cliente'] + $row['cena_medianoche_cliente']); ?></td>
                                    </tr>
                                    <tr>
                                        <td class="text-start ps-2 fw-bold text-success">EMPRESA DE SERVICIO</td>
                                        <td><?php echo $row['desayunos_servicio']; ?></td>
                                        <td><?php echo $row['almuerzos_servicio']; ?></td>
                                        <td><?php echo $row['cenas_servicio']; ?></td>
                                        <td><?php echo $row['cena_medianoche_servicio']; ?></td>
                                        <td><?php echo $row['alojamiento_servicio']; ?></td>
                                        <td class="fw-bold bg-light"><?php echo ($row['desayunos_servicio'] + $row['almuerzos_servicio'] + $row['cenas_servicio'] + $row['cena_medianoche_servicio']); ?></td>
                                    </tr>
                                    <tr>
                                        <td class="text-start ps-2 fw-bold text-primary">MARITIME</td>
                                        <td><?php echo $row['desayunos_maritime']; ?></td>
                                        <td><?php echo $row['almuerzos_maritime']; ?></td>
                                        <td><?php echo $row['cenas_maritime']; ?></td>
                                        <td><?php echo $row['cena_medianoche_maritime']; ?></td>
                                        <td><?php echo $row['alojamiento_maritime']; ?></td>
                                        <td class="fw-bold bg-light"><?php echo ($row['desayunos_maritime'] + $row['almuerzos_maritime'] + $row['cenas_maritime'] + $row['cena_medianoche_maritime']); ?></td>
                                    </tr>
                                </tbody>
                                <tfoot class="table-secondary fw-bold">
                                    <tr>
                                        <td class="text-start ps-2">TOTALES</td>
                                        <td><?php echo $tot_desayunos; ?></td>
                                        <td><?php echo $tot_almuerzos; ?></td>
                                        <td><?php echo $tot_cenas; ?></td>
                                        <td><?php echo $tot_mn; ?></td>
                                        <td><?php echo $tot_aloj; ?></td>
                                        <td class="table-primary text-dark"><?php echo $gran_total_raciones; ?></td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>

                        <!-- Menús Aplicados -->
                        <h6 class="fw-bold text-dark mb-2"><i class="bi bi-journal-text me-1"></i> Menús Aplicados</h6>
                        <div class="table-responsive mb-3">
                            <table class="table table-bordered table-sm align-middle table-mini mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th style="width: 20%;">Turno</th>
                                        <th>Detalle del Menú Registrado</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="fw-bold text-warning"><i class="bi bi-brightness-high me-1"></i> Desayuno</td>
                                        <td><?php echo !empty($row['menu_desayuno']) ? htmlspecialchars($row['menu_desayuno']) : '<em class="text-muted">Sin registrar</em>'; ?></td>
                                    </tr>
                                    <tr>
                                        <td class="fw-bold text-primary"><i class="bi bi-sun me-1"></i> Almuerzo</td>
                                        <td><?php echo !empty($row['menu_almuerzo']) ? htmlspecialchars($row['menu_almuerzo']) : '<em class="text-muted">Sin registrar</em>'; ?></td>
                                    </tr>
                                    <tr>
                                        <td class="fw-bold text-info"><i class="bi bi-moon-stars me-1"></i> Cena</td>
                                        <td><?php echo !empty($row['menu_cena']) ? htmlspecialchars($row['menu_cena']) : '<em class="text-muted">Sin registrar</em>'; ?></td>
                                    </tr>
                                    <tr>
                                        <td class="fw-bold text-dark"><i class="bi bi-clock-history me-1"></i> Media Noche</td>
                                        <td><?php echo !empty($row['menu_medianoche']) ? htmlspecialchars($row['menu_medianoche']) : '<em class="text-muted">Sin registrar</em>'; ?></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <?php if (!empty($row['observaciones'])): ?>
                            <div class="bg-light p-2 rounded mb-2 border">
                                <small class="fw-bold text-secondary d-block"><i class="bi bi-chat-left-text me-1"></i> Observaciones:</small>
                                <small class="text-dark"><?php echo nl2br(htmlspecialchars($row['observaciones'])); ?></small>
                            </div>
                        <?php endif; ?>

                        <div class="text-end text-muted small">
                            <i class="bi bi-person-check me-1"></i> Registrado por: <strong><?php echo htmlspecialchars($row['usuario_registro'] ?? 'N/A'); ?></strong>
                        </div>
                    </div>
                </div>
            <?php endwhile; ?>
        <?php else: ?>
            <div class="card border-0 shadow-sm text-center py-5">
                <div class="card-body text-muted">
                    <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                    No se encontraron registros de servicios en el rango de fechas seleccionado.
                </div>
            </div>
        <?php endif; ?>
    </div>

    <!-- MODAL PARA EDITAR REGISTRO -->
    <div class="modal fade" id="modalEditar" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <form method="POST" action="">
                    <input type="hidden" name="actualizar_servicio" value="1">
                    <input type="hidden" name="id_servicio" id="edit_id">
                    
                    <div class="modal-header bg-warning text-dark">
                        <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square me-2"></i>Editar Registro Diario de Servicio y Tarifas</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    
                    <div class="modal-body">
                        <div class="row mb-3">
                            <div class="col-md-4">
                                <label class="form-label fw-bold">Fecha</label>
                                <input type="date" name="fecha" id="edit_fecha" class="form-control" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-bold text-success">Tarifa Alimentación</label>
                                <input type="number" step="0.01" name="tarifa_alimentacion" id="edit_tarifa_alim" class="form-control" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-bold text-success">Tarifa Alojamiento</label>
                                <input type="number" step="0.01" name="tarifa_alojamiento" id="edit_tarifa_aloj" class="form-control" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Ubicación / Embarcación</label>
                            <input type="text" name="ubicacion_embarcacion" id="edit_ubicacion" class="form-control" required>
                        </div>

                        <!-- Conteo por Grupos -->
                        <h6 class="fw-bold text-primary mb-2">Conteo de Comensales y Alojamiento</h6>
                        <div class="table-responsive mb-3">
                            <table class="table table-bordered table-sm text-center align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th>Grupo</th>
                                        <th>Des.</th>
                                        <th>Alm.</th>
                                        <th>Cena</th>
                                        <th>M. Noche</th>
                                        <th>Aloj.</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="fw-bold text-primary">CLIENTE</td>
                                        <td><input type="number" name="desayunos_cliente" id="edit_d_cli" class="form-control form-control-sm text-center" min="0"></td>
                                        <td><input type="number" name="almuerzos_cliente" id="edit_a_cli" class="form-control form-control-sm text-center" min="0"></td>
                                        <td><input type="number" name="cenas_cliente" id="edit_c_cli" class="form-control form-control-sm text-center" min="0"></td>
                                        <td><input type="number" name="cena_medianoche_cliente" id="edit_mn_cli" class="form-control form-control-sm text-center" min="0"></td>
                                        <td><input type="number" name="alojamiento_cliente" id="edit_al_cli" class="form-control form-control-sm text-center" min="0"></td>
                                    </tr>
                                    <tr>
                                        <td class="fw-bold text-success">SERVICIO</td>
                                        <td><input type="number" name="desayunos_servicio" id="edit_d_ser" class="form-control form-control-sm text-center" min="0"></td>
                                        <td><input type="number" name="almuerzos_servicio" id="edit_a_ser" class="form-control form-control-sm text-center" min="0"></td>
                                        <td><input type="number" name="cenas_servicio" id="edit_c_ser" class="form-control form-control-sm text-center" min="0"></td>
                                        <td><input type="number" name="cena_medianoche_servicio" id="edit_mn_ser" class="form-control form-control-sm text-center" min="0"></td>
                                        <td><input type="number" name="alojamiento_servicio" id="edit_al_ser" class="form-control form-control-sm text-center" min="0"></td>
                                    </tr>
                                    <tr>
                                        <td class="fw-bold text-warning">MARITIME</td>
                                        <td><input type="number" name="desayunos_maritime" id="edit_d_mar" class="form-control form-control-sm text-center" min="0"></td>
                                        <td><input type="number" name="almuerzos_maritime" id="edit_a_mar" class="form-control form-control-sm text-center" min="0"></td>
                                        <td><input type="number" name="cenas_maritime" id="edit_c_mar" class="form-control form-control-sm text-center" min="0"></td>
                                        <td><input type="number" name="cena_medianoche_maritime" id="edit_mn_mar" class="form-control form-control-sm text-center" min="0"></td>
                                        <td><input type="number" name="alojamiento_maritime" id="edit_al_mar" class="form-control form-control-sm text-center" min="0"></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <!-- Menús Aplicados -->
                        <h6 class="fw-bold text-primary mb-2">Menús Aplicados</h6>
                        <div class="mb-2">
                            <label class="form-label small fw-bold">Desayuno</label>
                            <input type="text" name="menu_desayuno" id="edit_m_desayuno" class="form-control form-control-sm">
                        </div>
                        <div class="mb-2">
                            <label class="form-label small fw-bold">Almuerzo</label>
                            <input type="text" name="menu_almuerzo" id="edit_m_almuerzo" class="form-control form-control-sm">
                        </div>
                        <div class="mb-2">
                            <label class="form-label small fw-bold">Cena</label>
                            <input type="text" name="menu_cena" id="edit_m_cena" class="form-control form-control-sm">
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold">Media Noche</label>
                            <input type="text" name="menu_medianoche" id="edit_m_mn" class="form-control form-control-sm">
                        </div>

                        <!-- Observaciones -->
                        <div class="mb-2">
                            <label class="form-label fw-bold">Observaciones</label>
                            <textarea name="observaciones" id="edit_observaciones" class="form-control" rows="2"></textarea>
                        </div>
                    </div>
                    
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-warning fw-bold"><i class="bi bi-save me-1"></i> Guardar Cambios</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- MODAL DE ADVERTENCIA DE PERMISOS -->
    <div class="modal fade" id="modalSinPermiso" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title fw-bold"><i class="bi bi-exclamation-octagon-fill me-2"></i>Acceso Restringido</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body text-center py-4">
                    <i class="bi bi-shield-lock-fill text-danger fs-1 d-block mb-3"></i>
                    <p class="fs-5 mb-1 fw-bold text-dark">No tienes permisos para esta función</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Entendido</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function intentarEditar(data, tienePermiso) {
            if (!tienePermiso) {
                var modalNoPermiso = new bootstrap.Modal(document.getElementById('modalSinPermiso'));
                modalNoPermiso.show();
                return;
            }

            document.getElementById('edit_id').value = data.id_servicio;
            document.getElementById('edit_fecha').value = data.fecha;
            document.getElementById('edit_ubicacion').value = data.ubicacion_embarcacion;
            document.getElementById('edit_tarifa_alim').value = data.tarifa_alimentacion || 0;
            document.getElementById('edit_tarifa_aloj').value = data.tarifa_alojamiento || 0;

            // Cliente
            document.getElementById('edit_d_cli').value = data.desayunos_cliente;
            document.getElementById('edit_a_cli').value = data.almuerzos_cliente;
            document.getElementById('edit_c_cli').value = data.cenas_cliente;
            document.getElementById('edit_mn_cli').value = data.cena_medianoche_cliente;
            document.getElementById('edit_al_cli').value = data.alojamiento_cliente;

            // Servicio
            document.getElementById('edit_d_ser').value = data.desayunos_servicio;
            document.getElementById('edit_a_ser').value = data.almuerzos_servicio;
            document.getElementById('edit_c_ser').value = data.cenas_servicio;
            document.getElementById('edit_mn_ser').value = data.cena_medianoche_servicio;
            document.getElementById('edit_al_ser').value = data.alojamiento_servicio;

            // Maritime
            document.getElementById('edit_d_mar').value = data.desayunos_maritime;
            document.getElementById('edit_a_mar').value = data.almuerzos_maritime;
            document.getElementById('edit_c_mar').value = data.cenas_maritime;
            document.getElementById('edit_mn_mar').value = data.cena_medianoche_maritime;
            document.getElementById('edit_al_mar').value = data.alojamiento_maritime;

            // Menús
            document.getElementById('edit_m_desayuno').value = data.menu_desayuno || '';
            document.getElementById('edit_m_almuerzo').value = data.menu_almuerzo || '';
            document.getElementById('edit_m_cena').value = data.menu_cena || '';
            document.getElementById('edit_m_mn').value = data.menu_medianoche || '';

            // Observaciones
            document.getElementById('edit_observaciones').value = data.observaciones || '';

            var modal = new bootstrap.Modal(document.getElementById('modalEditar'));
            modal.show();
        }
    </script>
</body>
</html>