-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 23-10-2026 a las 22:14:50
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
  `estado` varchar(50) NOT NULL DEFAULT 'Disponible'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `inventario`
--

INSERT INTO `inventario` (`id_producto`, `codigo_sku`, `nombre_insumo`, `tipo_rubro`, `categoria`, `cantidad`, `unidad_medida`, `unidad_empaque`, `contenido_por_empaque`, `stock_minimo`, `stock_maximo`, `estado`) VALUES
(322, '147296', 'ACEITE DE PALMA', 'Consumible', 'Víveres', 50.00, 'Ltr', 'Cuñete', 18.00, 20.00, 400.00, 'Disponible'),
(323, '144106', 'ACEITE VEGETAL', 'Consumible', 'Víveres', 24.00, 'Ltr', 'Caja', 12.00, 15.00, 400.00, 'Disponible'),
(324, '150169', 'ACEITUNAS VERDES PRESENTACION 180 GRM', 'Consumible', 'Víveres', 50.00, 'PCE', 'Caja', 12.00, 30.00, 400.00, 'Disponible'),
(325, '150870', 'AGUA MINERAL DE 600 ML C/U', 'Consumible', 'Víveres', 48.00, 'Ltr', 'Caja', 24.00, 10.00, 400.00, 'Disponible'),
(326, '149008', 'TODDY (BEBIDA ACHOCOLATADA), PRESENTACIÓN: PAQ. DE 400 GRM', 'Consumible', 'Víveres', 2.00, 'PCE', 'Caja/Saco', 1.00, 5.00, 400.00, 'Por Agotarse'),
(327, '143949', 'ALIÑO ROJO EN POLVO', 'Consumible', 'Víveres', 2.00, 'Kg', 'Caja/Saco', 1.00, 5.00, 400.00, 'Por Agotarse'),
(328, '144460', 'ARROZ BLANCO TIPO I', 'Consumible', 'Víveres', 90.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(329, '144127', 'ATUN EN LATA , 170GR', 'Consumible', 'Víveres', 24.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(330, '148637', 'AVENA EN HOJUELAS, PRESENTACIÓN: PAQ. DE 800 GR', 'Consumible', 'Víveres', 6.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(331, '143996', 'ARVEJAS VERDES SECAS', 'Consumible', 'Víveres', 6.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(332, '149207', 'BICARBONATO DE SODIO, PRESENTACIÓN: PAQUETE DE 30 GR', 'Consumible', 'Víveres', 1.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Por Agotarse'),
(333, '147786', 'AZUCAR BLANCA GRANULADA', 'Consumible', 'Víveres', 160.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(334, '144471', 'CAFE MOLIDO, PRESENTACIÓN: PAQ. DE 500 GR', 'Consumible', 'Víveres', 60.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(335, '143951', 'CANELA EN RAMA', 'Consumible', 'Víveres', 0.50, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Por Agotarse'),
(336, '143950', 'Canela en Polvo', 'Consumible', 'Víveres', 0.50, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Por Agotarse'),
(337, '143997', 'CARAOTAS NEGRAS SECAS', 'Consumible', 'Víveres', 6.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(338, '144481', 'CARAOTAS ROJAS SECAS', 'Consumible', 'Víveres', 1.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Por Agotarse'),
(339, '148026', 'CARMENCITA (COLORANTE ALIMENTARIO)', 'Consumible', 'Víveres', 13.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(340, '154775', 'CLAVOS DE OLOR', 'Consumible', 'Víveres', 5.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(341, '148839', 'COMINO EN POLVO, PRESENTACIÓN: ENVASE DE 20 A 30  GR', 'Consumible', 'Víveres', 33.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(342, '144135', 'CURRY EN POLVO', 'Consumible', 'Víveres', 5.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(343, '143999', 'FRIJOL PICO NEGRO SECO', 'Consumible', 'Víveres', 3.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(344, '149537', 'GELATINA GRANULADA, SABORES SURTIDOS, PRESENTACIÓN: PAQ. DE 65 GRM', 'Consumible', 'Víveres', 1.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Por Agotarse'),
(345, '154853', 'CEREZAS EN ALMIBAR FRASCO 125GR A 400GR', 'Consumible', 'Víveres', 1.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Por Agotarse'),
(346, '146408', 'GALLETA CLUB SOCIAL, PRESENTACIÓN: PAQ. DE 234 GR (9 MINI-PAQ. X 3 UND)', 'Consumible', 'Víveres', 1.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Por Agotarse'),
(347, '146409', 'GUISANTES VERDES AL NATURAL, PRESENTACIÓN: LATA DE 425 GR', 'Consumible', 'Víveres', 4.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(348, '144690', 'HARINA DE MAIZ PRECOCIDA', 'Consumible', 'Víveres', 120.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(349, '144461', 'HARINA DE TRIGO LEUDANTE / TODO USO', 'Consumible', 'Víveres', 60.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(350, '147864', 'LAUREL SECO EN HOJAS', 'Consumible', 'Víveres', 25.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(351, '143968', 'LECHE CONDENSADA AZUCARADA, PRESENTACIÓN: LATA DE 397 GR', 'Consumible', 'Víveres', 1.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Por Agotarse'),
(352, '144000', 'LENTEJAS SECAS', 'Consumible', 'Víveres', 1.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Por Agotarse'),
(353, '148874', 'LECHE EN POLVO, PRESENTACIÓN: 1 KG', 'Consumible', 'Víveres', 36.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(354, '143974', 'LEVADURA GRANULADA PAQUETE DE 1/2 KG GRANULADA', 'Consumible', 'Víveres', 1.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Por Agotarse'),
(355, '144691', 'MAICENA / MAIZINA / ALMIDON DE MAIZ, PRESENTACIÓN: PAQ. DE 800 GR', 'Consumible', 'Víveres', 6.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(356, '144147', 'MAIZ DULCE EN GRANO, PRESENTACIÓN: LATA DE 300 GR', 'Consumible', 'Víveres', 4.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(357, '154776', 'MANTECA VEGETAL 500GR', 'Consumible', 'Víveres', 1.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Por Agotarse'),
(358, '150349', 'MARGARINA / MANTEQUILLA, PRESENTACIÓN: ENVASE DE 500 GRM', 'Consumible', 'Víveres', 24.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(359, '144069', 'MAYONESA PREPARADA', 'Consumible', 'Víveres', 8.00, 'GLL', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(360, '154858', 'MERMELADA SABORES DE FRUTAS SURTIDA 230GR – 400GR', 'Consumible', 'Víveres', 1.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Por Agotarse'),
(361, '146411', 'MOSTAZA PREPARADA, ENVASE DE 260 A 500 GR', 'Consumible', 'Víveres', 4.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(362, '149050', 'OREGANO SECO EN HOJAS', 'Consumible', 'Víveres', 1.00, 'KGM', 'Caja/Saco', 1.00, 1.00, 400.00, 'Por Agotarse'),
(363, '146413', 'PAPELON, PRESENTACIÓN: PANELA DE 500 GR', 'Consumible', 'Víveres', 20.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(364, '154774', 'PASTA DE TOMATE / PASSATA, PRESENTACIÓN: ENVASE DE 500GR', 'Consumible', 'Víveres', 4.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(365, '144467', 'PASTA CORTA', 'Consumible', 'Víveres', 36.00, 'KGM', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(366, '144152', 'PASTA LARGA', 'Consumible', 'Víveres', 24.00, 'KGM', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(367, '148645', 'PASTA PARA PASTICHO, PRESENTACIÓN: BT. DE 12 CAJAS DE 250 GR C/U', 'Consumible', 'Víveres', 24.00, 'BX', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(368, '143972', 'POLVO DE HORNEAR, PRESENTACIÓN: ENVASE DE 200 GR', 'Consumible', 'Víveres', 7.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(369, '154932', 'PUDIN', 'Consumible', 'Víveres', 1.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Por Agotarse'),
(370, '148643', 'UVAS PASAS', 'Consumible', 'Víveres', 1.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Por Agotarse'),
(371, '149641', 'PAPAS FRITAS PRECOCIDAS, PRESENTACIÓN: PAQ. DE 140 GR A 300GR', 'Consumible', 'Víveres', 1.00, 'PK', 'Caja/Saco', 1.00, 1.00, 400.00, 'Por Agotarse'),
(372, '147506', 'REFRESCO (SABOR SURTIDO), PRESENTACIÓN: CAJA DE 6 BOTELLA DE 2 LITROS C/U', 'Consumible', 'Víveres', 96.00, 'BX', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(373, '144942', 'REFRESCO DE LATA 355ML (PAQ. 24 UNIDADES)', 'Consumible', 'Víveres', 24.00, 'PK', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(374, '144472', 'SAL REFINADA', 'Consumible', 'Víveres', 28.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(375, '146412', 'SALSA 57 O 79, PRESENTACIÓN: FRASCO DE 375 ML', 'Consumible', 'Víveres', 2.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(376, '147889', 'SALSA DE AJO', 'Consumible', 'Víveres', 2.00, 'GLL', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(377, '147292', 'SALSA DE SOYA', 'Consumible', 'Víveres', 2.00, 'GLL', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(378, '144469', 'SALSA DE TOMATE, PRESENTACIÓN: ENVASE DE 4.2 KG', 'Consumible', 'Víveres', 4.00, 'GLL', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(379, '147293', 'SALSA  INGLESA', 'Consumible', 'Víveres', 2.00, 'GLL', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(380, '148849', 'SARDINAS EN ACEITE / AL NATURAL, PRESENTACIÓN: LATA DE 170 GR', 'Consumible', 'Víveres', 24.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(381, '149070', 'SAZONATODO (PRESENTACION: FRASCO DE 200 GR a 300GR)', 'Consumible', 'Víveres', 1.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Por Agotarse'),
(382, '146415', 'ESENCIA DE VAINILLA (LIQUIDA), PRESENTACIÓN: ENVASE DE 800 CC A 1 LT', 'Consumible', 'Víveres', 2.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(383, '154779', 'VINAGRE BLANCO 1LT', 'Consumible', 'Víveres', 12.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(384, '154778', 'TE DE MANZANILLA SOBRE', 'Consumible', 'Víveres', 1.00, 'PK', 'Caja/Saco', 1.00, 1.00, 400.00, 'Por Agotarse'),
(385, '154777', 'TÉ VERDE SOBRE', 'Consumible', 'Víveres', 1.00, 'PK', 'Caja/Saco', 1.00, 1.00, 400.00, 'Por Agotarse'),
(386, '154882', 'TE FRUTOS ROJOS', 'Consumible', 'Víveres', 1.00, 'PK', 'Caja/Saco', 1.00, 1.00, 400.00, 'Por Agotarse'),
(387, '147871', 'TOMILLO SECO EN HOJAS', 'Consumible', 'Víveres', 25.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(388, '144004', 'PAN DE SANDWICH BLANCO GRANDE', 'Consumible', 'Panes', 30.00, 'PK', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(389, '144006', 'PAN DE PERRO CALIENTE', 'Consumible', 'Panes', 20.00, 'PK', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(390, '144005', 'PAN DE HAMBURGUESA', 'Consumible', 'Panes', 20.00, 'PK', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(391, '154783', 'Pan Rallado', 'Consumible', 'Panes', 1.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Por Agotarse'),
(392, '143980', 'CAMBUR', 'Consumible', 'Frutas', 29.00, 'KGM', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(393, '143995', 'COCO NATURAL ENTERO X KGRS', 'Consumible', 'Frutas', 10.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(394, '144309', 'FRESA   (NATURAL)  X KGRS', 'Consumible', 'Frutas', 10.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(395, '143982', 'GUAYABA', 'Consumible', 'Frutas', 23.60, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(396, '143983', 'LECHOZA', 'Consumible', 'Frutas', 29.80, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(397, '143984', 'LIMON', 'Consumible', 'Frutas', 40.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(398, '143985', 'MANDARINA', 'Consumible', 'Frutas', 30.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(399, '143993', 'Manzana', 'Consumible', 'Frutas', 40.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(400, '143986', 'MELON', 'Consumible', 'Frutas', 118.60, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(401, '151281', 'MORA NATURAL, 1 KGR', 'Consumible', 'Frutas', 14.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(402, '150536', 'NARANJA', 'Consumible', 'Frutas', 119.20, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(403, '143987', 'PARCHITA', 'Consumible', 'Frutas', 39.80, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(404, '143988', 'PATILLA', 'Consumible', 'Frutas', 138.80, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(405, '143991', 'PIÑA', 'Consumible', 'Frutas', 114.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(406, '144071', 'AGUACATE', 'Consumible', 'Vegetales', 60.00, 'Kg', 'Cesta', 20.00, 1.00, 400.00, 'Disponible'),
(407, '144072', 'AJI DULCE', 'Consumible', 'Vegetales', 4.80, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(408, '144074', 'AJO PORRO', 'Consumible', 'Vegetales', 5.20, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(409, '144075', 'AJO SECO (CABEZA)', 'Consumible', 'Vegetales', 6.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(410, '144076', 'APIO CRIOLLO', 'Consumible', 'Vegetales', 9.60, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(411, '144077', 'APIO ESPAÑA O CEDANO', 'Consumible', 'Vegetales', 5.80, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(412, '144078', 'AUYAMA', 'Consumible', 'Vegetales', 29.40, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(413, '144079', 'BROCOLI LIMPIO', 'Consumible', 'Vegetales', 13.60, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(414, '144080', 'CALABACIN', 'Consumible', 'Vegetales', 15.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(415, '144081', 'CEBOLLA BLANCA', 'Consumible', 'Vegetales', 60.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(416, '144082', 'CEBOLLA MORADA', 'Consumible', 'Vegetales', 5.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(417, '144083', 'CEBOLLIN', 'Consumible', 'Vegetales', 14.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(418, '144085', 'CILANTRO', 'Consumible', 'Vegetales', 6.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(419, '144086', 'COLIFLOR LIMPIO', 'Consumible', 'Vegetales', 14.80, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(420, '144103', 'JOJOTO', 'Consumible', 'Vegetales', 19.40, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(421, '144088', 'LECHUGA LIMPIA', 'Consumible', 'Vegetales', 43.80, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(422, '144089', 'ÑAME', 'Consumible', 'Vegetales', 14.80, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(423, '144090', 'OCUMO', 'Consumible', 'Vegetales', 14.80, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(424, '144091', 'PAPA', 'Consumible', 'Vegetales', 138.60, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(425, '144093', 'PEREJIL', 'Consumible', 'Vegetales', 3.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(426, '144092', 'PEPINO', 'Consumible', 'Vegetales', 5.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(427, '144094', 'PIMENTON', 'Consumible', 'Vegetales', 30.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(428, '150535', 'PLATANO', 'Consumible', 'Vegetales', 196.60, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(429, '144095', 'REMOLACHA', 'Consumible', 'Vegetales', 19.40, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(430, '144096', 'REPOLLO BLANCO', 'Consumible', 'Vegetales', 29.80, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(431, '144097', 'REPOLLO MORADO', 'Consumible', 'Vegetales', 14.20, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(432, '144098', 'TOMATE', 'Consumible', 'Vegetales', 60.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(433, '144101', 'YUCA', 'Consumible', 'Vegetales', 69.80, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(434, '144102', 'ZANAHORIA', 'Consumible', 'Vegetales', 69.40, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(435, '150121', 'PULPAS DE FRUTAS SURTIDAS CON AZUCAR (PAQ. DE 1 KG)', 'Consumible', 'Pulpa de frutas', 89.80, 'PK', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(436, '148834', 'HUEVO DE GALLINA, PRESENTACION: CARTON DE 30 UND', 'Consumible', 'Charcutería', 36.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(437, '147859', 'BOLOÑA ENTERA CARNE', 'Consumible', 'Charcutería', 1.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Por Agotarse'),
(438, '143927', 'JAMON DE PIERNA ENTERO', 'Consumible', 'Charcutería', 39.80, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(439, '143926', 'MORTADELA ENTERA DE CARNE', 'Consumible', 'Charcutería', 6.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(440, '143874', 'CHORIZO PARRILLERO, PRESENTACIÓN: PAQUETE DE 5 KG', 'Consumible', 'Charcutería', 10.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(441, '143946', 'SALCHICHA TIPO WIENERS', 'Consumible', 'Charcutería', 2.40, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(442, '143936', 'TOCINETA AHUMADA ENTERA', 'Consumible', 'Charcutería', 5.80, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(443, '143940', 'CREMA DE LECHE (REFRIGERADA), PRESENTACIÓN: ENVASE DE 450 A 500 GR', 'Consumible', 'Charcutería', 4.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(444, '143928', 'QUESO AMARILLO ENTERO', 'Consumible', 'Charcutería', 9.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(445, '143925', 'QUESO MADURADO ENTERO', 'Consumible', 'Charcutería', 39.40, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(446, '143929', 'QUESO MOZARELLA ENTERO', 'Consumible', 'Charcutería', 28.80, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(447, '144171', 'QUESO PASTEURIZADO ENTERO', 'Consumible', 'Charcutería', 6.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(448, '143873', 'CARNE PARA MECHAR', 'Consumible', 'Proteínas', 39.40, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(449, '143872', 'CARNE MOLIDA DE RES, PRESENTACIÓN: PAQUETE DE 1 KG', 'Consumible', 'Proteínas', 49.40, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(450, '143879', 'CHIVO', 'Consumible', 'Proteínas', 15.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(451, '143882', 'GANSO O ENTRECANTO DE RES', 'Consumible', 'Proteínas', 73.80, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(452, '143896', 'PULPA NEGRA DE RES', 'Consumible', 'Proteínas', 29.60, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(453, '143881', 'COSTILLAS DE RES', 'Consumible', 'Proteínas', 15.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(454, '143884', 'HIGADO DE RES', 'Consumible', 'Proteínas', 10.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(455, '143877', 'CHULETA DE RES', 'Consumible', 'Proteínas', 30.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(456, '143899', 'RABO DE RES', 'Consumible', 'Proteínas', 10.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(457, '143892', 'MUCHACHO CUADRADO/REDONDO DE RES', 'Consumible', 'Proteínas', 18.80, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(458, '143876', 'CHULETA DE PUERCO, PRESENTACIÓN: 1KG', 'Consumible', 'Proteínas', 44.20, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(459, '143875', 'CHULETA AHUMADA, PRESENTACIÓN: PAQUETE DE 5 KG', 'Consumible', 'Proteínas', 19.80, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(460, '143894', 'PERNIL ENTERO', 'Consumible', 'Proteínas', 14.80, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(461, '144041', 'CORVINA ENTERA, PRESENTACIÓN: PAQUETE DE 1 KG', 'Consumible', 'Proteínas', 19.60, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(462, '144051', 'MOJITO DE PESCADO', 'Consumible', 'Proteínas', 20.40, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(463, '144064', 'POLLO ENTERO EMPACADO', 'Consumible', 'Proteínas', 247.60, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(464, '154785', 'MUSLO DE POLLO (1 KG)', 'Consumible', 'Proteínas', 39.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(465, '154786', 'PECHUGA DE POLLO (1KG)', 'Consumible', 'Proteínas', 248.40, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(466, '151042', 'BOLSA DE BASURA 200 LT (PAQUETE DE 25 PCE)', 'No consumible', 'Artículos de limpieza', 40.00, 'PK', 'Caja/Saco', 1.00, 20.00, 400.00, 'Disponible'),
(467, '143860', 'BOLSA DE 60 LT (PAQUETE DE 25 PCE)', 'No consumible', 'Artículos de limpieza', 40.00, 'PK', 'Caja/Saco', 1.00, 15.00, 400.00, 'Disponible'),
(468, '144019', 'Capacillos', 'No consumible', 'Desechables', 1.00, 'PCE', 'Caja/Saco', 1.00, 30.00, 400.00, 'Por Agotarse'),
(469, '154769', 'CUCHARA PLASTICA PARA POSTRE (20 PCE POR PAQUETE)', 'No consumible', 'Artículos de limpieza', 22.00, 'PK', 'Caja/Saco', 1.00, 10.00, 400.00, 'Disponible'),
(470, '143849', 'CLORO', 'No consumible', 'Artículos de limpieza', 5.00, 'GLL', 'Caja/Saco', 1.00, 5.00, 400.00, 'Por Agotarse'),
(471, '143850', 'DESENGRASANTE BIODEGRADABLE', 'No consumible', 'Artículos de limpieza', 5.00, 'GLL', 'Caja/Saco', 1.00, 5.00, 400.00, 'Por Agotarse'),
(472, '150001', 'DESINFECTANTE Y ELIMINADOR DE MALOS OLORES, ESPECIAL PARA ALMACENES DE ALIMENTOS', 'No consumible', 'Artículos de limpieza', 24.00, 'Ltr', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(473, '148150', 'DESTAPADOR DE POCETA', 'No consumible', 'Artículos de limpieza', 22.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(474, '143848', 'ESPONJA DE BRILLO / JABONOSA', 'No consumible', 'Artículos de limpieza', 6.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(475, '145357', 'ESPONJA DE ALAMBRE', 'No consumible', 'Artículos de limpieza', 22.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(476, '145358', 'ESPONJA DOBLE USO', 'No consumible', 'Artículos de limpieza', 6.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(477, '147270', 'GUANTE DE NITRILO TALLA L', 'No consumible', 'Desechables', 1.00, 'PR', 'Caja/Saco', 1.00, 1.00, 400.00, 'Por Agotarse'),
(478, '146590', 'GUANTE PLASTICO TALLA L', 'No consumible', 'Desechables', 2.00, 'PR', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(479, '145978', '(CATERING) GUANTES DESECHABLES DE SERVICIOS PLASTICOS (PAQUETE DE 100 PCE)', 'No consumible', 'Desechables', 1.00, 'PK', 'Caja/Saco', 1.00, 1.00, 400.00, 'Por Agotarse'),
(480, '142769', '(CATERING) GUANTES TERMICOS (PAR)', 'No consumible', 'Cocina', 1.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Por Agotarse'),
(481, '144142', 'JABON DE BAÑO', 'No consumible', 'Artículos de higiene', 150.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(482, '144125', 'JABON EN POLVO (PRESENTACION 5 KGM)', 'No consumible', 'Artículos de limpieza', 8.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(483, '144143', 'LAVAPLATO BIODEGRADABLE GALON', 'No consumible', 'Artículos de limpieza', 6.00, 'GLL', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(484, '143867', 'JABON LIQUIDO PARA MANOS', 'No consumible', 'Artículos de higiene', 2.00, 'GLL', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(485, '144145', 'LIMPIA HORNO CREMA', 'No consumible', 'Artículos de limpieza', 5.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(486, '133443', 'MASCARILLAS QUIRÚRGICA DESECHABLE', 'No consumible', 'Desechables', 2.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(487, '154771', 'MONDADIENTE (PAQ. DE 200 UNIDADES)', 'No consumible', 'Desechables', 10.00, 'PK', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(488, '144463', 'PAPEL ALUMINIO', 'No consumible', 'Cocina', 1.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Por Agotarse'),
(489, '144464', 'PAPEL ENVOPLAST INDUSTRIAL, 23 MICRAS X 500 MTS', 'No consumible', 'Cocina', 1.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Por Agotarse'),
(490, '144012', 'PAPEL HIGIENICO', 'No consumible', 'Artículos de higiene', 96.00, 'RO', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(491, '144013', 'PITILLOS (PAQUETE DE 150 PCE)', 'No consumible', 'Desechables', 10.00, 'PK', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(492, '141752', 'PORTA MOPA DE METAL', 'No consumible', 'Artículos de limpieza', 22.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(493, '143853', 'AMBIENTADOR', 'No consumible', 'Artículos de limpieza', 22.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(494, '144465', 'SERVILLETAS', 'No consumible', 'Desechables', 20.00, 'PK', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(495, '144018', 'TOALLIN INDUSTRIAL', 'No consumible', 'Artículos de limpieza', 3.00, 'RO', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(496, '154933', 'VASOS V – 4 , Z – 47, V -47 (Paq. 100 Und)', 'No consumible', 'Desechables', 30.00, 'PK', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(497, '144011', 'VASOS  V-5', 'No consumible', 'Desechables', 20.00, 'BG', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(498, '150454', 'VASOS V-10, TIPO V-107 (PAQUETE DE 50 PCE)', 'No consumible', 'Desechables', 30.00, 'PK', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible');

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
(54, 1, 'EDICION_INSUMO', 'Actualizó los datos del insumo \'AGUACATE\' (#406).', '2026-10-23 16:11:35');

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

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `menu_diario_detalle`
--

CREATE TABLE `menu_diario_detalle` (
  `id_detalle` int(11) NOT NULL,
  `id_menu_semanal` int(11) NOT NULL,
  `dia_semana` enum('Lunes','Martes','Miércoles','Jueves','Viernes','Sábado','Domingo') NOT NULL,
  `tipo_comida` enum('Desayuno','Almuerzo','Cena','Nocturno') NOT NULL,
  `plato_principal` text NOT NULL,
  `guarnicion` text DEFAULT NULL,
  `ensalada_sopa` text DEFAULT NULL,
  `postre_bebida` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

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
  `tarifa_alojamiento` decimal(10,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_spanish_ci;

--
-- Volcado de datos para la tabla `servicios_catering`
--

INSERT INTO `servicios_catering` (`id_servicio`, `fecha`, `ubicacion_embarcacion`, `desayunos_cliente`, `almuerzos_cliente`, `cenas_cliente`, `cena_medianoche_cliente`, `alojamiento_cliente`, `desayunos_servicio`, `almuerzos_servicio`, `cenas_servicio`, `cena_medianoche_servicio`, `alojamiento_servicio`, `desayunos_maritime`, `almuerzos_maritime`, `cenas_maritime`, `cena_medianoche_maritime`, `alojamiento_maritime`, `observaciones`, `usuario_registro`, `estado`, `fecha_cierre`, `creado_en`, `total_comensales`, `menu_desayuno`, `menu_almuerzo`, `menu_cena`, `menu_medianoche`, `tarifa_alimentacion`, `tarifa_alojamiento`) VALUES
(1, '2026-10-22', 'M-123', 5, 6, 5, 6, 10, 5, 5, 4, 5, 10, 6, 1, 9, 6, 10, '', 'Ariadna Colmenares', 'Abierto', NULL, '2026-10-22 19:52:55', 0, '', '', '', '', 15.00, 10.00);

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
(3, 'PED-20261020-271', 'M-123', '2026-10-20 11:17:31', '2026-10-23', 'Despachado', 'PROVEEDOR: FASTO\r\nProteínas y Carnes | Carne para mechar | Kg Directo | 1Kg | 50 | 5');

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
  ADD PRIMARY KEY (`id_producto`),
  ADD UNIQUE KEY `codigo_sku` (`codigo_sku`);

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
-- AUTO_INCREMENT de la tabla `entradas_insumos`
--
ALTER TABLE `entradas_insumos`
  MODIFY `id_entrada` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `inventario`
--
ALTER TABLE `inventario`
  MODIFY `id_producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=499;

--
-- AUTO_INCREMENT de la tabla `logs_sistema`
--
ALTER TABLE `logs_sistema`
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT de la tabla `menus_semanales`
--
ALTER TABLE `menus_semanales`
  MODIFY `id_menu_semanal` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `menu_diario_detalle`
--
ALTER TABLE `menu_diario_detalle`
  MODIFY `id_detalle` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `salidas_insumos`
--
ALTER TABLE `salidas_insumos`
  MODIFY `id_salida` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `servicios_catering`
--
ALTER TABLE `servicios_catering`
  MODIFY `id_servicio` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

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
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
