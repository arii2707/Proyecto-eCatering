-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 04-11-2026 a las 21:37:19
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
(323, '144106', 'ACEITE VEGETAL LITRO', 'Consumible', 'Víveres', 23.00, 'Ltr', 'Caja', 12.00, 15.00, 400.00, 'Disponible', 1),
(324, '150169', 'ACEITUNAS VERDES PRESENTACION 180 GRM', 'Consumible', 'Víveres', 0.00, 'PCE', 'Caja', 12.00, 30.00, 400.00, 'Agotado', 1),
(325, '150870', 'AGUA MINERAL DE 600 ML C/U', 'Consumible', 'Víveres', 12.00, 'Unid', 'Caja', 24.00, 10.00, 400.00, 'Disponible', 1),
(326, '149008', 'TODDY (BEBIDA ACHOCOLATADA), PRESENTACIÓN: PAQ. DE 400 GRM', 'Consumible', 'Víveres', 0.00, 'PCE', 'Paquete', 1.00, 5.00, 400.00, 'Agotado', 1),
(327, '143949', 'ALIÑO ROJO EN POLVO', 'Consumible', 'Víveres', 2.70, 'Kg', 'Bolsa', 1.00, 5.00, 400.00, 'Por Agotarse', 1),
(328, '144460', 'ARROZ BLANCO TIPO I', 'Consumible', 'Víveres', 116.00, 'Kg', 'Saco', 24.00, 1.00, 400.00, 'Disponible', 1),
(329, '144127', 'ATUN EN LATA , 170GR', 'Consumible', 'Víveres', 2.89, 'Kg', 'Lata', 0.17, 1.00, 400.00, 'Disponible', 1),
(330, '148637', 'AVENA EN HOJUELAS, PRESENTACIÓN: PAQ. DE 800 GR', 'Consumible', 'Víveres', 6.40, 'Unid', 'Paquete', 0.80, 1.00, 400.00, 'Disponible', 1),
(331, '143996', 'ARVEJAS VERDES SECAS', 'Consumible', 'Víveres', 1.60, 'Kg', 'Paquete', 0.40, 0.40, 400.00, 'Disponible', 1),
(332, '149207', 'BICARBONATO DE SODIO, PRESENTACIÓN: PAQUETE DE 30 GR', 'Consumible', 'Víveres', 0.50, 'Kg', 'Bolsa', 1.00, 1.00, 400.00, 'Por Agotarse', 1),
(333, '147786', 'AZUCAR BLANCA GRANULADA', 'Consumible', 'Víveres', 85.00, 'Kg', 'Caja', 24.00, 1.00, 400.00, 'Disponible', 1),
(334, '144471', 'CAFE MOLIDO, PRESENTACIÓN: PAQ. DE 500 GR', 'Consumible', 'Víveres', 26.00, 'PCE', 'Paquete', 0.50, 1.00, 400.00, 'Disponible', 1),
(335, '143951', 'CANELA EN RAMA', 'Consumible', 'Víveres', 0.30, 'Kg', 'Unidad', 0.50, 1.00, 400.00, 'Por Agotarse', 1),
(336, '143950', 'CANELA EN POLVO', 'Consumible', 'Víveres', 0.30, 'Kg', 'Unidad', 1.00, 1.00, 400.00, 'Por Agotarse', 1),
(337, '143997', 'CARAOTAS NEGRAS SECAS', 'Consumible', 'Víveres', 8.00, 'Kg', 'Bolsa', 1.00, 1.00, 400.00, 'Disponible', 1),
(338, '144481', 'CARAOTAS ROJAS SECAS', 'Consumible', 'Víveres', 6.00, 'Kg', 'Bolsa', 1.00, 1.00, 400.00, 'Disponible', 1),
(339, '148026', 'CARMENCITA (COLORANTE ALIMENTARIO)', 'Consumible', 'Víveres', 0.40, 'Kg', 'Bolsa', 1.00, 1.00, 400.00, 'Por Agotarse', 1),
(340, '154775', 'CLAVOS DE OLOR', 'Consumible', 'Víveres', 0.70, 'PCE', 'Unidad', 1.00, 1.00, 400.00, 'Por Agotarse', 1),
(341, '148839', 'COMINO EN POLVO, PRESENTACIÓN: ENVASE DE 20 A 30  GR', 'Consumible', 'Víveres', 1.00, 'PCE', 'Bolsa', 1.00, 1.00, 400.00, 'Por Agotarse', 1),
(342, '144135', 'CURRY EN POLVO', 'Consumible', 'Víveres', 1.00, 'Kg', 'Bolsa', 1.00, 1.00, 400.00, 'Por Agotarse', 1),
(343, '143999', 'FRIJOL PICO NEGRO SECO', 'Consumible', 'Víveres', 3.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible', 1),
(344, '149537', 'GELATINA GRANULADA, SABORES SURTIDOS, PRESENTACIÓN: PAQ. DE 65 GRM', 'Consumible', 'Víveres', 0.00, 'PCE', 'Paquete', 1.00, 1.00, 400.00, 'Agotado', 1),
(345, '154853', 'CEREZAS EN ALMIBAR FRASCO 125GR A 400GR', 'Consumible', 'Víveres', 1.00, 'PCE', 'Lata', 1.00, 1.00, 400.00, 'Por Agotarse', 1),
(346, '146408', 'GALLETA CLUB SOCIAL, PRESENTACIÓN: PAQ. DE 234 GR (9 MINI-PAQ. X 3 UND)', 'Consumible', 'Víveres', 0.00, 'PCE', 'Paquete', 1.00, 1.00, 400.00, 'Agotado', 1),
(347, '146409', 'GUISANTES VERDES AL NATURAL, PRESENTACIÓN: LATA DE 425 GR', 'Consumible', 'Víveres', 6.00, 'PCE', 'Paquete', 1.00, 1.00, 400.00, 'Disponible', 1),
(348, '144690', 'HARINA DE MAIZ PRECOCIDA', 'Consumible', 'Víveres', 76.00, 'Kg', 'Saco', 20.00, 1.00, 400.00, 'Disponible', 1),
(349, '144461', 'HARINA DE TRIGO LEUDANTE / TODO USO', 'Consumible', 'Víveres', 56.00, 'Kg', 'Saco', 20.00, 51.00, 400.00, 'Disponible', 1),
(350, '147864', 'LAUREL SECO EN HOJAS', 'Consumible', 'Víveres', 1.50, 'Kg', 'Bolsa', 1.00, 1.00, 400.00, 'Disponible', 1),
(351, '143968', 'LECHE CONDENSADA AZUCARADA, PRESENTACIÓN: LATA DE 397 GR', 'Consumible', 'Víveres', 0.39, 'PCE', 'Lata', 0.39, 1.00, 400.00, 'Por Agotarse', 1),
(352, '144000', 'LENTEJAS ', 'Consumible', 'Víveres', 0.80, 'Kg', 'Paquete', 0.40, 1.00, 400.00, 'Por Agotarse', 1),
(353, '148874', 'LECHE EN POLVO, PRESENTACIÓN: 1 KG', 'Consumible', 'Víveres', 21.40, 'Kg', 'Paquete', 0.90, 1.00, 400.00, 'Disponible', 1),
(354, '143974', 'LEVADURA GRANULADA PAQUETE DE 1/2 KG GRANULADA', 'Consumible', 'Víveres', 0.10, 'Kg', 'Bolsa', 1.00, 1.00, 400.00, 'Por Agotarse', 1),
(355, '144691', 'MAICENA / MAIZINA / ALMIDON DE MAIZ, PRESENTACIÓN', 'Consumible', 'Víveres', 4.80, 'Kg', 'Paquete', 0.80, 1.00, 400.00, 'Disponible', 1),
(357, '154776', 'MANTECA VEGETAL 500GR', 'Consumible', 'Víveres', 0.00, 'PCE', 'Paquete', 0.50, 1.00, 400.00, 'Agotado', 1),
(358, '150349', 'MARGARINA / MANTEQUILLA, PRESENTACIÓN: ENVASE DE 500 GRM', 'Consumible', 'Víveres', 14.00, 'Kg', 'Caja', 5.00, 1.00, 400.00, 'Disponible', 1),
(359, '144069', 'MAYONESA PREPARADA', 'Consumible', 'Víveres', 5.00, 'Lts', 'Galón', 3.60, 1.00, 400.00, 'Disponible', 1),
(361, '146411', 'MOSTAZA PREPARADA, ENVASE DE 260 A 500 GR', 'Consumible', 'Víveres', 0.94, 'PCE', 'Unidad', 0.49, 1.00, 400.00, 'Por Agotarse', 1),
(362, '149050', 'OREGANO SECO EN HOJAS', 'Consumible', 'Víveres', 0.70, 'Kg', 'Bolsa', 0.10, 1.00, 400.00, 'Por Agotarse', 1),
(364, '154774', 'PASTA DE TOMATE ', 'Consumible', 'Víveres', 2.00, 'PCE', 'Unidad', 0.50, 1.00, 400.00, 'Disponible', 1),
(365, '144467', 'PASTA CORTA', 'Consumible', 'Víveres', 38.00, 'Kg', 'Saco', 12.00, 1.00, 400.00, 'Disponible', 1),
(366, '144152', 'PASTA LARGA', 'Consumible', 'Víveres', 31.00, 'Kg', 'Saco', 12.00, 1.00, 400.00, 'Disponible', 1),
(367, '148645', 'PASTA PARA PASTICHO, PRESENTACIÓN: BT. DE 12 CAJAS DE 250 GR C/U', 'Consumible', 'Víveres', 28.00, 'BX', 'Caja', 1.00, 1.00, 400.00, 'Disponible', 1),
(368, '143972', 'POLVO DE HORNEAR, PRESENTACIÓN: ENVASE DE 200 GR', 'Consumible', 'Víveres', 2.50, 'Kg', 'Bolsa', 1.00, 1.00, 400.00, 'Disponible', 1),
(369, '154932', 'PUDIN', 'Consumible', 'Víveres', 1.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Por Agotarse', 1),
(370, '148643', 'UVAS PASAS', 'Consumible', 'Víveres', 0.00, 'Kg', 'Lata', 1.00, 1.00, 400.00, 'Agotado', 1),
(371, '149641', 'PAPAS FRITAS PRECOCIDAS, PRESENTACIÓN: PAQ. DE 140 GR A 300GR', 'Consumible', 'Víveres', 1.00, 'PCE', 'Bolsa', 1.00, 1.00, 400.00, 'Por Agotarse', 1),
(372, '147506', 'REFRESCO 2LTR', 'Consumible', 'Víveres', 36.00, 'Unid', 'Paca', 6.00, 1.00, 400.00, 'Disponible', 1),
(373, '144942', 'REFRESCO DE LATA 355ML (PAQ. 24 UNIDADES)', 'Consumible', 'Víveres', 12.00, 'PK', 'Paca', 24.00, 1.00, 400.00, 'Disponible', 1),
(374, '144472', 'SAL REFINADA', 'Consumible', 'Víveres', 33.00, 'Kg', 'Paquete', 1.00, 1.00, 400.00, 'Disponible', 1),
(375, '146412', 'SALSA 57 O 79, PRESENTACIÓN: FRASCO DE 375 ML', 'Consumible', 'Víveres', 0.37, 'PCE', 'Unidad', 0.37, 1.00, 400.00, 'Por Agotarse', 1),
(376, '147889', 'SALSA DE AJO', 'Consumible', 'Víveres', 3.70, 'Lts', 'Galón', 3.70, 1.00, 400.00, 'Disponible', 1),
(377, '147292', 'SALSA DE SOYA', 'Consumible', 'Víveres', 19.00, 'Lts', 'Galón', 3.80, 1.00, 400.00, 'Disponible', 1),
(378, '144469', 'SALSA DE TOMATE, PRESENTACIÓN: ENVASE DE 4.2 KG', 'Consumible', 'Víveres', 16.80, 'Lts', 'Galón', 4.20, 1.00, 400.00, 'Disponible', 1),
(379, '147293', 'SALSA  INGLESA', 'Consumible', 'Víveres', 11.40, 'Lts', 'Galón', 3.80, 1.00, 400.00, 'Disponible', 1),
(380, '148849', 'SARDINAS EN ACEITE / AL NATURAL, PRESENTACIÓN: LATA DE 170 GR', 'Consumible', 'Víveres', 6.63, 'PCE', 'Lata', 0.17, 1.00, 400.00, 'Disponible', 1),
(381, '149070', 'SAZONATODO (PRESENTACION: FRASCO DE 200 GR a 300GR)', 'Consumible', 'Víveres', 0.00, 'PCE', 'Unidad', 0.20, 1.00, 400.00, 'Agotado', 1),
(382, '146415', 'VAINILLA (LIQUIDA)', 'Consumible', 'Víveres', 3.00, 'Lts', 'Unidad', 1.00, 1.00, 400.00, 'Disponible', 1),
(383, '154779', 'VINAGRE BLANCO 1LT', 'Consumible', 'Víveres', 25.00, 'Lts', 'Unidad', 1.00, 1.00, 400.00, 'Disponible', 1),
(384, '154778', 'TE DE MANZANILLA SOBRE', 'Consumible', 'Víveres', 0.00, 'Unid.', 'Bolsa', 20.00, 1.00, 400.00, 'Agotado', 1),
(385, '154777', 'TÉ VERDE SOBRE', 'Consumible', 'Víveres', 20.00, 'Unid.', 'Paquete', 20.00, 1.00, 400.00, 'Disponible', 1),
(386, '154882', 'TE FRUTOS ROJOS', 'Consumible', 'Víveres', 0.00, 'Unid.', 'Bolsa', 1.00, 0.00, 400.00, 'Agotado', 1),
(387, '147871', 'TOMILLO SECO EN HOJAS', 'Consumible', 'Víveres', 0.50, 'Kg', 'Bolsa', 1.00, 1.00, 400.00, 'Por Agotarse', 1),
(388, '144004', 'PAN DE SANDWICH BLANCO GRANDE', 'Consumible', 'Panes', 384.00, 'Unid.', 'Bolsa', 8.00, 1.00, 400.00, 'Disponible', 1),
(389, '144006', 'PAN DE PERRO CALIENTE', 'Consumible', 'Panes', 176.00, 'Unid.', 'Bolsa', 8.00, 1.00, 400.00, 'Disponible', 1),
(390, '144005', 'PAN DE HAMBURGUESA', 'Consumible', 'Panes', 232.00, 'Unid.', 'Bolsa', 8.00, 1.00, 400.00, 'Disponible', 1),
(391, '154783', 'PAN RALLADO', 'Consumible', 'Panes', 1.00, 'PCE', 'Bolsa', 0.50, 1.00, 400.00, 'Por Agotarse', 1),
(392, '143980', 'CAMBUR', 'Consumible', 'Frutas', 0.00, 'Kg', 'Cesta', 100.00, 1.00, 400.00, 'Agotado', 1),
(393, '143995', 'COCO NATURAL ENTERO X KGRS', 'Consumible', 'Frutas', 4.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(394, '144309', 'FRESA   (NATURAL)  X KGRS', 'Consumible', 'Frutas', 10.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(395, '143982', 'GUAYABA', 'Consumible', 'Frutas', 26.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(396, '143983', 'LECHOZA', 'Consumible', 'Frutas', 6.80, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(397, '143984', 'LIMON', 'Consumible', 'Frutas', 15.60, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(398, '143985', 'MANDARINA', 'Consumible', 'Frutas', 5.40, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(399, '143993', 'MANZANA', 'Consumible', 'Frutas', 21.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(400, '143986', 'MELON', 'Consumible', 'Frutas', 19.80, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(401, '151281', 'MORA NATURAL, 1 KGR', 'Consumible', 'Frutas', 15.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(402, '150536', 'NARANJA', 'Consumible', 'Frutas', 68.60, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(403, '143987', 'PARCHITA', 'Consumible', 'Frutas', 19.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(404, '143988', 'PATILLA', 'Consumible', 'Frutas', 100.80, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(405, '143991', 'PIÑA', 'Consumible', 'Frutas', 56.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(406, '144071', 'AGUACATE', 'Consumible', 'Vegetales', 1.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Por Agotarse', 1),
(407, '144072', 'AJI DULCE', 'Consumible', 'Vegetales', 2.99, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(408, '144074', 'AJO PORRO', 'Consumible', 'Vegetales', 3.30, 'Kg', 'Caja', 1.00, 1.00, 400.00, 'Disponible', 1),
(409, '144075', 'AJO SECO (CABEZA)', 'Consumible', 'Vegetales', 5.70, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(410, '144076', 'APIO CRIOLLO', 'Consumible', 'Vegetales', 1.10, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(411, '144077', 'APIO ESPAÑA O CEDANO', 'Consumible', 'Vegetales', 3.80, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(412, '144078', 'AUYAMA', 'Consumible', 'Vegetales', 15.00, 'Kg', 'Caja', 1.00, 1.00, 400.00, 'Disponible', 1),
(413, '144079', 'BROCOLI LIMPIO', 'Consumible', 'Vegetales', 6.60, 'Kg', 'Caja', 1.00, 1.00, 400.00, 'Disponible', 1),
(414, '144080', 'CALABACIN', 'Consumible', 'Vegetales', 8.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(415, '144081', 'CEBOLLA BLANCA', 'Consumible', 'Vegetales', 33.50, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(416, '144082', 'CEBOLLA MORADA', 'Consumible', 'Vegetales', 2.70, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(417, '144083', 'CEBOLLIN', 'Consumible', 'Vegetales', 6.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(418, '144085', 'CILANTRO', 'Consumible', 'Vegetales', 4.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(419, '144086', 'COLIFLOR LIMPIO', 'Consumible', 'Vegetales', 6.80, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(420, '144103', 'JOJOTO', 'Consumible', 'Vegetales', 2.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(421, '144088', 'LECHUGA LIMPIA', 'Consumible', 'Vegetales', 23.80, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(422, '144089', 'ÑAME', 'Consumible', 'Vegetales', 6.90, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(423, '144090', 'OCUMO', 'Consumible', 'Vegetales', 8.50, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(424, '144091', 'PAPA', 'Consumible', 'Vegetales', 94.50, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(425, '144093', 'PEREJIL', 'Consumible', 'Vegetales', 2.40, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(426, '144092', 'PEPINO', 'Consumible', 'Vegetales', 2.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(427, '144094', 'PIMENTON', 'Consumible', 'Vegetales', 10.40, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(428, '150535', 'PLATANO', 'Consumible', 'Vegetales', 80.20, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(429, '144095', 'REMOLACHA', 'Consumible', 'Vegetales', 18.70, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(430, '144096', 'REPOLLO BLANCO', 'Consumible', 'Vegetales', 11.10, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(431, '144097', 'REPOLLO MORADO', 'Consumible', 'Vegetales', 15.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(432, '144098', 'TOMATE', 'Consumible', 'Vegetales', 29.80, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(433, '144101', 'YUCA', 'Consumible', 'Vegetales', 38.96, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(434, '144102', 'ZANAHORIA', 'Consumible', 'Vegetales', 63.30, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible', 1),
(435, '150121', 'PULPAS DE FRUTAS SURTIDAS CON AZUCAR (PAQ. DE 1 KG)', 'Consumible', 'Pulpa de frutas', 106.00, 'Kg', 'Bolsa', 48.00, 1.00, 400.00, 'Disponible', 1),
(436, '148834', 'HUEVOS DE GALLINA', 'Consumible', 'Proteínas', 31.00, 'PCE', 'Caja', 12.00, 1.00, 400.00, 'Disponible', 1),
(437, '147859', 'BOLOÑA ENTERA CARNE', 'Consumible', 'Charcutería', 0.00, 'Kg', 'Panela', 3.50, 1.00, 400.00, 'Agotado', 1),
(438, '143927', 'JAMON DE PIERNA ENTERO', 'Consumible', 'Charcutería', 31.50, 'Kg', 'Panela', 4.20, 1.00, 400.00, 'Disponible', 1),
(439, '143926', 'MORTADELA DE POLLO', 'Consumible', 'Charcutería', 1.50, 'Kg', 'Saco', 10.00, 1.00, 400.00, 'Disponible', 1),
(440, '143874', 'CHORIZO PARRILLERO', 'Consumible', 'Charcutería', 9.60, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible', 1),
(441, '143946', 'SALCHICHA TIPO WIENERS', 'Consumible', 'Charcutería', 4.80, 'Unid', 'Unidad', 100.00, 1.00, 400.00, 'Disponible', 1),
(442, '143936', 'TOCINETA AHUMADA ENTERA', 'Consumible', 'Charcutería', 1.00, 'Kg', 'Unidad', 3.00, 1.00, 400.00, 'Por Agotarse', 1),
(443, '143940', 'CREMA DE LECHE (REFRIGERADA), PRESENTACIÓN: ENVASE DE 450 A 500 GR', 'Consumible', 'Lácteos', 1.00, 'Unid', 'Lata', 1.00, 1.00, 400.00, 'Por Agotarse', 1),
(444, '143928', 'QUESO AMARILLO ENTERO', 'Consumible', 'Lácteos', 2.00, 'Kg', 'Panela', 1.00, 1.00, 400.00, 'Disponible', 1),
(445, '143925', 'QUESO MADURADO ENTERO', 'Consumible', 'Lácteos', 16.60, 'Kg', 'Unidad', 3.00, 1.00, 400.00, 'Disponible', 1),
(446, '143929', 'QUESO MOZARELLA ENTERO', 'Consumible', 'Lácteos', 16.60, 'Kg', 'Panela', 2.50, 1.00, 400.00, 'Disponible', 1),
(447, '144171', 'QUESO PASTEURIZADO ENTERO', 'Consumible', 'Lácteos', 22.60, 'Kg', 'Panela', 1.00, 1.00, 400.00, 'Disponible', 1),
(448, '143873', 'CARNE PARA MECHAR', 'Consumible', 'Proteínas', 69.60, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible', 1),
(449, '143872', 'CARNE MOLIDA (PULPON)', 'Consumible', 'Proteínas', 117.00, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible', 1),
(450, '143879', 'CHIVO', 'Consumible', 'Proteínas', 14.60, 'Kg', 'Bolsa', 5.00, 0.00, 400.00, 'Disponible', 1),
(451, '143882', 'GANSO O ENTRECANTO DE RES', 'Consumible', 'Proteínas', 0.00, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Agotado', 1),
(452, '143896', 'PULPA NEGRA DE RES', 'Consumible', 'Proteínas', 29.80, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible', 1),
(453, '143881', 'COSTILLAS DE RES', 'Consumible', 'Proteínas', 24.60, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible', 1),
(454, '143884', 'HIGADO DE RES', 'Consumible', 'Proteínas', 4.00, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible', 1),
(455, '143877', 'CHULETA DE RES', 'Consumible', 'Proteínas', 5.00, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible', 1),
(456, '143899', 'RABO DE RES', 'Consumible', 'Proteínas', 5.00, 'Unid', 'Bolsa', 5.00, 0.00, 400.00, 'Disponible', 1),
(457, '143892', 'MUCHACHO CUADRADO/REDONDO DE RES', 'Consumible', 'Proteínas', 25.00, 'Kg', 'Unidad', 3.00, 1.00, 400.00, 'Disponible', 1),
(458, '143876', 'CHULETA DE PUERCO', 'Consumible', 'Proteínas', 5.00, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible', 1),
(459, '143875', 'CHULETA AHUMADA, PRESENTACIÓN: PAQUETE DE 5 KG', 'Consumible', 'Proteínas', 0.00, 'Kg', 'Bolsa', 5.00, 0.00, 400.00, 'Agotado', 1),
(460, '143894', 'PERNIL ENTERO', 'Consumible', 'Proteínas', 6.00, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible', 1),
(461, '144041', 'CORVINA ENTERA', 'Consumible', 'Pescado', 56.40, 'Kg', 'Bolsa', 2.00, 1.00, 400.00, 'Disponible', 1),
(462, '144051', 'MOJITO DE PESCADO', 'Consumible', 'Pescado', 49.00, 'Kg', 'Bolsa', 2.00, 1.00, 400.00, 'Disponible', 1),
(463, '144064', 'POLLO ENTERO EMPACADO', 'Consumible', 'Proteínas', 243.50, 'Kg', 'Bolsa', 2.00, 1.00, 400.00, 'Disponible', 1),
(464, '154785', 'MUSLO DE POLLO', 'Consumible', 'Proteínas', 69.00, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible', 1),
(465, '154786', 'PECHUGA DE POLLO', 'Consumible', 'Proteínas', 230.40, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible', 1),
(466, '151042', 'BOLSA DE BASURA 200KG', 'No Consumible', 'Artículos de limpieza', 200.00, 'PCE', 'Paquete', 5.00, 20.00, 400.00, 'Disponible', 1),
(467, '143860', 'BOLSA DE 60KG', 'No Consumible', 'Artículos de limpieza', 1000.00, 'PCE', 'Paquete', 20.00, 15.00, 2000.00, 'Disponible', 1),
(468, '144019', 'CAPACILLOS', 'No Consumible', 'Desechables', 0.00, 'PCE', 'Paquete', 1000.00, 1.00, 1000.00, 'Agotado', 1),
(469, '154769', 'CUCHARA PLASTICA PARA POSTRE (20 PCE POR PAQUETE)', 'No Consumible', 'Artículos de limpieza', 200.00, 'Unid', 'Paquete', 100.00, 10.00, 400.00, 'Disponible', 1),
(470, '143849', 'CLORO', 'No Consumible', 'Artículos de limpieza', 6.00, 'Lts', 'Galón', 1.00, 5.00, 400.00, 'Disponible', 1),
(471, '143850', 'DESENGRASANTE BIODEGRADABLE', 'No Consumible', 'Artículos de limpieza', 3.00, 'Lts', 'Galón', 1.00, 1.00, 400.00, 'Disponible', 1),
(472, '150001', 'DESINFECTANTE ', 'No Consumible', 'Artículos de limpieza', 14.00, 'Ltr', 'Unidad', 1.00, 1.00, 400.00, 'Disponible', 1),
(473, '148150', 'DESTAPADOR DE POCETA', 'No Consumible', 'Artículos de limpieza', 3.00, 'Unid', 'Unidad', 1.00, 1.00, 400.00, 'Disponible', 1),
(474, '143848', 'ESPONJA DE BRILLO / JABONOSA', 'No Consumible', 'Artículos de limpieza', 12.00, 'PCE', 'Unidad', 1.00, 1.00, 400.00, 'Disponible', 1),
(475, '145357', 'ESPONJA DE ALAMBRE', 'No Consumible', 'Artículos de limpieza', 22.00, 'PCE', 'Unidad', 1.00, 1.00, 400.00, 'Disponible', 1),
(476, '145358', 'ESPONJA DOBLE USO', 'No Consumible', 'Artículos de limpieza', 18.00, 'PCE', 'Unidad', 1.00, 1.00, 400.00, 'Disponible', 1),
(477, '147270', 'GUANTE DE NITRILO TALLA L', 'No Consumible', 'Desechables', 150.00, 'PR', 'Caja', 100.00, 1.00, 400.00, 'Disponible', 1),
(478, '146590', 'GUANTE PLASTICO TALLA L', 'No Consumible', 'Desechables', 8.00, 'PR', 'Paquete', 1.00, 1.00, 400.00, 'Disponible', 1),
(479, '145978', 'GUANTES DESECHABLES DE SERVICIOS PLASTICOS (PAQUETE DE 100 PCE)', 'No Consumible', 'Desechables', 1000.00, 'Unid.', 'Caja', 100.00, 1.00, 400.00, 'Sobreabastecido', 1),
(480, '142769', 'GUANTES TERMICOS (PAR)', 'No Consumible', 'Cocina', 2.00, 'PCE', 'Paquete', 1.00, 1.00, 400.00, 'Disponible', 1),
(481, '144142', 'JABON DE BAÑO', 'No Consumible', 'Artículos de higiene', 139.00, 'PCE', 'Paquete', 1.00, 1.00, 400.00, 'Disponible', 1),
(482, '144125', 'JABON EN POLVO', 'No Consumible', 'Artículos de limpieza', 60.00, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible', 1),
(483, '144143', 'LAVAPLATO BIODEGRADABLE GALON', 'No Consumible', 'Artículos de limpieza', 10.00, 'Lts', 'Galón', 1.00, 1.00, 400.00, 'Disponible', 1),
(484, '143867', 'JABON LIQUIDO PARA MANOS', 'No Consumible', 'Artículos de higiene', 0.00, 'Lts', 'Galón', 1.00, 1.00, 400.00, 'Agotado', 1),
(485, '144145', 'LIMPIA HORNO CREMA', 'No Consumible', 'Artículos de limpieza', 3.00, 'PCE', 'Paquete', 1.00, 1.00, 400.00, 'Disponible', 1),
(486, '133443', 'MASCARILLAS QUIRÚRGICA DESECHABLE', 'No Consumible', 'Desechables', 200.00, 'Unid', 'Paquete', 50.00, 1.00, 400.00, 'Disponible', 1),
(487, '154771', 'MONDADIENTE (PAQ. DE 200 UNIDADES)', 'No Consumible', 'Desechables', 300.00, 'PK', 'Paquete', 100.00, 1.00, 400.00, 'Disponible', 1),
(488, '144463', 'PAPEL ALUMINIO', 'No Consumible', 'Cocina', 4.00, 'PCE', 'Paquete', 1.00, 1.00, 400.00, 'Disponible', 1),
(489, '144464', 'PAPEL ENVOPLAST INDUSTRIAL, 23 MICRAS X 500 MTS', 'No Consumible', 'Cocina', 2.00, 'PCE', 'Paquete', 1.00, 1.00, 400.00, 'Disponible', 1),
(490, '144012', 'PAPEL HIGIENICO', 'No Consumible', 'Artículos de higiene', 48.00, 'Unid', 'Paquete', 4.00, 1.00, 400.00, 'Disponible', 1),
(491, '144013', 'PITILLOS (PAQUETE DE 150 PCE)', 'No Consumible', 'Desechables', 4500.00, 'PK', 'Caja', 500.00, 1.00, 400.00, 'Sobreabastecido', 1),
(492, '141752', 'PORTA MOPA DE METAL', 'No Consumible', 'Artículos de limpieza', 2.00, 'PCE', 'Unidad', 1.00, 1.00, 400.00, 'Disponible', 1),
(493, '143853', 'AMBIENTADOR', 'No Consumible', 'Artículos de limpieza', 4.00, 'PCE', 'Unidad', 1.00, 1.00, 400.00, 'Disponible', 1),
(494, '144465', 'SERVILLETAS', 'No Consumible', 'Desechables', 20.00, 'PK', 'Paquete', 1.00, 1.00, 400.00, 'Disponible', 1),
(495, '144018', 'TOALLIN INDUSTRIAL', 'No Consumible', 'Artículos de limpieza', 28.00, 'Unid', 'Paquete', 1.00, 1.00, 400.00, 'Disponible', 1),
(496, '154933', 'VASOS V-4 , Z-47, V-47', 'No Consumible', 'Desechables', 2700.00, 'PK', 'Paquete', 100.00, 1.00, 400.00, 'Sobreabastecido', 1),
(497, '144011', 'VASOS  V-5', 'No Consumible', 'Desechables', 3600.00, 'Unid', 'Paquete', 100.00, 1.00, 400.00, 'Sobreabastecido', 1),
(498, '150454', 'VASOS V-10, TIPO V-107 ', 'No Consumible', 'Desechables', 3300.00, 'PK', 'Paquete', 50.00, 1.00, 400.00, 'Sobreabastecido', 1),
(499, NULL, 'BISTEC', 'Consumible', 'Proteínas', 54.60, 'Kg', 'Bolsa', 5.00, 15.00, 400.00, 'Disponible', 1),
(500, NULL, 'CARITE EN RUEDA', 'Consumible', 'Pescado', 0.00, 'Kg', 'Bolsa', 2.00, 1.00, 400.00, 'Agotado', 1),
(501, NULL, 'RONCO ENTERO', 'Consumible', 'Pescado', 0.00, 'Kg', 'Bolsa', 2.00, 1.00, 400.00, 'Agotado', 1),
(502, NULL, 'CORVINA EN RUEDA', 'Consumible', 'Pescado', 0.00, 'Kg', 'Bolsa', 2.00, 1.00, 400.00, 'Agotado', 1),
(503, NULL, 'ALBAHACA', 'Consumible', 'Víveres', 0.50, 'Kg', 'Bolsa', 1.00, 1.00, 400.00, 'Por Agotarse', 1),
(504, NULL, 'ALCAPARRAS', 'Consumible', 'Víveres', 0.00, 'Kg', 'Unidad', 1.00, 1.00, 400.00, 'Agotado', 1),
(505, NULL, 'CARBÓN', 'Consumible', 'Víveres', 10.00, 'Kg', 'Saco', 10.00, 1.00, 400.00, 'Disponible', 1),
(506, NULL, 'CHOCOLATE EN TABLA OSCURO CACAO 40%', 'Consumible', 'Víveres', 0.20, 'PCE', 'Paquete', 0.20, 1.00, 400.00, 'Por Agotarse', 1),
(507, NULL, 'PANELA', 'Consumible', 'Víveres', 4.05, 'PCE', 'Paquete', 0.45, 1.00, 400.00, 'Disponible', 1),
(508, NULL, 'PIMIENTA NEGRA MOLIDA', 'Consumible', 'Víveres', 1.00, 'Kg', 'Bolsa', 1.00, 1.00, 400.00, 'Por Agotarse', 1),
(509, NULL, 'ENVASE ANIME COMIDA', 'No Consumible', 'Cocina', 168.00, 'Unid', 'Saco', 200.00, 1.00, 600.00, 'Disponible', 1),
(510, NULL, 'MOPAS INDUSTRIALES', 'No Consumible', 'Limpieza', 4.00, 'Unid', 'Unidad', 1.00, 1.00, 40.00, 'Disponible', 1),
(511, NULL, 'PALA PARA BASURA', 'No Consumible', 'Limpieza', 2.00, 'Unid', 'Unidad', 1.00, 1.00, 20.00, 'Disponible', 1),
(512, NULL, 'PALILLOS PARA PINCHO', 'No Consumible', 'Cocina', 400.00, 'Unid', 'Paquete', 100.00, 1.00, 600.00, 'Disponible', 1),
(513, NULL, 'PALO PORTA MOPA', 'No Consumible', 'Limpieza', 2.00, 'Unid', 'Unidad', 1.00, 1.00, 20.00, 'Disponible', 1),
(514, NULL, 'PAÑITO REPASADOR', 'No Consumible', 'Limpieza', 3.00, 'Unid', 'Paquete', 3.00, 1.00, 50.00, 'Disponible', 1),
(515, NULL, 'PAÑO ABSORBENTE MICROFIBRA ', 'No Consumible', 'Limpieza', 252.00, 'Unid', 'Paquete', 12.00, 1.00, 40.00, 'Sobreabastecido', 1),
(516, NULL, 'PAPEL FILTRO PARA CAFÉ', 'No Consumible', 'Cocina', 600.00, 'Unid', 'Paquete', 50.00, 1.00, 50.00, 'Sobreabastecido', 1);

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
(10, 1, 'Cambio Estado Pedido', 'Pedido ID #3 actualizado a estado:Pendiente', '2026-10-20 12:54:13'),
(11, 1, 'DESPACHO_INSUMO', 'Despachó 8 Kg de \'Pimentón Rojo\' hacia RIG-42.', '2026-10-21 09:07:05'),
(12, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'Pimentón Rojo\' (#16).', '2026-10-21 09:07:48'),
(13, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'Aceite Vegetal 1L\' (#3).', '2026-10-22 09:10:30'),
(14, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'Cloro Concentrado\' (#19).', '2026-10-22 09:10:49'),
(15, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'Desengrasante Industrial\' (#20).', '2026-10-22 09:16:34'),
(16, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'Detergente Multiuso\' (#18).', '2026-10-22 09:16:52'),
(17, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'Papel Higiénico Institucional\' (#21).', '2026-10-22 09:17:16'),
(18, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'Servilletas de Mesa\' (#22).', '2026-10-22 09:17:43'),
(19, 1, 'REABASTECIMIENTO_INSUMO', 'Ingresó 18 PCE de \'Servilletas de Mesa\' desde FASTO.', '2026-10-22 09:19:11'),
(20, 1, 'DESPACHO_INSUMO', 'Despachó 30 PCE de \'Servilletas de Mesa\' hacia RIG-42.', '2026-10-22 09:20:00'),
(21, 1, 'REABASTECIMIENTO_INSUMO', 'Ingresó 30 PCE de \'Servilletas de Mesa\' desde MVT.', '2026-10-22 09:20:40'),
(22, 1, 'DESPACHO_INSUMO', 'Despachó 10 Kg de \'Arroz Blanco Superior\' hacia RIG-42.', '2026-10-22 09:37:03'),
(23, 1, 'CARGA_MASIVA', 'Procesó lote masivo \'plantilla_carga_masiva_erequest.csv\': 5 exitosos, 1 errores.', '2026-10-22 11:58:33'),
(24, 1, 'ELIMINACION_INSUMO', 'Eliminó el insumo \'Desengrasante Concentrado\' (#26) del inventario.', '2026-10-22 14:21:21'),
(25, 1, 'ELIMINACION_INSUMO', 'Eliminó el insumo \'Detergente Multiuso Industrial\' (#25) del inventario.', '2026-10-22 14:21:25'),
(26, 1, 'Cambio Estado Pedido', 'Pedido ID #3 actualizado a estado:Despachado', '2026-10-22 16:00:46'),
(27, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'Harina de Trigo Precoz\' (#24).', '2026-10-22 16:01:46'),
(28, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'Harina de Trigo Precoz\' (#24).', '2026-10-22 16:07:34'),
(29, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'Pimentón Rojo\' (#16).', '2026-10-22 16:08:07'),
(30, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'Aceite Vegetal 1L\' (#3).', '2026-10-22 16:13:56'),
(31, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'Aceite Vegetal 1L\' (#3).', '2026-10-22 16:19:05'),
(32, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'Aceite Vegetal 1L\' (#3).', '2026-10-23 10:56:09'),
(33, 1, 'CARGA_MASIVA', 'Procesó lote masivo \'plantilla_carga.csv\': 144 exitosos, 0 errores.', '2026-10-23 11:59:22'),
(34, 1, 'CARGA_MASIVA', 'Procesó lote masivo \'plantilla_carga_Nocomestibles - copia.csv\': 33 exitosos, 0 errores.', '2026-10-23 13:44:54'),
(35, 1, 'CARGA_MASIVA', 'Procesó lote masivo \'plantilla_carga_Nocomestibles - copia.csv\': 33 exitosos, 0 errores.', '2026-10-23 13:49:26'),
(36, 1, 'CARGA_MASIVA', 'Procesó lote masivo \'plantilla_carga_Nocomestibles - copia.csv\': 33 exitosos, 0 errores.', '2026-10-23 13:53:19'),
(37, 1, 'CARGA_MASIVA', 'Procesó lote masivo \'plantilla_carga_comestibles.csv\': 144 exitosos, 0 errores.', '2026-10-23 14:06:36'),
(38, 1, 'CARGA_MASIVA', 'Procesó lote masivo \'plantilla_carga_Nocomestibles - copia.csv\': 33 exitosos, 0 errores.', '2026-10-23 14:07:37'),
(39, 1, 'CARGA_MASIVA', 'Procesó lote masivo \'plantilla_carga_Nocomestibles - copia.csv\': 33 exitosos, 0 errores.', '2026-10-23 14:11:54'),
(40, 1, 'CARGA_MASIVA', 'Procesó lote masivo \'plantilla_carga_comestibles.csv\': 144 exitosos, 0 errores.', '2026-10-23 14:15:29'),
(41, 1, 'CARGA_MASIVA', 'Procesó lote masivo \'plantilla_carga_comestibles.csv\': 144 exitosos, 0 errores.', '2026-10-23 15:04:45'),
(42, 1, 'CARGA_MASIVA', 'Procesó lote masivo \'plantilla_carga_Nocomestibles - copia.csv\': 33 exitosos, 0 errores.', '2026-10-23 15:11:24'),
(43, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ACEITE DE PALMA\' (#322).', '2026-10-23 15:28:36'),
(44, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ACEITE DE PALMA\' (#322).', '2026-10-23 15:29:20'),
(45, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ACEITE DE PALMA\' (#322).', '2026-10-23 15:32:18'),
(46, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ACEITE VEGETAL\' (#323).', '2026-10-23 15:35:19'),
(47, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ACEITUNAS VERDES PRESENTACION 180 GRM\' (#324).', '2026-10-23 16:01:59'),
(48, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ACEITUNAS VERDES PRESENTACION 180 GRM\' (#324).', '2026-10-23 16:02:13'),
(49, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ACEITUNAS VERDES PRESENTACION 180 GRM\' (#324).', '2026-10-23 16:02:21'),
(50, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'AGUA MINERAL DE 600 ML C/U\' (#325).', '2026-10-23 16:05:12'),
(51, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'AGUACATE\' (#406).', '2026-10-23 16:10:24'),
(52, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'AGUACATE\' (#406).', '2026-10-23 16:10:34'),
(53, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'AGUACATE\' (#406).', '2026-10-23 16:10:41'),
(54, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'AGUACATE\' (#406).', '2026-10-23 16:11:35'),
(55, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'AJI DULCE\' (#407).', '2026-10-26 09:11:27'),
(56, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'AJI DULCE\' (#407).', '2026-10-26 09:12:10'),
(57, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'AJO PORRO\' (#408).', '2026-10-26 09:13:06'),
(58, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'AJO PORRO\' (#408).', '2026-10-26 09:13:13'),
(59, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'AJO SECO (CABEZA)\' (#409).', '2026-10-26 09:14:46'),
(60, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'AJO SECO (CABEZA)\' (#409).', '2026-10-26 09:15:28'),
(61, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ALIÑO ROJO EN POLVO\' (#327).', '2026-10-26 09:23:05'),
(62, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ALIÑO ROJO EN POLVO\' (#327).', '2026-10-26 09:23:53'),
(63, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ALIÑO ROJO EN POLVO\' (#327).', '2026-10-26 09:24:05'),
(64, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ALIÑO ROJO EN POLVO\' (#327).', '2026-10-26 09:24:20'),
(65, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ALIÑO ROJO EN POLVO\' (#327).', '2026-10-26 09:24:55'),
(66, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ALIÑO ROJO EN POLVO\' (#327).', '2026-10-26 09:25:22'),
(67, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ALIÑO ROJO EN POLVO\' (#327).', '2026-10-26 09:25:31'),
(68, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ALIÑO ROJO EN POLVO\' (#327).', '2026-10-26 09:26:07'),
(69, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ALIÑO ROJO EN POLVO\' (#327).', '2026-10-26 09:26:19'),
(70, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ALIÑO ROJO EN POLVO\' (#327).', '2026-10-26 09:26:29'),
(71, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ALIÑO ROJO EN POLVO\' (#327).', '2026-10-26 09:26:50'),
(72, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ALIÑO ROJO EN POLVO\' (#327).', '2026-10-26 09:27:09'),
(73, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ALIÑO ROJO EN POLVO\' (#327).', '2026-10-26 09:27:23'),
(74, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'APIO CRIOLLO\' (#410).', '2026-10-26 09:30:22'),
(75, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'APIO CRIOLLO\' (#410).', '2026-10-26 09:30:31'),
(76, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ALIÑO ROJO EN POLVO\' (#327).', '2026-10-26 09:30:53'),
(77, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'APIO ESPAÑA O CEDANO\' (#411).', '2026-10-26 09:32:31'),
(78, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ALIÑO ROJO EN POLVO\' (#327).', '2026-10-26 09:33:12'),
(79, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ALIÑO ROJO EN POLVO\' (#327).', '2026-10-26 09:33:59'),
(80, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ALIÑO ROJO EN POLVO\' (#327).', '2026-10-26 09:40:54'),
(81, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ALIÑO ROJO EN POLVO\' (#327).', '2026-10-26 09:41:04'),
(82, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ALIÑO ROJO EN POLVO\' (#327).', '2026-10-26 09:43:26'),
(83, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ALIÑO ROJO EN POLVO\' (#327).', '2026-10-26 09:43:53'),
(84, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ALIÑO ROJO EN POLVO\' (#327).', '2026-10-26 09:43:59'),
(85, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ALIÑO ROJO EN POLVO\' (#327).', '2026-10-26 09:44:08'),
(86, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ALIÑO ROJO EN POLVO\' (#327).', '2026-10-26 09:44:21'),
(87, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ARROZ BLANCO TIPO I\' (#328).', '2026-10-26 09:47:23'),
(88, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ARVEJAS VERDES SECAS\' (#331).', '2026-10-26 09:49:19'),
(89, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ARVEJAS VERDES SECAS\' (#331).', '2026-10-26 09:49:39'),
(90, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ARVEJAS VERDES SECAS\' (#331).', '2026-10-26 09:49:54'),
(91, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ATUN EN LATA , 170GR\' (#329).', '2026-10-26 09:52:41'),
(92, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'AUYAMA\' (#412).', '2026-10-26 09:59:02'),
(93, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'AUYAMA\' (#412).', '2026-10-26 09:59:47'),
(94, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'AUYAMA\' (#412).', '2026-10-26 10:00:13'),
(95, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'AUYAMA\' (#412).', '2026-10-26 10:00:22'),
(96, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'AUYAMA\' (#412).', '2026-10-26 10:00:40'),
(97, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'AGUACATE\' (#406).', '2026-10-26 10:00:56'),
(98, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'AJO PORRO\' (#408).', '2026-10-26 10:01:10'),
(99, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'AVENA EN HOJUELAS, PRESENTACIÓN: PAQ. DE 800 GR\' (#330).', '2026-10-26 10:02:58'),
(100, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'BICARBONATO DE SODIO, PRESENTACIÓN: PAQUETE DE 30 GR\' (#332).', '2026-10-26 10:04:43'),
(101, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'AZUCAR BLANCA GRANULADA\' (#333).', '2026-10-26 10:47:27'),
(102, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'AZUCAR BLANCA GRANULADA\' (#333).', '2026-10-26 10:47:38'),
(103, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'BICARBONATO DE SODIO, PRESENTACIÓN: PAQUETE DE 30 GR\' (#332).', '2026-10-26 10:48:16'),
(104, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'BICARBONATO DE SODIO, PRESENTACIÓN: PAQUETE DE 30 GR\' (#332).', '2026-10-26 10:48:29'),
(105, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'BICARBONATO DE SODIO, PRESENTACIÓN: PAQUETE DE 30 GR\' (#332).', '2026-10-26 10:49:07'),
(106, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'BOLOÑA ENTERA CARNE\' (#437).', '2026-10-26 11:17:22'),
(107, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'BICARBONATO DE SODIO, PRESENTACIÓN: PAQUETE DE 30 GR\' (#332).', '2026-10-26 11:17:51'),
(108, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'BICARBONATO DE SODIO, PRESENTACIÓN: PAQUETE DE 30 GR\' (#332).', '2026-10-26 11:18:06'),
(109, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'BICARBONATO DE SODIO, PRESENTACIÓN: PAQUETE DE 30 GR\' (#332).', '2026-10-26 11:18:13'),
(110, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'BROCOLI LIMPIO\' (#413).', '2026-10-26 11:19:42'),
(111, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CAFE MOLIDO, PRESENTACIÓN: PAQ. DE 500 GR\' (#334).', '2026-10-26 11:22:36'),
(112, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CALABACIN\' (#414).', '2026-10-26 11:23:44'),
(113, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CAMBUR\' (#392).', '2026-10-26 11:29:45'),
(114, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CAMBUR\' (#392).', '2026-10-26 11:30:08'),
(115, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CAMBUR\' (#392).', '2026-10-26 11:30:17'),
(116, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'Canela en Polvo\' (#336).', '2026-10-26 11:31:52'),
(117, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'Canela en Polvo\' (#336).', '2026-10-26 11:32:05'),
(118, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CANELA EN RAMA\' (#335).', '2026-10-26 11:32:19'),
(119, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CANELA EN RAMA\' (#335).', '2026-10-26 11:32:30'),
(120, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CANELA EN RAMA\' (#335).', '2026-10-26 11:33:02'),
(121, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CANELA EN RAMA\' (#335).', '2026-10-26 11:33:17'),
(122, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CAMBUR\' (#392).', '2026-10-26 11:33:47'),
(123, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CARAOTAS NEGRAS SECAS\' (#337).', '2026-10-26 11:34:19'),
(124, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CARAOTAS NEGRAS SECAS\' (#337).', '2026-10-26 11:34:29'),
(125, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CARAOTAS ROJAS SECAS\' (#338).', '2026-10-26 11:34:52'),
(126, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CARNE MOLIDA DE RES, PRESENTACIÓN: PAQUETE DE 1 KG\' (#449).', '2026-10-26 11:40:49'),
(127, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CARNE PARA MECHAR\' (#448).', '2026-10-26 11:41:20'),
(128, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CARNE MOLIDA DE RES, PRESENTACIÓN: PAQUETE DE 1 KG\' (#449).', '2026-10-26 11:41:41'),
(129, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CARNE PARA MECHAR\' (#448).', '2026-10-26 11:42:29'),
(130, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CARNE MOLIDA DE RES, PRESENTACIÓN: PAQUETE DE 1 KG\' (#449).', '2026-10-26 11:42:53'),
(131, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CHIVO\' (#450).', '2026-10-26 11:43:32'),
(132, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CHULETA AHUMADA, PRESENTACIÓN: PAQUETE DE 5 KG\' (#459).', '2026-10-26 11:44:32'),
(133, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CHULETA DE PUERCO\' (#458).', '2026-10-26 11:45:38'),
(134, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CHULETA DE PUERCO\' (#458).', '2026-10-26 11:45:55'),
(135, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CHULETA DE RES\' (#455).', '2026-10-26 11:46:28'),
(136, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CORVINA ENTERA\' (#461).', '2026-10-26 11:47:10'),
(137, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'COSTILLAS DE RES\' (#453).', '2026-10-26 11:47:53'),
(138, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'GANSO O ENTRECANTO DE RES\' (#451).', '2026-10-26 12:52:39'),
(139, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'HIGADO DE RES\' (#454).', '2026-10-26 12:53:14'),
(140, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'HIGADO DE RES\' (#454).', '2026-10-26 12:53:47'),
(141, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'HIGADO DE RES\' (#454).', '2026-10-26 12:54:20'),
(142, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'HIGADO DE RES\' (#454).', '2026-10-26 12:54:49'),
(143, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'HIGADO DE RES\' (#454).', '2026-10-26 12:59:14'),
(144, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'HIGADO DE RES\' (#454).', '2026-10-26 13:00:09'),
(145, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'HIGADO DE RES\' (#454).', '2026-10-26 13:03:36'),
(146, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'MOJITO DE PESCADO\' (#462).', '2026-10-26 13:04:33'),
(147, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'MUCHACHO CUADRADO/REDONDO DE RES\' (#457).', '2026-10-26 13:20:49'),
(148, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'MUSLO DE POLLO\' (#464).', '2026-10-26 13:22:52'),
(149, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'PECHUGA DE POLLO\' (#465).', '2026-10-26 13:23:55'),
(150, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'PECHUGA DE POLLO\' (#465).', '2026-10-26 13:24:22'),
(151, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'PERNIL ENTERO\' (#460).', '2026-10-26 13:25:16'),
(152, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'POLLO ENTERO EMPACADO\' (#463).', '2026-10-26 13:29:36'),
(153, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'PULPA NEGRA DE RES\' (#452).', '2026-10-26 13:30:21'),
(154, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'RABO DE RES\' (#456).', '2026-10-26 13:31:31'),
(155, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'PULPAS DE FRUTAS SURTIDAS CON AZUCAR (PAQ. DE 1 KG)\' (#435).', '2026-10-26 13:32:44'),
(156, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'PULPAS DE FRUTAS SURTIDAS CON AZUCAR (PAQ. DE 1 KG)\' (#435).', '2026-10-26 13:33:05'),
(157, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'BOLOÑA ENTERA CARNE\' (#437).', '2026-10-26 13:36:28'),
(158, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CHORIZO PARRILLERO\' (#440).', '2026-10-26 13:37:06'),
(159, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CREMA DE LECHE (REFRIGERADA), PRESENTACIÓN: ENVASE DE 450 A 500 GR\' (#443).', '2026-10-26 13:47:10'),
(160, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'HUEVO DE GALLINA\' (#436).', '2026-10-26 13:49:03'),
(161, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'JAMON DE PIERNA ENTERO\' (#438).', '2026-10-26 13:50:55'),
(162, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'MORTADELA ENTERA DE CARNE\' (#439).', '2026-10-26 13:54:03'),
(163, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'MORTADELA ENTERA DE CARNE\' (#439).', '2026-10-26 13:55:25'),
(164, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'QUESO AMARILLO ENTERO\' (#444).', '2026-10-26 14:00:58'),
(165, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'QUESO AMARILLO ENTERO\' (#444).', '2026-10-26 14:00:58'),
(166, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'QUESO MADURADO ENTERO\' (#445).', '2026-10-26 14:46:14'),
(167, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'QUESO MOZARELLA ENTERO\' (#446).', '2026-10-26 14:50:40'),
(168, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'QUESO PASTEURIZADO ENTERO\' (#447).', '2026-10-26 14:51:56'),
(169, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'QUESO PASTEURIZADO ENTERO\' (#447).', '2026-10-26 14:52:22'),
(170, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'SALCHICHA TIPO WIENERS\' (#441).', '2026-10-26 14:53:33'),
(171, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'SALCHICHA TIPO WIENERS\' (#441).', '2026-10-26 14:57:23'),
(172, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'MORTADELA ENTERA DE CARNE\' (#439).', '2026-10-26 14:59:19'),
(173, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'TOCINETA AHUMADA ENTERA\' (#442).', '2026-10-26 15:02:51'),
(174, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'SALCHICHA TIPO WIENERS\' (#441).', '2026-10-26 15:11:59'),
(175, 1, 'GESTION_MENU', 'Actualizó la minuta del menú semanal N° 44 (2026-10-26 al 2026-11-01).', '2026-10-26 15:25:56'),
(176, 1, 'GESTION_MENU', 'Actualizó la minuta del menú semanal N° 44 (2026-10-26 al 2026-11-01).', '2026-10-26 15:37:12'),
(177, 1, 'GESTION_MENU', 'Actualizó la minuta del menú semanal N° 44 (2026-10-26 al 2026-11-01).', '2026-10-26 15:41:46'),
(178, 1, 'GESTION_MENU', 'Actualizó la minuta del menú semanal N° 44 (2026-10-26 al 2026-11-01).', '2026-10-26 15:43:38'),
(179, 1, 'GESTION_MENU', 'Actualizó la minuta del menú semanal N° 44 (2026-10-26 al 2026-11-01).', '2026-10-26 15:46:48'),
(180, 1, 'GESTION_MENU', 'Actualizó la minuta del menú semanal N° 44 (2026-10-26 al 2026-11-01).', '2026-10-26 16:37:20'),
(181, 1, 'GESTION_MENU', 'Actualizó la minuta del menú semanal N° 44 (2026-10-26 al 2026-11-01).', '2026-10-27 08:50:35'),
(182, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ACEITE DE PALMA\' (#322).', '2026-10-27 16:12:38'),
(183, 1, 'CONSUMO_INSUMO', 'Registró consumo de 10 Ltr de \'ACEITE VEGETAL\' en Gabarra RIG-42.', '2026-10-27 16:17:02'),
(184, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4 Ltr de \'ACEITE VEGETAL\' en Gabarra RIG-42.', '2026-10-29 14:33:24'),
(185, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.5 Kg de \'AJO PORRO\' en Gabarra RIG-42.', '2026-10-29 14:34:06'),
(186, 1, 'CONSUMO_INSUMO', 'Registró consumo de 6 PCE de \'AVENA EN HOJUELAS, PRESENTACIÓN: PAQ. DE 800 GR\' en Gabarra RIG-42.', '2026-10-29 14:34:38'),
(187, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'AJO PORRO\' en Gabarra RIG-42.', '2026-10-29 14:35:09'),
(188, 1, 'CONSUMO_INSUMO', 'Registró consumo de 15 Kg de \'CARNE PARA MECHAR\' en Gabarra RIG-42.', '2026-10-29 14:36:37'),
(189, 1, 'REGISTRO_MERMA', 'Registró merma de \'AGUACATE\': 1 unid / 900 gr. Motivo: Deterioro', '2026-10-30 15:41:05'),
(190, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'MAICENA / MAIZINA / ALMIDON DE MAIZ, PRESENTACIÓN\' (#355).', '2026-11-03 22:54:33'),
(191, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'MANTECA VEGETAL 500GR\' (#357).', '2026-11-03 22:55:17'),
(192, 1, 'ELIMINACION_INSUMO', 'Eliminó el insumo \'MAIZ DULCE EN GRANO, PRESENTACIÓN: LATA DE 300 GR\' (#356) del inventario.', '2026-11-03 22:56:12'),
(193, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'MARGARINA / MANTEQUILLA, PRESENTACIÓN: ENVASE DE 500 GRM\' (#358).', '2026-11-03 23:03:38'),
(194, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'MARGARINA / MANTEQUILLA, PRESENTACIÓN: ENVASE DE 500 GRM\' (#358).', '2026-11-03 23:04:06'),
(195, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'MAYONESA PREPARADA\' (#359).', '2026-11-03 23:05:39'),
(196, 1, 'ELIMINACION_INSUMO', 'Eliminó el insumo \'MERMELADA SABORES DE FRUTAS SURTIDA 230GR – 400GR\' (#360) del inventario.', '2026-11-03 23:06:22'),
(197, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'MOSTAZA PREPARADA, ENVASE DE 260 A 500 GR\' (#361).', '2026-11-03 23:11:43'),
(198, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'OREGANO SECO EN HOJAS\' (#362).', '2026-11-03 23:12:50'),
(199, 1, 'CREACION_INSUMO', 'Creó el insumo \'PANELA\' (#507) con stock inicial de 4.05 PCE.', '2026-11-03 23:16:27'),
(200, 1, 'ELIMINACION_INSUMO', 'Eliminó el insumo \'PAPELON, PRESENTACIÓN: PANELA DE 500 GR\' (#363) del inventario.', '2026-11-03 23:17:04'),
(201, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'PAPAS FRITAS PRECOCIDAS, PRESENTACIÓN: PAQ. DE 140 GR A 300GR\' (#371).', '2026-11-03 23:18:09'),
(202, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'PASTA CORTA\' (#365).', '2026-11-03 23:19:09'),
(203, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'PASTA CORTA\' (#365).', '2026-11-03 23:19:40'),
(204, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'PASTA DE TOMATE \' (#364).', '2026-11-03 23:20:45'),
(205, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'PASTA LARGA\' (#366).', '2026-11-03 23:21:31'),
(206, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'PASTA PARA PASTICHO, PRESENTACIÓN: BT. DE 12 CAJAS DE 250 GR C/U\' (#367).', '2026-11-03 23:22:48'),
(207, 1, 'CREACION_INSUMO', 'Creó el insumo \'PIMIENTA NEGRA MOLIDA\' (#508) con stock inicial de 0.98 Kg.', '2026-11-03 23:25:00'),
(208, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'PIMIENTA NEGRA MOLIDA\' (#508).', '2026-11-03 23:26:23'),
(209, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'POLVO DE HORNEAR, PRESENTACIÓN: ENVASE DE 200 GR\' (#368).', '2026-11-03 23:28:01'),
(210, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'PIMIENTA NEGRA MOLIDA\' (#508).', '2026-11-03 23:28:20'),
(211, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'REFRESCO 2LTR\' (#372).', '2026-11-03 23:29:44'),
(212, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'REFRESCO 2LTR\' (#372).', '2026-11-03 23:30:08'),
(213, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'REFRESCO 2LTR\' (#372).', '2026-11-03 23:32:08'),
(214, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'REFRESCO DE LATA 355ML (PAQ. 24 UNIDADES)\' (#373).', '2026-11-03 23:36:21'),
(215, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'SAL REFINADA\' (#374).', '2026-11-03 23:37:21'),
(216, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'SALSA 57 O 79, PRESENTACIÓN: FRASCO DE 375 ML\' (#375).', '2026-11-03 23:38:42'),
(217, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'SALSA 57 O 79, PRESENTACIÓN: FRASCO DE 375 ML\' (#375).', '2026-11-03 23:39:21'),
(218, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'SALSA DE AJO\' (#376).', '2026-11-03 23:40:18'),
(219, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'SALSA DE AJO\' (#376).', '2026-11-03 23:40:31'),
(220, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'SALSA DE SOYA\' (#377).', '2026-11-03 23:41:13'),
(221, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'SALSA DE TOMATE, PRESENTACIÓN: ENVASE DE 4.2 KG\' (#378).', '2026-11-03 23:42:29'),
(222, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'SALSA DE TOMATE, PRESENTACIÓN: ENVASE DE 4.2 KG\' (#378).', '2026-11-03 23:44:08'),
(223, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'SALSA  INGLESA\' (#379).', '2026-11-03 23:45:08'),
(224, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'SARDINAS EN ACEITE / AL NATURAL, PRESENTACIÓN: LATA DE 170 GR\' (#380).', '2026-11-03 23:46:22'),
(225, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'SARDINAS EN ACEITE / AL NATURAL, PRESENTACIÓN: LATA DE 170 GR\' (#380).', '2026-11-03 23:46:35'),
(226, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'SAZONATODO (PRESENTACION: FRASCO DE 200 GR a 300GR)\' (#381).', '2026-11-03 23:47:28'),
(227, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'TE DE MANZANILLA SOBRE\' (#384).', '2026-11-03 23:48:18'),
(228, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'TE FRUTOS ROJOS\' (#386).', '2026-11-03 23:48:40'),
(229, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'TE FRUTOS ROJOS\' (#386).', '2026-11-03 23:48:57'),
(230, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'TE FRUTOS ROJOS\' (#386).', '2026-11-03 23:49:14'),
(231, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'TÉ VERDE SOBRE\' (#385).', '2026-11-03 23:49:42'),
(232, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'TÉ VERDE SOBRE\' (#385).', '2026-11-03 23:50:04'),
(233, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'TÉ VERDE SOBRE\' (#385).', '2026-11-03 23:50:25'),
(234, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'TODDY (BEBIDA ACHOCOLATADA), PRESENTACIÓN: PAQ. DE 400 GRM\' (#326).', '2026-11-03 23:50:54'),
(235, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'TOMILLO SECO EN HOJAS\' (#387).', '2026-11-03 23:53:58'),
(236, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'UVAS PASAS\' (#370).', '2026-11-03 23:54:29'),
(237, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'VAINILLA (LIQUIDA)\' (#382).', '2026-11-03 23:54:55'),
(238, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'VINAGRE BLANCO 1LT\' (#383).', '2026-11-03 23:55:42'),
(239, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'PAN DE SANDWICH BLANCO GRANDE\' (#388).', '2026-11-03 23:56:39'),
(240, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'PAN DE HAMBURGUESA\' (#390).', '2026-11-03 23:57:43'),
(241, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'PAN RALLADO\' (#391).', '2026-11-03 23:58:27'),
(242, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'PAN DE PERRO CALIENTE\' (#389).', '2026-11-03 23:59:03'),
(243, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'GUANTES DESECHABLES DE SERVICIOS PLASTICOS (PAQUETE DE 100 PCE)\' (#479).', '2026-11-04 00:00:51'),
(244, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'GUANTES TERMICOS (PAR)\' (#480).', '2026-11-04 00:02:56'),
(245, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'AMBIENTADOR\' (#493).', '2026-11-04 09:17:52'),
(246, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'BOLSA DE 60 LT (PAQUETE DE 25 PCE)\' (#467).', '2026-11-04 09:18:42'),
(247, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'BOLSA DE BASURA 200 LT (PAQUETE DE 25 PCE)\' (#466).', '2026-11-04 09:19:23'),
(248, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'BOLSA DE 60KG\' (#467).', '2026-11-04 09:19:39'),
(249, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'BOLSA DE BASURA 200KG\' (#466).', '2026-11-04 09:19:50'),
(250, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CAPACILLOS\' (#468).', '2026-11-04 09:22:19'),
(251, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CLORO\' (#470).', '2026-11-04 09:23:19'),
(252, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'BOLSA DE 60KG\' (#467).', '2026-11-04 09:24:34'),
(253, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'BOLSA DE 60KG\' (#467).', '2026-11-04 09:24:56'),
(254, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'BOLSA DE 60KG\' (#467).', '2026-11-04 09:25:21'),
(255, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'BOLSA DE BASURA 200KG\' (#466).', '2026-11-04 09:25:37'),
(256, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CUCHARA PLASTICA PARA POSTRE (20 PCE POR PAQUETE)\' (#469).', '2026-11-04 09:26:37'),
(257, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'DESENGRASANTE BIODEGRADABLE\' (#471).', '2026-11-04 09:27:15'),
(258, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'DESINFECTANTE \' (#472).', '2026-11-04 09:28:08'),
(259, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'DESENGRASANTE BIODEGRADABLE\' (#471).', '2026-11-04 09:29:23'),
(260, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'DESTAPADOR DE POCETA\' (#473).', '2026-11-04 09:30:13'),
(261, 1, 'CREACION_INSUMO', 'Creó el insumo \'ENVASE ANIME COMIDA\' (#509) con stock inicial de 33600 Unid.', '2026-11-04 09:37:20'),
(262, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ENVASE ANIME COMIDA\' (#509).', '2026-11-04 09:38:42'),
(263, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ESPONJA DE ALAMBRE\' (#475).', '2026-11-04 09:46:01'),
(264, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ESPONJA DE BRILLO / JABONOSA\' (#474).', '2026-11-04 09:46:34'),
(265, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'ESPONJA DOBLE USO\' (#476).', '2026-11-04 09:52:28'),
(266, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'GUANTE DE NITRILO TALLA L\' (#477).', '2026-11-04 09:56:17'),
(267, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'GUANTE PLASTICO TALLA L\' (#478).', '2026-11-04 09:57:15'),
(268, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'JABON DE BAÑO\' (#481).', '2026-11-04 09:59:23'),
(269, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'JABON EN POLVO (PRESENTACION 5 KGM)\' (#482).', '2026-11-04 10:00:21'),
(270, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'JABON EN POLVO (PRESENTACION 5 KGM)\' (#482).', '2026-11-04 10:00:46'),
(271, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'JABON EN POLVO\' (#482).', '2026-11-04 10:00:59'),
(272, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'JABON LIQUIDO PARA MANOS\' (#484).', '2026-11-04 10:01:52'),
(273, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'LAVAPLATO BIODEGRADABLE GALON\' (#483).', '2026-11-04 10:02:32'),
(274, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'LIMPIA HORNO CREMA\' (#485).', '2026-11-04 10:03:16'),
(275, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'MASCARILLAS QUIRÚRGICA DESECHABLE\' (#486).', '2026-11-04 10:04:34'),
(276, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'MASCARILLAS QUIRÚRGICA DESECHABLE\' (#486).', '2026-11-04 10:04:43'),
(277, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'MONDADIENTE (PAQ. DE 200 UNIDADES)\' (#487).', '2026-11-04 10:07:02'),
(278, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'PAPEL ENVOPLAST INDUSTRIAL, 23 MICRAS X 500 MTS\' (#489).', '2026-11-04 10:22:49'),
(279, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'PAPEL ALUMINIO\' (#488).', '2026-11-04 10:23:14'),
(280, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'PAPEL ENVOPLAST INDUSTRIAL, 23 MICRAS X 500 MTS\' (#489).', '2026-11-04 10:23:51'),
(281, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'PAPEL HIGIENICO\' (#490).', '2026-11-04 10:25:31'),
(282, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'PAPEL HIGIENICO\' (#490).', '2026-11-04 10:26:33'),
(283, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'PITILLOS (PAQUETE DE 150 PCE)\' (#491).', '2026-11-04 10:27:15'),
(284, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'PORTA MOPA DE METAL\' (#492).', '2026-11-04 10:27:57'),
(285, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'SERVILLETAS\' (#494).', '2026-11-04 10:29:48'),
(286, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'TOALLIN INDUSTRIAL\' (#495).', '2026-11-04 10:34:13'),
(287, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'VASOS  V-5\' (#497).', '2026-11-04 10:35:12'),
(288, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'VASOS  V-5\' (#497).', '2026-11-04 10:35:22'),
(289, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'VASOS V–4 , Z–47, V-47\' (#496).', '2026-11-04 10:35:58'),
(290, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'VASOS V-4 , Z-47, V-47\' (#496).', '2026-11-04 10:36:42'),
(291, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'VASOS V-10, TIPO V-107 \' (#498).', '2026-11-04 10:37:24'),
(292, 1, 'CREACION_INSUMO', 'Creó el insumo \'MOPAS INDUSTRIALES\' (#510) con stock inicial de 4 Unid.', '2026-11-04 10:40:28'),
(293, 1, 'CREACION_INSUMO', 'Creó el insumo \'PALA PARA BASURA\' (#511) con stock inicial de 2 Unid.', '2026-11-04 10:41:50'),
(294, 1, 'CREACION_INSUMO', 'Creó el insumo \'PALILLOS PARA PINCHO\' (#512) con stock inicial de 400 Unid.', '2026-11-04 10:43:01'),
(295, 1, 'CREACION_INSUMO', 'Creó el insumo \'PALO PORTA MOPA\' (#513) con stock inicial de 2 Unid.', '2026-11-04 10:44:42'),
(296, 1, 'CREACION_INSUMO', 'Creó el insumo \'PAÑITO REPASADOR\' (#514) con stock inicial de 3 Unid.', '2026-11-04 10:55:55'),
(297, 1, 'CREACION_INSUMO', 'Creó el insumo \'PAÑO ABSORBENTE MICROFIBRA \' (#515) con stock inicial de 252 Unid.', '2026-11-04 10:57:50'),
(298, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'PAÑO ABSORBENTE MICROFIBRA \' (#515).', '2026-11-04 10:59:25'),
(299, 1, 'CREACION_INSUMO', 'Creó el insumo \'PAPEL FILTRO PARA CAFÉ\' (#516) con stock inicial de 12 Unid.', '2026-11-04 11:01:08'),
(300, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'PAPEL FILTRO PARA CAFÉ\' (#516).', '2026-11-04 11:01:19'),
(301, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'BISTEC\' en Gabarra RIG-42.', '2026-11-04 14:21:49'),
(302, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'CARNE MOLIDA (PULPON)\' (#449).', '2026-11-04 14:23:06'),
(303, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'CARNE MOLIDA (PULPON)\' en Gabarra RIG-42.', '2026-11-04 14:23:29'),
(304, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'COSTILLAS DE RES\' en Gabarra RIG-42.', '2026-11-04 14:23:40'),
(305, 1, 'CONSUMO_INSUMO', 'Registró consumo de 10 Kg de \'MUSLO DE POLLO\' en Gabarra RIG-42.', '2026-11-04 14:24:30'),
(306, 1, 'CONSUMO_INSUMO', 'Registró consumo de 20 Kg de \'PECHUGA DE POLLO\' en Gabarra RIG-42.', '2026-11-04 14:24:49'),
(307, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4 PCE de \'HUEVOS DE GALLINA\' en Gabarra RIG-42.', '2026-11-04 14:25:03'),
(308, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4 Kg de \'JAMON DE PIERNA ENTERO\' en Gabarra RIG-42.', '2026-11-04 14:25:37'),
(309, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.5 Kg de \'TOCINETA AHUMADA ENTERA\' en Gabarra RIG-42.', '2026-11-04 14:25:52'),
(310, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 Kg de \'QUESO MADURADO ENTERO\' en Gabarra RIG-42.', '2026-11-04 14:26:18'),
(311, 1, 'CONSUMO_INSUMO', 'Registró consumo de 3 Kg de \'QUESO MOZARELLA ENTERO\' en Gabarra RIG-42.', '2026-11-04 14:26:33'),
(312, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'QUESO AMARILLO ENTERO\' en Gabarra RIG-42.', '2026-11-04 14:26:44'),
(313, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4 Kg de \'LIMON\' en Gabarra RIG-42.', '2026-11-04 14:27:30'),
(314, 1, 'CONSUMO_INSUMO', 'Registró consumo de 3 Kg de \'MANZANA\' en Gabarra RIG-42.', '2026-11-04 14:27:51'),
(315, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'MANDARINA\' en Gabarra RIG-42.', '2026-11-04 14:28:04'),
(316, 1, 'CONSUMO_INSUMO', 'Registró consumo de 10 Kg de \'MELON\' en Gabarra RIG-42.', '2026-11-04 14:28:23'),
(317, 1, 'CONSUMO_INSUMO', 'Registró consumo de 6 Kg de \'PARCHITA\' en Gabarra RIG-42.', '2026-11-04 14:28:38'),
(318, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4 Kg de \'PIÑA\' en Gabarra RIG-42.', '2026-11-04 14:28:51'),
(319, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1.8 Kg de \'AGUACATE\' en Gabarra RIG-42.', '2026-11-04 14:29:40'),
(320, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.21 Kg de \'AJI DULCE\' en Gabarra RIG-42.', '2026-11-04 14:30:05'),
(321, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.2 Kg de \'AJO PORRO\' en Gabarra RIG-42.', '2026-11-04 14:30:28'),
(322, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.3 Kg de \'AJO SECO (CABEZA)\' en Gabarra RIG-42.', '2026-11-04 14:53:46'),
(323, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.7 Kg de \'APIO CRIOLLO\' en Gabarra RIG-42.', '2026-11-04 14:54:09'),
(324, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1.6 Kg de \'AUYAMA\' en Gabarra RIG-42.', '2026-11-04 14:54:25'),
(325, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'CEBOLLA BLANCA\' en Gabarra RIG-42.', '2026-11-04 14:55:51'),
(326, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'CEBOLLIN\' en Gabarra RIG-42.', '2026-11-04 14:56:14'),
(327, 1, 'CONSUMO_INSUMO', 'Registró consumo de 0.5 Kg de \'CILANTRO\' en Gabarra RIG-42.', '2026-11-04 14:56:34'),
(328, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1.2 Kg de \'JOJOTO\' en Gabarra RIG-42.', '2026-11-04 14:56:55'),
(329, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2.5 Kg de \'LECHUGA LIMPIA\' en Gabarra RIG-42.', '2026-11-04 14:57:09'),
(330, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'ÑAME\' en Gabarra RIG-42.', '2026-11-04 14:57:22'),
(331, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'OCUMO\' en Gabarra RIG-42.', '2026-11-04 14:57:31'),
(332, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4 Kg de \'PAPA\' en Gabarra RIG-42.', '2026-11-04 14:57:42'),
(333, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1.5 Kg de \'PIMENTON\' en Gabarra RIG-42.', '2026-11-04 14:58:01'),
(334, 1, 'CONSUMO_INSUMO', 'Registró consumo de 15 Kg de \'PLATANO\' en Gabarra RIG-42.', '2026-11-04 14:58:12'),
(335, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'REPOLLO BLANCO\' en Gabarra RIG-42.', '2026-11-04 14:58:30'),
(336, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Kg de \'REPOLLO MORADO\' en Gabarra RIG-42.', '2026-11-04 14:58:49'),
(337, 1, 'CONSUMO_INSUMO', 'Registró consumo de 5 Kg de \'TOMATE\' en Gabarra RIG-42.', '2026-11-04 14:58:58'),
(338, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2.04 Kg de \'YUCA\' en Gabarra RIG-42.', '2026-11-04 14:59:13'),
(339, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2.5 Kg de \'ZANAHORIA\' en Gabarra RIG-42.', '2026-11-04 14:59:25'),
(340, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 Ltr de \'ACEITE VEGETAL LITRO\' en Gabarra RIG-42.', '2026-11-04 14:59:42'),
(341, 1, 'CONSUMO_INSUMO', 'Registró consumo de 7 Kg de \'ARROZ BLANCO TIPO I\' en Gabarra RIG-42.', '2026-11-04 14:59:54'),
(342, 1, 'CONSUMO_INSUMO', 'Registró consumo de 6 Kg de \'AZUCAR BLANCA GRANULADA\' en Gabarra RIG-42.', '2026-11-04 15:00:12'),
(343, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 PCE de \'CAFE MOLIDO, PRESENTACIÓN: PAQ. DE 500 GR\' en Gabarra RIG-42.', '2026-11-04 15:00:25'),
(344, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 PCE de \'GUISANTES VERDES AL NATURAL, PRESENTACIÓN: LATA DE 425 GR\' en Gabarra RIG-42.', '2026-11-04 15:00:38'),
(345, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4 Kg de \'HARINA DE MAIZ PRECOCIDA\' en Gabarra RIG-42.', '2026-11-04 15:01:00'),
(346, 1, 'CONSUMO_INSUMO', 'Registró consumo de 4 Kg de \'HARINA DE TRIGO LEUDANTE / TODO USO\' en Gabarra RIG-42.', '2026-11-04 15:01:15'),
(347, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 Kg de \'LECHE EN POLVO, PRESENTACIÓN: 1 KG\' en Gabarra RIG-42.', '2026-11-04 15:01:29'),
(348, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Lts de \'MAYONESA PREPARADA\' en Gabarra RIG-42.', '2026-11-04 16:18:05'),
(349, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 PCE de \'MOSTAZA PREPARADA, ENVASE DE 260 A 500 GR\' en Gabarra RIG-42.', '2026-11-04 16:18:23'),
(350, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'REFRESCO 2LTR\' (#372).', '2026-11-04 16:19:14'),
(351, 1, 'CONSUMO_INSUMO', 'Registró consumo de 6 Unid de \'REFRESCO 2LTR\' en Gabarra RIG-42.', '2026-11-04 16:20:47'),
(352, 1, 'CONSUMO_INSUMO', 'Registró consumo de 2 Kg de \'SAL REFINADA\' en Gabarra RIG-42.', '2026-11-04 16:21:06'),
(353, 1, 'CONSUMO_INSUMO', 'Registró consumo de 1 Lts de \'VINAGRE BLANCO 1LT\' en Gabarra RIG-42.', '2026-11-04 16:21:21'),
(354, 1, 'CONSUMO_INSUMO', 'Registró consumo de 16 Unid. de \'PAN DE SANDWICH BLANCO GRANDE\' en Gabarra RIG-42.', '2026-11-04 16:24:06');

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
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=355;

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
  MODIFY `id_salida` int(11) NOT NULL AUTO_INCREMENT;

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
