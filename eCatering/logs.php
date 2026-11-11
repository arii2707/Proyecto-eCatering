<?php
session_start();
if (!isset($_SESSION['id_usuario'])) {
    header("Location: index.php");
    exit();
}

// Control de Acceso por Rol (Solo Administrador y Coordinador)
$rol_usuario = $_SESSION['rol'] ?? '';
if ($rol_usuario !== 'Administrador' && $rol_usuario !== 'Coord.(a) catering') {
    header("Location: dashboard.php?error=acceso_denegado");
    exit();
}

require_once "config/conexion.php";

// Filtros de Búsqueda
$buscar      = $_GET['buscar'] ?? '';
$f_inicio    = $_GET['fecha_inicio'] ?? '';
$f_fin       = $_GET['fecha_fin'] ?? '';

// Construcción de Consulta SQL con Filtros
$where_conditions = [];

if (!empty($buscar)) {
    $buscar_clean = $conexion->real_escape_string($buscar);
    $where_conditions[] = "(l.accion LIKE '%$buscar_clean%' OR l.descripcion LIKE '%$buscar_clean%' OR u.nombre LIKE '%$buscar_clean%')";
}

if (!empty($f_inicio) && !empty($f_fin)) {
    $f_ini_clean = $conexion->real_escape_string($f_inicio);
    $f_fin_clean = $conexion->real_escape_string($f_fin);
    $where_conditions[] = "DATE(l.fecha_hora) BETWEEN '$f_ini_clean' AND '$f_fin_clean'";
}

$sql_where = !empty($where_conditions) ? "WHERE " . implode(" AND ", $where_conditions) : "";

$sql_logs = "SELECT l.*, u.nombre AS nombre_usuario, u.rol 
            FROM logs_sistema l 
            LEFT JOIN usuarios u ON l.id_usuario = u.id_usuario 
            $sql_where 
            ORDER BY l.fecha_hora DESC 
            LIMIT 100";

$res_logs = $conexion->query($sql_logs);
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>eCatering - Bitácora de Auditoría</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        /* ESTILOS OPTIMIZADOS PARA IMPRESIÓN Y PDF CENTRADO EN LOGS */
        @media print {
            @page {
                size: letter landscape;
                margin: 15mm;
            }
            body {
                background-color: #fff !important;
                color: #000 !important;
                font-size: 10pt;
            }
            nav, .btn, .card-body form, footer {
                display: none !important;
            }
            .container {
                width: 100% !important;
                max-width: 100% !important;
                margin: 0 auto !important;
                padding: 0 !important;
            }
            .card {
                border: none !important;
                box-shadow: none !important;
                margin: 0 auto !important;
                width: 100% !important;
            }
            .card-header {
                background-color: #fff !important;
                border-bottom: 2px solid #333 !important;
                padding-left: 0 !important;
            }
            .card-body {
                padding: 0 !important;
            }
            .table-responsive {
                overflow: visible !important;
            }
            .table {
                width: 100% !important;
                border-collapse: collapse !important;
                margin: 0 auto !important;
            }
            .table th, .table td {
                border: 1px solid #333 !important;
                padding: 6px 8px !important;
            }
        }
    </style>
</head>
<body class="bg-light">

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary px-4 shadow-sm">
        <a class="navbar-brand fw-bold" href="dashboard.php">eCatering System</a>
        <div class="ms-auto d-flex align-items-center text-white">
            <span class="me-3"><strong><?php echo htmlspecialchars($_SESSION['nombre']); ?></strong> (<?php echo htmlspecialchars($_SESSION['rol']); ?>)</span>
            <a href="dashboard.php" class="btn btn-outline-light btn-sm me-2">Volver al Panel</a>
            <a href="logout.php" class="btn btn-outline-light btn-sm">Cerrar Sesión</a>
        </div>
    </nav>

    <div class="container my-4">
        
        <!-- Encabezado -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="fw-bold text-primary mb-0"><i class="bi bi-shield-check me-2"></i>Bitácora y Logs de Auditoría</h3>
                <p class="text-muted small mb-0">Rastreo de eventos y seguridad del sistema (HU-23)</p>
            </div>
            <div>
                <button onclick="window.print();" class="btn btn-outline-secondary btn-sm fw-bold">
                    <i class="bi bi-printer me-1"></i> Imprimir
                </button>
            </div>
        </div>

        <!-- Filtros de Búsqueda -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-body">
                <form method="GET" action="logs.php" class="row g-3 align-items-end">
                    <div class="col-md-4">
                        <label class="form-label fw-bold small"><i class="bi bi-search me-1"></i>Buscar Acción o Usuario</label>
                        <input type="text" name="buscar" class="form-control" placeholder="Ej. Inserción, Salida, Nombre..." value="<?php echo htmlspecialchars($buscar); ?>">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label fw-bold small"><i class="bi bi-calendar-event me-1"></i>Desde</label>
                        <input type="date" name="fecha_inicio" class="form-control" value="<?php echo htmlspecialchars($f_inicio); ?>">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label fw-bold small"><i class="bi bi-calendar-check me-1"></i>Hasta</label>
                        <input type="date" name="fecha_fin" class="form-control" value="<?php echo htmlspecialchars($f_fin); ?>">
                    </div>
                    <div class="col-md-2 d-flex gap-2">
                        <button type="submit" class="btn btn-primary w-100 fw-bold"><i class="bi bi-funnel"></i> Filtrar</button>
                        <a href="logs.php" class="btn btn-outline-secondary" title="Limpiar Filtros"><i class="bi bi-arrow-counterclockwise"></i></a>
                    </div>
                </form>
            </div>
        </div>

        <!-- Tabla de Logs -->
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3">
                <h6 class="fw-bold text-secondary mb-0"><i class="bi bi-list-task me-2"></i>Últimos 100 Registros de Auditoría</h6>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th># ID Log</th>
                                <th>Fecha y Hora</th>
                                <th>Usuario</th>
                                <th>Rol</th>
                                <th>Acción Realizada</th>
                                <th>Descripción de Evento</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if ($res_logs && $res_logs->num_rows > 0): ?>
                                <?php while ($log = $res_logs->fetch_assoc()): ?>
                                    <tr>
                                        <td><code>#LOG-<?php echo str_pad($log['id_log'], 5, '0', STR_PAD_LEFT); ?></code></td>
                                        <td class="small text-muted"><?php echo date('d/m/Y h:i:s A', strtotime($log['fecha_hora'])); ?></td>
                                        <td class="fw-bold"><?php echo htmlspecialchars($log['nombre_usuario'] ?? 'Sistema / Desconocido'); ?></td>
                                        <td>
                                            <span class="badge bg-info text-dark">
                                                <?php echo htmlspecialchars($log['rol'] ?? 'N/A'); ?>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="badge bg-primary-subtle text-primary border border-primary-subtle">
                                                <?php echo htmlspecialchars($log['accion']); ?>
                                            </span>
                                        </td>
                                        <td class="small text-dark"><?php echo htmlspecialchars($log['descripcion']); ?></td>
                                    </tr>
                                <?php endwhile; ?>
                            <?php else: ?>
                                <tr>
                                    <td colspan="6" class="text-center py-4 text-muted">No se encontraron eventos o logs registrados bajo los criterios seleccionados.</td>
                                </tr>
                            <?php endif; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

    </div>

</body>
</html>