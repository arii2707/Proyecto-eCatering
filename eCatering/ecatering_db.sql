-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 14-10-2026 a las 21:41:41
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `ecatering_db`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `certificados_salud`
--

CREATE TABLE `certificados_salud` (
  `id_certificado` int(11) NOT NULL,
  `cedula` varchar(20) NOT NULL,
  `nombre_personal` varchar(150) NOT NULL,
  `cargo` varchar(100) DEFAULT NULL,
  `cuadrilla` varchar(20) DEFAULT NULL,
  `fecha_emision` date NOT NULL,
  `fecha_vencimiento` date NOT NULL,
  `estado_vigencia` enum('Vigente','Por Vencer','Vencido') DEFAULT 'Vigente'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `certificados_salud`
--

INSERT INTO `certificados_salud` (`id_certificado`, `cedula`, `nombre_personal`, `cargo`, `cuadrilla`, `fecha_emision`, `fecha_vencimiento`, `estado_vigencia`) VALUES
(1, '29.984.325', 'Ariadna Colmenares', 'Ayudante', 'A', '2026-10-07', '2027-01-12', 'Vigente'),
(2, '123456', 'José Perez', 'Cocinero', 'B', '2026-01-01', '2027-10-15', 'Vigente');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `inventario`
--

CREATE TABLE `inventario` (
  `id_producto` int(11) NOT NULL,
  `nombre_insumo` varchar(150) NOT NULL,
  `categoria` varchar(50) DEFAULT NULL,
  `cantidad` decimal(10,2) NOT NULL DEFAULT 0.00,
  `unidad_medida` varchar(20) NOT NULL,
  `stock_minimo` decimal(10,2) DEFAULT 5.00,
  `estado` enum('Disponible','Por Agotarse','Agotado') DEFAULT 'Disponible'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `inventario`
--

INSERT INTO `inventario` (`id_producto`, `nombre_insumo`, `categoria`, `cantidad`, `unidad_medida`, `stock_minimo`, `estado`) VALUES
(1, 'Arroz Blanco Superior', 'Víveres', 150.00, 'Kg', 30.00, 'Disponible'),
(2, 'Harina de Maíz Precocida', 'Víveres', 200.00, 'Kg', 50.00, 'Disponible'),
(3, 'Aceite Vegetal 1L', 'Víveres', 20.00, 'Lts', 15.00, 'Disponible'),
(4, 'Azúcar Refinada', 'Víveres', 38.00, 'Kg', 20.00, 'Disponible'),
(5, 'Pasta Plumas', 'Víveres', 80.00, 'Kg', 20.00, 'Disponible'),
(6, 'Caraotas Negras', 'Víveres', 45.00, 'Kg', 10.00, 'Disponible'),
(7, 'Pechuga de Pollo Deshuesada', 'Proteínas', 65.00, 'Kg', 15.00, 'Disponible'),
(8, 'Carne de Res para Mechar', 'Proteínas', 30.00, 'Kg', 25.00, 'Disponible'),
(9, 'Chuleta de Cerdo Ahumada', 'Proteínas', 30.00, 'Kg', 10.00, 'Disponible'),
(10, 'Filet de Merluza', 'Proteínas', 20.00, 'Kg', 8.00, 'Disponible'),
(11, 'Queso Blanco Duro', 'Lácteos', 22.00, 'Kg', 5.00, 'Disponible'),
(12, 'Mantequilla con Sal 500g', 'Lácteos', 18.00, 'PCE', 5.00, 'Disponible'),
(13, 'Leche Completa en Polvo', 'Lácteos', 15.00, 'Kg', 10.00, 'Disponible'),
(14, 'Tomate Perita', 'Vegetales', 25.00, 'Kg', 8.00, 'Disponible'),
(15, 'Cebolla Blanca', 'Vegetales', 18.00, 'Kg', 5.00, 'Disponible'),
(16, 'Pimentón Rojo', 'Vegetales', 8.00, 'Kg', 4.00, 'Disponible'),
(17, 'Papas Blancas', 'Vegetales', 40.00, 'Kg', 12.00, 'Disponible'),
(18, 'Detergente Multiuso', 'Artículos de Limpieza', 50.00, 'Kg', 10.00, 'Disponible'),
(19, 'Cloro Concentrado', 'Artículos de Limpieza', 15.00, 'Lts', 10.00, 'Disponible'),
(20, 'Desengrasante Industrial', 'Artículos de Limpieza', 15.00, 'Lts', 5.00, 'Disponible'),
(21, 'Papel Higiénico Institucional', 'Artículos de Limpieza', 120.00, 'PCE', 24.00, 'Disponible'),
(22, 'Servilletas de Mesa', 'Artículos de Limpieza', 20.00, 'PCE', 15.00, 'Disponible');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `salidas_insumos`
--

CREATE TABLE `salidas_insumos` (
  `id_salida` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `cantidad_salida` decimal(10,2) NOT NULL,
  `ubicacion_destino` varchar(150) NOT NULL,
  `fecha_salida` datetime NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `observaciones` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `salidas_insumos`
--

INSERT INTO `salidas_insumos` (`id_salida`, `id_producto`, `cantidad_salida`, `ubicacion_destino`, `fecha_salida`, `id_usuario`, `observaciones`) VALUES
(1, 3, 10.00, 'RIG-42', '2026-10-14 15:30:00', 1, '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `servicios_catering`
--

CREATE TABLE `servicios_catering` (
  `id_servicio` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `ubicacion_embarcacion` varchar(100) NOT NULL,
  `desayunos_cliente` int(11) DEFAULT 0,
  `almuerzos_cliente` int(11) DEFAULT 0,
  `cenas_cliente` int(11) DEFAULT 0,
  `cena_medianoche_cliente` int(11) DEFAULT 0,
  `alojamiento_cliente` int(11) DEFAULT 0,
  `desayunos_servicio` int(11) DEFAULT 0,
  `almuerzos_servicio` int(11) DEFAULT 0,
  `cenas_servicio` int(11) DEFAULT 0,
  `cena_medianoche_servicio` int(11) DEFAULT 0,
  `alojamiento_servicio` int(11) DEFAULT 0,
  `desayunos_maritime` int(11) DEFAULT 0,
  `almuerzos_maritime` int(11) DEFAULT 0,
  `cenas_maritime` int(11) DEFAULT 0,
  `cena_medianoche_maritime` int(11) DEFAULT 0,
  `alojamiento_maritime` int(11) DEFAULT 0,
  `observaciones` text DEFAULT NULL,
  `usuario_registro` varchar(100) DEFAULT NULL,
  `estado` enum('Abierto','Cerrado') DEFAULT 'Abierto',
  `fecha_cierre` datetime DEFAULT NULL,
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  `total_comensales` int(11) DEFAULT 0,
  `menu_desayuno` text DEFAULT NULL,
  `menu_almuerzo` text DEFAULT NULL,
  `menu_cena` text DEFAULT NULL,
  `menu_medianoche` text DEFAULT NULL,
  `tarifa_alimentacion` decimal(10,2) DEFAULT 0.00,
  `tarifa_alojamiento` decimal(10,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `solicitudes_catering`
--

CREATE TABLE `solicitudes_catering` (
  `id_solicitud` int(11) NOT NULL,
  `codigo_solicitud` varchar(50) NOT NULL,
  `ubicacion_embarcacion` varchar(150) NOT NULL,
  `fecha_solicitud` datetime DEFAULT current_timestamp(),
  `fecha_entrega` date NOT NULL,
  `estado_solicitud` enum('Pendiente','En Proceso','Despachado','Cancelado') DEFAULT 'Pendiente',
  `observaciones` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `rol` enum('Coord.(a) catering','Superv.(a) catering','Esp. Almacen') DEFAULT 'Coord.(a) catering',
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `nombre`, `email`, `password`, `rol`, `creado_en`) VALUES
(1, 'Ariadna Colmenares', 'pasante@maritime.com', '123456', 'Coord.(a) catering', '2026-10-06 22:09:04'),
(2, 'Angeles Villalobos', 'Angeles@maritime.com', '456123', 'Esp. Almacen', '2026-10-08 18:14:42');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `certificados_salud`
--
ALTER TABLE `certificados_salud`
  ADD PRIMARY KEY (`id_certificado`),
  ADD UNIQUE KEY `cedula` (`cedula`);

--
-- Indices de la tabla `inventario`
--
ALTER TABLE `inventario`
  ADD PRIMARY KEY (`id_producto`);

--
-- Indices de la tabla `salidas_insumos`
--
ALTER TABLE `salidas_insumos`
  ADD PRIMARY KEY (`id_salida`),
  ADD KEY `id_producto` (`id_producto`);

--
-- Indices de la tabla `servicios_catering`
--
ALTER TABLE `servicios_catering`
  ADD PRIMARY KEY (`id_servicio`);

--
-- Indices de la tabla `solicitudes_catering`
--
ALTER TABLE `solicitudes_catering`
  ADD PRIMARY KEY (`id_solicitud`),
  ADD UNIQUE KEY `codigo_solicitud` (`codigo_solicitud`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `certificados_salud`
--
ALTER TABLE `certificados_salud`
  MODIFY `id_certificado` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `inventario`
--
ALTER TABLE `inventario`
  MODIFY `id_producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de la tabla `salidas_insumos`
--
ALTER TABLE `salidas_insumos`
  MODIFY `id_salida` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `servicios_catering`
--
ALTER TABLE `servicios_catering`
  MODIFY `id_servicio` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `solicitudes_catering`
--
ALTER TABLE `solicitudes_catering`
  MODIFY `id_solicitud` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `salidas_insumos`
--
ALTER TABLE `salidas_insumos`
  ADD CONSTRAINT `salidas_insumos_ibfk_1` FOREIGN KEY (`id_producto`) REFERENCES `inventario` (`id_producto`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
