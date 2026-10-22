<?php
session_start();
require_once "config/conexion.php";

$error = "";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Cambiamos a nombre de usuario
    $nombre_usuario = $conexion->real_escape_string($_POST['nombre']);
    $password_ingresada = $_POST['password'];

    // Buscamos al usuario por su nombre en la base de datos
    $sql = "SELECT * FROM usuarios WHERE nombre = '$nombre_usuario'";
    $resultado = $conexion->query($sql);

    if ($resultado && $resultado->num_rows > 0) {
        $usuario = $resultado->fetch_assoc();
        
        // Verificación segura de la contraseña encriptada con BCRYPT
        if (password_verify($password_ingresada, $usuario['password'])) {
            $_SESSION['id_usuario'] = $usuario['id_usuario'];
            $_SESSION['nombre'] = $usuario['nombre'];
            $_SESSION['rol'] = $usuario['rol'];
            
            header("Location: dashboard.php");
            exit();
        } else {
            $error = "Contraseña incorrecta.";
        }
    } else {
        $error = "El usuario no está registrado.";
    }
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>eCatering - Iniciar Sesión</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center vh-100">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-4">
                <div class="card shadow-lg border-0 rounded-3">
                    <div class="card-body p-4">
                        <h4 class="text-center fw-bold mb-1">eCatering</h4>
                        <p class="text-center text-muted small mb-4">Maritime Contractors de Venezuela S.A.</p>

                        <?php if ($error): ?>
                            <div class="alert alert-danger py-2 small"><?php echo $error; ?></div>
                        <?php endif; ?>

                        <form method="POST" action="">
                            <div class="mb-3">
                                <label class="form-label text-secondary small fw-bold">Nombre de Usuario</label>
                                <!-- Cambiado de type="email" a type="text" y name="nombre" -->
                                <input type="text" name="nombre" class="form-control" placeholder="Ej. Carlos Mendoza" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label text-secondary small fw-bold">Contraseña</label>
                                <input type="password" name="password" class="form-control" placeholder="••••••••" required>
                            </div>
                            <button type="submit" class="btn btn-primary w-100 mt-2">Ingresar al Sistema</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>