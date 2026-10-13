<?php
session_start();
if (!isset($_SESSION['id_usuario'])) {
    header("Location: index.php");
    exit();
}

require_once "config/conexion.php";

// Consultas de resumen estadístico
$sql_total = "SELECT COUNT(*) AS total FROM inventario";
$sql_disponibles = "SELECT COUNT(*) AS disponibles FROM inventario WHERE estado = 'disponible'";
$sql_por_agotarse = "SELECT COUNT(*) AS por_agotarse FROM inventario WHERE estado = 'por agotarse'";
$sql_agotados = "SELECT COUNT(*) AS agotados FROM inventario WHERE estado = 'agotado'";

$total_items = $conexion->query($sql_total)->fetch_assoc()['total'] ?? 0;
$total_disponibles = $conexion->query($sql_disponibles)->fetch_assoc()['disponibles'] ?? 0;
$total_por_agotarse = $conexion->query($sql_por_agotarse)->fetch_assoc()['por_agotarse'] ?? 0;
$total_agotados = $conexion->query($sql_agotados)->fetch_assoc()['agotados'] ?? 0;

// Consulta de insumos que requieren atención (Agotados y Por Agotarse)
$sql_criticos = "SELECT * FROM inventario WHERE estado IN ('por agotarse', 'agotado') ORDER BY cantidad ASC";
$res_criticos = $conexion->query($sql_criticos);
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>eCatering - Alertas de Stock</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary px-4 shadow-sm">
        <a class="navbar-brand fw-bold" href="dashboard.php">eCatering System</a>
        <div class="ms-auto d-flex align-items-center text-white">
            <span class="me-3"><strong><?php echo $_SESSION['nombre']; ?></strong></span>
            <a href="dashboard.php" class="btn btn-outline-light btn-sm me-2">Volver al Panel</a>
            <a href="logout.php" class="btn btn-outline-light btn-sm">Cerrar Sesión</a>
        </div>
    </nav>

    <div class="container my-4">
        <!-- Encabezado -->
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3 class="fw-bold text-primary mb-0"><i class="bi bi-box-seam me-2"></i>Módulo de Inventario</h3>
        </div>

        <!-- Submenú -->
        <ul class="nav nav-tabs mb-4">
            <li class="nav-item">
                <a class="nav-link" href="inventario.php">
                    <i class="bi bi-list-check me-1"></i> Maestro de Artículos / Existencias
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link active fw-bold" href="reporte_existencias.php">
                    <i class="bi bi-file-earmark-bar-graph me-1"></i> Resumen / Alertas de Stock
                </a>
            </li>
        </ul>

        <!-- Tarjetas de Indicadores (KPIs) -->
        <div class="row g-3 mb-4">
            <div class="col-md-3">
                <div class="card border-0 shadow-sm border-start border-primary border-4">
                    <div class="card-body">
                        <span class="text-muted small fw-bold">Total Insumos Registrados</span>
                        <h3 class="fw-bold text-primary mb-0"><?php echo number_format($total_items); ?></h3>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm border-start border-success border-4">
                    <div class="card-body">
                        <span class="text-muted small fw-bold">Stock Suficiente</span>
                        <h3 class="fw-bold text-success mb-0"><?php echo number_format($total_disponibles); ?></h3>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm border-start border-warning border-4">
                    <div class="card-body">
                        <span class="text-muted small fw-bold">Por Agotarse (Bajo Mínimo)</span>
                        <h3 class="fw-bold text-warning mb-0"><?php echo number_format($total_por_agotarse); ?></h3>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border-0 shadow-sm border-start border-danger border-4">
                    <div class="card-body">
                        <span class="text-muted small fw-bold">Insumos Agotados (0 Stock)</span>
                        <h3 class="fw-bold text-danger mb-0"><?php echo number_format($total_agotados); ?></h3>
                    </div>
                </div>
            </div>
        </div>

        <!-- Tabla de Alertas Críticas -->
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3">
                <h5 class="fw-bold text-danger mb-0">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>Insumos Que Requieren Reposición Inmediata
                </h5>
            </div>
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-dark">
                            <tr>
                                <th>Código</th>
                                <th>Insumo</th>
                                <th>Categoría</th>
                                <th>Existencia Actual</th>
                                <th>Stock Mínimo</th>
                                <th>Estatus</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if ($res_criticos && $res_criticos->num_rows > 0): ?>
                                <?php while ($row = $res_criticos->fetch_assoc()): ?>
                                    <tr>
                                        <td><code><?php echo htmlspecialchars($row['codigo'] ?? 'N/A'); ?></code></td>
                                        <td class="fw-bold"><?php echo htmlspecialchars($row['nombre_insumo']); ?></td>
                                        <td><span class="badge bg-secondary"><?php echo htmlspecialchars($row['categoria']); ?></span></td>
                                        <td class="fw-bold text-danger fs-6"><?php echo number_format($row['cantidad'], 2) . ' ' . htmlspecialchars($row['unidad_medida']); ?></td>
                                        <td><?php echo number_format($row['stock_minimo'], 2) . ' ' . htmlspecialchars($row['unidad_medida']); ?></td>
                                        <td>
                                            <?php if ($row['estado'] === 'por agotarse'): ?>
                                                <span class="badge bg-warning text-dark"><i class="bi bi-exclamation-triangle me-1"></i> Por Agotarse</span>
                                            <?php else: ?>
                                                <span class="badge bg-danger"><i class="bi bi-x-circle me-1"></i> Agotado</span>
                                            <?php endif; ?>
                                        </td>
                                    </tr>
                                <?php endwhile; ?>
                            <?php else: ?>
                                <tr>
                                    <td colspan="6" class="text-center text-success py-4 fw-bold">
                                        <i class="bi bi-check-circle-fill me-2 fs-5"></i> ¡Todo en orden! No hay insumos agotados ni en stock crítico.
                                    </td>
                                </tr>
                            <?php endif; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>