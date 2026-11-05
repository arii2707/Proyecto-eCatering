<?php
session_start();
if (!isset($_SESSION['id_usuario'])) {
    header("Location: index.php");
    exit();
}

// RESTRICCIÓN DE ROL:
if (!isset($_SESSION['rol']) || $_SESSION['rol'] !== 'Coord.(a) catering') {
    header("Location: cierre_registros.php?error=acceso_denegado");
    exit();
}

require_once "config/conexion.php";


$mensaje = "";
$tipo_alerta = "";

// Validar que se reciba un ID válido
if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
    header("Location: cierre_registros.php");
    exit();
}

$id_servicio = intval($_GET['id']);

// Procesar el formulario cuando se envía (POST)
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $fecha = $conexion->real_escape_string($_POST['fecha']);
    $ubicacion = $conexion->real_escape_string($_POST['ubicacion_embarcacion']);
    
    // Servivio Cliente
    $d_cli = intval($_POST['desayunos_cliente']);
    $a_cli = intval($_POST['almuerzos_cliente']);
    $c_cli = intval($_POST['cenas_cliente']);
    $mn_cli = intval($_POST['cena_medianoche_cliente']);
    $al_cli = intval($_POST['alojamiento_cliente']);

    // Servicio Servicio
    $d_ser = intval($_POST['desayunos_servicio']);
    $a_ser = intval($_POST['almuerzos_servicio']);
    $c_ser = intval($_POST['cenas_servicio']);
    $mn_ser = intval($_POST['cena_medianoche_servicio']);
    $al_ser = intval($_POST['alojamiento_servicio']);

    // Servicio Maritime
    $d_mar = intval($_POST['desayunos_maritime']);
    $a_mar = intval($_POST['almuerzos_maritime']);
    $c_mar = intval($_POST['cenas_maritime']);
    $mn_mar = intval($_POST['cena_medianoche_maritime']);
    $al_mar = intval($_POST['alojamiento_maritime']);

    $observaciones = $conexion->real_escape_string($_POST['observaciones']);
    $usuario_modifico = $conexion->real_escape_string($_SESSION['nombre']);

    $sql_update = "UPDATE servicios_catering SET 
                    fecha = '$fecha',
                    ubicacion_embarcacion = '$ubicacion',
                    desayunos_cliente = $d_cli, almuerzos_cliente = $a_cli, cenas_cliente = $c_cli, cena_medianoche_cliente = $mn_cli, alojamiento_cliente = $al_cli,
                    desayunos_servicio = $d_ser, almuerzos_servicio = $a_ser, cenas_servicio = $c_ser, cena_medianoche_servicio = $mn_ser, alojamiento_servicio = $al_ser,
                    desayunos_maritime = $d_mar, almuerzos_maritime = $a_mar, cenas_maritime = $c_mar, cena_medianoche_maritime = $mn_mar, alojamiento_maritime = $al_mar,
                    observaciones = '$observaciones',
                    usuario_registro = '$usuario_modifico'
                   WHERE id_servicio = $id_servicio";

    if ($conexion->query($sql_update)) {
        header("Location: cierre_registros.php?mensaje=editado");
        exit();
    } else {
        $mensaje = "Error al actualizar el registro: " . $conexion->error;
        $tipo_alerta = "danger";
    }
}

// Obtener datos actuales del registro
$sql = "SELECT * FROM servicios_catering WHERE id_servicio = $id_servicio";
$resultado = $conexion->query($sql);

if (!$resultado || $resultado->num_rows === 0) {
    header("Location: cierre_registros.php");
    exit();
}

$registro = $resultado->fetch_assoc();
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>eCatering - Editar Registro #<?php echo $id_servicio; ?></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">
    <!-- Navegación -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary px-4 shadow-sm">
        <a class="navbar-brand fw-bold" href="dashboard.php">eCatering System</a>
        <div class="ms-auto d-flex align-items-center text-white">
            <span class="me-3"><strong><?php echo $_SESSION['nombre']; ?></strong></span>
            <a href="cierre_registros.php" class="btn btn-outline-light btn-sm me-2">Volver al Historial</a>
            <a href="logout.php" class="btn btn-outline-light btn-sm">Cerrar Sesión</a>
        </div>
    </nav>

    <div class="container my-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 class="fw-bold text-primary mb-0">
                <i class="bi bi-pencil-square me-2"></i>Editar Registro de Servicio #<?php echo $id_servicio; ?>
            </h4>
            <a href="cierre_registros.php" class="btn btn-secondary btn-sm">
                <i class="bi bi-arrow-left me-1"></i> Cancelar
            </a>
        </div>

        <?php if (!empty($mensaje)): ?>
            <div class="alert alert-<?php echo $tipo_alerta; ?> alert-dismissible fade show" role="alert">
                <?php echo $mensaje; ?>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <?php endif; ?>

        <form method="POST" action="">
            <!-- Encabezado del Registro -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Fecha del Servicio</label>
                            <input type="date" name="fecha" class="form-control" value="<?php echo $registro['fecha']; ?>" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Ubicación / Embarcación</label>
                            <input type="text" name="ubicacion_embarcacion" class="form-control" value="<?php echo htmlspecialchars($registro['ubicacion_embarcacion']); ?>" required>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Bloques de Personal -->
            <div class="row g-4 mb-4">
                <!-- Personal Cliente -->
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-header bg-primary text-white fw-bold">Personal Cliente</div>
                        <div class="card-body">
                            <div class="mb-2"><label class="form-label">Desayunos</label><input type="number" name="desayunos_cliente" class="form-control" value="<?php echo $registro['desayunos_cliente']; ?>" min="0"></div>
                            <div class="mb-2"><label class="form-label">Almuerzos</label><input type="number" name="almuerzos_cliente" class="form-control" value="<?php echo $registro['almuerzos_cliente']; ?>" min="0"></div>
                            <div class="mb-2"><label class="form-label">Cenas</label><input type="number" name="cenas_cliente" class="form-control" value="<?php echo $registro['cenas_cliente']; ?>" min="0"></div>
                            <div class="mb-2"><label class="form-label">Cena Medianoche</label><input type="number" name="cena_medianoche_cliente" class="form-control" value="<?php echo $registro['cena_medianoche_cliente']; ?>" min="0"></div>
                            <div class="mb-2"><label class="form-label">Alojamiento</label><input type="number" name="alojamiento_cliente" class="form-control" value="<?php echo $registro['alojamiento_cliente']; ?>" min="0"></div>
                        </div>
                    </div>
                </div>

                <!-- Personal Servicio -->
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-header bg-info text-dark fw-bold">Personal Servicio</div>
                        <div class="card-body">
                            <div class="mb-2"><label class="form-label">Desayunos</label><input type="number" name="desayunos_servicio" class="form-control" value="<?php echo $registro['desayunos_servicio']; ?>" min="0"></div>
                            <div class="mb-2"><label class="form-label">Almuerzos</label><input type="number" name="almuerzos_servicio" class="form-control" value="<?php echo $registro['almuerzos_servicio']; ?>" min="0"></div>
                            <div class="mb-2"><label class="form-label">Cenas</label><input type="number" name="cenas_servicio" class="form-control" value="<?php echo $registro['cenas_servicio']; ?>" min="0"></div>
                            <div class="mb-2"><label class="form-label">Cena Medianoche</label><input type="number" name="cena_medianoche_servicio" class="form-control" value="<?php echo $registro['cena_medianoche_servicio']; ?>" min="0"></div>
                            <div class="mb-2"><label class="form-label">Alojamiento</label><input type="number" name="alojamiento_servicio" class="form-control" value="<?php echo $registro['alojamiento_servicio']; ?>" min="0"></div>
                        </div>
                    </div>
                </div>

                <!-- Personal Maritime -->
                <div class="col-md-4">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-header bg-secondary text-white fw-bold">Personal Maritime</div>
                        <div class="card-body">
                            <div class="mb-2"><label class="form-label">Desayunos</label><input type="number" name="desayunos_maritime" class="form-control" value="<?php echo $registro['desayunos_maritime']; ?>" min="0"></div>
                            <div class="mb-2"><label class="form-label">Almuerzos</label><input type="number" name="almuerzos_maritime" class="form-control" value="<?php echo $registro['almuerzos_maritime']; ?>" min="0"></div>
                            <div class="mb-2"><label class="form-label">Cenas</label><input type="number" name="cenas_maritime" class="form-control" value="<?php echo $registro['cenas_maritime']; ?>" min="0"></div>
                            <div class="mb-2"><label class="form-label">Cena Medianoche</label><input type="number" name="cena_medianoche_maritime" class="form-control" value="<?php echo $registro['cena_medianoche_maritime']; ?>" min="0"></div>
                            <div class="mb-2"><label class="form-label">Alojamiento</label><input type="number" name="alojamiento_maritime" class="form-control" value="<?php echo $registro['alojamiento_maritime']; ?>" min="0"></div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Observaciones y Guardar -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-body">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Observaciones</label>
                        <textarea name="observaciones" class="form-control" rows="3"><?php echo htmlspecialchars($registro['observaciones']); ?></textarea>
                    </div>
                    <div class="d-flex justify-content-end gap-2">
                        <a href="cierre_registros.php" class="btn btn-outline-secondary">Cancelar</a>
                        <button type="submit" class="btn btn-success fw-bold">
                            <i class="bi bi-floppy-fill me-1"></i> Guardar Cambios
                        </button>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>