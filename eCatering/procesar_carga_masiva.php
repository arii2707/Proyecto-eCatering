<?php
session_start();
if (!isset($_SESSION['id_usuario'])) {
    header("Location: index.php");
    exit();
}

require_once "config/conexion.php";

// Función para autogenerar un código SKU secuencial por tipo de rubro
function generarCodigoSKU($conexion, $tipo_rubro) {
    $prefix = ($tipo_rubro === 'Consumible') ? 'COM-' : 'NC-';
    
    $sql = "SELECT codigo_sku FROM inventario WHERE codigo_sku LIKE '$prefix%' ORDER BY id_producto DESC LIMIT 1";
    $res = $conexion->query($sql);
    
    if ($res && $res->num_rows > 0) {
        $row = $res->fetch_assoc();
        $ultimo_codigo = $row['codigo_sku'];
        $numero = intval(substr($ultimo_codigo, strlen($prefix)));
        $nuevo_numero = $numero + 1;
    } else {
        $nuevo_numero = 1;
    }
    
    return $prefix . str_pad($nuevo_numero, 4, '0', STR_PAD_LEFT);
}

// Función auxiliar para calcular el estatus de stock
function calcularEstadoStock($cantidad, $stock_minimo, $stock_maximo = 0) {
    $cantidad = floatval($cantidad);
    $stock_minimo = floatval($stock_minimo);
    $stock_maximo = floatval($stock_maximo);

    if ($cantidad <= 0) {
        return 'Agotado';
    } elseif ($stock_maximo > 0 && $cantidad > $stock_maximo) {
        return 'Sobreabastecido'; // <-- Se evalúa primero antes del mínimo
    } elseif ($cantidad <= $stock_minimo) {
        return 'Por Agotarse';
    } else {
        return 'Disponible';
    }
}

// Procesamiento de Confirmación y Carga en Base de Datos
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['confirmar_carga'])) {
    $datos_subidos = json_decode($_POST['datos_validados'], true);
    $nombre_archivo = $conexion->real_escape_string($_POST['nombre_archivo']);
    $id_usuario = $_SESSION['id_usuario'];

    if (!empty($datos_subidos)) {
        $exitosos = 0;
        $errores = 0;

        $conexion->begin_transaction();

        try {
            foreach ($datos_subidos as $item) {
                // Si la fila tiene errores reportados en la validación, la omitimos o contamos como error
                if (!empty($item['errores'])) {
                    $errores++;
                    continue;
                }

                $nombre = $conexion->real_escape_string($item['nombre_insumo']);
                $tipo_rubro = $conexion->real_escape_string($item['tipo_rubro']);
                $categoria = $conexion->real_escape_string($item['categoria']);
                $cantidad = floatval($item['cantidad']);
                $unidad = $conexion->real_escape_string($item['unidad_medida']);
                $stock_min = floatval($item['stock_minimo']);
                $stock_max = floatval($item['stock_maximo']);

                // Generar o usar código SKU
                $sku = !empty($item['codigo_sku']) ? $conexion->real_escape_string($item['codigo_sku']) : generarCodigoSKU($conexion, $tipo_rubro);
                $estado = calcularEstadoStock($cantidad, $stock_min, $stock_max);

                // Comprobar si el producto o SKU ya existe
                $check = $conexion->query("SELECT id_producto, cantidad FROM inventario WHERE codigo_sku = '$sku' OR nombre_insumo = '$nombre'");
                
                if ($check && $check->num_rows > 0) {
                    // Si ya existe, actualizamos el stock sumando la nueva cantidad
                    $existente = $check->fetch_assoc();
                    $nueva_cant = $existente['cantidad'] + $cantidad;
                    $nuevo_estado = calcularEstadoStock($nueva_cant, $stock_min, $stock_max);
                    
                    $sql_upd = "UPDATE inventario SET cantidad = $nueva_cant, estado = '$nuevo_estado' WHERE id_producto = " . $existente['id_producto'];
                    $conexion->query($sql_upd);
                } else {
                    // Si no existe, se inserta como nuevo registro con su código autogenerado
                    $sql_ins = "INSERT INTO inventario (codigo_sku, nombre_insumo, tipo_rubro, categoria, cantidad, unidad_medida, stock_minimo, stock_maximo, estado) 
                                VALUES ('$sku', '$nombre', '$tipo_rubro', '$categoria', $cantidad, '$unidad', $stock_min, $stock_max, '$estado')";
                    $conexion->query($sql_ins);
                }

                $exitosos++;
            }

            // Registrar en el log de cargas masivas
            $total_filas = count($datos_subidos);
            $sql_log_carga = "INSERT INTO cargas_masivas_log (id_usuario, nombre_archivo, total_registros, registros_exitosos, registros_con_error, estado_lote) 
                              VALUES ($id_usuario, '$nombre_archivo', $total_filas, $exitosos, $errores, 'Procesado')";
            $conexion->query($sql_log_carga);

            // Registrar en la bitácora del sistema
            registrarLog($conexion, $id_usuario, "CARGA_MASIVA", "Procesó lote masivo '$nombre_archivo': $exitosos exitosos, $errores errores.");

            $conexion->commit();
            header("Location: inventario.php?sec=maestro&mensaje=importado_exito");
            exit();

        } catch (Exception $e) {
            $conexion->rollback();
            die("Error en el procesamiento masivo: " . $e->getMessage());
        }
    }
}
?>