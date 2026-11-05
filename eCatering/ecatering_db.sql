-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 05-11-2026 a las 21:30:00
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
-- Estructura de tabla para la tabla `cargas_masivas_log`
--

CREATE TABLE `cargas_masivas_log` (
  `id_carga` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `nombre_archivo` varchar(255) NOT NULL,
  `total_registros` int(11) NOT NULL,
  `registros_exitosos` int(11) NOT NULL,
  `registros_con_error` int(11) NOT NULL,
  `estado_lote` varchar(50) DEFAULT 'Pendiente',
  `fecha_carga` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `cargas_masivas_log`
--

INSERT INTO `cargas_masivas_log` (`id_carga`, `id_usuario`, `nombre_archivo`, `total_registros`, `registros_exitosos`, `registros_con_error`, `estado_lote`, `fecha_carga`) VALUES
(1, 1, 'plantilla_carga_masiva_erequest.csv', 6, 5, 1, 'Procesado', '2026-10-22 11:58:33'),
(2, 1, 'plantilla_carga.csv', 144, 144, 0, 'Procesado', '2026-10-23 11:59:22'),
(3, 1, 'plantilla_carga_Nocomestibles - copia.csv', 33, 33, 0, 'Procesado', '2026-10-23 13:44:54'),
(4, 1, 'plantilla_carga_Nocomestibles - copia.csv', 33, 33, 0, 'Procesado', '2026-10-23 13:49:26'),
(5, 1, 'plantilla_carga_Nocomestibles - copia.csv', 33, 33, 0, 'Procesado', '2026-10-23 13:53:19'),
(6, 1, 'plantilla_carga_comestibles.csv', 144, 144, 0, 'Procesado', '2026-10-23 14:06:36'),
(7, 1, 'plantilla_carga_Nocomestibles - copia.csv', 33, 33, 0, 'Procesado', '2026-10-23 14:07:37'),
(8, 1, 'plantilla_carga_Nocomestibles - copia.csv', 33, 33, 0, 'Procesado', '2026-10-23 14:11:54'),
(9, 1, 'plantilla_carga_comestibles.csv', 144, 144, 0, 'Procesado', '2026-10-23 14:15:29'),
(10, 1, 'plantilla_carga_comestibles.csv', 144, 144, 0, 'Procesado', '2026-10-23 15:04:45'),
(11, 1, 'plantilla_carga_Nocomestibles - copia.csv', 33, 33, 0, 'Procesado', '2026-10-23 15:11:24');

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
  `estado_vigencia` enum('Vigente','Por Vencer','Vencido') DEFAULT 'Vigente',
  `id_usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `certificados_salud`
--

INSERT INTO `certificados_salud` (`id_certificado`, `cedula`, `nombre_personal`, `cargo`, `cuadrilla`, `fecha_emision`, `fecha_vencimiento`, `estado_vigencia`, `id_usuario`) VALUES
(1, '29.984.325', 'Ariadna Colmenares', 'Ayudante', 'A', '2026-10-07', '2027-01-12', 'Vigente', 1),
(2, '123456', 'José Perez', 'Cocinero', 'B', '2026-01-01', '2027-10-15', 'Vigente', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `control_mermas`
--

CREATE TABLE `control_mermas` (
  `id_merma` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL,
  `cantidad_unid` decimal(10,2) DEFAULT 0.00,
  `peso_gramos` decimal(10,2) DEFAULT 0.00,
  `observaciones` text NOT NULL,
  `fecha_registro` datetime DEFAULT current_timestamp(),
  `id_usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `inventario`
--

CREATE TABLE `inventario` (
  `id_producto` int(11) NOT NULL,
  `codigo_sku` varchar(30) DEFAULT NULL,
  `nombre_insumo` varchar(150) NOT NULL,
  `tipo_rubro` varchar(50) NOT NULL DEFAULT 'Consumible',
  `categoria` varchar(50) DEFAULT NULL,
  `cantidad` decimal(10,2) NOT NULL DEFAULT 0.00,
  `unidad_medida` varchar(20) NOT NULL,
  `unidad_empaque` varchar(50) DEFAULT 'Caja/Saco',
  `contenido_por_empaque` decimal(10,2) DEFAULT 1.00,
  `stock_minimo` decimal(10,2) DEFAULT 5.00,
  `stock_maximo` decimal(10,2) DEFAULT 0.00,
  `estado` varchar(50) NOT NULL DEFAULT 'Disponible',
  `id_usuario` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `inventario`
--

INSERT INTO `inventario` (`id_producto`, `codigo_sku`, `nombre_insumo`, `tipo_rubro`, `categoria`, `cantidad`, `unidad_medida`, `unidad_empaque`, `contenido_por_empaque`, `stock_minimo`, `stock_maximo`, `estado`, `id_usuario`) VALUES
(322, '147296', 'ACEITE VEGETAL ', 'Consumible', 'Víveres', 0.00, 'Ltr', 'Cuñete', 18.00, 20.00, 40.00, 'Agotado', 1),
(323, '144106', 'ACEITE VEGETAL LITRO', 'Consumible', 'Víveres', 17.00, 'Ltr', 'Caja', 12.00, 15.00, 400.00, 'Disponible', 1),
(324, '150169', 'ACEITUNAS VERDES PRESENTACION 180 GRM', 'Consumible', 'Víveres', 0.00, 'PCE', 'Caja', 12.00, 30.00, 400.00, 'Agotado', 1),
(325, '150870', 'AGUA MINERAL DE 600 ML C/U', 'Consumible', 'Víveres', 12.00, 'Unid', 'Caja', 24.00, 10.00, 400.00, 'Disponible', 1),
(326, '149008', 'TODDY (BEBIDA ACHOCOLATADA), PRESENTACIÓN: PAQ. DE 400 GRM', 'Consumible', 'Víveres', 0.00, 'PCE', 'Paquete', 1.00, 5.00, 400.00, 'Agotado', 1),
(327, '143949', 'ALIÑO ROJO EN POLVO', 'Consumible', 'Víveres', 2.20, 'Kg', 'Bolsa', 1.00, 5.00, 400.00, 'Por Agotarse', 1),
(328, '144460', 'ARROZ BLANCO TIPO I', 'Consumible', 'Víveres', 102.00, 'Kg', 'Saco', 24.00, 1.00, 400.00, 'Disponible', 1),
(329, '144127', 'ATUN EN LATA , 170GR', 'Consumible', 'Víveres', 2.89, 'Kg', 'Lata', 0.17, 1.00, 400.00, 'Disponible', 1),
(330, '148637', 'AVENA EN HOJUELAS, PRESENTACIÓN: PAQ. DE 800 GR', 'Consumible', 'Víveres', 5.60, 'Unid', 'Paquete', 0.80, 1.00, 400.00, 'Disponible', 1),
(331, '143996', 'ARVEJAS VERDES SECAS', 'Consumible', 'Víveres', 1.60, 'Kg', 'Paquete', 0.40, 0.40, 400.00, 'Disponible', 1),
(332, '149207', 'BICARBONATO DE SODIO, PRESENTACIÓN: PAQUETE DE 30 GR', 'Consumible', 'Víveres', 0.25, 'Kg', 'Bolsa', 1.00, 1.00, 400.00, 'Por Agotarse', 1),
(333, '147786', 'AZUCAR BLANCA GRANULADA', 'Consumible', 'Víveres', 63.00, 'Kg', 'Caja', 24.00, 1.00, 400.00, 'Disponible', 1),
(334, '144471', 'CAFE MOLIDO, PRESENTACIÓN: PAQ. DE 500 GR', 'Consumible', 'Víveres', 23.00, 'Kg', 'Paquete', 0.50, 1.00, 400.00, 'Disponible', 1),
(335, '143951', 'CANELA EN RAMA', 'Consumible', 'Víveres', 0.20, 'Kg', 'Unidad', 0.50, 1.00, 400.00, 'Por Agotarse', 1),
(336, '143950', 'CANELA EN POLVO', 'Consumible', 'Víveres', 0.30, 'Kg', 'Unidad', 1.00, 1.00, 400.00, 'Por Agotarse', 1),
(337, '143997', 'CARAOTAS NEGRAS SECAS', 'Consumible', 'Víveres', 4.00, 'Kg', 'Bolsa', 1.00, 1.00, 400.00, 'Disponible', 1),
(338, '144481', 'CARAOTAS ROJAS SECAS', 'Consumible', 'Víveres', 6.00, 'Kg', 'Bolsa', 1.00, 1.00, 400.00, 'Disponible', 1),
(339, '148026', 'CARMENCITA (COLORANTE ALIMENTARIO)', 'Consumible', 'Víveres', 0.40, 'Kg', 'Bolsa', 1.00, 1.00, 400.00, 'Por Agotarse', 1),
(340, '154775', 'CLAVOS DE OLOR', 'Consumible', 'Víveres', 0.60, 'PCE', 'Unidad', 1.00, 1.00, 400.00, 'Por Agotarse', 1),
(341, '148839', 'COMINO EN POLVO, PRESENTACIÓN: ENVASE DE 20 A 30  GR', 'Consumible', 'Víveres', 1.00, 'PCE', 'Bolsa', 1.00, 1.00, 400.00, 'Por Agotarse', 1),
(342, '144135', 'CURRY EN POLVO', 'Consumible', 'Víveres', 1.00, 'Kg', 'Bolsa', 1.00, 1.00, 400.00, 'Por Agotarse', 1),
(343, '143999', 'FRIJOL PICO NEGRO SECO', 'Consumible', 'Víveres', 3.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible', 1),
(344, '149537', 'GELATINA GRANULADA, SABORES SURTIDOS, PRESENTACIÓN: PAQ. DE 65 GRM', 'Consumible', 'Víveres', 0.00, 'PCE', 'Paquete', 1.00, 1.00, 400.00, 'Agotado', 1),
(345, '154853', 'CEREZAS EN ALMIBAR FRASCO 125GR A 400GR', 'Consumible', 'Víveres', 1.00, 'PCE', 'Lata', 1.00, 1.00, 400.00, 'Por Agotarse', 1),
(346, '146408', 'GALLETA CLUB SOCIAL, PRESENTACIÓN: PAQ. DE 234 GR (9 MINI-PAQ. X 3 UND)', 'Consumible', 'Víveres', 0.00, 'PCE', 'Paquete', 1.00, 1.00, 400.00, 'Agotado', 1),
(347, '146409', 'GUISANTES VERDES AL NATURAL, PRESENTACIÓN: LATA DE 425 GR', 'Consumible', 'Víveres', 5.00, 'PCE', 'Paquete', 1.00, 1.00, 400.00, 'Disponible', 1),
(348, '144690', 'HARINA DE MAIZ PRECOCIDA', 'Consumible', 'Víveres', 59.00, 'Kg', 'Saco', 20.00, 1.00, 400.00, 'Disponible', 1),
(349, '144461', 'HARINA DE TRIGO LEUDANTE / TODO USO', 'Consumible', 'Víveres', 38.00, 'Kg', 'Saco', 20.00, 1.00, 400.00, 'Disponible', 1),
(350, '147864', 'LAUREL SECO EN HOJAS', 'Consumible', 'Víveres', 1.50, 'Kg', 'Bolsa', 1.00, 1.00, 400.00, 'Disponible', 1),
(351, '143968', 'LECHE CONDENSADA AZUCARADA, PRESENTACIÓN: LATA DE 397 GR', 'Consumible', 'Víveres', 0.39, 'PCE', 'Lata', 0.39, 1.00, 400.00, 'Por Agotarse', 1),
(352, '144000', 'LENTEJAS ', 'Consumible', 'Víveres', 0.80, 'Kg', 'Paquete', 0.40, 1.00, 400.00, 'Por Agotarse', 1),
(353, '148874', 'LECHE EN POLVO, PRESENTACIÓN: 1 KG', 'Consumible', 'Víveres', 17.00, 'Kg', 'Paquete', 0.90, 1.00, 400.00, 'Disponible', 1),
(354, '143974', 'LEVADURA GRANULADA PAQUETE DE 1/2 KG GRANULADA', 'Consumible', 'Víveres', 0.10, 'Kg', 'Bolsa', 1.00, 1.00, 400.00, 'Por Agotarse', 1),
(355, '144691', 'MAICENA / MAIZINA / ALMIDON DE MAIZ, PRESENTACIÓN', 'Consumible', 'Víveres', 4.00, 'Kg', 'Paquete', 0.80, 1.00, 400.00, 'Disponible', 1),
(357, '154776', 'MANTECA VEGETAL 500GR', 'Consumible', 'Víveres', 0.00, 'PCE', 'Paquete', 0.50, 1.00, 400.00, 'Agotado', 1),
(358, '150349', 'MARGARINA / MANTEQUILLA, PRESENTACIÓN: ENVASE DE 500 GRM', 'Consumible', 'Víveres', 7.00, 'Kg', 'Caja', 5.00, 1.00, 400.00, 'Disponible', 1),
(359, '144069', 'MAYONESA PREPARADA', 'Consumible', 'Víveres', 4.00, 'Lts', 'Galón', 3.60, 1.00, 400.00, 'Disponible', 1),
(361, '146411', 'MOSTAZA PREPARADA, ENVASE DE 260 A 500 GR', 'Consumible', 'Víveres', 0.00, 'Kg', 'Unidad', 0.50, 1.00, 400.00, 'Agotado', 1),
(362, '149050', 'OREGANO SECO EN HOJAS', 'Consumible', 'Víveres', 0.70, 'Kg', 'Bolsa', 0.10, 1.00, 400.00, 'Por Agotarse', 1),
(364, '154774', 'PASTA DE TOMATE ', 'Consumible', 'Víveres', 0.50, 'PCE', 'Unidad', 0.50, 1.00, 400.00, 'Por Agotarse', 1),
(365, '144467', 'PASTA CORTA', 'Consumible', 'Víveres', 38.00, 'Kg', 'Saco', 12.00, 1.00, 400.00, 'Disponible', 1),
(366, '144152', 'PASTA LARGA', 'Consumible', 'Víveres', 31.00, 'Kg', 'Saco', 12.00, 1.00, 400.00, 'Disponible', 1),
(367, '148645', 'PASTA PARA PASTICHO, PRESENTACIÓN: BT. DE 12 CAJAS DE 250 GR C/U', 'Consumible', 'Víveres', 17.00, 'BX', 'Caja', 1.00, 1.00, 400.00, 'Disponible', 1),
(368, '143972', 'POLVO DE HORNEAR, PRESENTACIÓN: ENVASE DE 200 GR', 'Consumible', 'Víveres', 2.50, 'Kg', 'Bolsa', 1.00, 1.00, 400.00, 'Disponible', 1),
(369, '154932', 'PUDIN', 'Consumible', 'Víveres', 1.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Por Agotarse', 1),
(370, '148643', 'UVAS PASAS', 'Consumible', 'Víveres', 0.00, 'Kg', 'Lata', 1.00, 1.00, 400.00, 'Agotado', 1),
(371, '149641', 'PAPAS FRITAS PRECOCIDAS, PRESENTACIÓN: PAQ. DE 140 GR A 300GR', 'Consumible', 'Víveres', 0.00, 'PCE', 'Bolsa', 1.00, 1.00, 400.00, 'Agotado', 1),
(372, '147506', 'REFRESCO 2LTR', 'Consumible', 'Víveres', 24.00, 'Unid', 'Paca', 6.00, 1.00, 400.00, 'Disponible', 1),
(373, '144942', 'REFRESCO DE LATA 355ML (PAQ. 24 UNIDADES)', 'Consumible', 'Víveres', 12.00, 'PK', 'Paca', 24.00, 1.00, 400.00, 'Disponible', 1),
(374, '144472', 'SAL REFINADA', 'Consumible', 'Víveres', 29.00, 'Kg', 'Paquete', 1.00, 1.00, 400.00, 'Disponible', 1),
(375, '146412', 'SALSA 57 O 79, PRESENTACIÓN: FRASCO DE 375 ML', 'Consumible', 'Víveres', 0.37, 'PCE', 'Unidad', 0.37, 1.00, 400.00, 'Por Agotarse', 1),
(376, '147889', 'SALSA DE AJO', 'Consumible', 'Víveres', 3.70, 'Lts', 'Galón', 3.70, 1.00, 400.00, 'Disponible', 1),
(377, '147292', 'SALSA DE SOYA', 'Consumible', 'Víveres', 19.00, 'Lts', 'Galón', 3.80, 1.00, 400.00, 'Disponible', 1),
(378, '144469', 'SALSA DE TOMATE, PRESENTACIÓN: ENVASE DE 4.2 KG', 'Consumible', 'Víveres', 12.60, 'Lts', 'Galón', 4.20, 1.00, 400.00, 'Disponible', 1),
(379, '147293', 'SALSA  INGLESA', 'Consumible', 'Víveres', 11.40, 'Lts', 'Galón', 3.80, 1.00, 400.00, 'Disponible', 1),
(380, '148849', 'SARDINAS EN ACEITE / AL NATURAL, PRESENTACIÓN: LATA DE 170 GR', 'Consumible', 'Víveres', 6.63, 'PCE', 'Lata', 0.17, 1.00, 400.00, 'Disponible', 1),
(381, '149070', 'SAZONATODO (PRESENTACION: FRASCO DE 200 GR a 300GR)', 'Consumible', 'Víveres', 0.00, 'PCE', 'Unidad', 0.20, 1.00, 400.00, 'Agotado', 1),
(382, '146415', 'VAINILLA (LIQUIDA)', 'Consumible', 'Víveres', 3.00, 'Lts', 'Unidad', 1.00, 1.00, 400.00, 'Disponible', 1),
(383, '154779', 'VINAGRE BLANCO 1LT', 'Consumible', 'Víveres', 22.00, 'Lts', 'Unidad', 1.00, 1.00, 400.00, 'Disponible', 1),
(384, '154778', 'TE DE MANZANILLA SOBRE', 'Consumible', 'Víveres', 0.00, 'Unid.', 'Bolsa', 20.00, 1.00, 400.00, 'Agotado', 1),
(385, '154777', 'TÉ VERDE SOBRE', 'Consumible', 'Víveres', 20.00, 'Unid.', 'Paquete', 20.00, 1.00, 400.00, 'Disponible', 1),
(386, '154882', 'TE FRUTOS ROJOS', 'Consumible', 'Víveres', 0.00, 'Unid.', 'Bolsa', 1.00, 0.00, 400.00, 'Agotado', 1),
(387, '147871', 'TOMILLO SECO EN HOJAS', 'Consumible', 'Víveres', 0.50, 'Kg', 'Bolsa', 1.00, 1.00, 400.00, 'Por Agotarse', 1),
(388, '144004', 'PAN DE SANDWICH BLANCO GRANDE', 'Consumible', 'Panes', 280.00, 'Unid.', 'Bolsa', 8.00, 1.00, 400.00, 'Disponible', 1),
(389, '144006', 'PAN DE PERRO CALIENTE', 'Consumible', 'Panes', 120.00, 'Unid.', 'Bolsa', 8.00, 1.00, 400.00, 'Disponible', 1),
(390, '144005', 'PAN DE HAMBURGUESA', 'Consumible', 'Panes', 168.00, 'Unid.', 'Bolsa', 8.00, 1.00, 400.00, 'Disponible', 1),
(391, '154783', 'PAN RALLADO', 'Consumible', 'Panes', 0.50, 'PCE', 'Bolsa', 0.50, 1.00, 400.00, 'Por Agotarse', 1),
(392, '143980', 'CAMBUR', 'Consumible', 'Frutas', 0.00, 'Kg', 'Cesta', 100.00, 1.00, 400.00, 'Agotado', 1),
(393, '143995', 'COCO NATURAL ENTERO X KGRS', 'Consumible', 'Frutas', 4.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(394, '144309', 'FRESA   (NATURAL)  X KGRS', 'Consumible', 'Frutas', 10.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(395, '143982', 'GUAYABA', 'Consumible', 'Frutas', 20.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(396, '143983', 'LECHOZA', 'Consumible', 'Frutas', 3.80, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(397, '143984', 'LIMON', 'Consumible', 'Frutas', 4.60, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(398, '143985', 'MANDARINA', 'Consumible', 'Frutas', 0.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Agotado', 1),
(399, '143993', 'MANZANA', 'Consumible', 'Frutas', 5.80, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(400, '143986', 'MELON', 'Consumible', 'Frutas', 18.27, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(401, '151281', 'MORA NATURAL, 1 KGR', 'Consumible', 'Frutas', 12.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(402, '150536', 'NARANJA', 'Consumible', 'Frutas', 30.60, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(403, '143987', 'PARCHITA', 'Consumible', 'Frutas', 7.40, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(404, '143988', 'PATILLA', 'Consumible', 'Frutas', 65.70, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(405, '143991', 'PIÑA', 'Consumible', 'Frutas', 39.25, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(406, '144071', 'AGUACATE', 'Consumible', 'Vegetales', 0.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Agotado', 1),
(407, '144072', 'AJI DULCE', 'Consumible', 'Vegetales', 2.09, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(408, '144074', 'AJO PORRO', 'Consumible', 'Vegetales', 2.14, 'Kg', 'Caja', 1.00, 1.00, 400.00, 'Disponible', 1),
(409, '144075', 'AJO SECO (CABEZA)', 'Consumible', 'Vegetales', 5.50, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(410, '144076', 'APIO CRIOLLO', 'Consumible', 'Vegetales', 0.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Agotado', 1),
(411, '144077', 'APIO ESPAÑA O CEDANO', 'Consumible', 'Vegetales', 1.75, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(412, '144078', 'AUYAMA', 'Consumible', 'Vegetales', 4.02, 'Kg', 'Caja', 1.00, 1.00, 400.00, 'Disponible', 1),
(413, '144079', 'BROCOLI LIMPIO', 'Consumible', 'Vegetales', 2.50, 'Kg', 'Caja', 1.00, 1.00, 400.00, 'Disponible', 1),
(414, '144080', 'CALABACIN', 'Consumible', 'Vegetales', 6.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(415, '144081', 'CEBOLLA BLANCA', 'Consumible', 'Vegetales', 19.80, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(416, '144082', 'CEBOLLA MORADA', 'Consumible', 'Vegetales', 2.20, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(417, '144083', 'CEBOLLIN', 'Consumible', 'Vegetales', 2.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(418, '144085', 'CILANTRO', 'Consumible', 'Vegetales', 0.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Agotado', 1),
(419, '144086', 'COLIFLOR LIMPIO', 'Consumible', 'Vegetales', 1.80, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(420, '144103', 'JOJOTO', 'Consumible', 'Vegetales', 0.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Agotado', 1),
(421, '144088', 'LECHUGA LIMPIA', 'Consumible', 'Vegetales', 7.60, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(422, '144089', 'ÑAME', 'Consumible', 'Vegetales', 2.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(423, '144090', 'OCUMO', 'Consumible', 'Vegetales', 2.48, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(424, '144091', 'PAPA', 'Consumible', 'Vegetales', 42.54, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(425, '144093', 'PEREJIL', 'Consumible', 'Vegetales', 1.95, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(426, '144092', 'PEPINO', 'Consumible', 'Vegetales', 0.94, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Por Agotarse', 1),
(427, '144094', 'PIMENTON', 'Consumible', 'Vegetales', 3.50, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(428, '150535', 'PLATANO', 'Consumible', 'Vegetales', 32.20, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(429, '144095', 'REMOLACHA', 'Consumible', 'Vegetales', 18.70, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(430, '144096', 'REPOLLO BLANCO', 'Consumible', 'Vegetales', 4.10, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(431, '144097', 'REPOLLO MORADO', 'Consumible', 'Vegetales', 14.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(432, '144098', 'TOMATE', 'Consumible', 'Vegetales', 17.39, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(433, '144101', 'YUCA', 'Consumible', 'Vegetales', 23.96, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(434, '144102', 'ZANAHORIA', 'Consumible', 'Vegetales', 47.10, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(435, '150121', 'PULPAS DE FRUTAS SURTIDAS CON AZUCAR (PAQ. DE 1 KG)', 'Consumible', 'Pulpa de frutas', 88.00, 'Kg', 'Bolsa', 48.00, 1.00, 400.00, 'Disponible', 1),
(436, '148834', 'HUEVOS DE GALLINA', 'Consumible', 'Proteínas', 20.00, 'PCE', 'Caja', 12.00, 1.00, 400.00, 'Disponible', 1),
(437, '147859', 'BOLOÑA ENTERA CARNE', 'Consumible', 'Charcutería', 0.00, 'Kg', 'Panela', 3.50, 1.00, 400.00, 'Agotado', 1),
(438, '143927', 'JAMON DE PIERNA ENTERO', 'Consumible', 'Charcutería', 19.00, 'Kg', 'Panela', 4.20, 1.00, 400.00, 'Disponible', 1),
(439, '143926', 'MORTADELA DE POLLO', 'Consumible', 'Charcutería', 1.50, 'Kg', 'Saco', 10.00, 1.00, 400.00, 'Disponible', 1),
(440, '143874', 'CHORIZO PARRILLERO', 'Consumible', 'Charcutería', 4.60, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible', 1),
(441, '143946', 'SALCHICHA TIPO WIENERS', 'Consumible', 'Charcutería', 4.80, 'Unid', 'Unidad', 100.00, 1.00, 400.00, 'Disponible', 1),
(442, '143936', 'TOCINETA AHUMADA ENTERA', 'Consumible', 'Charcutería', 0.00, 'Kg', 'Unidad', 3.00, 1.00, 400.00, 'Agotado', 1),
(443, '143940', 'CREMA DE LECHE (REFRIGERADA), PRESENTACIÓN: ENVASE DE 450 A 500 GR', 'Consumible', 'Lácteos', 1.00, 'Unid', 'Lata', 1.00, 1.00, 400.00, 'Por Agotarse', 1),
(444, '143928', 'QUESO AMARILLO ENTERO', 'Consumible', 'Lácteos', 1.50, 'Kg', 'Panela', 1.00, 1.00, 400.00, 'Disponible', 1),
(445, '143925', 'QUESO MADURADO ENTERO', 'Consumible', 'Lácteos', 10.10, 'Kg', 'Unidad', 3.00, 1.00, 400.00, 'Disponible', 1),
(446, '143929', 'QUESO MOZARELLA ENTERO', 'Consumible', 'Lácteos', 4.91, 'Kg', 'Panela', 2.50, 1.00, 400.00, 'Disponible', 1),
(447, '144171', 'QUESO PASTEURIZADO ENTERO', 'Consumible', 'Lácteos', 11.40, 'Kg', 'Panela', 1.00, 1.00, 400.00, 'Disponible', 1),
(448, '143873', 'CARNE PARA MECHAR', 'Consumible', 'Proteínas', 64.60, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible', 1),
(449, '143872', 'CARNE MOLIDA (PULPON)', 'Consumible', 'Proteínas', 102.00, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible', 1),
(450, '143879', 'CHIVO', 'Consumible', 'Proteínas', 14.60, 'Kg', 'Bolsa', 5.00, 0.00, 400.00, 'Disponible', 1),
(451, '143882', 'GANSO O ENTRECANTO DE RES', 'Consumible', 'Proteínas', 0.00, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Agotado', 1),
(452, '143896', 'PULPA NEGRA DE RES', 'Consumible', 'Proteínas', 24.80, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible', 1),
(453, '143881', 'COSTILLAS DE RES', 'Consumible', 'Proteínas', 24.60, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible', 1),
(454, '143884', 'HIGADO DE RES', 'Consumible', 'Proteínas', 4.00, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible', 1),
(455, '143877', 'CHULETA DE RES', 'Consumible', 'Proteínas', 5.00, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible', 1),
(456, '143899', 'RABO DE RES', 'Consumible', 'Proteínas', 0.00, 'Unid', 'Bolsa', 5.00, 0.00, 400.00, 'Agotado', 1),
(457, '143892', 'MUCHACHO CUADRADO/REDONDO DE RES', 'Consumible', 'Proteínas', 15.00, 'Kg', 'Unidad', 3.00, 1.00, 400.00, 'Disponible', 1),
(458, '143876', 'CHULETA DE PUERCO', 'Consumible', 'Proteínas', 5.00, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible', 1),
(459, '143875', 'CHULETA AHUMADA, PRESENTACIÓN: PAQUETE DE 5 KG', 'Consumible', 'Proteínas', 0.00, 'Kg', 'Bolsa', 5.00, 0.00, 400.00, 'Agotado', 1),
(460, '143894', 'PERNIL ENTERO', 'Consumible', 'Proteínas', 6.00, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible', 1),
(461, '144041', 'CORVINA ENTERA', 'Consumible', 'Pescado', 56.40, 'Kg', 'Bolsa', 2.00, 1.00, 400.00, 'Disponible', 1),
(462, '144051', 'MOJITO DE PESCADO', 'Consumible', 'Pescado', 49.00, 'Kg', 'Bolsa', 2.00, 1.00, 400.00, 'Disponible', 1),
(463, '144064', 'POLLO ENTERO EMPACADO', 'Consumible', 'Proteínas', 193.25, 'Kg', 'Bolsa', 2.00, 1.00, 400.00, 'Disponible', 1),
(464, '154785', 'MUSLO DE POLLO', 'Consumible', 'Proteínas', 54.00, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible', 1),
(465, '154786', 'PECHUGA DE POLLO', 'Consumible', 'Proteínas', 180.40, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible', 1),
(466, '151042', 'BOLSA DE BASURA 200KG', 'No Consumible', 'Artículos de limpieza', 150.00, 'PCE', 'Paquete', 5.00, 20.00, 400.00, 'Disponible', 1),
(467, '143860', 'BOLSA DE 60KG', 'No Consumible', 'Artículos de limpieza', 880.00, 'PCE', 'Paquete', 20.00, 15.00, 2000.00, 'Disponible', 1),
(468, '144019', 'CAPACILLOS', 'No Consumible', 'Desechables', 0.00, 'PCE', 'Paquete', 1000.00, 1.00, 1000.00, 'Agotado', 1),
(469, '154769', 'CUCHARA PLASTICA PARA POSTRE (20 PCE POR PAQUETE)', 'No Consumible', 'Artículos de limpieza', 100.00, 'Unid', 'Paquete', 100.00, 10.00, 400.00, 'Disponible', 1),
(470, '143849', 'CLORO', 'No Consumible', 'Artículos de limpieza', 5.00, 'Lts', 'Galón', 1.00, 5.00, 400.00, 'Por Agotarse', 1),
(471, '143850', 'DESENGRASANTE BIODEGRADABLE', 'No Consumible', 'Artículos de limpieza', 0.50, 'Lts', 'Galón', 1.00, 1.00, 400.00, 'Por Agotarse', 1),
(472, '150001', 'DESINFECTANTE ', 'No Consumible', 'Artículos de limpieza', 11.00, 'Ltr', 'Unidad', 1.00, 1.00, 400.00, 'Disponible', 1),
(473, '148150', 'DESTAPADOR DE POCETA', 'No Consumible', 'Artículos de limpieza', 3.00, 'Unid', 'Unidad', 1.00, 1.00, 400.00, 'Disponible', 1),
(474, '143848', 'ESPONJA DE BRILLO / JABONOSA', 'No Consumible', 'Artículos de limpieza', 12.00, 'PCE', 'Unidad', 1.00, 1.00, 400.00, 'Disponible', 1),
(475, '145357', 'ESPONJA DE ALAMBRE', 'No Consumible', 'Artículos de limpieza', 22.00, 'PCE', 'Unidad', 1.00, 1.00, 400.00, 'Disponible', 1),
(476, '145358', 'ESPONJA DOBLE USO', 'No Consumible', 'Artículos de limpieza', 18.00, 'PCE', 'Unidad', 1.00, 1.00, 400.00, 'Disponible', 1),
(477, '147270', 'GUANTE DE NITRILO TALLA L', 'No Consumible', 'Desechables', 75.00, 'PR', 'Caja', 100.00, 1.00, 400.00, 'Disponible', 1),
(478, '146590', 'GUANTE PLASTICO TALLA L', 'No Consumible', 'Desechables', 6.00, 'PR', 'Paquete', 1.00, 1.00, 400.00, 'Disponible', 1),
(479, '145978', 'GUANTES DESECHABLES DE SERVICIOS PLASTICOS (PAQUETE DE 100 PCE)', 'No Consumible', 'Desechables', 1000.00, 'Unid.', 'Caja', 100.00, 1.00, 400.00, 'Sobreabastecido', 1),
(480, '142769', 'GUANTES TERMICOS (PAR)', 'No Consumible', 'Cocina', 2.00, 'PCE', 'Paquete', 1.00, 1.00, 400.00, 'Disponible', 1),
(481, '144142', 'JABON DE BAÑO', 'No Consumible', 'Artículos de higiene', 100.00, 'PCE', 'Paquete', 1.00, 1.00, 400.00, 'Disponible', 1),
(482, '144125', 'JABON EN POLVO', 'No Consumible', 'Artículos de limpieza', 40.00, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible', 1),
(483, '144143', 'LAVAPLATO BIODEGRADABLE GALON', 'No Consumible', 'Artículos de limpieza', 8.00, 'Lts', 'Galón', 1.00, 1.00, 400.00, 'Disponible', 1),
(484, '143867', 'JABON LIQUIDO PARA MANOS', 'No Consumible', 'Artículos de higiene', 0.00, 'Lts', 'Galón', 1.00, 1.00, 400.00, 'Agotado', 1),
(485, '144145', 'LIMPIA HORNO CREMA', 'No Consumible', 'Artículos de limpieza', 2.00, 'PCE', 'Paquete', 1.00, 1.00, 400.00, 'Disponible', 1),
(486, '133443', 'MASCARILLAS QUIRÚRGICA DESECHABLE', 'No Consumible', 'Desechables', 150.00, 'Unid', 'Paquete', 50.00, 1.00, 400.00, 'Disponible', 1),
(487, '154771', 'MONDADIENTE (PAQ. DE 200 UNIDADES)', 'No Consumible', 'Desechables', 300.00, 'PK', 'Paquete', 100.00, 1.00, 400.00, 'Disponible', 1),
(488, '144463', 'PAPEL ALUMINIO', 'No Consumible', 'Cocina', 3.00, 'PCE', 'Paquete', 1.00, 1.00, 400.00, 'Disponible', 1),
(489, '144464', 'PAPEL ENVOPLAST INDUSTRIAL, 23 MICRAS X 500 MTS', 'No Consumible', 'Cocina', 2.00, 'PCE', 'Paquete', 1.00, 1.00, 400.00, 'Disponible', 1),
(490, '144012', 'PAPEL HIGIENICO', 'No Consumible', 'Artículos de higiene', 92.00, 'Unid', 'Paquete', 4.00, 1.00, 400.00, 'Disponible', 1),
(491, '144013', 'PITILLOS (PAQUETE DE 150 PCE)', 'No Consumible', 'Desechables', 4000.00, 'PK', 'Caja', 500.00, 1.00, 400.00, 'Sobreabastecido', 1),
(492, '141752', 'PORTA MOPA DE METAL', 'No Consumible', 'Artículos de limpieza', 2.00, 'PCE', 'Unidad', 1.00, 1.00, 400.00, 'Disponible', 1),
(493, '143853', 'AMBIENTADOR', 'No Consumible', 'Artículos de limpieza', 3.00, 'PCE', 'Unidad', 1.00, 1.00, 400.00, 'Disponible', 1),
(494, '144465', 'SERVILLETAS', 'No Consumible', 'Desechables', 12.00, 'PK', 'Paquete', 1.00, 1.00, 400.00, 'Disponible', 1),
(495, '144018', 'TOALLIN INDUSTRIAL', 'No Consumible', 'Artículos de limpieza', 27.00, 'Unid', 'Paquete', 1.00, 1.00, 400.00, 'Disponible', 1),
(496, '154933', 'VASOS V-4 , Z-47, V-47', 'No Consumible', 'Desechables', 1900.00, 'PK', 'Paquete', 100.00, 1.00, 400.00, 'Sobreabastecido', 1),
(497, '144011', 'VASOS  V-5', 'No Consumible', 'Desechables', 3200.00, 'Unid', 'Paquete', 100.00, 1.00, 400.00, 'Sobreabastecido', 1),
(498, '150454', 'VASOS V-10, TIPO V-107 ', 'No Consumible', 'Desechables', 2750.00, 'PK', 'Paquete', 50.00, 1.00, 400.00, 'Sobreabastecido', 1),
(499, NULL, 'BISTEC', 'Consumible', 'Proteínas', 34.60, 'Kg', 'Bolsa', 5.00, 15.00, 400.00, 'Disponible', 1),
(500, NULL, 'CARITE EN RUEDA', 'Consumible', 'Pescado', 0.00, 'Kg', 'Bolsa', 2.00, 1.00, 400.00, 'Agotado', 1),
(501, NULL, 'RONCO ENTERO', 'Consumible', 'Pescado', 0.00, 'Kg', 'Bolsa', 2.00, 1.00, 400.00, 'Agotado', 1),
(502, NULL, 'CORVINA EN RUEDA', 'Consumible', 'Pescado', 0.00, 'Kg', 'Bolsa', 2.00, 1.00, 400.00, 'Agotado', 1),
(503, NULL, 'ALBAHACA', 'Consumible', 'Víveres', 0.50, 'Kg', 'Bolsa', 1.00, 1.00, 400.00, 'Por Agotarse', 1),
(504, NULL, 'ALCAPARRAS', 'Consumible', 'Víveres', 0.00, 'Kg', 'Unidad', 1.00, 1.00, 400.00, 'Agotado', 1),
(505, NULL, 'CARBÓN', 'Consumible', 'Víveres', 10.00, 'Kg', 'Saco', 10.00, 1.00, 400.00, 'Disponible', 1),
(506, NULL, 'CHOCOLATE EN TABLA OSCURO CACAO 40%', 'Consumible', 'Víveres', 0.20, 'PCE', 'Paquete', 0.20, 1.00, 400.00, 'Por Agotarse', 1),
(507, NULL, 'PANELA', 'Consumible', 'Víveres', 0.00, 'PCE', 'Paquete', 0.45, 1.00, 400.00, 'Agotado', 1),
(508, NULL, 'PIMIENTA NEGRA MOLIDA', 'Consumible', 'Víveres', 0.50, 'Kg', 'Bolsa', 1.00, 1.00, 400.00, 'Por Agotarse', 1),
(509, NULL, 'ENVASE ANIME COMIDA', 'No Consumible', 'Cocina', 32800.00, 'Unid', 'Saco', 200.00, 1.00, 600.00, 'Sobreabastecido', 1),
(510, NULL, 'MOPAS INDUSTRIALES', 'No Consumible', 'Limpieza', 2.00, 'Unid', 'Unidad', 1.00, 1.00, 40.00, 'Disponible', 1),
(511, NULL, 'PALA PARA BASURA', 'No Consumible', 'Limpieza', 2.00, 'Unid', 'Unidad', 1.00, 1.00, 20.00, 'Disponible', 1),
(512, NULL, 'PALILLOS PARA PINCHO', 'No Consumible', 'Cocina', 400.00, 'Unid', 'Paquete', 100.00, 1.00, 600.00, 'Disponible', 1),
(513, NULL, 'PALO PORTA MOPA', 'No Consumible', 'Limpieza', 2.00, 'Unid', 'Unidad', 1.00, 1.00, 20.00, 'Disponible', 1),
(514, NULL, 'PAÑITO REPASADOR', 'No Consumible', 'Limpieza', 1.00, 'Unid', 'Paquete', 3.00, 1.00, 50.00, 'Por Agotarse', 1),
(515, NULL, 'PAÑO ABSORBENTE MICROFIBRA ', 'No Consumible', 'Limpieza', 228.00, 'Unid', 'Paquete', 12.00, 1.00, 40.00, 'Sobreabastecido', 1),
(516, NULL, 'PAPEL FILTRO PARA CAFÉ', 'No Consumible', 'Cocina', 550.00, 'Unid', 'Paquete', 50.00, 1.00, 50.00, 'Sobreabastecido', 1);

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
(1, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'BISTEC\' en Gabarra RIG-42.', '2026-11-05 08:50:22'),
(2, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'CARNE MOLIDA (PULPON)\' en Gabarra RIG-42.', '2026-11-05 08:50:33'),
(3, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'COSTILLAS DE RES\' en Gabarra RIG-42.', '2026-11-05 08:50:50'),
(4, 1, 'CONSUMO_INSUMO', 'Registró consumo de 10 Kg de \'MUSLO DE POLLO\' en Gabarra RIG-42.', '2026-11-05 08:51:06'),
(5, 1, 'CONSUMO_INSUMO', 'Registró consumo de 20 Kg de \'PECHUGA DE POLLO\' en Gabarra RIG-42.', '2026-11-05 08:51:27'),
(6, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4 PCE de \'HUEVOS DE GALLINA\' en Gabarra RIG-42.', '2026-11-05 08:51:39'),
(7, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4 Kg de \'JAMON DE PIERNA ENTERO\' en Gabarra RIG-42.', '2026-11-05 08:55:56'),
(8, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'TOCINETA AHUMADA ENTERA\' (#442).', '2026-11-05 08:56:15'),
(9, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.5 Kg de \'TOCINETA AHUMADA ENTERA\' en Gabarra RIG-42.', '2026-11-05 08:56:32'),
(10, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 Kg de \'QUESO MADURADO ENTERO\' en Gabarra RIG-42.', '2026-11-05 08:57:05'),
(11, 1, 'CONSUMO_INSUMO', 'Registró consumo de 3 Kg de \'QUESO MOZARELLA ENTERO\' en Gabarra RIG-42.', '2026-11-05 08:57:22'),
(12, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'QUESO AMARILLO ENTERO\' en Gabarra RIG-42.', '2026-11-05 08:57:35'),
(13, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4 Kg de \'LIMON\' en Gabarra RIG-42.', '2026-11-05 08:57:51'),
(14, 1, 'CONSUMO_INSUMO', 'Registró consumo de 3 Kg de \'MANZANA\' en Gabarra RIG-42.', '2026-11-05 08:58:07'),
(15, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'MANDARINA\' en Gabarra RIG-42.', '2026-11-05 08:58:22'),
(16, 1, 'CONSUMO_INSUMO', 'Registró consumo de 10 Kg de \'MELON\' en Gabarra RIG-42.', '2026-11-05 08:58:37'),
(17, 1, 'CONSUMO_INSUMO', 'Registró consumo de 6 Kg de \'PARCHITA\' en Gabarra RIG-42.', '2026-11-05 08:58:50'),
(18, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4 Kg de \'PIÑA\' en Gabarra RIG-42.', '2026-11-05 09:00:11'),
(19, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1.8 Kg de \'AGUACATE\' en Gabarra RIG-42.', '2026-11-05 09:04:21'),
(20, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.21 Kg de \'AJI DULCE\' en Gabarra RIG-42.', '2026-11-05 09:04:47'),
(21, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.2 Kg de \'AJO PORRO\' en Gabarra RIG-42.', '2026-11-05 09:05:17'),
(22, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.3 Kg de \'AJO SECO (CABEZA)\' en Gabarra RIG-42.', '2026-11-05 09:07:43'),
(23, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.7 Kg de \'APIO CRIOLLO\' en Gabarra RIG-42.', '2026-11-05 09:08:27'),
(24, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1.6 Kg de \'AUYAMA\' en Gabarra RIG-42.', '2026-11-05 09:08:41'),
(25, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'CEBOLLA BLANCA\' en Gabarra RIG-42.', '2026-11-05 09:09:41'),
(26, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'CEBOLLIN\' en Gabarra RIG-42.', '2026-11-05 09:10:06'),
(27, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.5 Kg de \'CILANTRO\' en Gabarra RIG-42.', '2026-11-05 09:10:24'),
(28, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1.2 Kg de \'JOJOTO\' en Gabarra RIG-42.', '2026-11-05 09:10:40'),
(29, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2.5 Kg de \'LECHUGA LIMPIA\' en Gabarra RIG-42.', '2026-11-05 09:12:03'),
(30, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'ÑAME\' en Gabarra RIG-42.', '2026-11-05 09:12:16'),
(31, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'OCUMO\' en Gabarra RIG-42.', '2026-11-05 09:12:25'),
(32, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4 Kg de \'PAPA\' en Gabarra RIG-42.', '2026-11-05 09:12:40'),
(33, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1.5 Kg de \'PIMENTON\' en Gabarra RIG-42.', '2026-11-05 09:13:37'),
(34, 1, 'CONSUMO_INSUMO', 'Registró consumo de 15 Kg de \'PLATANO\' en Gabarra RIG-42.', '2026-11-05 09:13:56'),
(35, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'REPOLLO BLANCO\' en Gabarra RIG-42.', '2026-11-05 09:14:35'),
(36, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'REPOLLO MORADO\' en Gabarra RIG-42.', '2026-11-05 09:14:59'),
(37, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'TOMATE\' en Gabarra RIG-42.', '2026-11-05 09:15:21'),
(38, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2.04 Kg de \'YUCA\' en Gabarra RIG-42.', '2026-11-05 09:15:37'),
(39, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2.5 Kg de \'ZANAHORIA\' en Gabarra RIG-42.', '2026-11-05 09:15:50'),
(40, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 Ltr de \'ACEITE VEGETAL LITRO\' en Gabarra RIG-42.', '2026-11-05 09:19:30'),
(41, 1, 'CONSUMO_INSUMO', 'Registró consumo de 7 Kg de \'ARROZ BLANCO TIPO I\' en Gabarra RIG-42.', '2026-11-05 09:19:56'),
(42, 1, 'CONSUMO_INSUMO', 'Registró consumo de 6 Kg de \'AZUCAR BLANCA GRANULADA\' en Gabarra RIG-42.', '2026-11-05 09:20:21'),
(43, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CAFE MOLIDO, PRESENTACIÓN: PAQ. DE 500 GR\' (#334).', '2026-11-05 09:21:26'),
(44, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CAFE MOLIDO, PRESENTACIÓN: PAQ. DE 500 GR\' (#334).', '2026-11-05 09:21:39'),
(45, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CAFE MOLIDO, PRESENTACIÓN: PAQ. DE 500 GR\' (#334).', '2026-11-05 09:21:58'),
(46, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 PCE de \'CAFE MOLIDO, PRESENTACIÓN: PAQ. DE 500 GR\' en Gabarra RIG-42.', '2026-11-05 09:22:35'),
(47, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 PCE de \'GUISANTES VERDES AL NATURAL, PRESENTACIÓN: LATA DE 425 GR\' en Gabarra RIG-42.', '2026-11-05 09:22:57'),
(48, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4 Kg de \'HARINA DE MAIZ PRECOCIDA\' en Gabarra RIG-42.', '2026-11-05 09:23:16'),
(49, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4 Kg de \'HARINA DE TRIGO LEUDANTE / TODO USO\' en Gabarra RIG-42.', '2026-11-05 09:23:47'),
(50, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 Kg de \'LECHE EN POLVO, PRESENTACIÓN: 1 KG\' en Gabarra RIG-42.', '2026-11-05 09:24:19'),
(51, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Lts de \'MAYONESA PREPARADA\' en Gabarra RIG-42.', '2026-11-05 09:24:54'),
(52, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 PCE de \'MOSTAZA PREPARADA, ENVASE DE 260 A 500 GR\' en Gabarra RIG-42.', '2026-11-05 09:25:15'),
(53, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 PCE de \'PANELA\' en Gabarra RIG-42.', '2026-11-05 09:25:38'),
(54, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 PCE de \'PASTA DE TOMATE \' en Gabarra RIG-42.', '2026-11-05 10:16:56'),
(55, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'REFRESCO 2LTR\' (#372).', '2026-11-05 10:32:19'),
(56, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Unid de \'REFRESCO 2LTR\' en Gabarra RIG-42.', '2026-11-05 10:34:10'),
(57, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'REFRESCO 2LTR\' (#372).', '2026-11-05 10:36:50'),
(58, 1, 'CONSUMO_INSUMO', 'Registró consumo de 6 Unid de \'REFRESCO 2LTR\' en Gabarra RIG-42.', '2026-11-05 10:37:37'),
(59, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 Kg de \'SAL REFINADA\' en Gabarra RIG-42.', '2026-11-05 10:38:31'),
(60, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Lts de \'VINAGRE BLANCO 1LT\' en Gabarra RIG-42.', '2026-11-05 10:39:38'),
(61, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'PAN DE SANDWICH BLANCO GRANDE\' (#388).', '2026-11-05 10:40:45'),
(62, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'PAN DE SANDWICH BLANCO GRANDE\' (#388).', '2026-11-05 10:41:22'),
(63, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 Unid. de \'PAN DE SANDWICH BLANCO GRANDE\' en Gabarra RIG-42.', '2026-11-05 10:43:54'),
(64, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'PAN DE SANDWICH BLANCO GRANDE\' (#388).', '2026-11-05 10:58:13'),
(65, 1, 'CONSUMO_INSUMO', 'Registró consumo de 16 Unid. de \'PAN DE SANDWICH BLANCO GRANDE\' en Gabarra RIG-42.', '2026-11-05 11:15:57'),
(66, 1, 'CONSUMO_INSUMO', 'Registró consumo de 10 PCE de \'BOLSA DE BASURA 200KG\' en Gabarra RIG-42.', '2026-11-05 11:23:28'),
(67, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'PAN DE SANDWICH BLANCO GRANDE\' (#388).', '2026-11-05 11:34:46'),
(68, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'BOLSA DE BASURA 200KG\' (#466).', '2026-11-05 11:39:24'),
(69, 1, 'CONSUMO_INSUMO', 'Registró consumo de 16 Unid. de \'PAN DE SANDWICH BLANCO GRANDE\' en Gabarra RIG-42.', '2026-11-05 11:39:51'),
(70, 1, 'CONSUMO_INSUMO', 'Registró consumo de 10 PCE de \'BOLSA DE BASURA 200KG\' en Gabarra RIG-42.', '2026-11-05 11:51:17'),
(71, 1, 'CONSUMO_INSUMO', 'Registró consumo de 40 PCE de \'BOLSA DE 60KG\' en Gabarra RIG-42.', '2026-11-05 11:51:35'),
(72, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Lts de \'DESENGRASANTE BIODEGRADABLE\' en Gabarra RIG-42.', '2026-11-05 12:00:44'),
(73, 1, 'CONSUMO_INSUMO', 'Registró consumo de 7 PCE de \'JABON DE BAÑO\' en Gabarra RIG-42.', '2026-11-05 12:04:00'),
(74, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'JABON EN POLVO\' en Gabarra RIG-42.', '2026-11-05 12:05:35'),
(75, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4 Unid de \'PAPEL HIGIENICO\' en Gabarra RIG-42.', '2026-11-05 12:07:19'),
(76, 1, 'CONSUMO_INSUMO', 'Registró consumo de 100 PK de \'VASOS V-4 , Z-47, V-47\' en Gabarra RIG-42.', '2026-11-05 12:07:42'),
(77, 1, 'CONSUMO_INSUMO', 'Registró consumo de 100 Unid de \'VASOS  V-5\' en Gabarra RIG-42.', '2026-11-05 12:07:55'),
(78, 1, 'CONSUMO_INSUMO', 'Registró consumo de 100 PK de \'VASOS V-10, TIPO V-107 \' en Gabarra RIG-42.', '2026-11-05 12:08:17'),
(79, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'BISTEC\' en Gabarra RIG-42.', '2026-11-05 13:14:35'),
(80, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'CARNE MOLIDA (PULPON)\' en Gabarra RIG-42.', '2026-11-05 13:14:49'),
(81, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5.5 Kg de \'POLLO ENTERO EMPACADO\' en Gabarra RIG-42.', '2026-11-05 13:15:39'),
(82, 1, 'CONSUMO_INSUMO', 'Registró consumo de 10 Kg de \'MUSLO DE POLLO\' en Gabarra RIG-42.', '2026-11-05 13:17:42'),
(83, 1, 'CONSUMO_INSUMO', 'Registró consumo de 25 Kg de \'PECHUGA DE POLLO\' en Gabarra RIG-42.', '2026-11-05 13:17:59'),
(84, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 PCE de \'HUEVOS DE GALLINA\' en Gabarra RIG-42.', '2026-11-05 13:18:20'),
(85, 1, 'CONSUMO_INSUMO', 'Registró consumo de 6 Kg de \'PULPAS DE FRUTAS SURTIDAS CON AZUCAR (PAQ. DE 1 KG)\' en Gabarra RIG-42.', '2026-11-05 13:18:36'),
(86, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5.5 Kg de \'JAMON DE PIERNA ENTERO\' en Gabarra RIG-42.', '2026-11-05 13:18:52'),
(87, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'TOCINETA AHUMADA ENTERA\' en Gabarra RIG-42.', '2026-11-05 13:19:05'),
(88, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'QUESO MOZARELLA ENTERO\' en Gabarra RIG-42.', '2026-11-05 13:19:27'),
(89, 1, 'CONSUMO_INSUMO', 'Registró consumo de 3.2 Kg de \'QUESO PASTEURIZADO ENTERO\' en Gabarra RIG-42.', '2026-11-05 13:19:38'),
(90, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 Kg de \'LIMON\' en Gabarra RIG-42.', '2026-11-05 13:20:16'),
(91, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4 Kg de \'MANZANA\' en Gabarra RIG-42.', '2026-11-05 13:20:30'),
(92, 1, 'CONSUMO_INSUMO', 'Registró consumo de 35 Kg de \'NARANJA\' en Gabarra RIG-42.', '2026-11-05 13:20:54'),
(93, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5.6 Kg de \'PARCHITA\' en Gabarra RIG-42.', '2026-11-05 13:21:16'),
(94, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'AGUACATE\' en Gabarra RIG-42.', '2026-11-05 13:21:39'),
(95, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.4 Kg de \'AJI DULCE\' en Gabarra RIG-42.', '2026-11-05 13:21:52'),
(96, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.45 Kg de \'AJO PORRO\' en Gabarra RIG-42.', '2026-11-05 13:22:06'),
(97, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.5 Kg de \'APIO CRIOLLO\' en Gabarra RIG-42.', '2026-11-05 13:22:30'),
(98, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.7 Kg de \'APIO ESPAÑA O CEDANO\' en Gabarra RIG-42.', '2026-11-05 13:22:50'),
(99, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1.44 Kg de \'AUYAMA\' en Gabarra RIG-42.', '2026-11-05 13:23:13'),
(100, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'BROCOLI LIMPIO\' en Gabarra RIG-42.', '2026-11-05 13:23:24'),
(101, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'CEBOLLA BLANCA\' en Gabarra RIG-42.', '2026-11-05 13:24:04'),
(102, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 Kg de \'CEBOLLIN\' en Gabarra RIG-42.', '2026-11-05 13:24:24'),
(103, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'CILANTRO\' en Gabarra RIG-42.', '2026-11-05 13:24:44'),
(104, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'COLIFLOR LIMPIO\' en Gabarra RIG-42.', '2026-11-05 13:24:57'),
(105, 1, 'CONSUMO_INSUMO', 'Registró consumo de 3.2 Kg de \'LECHUGA LIMPIA\' en Gabarra RIG-42.', '2026-11-05 13:25:39'),
(106, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1.2 Kg de \'ÑAME\' en Gabarra RIG-42.', '2026-11-05 13:26:02'),
(107, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1.5 Kg de \'OCUMO\' en Gabarra RIG-42.', '2026-11-05 13:26:17'),
(108, 1, 'CONSUMO_INSUMO', 'Registró consumo de 19 Kg de \'PAPA\' en Gabarra RIG-42.', '2026-11-05 13:26:36'),
(109, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.25 Kg de \'PEREJIL\' en Gabarra RIG-42.', '2026-11-05 13:27:56'),
(110, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1.2 Kg de \'PIMENTON\' en Gabarra RIG-42.', '2026-11-05 13:28:06'),
(111, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4.71 Kg de \'TOMATE\' en Gabarra RIG-42.', '2026-11-05 13:28:45'),
(112, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2.8 Kg de \'ZANAHORIA\' en Gabarra RIG-42.', '2026-11-05 13:29:01'),
(113, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 Ltr de \'ACEITE VEGETAL LITRO\' en Gabarra RIG-42.', '2026-11-05 13:29:17'),
(114, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.25 Kg de \'ALIÑO ROJO EN POLVO\' en Gabarra RIG-42.', '2026-11-05 13:29:32'),
(115, 1, 'CONSUMO_INSUMO', 'Registró consumo de 3 Kg de \'ARROZ BLANCO TIPO I\' en Gabarra RIG-42.', '2026-11-05 13:29:48'),
(116, 1, 'CONSUMO_INSUMO', 'Registró consumo de 6 Kg de \'AZUCAR BLANCA GRANULADA\' en Gabarra RIG-42.', '2026-11-05 13:30:02'),
(117, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 PCE de \'CAFE MOLIDO, PRESENTACIÓN: PAQ. DE 500 GR\' en Gabarra RIG-42.', '2026-11-05 13:30:56'),
(118, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CAFE MOLIDO, PRESENTACIÓN: PAQ. DE 500 GR\' (#334).', '2026-11-05 13:32:04'),
(119, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'CAFE MOLIDO, PRESENTACIÓN: PAQ. DE 500 GR\' en Gabarra RIG-42.', '2026-11-05 13:32:52'),
(120, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 PCE de \'GUISANTES VERDES AL NATURAL, PRESENTACIÓN: LATA DE 425 GR\' en Gabarra RIG-42.', '2026-11-05 13:33:09'),
(121, 1, 'CONSUMO_INSUMO', 'Registró consumo de 3 Kg de \'HARINA DE MAIZ PRECOCIDA\' en Gabarra RIG-42.', '2026-11-05 13:33:24'),
(122, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4 Kg de \'HARINA DE TRIGO LEUDANTE / TODO USO\' en Gabarra RIG-42.', '2026-11-05 13:33:38'),
(123, 1, 'CONSUMO_INSUMO', 'Registró consumo de 3 Kg de \'LECHE EN POLVO, PRESENTACIÓN: 1 KG\' en Gabarra RIG-42.', '2026-11-05 13:33:59'),
(124, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.8 Kg de \'MAICENA / MAIZINA / ALMIDON DE MAIZ, PRESENTACIÓN\' en Gabarra RIG-42.', '2026-11-05 13:36:49'),
(125, 1, 'CONSUMO_INSUMO', 'Registró consumo de 3 Kg de \'MARGARINA / MANTEQUILLA, PRESENTACIÓN: ENVASE DE 500 GRM\' en Gabarra RIG-42.', '2026-11-05 13:39:20'),
(126, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 PCE de \'MOSTAZA PREPARADA, ENVASE DE 260 A 500 GR\' en Gabarra RIG-42.', '2026-11-05 13:40:11'),
(127, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'MOSTAZA PREPARADA, ENVASE DE 260 A 500 GR\' (#361).', '2026-11-05 13:43:34'),
(128, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'MOSTAZA PREPARADA, ENVASE DE 260 A 500 GR\' (#361).', '2026-11-05 13:44:15'),
(129, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'PASTA DE TOMATE \' (#364).', '2026-11-05 13:46:04'),
(130, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.5 PCE de \'PASTA DE TOMATE \' en Gabarra RIG-42.', '2026-11-05 13:47:20'),
(131, 1, 'CONSUMO_INSUMO', 'Registró consumo de 11 BX de \'PASTA PARA PASTICHO, PRESENTACIÓN: BT. DE 12 CAJAS DE 250 GR C/U\' en Gabarra RIG-42.', '2026-11-05 13:47:54'),
(132, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'SAL REFINADA\' en Gabarra RIG-42.', '2026-11-05 13:49:03'),
(133, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4.2 Lts de \'SALSA DE TOMATE, PRESENTACIÓN: ENVASE DE 4.2 KG\' en Gabarra RIG-42.', '2026-11-05 13:51:04'),
(134, 1, 'CONSUMO_INSUMO', 'Registró consumo de 48 Unid. de \'PAN DE SANDWICH BLANCO GRANDE\' en Gabarra RIG-42.', '2026-11-05 13:51:29'),
(135, 1, 'CONSUMO_INSUMO', 'Registró consumo de 24 Unid. de \'PAN DE HAMBURGUESA\' en Gabarra RIG-42.', '2026-11-05 13:51:45'),
(136, 1, 'CONSUMO_INSUMO', 'Registró consumo de 10 PCE de \'BOLSA DE BASURA 200KG\' en Gabarra RIG-42.', '2026-11-05 13:53:13'),
(137, 1, 'CONSUMO_INSUMO', 'Registró consumo de 40 PCE de \'BOLSA DE 60KG\' en Gabarra RIG-42.', '2026-11-05 13:53:30'),
(138, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Lts de \'DESENGRASANTE BIODEGRADABLE\' en Gabarra RIG-42.', '2026-11-05 13:53:56'),
(139, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Ltr de \'DESINFECTANTE \' en Gabarra RIG-42.', '2026-11-05 13:54:13'),
(140, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 Unid de \'ENVASE ANIME COMIDA\' en Gabarra RIG-42.', '2026-11-05 13:55:03'),
(141, 1, 'CONSUMO_INSUMO', 'Registró consumo de 25 PR de \'GUANTE DE NITRILO TALLA L\' en Gabarra RIG-42.', '2026-11-05 13:55:46'),
(142, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'JABON EN POLVO\' en Gabarra RIG-42.', '2026-11-05 13:56:34'),
(143, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Lts de \'LAVAPLATO BIODEGRADABLE GALON\' en Gabarra RIG-42.', '2026-11-05 13:57:40'),
(144, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Unid de \'PAÑITO REPASADOR\' en Gabarra RIG-42.', '2026-11-05 13:58:06'),
(145, 1, 'CONSUMO_INSUMO', 'Registró consumo de 200 PK de \'VASOS V-4 , Z-47, V-47\' en Gabarra RIG-42.', '2026-11-05 13:58:33'),
(146, 1, 'CONSUMO_INSUMO', 'Registró consumo de 100 Unid de \'VASOS  V-5\' en Gabarra RIG-42.', '2026-11-05 13:58:45'),
(147, 1, 'CONSUMO_INSUMO', 'Registró consumo de 100 PK de \'VASOS V-10, TIPO V-107 \' en Gabarra RIG-42.', '2026-11-05 13:59:05'),
(148, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'CARNE MOLIDA (PULPON)\' en Gabarra RIG-42.', '2026-11-05 14:01:45'),
(149, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'CARNE PARA MECHAR\' en Gabarra RIG-42.', '2026-11-05 14:01:57'),
(150, 1, 'CONSUMO_INSUMO', 'Registró consumo de 10 Kg de \'MUCHACHO CUADRADO/REDONDO DE RES\' en Gabarra RIG-42.', '2026-11-05 14:02:31'),
(151, 1, 'CONSUMO_INSUMO', 'Registró consumo de 10 Kg de \'PECHUGA DE POLLO\' en Gabarra RIG-42.', '2026-11-05 14:02:49'),
(152, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4 PCE de \'HUEVOS DE GALLINA\' en Gabarra RIG-42.', '2026-11-05 14:04:21'),
(153, 1, 'CONSUMO_INSUMO', 'Registró consumo de 6 Kg de \'PULPAS DE FRUTAS SURTIDAS CON AZUCAR (PAQ. DE 1 KG)\' en Gabarra RIG-42.', '2026-11-05 14:04:46'),
(154, 1, 'CONSUMO_INSUMO', 'Registró consumo de 3 Kg de \'JAMON DE PIERNA ENTERO\' en Gabarra RIG-42.', '2026-11-05 14:05:00'),
(155, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 Kg de \'QUESO MADURADO ENTERO\' en Gabarra RIG-42.', '2026-11-05 14:05:16'),
(156, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2.69 Kg de \'QUESO MOZARELLA ENTERO\' en Gabarra RIG-42.', '2026-11-05 14:05:31'),
(157, 1, 'CONSUMO_INSUMO', 'Registró consumo de 3 Kg de \'QUESO PASTEURIZADO ENTERO\' en Gabarra RIG-42.', '2026-11-05 14:05:44'),
(158, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'LIMON\' en Gabarra RIG-42.', '2026-11-05 14:05:55'),
(159, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5.4 Kg de \'MANDARINA\' en Gabarra RIG-42.', '2026-11-05 14:06:19'),
(160, 1, 'CONSUMO_INSUMO', 'Registró consumo de 3 Kg de \'NARANJA\' en Gabarra RIG-42.', '2026-11-05 14:06:46'),
(161, 1, 'CONSUMO_INSUMO', 'Registró consumo de 25.1 Kg de \'PATILLA\' en Gabarra RIG-42.', '2026-11-05 14:07:10'),
(162, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.3 Kg de \'APIO ESPAÑA O CEDANO\' en Gabarra RIG-42.', '2026-11-05 14:07:30'),
(163, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2.57 Kg de \'AUYAMA\' en Gabarra RIG-42.', '2026-11-05 14:07:49'),
(164, 1, 'CONSUMO_INSUMO', 'Registró consumo de 3.1 Kg de \'BROCOLI LIMPIO\' en Gabarra RIG-42.', '2026-11-05 14:08:02'),
(165, 1, 'CONSUMO_INSUMO', 'Registró consumo de 3.5 Kg de \'CEBOLLA BLANCA\' en Gabarra RIG-42.', '2026-11-05 14:08:40'),
(166, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'CEBOLLIN\' en Gabarra RIG-42.', '2026-11-05 14:09:13'),
(167, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'CILANTRO\' en Gabarra RIG-42.', '2026-11-05 14:09:29'),
(168, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4 Kg de \'COLIFLOR LIMPIO\' en Gabarra RIG-42.', '2026-11-05 14:09:48'),
(169, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.5 Kg de \'JOJOTO\' en Gabarra RIG-42.', '2026-11-05 14:10:07'),
(170, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'ÑAME\' en Gabarra RIG-42.', '2026-11-05 14:10:45'),
(171, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1.5 Kg de \'OCUMO\' en Gabarra RIG-42.', '2026-11-05 14:11:04'),
(172, 1, 'CONSUMO_INSUMO', 'Registró consumo de 18.5 Kg de \'PAPA\' en Gabarra RIG-42.', '2026-11-05 14:11:20'),
(173, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 Kg de \'PIMENTON\' en Gabarra RIG-42.', '2026-11-05 14:11:35'),
(174, 1, 'CONSUMO_INSUMO', 'Registró consumo de 12.5 Kg de \'PLATANO\' en Gabarra RIG-42.', '2026-11-05 14:11:49'),
(175, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2.5 Kg de \'TOMATE\' en Gabarra RIG-42.', '2026-11-05 14:12:21'),
(176, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5.5 Kg de \'ZANAHORIA\' en Gabarra RIG-42.', '2026-11-05 14:12:41'),
(177, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Ltr de \'ACEITE VEGETAL LITRO\' en Gabarra RIG-42.', '2026-11-05 14:14:14'),
(178, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4 Kg de \'ARROZ BLANCO TIPO I\' en Gabarra RIG-42.', '2026-11-05 14:14:32'),
(179, 1, 'CONSUMO_INSUMO', 'Registró consumo de 6 Kg de \'AZUCAR BLANCA GRANULADA\' en Gabarra RIG-42.', '2026-11-05 14:15:01'),
(180, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.25 Kg de \'BICARBONATO DE SODIO, PRESENTACIÓN: PAQUETE DE 30 GR\' en Gabarra RIG-42.', '2026-11-05 14:15:24'),
(181, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'CAFE MOLIDO, PRESENTACIÓN: PAQ. DE 500 GR\' en Gabarra RIG-42.', '2026-11-05 14:15:43'),
(182, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CAFE MOLIDO, PRESENTACIÓN: PAQ. DE 500 GR\' (#334).', '2026-11-05 14:25:15'),
(183, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CAFE MOLIDO, PRESENTACIÓN: PAQ. DE 500 GR\' (#334).', '2026-11-05 14:25:22'),
(184, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4 Kg de \'CARAOTAS NEGRAS SECAS\' en Gabarra RIG-42.', '2026-11-05 14:27:00'),
(185, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4 Kg de \'HARINA DE MAIZ PRECOCIDA\' en Gabarra RIG-42.', '2026-11-05 14:27:56'),
(186, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4 Kg de \'HARINA DE TRIGO LEUDANTE / TODO USO\' en Gabarra RIG-42.', '2026-11-05 14:28:23'),
(187, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 Kg de \'LECHE EN POLVO, PRESENTACIÓN: 1 KG\' en Gabarra RIG-42.', '2026-11-05 14:28:45'),
(188, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 Kg de \'MARGARINA / MANTEQUILLA, PRESENTACIÓN: ENVASE DE 500 GRM\' en Gabarra RIG-42.', '2026-11-05 14:30:24'),
(189, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Lts de \'MAYONESA PREPARADA\' en Gabarra RIG-42.', '2026-11-05 14:31:15'),
(190, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 PCE de \'PAPAS FRITAS PRECOCIDAS, PRESENTACIÓN: PAQ. DE 140 GR A 300GR\' en Gabarra RIG-42.', '2026-11-05 14:31:41'),
(191, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.5 Kg de \'PIMIENTA NEGRA MOLIDA\' en Gabarra RIG-42.', '2026-11-05 14:32:09'),
(192, 1, 'CONSUMO_INSUMO', 'Registró consumo de 3 Unid de \'REFRESCO 2LTR\' en Gabarra RIG-42.', '2026-11-05 14:32:29'),
(193, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'SAL REFINADA\' en Gabarra RIG-42.', '2026-11-05 14:32:45'),
(194, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Lts de \'VINAGRE BLANCO 1LT\' en Gabarra RIG-42.', '2026-11-05 14:32:56'),
(195, 1, 'CONSUMO_INSUMO', 'Registró consumo de 16 Unid. de \'PAN DE SANDWICH BLANCO GRANDE\' en Gabarra RIG-42.', '2026-11-05 14:33:16'),
(196, 1, 'CONSUMO_INSUMO', 'Registró consumo de 40 Unid. de \'PAN DE HAMBURGUESA\' en Gabarra RIG-42.', '2026-11-05 14:33:29'),
(197, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.5 PCE de \'PAN RALLADO\' en Gabarra RIG-42.', '2026-11-05 14:33:57'),
(198, 1, 'CONSUMO_INSUMO', 'Registró consumo de 16 Unid. de \'PAN DE PERRO CALIENTE\' en Gabarra RIG-42.', '2026-11-05 14:34:30'),
(199, 1, 'CONSUMO_INSUMO', 'Registró consumo de 10 PCE de \'BOLSA DE BASURA 200KG\' en Gabarra RIG-42.', '2026-11-05 14:35:11'),
(200, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 PCE de \'AMBIENTADOR\' en Gabarra RIG-42.', '2026-11-05 14:35:26'),
(201, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Unid de \'PAÑITO REPASADOR\' en Gabarra RIG-42.', '2026-11-05 14:35:40'),
(202, 1, 'CONSUMO_INSUMO', 'Registró consumo de 24 Unid de \'PAÑO ABSORBENTE MICROFIBRA \' en Gabarra RIG-42.', '2026-11-05 14:36:10'),
(203, 1, 'CONSUMO_INSUMO', 'Registró consumo de 50 Unid de \'PAPEL FILTRO PARA CAFÉ\' en Gabarra RIG-42.', '2026-11-05 14:37:00'),
(204, 1, 'CONSUMO_INSUMO', 'Registró consumo de 8 Unid de \'PAPEL HIGIENICO\' en Gabarra RIG-42.', '2026-11-05 14:37:38'),
(205, 1, 'CONSUMO_INSUMO', 'Registró consumo de 500 PK de \'PITILLOS (PAQUETE DE 150 PCE)\' en Gabarra RIG-42.', '2026-11-05 14:37:59'),
(206, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4 PK de \'SERVILLETAS\' en Gabarra RIG-42.', '2026-11-05 14:39:55'),
(207, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Unid de \'TOALLIN INDUSTRIAL\' en Gabarra RIG-42.', '2026-11-05 14:40:09'),
(208, 1, 'CONSUMO_INSUMO', 'Registró consumo de 200 PK de \'VASOS V-4 , Z-47, V-47\' en Gabarra RIG-42.', '2026-11-05 14:40:41'),
(209, 1, 'CONSUMO_INSUMO', 'Registró consumo de 100 Unid de \'VASOS  V-5\' en Gabarra RIG-42.', '2026-11-05 14:40:56'),
(210, 1, 'CONSUMO_INSUMO', 'Registró consumo de 150 PK de \'VASOS V-10, TIPO V-107 \' en Gabarra RIG-42.', '2026-11-05 14:41:14'),
(211, 1, 'CONSUMO_INSUMO', 'Registró consumo de 10 Kg de \'BISTEC\' en Gabarra RIG-42.', '2026-11-05 14:55:48'),
(212, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'CARNE MOLIDA (PULPON)\' en Gabarra RIG-42.', '2026-11-05 14:56:04'),
(213, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Unid de \'RABO DE RES\' en Gabarra RIG-42.', '2026-11-05 14:56:25'),
(214, 1, 'CONSUMO_INSUMO', 'Registró consumo de 25.25 Kg de \'POLLO ENTERO EMPACADO\' en Gabarra RIG-42.', '2026-11-05 14:57:23'),
(215, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'MUSLO DE POLLO\' en Gabarra RIG-42.', '2026-11-05 14:58:19'),
(216, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'PECHUGA DE POLLO\' en Gabarra RIG-42.', '2026-11-05 14:58:38'),
(217, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 PCE de \'HUEVOS DE GALLINA\' en Gabarra RIG-42.', '2026-11-05 14:59:47'),
(218, 1, 'CONSUMO_INSUMO', 'Registró consumo de 6 Kg de \'PULPAS DE FRUTAS SURTIDAS CON AZUCAR (PAQ. DE 1 KG)\' en Gabarra RIG-42.', '2026-11-05 15:00:05'),
(219, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 Kg de \'JAMON DE PIERNA ENTERO\' en Gabarra RIG-42.', '2026-11-05 15:02:54'),
(220, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'CHORIZO PARRILLERO\' en Gabarra RIG-42.', '2026-11-05 15:03:17'),
(221, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4.5 Kg de \'QUESO MADURADO ENTERO\' en Gabarra RIG-42.', '2026-11-05 15:03:35'),
(222, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 Kg de \'QUESO MOZARELLA ENTERO\' en Gabarra RIG-42.', '2026-11-05 15:04:01'),
(223, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 Kg de \'QUESO PASTEURIZADO ENTERO\' en Gabarra RIG-42.', '2026-11-05 15:04:23'),
(224, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.5 Kg de \'QUESO AMARILLO ENTERO\' en Gabarra RIG-42.', '2026-11-05 15:04:34'),
(225, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 Kg de \'LIMON\' en Gabarra RIG-42.', '2026-11-05 15:04:59'),
(226, 1, 'CONSUMO_INSUMO', 'Registró consumo de 11.2 Kg de \'MANZANA\' en Gabarra RIG-42.', '2026-11-05 15:05:12'),
(227, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1.53 Kg de \'MELON\' en Gabarra RIG-42.', '2026-11-05 15:05:46'),
(228, 1, 'CONSUMO_INSUMO', 'Registró consumo de 10 Kg de \'PATILLA\' en Gabarra RIG-42.', '2026-11-05 15:06:05'),
(229, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1.75 Kg de \'PIÑA\' en Gabarra RIG-42.', '2026-11-05 15:06:22'),
(230, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.25 Kg de \'AJI DULCE\' en Gabarra RIG-42.', '2026-11-05 15:06:43'),
(231, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.49 Kg de \'AJO PORRO\' en Gabarra RIG-42.', '2026-11-05 15:06:56'),
(232, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.2 Kg de \'AJO SECO (CABEZA)\' en Gabarra RIG-42.', '2026-11-05 15:07:13'),
(233, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.3 Kg de \'APIO CRIOLLO\' en Gabarra RIG-42.', '2026-11-05 15:07:32'),
(234, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.4 Kg de \'APIO ESPAÑA O CEDANO\' en Gabarra RIG-42.', '2026-11-05 15:07:49'),
(235, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1.77 Kg de \'AUYAMA\' en Gabarra RIG-42.', '2026-11-05 15:08:02'),
(236, 1, 'CONSUMO_INSUMO', 'Registró consumo de 3 Kg de \'CEBOLLA BLANCA\' en Gabarra RIG-42.', '2026-11-05 15:08:16'),
(237, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'CILANTRO\' en Gabarra RIG-42.', '2026-11-05 15:08:38'),
(238, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.5 Kg de \'JOJOTO\' en Gabarra RIG-42.', '2026-11-05 15:08:53'),
(239, 1, 'CONSUMO_INSUMO', 'Registró consumo de 6 Kg de \'LECHUGA LIMPIA\' en Gabarra RIG-42.', '2026-11-05 15:09:07'),
(240, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1.2 Kg de \'ÑAME\' en Gabarra RIG-42.', '2026-11-05 15:09:29'),
(241, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1.42 Kg de \'OCUMO\' en Gabarra RIG-42.', '2026-11-05 15:09:40'),
(242, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4.7 Kg de \'PAPA\' en Gabarra RIG-42.', '2026-11-05 15:09:56'),
(243, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.2 Kg de \'PEREJIL\' en Gabarra RIG-42.', '2026-11-05 15:10:14'),
(244, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1.3 Kg de \'PIMENTON\' en Gabarra RIG-42.', '2026-11-05 15:10:28'),
(245, 1, 'CONSUMO_INSUMO', 'Registró consumo de 16 Kg de \'PLATANO\' en Gabarra RIG-42.', '2026-11-05 15:10:42'),
(246, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'REPOLLO BLANCO\' en Gabarra RIG-42.', '2026-11-05 15:10:57'),
(247, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1.5 Kg de \'TOMATE\' en Gabarra RIG-42.', '2026-11-05 15:11:15'),
(248, 1, 'CONSUMO_INSUMO', 'Registró consumo de 15 Kg de \'YUCA\' en Gabarra RIG-42.', '2026-11-05 15:11:25'),
(249, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5.5 Kg de \'ZANAHORIA\' en Gabarra RIG-42.', '2026-11-05 15:11:43'),
(250, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 Ltr de \'ACEITE VEGETAL LITRO\' en Gabarra RIG-42.', '2026-11-05 15:11:58'),
(251, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.25 Kg de \'ALIÑO ROJO EN POLVO\' en Gabarra RIG-42.', '2026-11-05 15:12:47'),
(252, 1, 'CONSUMO_INSUMO', 'Registró consumo de 3 Kg de \'ARROZ BLANCO TIPO I\' en Gabarra RIG-42.', '2026-11-05 15:13:14'),
(253, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.8 Unid de \'AVENA EN HOJUELAS, PRESENTACIÓN: PAQ. DE 800 GR\' en Gabarra RIG-42.', '2026-11-05 15:13:34'),
(254, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'AZUCAR BLANCA GRANULADA\' en Gabarra RIG-42.', '2026-11-05 15:13:53'),
(255, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'CAFE MOLIDO, PRESENTACIÓN: PAQ. DE 500 GR\' en Gabarra RIG-42.', '2026-11-05 15:14:15'),
(256, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.1 Kg de \'CANELA EN RAMA\' en Gabarra RIG-42.', '2026-11-05 15:14:36'),
(257, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.1 PCE de \'CLAVOS DE OLOR\' en Gabarra RIG-42.', '2026-11-05 15:15:04'),
(258, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'HARINA DE MAIZ PRECOCIDA\' en Gabarra RIG-42.', '2026-11-05 15:15:24'),
(259, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'HARINA DE TRIGO LEUDANTE / TODO USO\' en Gabarra RIG-42.', '2026-11-05 15:15:35'),
(260, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'LECHE EN POLVO, PRESENTACIÓN: 1 KG\' en Gabarra RIG-42.', '2026-11-05 15:15:53'),
(261, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'MARGARINA / MANTEQUILLA, PRESENTACIÓN: ENVASE DE 500 GRM\' en Gabarra RIG-42.', '2026-11-05 15:16:30'),
(262, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'MOSTAZA PREPARADA, ENVASE DE 260 A 500 GR\' en Gabarra RIG-42.', '2026-11-05 15:17:03'),
(263, 1, 'CONSUMO_INSUMO', 'Registró consumo de 9 Unid de \'REFRESCO 2LTR\' en Gabarra RIG-42.', '2026-11-05 15:17:26'),
(264, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'SAL REFINADA\' en Gabarra RIG-42.', '2026-11-05 15:17:42'),
(265, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Lts de \'VINAGRE BLANCO 1LT\' en Gabarra RIG-42.', '2026-11-05 15:17:58'),
(266, 1, 'CONSUMO_INSUMO', 'Registró consumo de 16 Unid. de \'PAN DE SANDWICH BLANCO GRANDE\' en Gabarra RIG-42.', '2026-11-05 15:18:17'),
(267, 1, 'CONSUMO_INSUMO', 'Registró consumo de 40 Unid. de \'PAN DE PERRO CALIENTE\' en Gabarra RIG-42.', '2026-11-05 15:18:33'),
(268, 1, 'CONSUMO_INSUMO', 'Registró consumo de 10 PCE de \'BOLSA DE BASURA 200KG\' en Gabarra RIG-42.', '2026-11-05 15:19:23'),
(269, 1, 'CONSUMO_INSUMO', 'Registró consumo de 40 PCE de \'BOLSA DE 60KG\' en Gabarra RIG-42.', '2026-11-05 15:19:44'),
(270, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Lts de \'CLORO\' en Gabarra RIG-42.', '2026-11-05 15:19:58'),
(271, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.5 Lts de \'DESENGRASANTE BIODEGRADABLE\' en Gabarra RIG-42.', '2026-11-05 15:20:26'),
(272, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Ltr de \'DESINFECTANTE \' en Gabarra RIG-42.', '2026-11-05 15:20:38'),
(273, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ENVASE ANIME COMIDA\' (#509).', '2026-11-05 15:24:30'),
(274, 1, 'CONSUMO_INSUMO', 'Registró consumo de 400 Unid de \'ENVASE ANIME COMIDA\' en Gabarra RIG-42.', '2026-11-05 15:28:40'),
(275, 1, 'CONSUMO_INSUMO', 'Registró consumo de 50 PR de \'GUANTE DE NITRILO TALLA L\' en Gabarra RIG-42.', '2026-11-05 15:29:27'),
(276, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 PR de \'GUANTE PLASTICO TALLA L\' en Gabarra RIG-42.', '2026-11-05 15:29:53'),
(277, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 PCE de \'JABON DE BAÑO\' en Gabarra RIG-42.', '2026-11-05 15:30:26'),
(278, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'JABON EN POLVO\' en Gabarra RIG-42.', '2026-11-05 15:31:03'),
(279, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Lts de \'LAVAPLATO BIODEGRADABLE GALON\' en Gabarra RIG-42.', '2026-11-05 15:31:28'),
(280, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 PCE de \'LIMPIA HORNO CREMA\' en Gabarra RIG-42.', '2026-11-05 15:31:44'),
(281, 1, 'CONSUMO_INSUMO', 'Registró consumo de 50 Unid de \'MASCARILLAS QUIRÚRGICA DESECHABLE\' en Gabarra RIG-42.', '2026-11-05 15:32:10'),
(282, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 PCE de \'PAPEL ALUMINIO\' en Gabarra RIG-42.', '2026-11-05 15:32:33'),
(283, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4 Unid de \'PAPEL HIGIENICO\' en Gabarra RIG-42.', '2026-11-05 15:32:52'),
(284, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'PAPEL HIGIENICO\' (#490).', '2026-11-05 15:35:27'),
(285, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 PK de \'SERVILLETAS\' en Gabarra RIG-42.', '2026-11-05 15:36:47'),
(286, 1, 'CONSUMO_INSUMO', 'Registró consumo de 100 PK de \'VASOS V-4 , Z-47, V-47\' en Gabarra RIG-42.', '2026-11-05 15:37:36'),
(287, 1, 'CONSUMO_INSUMO', 'Registró consumo de 100 PK de \'VASOS V-10, TIPO V-107 \' en Gabarra RIG-42.', '2026-11-05 15:37:47'),
(288, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'BISTEC\' en Gabarra RIG-42.', '2026-11-05 15:38:19'),
(289, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'PULPA NEGRA DE RES\' en Gabarra RIG-42.', '2026-11-05 15:38:38'),
(290, 1, 'CONSUMO_INSUMO', 'Registró consumo de 19.5 Kg de \'POLLO ENTERO EMPACADO\' en Gabarra RIG-42.', '2026-11-05 15:39:39'),
(291, 1, 'CONSUMO_INSUMO', 'Registró consumo de 10 Kg de \'PECHUGA DE POLLO\' en Gabarra RIG-42.', '2026-11-05 15:39:56'),
(292, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4 PCE de \'HUEVOS DE GALLINA\' en Gabarra RIG-42.', '2026-11-05 15:40:06'),
(293, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 Kg de \'JAMON DE PIERNA ENTERO\' en Gabarra RIG-42.', '2026-11-05 15:40:19'),
(294, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 Kg de \'QUESO MOZARELLA ENTERO\' en Gabarra RIG-42.', '2026-11-05 15:41:03'),
(295, 1, 'CONSUMO_INSUMO', 'Registró consumo de 3 Kg de \'QUESO PASTEURIZADO ENTERO\' en Gabarra RIG-42.', '2026-11-05 15:41:14'),
(296, 1, 'CONSUMO_INSUMO', 'Registró consumo de 6 Kg de \'GUAYABA\' en Gabarra RIG-42.', '2026-11-05 15:41:35'),
(297, 1, 'CONSUMO_INSUMO', 'Registró consumo de 3 Kg de \'LECHOZA\' en Gabarra RIG-42.', '2026-11-05 15:41:48'),
(298, 1, 'CONSUMO_INSUMO', 'Registró consumo de 6 Kg de \'LIMON\' en Gabarra RIG-42.', '2026-11-05 15:42:03'),
(299, 1, 'CONSUMO_INSUMO', 'Registró consumo de 3 Kg de \'MORA NATURAL, 1 KGR\' en Gabarra RIG-42.', '2026-11-05 15:42:29'),
(300, 1, 'CONSUMO_INSUMO', 'Registró consumo de 6 Kg de \'PARCHITA\' en Gabarra RIG-42.', '2026-11-05 15:42:49'),
(301, 1, 'CONSUMO_INSUMO', 'Registró consumo de 15 Kg de \'PIÑA\' en Gabarra RIG-42.', '2026-11-05 15:43:00'),
(302, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.25 Kg de \'AJI DULCE\' en Gabarra RIG-42.', '2026-11-05 15:43:21'),
(303, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.22 Kg de \'AJO PORRO\' en Gabarra RIG-42.', '2026-11-05 15:43:37'),
(304, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.3 Kg de \'APIO CRIOLLO\' en Gabarra RIG-42.', '2026-11-05 15:43:55'),
(305, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.65 Kg de \'APIO ESPAÑA O CEDANO\' en Gabarra RIG-42.', '2026-11-05 15:44:16'),
(306, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4.8 Kg de \'AUYAMA\' en Gabarra RIG-42.', '2026-11-05 15:44:34'),
(307, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 Kg de \'CALABACIN\' en Gabarra RIG-42.', '2026-11-05 15:44:53'),
(308, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2.2 Kg de \'CEBOLLA BLANCA\' en Gabarra RIG-42.', '2026-11-05 15:45:06'),
(309, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.5 Kg de \'CEBOLLA MORADA\' en Gabarra RIG-42.', '2026-11-05 15:45:30'),
(310, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'CEBOLLIN\' en Gabarra RIG-42.', '2026-11-05 15:45:49'),
(311, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'CILANTRO\' en Gabarra RIG-42.', '2026-11-05 15:46:03'),
(312, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'JOJOTO\' en Gabarra RIG-42.', '2026-11-05 15:46:31'),
(313, 1, 'CONSUMO_INSUMO', 'Registró consumo de 7 Kg de \'LECHUGA LIMPIA\' en Gabarra RIG-42.', '2026-11-05 15:46:50'),
(314, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1.5 Kg de \'ÑAME\' en Gabarra RIG-42.', '2026-11-05 15:47:15'),
(315, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1.6 Kg de \'OCUMO\' en Gabarra RIG-42.', '2026-11-05 15:47:32'),
(316, 1, 'CONSUMO_INSUMO', 'Registró consumo de 9.76 Kg de \'PAPA\' en Gabarra RIG-42.', '2026-11-05 15:47:48'),
(317, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1.06 Kg de \'PEPINO\' en Gabarra RIG-42.', '2026-11-05 15:49:02'),
(318, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2.4 Kg de \'PIMENTON\' en Gabarra RIG-42.', '2026-11-05 15:51:23'),
(319, 1, 'CONSUMO_INSUMO', 'Registró consumo de 19.5 Kg de \'PLATANO\' en Gabarra RIG-42.', '2026-11-05 15:51:45'),
(320, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 Kg de \'REPOLLO BLANCO\' en Gabarra RIG-42.', '2026-11-05 15:52:01'),
(321, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'REPOLLO MORADO\' en Gabarra RIG-42.', '2026-11-05 15:52:19'),
(322, 1, 'CONSUMO_INSUMO', 'Registró consumo de 3.7 Kg de \'TOMATE\' en Gabarra RIG-42.', '2026-11-05 15:52:36'),
(323, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2.4 Kg de \'ZANAHORIA\' en Gabarra RIG-42.', '2026-11-05 15:52:51'),
(324, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Ltr de \'ACEITE VEGETAL LITRO\' en Gabarra RIG-42.', '2026-11-05 15:53:06'),
(325, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4 Kg de \'ARROZ BLANCO TIPO I\' en Gabarra RIG-42.', '2026-11-05 15:53:24'),
(326, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'AZUCAR BLANCA GRANULADA\' en Gabarra RIG-42.', '2026-11-05 15:53:44'),
(327, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'CAFE MOLIDO, PRESENTACIÓN: PAQ. DE 500 GR\' en Gabarra RIG-42.', '2026-11-05 15:54:13'),
(328, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'HARINA DE MAIZ PRECOCIDA\' en Gabarra RIG-42.', '2026-11-05 15:54:41'),
(329, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'LECHE EN POLVO, PRESENTACIÓN: 1 KG\' en Gabarra RIG-42.', '2026-11-05 15:55:01'),
(330, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'MARGARINA / MANTEQUILLA, PRESENTACIÓN: ENVASE DE 500 GRM\' en Gabarra RIG-42.', '2026-11-05 15:55:19'),
(331, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.5 Kg de \'MOSTAZA PREPARADA, ENVASE DE 260 A 500 GR\' en Gabarra RIG-42.', '2026-11-05 15:55:36'),
(332, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4 PCE de \'PANELA\' en Gabarra RIG-42.', '2026-11-05 15:55:50'),
(333, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'SAL REFINADA\' en Gabarra RIG-42.', '2026-11-05 15:56:22'),
(334, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Lts de \'VINAGRE BLANCO 1LT\' en Gabarra RIG-42.', '2026-11-05 15:56:35'),
(335, 1, 'CONSUMO_INSUMO', 'Registró consumo de 24 Unid. de \'PAN DE SANDWICH BLANCO GRANDE\' en Gabarra RIG-42.', '2026-11-05 15:56:48'),
(336, 1, 'CONSUMO_INSUMO', 'Registró consumo de 10 PCE de \'BOLSA DE BASURA 200KG\' en Gabarra RIG-42.', '2026-11-05 15:57:17'),
(337, 1, 'CONSUMO_INSUMO', 'Registró consumo de 100 Unid de \'CUCHARA PLASTICA PARA POSTRE (20 PCE POR PAQUETE)\' en Gabarra RIG-42.', '2026-11-05 15:57:37'),
(338, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Ltr de \'DESINFECTANTE \' en Gabarra RIG-42.', '2026-11-05 15:57:50'),
(339, 1, 'CONSUMO_INSUMO', 'Registró consumo de 30 PCE de \'JABON DE BAÑO\' en Gabarra RIG-42.', '2026-11-05 15:58:08'),
(340, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'JABON EN POLVO\' en Gabarra RIG-42.', '2026-11-05 15:58:31'),
(341, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 Unid de \'MOPAS INDUSTRIALES\' en Gabarra RIG-42.', '2026-11-05 15:58:57'),
(342, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4 Unid de \'PAPEL HIGIENICO\' en Gabarra RIG-42.', '2026-11-05 15:59:09'),
(343, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 PK de \'SERVILLETAS\' en Gabarra RIG-42.', '2026-11-05 15:59:33'),
(344, 1, 'CONSUMO_INSUMO', 'Registró consumo de 200 PK de \'VASOS V-4 , Z-47, V-47\' en Gabarra RIG-42.', '2026-11-05 15:59:55'),
(345, 1, 'CONSUMO_INSUMO', 'Registró consumo de 100 Unid de \'VASOS  V-5\' en Gabarra RIG-42.', '2026-11-05 16:00:12'),
(346, 1, 'CONSUMO_INSUMO', 'Registró consumo de 100 PK de \'VASOS V-10, TIPO V-107 \' en Gabarra RIG-42.', '2026-11-05 16:00:26');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `menus_semanales`
--

CREATE TABLE `menus_semanales` (
  `id_menu_semanal` int(11) NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `semana_numero` int(11) NOT NULL,
  `observaciones` text DEFAULT NULL,
  `id_coordinador` int(11) NOT NULL,
  `fecha_creacion` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `menus_semanales`
--

INSERT INTO `menus_semanales` (`id_menu_semanal`, `fecha_inicio`, `fecha_fin`, `semana_numero`, `observaciones`, `id_coordinador`, `fecha_creacion`) VALUES
(1, '2026-10-26', '2026-11-01', 44, '', 1, '2026-10-26 15:25:55'),
(2, '2026-11-02', '2026-11-08', 45, '', 1, '2026-10-29 16:11:54');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `menu_diario_detalle`
--

CREATE TABLE `menu_diario_detalle` (
  `id_detalle` int(11) NOT NULL,
  `id_menu_semanal` int(11) NOT NULL,
  `dia_semana` enum('Lunes','Martes','Miércoles','Jueves','Viernes','Sábado','Domingo') NOT NULL,
  `tipo_comida` varchar(50) NOT NULL,
  `plato_principal` text NOT NULL,
  `guarnicion` text DEFAULT NULL,
  `ensalada_sopa` text DEFAULT NULL,
  `postre_bebida` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `menu_diario_detalle`
--

INSERT INTO `menu_diario_detalle` (`id_detalle`, `id_menu_semanal`, `dia_semana`, `tipo_comida`, `plato_principal`, `guarnicion`, `ensalada_sopa`, `postre_bebida`) VALUES
(67, 1, 'Lunes', 'Desayuno', 'AREPA CON JAMON Y QUESO / SANDWICH X 3 JAMON Y QUESO CON VEGETALES', '', '', 'CHOCOLATE CALIENTE / JUGO DE NARANJA / TIZANA'),
(68, 1, 'Lunes', 'Almuerzo', 'BISTEC SALTEADO / PASTA CON ATUN EN SALSA DE TOMATE', 'ARROZ BLANCO / PAN AL AJILLO', 'ENSALADA MORADA / SOPA TUBERCULOS', 'JUGO 3 EN 1'),
(69, 1, 'Lunes', 'Cena', 'PAELLA POLLO / CHULETA DE CERDO AGRIDULCE', 'ARROZ BLANCO / TAJADAS', 'ENSALADA COLESLAW', 'JUGO DE MELON / PONQUESITO MARMOLEADO.'),
(70, 1, 'Lunes', 'Cena de Media Noche', 'HAMBURGUESAS DE CARNE', '', '', 'REFRESCO'),
(71, 1, 'Martes', 'Desayuno', 'AREPA CATIRA / MANDOCA DE PLATANO Y QUESO', '', '', 'CAFÉ CON LECHE / JUGO DE GUAYABA /CAMBUR.'),
(72, 1, 'Martes', 'Almuerzo', 'POLLO A LA PLANCHA / PESCADO EN SALSA VERDE', 'ARROZ PRIMAVERA / TAJADAS', 'ENSALADA COCIDA / SOPA DE GALLINA', 'JUGO DE PULPAS'),
(73, 1, 'Martes', 'Cena', 'PASTEL DE PLATANO / POLLO MEDITERRANEO HORNEADO', 'ARROZ AMARILLO / PAN AL AJILLO / QUESO TAJADO', '', 'JUGO DE PULPAS / CAMBUR'),
(74, 1, 'Martes', 'Cena de Media Noche', 'MILANESAS DE POLLO', 'PURE DE PAPAS / VEGETALES GRATINADOS ', '', 'JUGO DE PULPAS '),
(75, 1, 'Miércoles', 'Desayuno', 'TEQUEÑOS / AREPA CON JAMON Y QUESO', '', '', 'MAICENA CALIENTE / JUGO DE PARCHITA / PATILLA'),
(76, 1, 'Miércoles', 'Almuerzo', 'ENVUELTO DE POLLO / CARNE EN JULIANA', ' PASTA CORTA CON VEGETALES / PAN TOSTADO', 'ENSALADA CRUDA / SOPA DE POLLO', 'PAPELÓN CON LIMÓN'),
(77, 1, 'Miércoles', 'Cena', 'PINCHOS MIXTOS', 'QUESO FRITO / PAPAS RUSTICAS', 'ENSALADA COLESLAW', 'REFRESCO / TORTA CON PUDÍN'),
(78, 1, 'Miércoles', 'Cena de Media Noche', 'CHORIPANES ', '', '', 'PAPELÓN CON LIMÓN'),
(79, 1, 'Jueves', 'Desayuno', 'AREPA CON HARINA DE TRIGO, MORTADELA Y QUESO / PAN MOROCHO JAMON Y QUESO CON VERDURAS', '', '', 'CAFÉ CON LECHE / JUGO DE PULPA / MELÓN '),
(80, 1, 'Jueves', 'Almuerzo', 'CHULETA AHUMADA BBQ / POLLO RELLENO', 'ARROZ PALITO / PURE DE PLATANO', 'ENSALADA CRUDA/COCIDA / SOPA DE GRANOS', 'JUGO DE PIÑA'),
(81, 1, 'Jueves', 'Cena', 'MOJITO EN COCO / CARNE SALTEADA CON VEGETALES', 'ARROZ BLANCO / AREPA ASADA', 'ENSALADA MIXTA', 'JUGO DE MORA / BIZCOCHO SENCILLO'),
(82, 1, 'Jueves', 'Cena de Media Noche', 'CLUB SANDWICH', 'PAPAS FRITAS', '', 'JUGO DE PULPA'),
(83, 1, 'Viernes', 'Desayuno', 'EMPANADA, MOJITO Y PAPA CON QUESO / HUEVO PERICO CON PAN TOSTADO', '', '', 'AVENA CALIENTE / JUGO DE PATILLA / PIÑA'),
(84, 1, 'Viernes', 'Almuerzo', 'POLLO GUISADO / BISTEC ENCEBOLLADO', 'ARROZ BLANCO / TOSTONES', 'ENSALADA CRUDA CON AGUACATE / SOPA DE PESCADO', 'PAPELÓN CON LIMÓN'),
(85, 1, 'Viernes', 'Cena', 'PERNIL EN SALSA / CHICHARRONES DE PESCADO', 'ARROZ PRIMAVERA / YUCA FRITA', 'ENSALADA COCIDA EN RUEDA', 'PAPELÓN CON LIMÓN / DULCE DE PIÑA CON MANJAR'),
(86, 1, 'Viernes', 'Cena de Media Noche', 'SHAWARMA', '', '', 'REFRESCO'),
(87, 1, 'Sábado', 'Desayuno', 'CACHAPA  CON QUESO / PAN CON POLLO', '', '', 'CHOCOLATE CALIENTE / JUGO MELÓN / CAMBUR'),
(88, 1, 'Sábado', 'Almuerzo', 'HIGADO ENCEBOLLADO / POLLO HORNEADO EN SALSA', 'ARROZ CON GUISANTES / PLATANO HORNEADO', 'ENSALDA BLANCA / CREMA DE APIO', 'LIMONADA'),
(89, 1, 'Sábado', 'Cena', 'PASTA CON POLLO / ARROZ CHINO', 'QUESO / AREPITAS FRITAS CON QUESO', 'ENSALADA RALLADA', 'QUESILLO / JUGO DE PULPA '),
(90, 1, 'Sábado', 'Cena de Media Noche', 'PINCHOS MIXTOS / YUCA FRITA', '', '', 'NESTEA'),
(91, 1, 'Domingo', 'Desayuno', 'AREPA FRITA CON CHORIZO Y QUESO / HUEVO CON CARNE MOLIDA Y TOSTADA', '', '', 'FORORO CALIENTE / JUGO DE LECHOZA / MANDARINA.'),
(92, 1, 'Domingo', 'Almuerzo', 'PESCADO FRITO / CARNE GUISADA CON PAPA', 'ARROZ BLANCO / TOSTONES', 'ENSALADA CRUDA CON AGUACATE / SOPA DE RABO', 'REFRESCO'),
(93, 1, 'Domingo', 'Cena', 'PARRILLA MIXTA (POLLO, CARNE, CHULETA, CHORIZO)', 'QUESO A LA PLANCHA / YUCA AL AJILLO / GUACAMOLE', 'ENSALADA COLESLAW ', 'REFRESCO / HELADO DE FRUTA'),
(94, 1, 'Domingo', 'Cena de Media Noche', 'POLLO FRITO / PAPAS FRITAS', '', 'ENSALADA COLESLAW', 'REFRESCO'),
(200, 2, 'Lunes', 'Desayuno', 'Arepas con pollo desmechado y queso / Club house con tortilla de huevo', '', '', 'Café con leche / Jugo de patilla [Fruta: Cambur]'),
(201, 2, 'Lunes', 'Almuerzo', 'Pollo a la BBQ / Estofado de lomo', 'Arroz verde / Plátano horneado / Vegetales salteados (coliflor, zanahoria, cebolla y brócoli)', 'Sopa de pollo', 'Jugo de pulpa de frutas'),
(202, 2, 'Lunes', 'Cena', 'Pollo con vegetales / Bistec con salsa napoli', 'Arroz con zanahoria / Arepitas horneadas / Ensalada rallada (repollo blanco, cebolla, zanahoria y remolacha)', '', 'Papelón con limón [Postre: Quesillo]'),
(203, 2, 'Lunes', 'Cena de Media Noche', 'Pastel de pollo horneado', 'Ensalada tricolor', '', 'Jugo de melón'),
(204, 2, 'Martes', 'Desayuno', 'Panquecas con jamón y queso / Plátano horneado con jamón y queso rallado', '', '', 'Avena caliente / Jugo de pulpa de frutas [Fruta: Patilla]'),
(205, 2, 'Martes', 'Almuerzo', 'Croquetas de pollo / Rollo de carne molida relleno de vegetales', 'Arroz blanco / Yuca cocida / Ensalada cruda (repollo, zanahoria y cebolla)', 'Sopa de caraotas negras', 'Jugo de piña'),
(206, 2, 'Martes', 'Cena', 'Pechuga de pollo al ajillo / Asado negro', 'Puré de papa / Tostones / Ensalada cruda (lechuga, cebolla, maíz y zanahoria)', '', 'Jugo de patilla [Fruta: Cambur]'),
(207, 2, 'Martes', 'Cena de Media Noche', 'Hamburguesa de carne', 'Papas fritas', '', 'Refresco'),
(208, 2, 'Miércoles', 'Desayuno', 'Sándwich de jamón y queso / Arepa con ensalada de atún', '', '', 'Café con leche / Jugo de melón [Fruta: Fresas]'),
(209, 2, 'Miércoles', 'Almuerzo', 'Mojito / Hígado encebollado', 'Arroz blanco / Tostones / Ensalada criolla con aguacate (lechuga, tomate y cebolla)', 'Sopa de costilla', 'Jugo de pulpa de frutas'),
(210, 2, 'Miércoles', 'Cena', 'Chuleta de cerdo a la jardinera / Pasta boloña', 'Pan al ajillo / Arroz amarillo (op. 1) / Ensalada agridulce (repollo, lechuga, cebolla y zanahoria)', '', 'Jugo de pulpa de frutas [Postre: Arroz con leche]'),
(211, 2, 'Miércoles', 'Cena de Media Noche', 'Morochos rellenos de pollo desmechado, vegetales y queso', '', '', 'Jugo de pulpa de frutas'),
(212, 2, 'Jueves', 'Desayuno', 'Arepas asadas con perico y queso / Cachitos de jamón', '', '', 'Avena caliente / Jugo de naranja [Fruta: Mandarina]'),
(213, 2, 'Jueves', 'Almuerzo', 'Bollitos de pollo en salsa de tomate / Milanesa de carne', 'Arroz a la jardinera / Plátano horneado / Ensalada rusa (papa y zanahoria)', 'Crema de auyama', 'Jugo de melón'),
(214, 2, 'Jueves', 'Cena', 'Revuelto de pollo / Albóndigas en salsa napolitana', 'Arroz con vegetales / Plátano horneado / Ensalada cocida (papa, remolacha, zanahoria y cebolla)', '', 'Jugo de mora [Fruta: Manzana]'),
(215, 2, 'Jueves', 'Cena de Media Noche', 'Pizza', '', '', 'Jugo de guayaba'),
(216, 2, 'Viernes', 'Desayuno', 'Pastel de plátano horneado con carne y queso / Arepa con jamón, queso y vegetales', '', '', 'Maicena caliente / Jugo de pulpa de frutas [Fruta: Melón]'),
(217, 2, 'Viernes', 'Almuerzo', 'Pollo horneado / Chuleta en salsa agridulce', 'Arroz primavera / Papas al ajillo / Ensalada cruda (pepino, zanahoria, cebolla y lechuga)', 'Consomé de pollo', 'Limonada'),
(218, 2, 'Viernes', 'Cena', 'Corvina horneada con vegetales / Bistec encebollado', 'Arroz amarillo / Yuca al mojo / Ensalada criolla (lechuga, tomate, cebolla y aguacate)', '', 'Limonada [Postre: Bizcocho sencillo]'),
(219, 2, 'Viernes', 'Cena de Media Noche', 'Pollo y carne desmechados', 'Arepas asadas / Ensalada criolla', '', 'Jugo de patilla'),
(220, 2, 'Sábado', 'Desayuno', 'Cachapa con jamón y queso / Pan relleno de pollo desmechado y vegetales', '', '', 'Avena caliente / Jugo de patilla [Fruta: Piña]'),
(221, 2, 'Sábado', 'Almuerzo', 'Juliana de pollo con vegetales / Pasticho de carne', 'Puré de papa (op. 1) / Pan al ajillo (op. 1) / Ensalada césar', 'Sopa de arvejas', 'Jugo de parchita'),
(222, 2, 'Sábado', 'Cena', 'Pernil en salsa de naranja / Chop suey de carne', 'Arroz blanco / Plátano horneado / Vegetales salteados (brócoli y coliflor)', '', 'Jugo de guayaba [Postre: Tizana]'),
(223, 2, 'Sábado', 'Cena de Media Noche', 'Club house con pollo, queso y vegetales', 'Papas fritas', '', 'Jugo de melón'),
(224, 2, 'Domingo', 'Desayuno', 'Empanadas de carne mechada / Mandoca y queso', '', '', 'Café con leche / Jugo de patilla [Fruta: Manzana]'),
(225, 2, 'Domingo', 'Almuerzo', 'Pescado frito / Carne guisada', 'Arroz con ají / Yuca al vapor / Ensalada cruda (repollo blanco y morado, cebolla, zanahoria y perejil)', 'Sopa de pollo', 'Jugo de pulpa de frutas'),
(226, 2, 'Domingo', 'Cena', 'Parrilla mixta (única)', 'Arepitas horneadas / Yuca / Ensalada cruda', '', 'Refresco [Postre: Galletas caseras]'),
(227, 2, 'Domingo', 'Cena de Media Noche', 'Carne asada salteada', 'Arepas asadas / Pico de gallo', '', 'Jugo de parchita');

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
(1, 499, 5.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(2, 449, 5.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(3, 453, 5.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(4, 464, 10.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(5, 465, 20.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(6, 436, 4.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(7, 438, 4.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(8, 442, 0.50, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(9, 445, 2.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(10, 446, 3.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(11, 444, 1.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(12, 397, 4.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(13, 399, 3.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(14, 398, 5.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(15, 400, 10.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(16, 403, 6.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(17, 405, 4.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(18, 406, 1.80, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(19, 407, 0.21, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(20, 408, 0.20, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(21, 409, 0.30, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(22, 410, 0.70, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(23, 412, 1.60, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(24, 415, 5.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(25, 417, 1.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(26, 418, 0.50, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(27, 420, 1.20, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(28, 421, 2.50, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(29, 422, 1.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(30, 423, 1.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(31, 424, 4.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(32, 427, 1.50, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(33, 428, 15.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(34, 430, 5.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(35, 431, 1.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(36, 432, 5.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(37, 433, 2.04, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(38, 434, 2.50, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(39, 323, 2.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(40, 328, 7.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(41, 333, 6.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(42, 334, 1.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(43, 347, 1.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(44, 348, 4.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(45, 349, 4.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(46, 353, 2.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(47, 359, 1.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(48, 361, 2.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(49, 507, 5.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(50, 364, 2.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(52, 372, 6.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(53, 374, 2.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(54, 383, 1.00, 'Gabarra RIG-42', '2026-10-29 00:00:00', 1, ''),
(58, 388, 16.00, 'Gabarra RIG-42', '2026-10-29 11:39:51', 1, ''),
(59, 466, 10.00, 'Gabarra RIG-42', '2026-10-29 11:51:17', 1, ''),
(60, 467, 40.00, 'Gabarra RIG-42', '2026-10-29 11:51:35', 1, ''),
(61, 471, 1.00, 'Gabarra RIG-42', '2026-10-29 12:00:44', 1, ''),
(62, 481, 7.00, 'Gabarra RIG-42', '2026-10-29 12:04:00', 1, ''),
(63, 482, 5.00, 'Gabarra RIG-42', '2026-10-29 12:05:35', 1, ''),
(64, 490, 4.00, 'Gabarra RIG-42', '2026-10-29 12:07:19', 1, ''),
(65, 496, 100.00, 'Gabarra RIG-42', '2026-10-29 12:07:42', 1, ''),
(66, 497, 100.00, 'Gabarra RIG-42', '2026-10-29 12:07:55', 1, ''),
(67, 498, 100.00, 'Gabarra RIG-42', '2026-10-29 12:08:17', 1, ''),
(68, 499, 5.00, 'Gabarra RIG-42', '2026-10-30 13:14:35', 1, ''),
(69, 449, 5.00, 'Gabarra RIG-42', '2026-10-30 13:14:49', 1, ''),
(70, 463, 5.50, 'Gabarra RIG-42', '2026-10-30 13:15:39', 1, ''),
(71, 464, 10.00, 'Gabarra RIG-42', '2026-10-30 13:17:42', 1, ''),
(72, 465, 25.00, 'Gabarra RIG-42', '2026-10-30 13:17:59', 1, ''),
(73, 436, 2.00, 'Gabarra RIG-42', '2026-10-30 13:18:20', 1, ''),
(74, 435, 6.00, 'Gabarra RIG-42', '2026-10-30 13:18:36', 1, ''),
(75, 438, 5.50, 'Gabarra RIG-42', '2026-10-30 13:18:52', 1, ''),
(76, 442, 1.00, 'Gabarra RIG-42', '2026-10-30 13:19:05', 1, ''),
(77, 446, 5.00, 'Gabarra RIG-42', '2026-10-30 13:19:27', 1, '\r\n'),
(78, 447, 3.20, 'Gabarra RIG-42', '2026-10-30 13:19:38', 1, ''),
(79, 397, 2.00, 'Gabarra RIG-42', '2026-10-30 13:20:16', 1, ''),
(80, 399, 4.00, 'Gabarra RIG-42', '2026-10-30 13:20:30', 1, ''),
(81, 402, 35.00, 'Gabarra RIG-42', '2026-10-30 13:20:54', 1, ''),
(82, 403, 5.60, 'Gabarra RIG-42', '2026-10-30 13:21:16', 1, ''),
(83, 406, 1.00, 'Gabarra RIG-42', '2026-10-30 13:21:39', 1, ''),
(84, 407, 0.40, 'Gabarra RIG-42', '2026-10-30 13:21:52', 1, ''),
(85, 408, 0.45, 'Gabarra RIG-42', '2026-10-30 13:22:06', 1, ''),
(86, 410, 0.50, 'Gabarra RIG-42', '2026-10-30 13:22:30', 1, ''),
(87, 411, 0.70, 'Gabarra RIG-42', '2026-10-30 13:22:50', 1, ''),
(88, 412, 1.44, 'Gabarra RIG-42', '2026-10-30 13:23:13', 1, ''),
(89, 413, 1.00, 'Gabarra RIG-42', '2026-10-30 13:23:24', 1, ''),
(90, 415, 5.00, 'Gabarra RIG-42', '2026-10-30 13:24:04', 1, ''),
(91, 417, 2.00, 'Gabarra RIG-42', '2026-10-30 13:24:24', 1, ''),
(92, 418, 1.00, 'Gabarra RIG-42', '2026-10-30 13:24:44', 1, ''),
(93, 419, 1.00, 'Gabarra RIG-42', '2026-10-30 13:24:57', 1, ''),
(94, 421, 3.20, 'Gabarra RIG-42', '2026-10-30 13:25:39', 1, ''),
(95, 422, 1.20, 'Gabarra RIG-42', '2026-10-30 13:26:02', 1, ''),
(96, 423, 1.50, 'Gabarra RIG-42', '2026-10-30 13:26:17', 1, ''),
(97, 424, 19.00, 'Gabarra RIG-42', '2026-10-30 13:26:36', 1, ''),
(98, 425, 0.25, 'Gabarra RIG-42', '2026-10-30 13:27:56', 1, ''),
(99, 427, 1.20, 'Gabarra RIG-42', '2026-10-30 13:28:06', 1, ''),
(100, 432, 4.71, 'Gabarra RIG-42', '2026-10-30 13:28:45', 1, ''),
(101, 434, 2.80, 'Gabarra RIG-42', '2026-10-30 13:29:01', 1, ''),
(102, 323, 2.00, 'Gabarra RIG-42', '2026-10-30 13:29:17', 1, ''),
(103, 327, 0.25, 'Gabarra RIG-42', '2026-10-30 13:29:32', 1, ''),
(104, 328, 3.00, 'Gabarra RIG-42', '2026-10-30 13:29:48', 1, ''),
(105, 333, 6.00, 'Gabarra RIG-42', '2026-10-30 13:30:02', 1, ''),
(106, 334, 1.00, 'Gabarra RIG-42', '2026-10-30 13:30:56', 1, ''),
(108, 347, 1.00, 'Gabarra RIG-42', '2026-10-30 13:33:09', 1, ''),
(109, 348, 3.00, 'Gabarra RIG-42', '2026-10-30 13:33:24', 1, ''),
(110, 349, 4.00, 'Gabarra RIG-42', '2026-10-30 13:33:38', 1, ''),
(111, 353, 3.00, 'Gabarra RIG-42', '2026-10-30 13:33:59', 1, ''),
(112, 355, 0.80, 'Gabarra RIG-42', '2026-10-30 13:36:49', 1, ''),
(113, 358, 3.00, 'Gabarra RIG-42', '2026-10-30 13:39:20', 1, ''),
(114, 361, 1.00, 'Gabarra RIG-42', '2026-10-30 13:40:11', 1, ''),
(115, 364, 0.50, 'Gabarra RIG-42', '2026-10-30 13:47:20', 1, ''),
(116, 367, 11.00, 'Gabarra RIG-42', '2026-10-30 13:47:54', 1, ''),
(117, 374, 1.00, 'Gabarra RIG-42', '2026-10-30 13:49:03', 1, ''),
(118, 378, 4.20, 'Gabarra RIG-42', '2026-10-30 13:51:04', 1, ''),
(119, 388, 48.00, 'Gabarra RIG-42', '2026-10-30 13:51:29', 1, ''),
(120, 390, 24.00, 'Gabarra RIG-42', '2026-10-30 13:51:45', 1, ''),
(121, 466, 10.00, 'Gabarra RIG-42', '2026-10-30 13:53:13', 1, ''),
(122, 467, 40.00, 'Gabarra RIG-42', '2026-10-30 13:53:30', 1, ''),
(123, 471, 1.00, 'Gabarra RIG-42', '2026-10-30 13:53:56', 1, ''),
(124, 472, 1.00, 'Gabarra RIG-42', '2026-10-30 13:54:13', 1, ''),
(125, 509, 2.00, 'Gabarra RIG-42', '2026-10-30 13:55:03', 1, ''),
(126, 477, 25.00, 'Gabarra RIG-42', '2026-10-30 13:55:46', 1, ''),
(127, 482, 5.00, 'Gabarra RIG-42', '2026-10-30 13:56:34', 1, ''),
(128, 483, 1.00, 'Gabarra RIG-42', '2026-10-30 13:57:40', 1, ''),
(129, 514, 1.00, 'Gabarra RIG-42', '2026-10-30 13:58:06', 1, ''),
(130, 496, 200.00, 'Gabarra RIG-42', '2026-10-30 13:58:33', 1, ''),
(131, 497, 100.00, 'Gabarra RIG-42', '2026-10-30 13:58:45', 1, ''),
(132, 498, 100.00, 'Gabarra RIG-42', '2026-10-30 13:59:05', 1, ''),
(133, 449, 5.00, 'Gabarra RIG-42', '2026-10-31 14:01:45', 1, ''),
(134, 448, 5.00, 'Gabarra RIG-42', '2026-10-31 14:01:57', 1, ''),
(135, 457, 10.00, 'Gabarra RIG-42', '2026-10-31 14:02:31', 1, ''),
(136, 465, 10.00, 'Gabarra RIG-42', '2026-10-31 14:02:49', 1, ''),
(137, 436, 4.00, 'Gabarra RIG-42', '2026-10-31 14:04:21', 1, ''),
(138, 435, 6.00, 'Gabarra RIG-42', '2026-10-31 14:04:46', 1, ''),
(139, 438, 3.00, 'Gabarra RIG-42', '2026-10-31 14:05:00', 1, ''),
(140, 445, 2.00, 'Gabarra RIG-42', '2026-10-31 14:05:16', 1, ''),
(141, 446, 2.69, 'Gabarra RIG-42', '2026-10-31 14:05:31', 1, ''),
(142, 447, 3.00, 'Gabarra RIG-42', '2026-10-31 14:05:44', 1, ''),
(143, 397, 1.00, 'Gabarra RIG-42', '2026-10-31 14:05:55', 1, ''),
(144, 398, 5.40, 'Gabarra RIG-42', '2026-10-31 14:06:19', 1, ''),
(145, 402, 3.00, 'Gabarra RIG-42', '2026-10-31 14:06:46', 1, ''),
(146, 404, 25.10, 'Gabarra RIG-42', '2026-10-31 14:07:10', 1, ''),
(147, 411, 0.30, 'Gabarra RIG-42', '2026-10-31 14:07:30', 1, ''),
(148, 412, 2.57, 'Gabarra RIG-42', '2026-10-31 14:07:49', 1, ''),
(149, 413, 3.10, 'Gabarra RIG-42', '2026-10-31 14:08:02', 1, ''),
(150, 415, 3.50, 'Gabarra RIG-42', '2026-10-31 14:08:40', 1, ''),
(151, 417, 1.00, 'Gabarra RIG-42', '2026-10-31 14:09:13', 1, ''),
(152, 418, 1.00, 'Gabarra RIG-42', '2026-10-31 14:09:29', 1, ''),
(153, 419, 4.00, 'Gabarra RIG-42', '2026-10-31 14:09:48', 1, ''),
(154, 420, 0.50, 'Gabarra RIG-42', '2026-10-31 14:10:07', 1, ''),
(155, 422, 1.00, 'Gabarra RIG-42', '2026-10-31 14:10:45', 1, ''),
(156, 423, 1.50, 'Gabarra RIG-42', '2026-10-31 14:11:04', 1, ''),
(157, 424, 18.50, 'Gabarra RIG-42', '2026-10-31 14:11:20', 1, ''),
(158, 427, 2.00, 'Gabarra RIG-42', '2026-10-31 14:11:35', 1, ''),
(159, 428, 12.50, 'Gabarra RIG-42', '2026-10-31 14:11:49', 1, ''),
(160, 432, 2.50, 'Gabarra RIG-42', '2026-10-31 14:12:21', 1, ''),
(161, 434, 5.50, 'Gabarra RIG-42', '2026-10-31 14:12:41', 1, ''),
(162, 323, 1.00, 'Gabarra RIG-42', '2026-10-31 14:14:14', 1, ''),
(163, 328, 4.00, 'Gabarra RIG-42', '2026-10-31 14:14:32', 1, ''),
(164, 333, 6.00, 'Gabarra RIG-42', '2026-10-31 14:15:01', 1, ''),
(165, 332, 0.25, 'Gabarra RIG-42', '2026-10-31 14:15:24', 1, ''),
(166, 334, 1.00, 'Gabarra RIG-42', '2026-10-31 14:15:43', 1, ''),
(167, 337, 4.00, 'Gabarra RIG-42', '2026-10-31 14:27:00', 1, ''),
(168, 348, 4.00, 'Gabarra RIG-42', '2026-10-31 14:27:56', 1, ''),
(169, 349, 4.00, 'Gabarra RIG-42', '2026-10-31 14:28:23', 1, ''),
(170, 353, 2.00, 'Gabarra RIG-42', '2026-10-31 14:28:45', 1, ''),
(171, 358, 2.00, 'Gabarra RIG-42', '2026-10-31 14:30:24', 1, ''),
(172, 359, 1.00, 'Gabarra RIG-42', '2026-10-31 14:31:15', 1, ''),
(173, 371, 1.00, 'Gabarra RIG-42', '2026-10-31 14:31:41', 1, ''),
(174, 508, 0.50, 'Gabarra RIG-42', '2026-10-31 14:32:09', 1, ''),
(175, 372, 3.00, 'Gabarra RIG-42', '2026-10-31 14:32:29', 1, ''),
(176, 374, 1.00, 'Gabarra RIG-42', '2026-10-31 14:32:45', 1, ''),
(177, 383, 1.00, 'Gabarra RIG-42', '2026-10-31 14:32:56', 1, ''),
(178, 388, 16.00, 'Gabarra RIG-42', '2026-10-31 14:33:16', 1, ''),
(179, 390, 40.00, 'Gabarra RIG-42', '2026-10-31 14:33:29', 1, ''),
(180, 391, 0.50, 'Gabarra RIG-42', '2026-10-31 14:33:57', 1, ''),
(181, 389, 16.00, 'Gabarra RIG-42', '2026-10-31 14:34:30', 1, ''),
(182, 466, 10.00, 'Gabarra RIG-42', '2026-10-31 14:35:11', 1, ''),
(183, 493, 1.00, 'Gabarra RIG-42', '2026-10-31 14:35:26', 1, ''),
(184, 514, 1.00, 'Gabarra RIG-42', '2026-10-31 14:35:40', 1, ''),
(185, 515, 24.00, 'Gabarra RIG-42', '2026-10-31 14:36:10', 1, ''),
(186, 516, 50.00, 'Gabarra RIG-42', '2026-10-31 14:37:00', 1, ''),
(187, 490, 8.00, 'Gabarra RIG-42', '2026-10-31 14:37:38', 1, ''),
(188, 491, 500.00, 'Gabarra RIG-42', '2026-10-31 14:37:59', 1, ''),
(189, 494, 4.00, 'Gabarra RIG-42', '2026-10-31 14:39:55', 1, ''),
(190, 495, 1.00, 'Gabarra RIG-42', '2026-10-31 14:40:09', 1, ''),
(191, 496, 200.00, 'Gabarra RIG-42', '2026-10-31 14:40:41', 1, ''),
(192, 497, 100.00, 'Gabarra RIG-42', '2026-10-31 14:40:56', 1, ''),
(193, 498, 150.00, 'Gabarra RIG-42', '2026-10-31 14:41:14', 1, ''),
(194, 499, 10.00, 'Gabarra RIG-42', '2026-11-01 14:55:48', 1, ''),
(195, 449, 5.00, 'Gabarra RIG-42', '2026-11-01 14:56:04', 1, ''),
(196, 456, 5.00, 'Gabarra RIG-42', '2026-11-01 14:56:25', 1, ''),
(197, 463, 25.25, 'Gabarra RIG-42', '2026-11-01 14:57:23', 1, ''),
(198, 464, 5.00, 'Gabarra RIG-42', '2026-11-01 14:58:19', 1, ''),
(199, 465, 5.00, 'Gabarra RIG-42', '2026-11-01 14:58:38', 1, ''),
(200, 436, 1.00, 'Gabarra RIG-42', '2026-11-01 14:59:47', 1, ''),
(201, 435, 6.00, 'Gabarra RIG-42', '2026-11-01 15:00:05', 1, ''),
(202, 438, 2.00, 'Gabarra RIG-42', '2026-11-01 15:02:54', 1, ''),
(203, 440, 5.00, 'Gabarra RIG-42', '2026-11-01 15:03:17', 1, ''),
(204, 445, 4.50, 'Gabarra RIG-42', '2026-11-01 15:03:35', 1, ''),
(205, 446, 2.00, 'Gabarra RIG-42', '2026-11-01 15:04:01', 1, ''),
(206, 447, 2.00, 'Gabarra RIG-42', '2026-11-01 15:04:23', 1, ''),
(207, 444, 0.50, 'Gabarra RIG-42', '2026-11-01 15:04:34', 1, ''),
(208, 397, 2.00, 'Gabarra RIG-42', '2026-11-01 15:04:59', 1, ''),
(209, 399, 11.20, 'Gabarra RIG-42', '2026-11-01 15:05:12', 1, ''),
(210, 400, 1.53, 'Gabarra RIG-42', '2026-11-01 15:05:46', 1, ''),
(211, 404, 10.00, 'Gabarra RIG-42', '2026-11-01 15:06:05', 1, ''),
(212, 405, 1.75, 'Gabarra RIG-42', '2026-11-01 15:06:22', 1, ''),
(213, 407, 0.25, 'Gabarra RIG-42', '2026-11-01 15:06:43', 1, ''),
(214, 408, 0.49, 'Gabarra RIG-42', '2026-11-01 15:06:56', 1, ''),
(215, 409, 0.20, 'Gabarra RIG-42', '2026-11-01 15:07:13', 1, ''),
(216, 410, 0.30, 'Gabarra RIG-42', '2026-11-01 15:07:32', 1, ''),
(217, 411, 0.40, 'Gabarra RIG-42', '2026-11-01 15:07:49', 1, ''),
(218, 412, 1.77, 'Gabarra RIG-42', '2026-11-01 15:08:02', 1, ''),
(219, 415, 3.00, 'Gabarra RIG-42', '2026-11-01 15:08:16', 1, ''),
(220, 418, 1.00, 'Gabarra RIG-42', '2026-11-01 15:08:38', 1, ''),
(221, 420, 0.50, 'Gabarra RIG-42', '2026-11-01 15:08:53', 1, ''),
(222, 421, 6.00, 'Gabarra RIG-42', '2026-11-01 15:09:07', 1, ''),
(223, 422, 1.20, 'Gabarra RIG-42', '2026-11-01 15:09:29', 1, ''),
(224, 423, 1.42, 'Gabarra RIG-42', '2026-11-01 15:09:40', 1, ''),
(225, 424, 4.70, 'Gabarra RIG-42', '2026-11-01 15:09:56', 1, ''),
(226, 425, 0.20, 'Gabarra RIG-42', '2026-11-01 15:10:14', 1, ''),
(227, 427, 1.30, 'Gabarra RIG-42', '2026-11-01 15:10:28', 1, ''),
(228, 428, 16.00, 'Gabarra RIG-42', '2026-11-01 15:10:42', 1, ''),
(229, 430, 5.00, 'Gabarra RIG-42', '2026-11-01 15:10:57', 1, ''),
(230, 432, 1.50, 'Gabarra RIG-42', '2026-11-01 15:11:15', 1, ''),
(231, 433, 15.00, 'Gabarra RIG-42', '2026-11-01 15:11:25', 1, ''),
(232, 434, 5.50, 'Gabarra RIG-42', '2026-11-01 15:11:43', 1, ''),
(233, 323, 2.00, 'Gabarra RIG-42', '2026-11-01 15:11:58', 1, ''),
(234, 327, 0.25, 'Gabarra RIG-42', '2026-11-01 15:12:47', 1, ''),
(235, 328, 3.00, 'Gabarra RIG-42', '2026-11-01 15:13:14', 1, ''),
(236, 330, 0.80, 'Gabarra RIG-42', '2026-11-01 15:13:34', 1, ''),
(237, 333, 5.00, 'Gabarra RIG-42', '2026-11-01 15:13:53', 1, ''),
(238, 334, 1.00, 'Gabarra RIG-42', '2026-11-01 15:14:15', 1, ''),
(239, 335, 0.10, 'Gabarra RIG-42', '2026-11-01 15:14:36', 1, ''),
(240, 340, 0.10, 'Gabarra RIG-42', '2026-11-01 15:15:04', 1, ''),
(241, 348, 5.00, 'Gabarra RIG-42', '2026-11-01 15:15:24', 1, ''),
(242, 349, 1.00, 'Gabarra RIG-42', '2026-11-01 15:15:35', 1, ''),
(243, 353, 1.00, 'Gabarra RIG-42', '2026-11-01 15:15:53', 1, ''),
(244, 358, 1.00, 'Gabarra RIG-42', '2026-11-01 15:16:30', 1, ''),
(245, 361, 1.00, 'Gabarra RIG-42', '2026-11-01 15:17:03', 1, ''),
(246, 372, 9.00, 'Gabarra RIG-42', '2026-11-01 15:17:26', 1, ''),
(247, 374, 1.00, 'Gabarra RIG-42', '2026-11-01 15:17:42', 1, ''),
(248, 383, 1.00, 'Gabarra RIG-42', '2026-11-01 15:17:58', 1, ''),
(249, 388, 16.00, 'Gabarra RIG-42', '2026-11-01 15:18:17', 1, ''),
(250, 389, 40.00, 'Gabarra RIG-42', '2026-11-01 15:18:33', 1, ''),
(251, 466, 10.00, 'Gabarra RIG-42', '2026-11-01 15:19:23', 1, ''),
(252, 467, 40.00, 'Gabarra RIG-42', '2026-11-01 15:19:44', 1, ''),
(253, 470, 1.00, 'Gabarra RIG-42', '2026-11-01 15:19:58', 1, ''),
(254, 471, 0.50, 'Gabarra RIG-42', '2026-11-01 15:20:26', 1, ''),
(255, 472, 1.00, 'Gabarra RIG-42', '2026-11-01 15:20:38', 1, ''),
(256, 509, 400.00, 'Gabarra RIG-42', '2026-11-01 15:28:40', 1, ''),
(257, 477, 50.00, 'Gabarra RIG-42', '2026-11-01 15:29:27', 1, ''),
(258, 478, 2.00, 'Gabarra RIG-42', '2026-11-01 15:29:53', 1, ''),
(259, 481, 2.00, 'Gabarra RIG-42', '2026-11-01 15:30:26', 1, ''),
(260, 482, 5.00, 'Gabarra RIG-42', '2026-11-01 15:31:03', 1, ''),
(261, 483, 1.00, 'Gabarra RIG-42', '2026-11-01 15:31:28', 1, ''),
(262, 485, 1.00, 'Gabarra RIG-42', '2026-11-01 15:31:44', 1, ''),
(263, 486, 50.00, 'Gabarra RIG-42', '2026-11-01 15:32:10', 1, ''),
(264, 488, 1.00, 'Gabarra RIG-42', '2026-11-01 15:32:33', 1, ''),
(265, 490, 4.00, 'Gabarra RIG-42', '2026-11-01 15:32:52', 1, ''),
(266, 494, 2.00, 'Gabarra RIG-42', '2026-11-01 15:36:47', 1, ''),
(267, 496, 100.00, 'Gabarra RIG-42', '2026-11-01 15:37:36', 1, ''),
(268, 498, 100.00, 'Gabarra RIG-42', '2026-11-01 15:37:47', 1, ''),
(269, 499, 5.00, 'Gabarra RIG-42', '2026-11-02 15:38:19', 1, ''),
(270, 452, 5.00, 'Gabarra RIG-42', '2026-11-02 15:38:38', 1, ''),
(271, 463, 19.50, 'Gabarra RIG-42', '2026-11-02 15:39:39', 1, ''),
(272, 465, 10.00, 'Gabarra RIG-42', '2026-11-02 15:39:56', 1, ''),
(273, 436, 4.00, 'Gabarra RIG-42', '2026-11-02 15:40:06', 1, ''),
(274, 438, 2.00, 'Gabarra RIG-42', '2026-11-02 15:40:19', 1, ''),
(275, 446, 2.00, 'Gabarra RIG-42', '2026-11-02 15:41:03', 1, ''),
(276, 447, 3.00, 'Gabarra RIG-42', '2026-11-02 15:41:14', 1, ''),
(277, 395, 6.00, 'Gabarra RIG-42', '2026-11-02 15:41:35', 1, ''),
(278, 396, 3.00, 'Gabarra RIG-42', '2026-11-02 15:41:48', 1, ''),
(279, 397, 6.00, 'Gabarra RIG-42', '2026-11-02 15:42:03', 1, ''),
(280, 401, 3.00, 'Gabarra RIG-42', '2026-11-02 15:42:29', 1, ''),
(281, 403, 6.00, 'Gabarra RIG-42', '2026-11-02 15:42:49', 1, ''),
(282, 405, 15.00, 'Gabarra RIG-42', '2026-11-02 15:43:00', 1, ''),
(283, 407, 0.25, 'Gabarra RIG-42', '2026-11-02 15:43:21', 1, ''),
(284, 408, 0.22, 'Gabarra RIG-42', '2026-11-02 15:43:37', 1, ''),
(285, 410, 0.30, 'Gabarra RIG-42', '2026-11-02 15:43:55', 1, ''),
(286, 411, 0.65, 'Gabarra RIG-42', '2026-11-02 15:44:16', 1, ''),
(287, 412, 4.80, 'Gabarra RIG-42', '2026-11-02 15:44:34', 1, ''),
(288, 414, 2.00, 'Gabarra RIG-42', '2026-11-02 15:44:53', 1, ''),
(289, 415, 2.20, 'Gabarra RIG-42', '2026-11-02 15:45:06', 1, ''),
(290, 416, 0.50, 'Gabarra RIG-42', '2026-11-02 15:45:30', 1, ''),
(291, 417, 1.00, 'Gabarra RIG-42', '2026-11-02 15:45:49', 1, ''),
(292, 418, 1.00, 'Gabarra RIG-42', '2026-11-02 15:46:03', 1, ''),
(293, 420, 1.00, 'Gabarra RIG-42', '2026-11-02 15:46:31', 1, ''),
(294, 421, 7.00, 'Gabarra RIG-42', '2026-11-02 15:46:50', 1, ''),
(295, 422, 1.50, 'Gabarra RIG-42', '2026-11-02 15:47:15', 1, ''),
(296, 423, 1.60, 'Gabarra RIG-42', '2026-11-02 15:47:32', 1, ''),
(297, 424, 9.76, 'Gabarra RIG-42', '2026-11-02 15:47:48', 1, ''),
(298, 426, 1.06, 'Gabarra RIG-42', '2026-11-02 15:49:02', 1, ''),
(299, 427, 2.40, 'Gabarra RIG-42', '2026-11-02 15:51:23', 1, ''),
(300, 428, 19.50, 'Gabarra RIG-42', '2026-11-02 15:51:45', 1, ''),
(301, 430, 2.00, 'Gabarra RIG-42', '2026-11-02 15:52:01', 1, ''),
(302, 431, 1.00, 'Gabarra RIG-42', '2026-11-02 15:52:19', 1, ''),
(303, 432, 3.70, 'Gabarra RIG-42', '2026-11-02 15:52:36', 1, ''),
(304, 434, 2.40, 'Gabarra RIG-42', '2026-11-02 15:52:50', 1, ''),
(305, 323, 1.00, 'Gabarra RIG-42', '2026-11-02 15:53:06', 1, ''),
(306, 328, 4.00, 'Gabarra RIG-42', '2026-11-02 15:53:24', 1, ''),
(307, 333, 5.00, 'Gabarra RIG-42', '2026-11-02 15:53:44', 1, ''),
(308, 334, 1.00, 'Gabarra RIG-42', '2026-11-02 15:54:13', 1, ''),
(309, 348, 5.00, 'Gabarra RIG-42', '2026-11-02 15:54:41', 1, ''),
(310, 353, 1.00, 'Gabarra RIG-42', '2026-11-02 15:55:01', 1, ''),
(311, 358, 1.00, 'Gabarra RIG-42', '2026-11-02 15:55:19', 1, ''),
(312, 361, 0.50, 'Gabarra RIG-42', '2026-11-02 15:55:36', 1, ''),
(313, 507, 4.00, 'Gabarra RIG-42', '2026-11-02 15:55:50', 1, ''),
(314, 374, 1.00, 'Gabarra RIG-42', '2026-11-02 15:56:22', 1, ''),
(315, 383, 1.00, 'Gabarra RIG-42', '2026-11-02 15:56:35', 1, ''),
(316, 388, 24.00, 'Gabarra RIG-42', '2026-11-02 15:56:48', 1, ''),
(317, 466, 10.00, 'Gabarra RIG-42', '2026-11-02 15:57:17', 1, ''),
(318, 469, 100.00, 'Gabarra RIG-42', '2026-11-02 15:57:37', 1, ''),
(319, 472, 1.00, 'Gabarra RIG-42', '2026-11-02 15:57:50', 1, ''),
(320, 481, 30.00, 'Gabarra RIG-42', '2026-11-02 15:58:08', 1, ''),
(321, 482, 5.00, 'Gabarra RIG-42', '2026-11-02 15:58:31', 1, ''),
(322, 510, 2.00, 'Gabarra RIG-42', '2026-11-02 15:58:57', 1, ''),
(323, 490, 4.00, 'Gabarra RIG-42', '2026-11-02 15:59:09', 1, ''),
(324, 494, 2.00, 'Gabarra RIG-42', '2026-11-02 15:59:33', 1, ''),
(325, 496, 200.00, 'Gabarra RIG-42', '2026-11-02 15:59:55', 1, ''),
(326, 497, 100.00, 'Gabarra RIG-42', '2026-11-02 16:00:12', 1, ''),
(327, 498, 100.00, 'Gabarra RIG-42', '2026-11-02 16:00:26', 1, '');

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
  `tarifa_alojamiento` decimal(10,2) DEFAULT 0.00,
  `id_usuario` int(11) NOT NULL,
  `id_menu_semanal` int(11) DEFAULT NULL
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
  `observaciones` text DEFAULT NULL,
  `id_usuario` int(11) NOT NULL
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
  `rol` enum('Administrador','Coord.(a) catering','Superv.(a) catering','Esp. Almacen') DEFAULT 'Coord.(a) catering',
  `creado_en` timestamp NOT NULL DEFAULT current_timestamp(),
  `estado` varchar(20) DEFAULT 'Activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `nombre`, `email`, `password`, `rol`, `creado_en`, `estado`) VALUES
(1, 'Ariadna Colmenares', 'pasante@maritime.com', '$2y$10$jAXaNAzU/6GGrt.XK5a7UO3UwWfHCrC6MeYIACNz2W1vn/4m3nguy', 'Administrador', '2026-10-06 22:09:04', 'Activo'),
(5, 'Mariangela Chacin', 'mariangela.chacin@maritime.com', '$2y$10$WH3AZJIMpU2mnOh4Q/YSluXDKyxfypc2gMZ.ma97ozNxvQs4z/LOi', 'Coord.(a) catering', '2026-10-20 19:15:59', 'Activo');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `cargas_masivas_log`
--
ALTER TABLE `cargas_masivas_log`
  ADD PRIMARY KEY (`id_carga`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `certificados_salud`
--
ALTER TABLE `certificados_salud`
  ADD PRIMARY KEY (`id_certificado`),
  ADD UNIQUE KEY `cedula` (`cedula`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `control_mermas`
--
ALTER TABLE `control_mermas`
  ADD PRIMARY KEY (`id_merma`),
  ADD KEY `id_producto` (`id_producto`),
  ADD KEY `id_usuario` (`id_usuario`);

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
  ADD PRIMARY KEY (`id_producto`),
  ADD UNIQUE KEY `codigo_sku` (`codigo_sku`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `logs_sistema`
--
ALTER TABLE `logs_sistema`
  ADD PRIMARY KEY (`id_log`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `menus_semanales`
--
ALTER TABLE `menus_semanales`
  ADD PRIMARY KEY (`id_menu_semanal`),
  ADD KEY `id_coordinador` (`id_coordinador`);

--
-- Indices de la tabla `menu_diario_detalle`
--
ALTER TABLE `menu_diario_detalle`
  ADD PRIMARY KEY (`id_detalle`),
  ADD KEY `id_menu_semanal` (`id_menu_semanal`);

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
  ADD PRIMARY KEY (`id_servicio`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `id_menu_semanal` (`id_menu_semanal`);

--
-- Indices de la tabla `solicitudes_catering`
--
ALTER TABLE `solicitudes_catering`
  ADD PRIMARY KEY (`id_solicitud`),
  ADD UNIQUE KEY `codigo_solicitud` (`codigo_solicitud`),
  ADD KEY `id_usuario` (`id_usuario`);

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
-- AUTO_INCREMENT de la tabla `cargas_masivas_log`
--
ALTER TABLE `cargas_masivas_log`
  MODIFY `id_carga` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `certificados_salud`
--
ALTER TABLE `certificados_salud`
  MODIFY `id_certificado` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `control_mermas`
--
ALTER TABLE `control_mermas`
  MODIFY `id_merma` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `entradas_insumos`
--
ALTER TABLE `entradas_insumos`
  MODIFY `id_entrada` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `inventario`
--
ALTER TABLE `inventario`
  MODIFY `id_producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=517;

--
-- AUTO_INCREMENT de la tabla `logs_sistema`
--
ALTER TABLE `logs_sistema`
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=347;

--
-- AUTO_INCREMENT de la tabla `menus_semanales`
--
ALTER TABLE `menus_semanales`
  MODIFY `id_menu_semanal` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `menu_diario_detalle`
--
ALTER TABLE `menu_diario_detalle`
  MODIFY `id_detalle` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=228;

--
-- AUTO_INCREMENT de la tabla `salidas_insumos`
--
ALTER TABLE `salidas_insumos`
  MODIFY `id_salida` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=328;

--
-- AUTO_INCREMENT de la tabla `servicios_catering`
--
ALTER TABLE `servicios_catering`
  MODIFY `id_servicio` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

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
-- Filtros para la tabla `cargas_masivas_log`
--
ALTER TABLE `cargas_masivas_log`
  ADD CONSTRAINT `cargas_masivas_log_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `certificados_salud`
--
ALTER TABLE `certificados_salud`
  ADD CONSTRAINT `fk_certificados_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `control_mermas`
--
ALTER TABLE `control_mermas`
  ADD CONSTRAINT `control_mermas_ibfk_1` FOREIGN KEY (`id_producto`) REFERENCES `inventario` (`id_producto`) ON DELETE CASCADE,
  ADD CONSTRAINT `control_mermas_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE;

--
-- Filtros para la tabla `entradas_insumos`
--
ALTER TABLE `entradas_insumos`
  ADD CONSTRAINT `entradas_insumos_ibfk_1` FOREIGN KEY (`id_producto`) REFERENCES `inventario` (`id_producto`) ON DELETE CASCADE,
  ADD CONSTRAINT `entradas_insumos_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `inventario`
--
ALTER TABLE `inventario`
  ADD CONSTRAINT `fk_inventario_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_inventario_usuario_ref` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `logs_sistema`
--
ALTER TABLE `logs_sistema`
  ADD CONSTRAINT `logs_sistema_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE;

--
-- Filtros para la tabla `menus_semanales`
--
ALTER TABLE `menus_semanales`
  ADD CONSTRAINT `menus_semanales_ibfk_1` FOREIGN KEY (`id_coordinador`) REFERENCES `usuarios` (`id_usuario`);

--
-- Filtros para la tabla `menu_diario_detalle`
--
ALTER TABLE `menu_diario_detalle`
  ADD CONSTRAINT `menu_diario_detalle_ibfk_1` FOREIGN KEY (`id_menu_semanal`) REFERENCES `menus_semanales` (`id_menu_semanal`) ON DELETE CASCADE;

--
-- Filtros para la tabla `salidas_insumos`
--
ALTER TABLE `salidas_insumos`
  ADD CONSTRAINT `salidas_insumos_ibfk_1` FOREIGN KEY (`id_producto`) REFERENCES `inventario` (`id_producto`);

--
-- Filtros para la tabla `servicios_catering`
--
ALTER TABLE `servicios_catering`
  ADD CONSTRAINT `fk_servicios_menu_semanal` FOREIGN KEY (`id_menu_semanal`) REFERENCES `menus_semanales` (`id_menu_semanal`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_servicios_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `solicitudes_catering`
--
ALTER TABLE `solicitudes_catering`
  ADD CONSTRAINT `fk_solicitudes_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
