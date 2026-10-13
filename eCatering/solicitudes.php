<?php
session_start();
if (!isset($_SESSION['id_usuario'])) {
    header("Location: index.php");
    exit();
}

require_once "config/conexion.php";

$mensaje = "";
$error = "";

// Lógica para registrar una nueva solicitud de catering
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['agregar_solicitud'])) {
    $ubicacion = $conexion->real_escape_string($_POST['ubicacion']);
    $solicitante = $conexion->real_escape_string($_POST['solicitante']);
    $fecha_requerida = $_POST['fecha_requerida'];
    $observaciones = $conexion->real_escape_string($_POST['observaciones']);
    $estatus = $conexion->real_escape_string($_POST['estatus']);

    $sql_insert = "INSERT INTO solicitudes_catering (ubicacion, solicitante, fecha_requerida, observaciones, estatus) 
                   VALUES ('$ubicacion', '$solicitante', '$fecha_requerida', '$observaciones', '$estatus')";

    if ($conexion->query($sql_insert)) {
        $mensaje = "Solicitud de catering registrada exitosamente.";
    } else {
        $error = "Error al registrar la solicitud: " . $conexion->error;
    }
}

// Consultar todas las solicitudes
$sql_solicitudes = "SELECT * FROM solicitudes_catering ORDER BY fecha_solicitud DESC";
$resultado = $conexion->query($sql_solicitudes);
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>eCatering - Solicitudes y Catering</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <!-- Navegación -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary px-4 shadow-sm">
        <a class="navbar-brand fw-bold" href="dashboard.php">eCatering System</a>
        <div class="ms-auto d-flex align-items-center text-white">
            <span class="me-3"><strong><?php echo $_SESSION['nombre']; ?></strong></span>
            <a href="dashboard.php" class="btn btn-outline-light btn-sm me-2">Volver al Panel</a>
            <a href="logout.php" class="btn btn-outline-light btn-sm">Cerrar Sesión</a>
        </div>
    </nav>

    <div class="container my-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h2>Gestión de Solicitudes y Catering</h2>
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalNuevaSolicitud">
                + Nueva Solicitud
            </button>
        </div>

        <?php if ($mensaje): ?>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <?php echo $mensaje; ?>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <?php endif; ?>

        <?php if ($error): ?>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <?php echo $error; ?>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <?php endif; ?>

        <!-- Tabla de Solicitudes -->
        <div class="card border-0 shadow-sm">
            <div class="card-body p-0">
                <table class="table table-hover mb-0 align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>#</th>
                            <th>Ubicación / Embarcación</th>
                            <th>Solicitante</th>
                            <th>F. Requerida</th>
                            <th>Observaciones</th>
                            <th>Estatus</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php if ($resultado && $resultado->num_rows > 0): ?>
                            <?php while ($row = $resultado->fetch_assoc()): ?>
                                <tr>
                                    <td><?php echo $row['id_solicitud']; ?></td>
                                    <td class="fw-bold"><?php echo $row['ubicacion']; ?></td>
                                    <td><?php echo $row['solicitante']; ?></td>
                                    <td><?php echo date('d/m/Y', strtotime($row['fecha_requerida'])); ?></td>
                                    <td><?php echo $row['observaciones'] ? $row['observaciones'] : '<span class="text-muted">Sin detalles</span>'; ?></td>
                                    <td>
                                        <?php if ($row['estatus'] == 'Pendiente'): ?>
                                            <span class="badge bg-warning text-dark">Pendiente</span>
                                        <?php elseif ($row['estatus'] == 'En Proceso'): ?>
                                            <span class="badge bg-info text-dark">En Proceso</span>
                                        <?php elseif ($row['estatus'] == 'Despachado'): ?>
                                            <span class="badge bg-success">Despachado</span>
                                        <?php else: ?>
                                            <span class="badge bg-secondary"><?php echo $row['estatus']; ?></span>
                                        <?php endif; ?>
                                    </td>
                                </tr>
                            <?php endwhile; ?>
                        <?php else: ?>
                            <tr>
                                <td colspan="6" class="text-center text-muted py-4">
                                    No hay solicitudes de catering registradas.
                                </td>
                            </tr>
                        <?php endif; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Modal para Nueva Solicitud -->
    <div class="modal fade" id="modalNuevaSolicitud" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form method="POST" action="">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title">Registrar Solicitud de Catering</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Ubicación / Embarcación Destino</label>
                            <input type="text" name="ubicacion" class="form-control" placeholder="Ej. Gabarra M-101 / Muelle Principal" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Nombre del Solicitante / Solicitado Por</label>
                            <input type="text" name="solicitante" class="form-control" placeholder="Ej. Capitán R. Morales" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Fecha Requerida de Despacho</label>
                            <input type="date" name="fecha_requerida" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Estatus Inicial</label>
                            <select name="estatus" class="form-select" required>
                                <option value="Pendiente">Pendiente</option>
                                <option value="En Proceso">En Proceso</option>
                                <option value="Despachado">Despachado</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Observaciones / Lista Resumida</label>
                            <textarea name="observaciones" class="form-control" rows="3" placeholder="Detalles o víveres solicitados..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" name="agregar_solicitud" class="btn btn-primary">Guardar Solicitud</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Script de Bootstrap 5 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>