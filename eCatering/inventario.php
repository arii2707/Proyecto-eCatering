<?php
session_start();
if (!isset($_SESSION['id_usuario'])) {
    header("Location: index.php");
    exit();
}

require_once "config/conexion.php";

// Función auxiliar con las mayúsculas exactas del ENUM de la base de datos
function calcularEstado($cantidad, $stock_minimo) {
    if ($cantidad <= 0) {
        return 'Agotado';
    } elseif ($cantidad <= $stock_minimo) {
        return 'Por Agotarse';
    } else {
        return 'Disponible';
    }
}

// Determinar qué pestaña está activa (por defecto el maestro)
$seccion = $_GET['sec'] ?? 'maestro';

// INICIALIZAR TODAS LAS VARIABLES POR DEFECTO PARA EVITAR ERRORES
$res_inv = null;
$lista_productos = null;
$historial_salidas = null;
$historial_entradas = null;

// ACTUALIZACIÓN GLOBAL DE ESTATUS AL CARGAR
$res_estatus = $conexion->query("SELECT id_producto, cantidad, stock_minimo FROM inventario");
if ($res_estatus) {
    while ($prod = $res_estatus->fetch_assoc()) {
        $nuevo_estado = calcularEstado($prod['cantidad'], $prod['stock_minimo']);
        $conexion->query("UPDATE inventario SET estado = '$nuevo_estado' WHERE id_producto = " . $prod['id_producto']);
    }
}

// 1. Guardar Nuevo Insumo (Manual)
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['accion']) && $_POST['accion'] === 'guardar_insumo') {
    $nombre       = $conexion->real_escape_string($_POST['nombre_insumo']);
    $categoria    = $conexion->real_escape_string($_POST['categoria']);
    $unidad       = $conexion->real_escape_string($_POST['unidad_medida']);
    $cantidad     = floatval(str_replace([' ', ','], ['', '.'], $_POST['cantidad_inicial']));
    $stock_minimo = floatval(str_replace([' ', ','], ['', '.'], $_POST['stock_minimo']));
    $estado       = calcularEstado($cantidad, $stock_minimo);

    $sql_insert = "INSERT INTO inventario (nombre_insumo, categoria, cantidad, unidad_medida, stock_minimo, estado) 
                    VALUES ('$nombre', '$categoria', $cantidad, '$unidad', $stock_minimo, '$estado')";
    
    if ($conexion->query($sql_insert)) {
        header("Location: inventario.php?sec=maestro&mensaje=guardado");
        exit();
    }
}

// 2. Editar / Actualizar Insumo (Manual)
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['accion']) && $_POST['accion'] === 'editar_insumo') {
    $id_producto  = intval($_POST['id_producto']);
    $nombre       = $conexion->real_escape_string($_POST['nombre_insumo']);
    $categoria    = $conexion->real_escape_string($_POST['categoria']);
    $unidad       = $conexion->real_escape_string($_POST['unidad_medida']);
    $cantidad     = floatval(str_replace([' ', ','], ['', '.'], $_POST['cantidad']));
    $stock_minimo = floatval(str_replace([' ', ','], ['', '.'], $_POST['stock_minimo']));
    $estado       = calcularEstado($cantidad, $stock_minimo);

    $sql_update = "UPDATE inventario SET 
                    nombre_insumo = '$nombre', 
                    categoria = '$categoria', 
                    cantidad = $cantidad, 
                    unidad_medida = '$unidad', 
                    stock_minimo = $stock_minimo, 
                    estado = '$estado' 
                   WHERE id_producto = $id_producto";
    
    if ($conexion->query($sql_update)) {
        header("Location: inventario.php?sec=maestro&mensaje=editado");
        exit();
    }
}

// 3. Eliminar Insumo
if (isset($_GET['eliminar'])) {
    $id_producto = intval($_GET['eliminar']);
    $sql_delete = "DELETE FROM inventario WHERE id_producto = $id_producto";
    
    if ($conexion->query($sql_delete)) {
        header("Location: inventario.php?sec=maestro&mensaje=eliminado");
        exit();
    }
}

// 4. Registrar Salida de Insumos (PEPS)
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['accion']) && $_POST['accion'] === 'registrar_salida') {
    $id_producto       = intval($_POST['id_producto']);
    $cantidad_salida   = floatval($_POST['cantidad_salida']);
    $ubicacion_destino = $conexion->real_escape_string($_POST['ubicacion_destino']);
    $observaciones     = $conexion->real_escape_string($_POST['observaciones']);
    $id_usuario        = $_SESSION['id_usuario'];

    if ($cantidad_salida <= 0) {
        $error_salida = "La cantidad a retirar debe ser mayor a cero.";
    } else {
        $conexion->begin_transaction();
        try {
            $sql_stk = "SELECT cantidad, stock_minimo, nombre_insumo, unidad_medida FROM inventario WHERE id_producto = $id_producto FOR UPDATE";
            $res_stk = $conexion->query($sql_stk);
            
            if ($res_stk && $res_stk->num_rows > 0) {
                $prod_data = $res_stk->fetch_assoc();
                $stock_actual = floatval($prod_data['cantidad']);

                if ($cantidad_salida > $stock_actual) {
                    throw new Exception("Stock insuficiente. Disponible actual para '{$prod_data['nombre_insumo']}': $stock_actual {$prod_data['unidad_medida']}.");
                }

                $nueva_cantidad = $stock_actual - $cantidad_salida;
                $nuevo_estado = calcularEstado($nueva_cantidad, floatval($prod_data['stock_minimo']));

                $sql_ins_salida = "INSERT INTO salidas_insumos (id_producto, cantidad_salida, ubicacion_destino, fecha_salida, id_usuario, observaciones) 
                                   VALUES ($id_producto, $cantidad_salida, '$ubicacion_destino', NOW(), $id_usuario, '$observaciones')";
                if (!$conexion->query($sql_ins_salida)) {
                    throw new Exception("Error al registrar el movimiento: " . $conexion->error);
                }

                $sql_upd_inv = "UPDATE inventario SET cantidad = $nueva_cantidad, estado = '$nuevo_estado' WHERE id_producto = $id_producto";
                if (!$conexion->query($sql_upd_inv)) {
                    throw new Exception("Error al actualizar el stock: " . $conexion->error);
                }

                $conexion->commit();
                header("Location: inventario.php?sec=salidas&mensaje=salida_exito");
                exit();
            } else {
                throw new Exception("El producto seleccionado no existe.");
            }
        } catch (Exception $e) {
            $conexion->rollback();
            $error_salida = $e->getMessage();
        }
    }
}

// 5. Registrar Entrada / Reabastecimiento de Insumos
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['accion']) && $_POST['accion'] === 'registrar_entrada') {
    $id_producto       = intval($_POST['id_producto']);
    $cantidad_entrada  = floatval($_POST['cantidad_entrada']);
    $proveedor         = $conexion->real_escape_string($_POST['proveedor']);
    $num_factura_orden = $conexion->real_escape_string($_POST['num_factura_orden']);
    $fecha_vencimiento = !empty($_POST['fecha_vencimiento']) ? "'" . $conexion->real_escape_string($_POST['fecha_vencimiento']) . "'" : "NULL";
    $observaciones     = $conexion->real_escape_string($_POST['observaciones']);
    $id_usuario        = $_SESSION['id_usuario'];

    if ($cantidad_entrada <= 0) {
        $error_entrada = "La cantidad ingresada debe ser mayor a cero.";
    } else {
        $conexion->begin_transaction();
        try {
            $sql_stk = "SELECT cantidad, stock_minimo FROM inventario WHERE id_producto = $id_producto FOR UPDATE";
            $res_stk = $conexion->query($sql_stk);

            if ($res_stk && $res_stk->num_rows > 0) {
                $prod_data = $res_stk->fetch_assoc();
                $stock_actual = floatval($prod_data['cantidad']);

                $nueva_cantidad = $stock_actual + $cantidad_entrada;
                $nuevo_estado   = calcularEstado($nueva_cantidad, floatval($prod_data['stock_minimo']));

                // Insertar en historial de entradas
                $sql_ins_entrada = "INSERT INTO entradas_insumos (id_producto, cantidad, proveedor, num_factura_orden, fecha_vencimiento, fecha_entrada, id_usuario, observaciones) 
                                    VALUES ($id_producto, $cantidad_entrada, '$proveedor', '$num_factura_orden', $fecha_vencimiento, NOW(), $id_usuario, '$observaciones')";
                if (!$conexion->query($sql_ins_entrada)) {
                    throw new Exception("Error al registrar el reabastecimiento: " . $conexion->error);
                }

                // Actualizar stock y estado en inventario
                $sql_upd_inv = "UPDATE inventario SET cantidad = $nueva_cantidad, estado = '$nuevo_estado' WHERE id_producto = $id_producto";
                if (!$conexion->query($sql_upd_inv)) {
                    throw new Exception("Error al actualizar el stock maestro: " . $conexion->error);
                }

                $conexion->commit();
                header("Location: inventario.php?sec=entradas&mensaje=entrada_exito");
                exit();
            } else {
                throw new Exception("El producto seleccionado no existe.");
            }
        } catch (Exception $e) {
            $conexion->rollback();
            $error_entrada = $e->getMessage();
        }
    }
}

// 6. Importar Inventario desde CSV
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['accion']) && $_POST['accion'] === 'importar_csv') {
    if (isset($_FILES['archivo_csv']) && $_FILES['archivo_csv']['error'] === UPLOAD_ERR_OK) {
        $archivo = $_FILES['archivo_csv']['tmp_name'];
        if (($gestor = fopen($archivo, "r")) !== FALSE) {
            fgetcsv($gestor, 1000, ","); 
            while (($datos = fgetcsv($gestor, 1000, ",")) !== FALSE) {
                if (count($datos) >= 5) {
                    $nombre    = trim($datos[0]);
                    $categoria = trim($datos[1]);
                    $unidad    = trim($datos[3]);
                    $cant_raw  = str_replace([' ', ','], ['', '.'], trim($datos[2]));
                    $stock_raw = str_replace([' ', ','], ['', '.'], trim($datos[4]));

                    $cantidad     = floatval($cant_raw);
                    $stock_minimo = floatval($stock_raw);

                    if (empty($nombre)) continue;

                    $nombre_ins = $conexion->real_escape_string($nombre);
                    $cat_ins    = $conexion->real_escape_string($categoria);
                    $uni_ins    = $conexion->real_escape_string($unidad);
                    $estado     = calcularEstado($cantidad, $stock_minimo);

                    $sql_insert = "INSERT INTO inventario (nombre_insumo, categoria, cantidad, unidad_medida, stock_minimo, estado) 
                                    VALUES ('$nombre_ins', '$cat_ins', $cantidad, '$uni_ins', $stock_minimo, '$estado')";
                    $conexion->query($sql_insert);
                }
            }
            fclose($gestor);
            header("Location: inventario.php?sec=maestro&mensaje=importado_exito");
            exit();
        }
    }
}

// Consultas y Filtros según la pestaña activa
$res_categorias = $conexion->query("SELECT DISTINCT categoria FROM inventario WHERE categoria IS NOT NULL AND categoria != '' ORDER BY categoria ASC");
$buscar = $_GET['buscar'] ?? '';
$categoria_filtro = $_GET['categoria'] ?? '';

if ($seccion == 'maestro') {
    $donde = "WHERE 1=1";
    if (!empty($buscar)) {
        $b_clean = $conexion->real_escape_string($buscar);
        $donde .= " AND nombre_insumo LIKE '%$b_clean%'";
    }
    if (!empty($categoria_filtro)) {
        $c_clean = $conexion->real_escape_string($categoria_filtro);
        $donde .= " AND categoria = '$c_clean'";
    }
    $res_inv = $conexion->query("SELECT * FROM inventario $donde ORDER BY nombre_insumo ASC");
} elseif ($seccion == 'resumen') {
    $res_inv = $conexion->query("SELECT * FROM inventario WHERE cantidad <= stock_minimo ORDER BY cantidad ASC");
} elseif ($seccion == 'salidas') {
    $lista_productos = $conexion->query("SELECT id_producto, nombre_insumo, cantidad, unidad_medida FROM inventario ORDER BY nombre_insumo ASC");
    $historial_salidas = $conexion->query("SELECT s.*, i.nombre_insumo, i.unidad_medida, u.nombre AS usuario_nombre 
                                          FROM salidas_insumos s 
                                          INNER JOIN inventario i ON s.id_producto = i.id_producto 
                                          INNER JOIN usuarios u ON s.id_usuario = u.id_usuario 
                                          ORDER BY s.fecha_salida DESC LIMIT 15");
} elseif ($seccion == 'entradas') {
    $lista_productos = $conexion->query("SELECT id_producto, nombre_insumo, cantidad, unidad_medida FROM inventario ORDER BY nombre_insumo ASC");
    $historial_entradas = $conexion->query("SELECT e.*, i.nombre_insumo, i.unidad_medida, u.nombre AS usuario_nombre 
                                           FROM entradas_insumos e 
                                           INNER JOIN inventario i ON e.id_producto = i.id_producto 
                                           INNER JOIN usuarios u ON e.id_usuario = u.id_usuario 
                                           ORDER BY e.fecha_entrada DESC LIMIT 15");
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>eCatering - Gestión de Inventario</title>
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
        <!-- Encabezado y Botones de Acción Global -->
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3 class="fw-bold text-primary mb-0"><i class="bi bi-box-seam me-2"></i>Gestión de Inventario</h3>
            <div class="d-flex gap-2">
                <button class="btn btn-success shadow-sm" data-bs-toggle="modal" data-bs-target="#modalImportarExcel">
                    <i class="bi bi-file-earmark-excel me-1"></i> Importar
                </button>
                <button class="btn btn-primary shadow-sm" data-bs-toggle="modal" data-bs-target="#modalNuevoInsumo">
                    <i class="bi bi-plus-lg me-1"></i> Nuevo Producto
                </button>
            </div>
        </div>

        <!-- Submenú de Pestañas Unificadas -->
        <ul class="nav nav-tabs mb-4">
            <li class="nav-item">
                <a class="nav-link <?php echo ($seccion == 'maestro') ? 'active fw-bold' : ''; ?>" href="inventario.php?sec=maestro">
                    <i class="bi bi-list-check me-1"></i> Maestro de Artículos / Existencias
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <?php echo ($seccion == 'resumen') ? 'active fw-bold' : ''; ?>" href="inventario.php?sec=resumen">
                    <i class="bi bi-file-earmark-bar-graph me-1"></i> Resumen / Alertas de Stock
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <?php echo ($seccion == 'entradas') ? 'active fw-bold' : ''; ?>" href="inventario.php?sec=entradas">
                    <i class="bi bi-arrow-down-left-circle-fill me-1 text-success"></i> Entrada de Insumos
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <?php echo ($seccion == 'salidas') ? 'active fw-bold' : ''; ?>" href="inventario.php?sec=salidas">
                    <i class="bi bi-arrow-up-right-circle-fill me-1 text-danger"></i> Salida de Insumos
                </a>
            </li>
        </ul>

        <!-- Mensajes de Alerta -->
        <?php if (isset($_GET['mensaje'])): ?>
            <?php if ($_GET['mensaje'] === 'guardado'): ?>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i> Insumo registrado correctamente.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <?php elseif ($_GET['mensaje'] === 'editado'): ?>
                <div class="alert alert-info alert-dismissible fade show" role="alert">
                    <i class="bi bi-pencil-square me-2"></i> Insumo actualizado correctamente.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <?php elseif ($_GET['mensaje'] === 'eliminado'): ?>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-trash-fill me-2"></i> Insumo eliminado del inventario correctamente.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <?php elseif ($_GET['mensaje'] === 'importado_exito'): ?>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i> ¡Inventario importado con éxito!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <?php elseif ($_GET['mensaje'] === 'salida_exito'): ?>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i> ¡Salida de insumo registrada con éxito y stock actualizado!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <?php elseif ($_GET['mensaje'] === 'entrada_exito'): ?>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i> ¡Entrada de insumo registrada correctamente y stock reabastecido!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <?php endif; ?>
        <?php endif; ?>

        <?php if (isset($error_salida)): ?>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-octagon-fill me-2"></i> <?php echo $error_salida; ?>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <?php endif; ?>

        <?php if (isset($error_entrada)): ?>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-octagon-fill me-2"></i> <?php echo $error_entrada; ?>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <?php endif; ?>

        <!-- CONTENIDO DE CADA PESTAÑA -->
        <?php if ($seccion == 'maestro'): ?>
            <!-- Filtro de Búsqueda -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-body">
                    <form method="GET" action="inventario.php" class="row g-2 align-items-center">
                        <input type="hidden" name="sec" value="maestro">
                        <div class="col-md-5">
                            <input type="text" name="buscar" class="form-control" placeholder="Buscar por nombre del insumo..." value="<?php echo htmlspecialchars($buscar); ?>">
                        </div>
                        <div class="col-md-4">
                            <select name="categoria" class="form-select">
                                <option value="">-- Todas las Categorías --</option>
                                <?php if ($res_categorias && $res_categorias->num_rows > 0): ?>
                                    <?php while ($cat = $res_categorias->fetch_assoc()): ?>
                                        <option value="<?php echo htmlspecialchars($cat['categoria']); ?>" <?php echo ($categoria_filtro === $cat['categoria']) ? 'selected' : ''; ?>>
                                            <?php echo htmlspecialchars($cat['categoria']); ?>
                                        </option>
                                    <?php endwhile; ?>
                                <?php endif; ?>
                            </select>
                        </div>
                        <div class="col-md-3 d-flex gap-2">
                            <button type="submit" class="btn btn-primary w-100"><i class="bi bi-search me-1"></i> Filtrar</button>
                            <a href="inventario.php?sec=maestro" class="btn btn-outline-secondary" title="Limpiar Filtros"><i class="bi bi-arrow-counterclockwise"></i></a>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Tabla Maestro -->
            <div class="card border-0 shadow-sm">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-dark">
                                <tr>
                                    <th>#ID</th>
                                    <th>Nombre del Insumo</th>
                                    <th>Categoría</th>
                                    <th>Existencia</th>
                                    <th>Unidad</th>
                                    <th>Stock Mínimo</th>
                                    <th>Estatus Stock</th>
                                    <th class="text-center">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php if ($res_inv && $res_inv->num_rows > 0): ?>
                                    <?php while ($row = $res_inv->fetch_assoc()): ?>
                                        <tr>
                                            <td><strong><?php echo $row['id_producto']; ?></strong></td>
                                            <td class="fw-bold"><?php echo htmlspecialchars($row['nombre_insumo']); ?></td>
                                            <td><span class="badge bg-secondary"><?php echo htmlspecialchars($row['categoria']); ?></span></td>
                                            <td class="fs-6 fw-bold"><?php echo number_format($row['cantidad'], 2); ?></td>
                                            <td><?php echo htmlspecialchars($row['unidad_medida']); ?></td>
                                            <td><?php echo number_format($row['stock_minimo'], 2); ?></td>
                                            <td>
                                                <?php if ($row['estado'] === 'Disponible'): ?>
                                                    <span class="badge bg-success"><i class="bi bi-check-circle me-1"></i> Disponible</span>
                                                <?php elseif ($row['estado'] === 'Por Agotarse'): ?>
                                                    <span class="badge bg-warning text-dark"><i class="bi bi-exclamation-triangle me-1"></i> Por Agotarse</span>
                                                <?php else: ?>
                                                    <span class="badge bg-danger"><i class="bi bi-x-circle me-1"></i> Agotado</span>
                                                <?php endif; ?>
                                            </td>
                                            <td class="text-center">
                                                <div class="d-flex justify-content-center gap-1">
                                                    <button class="btn btn-warning btn-sm fw-bold shadow-sm" 
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#modalEditarInsumo"
                                                            data-id="<?php echo $row['id_producto']; ?>"
                                                            data-nombre="<?php echo htmlspecialchars($row['nombre_insumo']); ?>"
                                                            data-categoria="<?php echo htmlspecialchars($row['categoria']); ?>"
                                                            data-cantidad="<?php echo $row['cantidad']; ?>"
                                                            data-unidad="<?php echo htmlspecialchars($row['unidad_medida']); ?>"
                                                            data-stock="<?php echo $row['stock_minimo']; ?>">
                                                        <i class="bi bi-pencil-square"></i>
                                                    </button>
                                                    <a href="inventario.php?eliminar=<?php echo $row['id_producto']; ?>" 
                                                       class="btn btn-danger btn-sm shadow-sm" 
                                                       onclick="return confirm('¿Estás segura de que deseas eliminar este insumo?');"
                                                       title="Eliminar Insumo">
                                                        <i class="bi bi-trash-fill"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    <?php endwhile; ?>
                                <?php else: ?>
                                    <tr><td colspan="8" class="text-center text-muted py-4">No hay productos registrados en el inventario.</td></tr>
                                <?php endif; ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        <?php elseif ($seccion == 'resumen'): ?>
            <!-- Pestaña Resumen / Alertas -->
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white py-3">
                    <h5 class="fw-bold text-secondary mb-0"><i class="bi bi-exclamation-triangle text-warning me-2"></i>Artículos con Stock Bajo o por Agotarse</h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0 text-center">
                            <thead class="table-light">
                                <tr>
                                    <th class="text-start">Insumo</th>
                                    <th>Stock Actual</th>
                                    <th>Stock Mínimo Requerido</th>
                                    <th>Unidad</th>
                                    <th>Estado</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php if ($res_inv && $res_inv->num_rows > 0): ?>
                                    <?php while ($row = $res_inv->fetch_assoc()): ?>
                                        <tr>
                                            <td class="text-start fw-bold"><?php echo htmlspecialchars($row['nombre_insumo']); ?></td>
                                            <td class="fw-bold text-danger"><?php echo number_format($row['cantidad'], 2); ?></td>
                                            <td><?php echo number_format($row['stock_minimo'], 2); ?></td>
                                            <td><?php echo htmlspecialchars($row['unidad_medida']); ?></td>
                                            <td>
                                                <?php if ($row['estado'] === 'Agotado'): ?>
                                                    <span class="badge bg-danger">Agotado</span>
                                                <?php else: ?>
                                                    <span class="badge bg-warning text-dark">Por Agotarse</span>
                                                <?php endif; ?>
                                            </td>
                                        </tr>
                                    <?php endwhile; ?>
                                <?php else: ?>
                                    <tr><td colspan="5" class="py-4 text-success fw-bold"><i class="bi bi-check-circle me-1"></i> ¡Excelente! No hay alertas de stock bajo en este momento.</td></tr>
                                <?php endif; ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        <?php elseif ($seccion == 'entradas'): ?>
            <!-- Pestaña Entrada de Insumos (Reabastecimiento) -->
            <div class="row">
                <div class="col-lg-4 mb-4">
                    <div class="card border-0 shadow-sm">
                        <div class="card-header bg-white py-3">
                            <h5 class="fw-bold text-secondary mb-0">
                                <i class="bi bi-box-arrow-in-down text-success me-2"></i>Registrar Entrada / Reabastecimiento
                            </h5>
                        </div>
                        <div class="card-body">
                            <form method="POST" action="inventario.php?sec=entradas">
                                <input type="hidden" name="accion" value="registrar_entrada">
                                
                                <div class="mb-3">
                                    <label class="form-label fw-bold small">Seleccionar Insumo</label>
                                    <select name="id_producto" class="form-select" required>
                                        <option value="">-- Elija del inventario --</option>
                                        <?php if ($lista_productos && $lista_productos->num_rows > 0): ?>
                                            <?php while ($prod = $lista_productos->fetch_assoc()): ?>
                                                <option value="<?php echo $prod['id_producto']; ?>">
                                                    <?php echo htmlspecialchars($prod['nombre_insumo']); ?> (Stock Actual: <?php echo $prod['cantidad'] . ' ' . $prod['unidad_medida']; ?>)
                                                </option>
                                            <?php endwhile; ?>
                                        <?php endif; ?>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-bold small">Cantidad Recibida</label>
                                    <input type="number" step="0.01" name="cantidad_entrada" class="form-control" placeholder="Ej. 50.00" required>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-bold small">Proveedor / Contratista</label>
                                    <input type="text" name="proveedor" class="form-control" placeholder="Ej. Distribuidora Maritime C.A." required>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-bold small">N° Factura / Orden de Compra</label>
                                    <input type="text" name="num_factura_orden" class="form-control" placeholder="Ej. FACT-2026-089">
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-bold small">Fecha de Vencimiento (PEPS)</label>
                                    <input type="date" name="fecha_vencimiento" class="form-control">
                                    <span class="text-muted small">* Requerido para priorización de salidas PEPS.</span>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-bold small">Observaciones / Estado del Lote</label>
                                    <textarea name="observaciones" class="form-control" rows="2" placeholder="Ej. Empaque sellado correctamente, temperatura óptima"></textarea>
                                </div>

                                <button type="submit" class="btn btn-success w-100 fw-bold py-2">
                                    <i class="bi bi-plus-circle me-1"></i> Registrar Entrada y Sumar Stock
                                </button>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm">
                        <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                            <h5 class="fw-bold text-secondary mb-0">
                                <i class="bi bi-clock-history text-secondary me-2"></i>Historial Reciente de Reabastecimientos
                            </h5>
                            <a href="reporte_entradas.php" class="btn btn-outline-success btn-sm fw-bold shadow-sm">
                                <i class="bi bi-file-earmark-excel me-1"></i> Descargar Reporte
                            </a>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0 text-center small">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Fecha / Hora</th>
                                            <th class="text-start">Insumo</th>
                                            <th>Cantidad</th>
                                            <th>Proveedor</th>
                                            <th>Factura / N° Orden</th>
                                            <th>Vencimiento</th>
                                            <th>Observaciones</th>
                                            <th>Registrado por</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php if ($historial_entradas && $historial_entradas->num_rows > 0): ?>
                                            <?php while ($row = $historial_entradas->fetch_assoc()): ?>
                                                <tr>
                                                    <td><?php echo date('d/m/Y H:i', strtotime($row['fecha_entrada'])); ?></td>
                                                    <td class="text-start fw-bold text-success"><?php echo htmlspecialchars($row['nombre_insumo']); ?></td>
                                                    <td><span class="badge bg-success-subtle text-success border px-2 py-1 fw-bold">+<?php echo $row['cantidad'] . ' ' . $row['unidad_medida']; ?></span></td>
                                                    <td><?php echo htmlspecialchars($row['proveedor']); ?></td>
                                                    <td><?php echo !empty($row['num_factura_orden']) ? htmlspecialchars($row['num_factura_orden']) : '<span class="text-muted">N/A</span>'; ?></td>
                                                    <td><?php echo !empty($row['fecha_vencimiento']) ? date('d/m/Y', strtotime($row['fecha_vencimiento'])) : '<span class="text-muted">Sin Fecha</span>'; ?></td>
                                                    <td class="text-start"><small class="text-muted"><?php echo !empty($row['observaciones']) ? htmlspecialchars($row['observaciones']) : '-'; ?></small></td>
                                                    <td class="text-muted"><?php echo htmlspecialchars($row['usuario_nombre']); ?></td>
                                                </tr>
                                            <?php endwhile; ?>
                                        <?php else: ?>
                                            <tr><td colspan="8" class="py-4 text-muted">No hay registros de entradas recientes.</td></tr>
                                        <?php endif; ?>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        <?php elseif ($seccion == 'salidas'): ?>
            <!-- Pestaña Salida de Insumos -->
            <div class="row">
                <div class="col-lg-4 mb-4">
                    <div class="card border-0 shadow-sm">
                        <div class="card-header bg-white py-3">
                            <h5 class="fw-bold text-secondary mb-0">
                                <i class="bi bi-box-arrow-right text-primary me-2"></i>Registrar Salida
                            </h5>
                        </div>
                        <div class="card-body">
                            <form method="POST" action="inventario.php?sec=salidas">
                                <input type="hidden" name="accion" value="registrar_salida">
                                
                                <div class="mb-3">
                                    <label class="form-label fw-bold small">Seleccionar Insumo</label>
                                    <select name="id_producto" class="form-select" required>
                                        <option value="">-- Elija del inventario --</option>
                                        <?php if ($lista_productos && $lista_productos->num_rows > 0): ?>
                                            <?php while ($prod = $lista_productos->fetch_assoc()): ?>
                                                <option value="<?php echo $prod['id_producto']; ?>">
                                                    <?php echo htmlspecialchars($prod['nombre_insumo']); ?> (Stock: <?php echo $prod['cantidad'] . ' ' . $prod['unidad_medida']; ?>)
                                                </option>
                                            <?php endwhile; ?>
                                        <?php endif; ?>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-bold small">Cantidad a Retirar</label>
                                    <input type="number" step="0.01" name="cantidad_salida" class="form-control" placeholder="Ej. 10" required>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-bold small">Embarcación / Destino</label>
                                    <input type="text" name="ubicacion_destino" class="form-control" placeholder="Ej. RIG-123 / Gabarra" required>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label fw-bold small">Observaciones</label>
                                    <textarea name="observaciones" class="form-control" rows="2"></textarea>
                                </div>

                                <button type="submit" class="btn btn-primary w-100 fw-bold py-2">
                                    <i class="bi bi-check2-circle me-1"></i> Registrar Salida y Descontar
                                </button>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm">
                        <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                            <h5 class="fw-bold text-secondary mb-0">
                                <i class="bi bi-clock-history text-secondary me-2"></i>Historial Reciente de Salidas
                            </h5>
                            <!-- Botón Descargar Reporte de Salidas -->
                            <a href="reporte_salidas.php" class="btn btn-outline-danger btn-sm fw-bold shadow-sm" title="Exportar historial de salidas a Excel">
                                <i class="bi bi-file-earmark-excel me-1"></i> Descargar Reporte
                            </a>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0 text-center small">
                                    <thead class="table-light">
                                        <tr>
                                            <th>Fecha / Hora</th>
                                            <th class="text-start">Insumo</th>
                                            <th>Cantidad</th>
                                            <th class="text-start">Embarcación</th>
                                            <th>Observaciones</th>
                                            <th>Autorizado por</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php if ($historial_salidas && $historial_salidas->num_rows > 0): ?>
                                            <?php while ($row = $historial_salidas->fetch_assoc()): ?>
                                                <tr>
                                                    <td><?php echo date('d/m/Y H:i', strtotime($row['fecha_salida'])); ?></td>
                                                    <td class="text-start fw-bold text-primary"><?php echo htmlspecialchars($row['nombre_insumo']); ?></td>
                                                    <td><span class="badge bg-danger-subtle text-danger border px-2 py-1 fw-bold">-<?php echo $row['cantidad_salida'] . ' ' . $row['unidad_medida']; ?></span></td>
                                                    <td class="text-start"><?php echo htmlspecialchars($row['ubicacion_destino']); ?></td>
                                                    <td class="text-start"><small class="text-muted"><?php echo !empty($row['observaciones']) ? htmlspecialchars($row['observaciones']) : '-'; ?></small></td>
                                                    <td class="text-muted"><?php echo htmlspecialchars($row['usuario_nombre']); ?></td>
                                                </tr>
                                            <?php endwhile; ?>
                                        <?php else: ?>
                                            <tr><td colspan="5" class="py-4 text-muted">No hay registros de salidas recientes.</td></tr>
                                        <?php endif; ?>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        <?php endif; ?>
    </div>

    <!-- Modal Nuevo Insumo -->
    <div class="modal fade" id="modalNuevoInsumo" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form method="POST" action="">
                    <input type="hidden" name="accion" value="guardar_insumo">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title"><i class="bi bi-box-seam me-2"></i>Registrar Nuevo Insumo</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body row g-3">
                        <div class="col-md-12">
                            <label class="form-label fw-bold">Categoría / Clase:</label>
                            <input type="text" name="categoria" class="form-control" placeholder="Ej: Víveres, Proteínas, Lácteos" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-bold">Nombre del Insumo / Descripción:</label>
                            <input type="text" name="nombre_insumo" class="form-control" placeholder="Ej: Arroz Tipo I (1kg)" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Cantidad Inicial:</label>
                            <input type="number" step="0.01" name="cantidad_inicial" class="form-control" placeholder="0.00" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Unidad de Medida:</label>
                            <input type="text" name="unidad_medida" class="form-control" placeholder="Ej: Kg, Sacos, Litros" required>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label fw-bold">Stock Mínimo Alerta:</label>
                            <input type="number" step="0.01" name="stock_minimo" class="form-control" placeholder="Ej: 10.00" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-primary fw-bold">Guardar Insumo</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal Editar Insumo -->
    <div class="modal fade" id="modalEditarInsumo" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form method="POST" action="">
                    <input type="hidden" name="accion" value="editar_insumo">
                    <input type="hidden" name="id_producto" id="edit_id_producto">
                    <div class="modal-header bg-warning text-dark">
                        <h5 class="modal-title"><i class="bi bi-pencil-square me-2"></i>Editar Insumo</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body row g-3">
                        <div class="col-md-12">
                            <label class="form-label fw-bold">Categoría / Clase:</label>
                            <input type="text" name="categoria" id="edit_categoria" class="form-control" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-bold">Nombre del Insumo:</label>
                            <input type="text" name="nombre_insumo" id="edit_nombre" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Existencia Actual:</label>
                            <input type="number" step="0.01" name="cantidad" id="edit_cantidad" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold">Unidad de Medida:</label>
                            <input type="text" name="unidad_medida" id="edit_unidad" class="form-control" required>
                        </div>
                        <div class="col-md-12">
                            <label class="form-label fw-bold">Stock Mínimo:</label>
                            <input type="number" step="0.01" name="stock_minimo" id="edit_stock" class="form-control" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-warning fw-bold">Actualizar Insumo</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal Importar CSV -->
    <div class="modal fade" id="modalImportarExcel" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form method="POST" action="" enctype="multipart/form-data">
                    <input type="hidden" name="accion" value="importar_csv">
                    <div class="modal-header bg-success text-white">
                        <h5 class="modal-title"><i class="bi bi-file-earmark-excel me-2"></i>Importar Inventario (.CSV)</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Seleccionar archivo CSV:</label>
                            <input type="file" name="archivo_csv" class="form-control" accept=".csv" required>
                        </div>
                        <div class="alert alert-light border small text-muted">
                            <strong>Formato requerido en el CSV:</strong><br>
                            Columna 1: Nombre Insumo<br>
                            Columna 2: Categoría<br>
                            Columna 3: Cantidad Inicial<br>
                            Columna 4: Unidad de Medida<br>
                            Columna 5: Stock Mínimo
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-success fw-bold">Procesar e Importar</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Scripts de Bootstrap y Modal Dynamic Handler -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Cargar datos en el modal de edición dinámicamente
        const modalEditar = document.getElementById('modalEditarInsumo');
        if (modalEditar) {
            modalEditar.addEventListener('show.bs.modal', function (event) {
                const button = event.relatedTarget;
                document.getElementById('edit_id_producto').value = button.getAttribute('data-id');
                document.getElementById('edit_nombre').value      = button.getAttribute('data-nombre');
                document.getElementById('edit_categoria').value   = button.getAttribute('data-categoria');
                document.getElementById('edit_cantidad').value    = button.getAttribute('data-cantidad');
                document.getElementById('edit_unidad').value      = button.getAttribute('data-unidad');
                document.getElementById('edit_stock').value       = button.getAttribute('data-stock');
            });
        }
    </script>
</body>
</html>