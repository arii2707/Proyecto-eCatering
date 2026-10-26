<?php
session_start();
if (!isset($_SESSION['id_usuario'])) {
    header("Location: index.php");
    exit();
}

// CONTROL DE ACCESO (RBAC) con los valores exactos del ENUM
$roles_permitidos = ['Coord.(a) catering', 'Superv.(a) catering', 'Administrador'];

if (!isset($_SESSION['rol']) || !in_array($_SESSION['rol'],$roles_permitidos)) {
    header("Location: dashboard.php?error=acceso_denegado");
    exit();
}

require_once "config/conexion.php";

// 1. Lógica para Registrar Nuevo Usuario
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['registrar_usuario'])) {$nombre = $conexion->real_escape_string($_POST['nombre']);
    $email =$conexion->real_escape_string($_POST['email']);$password = password_hash($_POST['password'], PASSWORD_BCRYPT);$rol = $conexion->real_escape_string($_POST['rol']);

    $check =$conexion->query("SELECT id_usuario FROM usuarios WHERE email = '$email'");
    if ($check &&$check->num_rows > 0) {
        header("Location: usuarios.php?mensaje=error_email");
        exit();
    } else {
        $sql_insert = "INSERT INTO usuarios (nombre, email, password, rol) 
                       VALUES ('$nombre', '$email', '$password', '$rol')";
        if ($conexion->query($sql_insert)) {
            header("Location: usuarios.php?mensaje=guardado");
            exit();
        } else {
            $error = "Error al registrar usuario: " . $conexion->error;
        }
    }
}

// 2. Lógica para Actualizar Usuario
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['actualizar_usuario'])) {
    $id_usuario = intval($_POST['id_usuario']);
    $nombre =$conexion->real_escape_string($_POST['nombre']);$rol = $conexion->real_escape_string($_POST['rol']);

    $sql_update = "UPDATE usuarios SET nombre = '$nombre', rol = '$rol' WHERE id_usuario =$id_usuario";
    if ($conexion->query($sql_update)) {
        header("Location: usuarios.php?mensaje=actualizado");
        exit();
    } else {
        $error = "Error al actualizar: " . $conexion->error;
    }
}

// 3. Lógica para Restablecer Contraseña
if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST['reset_password'])) {
    $id_usuario = intval($_POST['id_usuario']);
    $nueva_clave = password_hash($_POST['nueva_password'], PASSWORD_BCRYPT);

    $sql_pass = "UPDATE usuarios SET password = '$nueva_clave' WHERE id_usuario =$id_usuario";
    if ($conexion->query($sql_pass)) {
        header("Location: usuarios.php?mensaje=clave_reset");
        exit();
    }
}

// 4. Lógica para Eliminar Usuario
if (isset($_GET['eliminar'])) {
    $id_a_eliminar = intval($_GET['eliminar']);

    // Validación de seguridad: No permitir que el usuario borre su propia cuenta activa
    if ($id_a_eliminar === intval($_SESSION['id_usuario'])) {
        header("Location: usuarios.php?mensaje=error_auto_eliminacion");
        exit();
    }

    $sql_delete = "DELETE FROM usuarios WHERE id_usuario = $id_a_eliminar";
    if ($conexion->query($sql_delete)) {
        header("Location: usuarios.php?mensaje=eliminado");
        exit();
    } else {
        header("Location: usuarios.php?mensaje=error_eliminar");
        exit();
    }
}

// Filtro y Búsqueda
$busqueda = isset($_GET['buscar']) ? $conexion->real_escape_string(trim($_GET['buscar'])) : '';
$filtro_rol = isset($_GET['filtro_rol']) ? $conexion->real_escape_string($_GET['filtro_rol']) : '';

$conditions = [];
if ($busqueda != '') {$conditions[] = "(nombre LIKE '%$busqueda%' OR email LIKE '%$busqueda%')";
}
if ($filtro_rol != '') {
    $conditions[] = "rol = '$filtro_rol'";
}

$where_sql = count($conditions) > 0 ? "WHERE " . implode(" AND ", $conditions) : "";
$sql_usuarios = "SELECT * FROM usuarios $where_sql ORDER BY id_usuario DESC";
$resultado = $conexion->query($sql_usuarios);
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>eCatering - Gestión de Usuarios</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">

    <!-- Navegación -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary px-4 shadow-sm">
        <a class="navbar-brand fw-bold" href="dashboard.php">eCatering System</a>
        <div class="ms-auto d-flex align-items-center text-white">
            <span class="me-3"><strong><?php echo $_SESSION['nombre']; ?></strong> (<?php echo$_SESSION['rol']; ?>)</span>
            <a href="dashboard.php" class="btn btn-outline-light btn-sm me-2">
                <i class="bi bi-speedometer2 me-1"></i>Volver al Panel
            </a>
            <a href="logout.php" class="btn btn-outline-light btn-sm">
                <i class="bi bi-box-arrow-right me-1"></i>Cerrar Sesión
            </a>
        </div>
    </nav>

    <div class="container-fluid px-4 my-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
            <div>
                <h3 class="fw-bold text-primary mb-1">
                    <i class="bi bi-shield-lock-fill me-2"></i>Gestión de Usuarios Privilegiada
                </h3>
                <p class="text-muted small mb-0">Módulo exclusivo para Coordinadores y Supervisores de Catering.</p>
            </div>
            <button class="btn btn-primary shadow-sm fw-bold px-3" data-bs-toggle="modal" data-bs-target="#modalNuevoUsuario">
                <i class="bi bi-person-plus-fill me-1"></i> Registrar Nuevo Usuario
            </button>
        </div>

        <!-- Alertas de Estado -->
        <?php if (isset($_GET['mensaje'])): ?>
            <?php if ($_GET['mensaje'] === 'guardado'): ?>
                <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i> Usuario creado correctamente.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <?php elseif ($_GET['mensaje'] === 'actualizado'): ?>
                <div class="alert alert-info alert-dismissible fade show shadow-sm" role="alert">
                    <i class="bi bi-info-circle-fill me-2"></i> Datos de usuario actualizados correctamente.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <?php elseif ($_GET['mensaje'] === 'clave_reset'): ?>
                <div class="alert alert-warning alert-dismissible fade show shadow-sm" role="alert">
                    <i class="bi bi-key-fill me-2"></i> Contraseña restablecida exitosamente.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <?php elseif ($_GET['mensaje'] === 'eliminado'): ?>
                <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                    <i class="bi bi-trash-fill me-2"></i> Usuario eliminado exitosamente del sistema.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <?php elseif ($_GET['mensaje'] === 'error_email'): ?>
                <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i> El correo ingresado ya se encuentra registrado.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <?php elseif ($_GET['mensaje'] === 'error_auto_eliminacion'): ?>
                <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                    <i class="bi bi-shield-exclamation me-2"></i> <strong>Acción Denegada:</strong> No puedes eliminar tu propia cuenta mientras estás logueado.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            <?php endif; ?>
        <?php endif; ?>

        <!-- BARRA DE BÚSQUEDA Y FILTROS -->
        <div class="card border-0 shadow-sm mb-4">
            <div class="card-body bg-white rounded">
                <form method="GET" action="" class="row g-3 align-items-end">
                    <div class="col-md-5">
                        <label class="form-label fw-bold small text-secondary">Buscar Usuario / Correo</label>
                        <div class="input-group input-group-sm">
                            <span class="input-group-text"><i class="bi bi-search"></i></span>
                            <input type="text" name="buscar" class="form-control" placeholder="Nombre o Correo..." value="<?php echo htmlspecialchars($busqueda); ?>">
                        </div>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-bold small text-secondary">Filtrar por Rol ENUM</label>
                        <select name="filtro_rol" class="form-select form-select-sm">
                            <option value="">Todos los Roles</option>
                            <option value="Coord.(a) catering" <?php echo $filtro_rol == 'Coord.(a) catering' ? 'selected' : ''; ?>>Coord.(a) catering</option>
                            <option value="Superv.(a) catering" <?php echo $filtro_rol == 'Superv.(a) catering' ? 'selected' : ''; ?>>Superv.(a) catering</option>
                            <option value="Esp. Almacen" <?php echo $filtro_rol == 'Esp. Almacen' ? 'selected' : ''; ?>>Esp. Almacen</option>
                        </select>
                    </div>
                    <div class="col-md-3 d-flex gap-2">
                        <button type="submit" class="btn btn-primary btn-sm fw-bold w-100 shadow-sm"><i class="bi bi-funnel me-1"></i> Filtrar</button>
                        <a href="usuarios.php" class="btn btn-outline-secondary btn-sm w-100">Limpiar</a>
                    </div>
                </form>
            </div>
        </div>

        <!-- TABLA DE USUARIOS -->
        <div class="card border-0 shadow-sm">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-dark">
                            <tr>
                                <th>Usuario / Nombre</th>
                                <th>Correo Electrónico</th>
                                <th>Rol Operativo</th>
                                <th class="text-center">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if ($resultado &&$resultado->num_rows > 0): ?>
                                <?php while ($user =$resultado->fetch_assoc()): ?>
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-2 fw-bold" style="width: 38px; height: 38px; font-size: 14px;">
                                                    <?php echo strtoupper(substr($user['nombre'], 0, 2)); ?>
                                                </div>
                                                <div>
                                                    <strong class="text-dark d-block"><?php echo htmlspecialchars($user['nombre']); ?></strong>
                                                    <span class="text-muted extra-small" style="font-size: 11px;">ID: #<?php echo $user['id_usuario']; ?></span>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="small"><i class="bi bi-envelope me-1 text-muted"></i><?php echo htmlspecialchars($user['email']); ?></td>
                                        <td>
                                            <?php 
                                            $rol_badge = "bg-secondary";
                                            if ($user['rol'] == 'Coord.(a) catering')$rol_badge = "bg-primary";
                                            elseif ($user['rol'] == 'Superv.(a) catering')$rol_badge = "bg-info text-dark";
                                            elseif ($user['rol'] == 'Esp. Almacen') $rol_badge = "bg-warning text-dark";
                                            ?>
                                            <span class="badge <?php echo $rol_badge; ?> px-2 py-1"><?php echo htmlspecialchars($user['rol']); ?></span>
                                        </td>
                                        <td class="text-center">
                                            <div class="d-flex justify-content-center gap-1">
                                                <!-- Botón Editar -->
                                                <button class="btn btn-sm btn-outline-primary fw-bold" 
                                                        data-bs-toggle="modal" 
                                                        data-bs-target="#modalEditarUsuario"
                                                        data-id="<?php echo $user['id_usuario']; ?>"
                                                        data-nombre="<?php echo htmlspecialchars($user['nombre']); ?>"
                                                        data-email="<?php echo htmlspecialchars($user['email']); ?>"
                                                        data-rol="<?php echo $user['rol']; ?>"
                                                        title="Editar Usuario">
                                                    <i class="bi bi-pencil-square"></i>
                                                </button>

                                                <!-- Botón Cambiar Clave -->
                                                <button class="btn btn-sm btn-outline-warning text-dark fw-bold" 
                                                        data-bs-toggle="modal" 
                                                        data-bs-target="#modalResetPass"
                                                        data-id="<?php echo $user['id_usuario']; ?>"
                                                        data-nombre="<?php echo htmlspecialchars($user['nombre']); ?>"
                                                        title="Restablecer Contraseña">
                                                    <i class="bi bi-key-fill"></i>
                                                </button>

                                                <!-- Botón Eliminar -->
                                                <button class="btn btn-sm btn-outline-danger fw-bold" 
                                                        onclick="confirmarEliminacion(<?php echo $user['id_usuario']; ?>, '<?php echo htmlspecialchars($user['nombre'], ENT_QUOTES); ?>')"
                                                        title="Eliminar Usuario">
                                                    <i class="bi bi-trash-fill"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                <?php endwhile; ?>
                            <?php else: ?>
                                <tr>
                                    <td colspan="4" class="text-center text-muted py-5">
                                        <i class="bi bi-people fs-2 d-block mb-2 text-secondary"></i> No se encontraron usuarios registrados.
                                    </td>
                                </tr>
                            <?php endif; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL: CREAR NUEVO USUARIO -->
    <div class="modal fade" id="modalNuevoUsuario" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form method="POST" action="">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title fw-bold"><i class="bi bi-person-plus-fill me-2"></i>Registrar Nuevo Usuario</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body row g-3">
                        <div class="col-12">
                            <label class="form-label fw-bold">Nombre Completo</label>
                            <input type="text" name="nombre" class="form-control" placeholder="Ej. Carlos Mendoza" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-bold">Correo Electrónico</label>
                            <input type="email" name="email" class="form-control" placeholder="ejemplo@maritime.com" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-bold">Contraseña Inicial</label>
                            <input type="password" name="password" class="form-control" minlength="6" placeholder="Mínimo 6 caracteres" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-bold">Rol Operativo</label>
                            <select name="rol" class="form-select" required>
                                <option value="Coord.(a) catering">Coord.(a) catering</option>
                                <option value="Superv.(a) catering">Superv.(a) catering</option>
                                <option value="Esp. Almacen">Esp. Almacen</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" name="registrar_usuario" class="btn btn-primary fw-bold">Guardar Usuario</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- MODAL: EDITAR USUARIO -->
    <div class="modal fade" id="modalEditarUsuario" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form method="POST" action="">
                    <input type="hidden" name="actualizar_usuario" value="1">
                    <input type="hidden" name="id_usuario" id="edit_user_id">
                    <div class="modal-header bg-warning text-dark">
                        <h5 class="modal-title fw-bold"><i class="bi bi-pencil-square me-2"></i>Editar Usuario</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body row g-3">
                        <div class="col-12">
                            <label class="form-label fw-bold">Nombre Completo</label>
                            <input type="text" name="nombre" id="edit_user_nombre" class="form-control" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-bold text-muted">Correo Electrónico (No modificable)</label>
                            <input type="email" id="edit_user_email" class="form-control bg-light" readonly>
                        </div>
                        <div class="col-12">
                            <label class="form-label fw-bold">Rol Asignado</label>
                            <select name="rol" id="edit_user_rol" class="form-select" required>
                                <option value="Coord.(a) catering">Coord.(a) catering</option>
                                <option value="Superv.(a) catering">Superv.(a) catering</option>
                                <option value="Esp. Almacen">Esp. Almacen</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-warning fw-bold">Actualizar Datos</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- MODAL: RESTABLECER CONTRASEÑA -->
    <div class="modal fade" id="modalResetPass" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <form method="POST" action="">
                    <input type="hidden" name="reset_password" value="1">
                    <input type="hidden" name="id_usuario" id="reset_user_id">
                    <div class="modal-header bg-warning text-dark">
                        <h5 class="modal-title fw-bold"><i class="bi bi-key-fill me-2"></i>Restablecer Contraseña</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body py-3">
                        <p class="mb-3">Ingresa la nueva contraseña para el usuario <strong id="reset_user_nombre" class="text-primary"></strong>:</p>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Nueva Contraseña</label>
                            <input type="password" name="nueva_password" class="form-control" minlength="6" placeholder="Ingresa la nueva clave..." required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <button type="submit" class="btn btn-warning fw-bold">Cambiar Contraseña</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const modalEditar = document.getElementById('modalEditarUsuario');
        if (modalEditar) {
            modalEditar.addEventListener('show.bs.modal', function (event) {
                const button = event.relatedTarget;
                document.getElementById('edit_user_id').value = button.getAttribute('data-id');
                document.getElementById('edit_user_nombre').value = button.getAttribute('data-nombre');
                document.getElementById('edit_user_email').value = button.getAttribute('data-email');
                document.getElementById('edit_user_rol').value = button.getAttribute('data-rol');
            });
        }

        const modalReset = document.getElementById('modalResetPass');
        if (modalReset) {
            modalReset.addEventListener('show.bs.modal', function (event) {
                const button = event.relatedTarget;
                document.getElementById('reset_user_id').value = button.getAttribute('data-id');
                document.getElementById('reset_user_nombre').textContent = button.getAttribute('data-nombre');
            });
        }

        function confirmarEliminacion(id, nombre) {
            if (confirm(`¿Estás segura de que deseas eliminar al usuario "${nombre}"? Esta acción no se puede deshacer.`)) {
                window.location.href = `usuarios.php?eliminar=${id}`;
            }
        }
    </script>
</body>
</html>