<?php
session_start();
if (!isset($_SESSION['id_usuario'])) {
    header("Location: index.php");
    exit();
}

require_once "config/conexion.php";

// Función para estatus según stock (Mínimo y Máximo)
function calcularEstado($cantidad, $stock_minimo, $stock_maximo = 0) {
    $cantidad = floatval($cantidad);
    $stock_minimo = floatval($stock_minimo);
    $stock_maximo = floatval($stock_maximo);

    if ($cantidad <= 0) {
        return 'Agotado';
    } elseif ($cantidad <= $stock_minimo) {
        return 'Por Agotarse';
    } elseif ($stock_maximo > 0 && $cantidad > $stock_maximo) {
        return 'Sobreabastecido';
    } else {
        return 'Disponible';
    }
}

// Función para conversión matemática precisa a empaque / presentación comercial
function obtenerPresentacion($cantidad, $unidad_base, $empaque, $contenido_empaque) {
    $contenido_empaque = floatval($contenido_empaque);
    if ($contenido_empaque > 0) {
        $empaques_completos = floor($cantidad / $contenido_empaque);
        $resto = $cantidad - ($empaques_completos * $contenido_empaque);
        
        if ($empaques_completos > 0) {
            $txt_resto = ($resto > 0) ? " (" . number_format($resto, 2) . " $unidad_base sueltos)" : "";
            return "<strong>$empaques_completos $empaque(s)</strong>$txt_resto";
        }
    }
    return number_format($cantidad, 2) . " " . $unidad_base;
}

$seccion = $_GET['sec'] ?? 'maestro';
$tipo_rubro_filtro = $_GET['tipo_rubro'] ?? 'Consumible';
$semana_filtro = $_GET['semana'] ?? ''; // Filtro opcional por semana para estadísticas

$res_inv = null;
$lista_productos = null;
$historial_salidas = null;
$historial_entradas = null;
$historial_mermas = null;
$res_estadisticas_consumo = null;
$res_semanas_disponibles = null;
$donde = ""; 

// ACTUALIZACIÓN GLOBAL DE ESTATUS AL CARGAR
$res_estatus = $conexion->query("SELECT id_producto, cantidad, stock_minimo, stock_maximo FROM inventario");
if ($res_estatus) {
    while ($prod = $res_estatus->fetch_assoc()) {
        $stk_max = isset($prod['stock_maximo']) ? $prod['stock_maximo'] : 0;
        $nuevo_estado = calcularEstado($prod['cantidad'], $prod['stock_minimo'], $stk_max);
        $conexion->query("UPDATE inventario SET estado = '$nuevo_estado' WHERE id_producto = " . $prod['id_producto']);
    }
}

// 1. Guardar Nuevo Insumo
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['accion']) && $_POST['accion'] === 'guardar_insumo') {
    $nombre            = $conexion->real_escape_string($_POST['nombre_insumo']);
    $tipo_rubro        = $conexion->real_escape_string($_POST['tipo_rubro']);
    
    $sql_verificar = "SELECT id_producto FROM inventario WHERE TRIM(LOWER(nombre_insumo)) = TRIM(LOWER('$nombre'))";
    $res_verificar = $conexion->query($sql_verificar);

    if ($res_verificar && $res_verificar->num_rows > 0) {
        $filtro_cat = $_POST['categoria'] ?? '';
        header("Location: inventario.php?sec=maestro&tipo_rubro=$tipo_rubro&mensaje=duplicado");
        exit();
    }

    $categoria         = $conexion->real_escape_string($_POST['categoria']);
    $unidad            = $conexion->real_escape_string($_POST['unidad_medida']);
    $unidad_empaque    = $conexion->real_escape_string($_POST['unidad_empaque']);
    $contenido_empaque = floatval(str_replace([' ', ','], ['', '.'], $_POST['contenido_por_empaque']));
    
    // Captura inteligente de cantidad inicial (permite ingresar en empaques o unidades)
    $cantidad_bruta    = floatval(str_replace([' ', ','], ['', '.'], $_POST['cantidad_inicial']));
    $tipo_ingreso_ini  = $_POST['tipo_ingreso_inicial'] ?? 'unidades';
    $cantidad          = ($tipo_ingreso_ini === 'empaques' && $contenido_empaque > 0) ? ($cantidad_bruta * $contenido_empaque) : $cantidad_bruta;

    $stock_minimo      = floatval(str_replace([' ', ','], ['', '.'], $_POST['stock_minimo']));
    $stock_maximo      = floatval(str_replace([' ', ','], ['', '.'], $_POST['stock_maximo'] ?? 0));
    $estado            = calcularEstado($cantidad, $stock_minimo, $stock_maximo);

    $sql_insert = "INSERT INTO inventario (nombre_insumo, tipo_rubro, categoria, cantidad, unidad_medida, unidad_empaque, contenido_por_empaque, stock_minimo, stock_maximo, estado) 
                    VALUES ('$nombre', '$tipo_rubro', '$categoria', $cantidad, '$unidad', '$unidad_empaque', $contenido_empaque, $stock_minimo, $stock_maximo, '$estado')";
    
    if ($conexion->query($sql_insert)) {
        $id_nuevo = $conexion->insert_id;
        registrarLog($conexion, $_SESSION['id_usuario'], "CREACION_INSUMO", "Creó el insumo '$nombre' (#$id_nuevo) con stock inicial de $cantidad $unidad.");
        header("Location: inventario.php?sec=maestro&tipo_rubro=$tipo_rubro&mensaje=guardado");
        exit();
    }
}

// 2. Editar / Actualizar Insumo
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['accion']) && $_POST['accion'] === 'editar_insumo') {
    $id_producto       = intval($_POST['id_producto']);
    $nombre            = $conexion->real_escape_string($_POST['nombre_insumo']);
    $tipo_rubro        = $conexion->real_escape_string($_POST['tipo_rubro']);

    $sql_val_dup = "SELECT id_producto FROM inventario WHERE TRIM(LOWER(nombre_insumo)) = TRIM(LOWER('$nombre')) AND id_producto != $id_producto";
    $res_val_dup = $conexion->query($sql_val_dup);

    $filtro_cat = $_POST['filtro_categoria_actual'] ?? '';
    $filtro_bus = $_POST['filtro_busqueda_actual'] ?? '';

    if ($res_val_dup && $res_val_dup->num_rows > 0) {
        header("Location: inventario.php?sec=maestro&tipo_rubro=$tipo_rubro&categoria=" . urlencode($filtro_cat) . "&buscar=" . urlencode($filtro_bus) . "&mensaje=duplicado_edicion");
        exit();
    }

    $categoria         = $conexion->real_escape_string($_POST['categoria']);
    $unidad            = $conexion->real_escape_string($_POST['unidad_medida']);
    $unidad_empaque    = $conexion->real_escape_string($_POST['unidad_empaque']);
    $contenido_empaque = floatval(str_replace([' ', ','], ['', '.'], $_POST['contenido_por_empaque']));
    
    // Captura inteligente de cantidad en edición
    $cantidad_bruta    = floatval(str_replace([' ', ','], ['', '.'], $_POST['cantidad']));
    $tipo_ingreso_edit = $_POST['tipo_ingreso_editar'] ?? 'unidades';
    $cantidad          = ($tipo_ingreso_edit === 'empaques' && $contenido_empaque > 0) ? ($cantidad_bruta * $contenido_empaque) : $cantidad_bruta;

    $stock_minimo      = floatval(str_replace([' ', ','], ['', '.'], $_POST['stock_minimo']));
    $stock_maximo      = floatval(str_replace([' ', ','], ['', '.'], $_POST['stock_maximo'] ?? 0));
    $estado            = calcularEstado($cantidad, $stock_minimo, $stock_maximo);

    $sql_update = "UPDATE inventario SET 
                    nombre_insumo = '$nombre', 
                    tipo_rubro = '$tipo_rubro',
                    categoria = '$categoria', 
                    cantidad = $cantidad, 
                    unidad_medida = '$unidad', 
                    unidad_empaque = '$unidad_empaque', 
                    contenido_por_empaque = $contenido_empaque, 
                    stock_minimo = $stock_minimo, 
                    stock_maximo = $stock_maximo, 
                    estado = '$estado' 
                   WHERE id_producto = $id_producto";
    
    if ($conexion->query($sql_update)) {
        registrarLog($conexion, $_SESSION['id_usuario'], "EDICION_INSUMO", "Actualizó los datos del insumo '$nombre' (#$id_producto).");
        header("Location: inventario.php?sec=maestro&tipo_rubro=$tipo_rubro&categoria=" . urlencode($filtro_cat) . "&buscar=" . urlencode($filtro_bus) . "&mensaje=editado");
        exit();
    }
}

// 3. Eliminar Insumo
if (isset($_GET['eliminar'])) {
    $id_producto = intval($_GET['eliminar']);
    
    $q_nom = $conexion->query("SELECT nombre_insumo, tipo_rubro FROM inventario WHERE id_producto = $id_producto");
    $r = ($q_nom) ? $q_nom->fetch_assoc() : null;
    $nom_ins = $r ? $r['nombre_insumo'] : "ID #$id_producto";
    $t_rubro = $r ? $r['tipo_rubro'] : "Consumible";

    $sql_delete = "DELETE FROM inventario WHERE id_producto = $id_producto";
    
    if ($conexion->query($sql_delete)) {
        registrarLog($conexion, $_SESSION['id_usuario'], "ELIMINACION_INSUMO", "Eliminó el insumo '$nom_ins' (#$id_producto) del inventario.");
        header("Location: inventario.php?sec=maestro&tipo_rubro=$t_rubro&mensaje=eliminado");
        exit();
    }
}

// 4. Registrar Consumo en el Taladro (Salidas)
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['accion']) && $_POST['accion'] === 'registrar_salida') {
    $id_producto       = intval($_POST['id_producto']);
    $cantidad_salida   = floatval($_POST['cantidad_salida']);
    $ubicacion_destino = $conexion->real_escape_string($_POST['ubicacion_destino'] ?? 'Gabarra RIG-42');
    
    $fecha_salida      = !empty($_POST['fecha_salida']) ? "'" . $conexion->real_escape_string($_POST['fecha_salida']) . "'" : "NOW()";
    $observaciones     = $conexion->real_escape_string($_POST['observaciones']);
    $id_usuario        = $_SESSION['id_usuario'];

    if ($cantidad_salida <= 0) {
        $error_salida = "La cantidad a registrar debe ser mayor a cero.";
    } else {
        $conexion->begin_transaction();
        try {
            $sql_stk = "SELECT cantidad, stock_minimo, stock_maximo, nombre_insumo, unidad_medida FROM inventario WHERE id_producto = $id_producto FOR UPDATE";
            $res_stk = $conexion->query($sql_stk);
            
            if ($res_stk && $res_stk->num_rows > 0) {
                $prod_data = $res_stk->fetch_assoc();
                $stock_actual = floatval($prod_data['cantidad']);

                if ($cantidad_salida > $stock_actual) {
                    throw new Exception("Stock insuficiente. Disponible actual para '{$prod_data['nombre_insumo']}': $stock_actual {$prod_data['unidad_medida']}.");
                }

                $nueva_cantidad = $stock_actual - $cantidad_salida;
                $stk_max = isset($prod_data['stock_maximo']) ? $prod_data['stock_maximo'] : 0;
                $nuevo_estado = calcularEstado($nueva_cantidad, floatval($prod_data['stock_minimo']), $stk_max);

                $sql_ins_salida = "INSERT INTO salidas_insumos (id_producto, cantidad_salida, ubicacion_destino, fecha_salida, id_usuario, observaciones) 
                                   VALUES ($id_producto, $cantidad_salida, '$ubicacion_destino', $fecha_salida, $id_usuario, '$observaciones')";
                if (!$conexion->query($sql_ins_salida)) {
                    throw new Exception("Error al registrar el consumo: " . $conexion->error);
                }

                $sql_upd_inv = "UPDATE inventario SET cantidad = $nueva_cantidad, estado = '$nuevo_estado' WHERE id_producto = $id_producto";
                if (!$conexion->query($sql_upd_inv)) {
                    throw new Exception("Error al actualizar el stock: " . $conexion->error);
                }

                registrarLog($conexion, $id_usuario, "CONSUMO_INSUMO", "Registró consumo de $cantidad_salida {$prod_data['unidad_medida']} de '{$prod_data['nombre_insumo']}' en $ubicacion_destino.");

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
            $sql_stk = "SELECT cantidad, stock_minimo, stock_maximo, nombre_insumo, unidad_medida FROM inventario WHERE id_producto = $id_producto FOR UPDATE";
            $res_stk = $conexion->query($sql_stk);

            if ($res_stk && $res_stk->num_rows > 0) {
                $prod_data = $res_stk->fetch_assoc();
                $stock_actual = floatval($prod_data['cantidad']);

                $nueva_cantidad = $stock_actual + $cantidad_entrada;
                $stk_max = isset($prod_data['stock_maximo']) ? $prod_data['stock_maximo'] : 0;
                $nuevo_estado   = calcularEstado($nueva_cantidad, floatval($prod_data['stock_minimo']), $stk_max);

                $sql_ins_entrada = "INSERT INTO entradas_insumos (id_producto, cantidad, proveedor, num_factura_orden, fecha_vencimiento, fecha_entrada, id_usuario, observaciones) 
                                    VALUES ($id_producto, $cantidad_entrada, '$proveedor', '$num_factura_orden', $fecha_vencimiento, NOW(), $id_usuario, '$observaciones')";
                if (!$conexion->query($sql_ins_entrada)) {
                    throw new Exception("Error al registrar el reabastecimiento: " . $conexion->error);
                }

                $sql_upd_inv = "UPDATE inventario SET cantidad = $nueva_cantidad, estado = '$nuevo_estado' WHERE id_producto = $id_producto";
                if (!$conexion->query($sql_upd_inv)) {
                    throw new Exception("Error al actualizar el stock maestro: " . $conexion->error);
                }

                registrarLog($conexion, $id_usuario, "REABASTECIMIENTO_INSUMO", "Ingresó $cantidad_entrada {$prod_data['unidad_medida']} de '{$prod_data['nombre_insumo']}' desde $proveedor.");

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

// 6. REGISTRAR MERMA DE INSUMOS
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['accion']) && $_POST['accion'] === 'registrar_merma') {
    $id_producto       = intval($_POST['id_producto']);
    $cantidad_unid     = floatval($_POST['cantidad_unid'] ?? 0);
    $peso_gramos       = floatval($_POST['peso_gramos'] ?? 0);
    $observaciones     = $conexion->real_escape_string($_POST['observaciones']);
    $id_usuario        = $_SESSION['id_usuario'];

    if ($cantidad_unid <= 0 && $peso_gramos <= 0) {
        $error_merma = "Debe ingresar al menos una cantidad en unidades o el peso en gramos para la merma.";
    } else {
        $conexion->begin_transaction();
        try {
            $sql_stk = "SELECT cantidad, stock_minimo, stock_maximo, nombre_insumo, unidad_medida FROM inventario WHERE id_producto = $id_producto FOR UPDATE";
            $res_stk = $conexion->query($sql_stk);

            if ($res_stk && $res_stk->num_rows > 0) {
                $prod_data = $res_stk->fetch_assoc();
                $stock_actual = floatval($prod_data['cantidad']);
                $uni_medida = strtolower(trim($prod_data['unidad_medida']));

                $descuento_stock = 0;
                if ($peso_gramos > 0) {
                    $descuento_stock = ($uni_medida == 'kg' || $uni_medida == 'kilos' || $uni_medida == 'kilo') ? ($peso_gramos / 1000) : $peso_gramos;
                } else {
                    $descuento_stock = $cantidad_unid;
                }

                if ($descuento_stock > $stock_actual) {
                    throw new Exception("La merma excede el stock actual ($stock_actual {$prod_data['unidad_medida']}) de '{$prod_data['nombre_insumo']}'.");
                }

                $nueva_cantidad = $stock_actual - $descuento_stock;
                $stk_max = isset($prod_data['stock_maximo']) ? $prod_data['stock_maximo'] : 0;
                $nuevo_estado = calcularEstado($nueva_cantidad, floatval($prod_data['stock_minimo']), $stk_max);

                $sql_ins_merma = "INSERT INTO control_mermas (id_producto, cantidad_unid, peso_gramos, fecha_registro, id_usuario, observaciones) 
                                  VALUES ($id_producto, $cantidad_unid, $peso_gramos, NOW(), $id_usuario, '$observaciones')";
                if (!$conexion->query($sql_ins_merma)) {
                    throw new Exception("Error al registrar la merma en la base de datos: " . $conexion->error);
                }

                $sql_upd_inv = "UPDATE inventario SET cantidad = $nueva_cantidad, estado = '$nuevo_estado' WHERE id_producto = $id_producto";
                if (!$conexion->query($sql_upd_inv)) {
                    throw new Exception("Error al actualizar el stock tras registrar la merma: " . $conexion->error);
                }

                registrarLog($conexion, $id_usuario, "REGISTRO_MERMA", "Registró merma de '{$prod_data['nombre_insumo']}': $cantidad_unid unid / $peso_gramos gr. Motivo: $observaciones");

                $conexion->commit();
                header("Location: inventario.php?sec=mermas&mensaje=merma_exito");
                exit();
            } else {
                throw new Exception("El producto seleccionado no existe.");
            }
        } catch (Exception $e) {
            $conexion->rollback();
            $error_merma = $e->getMessage();
        }
    }
}

// Consultas y Filtros
$res_categorias = $conexion->query("SELECT DISTINCT categoria FROM inventario WHERE categoria IS NOT NULL AND categoria != '' ORDER BY categoria ASC");
$buscar = $_GET['buscar'] ?? '';
$categoria_filtro = $_GET['categoria'] ?? '';

if ($seccion == 'maestro') {
    $donde = "WHERE tipo_rubro = '$tipo_rubro_filtro'";
    if (!empty($buscar)) {
        $b_clean = $conexion->real_escape_string($buscar);
        $donde .= " AND nombre_insumo LIKE '%$b_clean%'";
    }
    if (!empty($categoria_filtro)) {
        $c_clean = $conexion->real_escape_string($categoria_filtro);
        $donde .= " AND categoria = '$c_clean'";
    }
    $res_inv = $conexion->query("SELECT * FROM inventario $donde ORDER BY nombre_insumo ASC");
} elseif ($seccion == 'reporte') {
    $res_inv = $conexion->query("SELECT * FROM inventario ORDER BY tipo_rubro DESC, categoria DESC, nombre_insumo ASC");
} elseif ($seccion == 'resumen') {
    $res_inv = $conexion->query("SELECT * FROM inventario WHERE cantidad <= stock_minimo OR (stock_maximo > 0 AND cantidad > stock_maximo) ORDER BY cantidad ASC");
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
} elseif ($seccion == 'mermas') {
    $lista_productos = $conexion->query("SELECT id_producto, nombre_insumo, cantidad, unidad_medida FROM inventario ORDER BY nombre_insumo ASC");
    $historial_mermas = $conexion->query("SELECT m.*, i.nombre_insumo, i.unidad_medida, u.nombre AS usuario_nombre 
                                          FROM control_mermas m 
                                          INNER JOIN inventario i ON m.id_producto = i.id_producto 
                                          INNER JOIN usuarios u ON m.id_usuario = u.id_usuario 
                                          ORDER BY m.fecha_registro DESC LIMIT 20");
} elseif ($seccion == 'estadisticas') {
    $res_semanas_disponibles = $conexion->query("SELECT DISTINCT YEARWEEK(fecha_salida, 1) as anio_semana FROM salidas_insumos ORDER BY anio_semana DESC");

    $filtro_semana_sql = "";
    if (!empty($semana_filtro)) {
        $s_clean = $conexion->real_escape_string($semana_filtro);
        $filtro_semana_sql = "WHERE YEARWEEK(s.fecha_salida, 1) = '$s_clean'";
    }

    $sql_est_consumo = "SELECT i.nombre_insumo, IFNULL(i.tipo_rubro, 'Consumible') as tipo_rubro, i.categoria, i.unidad_medida,
                        SUM(s.cantidad_salida) as total_salida,
                        (SELECT SUM(cantidad_salida) FROM salidas_insumos " . (!empty($semana_filtro) ? "WHERE YEARWEEK(fecha_salida, 1) = '$semana_filtro'" : "") . ") as total_general
                        FROM salidas_insumos s
                        INNER JOIN inventario i ON s.id_producto = i.id_producto
                        $filtro_semana_sql
                        GROUP BY s.id_producto
                        ORDER BY total_salida DESC";
    $res_estadisticas_consumo = $conexion->query($sql_est_consumo);
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
    <style>
        @media print {
            @page {
                size: letter landscape;
                margin: 15mm;
            }
            nav, .btn, .nav-tabs, footer, form {
                display: none !important;
            }
            body {
                background-color: #fff !important;
                color: #000 !important;
                font-size: 11pt;
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
            <span class="me-3"><strong><?php echo $_SESSION['nombre']; ?></strong></span>
            <a href="dashboard.php" class="btn btn-outline-light btn-sm me-2">Volver al Panel</a>
            <a href="logout.php" class="btn btn-outline-light btn-sm">Cerrar Sesión</a>
        </div>
    </nav>

    <div class="container my-4">
        <!-- Encabezado y Botones -->
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3 class="fw-bold text-primary mb-0"><i class="bi bi-box-seam me-2"></i>Gestión de Inventario</h3>
            <div class="d-flex gap-2">
                <button class="btn btn-primary shadow-sm" data-bs-toggle="modal" data-bs-target="#modalNuevoInsumo">
                    <i class="bi bi-plus-lg me-1"></i> Nuevo Producto
                </button>
                <a href="carga_masiva.php" class="btn btn-outline-primary fw-bold shadow-sm">
                    <i class="bi bi-cloud-upload me-1"></i> Cargar Datos
                </a>
            </div>
        </div>

        <!-- Submenú Pestañas Actualizado -->
        <ul class="nav nav-tabs mb-4">
            <li class="nav-item">
                <a class="nav-link <?php echo ($seccion == 'maestro') ? 'active fw-bold' : ''; ?>" href="inventario.php?sec=maestro">
                    <i class="bi bi-list-check text-success me-1"></i> Maestro de Artículos
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <?php echo ($seccion == 'resumen') ? 'active fw-bold' : ''; ?>" href="inventario.php?sec=resumen">
                    <i class="bi bi-exclamation-triangle text-warning me-1"></i> Alertas de Stock
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <?php echo ($seccion == 'entradas') ? 'active fw-bold' : ''; ?>" href="inventario.php?sec=entradas">
                    <i class="bi bi-arrow-down-left-circle-fill text-success me-1 "></i> Entradas
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <?php echo ($seccion == 'salidas') ? 'active fw-bold' : ''; ?>" href="inventario.php?sec=salidas">
                    <i class="bi bi-arrow-up-right-circle-fill text-danger me-1"></i> Consumo
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <?php echo ($seccion == 'mermas') ? 'active fw-bold' : ''; ?>" href="inventario.php?sec=mermas">
                    <i class="bi bi-trash3-fill text-warning me-1"></i> Control de Mermas
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <?php echo ($seccion == 'estadisticas') ? 'active fw-bold' : ''; ?>" href="inventario.php?sec=estadisticas">
                    <i class="bi bi-pie-chart-fill text-primary me-1 "></i> Porcentajes de Consumo
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <?php echo ($seccion == 'reporte') ? 'active fw-bold' : ''; ?>" href="inventario.php?sec=reporte">
                    <i class="bi bi-file-earmark-bar-graph text-success me-1"></i> Reporte de Existencias
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
            <?php elseif ($_GET['mensaje'] === 'duplicado'): ?>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-x-octagon-fill me-2"></i>¡Atención! El producto que intentas registrar ya se encuentra en el inventario. No se permiten duplicados.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <?php elseif ($_GET['mensaje'] === 'duplicado_edicion'): ?>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-x-octagon-fill me-2"></i>¡Atención! No se pudo actualizar porque ya existe otro producto registrado con ese mismo nombre.
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
                    <i class="bi bi-check-circle-fill me-2"></i> ¡Consumo registrado con éxito y stock descontado!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <?php elseif ($_GET['mensaje'] === 'entrada_exito'): ?>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i> ¡Entrada de insumo registrada correctamente y stock reabastecido!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <?php elseif ($_GET['mensaje'] === 'merma_exito'): ?>
                <div class="alert alert-warning alert-dismissible fade show text-dark fw-bold" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2 text-warning"></i> ¡Merma diaria registrada con éxito y descontada del inventario!
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

        <?php if (isset($error_merma)): ?>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-octagon-fill me-2"></i> <?php echo $error_merma; ?>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <?php endif; ?>
        

        <!-- PESTAÑA MAESTRO DE ARTÍCULOS -->
        <?php if ($seccion == 'maestro'): ?>
            <ul class="nav nav-pills mb-3">
                <li class="nav-item me-2">
                    <a class="nav-link <?php echo ($tipo_rubro_filtro == 'Consumible') ? 'active fw-bold bg-success text-white' : 'bg-white text-dark border'; ?>" 
                       href="inventario.php?sec=maestro&tipo_rubro=Consumible">
                        <i class="bi bi-cart4 me-1"></i> Consumibles
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link <?php echo ($tipo_rubro_filtro == 'No Consumible') ? 'active fw-bold bg-primary text-white' : 'bg-white text-dark border'; ?>" 
                       href="inventario.php?sec=maestro&tipo_rubro=No%20Consumible">
                        <i class="bi bi-clipboard-check me-1"></i> No Consumibles
                    </a>
                </li>
            </ul>

            <div class="card border-0 shadow-sm mb-4">
                <div class="card-body">
                    <form method="GET" action="inventario.php" class="row g-2 align-items-center">
                        <input type="hidden" name="sec" value="maestro">
                        <input type="hidden" name="tipo_rubro" value="<?php echo htmlspecialchars($tipo_rubro_filtro); ?>">
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
                            <a href="inventario.php?sec=maestro&tipo_rubro=<?php echo $tipo_rubro_filtro; ?>" class="btn btn-outline-secondary" title="Limpiar Filtros"><i class="bi bi-arrow-counterclockwise"></i></a>
                        </div>
                    </form>
                </div>
            </div>

            <div class="card border-0 shadow-sm">
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-dark">
                                <tr>
                                    <th>#ID</th>
                                    <th>Nombre del Insumo</th>
                                    <th class="text-center">Categoría</th>
                                    <th class="text-center">Existencias a bordo</th>
                                    <th class="text-center">Presentación</th>
                                    <th class="text-center">Unidad</th>
                                    <th class="text-center">Stock Mín.</th>
                                    <th class="text-center">Stock Máx.</th>
                                    <th class="text-center">Estatus Stock</th>
                                    <th class="text-center">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php if ($res_inv && $res_inv->num_rows > 0): ?>
                                    <?php while ($row = $res_inv->fetch_assoc()): ?>
                                        <tr>
                                            <td><strong><?php echo $row['id_producto']; ?></strong></td>
                                            <td class="fw-bold"><?php echo htmlspecialchars($row['nombre_insumo']); ?></td>
                                            <td class="text-center"><span class="badge bg-secondary"><?php echo htmlspecialchars($row['categoria']); ?></span></td>
                                            <td class="text-center fs-6 fw-bold text-primary"><?php echo number_format($row['cantidad'], 2); ?></td>
                                            <td class="text-center"><small class="text-dark fw-semibold"><?php echo obtenerPresentacion($row['cantidad'], $row['unidad_medida'], $row['unidad_empaque'] ?? 'Empaques', $row['contenido_por_empaque'] ?? 1); ?></small></td>
                                            <td class="text-center"><?php echo htmlspecialchars($row['unidad_medida']); ?></td>
                                            <td class="text-center"><?php echo number_format($row['stock_minimo'], 2); ?></td>
                                            <td class="text-center"><?php echo number_format($row['stock_maximo'] ?? 0, 2); ?></td>
                                            <td class="text-center">
                                                <?php if ($row['estado'] === 'Disponible'): ?>
                                                    <span class="badge bg-success"><i class="bi bi-check-circle me-1"></i> Disponible</span>
                                                <?php elseif ($row['estado'] === 'Por Agotarse'): ?>
                                                    <span class="badge bg-warning text-dark"><i class="bi bi-exclamation-triangle me-1"></i> Por Agotarse</span>
                                                <?php elseif ($row['estado'] === 'Sobreabastecido'): ?>
                                                    <span class="badge bg-info text-dark"><i class="bi bi-arrow-up-circle me-1"></i> Sobreabastecido</span>
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
                                                            data-tiporubro="<?php echo htmlspecialchars($row['tipo_rubro'] ?? 'Consumible'); ?>"
                                                            data-categoria="<?php echo htmlspecialchars($row['categoria']); ?>"
                                                            data-cantidad="<?php echo $row['cantidad']; ?>"
                                                            data-unidad="<?php echo htmlspecialchars($row['unidad_medida']); ?>"
                                                            data-empaque="<?php echo htmlspecialchars($row['unidad_empaque'] ?? 'Saco'); ?>"
                                                            data-contenido="<?php echo $row['contenido_por_empaque'] ?? 1; ?>"
                                                            data-stock="<?php echo $row['stock_minimo']; ?>"
                                                            data-stockmax="<?php echo $row['stock_maximo'] ?? 0; ?>">
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
                                    <tr><td colspan="10" class="text-center text-muted py-4">No hay productos registrados en esta categoría.</td></tr>
                                <?php endif; ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

       <!-- PESTAÑA CONTROL DE MERMAS DIARIAS -->
        <?php elseif ($seccion == 'mermas'): ?>
            <div class="row">
                <div class="col-lg-4 mb-4">
                    <div class="card border-0 shadow-sm">
                        <div class="card-header bg-dark text-white py-3">
                            <h5 class="fw-bold mb-0"><i class="bi bi-journal-x text-warning me-2"></i>Registrar Merma Diaria</h5>
                            <small class="text-white-50">Control diario de pérdidas y desechos</small>
                        </div>
                        <div class="card-body">
                            <form method="POST" action="inventario.php?sec=mermas">
                                <input type="hidden" name="accion" value="registrar_merma">
                                <div class="mb-3">
                                    <label class="form-label fw-bold small">Descripción (Producto)</label>
                                    <select name="id_producto" class="form-select" required>
                                        <option value="">-- Seleccionar Producto --</option>
                                        <?php if ($lista_productos && $lista_productos->num_rows > 0): ?>
                                            <?php while ($prod = $lista_productos->fetch_assoc()): ?>
                                                <option value="<?php echo $prod['id_producto']; ?>">
                                                    <?php echo htmlspecialchars($prod['nombre_insumo']); ?> (Stock: <?php echo $prod['cantidad'] . ' ' . $prod['unidad_medida']; ?>)
                                                </option>
                                            <?php endwhile; ?>
                                        <?php endif; ?>
                                    </select>
                                </div>
                                <div class="row g-2 mb-3">
                                    <div class="col-6">
                                        <label class="form-label fw-bold small">Mermas (Unid.)</label>
                                        <input type="number" step="0.01" name="cantidad_unid" class="form-control" placeholder="Ej. 2">
                                    </div>
                                    <div class="col-6">
                                        <label class="form-label fw-bold small">Mermas (gr)</label>
                                        <input type="number" step="0.01" name="peso_gramos" class="form-control" placeholder="Ej. 500">
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label fw-bold small">Observaciones / Motivo</label>
                                    <textarea name="observaciones" class="form-control" rows="3" placeholder="Motivo del descarte (vencimiento, preparación, deterioro...)" required></textarea>
                                </div>
                                <button type="submit" class="btn btn-dark fw-bold text-white w-100 shadow-sm"><i class="bi bi-check-circle me-1"></i> Guardar Merma</button>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm">
                        <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                            <div>
                                <h5 class="fw-bold text-secondary mb-0"><i class="bi bi-clock-history me-2"></i>Historial Control Diario de Mermas</h5>
                                <small class="text-muted">Descuentos automáticos aplicados al inventario</small>
                            </div>
                            <a href="reporte_mermas.php" class="btn btn-success btn-sm fw-bold shadow-sm">
                                <i class="bi bi-filetype-xlsx me-1"></i> Descargar
                            </a>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0 small">
                                    <thead class="table-dark">
                                        <tr>
                                            <th>Fecha/Hora</th>
                                            <th>Descripción (Producto)</th>
                                            <th class="text-center">Unid.</th>
                                            <th class="text-center">(gr)</th>
                                            <th>Observaciones</th>
                                            <th>Usuario</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php if ($historial_mermas && $historial_mermas->num_rows > 0): ?>
                                            <?php while ($m = $historial_mermas->fetch_assoc()): ?>
                                                <tr>
                                                    <td><?php echo date('d/m/Y H:i', strtotime($m['fecha_registro'])); ?></td>
                                                    <td class="fw-bold"><?php echo htmlspecialchars($m['nombre_insumo']); ?></td>
                                                    <td class="text-center fw-bold text-danger"><?php echo ($m['cantidad_unid'] > 0) ? number_format($m['cantidad_unid'], 2) : '-'; ?></td>
                                                    <td class="text-center fw-bold text-danger"><?php echo ($m['peso_gramos'] > 0) ? number_format($m['peso_gramos'], 2) : '-'; ?></td>
                                                    <td><?php echo htmlspecialchars($m['observaciones']); ?></td>
                                                    <td><?php echo htmlspecialchars($m['usuario_nombre']); ?></td>
                                                </tr>
                                            <?php endwhile; ?>
                                        <?php else: ?>
                                            <tr><td colspan="6" class="text-center py-4 text-muted">No se han registrado mermas recientemente.</td></tr>
                                        <?php endif; ?>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        <!-- PESTAÑA REPORTE DE EXISTENCIAS -->
        <?php elseif ($seccion == 'reporte'): ?>
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                    <div>
                        <h5 class="fw-bold text-secondary mb-0"><i class="bi bi-file-earmark-bar-graph text-success me-2"></i>Reporte de Existencias</h5>
                        <small class="text-muted">Maritime Contractors de Venezuela, C.A.</small>
                    </div>
                    <div>
                        <button onclick="window.print();" class="btn btn-outline-primary btn-sm me-2 fw-bold shadow-sm">
                            <i class="bi bi-printer me-1"></i> Imprimir / PDF
                        </button>
                        <a href="exportar_inventario.php" class="btn btn-success btn-sm fw-bold shadow-sm">
                            <i class="bi bi-file-earmark-excel me-1"></i> Exportar
                        </a>
                    </div>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0">
                            <thead class="table-dark">
                                <tr>
                                    <th>Tipo Rubro</th>
                                    <th>Insumo / Artículo</th>
                                    <th>Categoría</th>
                                    <th class="text-center">Existencia Base</th>
                                    <th class="text-center">Presentación Comercial</th>
                                    <th class="text-center">Mín / Máx</th>
                                    <th class="text-center">Estatus</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php if ($res_inv && $res_inv->num_rows > 0): ?>
                                    <?php while ($row = $res_inv->fetch_assoc()): ?>
                                        <tr>
                                            <td><span class="badge <?php echo (($row['tipo_rubro'] ?? 'Consumible') === 'Consumible') ? 'bg-success' : 'bg-secondary'; ?>"><?php echo $row['tipo_rubro'] ?? 'Consumible'; ?></span></td>
                                            <td class="fw-bold"><?php echo htmlspecialchars($row['nombre_insumo']); ?></td>
                                            <td><span class="badge bg-secondary"><?php echo htmlspecialchars($row['categoria']); ?></span></td>
                                            <td class="text-center fw-bold text-primary"><?php echo number_format($row['cantidad'], 2); ?> <?php echo htmlspecialchars($row['unidad_medida']); ?></td>
                                            <td class="text-center"><small class="text-muted fw-semibold"><?php echo obtenerPresentacion($row['cantidad'], $row['unidad_medida'], $row['unidad_empaque'] ?? 'Empaques', $row['contenido_por_empaque'] ?? 1); ?></small></td>
                                            <td class="text-center"><small class="text-dark"><?php echo number_format($row['stock_minimo'], 2); ?> / <?php echo number_format($row['stock_maximo'] ?? 0, 2); ?></small></td>
                                            <td class="text-center">
                                                <?php if ($row['estado'] === 'Disponible'): ?>
                                                    <span class="badge bg-success">Disponible</span>
                                                <?php elseif ($row['estado'] === 'Por Agotarse'): ?>
                                                    <span class="badge bg-warning text-dark">Por Agotarse</span>
                                                <?php elseif ($row['estado'] === 'Sobreabastecido'): ?>
                                                    <span class="badge bg-info text-dark">Sobreabastecido</span>
                                                <?php else: ?>
                                                    <span class="badge bg-danger">Agotado</span>
                                                <?php endif; ?>
                                            </td>
                                        </tr>
                                    <?php endwhile; ?>
                                <?php else: ?>
                                    <tr><td colspan="7" class="text-center text-muted py-4">No hay registros de inventario disponibles para generar el reporte.</td></tr>
                                <?php endif; ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        <!-- PESTAÑA RESUMEN -->
        <?php elseif ($seccion == 'resumen'): ?>
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white py-3">
                    <h5 class="fw-bold text-secondary mb-0"><i class="bi bi-exclamation-triangle text-warning me-2"></i>Alertas de Stock</h5>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle mb-0 text-center">
                            <thead class="table-dark">
                                <tr>
                                    <th class="text-start">Insumo</th>
                                    <th>Stock Actual</th>
                                    <th>Empaques Equivalentes</th>
                                    <th>Stock Mínimo</th>
                                    <th>Stock Máximo</th>
                                    <th>Estatus</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php if ($res_inv && $res_inv->num_rows > 0): ?>
                                    <?php while ($row = $res_inv->fetch_assoc()): ?>
                                        <tr>
                                            <td class="text-start fw-bold"><?php echo htmlspecialchars($row['nombre_insumo']); ?></td>
                                            <td class="fw-bold text-danger"><?php echo number_format($row['cantidad'], 2); ?> <?php echo $row['unidad_medida']; ?></td>
                                            <td><small class="text-muted fw-bold"><?php echo obtenerPresentacion($row['cantidad'], $row['unidad_medida'], $row['unidad_empaque'] ?? 'Empaques', $row['contenido_por_empaque'] ?? 1); ?></small></td>
                                            <td><?php echo number_format($row['stock_minimo'], 2); ?></td>
                                            <td><?php echo number_format($row['stock_maximo'] ?? 0, 2); ?></td>
                                            <td>
                                                <?php if ($row['estado'] === 'Agotado'): ?>
                                                    <span class="badge bg-danger">Agotado</span>
                                                <?php elseif ($row['estado'] === 'Por Agotarse'): ?>
                                                    <span class="badge bg-warning text-dark">Por Agotarse</span>
                                                <?php elseif ($row['estado'] === 'Sobreabastecido'): ?>
                                                    <span class="badge bg-info text-dark">Sobreabastecido</span>
                                                <?php else: ?>
                                                    <span class="badge bg-success">Disponible</span>
                                                <?php endif; ?>
                                            </td>
                                        </tr>
                                    <?php endwhile; ?>
                                <?php else: ?>
                                    <tr><td colspan="6" class="py-4 text-success fw-bold"><i class="bi bi-check-circle me-1"></i> ¡Excelente! No hay alertas de stock bajo ni sobreabastecimiento en este momento.</td></tr>
                                <?php endif; ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        <!-- PESTAÑA ENTRADAS -->
        <?php elseif ($seccion == 'entradas'): ?>
            <div class="row">
                <div class="col-lg-4 mb-4">
                    <div class="card border-0 shadow-sm">
                        <div class="card-header bg-dark py-3">
                            <h5 class="fw-bold text-white mb-0"><i class="bi bi-box-arrow-in-down text-success me-2"></i>Registrar Entrada</h5>
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
                                                    <?php echo htmlspecialchars($prod['nombre_insumo']); ?> (Stock: <?php echo $prod['cantidad'] . ' ' . $prod['unidad_medida']; ?>)
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
                                    <label class="form-label fw-bold small">Proveedor</label>
                                    <input type="text" name="proveedor" class="form-control" placeholder="Ej. Distribuidora Maritime C.A." required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label fw-bold small">N° Factura</label>
                                    <input type="text" name="num_factura_orden" class="form-control" placeholder="FAC-00123">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label fw-bold small">Fecha Vencimiento</label>
                                    <input type="date" name="fecha_vencimiento" class="form-control">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label fw-bold small">Observaciones</label>
                                    <textarea name="observaciones" class="form-control" rows="2" placeholder="Notas de recepción..."></textarea>
                                </div>
                                <button type="submit" class="btn btn-dark fw-bold w-100"><i class="bi bi-save me-1"></i> Guardar</button>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm">
                        <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                            <h5 class="fw-bold text-secondary mb-0"><i class="bi bi-clock-history me-2"></i>Historial de Entradas</h5>
                            <a href="reporte_entradas.php" class="btn btn-success btn-sm fw-bold shadow-sm">
                                <i class="bi bi-filetype-xlsx me-1"></i> Descargar
                            </a>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0 small">
                                    <thead class="table-dark">
                                        <tr>
                                            <th>Fecha</th>
                                            <th>Insumo</th>
                                            <th>Cantidad</th>
                                            <th>Proveedor</th>
                                            <th>Factura</th>
                                            <th>Usuario</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php if ($historial_entradas && $historial_entradas->num_rows > 0): ?>
                                            <?php while ($e = $historial_entradas->fetch_assoc()): ?>
                                                <tr>
                                                    <td><?php echo date('d/m/Y H:i', strtotime($e['fecha_entrada'])); ?></td>
                                                    <td class="fw-bold"><?php echo htmlspecialchars($e['nombre_insumo']); ?></td>
                                                    <td class="text-success fw-bold">+<?php echo number_format($e['cantidad'], 2) . ' ' . $e['unidad_medida']; ?></td>
                                                    <td><?php echo htmlspecialchars($e['proveedor']); ?></td>
                                                    <td><code><?php echo htmlspecialchars($e['num_factura_orden']); ?></code></td>
                                                    <td><?php echo htmlspecialchars($e['usuario_nombre']); ?></td>
                                                </tr>
                                            <?php endwhile; ?>
                                        <?php else: ?>
                                            <tr><td colspan="6" class="text-center py-4 text-muted">No hay registros de entradas recientes.</td></tr>
                                        <?php endif; ?>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        <!-- PESTAÑA CONSUMO EN EL TALADRO -->
        <?php elseif ($seccion == 'salidas'): ?>
            <div class="row">
                <div class="col-lg-4 mb-4">
                    <div class="card border-0 shadow-sm">
                        <div class="card-header bg-dark py-3">
                            <h5 class="fw-bold text-white mb-0"><i class="bi bi-box-arrow-in-up text-danger me-2"></i>Registrar Consumo</h5>
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
                                                    <?php echo htmlspecialchars($prod['nombre_insumo']); ?> (Disponible: <?php echo $prod['cantidad'] . ' ' . $prod['unidad_medida']; ?>)
                                                </option>
                                            <?php endwhile; ?>
                                        <?php endif; ?>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label fw-bold small">Fecha del Consumo</label>
                                    <input type="date" name="fecha_salida" class="form-control" value="<?php echo date('Y-m-d'); ?>" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label fw-bold small">Cantidad Consumida</label>
                                    <input type="number" step="0.01" name="cantidad_salida" class="form-control" placeholder="Ej. 10.00" required>
                                </div>
                                
                                <div class="mb-3">
                                    <label class="form-label fw-bold small">Observaciones</label>
                                    <textarea name="observaciones" class="form-control" rows="2" placeholder="Notas sobre el consumo..."></textarea>
                                </div>
                                <button type="submit" class="btn btn-dark fw-bold w-100"><i class="bi bi-check2-circle me-1"></i> Registrar Consumo</button>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm">
                        <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                            <h5 class="fw-bold text-secondary mb-0"><i class="bi bi-clock-history me-2"></i>Historial de Consumo</h5>
                            <a href="reporte_salidas.php" class="btn btn-success btn-sm fw-bold shadow-sm">
                                <i class="bi bi-filetype-xlsx me-1"></i> Descargar
                            </a>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0 small">
                                    <thead class="table-dark">
                                        <tr>
                                            <th>Fecha</th>
                                            <th>Insumo</th>
                                            <th>Cantidad Consumida</th>
                                            <th>Usuario</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php if ($historial_salidas && $historial_salidas->num_rows > 0): ?>
                                            <?php while ($s = $historial_salidas->fetch_assoc()): ?>
                                                <tr>
                                                    <td><?php echo date('d/m/Y H:i', strtotime($s['fecha_salida'])); ?></td>
                                                    <td class="fw-bold"><?php echo htmlspecialchars($s['nombre_insumo']); ?></td>
                                                    <td class="text-danger fw-bold">-<?php echo number_format($s['cantidad_salida'], 2) . ' ' . $s['unidad_medida']; ?></td>
                                                    <td><?php echo htmlspecialchars($s['usuario_nombre']); ?></td>
                                                </tr>
                                            <?php endwhile; ?>
                                        <?php else: ?>
                                            <tr><td colspan="5" class="text-center py-4 text-muted">No hay registros de consumo recientes.</td></tr>
                                        <?php endif; ?>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        <!-- PESTAÑA ESTADÍSTICAS DE CONSUMO -->
        <?php elseif ($seccion == 'estadisticas'): ?>
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center flex-wrap gap-2">
                    <h5 class="fw-bold text-primary mb-0"><i class="bi bi-pie-chart-fill me-2"></i>Estadísticas y Porcentajes de Consumo por Insumo</h5>
                    
                    <form method="GET" action="inventario.php" class="d-flex align-items-center gap-2">
                        <input type="hidden" name="sec" value="estadisticas">
                        <label class="form-label fw-bold small mb-0">Filtrar por Semana:</label>
                        <select name="semana" class="form-select form-select-sm" onchange="this.form.submit()">
                            <option value="">-- Todas las Semanas (Acumulado) --</option>
                            <?php if ($res_semanas_disponibles && $res_semanas_disponibles->num_rows > 0): ?>
                                <?php while ($sem = $res_semanas_disponibles->fetch_assoc()): 
                                    $val_sem = $sem['anio_semana'];
                                    $anio = substr($val_sem, 0, 4);
                                    $num_s = substr($val_sem, 4);
                                ?>
                                    <option value="<?php echo $val_sem; ?>" <?php echo ($semana_filtro === $val_sem) ? 'selected' : ''; ?>>
                                        Semana N° <?php echo $num_s; ?> (Año <?php echo $anio; ?>)
                                    </option>
                                <?php endwhile; ?>
                            <?php endif; ?>
                        </select>
                        <?php if (!empty($semana_filtro)): ?>
                            <a href="inventario.php?sec=estadisticas" class="btn btn-outline-secondary btn-sm" title="Ver todo"><i class="bi bi-x-lg"></i></a>
                        <?php endif; ?>
                    </form>
                </div>
                <div class="card-body">
                    <div class="mb-3 p-3 bg-light rounded border d-flex justify-content-between align-items-center">
                        <span class="fw-bold text-secondary">
                            <i class="bi bi-calendar-range me-1"></i> Período seleccionado: 
                            <?php echo !empty($semana_filtro) ? "Semana N° " . substr($semana_filtro, 4) . " (Año " . substr($semana_filtro, 0, 4) . ")" : "Histórico General Acumulado"; ?>
                        </span>
                        <span class="badge bg-primary fs-6">Total Consumido en el Período: 
                            <?php 
                                $q_tot_gen = $conexion->query("SELECT SUM(cantidad_salida) as general FROM salidas_insumos " . (!empty($semana_filtro) ? "WHERE YEARWEEK(fecha_salida, 1) = '$semana_filtro'" : ""));
                                $res_gen = ($q_tot_gen) ? $q_tot_gen->fetch_assoc()['general'] : 0;
                                echo number_format($res_gen, 2); 
                            ?>
                        </span>
                    </div>

                    <?php if ($res_estadisticas_consumo && $res_estadisticas_consumo->num_rows > 0): ?>
                        <?php while ($c = $res_estadisticas_consumo->fetch_assoc()): 
                            $tot_gen = floatval($c['total_general']);
                            $tot_sal = floatval($c['total_salida']);
                            $pct = ($tot_gen > 0) ? ($tot_sal / $tot_gen) * 100 : 0;
                            $bg_badge = ($c['tipo_rubro'] === 'Consumible') ? 'bg-success' : 'bg-secondary';
                        ?>
                            <div class="mb-3 p-3 bg-white rounded border shadow-sm">
                                <div class="d-flex justify-content-between align-items-center mb-1">
                                    <div>
                                        <span class="fw-bold fs-6 text-dark"><?php echo htmlspecialchars($c['nombre_insumo']); ?></span>
                                        <span class="badge <?php echo $bg_badge; ?> ms-2"><?php echo htmlspecialchars($c['tipo_rubro']); ?></span>
                                        <span class="badge bg-light text-dark border ms-1"><?php echo htmlspecialchars($c['categoria']); ?></span>
                                    </div>
                                    <div class="text-end">
                                        <span class="fw-bold text-danger fs-5 me-3">
                                            <i class="bi bi-arrow-up-right-circle me-1"></i> <?php echo number_format($tot_sal, 2) . ' ' . htmlspecialchars($c['unidad_medida']); ?>
                                        </span>
                                        <span class="fw-bold text-primary fs-5">(<?php echo number_format($pct, 1); ?>%)</span>
                                    </div>
                                </div>
                                <div class="progress" style="height: 12px;">
                                    <div class="progress-bar <?php echo ($c['tipo_rubro'] === 'Consumible') ? 'bg-success' : 'bg-secondary'; ?>" 
                                         role="progressbar" 
                                         style="width: <?php echo $pct; ?>%;" 
                                         aria-valuenow="<?php echo $pct; ?>" 
                                         aria-valuemin="0" 
                                         aria-valuemax="100">
                                    </div>
                                </div>
                            </div>
                        <?php endwhile; ?>
                    <?php else: ?>
                        <div class="text-center text-muted py-5">
                            <i class="bi bi-info-circle fs-1 text-secondary mb-2 d-block"></i>
                            Aún no hay registros de consumo para el período seleccionado.
                        </div>
                    <?php endif; ?>
                </div>
            </div>
        <?php endif; ?>

    </div>

    <!-- MODAL NUEVO INSUMO -->
    <div class="modal fade" id="modalNuevoInsumo" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form method="POST" action="inventario.php?sec=maestro">
                    <input type="hidden" name="accion" value="guardar_insumo">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title fw-bold"><i class="bi bi-box-seam me-2"></i>Nuevo Insumo</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body row g-3">
                        <div class="col-12">
                            <label class="form-label fw-bold small">Nombre del Insumo</label>
                            <input type="text" name="nombre_insumo" class="form-control" placeholder="Ej. Harina de Trigo Todo Uso" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small">Tipo de Rubro</label>
                            <select name="tipo_rubro" class="form-select" required>
                                <option value="Consumible">Consumible</option>
                                <option value="No Consumible">No Consumible</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small">Categoría</label>
                            <input type="text" name="categoria" class="form-control" placeholder="Ej. Víveres / Limpieza" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small">Unidad de Medida Base</label>
                            <input type="text" name="unidad_medida" class="form-control" placeholder="Kg, Lts, Uds" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small">Presentación / Empaque</label>
                            <select name="unidad_empaque" class="form-select" required>
                                <option value="Bolsa">Bolsa</option>
                                <option value="Caja">Caja</option>
                                <option value="Cesta">Cesta</option>
                                <option value="Cuñete">Cuñete</option>
                                <option value="Envase">Envase</option>
                                <option value="Galón">Galón</option>
                                <option value="Lata">Lata</option>
                                <option value="Paca">Paca</option>
                                <option value="Paquete">Paquete</option>
                                <option value="Panela">Panela</option>
                                <option value="Saco">Saco / Bulto</option>
                                <option value="Unidad">Unidad / Pieza</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small">Contenido por Empaque</label>
                            <input type="number" step="0.01" name="contenido_por_empaque" class="form-control" placeholder="Ej. 24" value="1.00" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small">Cantidad Inicial</label>
                            <input type="number" step="0.01" name="cantidad_inicial" class="form-control" placeholder="Ej. 0.5 o 12" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small">¿Cómo ingresa la cantidad?</label>
                            <select name="tipo_ingreso_inicial" class="form-select">
                                <option value="unidades">Unidades / Kilos sueltos</option>
                                <option value="empaques">Cajas / Empaques (ej. 0.5 = media)</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small">Stock Mínimo</label>
                            <input type="number" step="0.01" name="stock_minimo" class="form-control" placeholder="10.00" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small">Stock Máximo</label>
                            <input type="number" step="0.01" name="stock_maximo" class="form-control" placeholder="100.00" value="0.00">
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

   <!-- MODAL EDITAR INSUMO -->
    <div class="modal fade" id="modalEditarInsumo" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form method="POST" action="inventario.php?sec=maestro">
                    <input type="hidden" name="accion" value="editar_insumo">
                    <input type="hidden" name="id_producto" id="edit_id_producto">
                    <input type="hidden" name="filtro_categoria_actual" id="edit_filtro_categoria" value="">
                    <input type="hidden" name="filtro_busqueda_actual" id="edit_filtro_busqueda" value="">
                    <div class="modal-header bg-warning text-dark">
                        <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square me-2"></i>Editar Insumo</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body row g-3">
                        <div class="col-12">
                            <label class="form-label fw-bold small">Nombre del Insumo</label>
                            <input type="text" name="nombre_insumo" id="edit_nombre" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small">Tipo de Rubro</label>
                            <select name="tipo_rubro" id="edit_tiporubro" class="form-select" required>
                                <option value="Consumible">Consumible</option>
                                <option value="No Consumible">No Consumible</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small">Categoría</label>
                            <input type="text" name="categoria" id="edit_categoria" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small">Unidad Base</label>
                            <input type="text" name="unidad_medida" id="edit_unidad" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small">Presentación / Empaque</label>
                            <select name="unidad_empaque" id="edit_empaque" class="form-select" required>
                                <option value="Bolsa">Bolsa</option>
                                <option value="Caja">Caja</option>
                                <option value="Cesta">Cesta</option>
                                <option value="Cuñete">Cuñete</option>
                                <option value="Envase">Envase</option>
                                <option value="Galón">Galón</option>
                                <option value="Lata">Lata</option>
                                <option value="Paca">Paca</option>
                                <option value="Paquete">Paquete</option>
                                <option value="Panela">Panela</option>
                                <option value="Saco">Saco / Bulto</option>
                                <option value="Unidad">Unidad / Pieza</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small">Contenido por Empaque</label>
                            <input type="number" step="0.01" name="contenido_por_empaque" id="edit_contenido" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small">Existencia Actual</label>
                            <input type="number" step="0.01" name="cantidad" id="edit_cantidad" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small">¿Cómo ingresa la cantidad?</label>
                            <select name="tipo_ingreso_editar" class="form-select">
                                <option value="unidades">Unidades / Kilos sueltos</option>
                                <option value="empaques">Cajas / Empaques (ej. 0.5 = media)</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label fw-bold small">Stock Mínimo</label>
                            <input type="number" step="0.01" name="stock_minimo" id="edit_stock" class="form-control" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label fw-bold small">Stock Máximo</label>
                            <input type="number" step="0.01" name="stock_maximo" id="edit_stock_max" class="form-control" value="0.00">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-warning fw-bold text-dark">Actualizar Insumo</button>
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
            document.getElementById('edit_id_producto').value = button.getAttribute('data-id');
            document.getElementById('edit_nombre').value = button.getAttribute('data-nombre');
            document.getElementById('edit_tiporubro').value = button.getAttribute('data-tiporubro') || 'Consumible';
            document.getElementById('edit_categoria').value = button.getAttribute('data-categoria');
            document.getElementById('edit_unidad').value = button.getAttribute('data-unidad');
            document.getElementById('edit_empaque').value = button.getAttribute('data-empaque');
            
            let contenido = parseFloat(button.getAttribute('data-contenido')) || 1;
            let cantidadTotal = parseFloat(button.getAttribute('data-cantidad')) || 0;
            
            document.getElementById('edit_contenido').value = contenido.toFixed(2);
            document.getElementById('edit_cantidad').value = cantidadTotal.toFixed(2);

            document.getElementById('edit_stock').value = button.getAttribute('data-stock');
            document.getElementById('edit_stock_max').value = button.getAttribute('data-stockmax') || '0.00';

            const urlParams = new URLSearchParams(window.location.search);
            document.getElementById('edit_filtro_categoria').value = urlParams.get('categoria') || '';
            document.getElementById('edit_filtro_busqueda').value = urlParams.get('buscar') || '';
        });
    }
</script>
</body>
</html>