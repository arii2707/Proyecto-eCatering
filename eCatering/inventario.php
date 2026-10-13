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
        header("Location: inventario.php?mensaje=guardado");
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
        header("Location: inventario.php?mensaje=editado");
        exit();
    }
}

// 3. Eliminar Insumo
if (isset($_GET['eliminar'])) {
    $id_producto = intval($_GET['eliminar']);
    $sql_delete = "DELETE FROM inventario WHERE id_producto = $id_producto";
    
    if ($conexion->query($sql_delete)) {
        header("Location: inventario.php?mensaje=eliminado");
        exit();
    }
}

// 4. Importar Inventario desde CSV Limpio
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['accion']) && $_POST['accion'] === 'importar_csv') {
    if (isset($_FILES['archivo_csv']) && $_FILES['archivo_csv']['error'] === UPLOAD_ERR_OK) {
        $archivo = $_FILES['archivo_csv']['tmp_name'];

        if (($gestor = fopen($archivo, "r")) !== FALSE) {
            fgetcsv($gestor, 1000, ","); // Saltar cabecera

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
            header("Location: inventario.php?mensaje=importado_exito");
            exit();
        }
    }
}

// Consultar Categorías Existentes para el Filtro
$res_categorias = $conexion->query("SELECT DISTINCT categoria FROM inventario WHERE categoria IS NOT NULL AND categoria != '' ORDER BY categoria ASC");

// Consultar Inventario con Filtros
$buscar = $_GET['buscar'] ?? '';
$categoria_filtro = $_GET['categoria'] ?? '';

$donde = "WHERE 1=1";
if (!empty($buscar)) {
    $b_clean = $conexion->real_escape_string($buscar);
    $donde .= " AND nombre_insumo LIKE '%$b_clean%'";
}
if (!empty($categoria_filtro)) {
    $c_clean = $conexion->real_escape_string($categoria_filtro);
    $donde .= " AND categoria = '$c_clean'";
}

$sql_inv = "SELECT * FROM inventario $donde ORDER BY nombre_insumo ASC";
$res_inv = $conexion->query($sql_inv);
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
        <!-- Encabezado y Navegación de Pestañas -->
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3 class="fw-bold text-primary mb-0"><i class="bi bi-box-seam me-2"></i>Módulo de Inventario</h3>
            <div class="d-flex gap-2">
                <button class="btn btn-success shadow-sm" data-bs-toggle="modal" data-bs-target="#modalImportarExcel">
                    <i class="bi bi-file-earmark-excel me-1"></i> Importar CSV Limpio
                </button>
                <button class="btn btn-primary shadow-sm" data-bs-toggle="modal" data-bs-target="#modalNuevoInsumo">
                    <i class="bi bi-plus-lg me-1"></i> Nuevo Producto
                </button>
            </div>
        </div>

        <!-- Submenú -->
        <ul class="nav nav-tabs mb-4">
            <li class="nav-item">
                <a class="nav-link active fw-bold" href="inventario.php">
                    <i class="bi bi-list-check me-1"></i> Maestro de Artículos / Existencias
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="reporte_existencias.php">
                    <i class="bi bi-file-earmark-bar-graph me-1"></i> Resumen / Alertas de Stock
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
            <?php endif; ?>
        <?php endif; ?>

        <!-- Filtro de Búsqueda -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-body">
                <form method="GET" action="" class="row g-2 align-items-center">
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
                        <a href="inventario.php" class="btn btn-outline-secondary" title="Limpiar Filtros"><i class="bi bi-arrow-counterclockwise"></i></a>
                    </div>
                </form>
            </div>
        </div>

        <!-- Tabla de Productos -->
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
                                <tr>
                                    <td colspan="8" class="text-center text-muted py-4">No hay productos registrados en el inventario.</td>
                                </tr>
                            <?php endif; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
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
                            <input type="text" name="nombre_insumo" class="form-control" placeholder="Ej: Aceite de Oliva" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-bold">Unidad Medida:</label>
                            <input type="text" name="unidad_medida" class="form-control" placeholder="Ej: Kg, Lts, PCE" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-bold">Cant. Inicial:</label>
                            <input type="number" step="0.01" name="cantidad_inicial" class="form-control" value="0.00" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-bold">Stock Mínimo:</label>
                            <input type="number" step="0.01" name="stock_minimo" class="form-control" value="5.00" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-primary"><i class="bi bi-save me-1"></i> Guardar Insumo</button>
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
                        <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square me-2"></i>Editar Insumo</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body row g-3">
                        <div class="col-md-12">
                            <label class="form-label fw-bold">Categoría / Clase:</label>
                            <input type="text" name="categoria" id="edit_categoria" class="form-control" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-bold">Nombre del Insumo / Descripción:</label>
                            <input type="text" name="nombre_insumo" id="edit_nombre_insumo" class="form-control" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-bold">Unidad Medida:</label>
                            <input type="text" name="unidad_medida" id="edit_unidad_medida" class="form-control" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-bold">Cantidad Actual:</label>
                            <input type="number" step="0.01" name="cantidad" id="edit_cantidad" class="form-control" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label fw-bold">Stock Mínimo:</label>
                            <input type="number" step="0.01" name="stock_minimo" id="edit_stock_minimo" class="form-control" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-warning text-dark fw-bold"><i class="bi bi-arrow-repeat me-1"></i> Actualizar</button>
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
                        <h5 class="modal-title"><i class="bi bi-file-earmark-excel me-2"></i>Importar Inventario Limpio (CSV)</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="alert alert-info py-2 small">
                            <i class="bi bi-info-circle-fill me-1"></i> El archivo CSV debe contener exactamente 5 columnas:<br>
                            <code>Nombre, Categoría, Cantidad, Unidad, Stock Mínimo</code>.
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Seleccionar archivo CSV:</label>
                            <input type="file" name="archivo_csv" class="form-control" accept=".csv" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-success"><i class="bi bi-upload me-1"></i> Cargar Datos</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        const modalEditar = document.getElementById('modalEditarInsumo');
        if (modalEditar) {
            modalEditar.addEventListener('show.bs.modal', function (event) {
                const button = event.relatedTarget;
                
                const id = button.getAttribute('data-id');
                const nombre = button.getAttribute('data-nombre');
                const categoria = button.getAttribute('data-categoria');
                const cantidad = button.getAttribute('data-cantidad');
                const unidad = button.getAttribute('data-unidad');
                const stock = button.getAttribute('data-stock');

                document.getElementById('edit_id_producto').value = id;
                document.getElementById('edit_nombre_insumo').value = nombre;
                document.getElementById('edit_categoria').value = categoria;
                document.getElementById('edit_cantidad').value = cantidad;
                document.getElementById('edit_unidad_medida').value = unidad;
                document.getElementById('edit_stock_minimo').value = stock;
            });
        }
    </script>
</body>
</html>