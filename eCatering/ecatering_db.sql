-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 20-10-2026 a las 21:45:47
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
-- Estructura de tabla para la tabla `entradas_insumos`
--

CREATE TABLE `entradas_insumos` (
  `id_entrada` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `cantidad` decimal(10,2) NOT NULL,
  `proveedor` varchar(150) DEFAULT NULL,
  `num_factura_orden` varchar(50) DEFAULT NULL,
  `fecha_vencimiento` date DEFAULT NULL,
  `fecha_entrada` datetime DEFAULT current_timestamp(),
  `id_usuario` int(11) NOT NULL,
  `observaciones` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `entradas_insumos`
--

INSERT INTO `entradas_insumos` (`id_entrada`, `id_producto`, `cantidad`, `proveedor`, `num_factura_orden`, `fecha_vencimiento`, `fecha_entrada`, `id_usuario`, `observaciones`) VALUES
(1, 3, 10.00, 'MVT', '22555', '2026-10-31', '2026-10-19 10:40:39', 1, 'Perfectas condiciones'),
(2, 3, 5.00, 'MVT', '22555', '2026-10-31', '2026-10-19 10:41:30', 1, 'perfecto'),
(3, 3, 11.00, 'FASTO', '123', '2026-11-05', '2026-10-20 09:59:17', 1, ''),
(4, 1, 18.00, 'FASTO', '1234', '2026-10-30', '2026-10-20 10:01:08', 1, '');

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
  `unidad_empaque` varchar(50) DEFAULT 'Caja/Saco',
  `contenido_por_empaque` decimal(10,2) DEFAULT 1.00,
  `stock_minimo` decimal(10,2) DEFAULT 5.00,
  `stock_maximo` decimal(10,2) DEFAULT 0.00,
  `estado` enum('Disponible','Por Agotarse','Agotado') DEFAULT 'Disponible'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `inventario`
--

INSERT INTO `inventario` (`id_producto`, `nombre_insumo`, `categoria`, `cantidad`, `unidad_medida`, `unidad_empaque`, `contenido_por_empaque`, `stock_minimo`, `stock_maximo`, `estado`) VALUES
(1, 'Arroz Blanco Superior', 'Víveres', 168.00, 'Kg', 'Paca', 24.00, 30.00, 0.00, 'Disponible'),
(2, 'Harina de Maíz Precocida', 'Víveres', 200.00, 'Kg', 'Caja/Saco', 1.00, 50.00, 0.00, 'Disponible'),
(3, 'Aceite Vegetal 1L', 'Víveres', 31.00, 'Lts', 'Paca', 12.00, 15.00, 0.00, 'Disponible'),
(4, 'Azúcar Refinada', 'Víveres', 38.00, 'Kg', 'Caja/Saco', 1.00, 20.00, 0.00, 'Disponible'),
(5, 'Pasta Plumas', 'Víveres', 80.00, 'Kg', 'Caja/Saco', 1.00, 20.00, 0.00, 'Disponible'),
(6, 'Caraotas Negras', 'Víveres', 45.00, 'Kg', 'Caja/Saco', 1.00, 10.00, 0.00, 'Disponible'),
(7, 'Pechuga de Pollo Deshuesada', 'Proteínas', 65.00, 'Kg', 'Caja/Saco', 1.00, 15.00, 0.00, 'Disponible'),
(8, 'Carne de Res para Mechar', 'Proteínas', 30.00, 'Kg', 'Caja/Saco', 1.00, 25.00, 0.00, 'Disponible'),
(9, 'Chuleta de Cerdo Ahumada', 'Proteínas', 25.00, 'Kg', 'Caja/Saco', 1.00, 10.00, 0.00, 'Disponible'),
(10, 'Filet de Merluza', 'Proteínas', 20.00, 'Kg', 'Caja/Saco', 1.00, 8.00, 0.00, 'Disponible'),
(11, 'Queso Blanco Duro', 'Lácteos', 22.00, 'Kg', 'Caja/Saco', 1.00, 5.00, 0.00, 'Disponible'),
(12, 'Mantequilla con Sal 500g', 'Lácteos', 18.00, 'PCE', 'Caja/Saco', 1.00, 5.00, 0.00, 'Disponible'),
(13, 'Leche Completa en Polvo', 'Lácteos', 15.00, 'Kg', 'Caja/Saco', 1.00, 10.00, 0.00, 'Disponible'),
(14, 'Tomate Perita', 'Vegetales', 25.00, 'Kg', 'Caja/Saco', 1.00, 8.00, 0.00, 'Disponible'),
(15, 'Cebolla Blanca', 'Vegetales', 18.00, 'Kg', 'Caja/Saco', 1.00, 5.00, 0.00, 'Disponible'),
(16, 'Pimentón Rojo', 'Vegetales', 8.00, 'Kg', 'Caja/Saco', 1.00, 4.00, 0.00, 'Disponible'),
(17, 'Papas Blancas', 'Vegetales', 40.00, 'Kg', 'Caja/Saco', 1.00, 12.00, 0.00, 'Disponible'),
(18, 'Detergente Multiuso', 'Artículos de Limpieza', 40.00, 'Kg', 'Caja/Saco', 1.00, 10.00, 0.00, 'Disponible'),
(19, 'Cloro Concentrado', 'Artículos de Limpieza', 15.00, 'Lts', 'Caja/Saco', 1.00, 10.00, 0.00, 'Disponible'),
(20, 'Desengrasante Industrial', 'Artículos de Limpieza', 15.00, 'Lts', 'Caja/Saco', 1.00, 5.00, 0.00, 'Disponible'),
(21, 'Papel Higiénico Institucional', 'Artículos de Limpieza', 120.00, 'PCE', 'Caja/Saco', 1.00, 24.00, 0.00, 'Disponible'),
(22, 'Servilletas de Mesa', 'Artículos de Limpieza', 20.00, 'PCE', 'Caja/Saco', 1.00, 15.00, 0.00, 'Disponible'),
(23, 'Harina de trigo todo uso', 'Víveres', 24.00, 'Kg', 'Caja/Saco', 1.00, 12.00, 0.00, 'Disponible');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `logs_sistema`
--

CREATE TABLE `logs_sistema` (
  `id_log` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `accion` varchar(100) NOT NULL,
  `descripcion` text NOT NULL,
  `fecha_hora` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `logs_sistema`
--

INSERT INTO `logs_sistema` (`id_log`, `id_usuario`, `accion`, `descripcion`, `fecha_hora`) VALUES
(1, 1, 'CREACION_INSUMO', 'Creó el insumo \'Harina de trigo todo uso\' (#23) con stock inicial de 24 Kg.', '2026-10-20 09:39:53'),
(2, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'Aceite Vegetal 1L\' (#3).', '2026-10-20 09:56:29'),
(3, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'Arroz Blanco Superior\' (#1).', '2026-10-20 09:57:27'),
(4, 1, 'REABASTECIMIENTO_INSUMO', 'Ingresó 11 Lts de \'Aceite Vegetal 1L\' desde FASTO.', '2026-10-20 09:59:17'),
(5, 1, 'REABASTECIMIENTO_INSUMO', 'Ingresó 18 Kg de \'Arroz Blanco Superior\' desde FASTO.', '2026-10-20 10:01:08'),
(6, 1, 'DESPACHO_INSUMO', 'Despachó 5 Lts de \'Aceite Vegetal 1L\' hacia RIG-42.', '2026-10-20 10:01:41'),
(7, 1, 'Cambio Estado Pedido', 'Pedido ID #3 actualizado a estado:En Proceso', '2026-10-20 11:25:14'),
(8, 1, 'DESPACHO_INSUMO', 'Despachó 10 Kg de \'Detergente Multiuso\' hacia RIG-42.', '2026-10-20 11:56:21'),
(9, 1, 'DESPACHO_INSUMO', 'Despachó 5 Kg de \'Chuleta de Cerdo Ahumada\' hacia RIG-42.', '2026-10-20 11:57:12'),
(10, 1, 'Cambio Estado Pedido', 'Pedido ID #3 actualizado a estado:Pendiente', '2026-10-20 12:54:13');

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
(1, 3, 10.00, 'RIG-42', '2026-10-14 15:30:00', 1, ''),
(2, 3, 5.00, 'RIG-42', '2026-10-19 11:36:11', 1, 'perfecto'),
(3, 3, 5.00, 'RIG-42', '2026-10-20 10:01:41', 1, ''),
(4, 18, 10.00, 'RIG-42', '2026-10-20 11:56:21', 1, ''),
(5, 9, 5.00, 'RIG-42', '2026-10-20 11:57:12', 1, '');

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

--
-- Volcado de datos para la tabla `solicitudes_catering`
--

INSERT INTO `solicitudes_catering` (`id_solicitud`, `codigo_solicitud`, `ubicacion_embarcacion`, `fecha_solicitud`, `fecha_entrega`, `estado_solicitud`, `observaciones`) VALUES
(1, 'PED-20261019-604', 'M-123', '2026-10-19 14:40:35', '2026-10-30', 'Despachado', 'Víveres Secos y Granos | Aceite Vegetal | Cuñete | 18Ltr | 5 | 91.5\r\nVíveres Secos y Granos | Arroz Mary | Unid | 900Grs | 10 | 1.75\r\nProteínas y Carnes | Pollo entero | Kg Directo | 1Kg | 100 | 4.95'),
(2, 'PED-20261019-250', 'M-123', '2026-10-19 15:00:24', '2026-10-30', 'Despachado', 'PROVEEDOR: FASTO\r\nVíveres Secos y Granos | Aceite Vegetal | Cuñete | 18Ltr | 10 | 91.5\r\nVíveres Secos y Granos | Arroz Mary | Kg Directo | 0.9Kg | 15 | 1.75\r\nVíveres Secos y Granos | Atún en agua | Unid | 0.17Kg | 20 | 4.5\r\nProteínas y Carnes | Carne para mechar | Kg Directo | 1Kg | 50 | 13.3'),
(3, 'PED-20261020-271', 'M-123', '2026-10-20 11:17:31', '2026-10-23', 'Pendiente', 'PROVEEDOR: FASTO\r\nProteínas y Carnes | Carne para mechar | Kg Directo | 1Kg | 50 | 5');

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
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  `estado` varchar(20) DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `nombre`, `email`, `password`, `rol`, `creado_en`, `estado`) VALUES
(1, 'Ariadna Colmenares', 'pasante@maritime.com', '$2y$10$jAXaNAzU/6GGrt.XK5a7UO3UwWfHCrC6MeYIACNz2W1vn/4m3nguy', 'Coord.(a) catering', '2026-10-06 22:09:04', 'Activo'),
(4, 'Cristian Espinoza', 'cristian.espinoza@maritime.com', '$2y$10$1xgXqeoNY.Xh1JjUm2bJCO2o1we9Dq0cQMdrBvcKdPWJvr/GF53Aa', 'Esp. Almacen', '2026-10-20 19:14:03', 'Activo'),
(5, 'Mariangela Chacin', 'mariangela.chacin@maritime.com', '$2y$10$WH3AZJIMpU2mnOh4Q/YSluXDKyxfypc2gMZ.ma97ozNxvQs4z/LOi', 'Coord.(a) catering', '2026-10-20 19:15:59', 'Activo');

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
-- Indices de la tabla `entradas_insumos`
--
ALTER TABLE `entradas_insumos`
  ADD PRIMARY KEY (`id_entrada`),
  ADD KEY `id_producto` (`id_producto`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `inventario`
--
ALTER TABLE `inventario`
  ADD PRIMARY KEY (`id_producto`);

--
-- Indices de la tabla `logs_sistema`
--
ALTER TABLE `logs_sistema`
  ADD PRIMARY KEY (`id_log`),
  ADD KEY `id_usuario` (`id_usuario`);

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
-- AUTO_INCREMENT de la tabla `entradas_insumos`
--
ALTER TABLE `entradas_insumos`
  MODIFY `id_entrada` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `inventario`
--
ALTER TABLE `inventario`
  MODIFY `id_producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT de la tabla `logs_sistema`
--
ALTER TABLE `logs_sistema`
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `salidas_insumos`
--
ALTER TABLE `salidas_insumos`
  MODIFY `id_salida` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `servicios_catering`
--
ALTER TABLE `servicios_catering`
  MODIFY `id_servicio` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `solicitudes_catering`
--
ALTER TABLE `solicitudes_catering`
  MODIFY `id_solicitud` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `entradas_insumos`
--
ALTER TABLE `entradas_insumos`
  ADD CONSTRAINT `entradas_insumos_ibfk_1` FOREIGN KEY (`id_producto`) REFERENCES `inventario` (`id_producto`) ON DELETE CASCADE,
  ADD CONSTRAINT `entradas_insumos_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `logs_sistema`
--
ALTER TABLE `logs_sistema`
  ADD CONSTRAINT `logs_sistema_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE;

--
-- Filtros para la tabla `salidas_insumos`
--
ALTER TABLE `salidas_insumos`
  ADD CONSTRAINT `salidas_insumos_ibfk_1` FOREIGN KEY (`id_producto`) REFERENCES `inventario` (`id_producto`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
