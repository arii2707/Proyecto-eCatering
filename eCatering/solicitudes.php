<?php
session_start();
if (!isset($_SESSION['id_usuario'])) {
    header("Location: index.php");
    exit();
}

require_once "config/conexion.php";

// 1. Lógica para registrar un nuevo pedido con Proveedor
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['agregar_pedido'])) {
    $codigo = "PED-" . date('Ymd') . "-" . rand(100, 999);
    $ubicacion = $conexion->real_escape_string($_POST['ubicacion_embarcacion']);
    $proveedor = $conexion->real_escape_string($_POST['proveedor']);
    $fecha_entrega = $_POST['fecha_entrega'];
    $estado_solicitud = $conexion->real_escape_string($_POST['estado_solicitud']);

    $rubros = $_POST['prod_rubro'] ?? [];
    $productos = $_POST['prod_nombre'] ?? [];
    $empaques = $_POST['prod_empaque'] ?? [];
    $contenidos = $_POST['prod_contenido'] ?? [];
    $cantidades = $_POST['prod_cant'] ?? [];
    $precios = $_POST['prod_precio'] ?? [];

    $lista_items = [];
    // Guardamos el Proveedor en la primera línea descriptiva o en las notas
    for ($i = 0; $i < count($productos); $i++) {
        $p_rub = trim($rubros[$i] ?? 'General');
        $p_nom = trim($productos[$i]);
        $p_emp = trim($empaques[$i] ?? 'Unid');
        $p_cnt = trim($contenidos[$i] ?? '');
        $p_cant = floatval($cantidades[$i] ?? 1);
        $p_prec = floatval($precios[$i] ?? 0);
        
        if (!empty($p_nom)) {
            $lista_items[] = "$p_rub | $p_nom | $p_emp | $p_cnt | $p_cant | $p_prec";
        }
    }

    // Encabezado interno con Proveedor
    $observaciones_final = "PROVEEDOR: " . $proveedor . "\n" . implode("\n", $lista_items);
    $observaciones_esc = $conexion->real_escape_string($observaciones_final);

    $sql_insert = "INSERT INTO solicitudes_catering (codigo_solicitud, ubicacion_embarcacion, fecha_solicitud, fecha_entrega, estado_solicitud, observaciones) 
                   VALUES ('$codigo', '$ubicacion', NOW(), '$fecha_entrega', '$estado_solicitud', '$observaciones_esc')";

    if ($conexion->query($sql_insert)) {
        if (function_exists('registrarLog')) {
            registrarLog($conexion, $_SESSION['id_usuario'], 'Nuevo Pedido Catering', "Se registró el pedido $codigo para $ubicacion (Proveedor: $proveedor)");
        }
        header("Location: solicitudes.php?mensaje=guardado");
        exit();
    } else {
        $error = "Error al registrar el pedido: " . $conexion->error;
    }
}

// 2. Lógica para cambiar estado o cancelar pedido
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['actualizar_estado'])) {
    $id_solicitud = intval($_POST['id_solicitud']);
    $nuevo_estado =$conexion->real_escape_string($_POST['estado_solicitud']);$observaciones = $conexion->real_escape_string($_POST['observaciones']);

    $sql_update = "UPDATE solicitudes_catering SET estado_solicitud = '$nuevo_estado', observaciones = '$observaciones' WHERE id_solicitud =$id_solicitud";

    if ($conexion->query($sql_update)) {
        if (function_exists('registrarLog')) {
            registrarLog($conexion,$_SESSION['id_usuario'], 'Cambio Estado Pedido', "Pedido ID #$id_solicitud actualizado a estado:$nuevo_estado");
        }
        header("Location: solicitudes.php?mensaje=actualizado");
        exit();
    } else {
        $error = "Error al actualizar el pedido: " . $conexion->error;
    }
}

// 3. Eliminar pedido
if (isset($_GET['eliminar'])) {
    $id_eliminar = intval($_GET['eliminar']);
    if ($conexion->query("DELETE FROM solicitudes_catering WHERE id_solicitud = $id_eliminar")) {
        if (function_exists('registrarLog')) {
            registrarLog($conexion,$_SESSION['id_usuario'], 'Eliminación Pedido', "Se eliminó el pedido ID #$id_eliminar");
        }
        header("Location: solicitudes.php?mensaje=eliminado");
        exit();
    }
}

// Filtros y Búsqueda (Incluye Proveedor)
$busqueda = isset($_GET['buscar']) ? $conexion->real_escape_string(trim($_GET['buscar'])) : '';
$filtro_estado = isset($_GET['filtro_estado']) ? $conexion->real_escape_string($_GET['filtro_estado']) : '';
$fecha_desde = isset($_GET['fecha_desde']) ? $_GET['fecha_desde'] : '';$fecha_hasta = isset($_GET['fecha_hasta']) ?$_GET['fecha_hasta'] : '';

$conditions = [];
if ($busqueda != '') {$conditions[] = "(codigo_solicitud LIKE '%$busqueda%' OR ubicacion_embarcacion LIKE '%$busqueda%' OR observaciones LIKE '%$busqueda%')";
}
if ($filtro_estado != '') {
    $conditions[] = "estado_solicitud = '$filtro_estado'";
}
if (!empty($fecha_desde) && !empty($fecha_hasta)) {$conditions[] = "DATE(fecha_solicitud) BETWEEN '$fecha_desde' AND '$fecha_hasta'";
}

$where_sql = count($conditions) > 0 ? "WHERE " . implode(" AND ", $conditions) : "";
$sql_pedidos = "SELECT * FROM solicitudes_catering $where_sql ORDER BY fecha_solicitud DESC";
$resultado = $conexion->query($sql_pedidos);
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>eCatering - Gestión de Pedidos y Proveedores</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">

    <!-- Navegación -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary px-4 shadow-sm">
        <a class="navbar-brand fw-bold" href="dashboard.php">eCatering System</a>
        <div class="ms-auto d-flex align-items-center text-white">
            <span class="me-3"><strong><?php echo htmlspecialchars($_SESSION['nombre']); ?></strong></span>
            <a href="dashboard.php" class="btn btn-outline-light btn-sm me-2">
                <i class="bi bi-speedometer2 me-1"></i>Volver al Panel
            </a>
            <a href="logout.php" class="btn btn-outline-light btn-sm">
                <i class="bi bi-box-arrow-right me-1"></i>Cerrar Sesión
            </a>
        </div>
    </nav>

    <div class="container-fluid px-4 my-4">
        <!-- Encabezado -->
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
            <div>
                <h3 class="fw-bold text-primary mb-1">
                    <i class="bi bi-cart-check me-2"></i>Gestión de Pedidos y Proveedores
                </h3>
                <p class="text-muted small mb-0">Control de órdenes por embarcación, asignación de proveedor y emisión de PDF.</p>
            </div>
            <button class="btn btn-primary shadow-sm fw-bold px-3" data-bs-toggle="modal" data-bs-target="#modalNuevoPedido">
                <i class="bi bi-plus-circle me-1"></i> Realizar Nuevo Pedido
            </button>
        </div>

        <!-- Alertas -->
        <?php if (isset($_GET['mensaje'])): ?>
            <?php if ($_GET['mensaje'] === 'guardado'): ?>
                <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i> Pedido y proveedor registrados con éxito.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <?php elseif ($_GET['mensaje'] === 'actualizado'): ?>
                <div class="alert alert-info alert-dismissible fade show shadow-sm" role="alert">
                    <i class="bi bi-info-circle-fill me-2"></i> Estado actualizado.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <?php elseif ($_GET['mensaje'] === 'eliminado'): ?>
                <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                    <i class="bi bi-trash-fill me-2"></i> Pedido eliminado.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <?php endif; ?>
        <?php endif; ?>

        <!-- BARRA DE BÚSQUEDA Y FILTROS -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-body bg-white rounded">
                <form method="GET" action="" class="row g-3 align-items-end">
                    <div class="col-md-3">
                        <label class="form-label fw-bold small text-secondary">Buscar Pedido / Proveedor / Destino</label>
                        <div class="input-group input-group-sm">
                            <span class="input-group-text"><i class="bi bi-search"></i></span>
                            <input type="text" name="buscar" class="form-control" placeholder="Nº Pedido, Proveedor, Destino..." value="<?php echo htmlspecialchars($busqueda); ?>">
                        </div>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label fw-bold small text-secondary">Estado</label>
                        <select name="filtro_estado" class="form-select form-select-sm">
                            <option value="">Todos los Estados</option>
                            <option value="Pendiente" <?php echo $filtro_estado == 'Pendiente' ? 'selected' : ''; ?>>Pendiente</option>
                            <option value="En Proceso" <?php echo $filtro_estado == 'En Proceso' ? 'selected' : ''; ?>>En Preparación</option>
                            <option value="Despachado" <?php echo $filtro_estado == 'Despachado' ? 'selected' : ''; ?>>Despachado</option>
                            <option value="Cancelado" <?php echo $filtro_estado == 'Cancelado' ? 'selected' : ''; ?>>Cancelado</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label fw-bold small text-secondary">Fecha Desde</label>
                        <input type="date" name="fecha_desde" class="form-control form-control-sm" value="<?php echo $fecha_desde; ?>">
                    </div>
                    <div class="col-md-2">
                        <label class="form-label fw-bold small text-secondary">Fecha Hasta</label>
                        <input type="date" name="fecha_hasta" class="form-control form-control-sm" value="<?php echo $fecha_hasta; ?>">
                    </div>
                    <div class="col-md-3 d-flex gap-2">
                        <button type="submit" class="btn btn-primary btn-sm fw-bold w-100 shadow-sm"><i class="bi bi-funnel me-1"></i> Filtrar</button>
                        <a href="solicitudes.php" class="btn btn-outline-secondary btn-sm w-100">Limpiar</a>
                    </div>
                </form>
            </div>
        </div>

        <!-- TABLA PRINCIPAL DE PEDIDOS -->
        <div class="card border-0 shadow-sm">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-dark">
                            <tr>
                                <th>Nº Pedido</th>
                                <th>Embarcación / Destino</th>
                                <th>Proveedor / Notas</th>
                                <th>F. Requerida</th>
                                <th>Estado / Alerta</th>
                                <th class="text-center">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if ($resultado &&$resultado->num_rows > 0): ?>
                                <?php 
                                $hoy = date('Y-m-d');
                                while ($row = $resultado->fetch_assoc()):$es_atrasado = ($row['fecha_entrega'] <$hoy && $row['estado_solicitud'] != 'Despachado' &&$row['estado_solicitud'] != 'Cancelado');
                                ?>
                                    <tr class="<?php echo $es_atrasado ? 'table-danger' : ''; ?>">
                                        <td><span class="badge bg-secondary px-2 py-1"><?php echo htmlspecialchars($row['codigo_solicitud']); ?></span></td>
                                        <td class="fw-bold text-primary"><i class="bi bi-geo-alt me-1"></i><?php echo htmlspecialchars($row['ubicacion_embarcacion']); ?></td>
                                        <td class="small text-dark" style="max-width: 280px; white-space: pre-line;"><?php echo $row['observaciones'] ? htmlspecialchars($row['observaciones']) : '<em>Sin detalles</em>'; ?></td>
                                        <td><span class="badge bg-light text-dark border"><i class="bi bi-calendar-event me-1"></i><?php echo date('d/m/Y', strtotime($row['fecha_entrega'])); ?></span></td>
                                        <td>
                                            <?php if ($es_atrasado): ?>
                                                <span class="badge bg-danger text-white shadow-sm"><i class="bi bi-exclamation-triangle-fill me-1"></i> ATRASADO</span>
                                            <?php elseif ($row['estado_solicitud'] == 'Pendiente'): ?>
                                                <span class="badge bg-warning text-dark"><i class="bi bi-clock me-1"></i>Pendiente</span>
                                            <?php elseif ($row['estado_solicitud'] == 'En Proceso'): ?>
                                                <span class="badge bg-info text-dark"><i class="bi bi-arrow-repeat me-1"></i>En Preparación</span>
                                            <?php elseif ($row['estado_solicitud'] == 'Despachado'): ?>
                                                <span class="badge bg-success"><i class="bi bi-check2-circle me-1"></i>Despachado</span>
                                            <?php elseif ($row['estado_solicitud'] == 'Cancelado'): ?>
                                                <span class="badge bg-secondary"><i class="bi bi-x-circle me-1"></i>Cancelado</span>
                                            <?php endif; ?>
                                        </td>
                                        <td class="text-center">
                                            <div class="d-flex justify-content-center gap-1">
                                                <a href="generar_pedido_pdf.php?id=<?php echo $row['id_solicitud']; ?>" target="_blank" class="btn btn-sm btn-outline-danger fw-bold shadow-sm" title="PDF Desglosado">
                                                    <i class="bi bi-file-earmark-pdf-fill me-1"></i> PDF
                                                </a>
                                                <?php if ($row['estado_solicitud'] != 'Cancelado' &&$row['estado_solicitud'] != 'Despachado'): ?>
                                                    <button class="btn btn-sm btn-warning fw-bold shadow-sm" data-bs-toggle="modal" data-bs-target="#modalEditarEstado" data-id="<?php echo $row['id_solicitud']; ?>" data-estado="<?php echo $row['estado_solicitud']; ?>" data-obs="<?php echo htmlspecialchars($row['observaciones']); ?>"><i class="bi bi-pencil-square"></i></button>
                                                    <button class="btn btn-sm btn-outline-danger fw-bold" data-bs-toggle="modal" data-bs-target="#modalConfirmarCancelar" data-id="<?php echo $row['id_solicitud']; ?>" data-codigo="<?php echo htmlspecialchars($row['codigo_solicitud']); ?>"><i class="bi bi-x-circle"></i></button>
                                                <?php endif; ?>
                                            </div>
                                        </td>
                                    </tr>
                                <?php endwhile; ?>
                            <?php else: ?>
                                <tr>
                                    <td colspan="6" class="text-center text-muted py-5"><i class="bi bi-inbox fs-2 d-block mb-2 text-secondary"></i> No hay pedidos registrados.</td>
                                </tr>
                            <?php endif; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL: NUEVO PEDIDO CON PROVEEDOR -->
    <div class="modal fade" id="modalNuevoPedido" tabindex="-1">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <form method="POST" action="">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title fw-bold"><i class="bi bi-cart-plus me-2"></i>Realizar Nuevo Pedido con Proveedor</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body row g-3">
                        <div class="col-md-5">
                            <label class="form-label fw-bold">Embarcación / Punto Destino</label>
                            <input type="text" name="ubicacion_embarcacion" class="form-control" placeholder="Ej. Gabarra M-101 / Muelle Principal" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-bold"><i class="bi bi-truck me-1"></i> Proveedor Asignado</label>
                            <input type="text" name="proveedor" class="form-control" placeholder="Ej. Distribuidora Marítima C.A." required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-bold">Fecha Requerida</label>
                            <input type="date" name="fecha_entrega" class="form-control" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-bold">Estado Inicial</label>
                            <select name="estado_solicitud" class="form-select" required>
                                <option value="Pendiente">Pendiente</option>
                                <option value="En Proceso">En Preparación</option>
                                <option value="Despachado">Despachado</option>
                            </select>
                        </div>

                        <!-- TABLA INTERACTIVA -->
                        <div class="col-12 mt-4">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <label class="form-label fw-bold text-primary mb-0"><i class="bi bi-diagram-3 me-1"></i> Desglose de Insumos y Alimentos</label>
                                <button type="button" class="btn btn-sm btn-success fw-bold" onclick="agregarFilaRubro()">
                                    <i class="bi bi-plus-lg me-1"></i> Añadir Insumo
                                </button>
                            </div>
                            <div class="table-responsive border rounded">
                                <table class="table table-bordered table-sm mb-0 align-middle">
                                    <thead class="table-light">
                                        <tr>
                                            <th style="width: 22%;">Rubro</th>
                                            <th>Producto / Alimento</th>
                                            <th style="width: 14%;">Presentación</th>
                                            <th style="width: 15%;">Capacidad / Ref.</th>
                                            <th style="width: 10%;">Cant.</th>
                                            <th style="width: 14%;">Precio ($)</th>
                                            <th style="width: 6%;" class="text-center">Acción</th>
                                        </tr>
                                    </thead>
                                    <tbody id="bodyRubros">
                                        <tr>
                                            <td>
                                                <select name="prod_rubro[]" class="form-select form-select-sm" required>
                                                    <option value="Proteínas y Carnes">Proteínas y Carnes</option>
                                                    <option value="Víveres Secos y Granos">Víveres Secos y Granos</option>
                                                    <option value="Frutas y Verduras">Frutas y Verduras</option>
                                                    <option value="Lácteos y Charcutería">Lácteos y Charcutería</option>
                                                    <option value="Aceites y Grasas">Aceites y Grasas</option>
                                                    <option value="Bebidas y Líquidos">Bebidas y Líquidos</option>
                                                    <option value="Artículos de Limpieza">Artículos de Limpieza</option>
                                                </select>
                                            </td>
                                            <td><input type="text" name="prod_nombre[]" class="form-control form-control-sm" placeholder="Ej. Aceite Vegetal" required></td>
                                            <td>
                                                <select name="prod_empaque[]" class="form-select form-select-sm" required>
                                                    <option value="Cuñete">Cuñete</option>
                                                    <option value="Bulto">Bulto</option>
                                                    <option value="Caja">Caja</option>
                                                    <option value="Cesta">Cesta</option>
                                                    <option value="Saco">Saco</option>
                                                    <option value="Kg Directo">Kg Directo</option>
                                                    <option value="Unid">Unidad</option>
                                                </select>
                                            </td>
                                            <td><input type="text" name="prod_contenido[]" class="form-control form-control-sm" placeholder="Ej. 18 Lts"></td>
                                            <td><input type="number" step="1" min="1" name="prod_cant[]" class="form-control form-control-sm" placeholder="1" required></td>
                                            <td><input type="number" step="0.01" name="prod_precio[]" class="form-control form-control-sm" placeholder="40.00" required></td>
                                            <td class="text-center"><button type="button" class="btn btn-sm btn-outline-danger" onclick="eliminarFilaRubro(this)"><i class="bi bi-trash"></i></button></td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" name="agregar_pedido" class="btn btn-primary fw-bold"><i class="bi bi-check-lg me-1"></i> Guardar Pedido</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- MODAL EDITAR ESTADO -->
    <div class="modal fade" id="modalEditarEstado" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form method="POST" action="">
                    <input type="hidden" name="actualizar_estado" value="1">
                    <input type="hidden" name="id_solicitud" id="edit_id_solicitud">
                    <div class="modal-header bg-warning text-dark">
                        <h5 class="modal-title fw-bold"><i class="bi bi-gear-fill me-2"></i>Actualizar Estado</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body row g-3">
                        <div class="col-12">
                            <label class="form-label fw-bold">Estado</label>
                            <select name="estado_solicitud" id="edit_estado" class="form-select" required>
                                <option value="Pendiente">Pendiente</option>
                                <option value="En Proceso">En Preparación</option>
                                <option value="Despachado">Despachado</option>
                            </select>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-bold">Notas u Observaciones</label>
                            <textarea name="observaciones" id="edit_observaciones" class="form-control" rows="4"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-warning fw-bold">Guardar Cambios</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- MODAL CANCELAR -->
    <div class="modal fade" id="modalConfirmarCancelar" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <form method="POST" action="">
                    <input type="hidden" name="actualizar_estado" value="1">
                    <input type="hidden" name="id_solicitud" id="cancel_id_solicitud">
                    <input type="hidden" name="estado_solicitud" value="Cancelado">
                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title fw-bold"><i class="bi bi-exclamation-triangle-fill me-2"></i>Confirmar Cancelación</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body text-center py-4">
                        <p class="fs-5 mb-2">¿Cancelar el pedido <strong id="cancel_codigo_pedido" class="text-danger"></strong>?</p>
                        <textarea name="observaciones" class="form-control mt-3" placeholder="Motivo de la cancelación..." required></textarea>
                    </div>
                    <div class="modal-footer justify-content-center">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Regresar</button>
                        <button type="submit" class="btn btn-danger fw-bold">Cancelar Pedido</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function agregarFilaRubro() {
            const body = document.getElementById('bodyRubros');
            const nuevaFila = document.createElement('tr');
            nuevaFila.innerHTML = `
                <td>
                    <select name="prod_rubro[]" class="form-select form-select-sm" required>
                        <option value="Proteínas y Carnes">Proteínas y Carnes</option>
                        <option value="Víveres Secos y Granos">Víveres Secos y Granos</option>
                        <option value="Frutas y Verduras">Frutas y Verduras</option>
                        <option value="Lácteos y Charcutería">Lácteos y Charcutería</option>
                        <option value="Aceites y Grasas">Aceites y Grasas</option>
                        <option value="Bebidas y Líquidos">Bebidas y Líquidos</option>
                        <option value="Artículos de Limpieza">Artículos de Limpieza</option>
                    </select>
                </td>
                <td><input type="text" name="prod_nombre[]" class="form-control form-control-sm" placeholder="Producto" required></td>
                <td>
                    <select name="prod_empaque[]" class="form-select form-select-sm" required>
                        <option value="Cuñete">Cuñete</option>
                        <option value="Bulto">Bulto</option>
                        <option value="Caja">Caja</option>
                        <option value="Cesta">Cesta</option>
                        <option value="Saco">Saco</option>
                        <option value="Kg Directo">Kg Directo</option>
                        <option value="Unid">Unidad</option>
                    </select>
                </td>
                <td><input type="text" name="prod_contenido[]" class="form-control form-control-sm" placeholder="Capacidad"></td>
                <td><input type="number" step="1" min="1" name="prod_cant[]" class="form-control form-control-sm" placeholder="1" required></td>
                <td><input type="number" step="0.01" name="prod_precio[]" class="form-control form-control-sm" placeholder="0.00" required></td>
                <td class="text-center"><button type="button" class="btn btn-sm btn-outline-danger" onclick="eliminarFilaRubro(this)"><i class="bi bi-trash"></i></button></td>
            `;
            body.appendChild(nuevaFila);
        }

        function eliminarFilaRubro(btn) {
            const body = document.getElementById('bodyRubros');
            if (body.childElementCount > 1) {
                btn.closest('tr').remove();
            } else {
                alert("El pedido debe contener al menos un insumo.");
            }
        }

        const modalEditar = document.getElementById('modalEditarEstado');
        if (modalEditar) {
            modalEditar.addEventListener('show.bs.modal', function (event) {
                const button = event.relatedTarget;
                document.getElementById('edit_id_solicitud').value = button.getAttribute('data-id');
                document.getElementById('edit_estado').value = button.getAttribute('data-estado');
                document.getElementById('edit_observaciones').value = button.getAttribute('data-obs');
            });
        }

        const modalCancelar = document.getElementById('modalConfirmarCancelar');
        if (modalCancelar) {
            modalCancelar.addEventListener('show.bs.modal', function (event) {
                const button = event.relatedTarget;
                document.getElementById('cancel_id_solicitud').value = button.getAttribute('data-id');
                document.getElementById('cancel_codigo_pedido').textContent = button.getAttribute('data-codigo');
            });
        }
    </script>
</body>
</html>