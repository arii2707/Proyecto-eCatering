 <?php

session_start();


if (!isset($_SESSION['id_usuario'])) {

    header("Location: index.php");

    exit();

}


require_once "config/conexion.php";


// 1. Alertas de Certificados de Salud (vencidos o por vencer en 30 días)

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
$sql_servicios_hoy = "SELECT SUM(total_comensales) AS total_hoy FROM servicios_catering WHERE fecha = '$fecha_hoy'";
$res_shoy = $conexion->query($sql_servicios_hoy);
$comensales_hoy = 0;
if ($res_shoy) {
    $row_sh = $res_shoy->fetch_assoc();
    $comensales_hoy = intval($row_sh['total_hoy']);
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

</head>

<body class="bg-light">

    <!-- Navegación -->

    <nav class="navbar navbar-expand-lg navbar-dark bg-primary px-4 shadow-sm">

        <a class="navbar-brand fw-bold" href="dashboard.php">eCatering System</a>

        <div class="ms-auto d-flex align-items-center text-white">

            <span class="me-3">Bienvenido, <strong><?php echo $_SESSION['nombre']; ?></strong> (<?php echo $_SESSION['rol']; ?>)</span>

           

            <a href="certificados.php" class="btn btn-outline-light btn-sm me-3 position-relative">

                <i class="bi bi-card-checklist me-1"></i> Certificados

                <?php if ($total_alertas > 0): ?>

                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">

                        <?php echo $total_alertas; ?>

                        <span class="visually-hidden">alertas</span>

                    </span>

                <?php endif; ?>

            </a>


            <a href="logout.php" class="btn btn-outline-light btn-sm">Cerrar Sesión</a>

        </div>

    </nav>


    <div class="container my-5">

        <h3 class="mb-4 text-secondary">Bienvenido al sistema de gestión eCatering</h3>

       

     <!-- Fila de Tarjetas del Dashboard -->
      <div class="row g-4 justify-content-center align-items-stretch">
        <!-- Tarjeta 1: Gestión de Inventario -->
         <div class="col-md-4">
            <div class="card border-0 shadow-sm h-100 text-center p-4">
                <div class="card-body d-flex flex-column p-0">
                    <div class="mb-3">
                        <h5 class="fw-bold text-dark mb-1">
                            <i class="bi bi-box-seam text-primary me-2"></i>Gestión de Inventario
                        </h5>
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
                        <a href="inventario.php" class="btn btn-primary px-4 w-50">Entrar</a>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Tarjeta 2: Certificados de Salud -->
         <div class="col-md-4">
            <div class="card border-0 shadow-sm h-100 text-center p-4">
                <div class="card-body d-flex flex-column p-0">
                    <div class="mb-3">
                        <h5 class="fw-bold text-dark mb-1">
                            <i class="bi bi-card-checklist text-primary me-2"></i>Certificados de Salud
                        </h5>
                        <p class="text-muted small mb-0">Control de fechas y estatus por cuadrillas del personal.</p>
                    </div>
                    
                    <div class="my-auto py-2">
                        <span class="badge bg-success px-3 py-2 fw-semibold">
                            <i class="bi bi-check-circle-fill me-1"></i> Todos vigentes
                        </span>
                    </div>
                    
                    <div class="mt-auto pt-3">
                        <a href="certificados.php" class="btn btn-primary px-4 w-50">Entrar</a>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Tarjeta 3: Servicios de Catering -->
         <div class="col-md-4">
            <div class="card border-0 shadow-sm h-100 text-center p-4">
                <div class="card-body d-flex flex-column p-0">
                    <div class="mb-3">
                        <h5 class="fw-bold text-dark mb-1">
                            <i class="bi bi-check2-square text-primary me-2"></i>Servicios de Catering
                        </h5>
                        <p class="text-muted small mb-0">Registro diario de servicios y cierres.</p>
                    </div>
                    
                    <div class="my-auto py-2">
                        <span class="badge bg-info text-dark px-3 py-2 fw-semibold">
                            <i class="bi bi-egg-fried me-1"></i> <?php echo $comensales_hoy; ?> comidas servidas hoy
                        </span>
                    </div>
                    
                    <div class="mt-auto pt-3">
                        <a href="servicio_diario.php" class="btn btn-primary px-4 w-50">Entrar</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>

</html>