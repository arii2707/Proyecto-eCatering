<?php
session_start();
if (!isset($_SESSION['id_usuario'])) {
    header("Location: index.php");
    exit();
}

require_once "config/conexion.php";

$mensaje = "";
$error = "";

// Lógica para registrar un nuevo certificado
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['agregar_certificado'])) {
    $nombre_personal = $conexion->real_escape_string($_POST['nombre_personal']);
    $cedula = $conexion->real_escape_string($_POST['cedula']);
    $cargo = $conexion->real_escape_string($_POST['cargo']);
    $cuadrilla = $conexion->real_escape_string($_POST['cuadrilla']);
    $fecha_emision = $_POST['fecha_emision'];
    $fecha_vencimiento = $_POST['fecha_vencimiento'];

    $sql_insert = "INSERT INTO certificados_salud (nombre_personal, cedula, cargo, cuadrilla, fecha_emision, fecha_vencimiento) 
                   VALUES ('$nombre_personal', '$cedula', '$cargo', '$cuadrilla', '$fecha_emision', '$fecha_vencimiento')";

    if ($conexion->query($sql_insert)) {
        $mensaje = "Certificado de salud registrado exitosamente.";
    } else {
        $error = "Error al guardar el registro: " . $conexion->error;
    }
}

// Lógica para editar un certificado
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['editar_certificado'])) {
    $id_certificado = intval($_POST['id_certificado']);
    $nombre_personal = $conexion->real_escape_string($_POST['nombre_personal']);
    $cedula = $conexion->real_escape_string($_POST['cedula']);
    $cargo = $conexion->real_escape_string($_POST['cargo']);
    $cuadrilla = $conexion->real_escape_string($_POST['cuadrilla']);
    $fecha_emision = $_POST['fecha_emision'];
    $fecha_vencimiento = $_POST['fecha_vencimiento'];

    $sql_update = "UPDATE certificados_salud 
                   SET nombre_personal = '$nombre_personal', 
                       cedula = '$cedula', 
                       cargo = '$cargo', 
                       cuadrilla = '$cuadrilla',
                       fecha_emision = '$fecha_emision', 
                       fecha_vencimiento = '$fecha_vencimiento' 
                   WHERE id_certificado = $id_certificado";

    if ($conexion->query($sql_update)) {
        $mensaje = "Certificado actualizado exitosamente.";
    } else {
        $error = "Error al actualizar el registro: " . $conexion->error;
    }
}

// Lógica para eliminar un certificado
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['eliminar_certificado'])) {
    $id_certificado = intval($_POST['id_certificado']);

    $sql_delete = "DELETE FROM certificados_salud WHERE id_certificado = $id_certificado";

    if ($conexion->query($sql_delete)) {
        $mensaje = "Certificado eliminado exitosamente.";
    } else {
        $error = "Error al eliminar el registro: " . $conexion->error;
    }
}

// Consultar estadísticas de alertas
$sql_alertas = "SELECT 
    SUM(CASE WHEN fecha_vencimiento < CURDATE() THEN 1 ELSE 0 END) AS vencidos,
    SUM(CASE WHEN fecha_vencimiento BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY) THEN 1 ELSE 0 END) AS por_vencer
FROM certificados_salud";

$res_alertas = $conexion->query($sql_alertas);
$alertas = $res_alertas ? $res_alertas->fetch_assoc() : ['vencidos' => 0, 'por_vencer' => 0];

// Consultar todos los certificados
$sql_certificados = "SELECT * FROM certificados_salud ORDER BY fecha_vencimiento ASC";
$resultado = $conexion->query($sql_certificados);

$hoy = date('Y-m-d');
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>eCatering - Certificados de Salud</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
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
            <h2><i class="bi bi-card-checklist me-2"></i>Control de certificados de salud</h2>
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modalNuevoCertificado">
                <i class="bi bi-plus-lg me-1"></i> Nuevo certificado
            </button>
        </div>

        <!-- Banner de Alertas -->
        <?php if (($alertas['vencidos'] ?? 0) > 0 || ($alertas['por_vencer'] ?? 0) > 0): ?>
            <div class="alert alert-warning alert-dismissible fade show d-flex align-items-center shadow-sm" role="alert">
                <i class="bi bi-exclamation-triangle-fill fs-3 me-3 text-warning"></i>
                <div>
                    <h5 class="alert-heading mb-1 fw-bold">¡Atención requerida!</h5>
                    Hay <strong><?php echo $alertas['vencidos']; ?></strong> certificado(s) vencido(s) y 
                    <strong><?php echo $alertas['por_vencer']; ?></strong> próximo(s) a vencer en los próximos 30 días.
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <?php endif; ?>

        <?php if ($mensaje): ?>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i><?php echo $mensaje; ?>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <?php endif; ?>

        <?php if ($error): ?>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-x-circle-fill me-2"></i><?php echo $error; ?>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <?php endif; ?>

        <!-- Tabla de Certificados -->
        <div class="card border-0 shadow-sm">
            <div class="card-body p-0">
                <table class="table table-hover mb-0 align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>#</th>
                            <th>Nombre Completo</th>
                            <th>Cédula</th>
                            <th>Cargo</th>
                            <th>Cuadrilla</th>
                            <th>F. Emisión</th>
                            <th>F. Vencimiento</th>
                            <th>Estatus</th>
                            <th class="text-center">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php if ($resultado && $resultado->num_rows > 0): ?>
                            <?php while ($row = $resultado->fetch_assoc()): ?>
                                <?php 
                                    $vencimiento = $row['fecha_vencimiento'];
                                    $dias_restantes = (strtotime($vencimiento) - strtotime($hoy)) / (60 * 60 * 24);
                                    $cuadrilla_valor = isset($row['cuadrilla']) ? $row['cuadrilla'] : 'N/A';
                                ?>
                                <tr>
                                    <td><?php echo $row['id_certificado']; ?></td>
                                    <td class="fw-bold"><?php echo htmlspecialchars($row['nombre_personal']); ?></td>
                                    <td><?php echo htmlspecialchars($row['cedula']); ?></td>
                                    <td><?php echo htmlspecialchars($row['cargo']); ?></td>
                                    <td><span class="badge bg-secondary">Cuadrilla #<?php echo htmlspecialchars($cuadrilla_valor); ?></span></td>
                                    <td><?php echo date('d/m/Y', strtotime($row['fecha_emision'])); ?></td>
                                    <td><?php echo date('d/m/Y', strtotime($row['fecha_vencimiento'])); ?></td>
                                    <td>
                                        <?php if ($dias_restantes < 0): ?>
                                            <span class="badge bg-danger"><i class="bi bi-x-circle me-1"></i>Vencido</span>
                                        <?php elseif ($dias_restantes <= 30): ?>
                                            <span class="badge bg-warning text-dark"><i class="bi bi-exclamation-circle me-1"></i>Por Vencer (<?php echo round($dias_restantes); ?> días)</span>
                                        <?php else: ?>
                                            <span class="badge bg-success"><i class="bi bi-check-circle me-1"></i>Vigente</span>
                                        <?php endif; ?>
                                    </td>
                                    <td class="text-center">
                                        <button class="btn btn-sm btn-outline-primary me-1" 
                                                data-bs-toggle="modal" 
                                                data-bs-target="#modalEditarCertificado"
                                                onclick="cargarDatosEditar(
                                                    <?php echo $row['id_certificado']; ?>,
                                                    '<?php echo addslashes($row['nombre_personal']); ?>',
                                                    '<?php echo addslashes($row['cedula']); ?>',
                                                    '<?php echo addslashes($row['cargo']); ?>',
                                                    '<?php echo addslashes($cuadrilla_valor); ?>',
                                                    '<?php echo $row['fecha_emision']; ?>',
                                                    '<?php echo $row['fecha_vencimiento']; ?>'
                                                )">
                                            <i class="bi bi-pencil-square"></i>
                                        </button>
                                        <button class="btn btn-sm btn-outline-danger" 
                                                data-bs-toggle="modal" 
                                                data-bs-target="#modalEliminarCertificado"
                                                onclick="cargarDatosEliminar(
                                                    <?php echo $row['id_certificado']; ?>,
                                                    '<?php echo addslashes($row['nombre_personal']); ?>'
                                                )">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </td>
                                </tr>
                            <?php endwhile; ?>
                        <?php else: ?>
                            <tr>
                                <td colspan="9" class="text-center text-muted py-4">
                                    No hay certificados registrados.
                                </td>
                            </tr>
                        <?php endif; ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Modal Nuevo Certificado -->
    <div class="modal fade" id="modalNuevoCertificado" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form method="POST" action="">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title"><i class="bi bi-file-earmark-medical me-2"></i>Registrar Certificado de Salud</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Nombre Completo del Empleado</label>
                            <input type="text" name="nombre_personal" class="form-control" placeholder="Ej. Juan Pérez" required>
                        </div>
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-bold">Cédula</label>
                                <input type="text" name="cedula" class="form-control" placeholder="V-12345678" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-bold">Cargo</label>
                                <input type="text" name="cargo" class="form-control" placeholder="Cocinero..." required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-bold">Cuadrilla</label>
                                <input type="text" name="cuadrilla" class="form-control" placeholder="Ej. 1, 2, A" required>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Fecha de Emisión</label>
                                <input type="date" name="fecha_emision" class="form-control" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Fecha de Vencimiento</label>
                                <input type="date" name="fecha_vencimiento" class="form-control" required>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" name="agregar_certificado" class="btn btn-primary">Guardar Registro</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal Editar Certificado -->
    <div class="modal fade" id="modalEditarCertificado" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form method="POST" action="">
                    <input type="hidden" name="id_certificado" id="edit_id_certificado">
                    <div class="modal-header bg-warning text-dark">
                        <h5 class="modal-title"><i class="bi bi-pencil-square me-2"></i>Editar Certificado de Salud</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Nombre Completo del Empleado</label>
                            <input type="text" name="nombre_personal" id="edit_nombre_personal" class="form-control" required>
                        </div>
                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-bold">Cédula</label>
                                <input type="text" name="cedula" id="edit_cedula" class="form-control" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-bold">Cargo</label>
                                <input type="text" name="cargo" id="edit_cargo" class="form-control" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-bold">Cuadrilla</label>
                                <input type="text" name="cuadrilla" id="edit_cuadrilla" class="form-control" required>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Fecha de Emisión</label>
                                <input type="date" name="fecha_emision" id="edit_fecha_emision" class="form-control" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Fecha de Vencimiento</label>
                                <input type="date" name="fecha_vencimiento" id="edit_fecha_vencimiento" class="form-control" required>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" name="editar_certificado" class="btn btn-warning">Actualizar Registro</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal Eliminar Certificado -->
    <div class="modal fade" id="modalEliminarCertificado" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <form method="POST" action="">
                    <input type="hidden" name="id_certificado" id="delete_id_certificado">
                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title"><i class="bi bi-exclamation-triangle-fill me-2"></i>Confirmar Eliminación</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body text-center py-4">
                        <i class="bi bi-trash text-danger display-4 mb-3 d-block"></i>
                        <p class="fs-5 mb-1">¿Estás seguro de que deseas eliminar este registro?</p>
                        <p class="text-muted fw-bold" id="delete_nombre_personal"></p>
                        <small class="text-danger">Esta acción no se puede deshacer.</small>
                    </div>
                    <div class="modal-footer justify-content-center">
                        <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" name="eliminar_certificado" class="btn btn-danger px-4">Sí, Eliminar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function cargarDatosEditar(id, nombre, cedula, cargo, cuadrilla, emision, vencimiento) {
            document.getElementById('edit_id_certificado').value = id;
            document.getElementById('edit_nombre_personal').value = nombre;
            document.getElementById('edit_cedula').value = cedula;
            document.getElementById('edit_cargo').value = cargo;
            document.getElementById('edit_cuadrilla').value = cuadrilla;
            document.getElementById('edit_fecha_emision').value = emision;
            document.getElementById('edit_fecha_vencimiento').value = vencimiento;
        }

        function cargarDatosEliminar(id, nombre) {
            document.getElementById('delete_id_certificado').value = id;
            document.getElementById('delete_nombre_personal').innerText = nombre;
        }
    </script>
</body>
</html>