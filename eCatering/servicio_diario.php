<?php
session_start();
if (!isset($_SESSION['id_usuario'])) {
    header("Location: index.php");
    exit();
}

require_once "config/conexion.php";

$mensaje = "";
$error = "";

// Lógica para guardar el registro diario
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['guardar_servicio'])) {
    $fecha =$_POST['fecha'];
    $ubicacion =$conexion->real_escape_string($_POST['ubicacion_embarcacion']);$observaciones = $conexion->real_escape_string($_POST['observaciones']);

    // Tarifas unitarias del día
    $tarifa_alim = floatval($_POST['tarifa_alimentacion']);
    $tarifa_aloj = floatval($_POST['tarifa_alojamiento']);

    // Cliente
    $d_cli = intval($_POST['desayunos_cliente']);
    $a_cli = intval($_POST['almuerzos_cliente']);
    $c_cli = intval($_POST['cenas_cliente']);
    $mn_cli = intval($_POST['cena_medianoche_cliente']);
    $al_cli = intval($_POST['alojamiento_cliente']);

    // Empresa de Servicio
    $d_ser = intval($_POST['desayunos_servicio']);
    $a_ser = intval($_POST['almuerzos_servicio']);
    $c_ser = intval($_POST['cenas_servicio']);
    $mn_ser = intval($_POST['cena_medianoche_servicio']);
    $al_ser = intval($_POST['alojamiento_servicio']);

    // Maritime
    $d_mar = intval($_POST['desayunos_maritime']);
    $a_mar = intval($_POST['almuerzos_maritime']);
    $c_mar = intval($_POST['cenas_maritime']);
    $mn_mar = intval($_POST['cena_medianoche_maritime']);
    $al_mar = intval($_POST['alojamiento_maritime']);

    // Menús Aplicados
    $m_desayuno = $conexion->real_escape_string($_POST['menu_desayuno']);
    $m_almuerzo =$conexion->real_escape_string($_POST['menu_almuerzo']);$m_cena = $conexion->real_escape_string($_POST['menu_cena']);
    $m_medianoche =$conexion->real_escape_string($_POST['menu_medianoche']);$usuario_actual = $conexion->real_escape_string($_SESSION['nombre']);

    $sql = "INSERT INTO servicios_catering 
            (fecha, ubicacion_embarcacion, tarifa_alimentacion, tarifa_alojamiento,
             desayunos_cliente, almuerzos_cliente, cenas_cliente, cena_medianoche_cliente, alojamiento_cliente,
             desayunos_servicio, almuerzos_servicio, cenas_servicio, cena_medianoche_servicio, alojamiento_servicio,
             desayunos_maritime, almuerzos_maritime, cenas_maritime, cena_medianoche_maritime, alojamiento_maritime,
             menu_desayuno, menu_almuerzo, menu_cena, menu_medianoche,
             observaciones, usuario_registro)
            VALUES 
            ('$fecha', '$ubicacion',$tarifa_alim, $tarifa_aloj,$d_cli, $a_cli,$c_cli, $mn_cli,$al_cli,
             $d_ser,$a_ser, $c_ser,$mn_ser, $al_ser,$d_mar, $a_mar,$c_mar, $mn_mar,$al_mar,
             '$m_desayuno', '$m_almuerzo', '$m_cena', '$m_medianoche',
             '$observaciones', '$usuario_actual')";

    if ($conexion->query($sql)) {$mensaje = "¡Servicio, tarifas y menús registrados exitosamente!";
    } else {
        $error = "Error al registrar el servicio: " . $conexion->error;
    }
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>eCatering - Registro Diario de Servicio</title>
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
        <!-- Submenú de Navegación del Módulo -->
        <ul class="nav nav-tabs mb-4">
            <li class="nav-item">
                <a class="nav-link active fw-bold" href="servicio_diario.php">
                    <i class="bi bi-pencil-square me-1"></i> Registro de Servicios
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="cierre_registros.php">
                    <i class="bi bi-archive-fill me-1"></i> Cierre de Registros
                </a>
            </li>
        </ul>

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

        <form method="POST" action="">
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-white py-3">
                    <h5 class="card-title fw-bold mb-0 text-primary">
                        <i class="bi bi-calendar-event me-2"></i>Datos Operativos y Tarifas del Día
                    </h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3 mb-3">
                            <label class="form-label fw-bold">Fecha del Servicio</label>
                            <input type="date" name="fecha" class="form-control" value="<?php echo date('Y-m-d'); ?>" required>
                        </div>
                        <div class="col-md-5 mb-3">
                            <label class="form-label fw-bold">Ubicación / Embarcación</label>
                            <input type="text" name="ubicacion_embarcacion" class="form-control" placeholder="Ej. Gabarra M-501 / Lago de Maracaibo" required>
                        </div>
                        <div class="col-md-2 mb-3">
                            <label class="form-label fw-bold text-success">Tarifa Alimentación</label>
                            <input type="number" step="0.01" min="0" name="tarifa_alimentacion" class="form-control" value="0$" required>
                        </div>
                        <div class="col-md-2 mb-3">
                            <label class="form-label fw-bold text-success">Tarifa Alojamiento</label>
                            <input type="number" step="0.01" min="0" name="tarifa_alojamiento" class="form-control" value="0$" required>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Matriz de Conteo por Grupos -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-dark text-white py-3">
                    <h5 class="card-title fw-bold mb-0">
                        <i class="bi bi-table me-2"></i>Servicio y Alojamiento por Grupos
                    </h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-bordered align-middle text-center mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th class="text-start ps-3" style="width: 25%;">Grupo / Personal</th>
                                    <th>Desayunos</th>
                                    <th>Almuerzos</th>
                                    <th>Cenas</th>
                                    <th>Cena M. Noche</th>
                                    <th>Alojamiento</th>
                                    <th class="table-secondary">Total Raciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <!-- Fila CLIENTE -->
                                <tr>
                                    <td class="fw-bold text-start ps-3 text-warning">CLIENTE</td>
                                    <td><input type="number" min="0" name="desayunos_cliente" class="form-control text-center calc-input cli-r" value="0" oninput="calcularTotales()"></td>
                                    <td><input type="number" min="0" name="almuerzos_cliente" class="form-control text-center calc-input cli-r" value="0" oninput="calcularTotales()"></td>
                                    <td><input type="number" min="0" name="cenas_cliente" class="form-control text-center calc-input cli-r" value="0" oninput="calcularTotales()"></td>
                                    <td><input type="number" min="0" name="cena_medianoche_cliente" class="form-control text-center calc-input cli-r" value="0" oninput="calcularTotales()"></td>
                                    <td><input type="number" min="0" name="alojamiento_cliente" class="form-control text-center calc-input" value="0" oninput="calcularTotales()"></td>
                                    <td class="fw-bold bg-light" id="total_cliente">0</td>
                                </tr>
                                <!-- Fila EMPRESA DE SERVICIO -->
                                <tr>
                                    <td class="fw-bold text-start ps-3 text-success">EMPRESA DE SERVICIO</td>
                                    <td><input type="number" min="0" name="desayunos_servicio" class="form-control text-center calc-input ser-r" value="0" oninput="calcularTotales()"></td>
                                    <td><input type="number" min="0" name="almuerzos_servicio" class="form-control text-center calc-input ser-r" value="0" oninput="calcularTotales()"></td>
                                    <td><input type="number" min="0" name="cenas_servicio" class="form-control text-center calc-input ser-r" value="0" oninput="calcularTotales()"></td>
                                    <td><input type="number" min="0" name="cena_medianoche_servicio" class="form-control text-center calc-input ser-r" value="0" oninput="calcularTotales()"></td>
                                    <td><input type="number" min="0" name="alojamiento_servicio" class="form-control text-center calc-input" value="0" oninput="calcularTotales()"></td>
                                    <td class="fw-bold bg-light" id="total_servicio">0</td>
                                </tr>
                                <!-- Fila MARITIME -->
                                <tr>
                                    <td class="fw-bold text-start ps-3 text-primary">MARITIME</td>
                                    <td><input type="number" min="0" name="desayunos_maritime" class="form-control text-center calc-input mar-r" value="0" oninput="calcularTotales()"></td>
                                    <td><input type="number" min="0" name="almuerzos_maritime" class="form-control text-center calc-input mar-r" value="0" oninput="calcularTotales()"></td>
                                    <td><input type="number" min="0" name="cenas_maritime" class="form-control text-center calc-input mar-r" value="0" oninput="calcularTotales()"></td>
                                    <td><input type="number" min="0" name="cena_medianoche_maritime" class="form-control text-center calc-input mar-r" value="0" oninput="calcularTotales()"></td>
                                    <td><input type="number" min="0" name="alojamiento_maritime" class="form-control text-center calc-input" value="0" oninput="calcularTotales()"></td>
                                    <td class="fw-bold bg-light" id="total_maritime">0</td>
                                </tr>
                            </tbody>
                            <tfoot class="table-secondary fw-bold">
                                <tr>
                                    <td class="text-start ps-3">TOTAL GENERAL</td>
                                    <td id="tot_desayunos">0</td>
                                    <td id="tot_almuerzos">0</td>
                                    <td id="tot_cenas">0</td>
                                    <td id="tot_medianoche">0</td>
                                    <td id="tot_alojamiento">0</td>
                                    <td class="table-primary text-primary fs-5" id="gran_total">0</td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Sección de Menús Aplicados -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-secondary text-white py-3">
                    <h5 class="card-title fw-bold mb-0">
                        <i class="bi bi-journal-text me-2"></i>Menús Aplicados del Día
                    </h5>
                </div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label fw-bold text-dark"><i class="bi bi-brightness-high me-1"></i> Menú Desayuno</label>
                            <textarea name="menu_desayuno" class="form-control" rows="2" placeholder="Ej: Opción 1: Arepas con perico..."></textarea>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold text-dark"><i class="bi bi-sun me-1"></i> Menú Almuerzo</label>
                            <textarea name="menu_almuerzo" class="form-control" rows="2" placeholder="Ej: Sopa de res, Pollo frito..."></textarea>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold text-dark"><i class="bi bi-moon-stars me-1"></i> Menú Cena</label>
                            <textarea name="menu_cena" class="form-control" rows="2" placeholder="Ej: Carne desmechada..."></textarea>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold text-dark"><i class="bi bi-clock-history me-1"></i> Menú Media Noche</label>
                            <textarea name="menu_medianoche" class="form-control" rows="2" placeholder="Ej: Arepitas asadas..."></textarea>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Observaciones y Guardar -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-body">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Observaciones</label>
                        <textarea name="observaciones" class="form-control" rows="3" placeholder="Ingresa detalles sobre demoras, visitas adicionales..."></textarea>
                    </div>
                    <div class="d-flex justify-content-end">
                        <button type="submit" name="guardar_servicio" class="btn btn-primary px-4 fw-bold">
                            <i class="bi bi-check-circle-fill me-1"></i> Guardar Registro con Tarifas
                        </button>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function calcularTotales() {
            let sumRow = (className) => {
                let inputs = document.querySelectorAll(className);
                let total = 0;
                inputs.forEach(i => total += parseInt(i.value) || 0);
                return total;
            };

            let totCli = sumRow('.cli-r');
            let totSer = sumRow('.ser-r');
            let totMar = sumRow('.mar-r');

            document.getElementById('total_cliente').innerText = totCli;
            document.getElementById('total_servicio').innerText = totSer;
            document.getElementById('total_maritime').innerText = totMar;

            let sumCol = (name) => {
                let inputs = document.querySelectorAll(`input[name*="${name}"]`);
                let total = 0;
                inputs.forEach(i => total += parseInt(i.value) || 0);
                return total;
            };

            let d = sumCol('desayunos');
            let a = sumCol('almuerzos');
            let c = sumCol('cenas');
            let mn = sumCol('cena_medianoche');
            let al = sumCol('alojamiento');

            document.getElementById('tot_desayunos').innerText = d;
            document.getElementById('tot_almuerzos').innerText = a;
            document.getElementById('tot_cenas').innerText = c;
            document.getElementById('tot_medianoche').innerText = mn;
            document.getElementById('tot_alojamiento').innerText = al;

            document.getElementById('gran_total').innerText = d + a + c + mn;
        }
    </script>
</body>
</html>