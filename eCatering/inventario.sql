-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 03-11-2026 a las 21:27:03
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
(322, '147296', 'ACEITE VEGETAL ', 'Consumible', 'Víveres', 0.00, 'Ltr', 'Cuñete', 18.00, 20.00, 40.00, 'Agotado'),
(323, '144106', 'ACEITE VEGETAL LITRO', 'Consumible', 'Víveres', 25.00, 'Ltr', 'Caja', 12.00, 15.00, 400.00, 'Disponible'),
(324, '150169', 'ACEITUNAS VERDES PRESENTACION 180 GRM', 'Consumible', 'Víveres', 0.00, 'PCE', 'Caja', 12.00, 30.00, 400.00, 'Agotado'),
(325, '150870', 'AGUA MINERAL DE 600 ML C/U', 'Consumible', 'Víveres', 12.00, 'Unid', 'Caja', 24.00, 10.00, 400.00, 'Disponible'),
(326, '149008', 'TODDY (BEBIDA ACHOCOLATADA), PRESENTACIÓN: PAQ. DE 400 GRM', 'Consumible', 'Víveres', 2.00, 'PCE', 'Caja/Saco', 1.00, 5.00, 400.00, 'Por Agotarse'),
(327, '143949', 'ALIÑO ROJO EN POLVO', 'Consumible', 'Víveres', 2.70, 'Kg', 'Bolsa', 1.00, 5.00, 400.00, 'Por Agotarse'),
(328, '144460', 'ARROZ BLANCO TIPO I', 'Consumible', 'Víveres', 123.00, 'Kg', 'Saco', 24.00, 1.00, 400.00, 'Disponible'),
(329, '144127', 'ATUN EN LATA , 170GR', 'Consumible', 'Víveres', 2.89, 'Kg', 'Lata', 0.17, 1.00, 400.00, 'Disponible'),
(330, '148637', 'AVENA EN HOJUELAS, PRESENTACIÓN: PAQ. DE 800 GR', 'Consumible', 'Víveres', 6.40, 'Unid', 'Paquete', 0.80, 1.00, 400.00, 'Disponible'),
(331, '143996', 'ARVEJAS VERDES SECAS', 'Consumible', 'Víveres', 1.60, 'Kg', 'Paquete', 0.40, 0.40, 400.00, 'Disponible'),
(332, '149207', 'BICARBONATO DE SODIO, PRESENTACIÓN: PAQUETE DE 30 GR', 'Consumible', 'Víveres', 0.50, 'Kg', 'Bolsa', 1.00, 1.00, 400.00, 'Por Agotarse'),
(333, '147786', 'AZUCAR BLANCA GRANULADA', 'Consumible', 'Víveres', 91.00, 'Kg', 'Caja', 24.00, 1.00, 400.00, 'Disponible'),
(334, '144471', 'CAFE MOLIDO, PRESENTACIÓN: PAQ. DE 500 GR', 'Consumible', 'Víveres', 28.00, 'PCE', 'Paquete', 0.50, 1.00, 400.00, 'Disponible'),
(335, '143951', 'CANELA EN RAMA', 'Consumible', 'Víveres', 0.30, 'Kg', 'Unidad', 0.50, 1.00, 400.00, 'Por Agotarse'),
(336, '143950', 'CANELA EN POLVO', 'Consumible', 'Víveres', 0.30, 'Kg', 'Unidad', 1.00, 1.00, 400.00, 'Por Agotarse'),
(337, '143997', 'CARAOTAS NEGRAS SECAS', 'Consumible', 'Víveres', 8.00, 'Kg', 'Bolsa', 1.00, 1.00, 400.00, 'Disponible'),
(338, '144481', 'CARAOTAS ROJAS SECAS', 'Consumible', 'Víveres', 6.00, 'Kg', 'Bolsa', 1.00, 1.00, 400.00, 'Disponible'),
(339, '148026', 'CARMENCITA (COLORANTE ALIMENTARIO)', 'Consumible', 'Víveres', 0.40, 'Kg', 'Bolsa', 1.00, 1.00, 400.00, 'Por Agotarse'),
(340, '154775', 'CLAVOS DE OLOR', 'Consumible', 'Víveres', 0.70, 'PCE', 'Unidad', 1.00, 1.00, 400.00, 'Por Agotarse'),
(341, '148839', 'COMINO EN POLVO, PRESENTACIÓN: ENVASE DE 20 A 30  GR', 'Consumible', 'Víveres', 1.00, 'PCE', 'Bolsa', 1.00, 1.00, 400.00, 'Por Agotarse'),
(342, '144135', 'CURRY EN POLVO', 'Consumible', 'Víveres', 1.00, 'Kg', 'Bolsa', 1.00, 1.00, 400.00, 'Por Agotarse'),
(344, '149537', 'GELATINA GRANULADA, SABORES SURTIDOS, PRESENTACIÓN: PAQ. DE 65 GRM', 'Consumible', 'Víveres', 0.00, 'PCE', 'Paquete', 1.00, 1.00, 400.00, 'Agotado'),
(345, '154853', 'CEREZAS EN ALMIBAR FRASCO 125GR A 400GR', 'Consumible', 'Víveres', 1.00, 'PCE', 'Lata', 1.00, 1.00, 400.00, 'Por Agotarse'),
(346, '146408', 'GALLETA CLUB SOCIAL, PRESENTACIÓN: PAQ. DE 234 GR (9 MINI-PAQ. X 3 UND)', 'Consumible', 'Víveres', 0.00, 'PCE', 'Paquete', 1.00, 1.00, 400.00, 'Agotado'),
(347, '146409', 'GUISANTES VERDES AL NATURAL, PRESENTACIÓN: LATA DE 425 GR', 'Consumible', 'Víveres', 7.00, 'PCE', 'Paquete', 1.00, 1.00, 400.00, 'Disponible'),
(348, '144690', 'HARINA DE MAIZ PRECOCIDA', 'Consumible', 'Víveres', 80.00, 'Kg', 'Saco', 20.00, 1.00, 400.00, 'Disponible'),
(349, '144461', 'HARINA DE TRIGO LEUDANTE / TODO USO', 'Consumible', 'Víveres', 60.00, 'Kg', 'Saco', 20.00, 51.00, 400.00, 'Disponible'),
(350, '147864', 'LAUREL SECO EN HOJAS', 'Consumible', 'Víveres', 1.50, 'Kg', 'Bolsa', 1.00, 1.00, 400.00, 'Disponible'),
(351, '143968', 'LECHE CONDENSADA AZUCARADA, PRESENTACIÓN: LATA DE 397 GR', 'Consumible', 'Víveres', 0.39, 'PCE', 'Lata', 0.39, 1.00, 400.00, 'Por Agotarse'),
(352, '144000', 'LENTEJAS ', 'Consumible', 'Víveres', 0.80, 'Kg', 'Paquete', 0.40, 1.00, 400.00, 'Por Agotarse'),
(353, '148874', 'LECHE EN POLVO, PRESENTACIÓN: 1 KG', 'Consumible', 'Víveres', 23.40, 'Kg', 'Paquete', 0.90, 1.00, 400.00, 'Disponible'),
(354, '143974', 'LEVADURA GRANULADA PAQUETE DE 1/2 KG GRANULADA', 'Consumible', 'Víveres', 0.10, 'Kg', 'Bolsa', 1.00, 1.00, 400.00, 'Por Agotarse'),
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
(382, '146415', 'VAINILLA (LIQUIDA)', 'Consumible', 'Víveres', 3.00, 'Lts', 'Unidad', 1.00, 1.00, 400.00, 'Disponible'),
(383, '154779', 'VINAGRE BLANCO 1LT', 'Consumible', 'Víveres', 12.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(384, '154778', 'TE DE MANZANILLA SOBRE', 'Consumible', 'Víveres', 1.00, 'PK', 'Caja/Saco', 1.00, 1.00, 400.00, 'Por Agotarse'),
(385, '154777', 'TÉ VERDE SOBRE', 'Consumible', 'Víveres', 1.00, 'PK', 'Caja/Saco', 1.00, 1.00, 400.00, 'Por Agotarse'),
(386, '154882', 'TE FRUTOS ROJOS', 'Consumible', 'Víveres', 1.00, 'PK', 'Caja/Saco', 1.00, 1.00, 400.00, 'Por Agotarse'),
(387, '147871', 'TOMILLO SECO EN HOJAS', 'Consumible', 'Víveres', 25.00, 'Kg', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(388, '144004', 'PAN DE SANDWICH BLANCO GRANDE', 'Consumible', 'Panes', 30.00, 'PK', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(389, '144006', 'PAN DE PERRO CALIENTE', 'Consumible', 'Panes', 20.00, 'PK', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(390, '144005', 'PAN DE HAMBURGUESA', 'Consumible', 'Panes', 20.00, 'PK', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(391, '154783', 'Pan Rallado', 'Consumible', 'Panes', 1.00, 'PCE', 'Caja/Saco', 1.00, 1.00, 400.00, 'Por Agotarse'),
(392, '143980', 'CAMBUR', 'Consumible', 'Frutas', 0.00, 'Kg', 'Cesta', 100.00, 1.00, 400.00, 'Agotado'),
(393, '143995', 'COCO NATURAL ENTERO X KGRS', 'Consumible', 'Frutas', 4.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(394, '144309', 'FRESA   (NATURAL)  X KGRS', 'Consumible', 'Frutas', 10.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(395, '143982', 'GUAYABA', 'Consumible', 'Frutas', 26.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(396, '143983', 'LECHOZA', 'Consumible', 'Frutas', 6.80, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(397, '143984', 'LIMON', 'Consumible', 'Frutas', 19.60, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(398, '143985', 'MANDARINA', 'Consumible', 'Frutas', 10.40, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(399, '143993', 'MANZANA', 'Consumible', 'Frutas', 24.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(400, '143986', 'MELON', 'Consumible', 'Frutas', 29.80, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(401, '151281', 'MORA NATURAL, 1 KGR', 'Consumible', 'Frutas', 15.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(402, '150536', 'NARANJA', 'Consumible', 'Frutas', 68.60, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(403, '143987', 'PARCHITA', 'Consumible', 'Frutas', 25.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(404, '143988', 'PATILLA', 'Consumible', 'Frutas', 100.80, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(405, '143991', 'PIÑA', 'Consumible', 'Frutas', 60.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(406, '144071', 'AGUACATE', 'Consumible', 'Vegetales', 2.80, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(407, '144072', 'AJI DULCE', 'Consumible', 'Vegetales', 3.20, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(408, '144074', 'AJO PORRO', 'Consumible', 'Vegetales', 3.50, 'Kg', 'Caja', 1.00, 1.00, 400.00, 'Disponible'),
(409, '144075', 'AJO SECO (CABEZA)', 'Consumible', 'Vegetales', 6.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(410, '144076', 'APIO CRIOLLO', 'Consumible', 'Vegetales', 1.80, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(411, '144077', 'APIO ESPAÑA O CEDANO', 'Consumible', 'Vegetales', 3.80, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(412, '144078', 'AUYAMA', 'Consumible', 'Vegetales', 16.60, 'Kg', 'Caja', 1.00, 1.00, 400.00, 'Disponible'),
(413, '144079', 'BROCOLI LIMPIO', 'Consumible', 'Vegetales', 6.60, 'Kg', 'Caja', 1.00, 1.00, 400.00, 'Disponible'),
(414, '144080', 'CALABACIN', 'Consumible', 'Vegetales', 8.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(415, '144081', 'CEBOLLA BLANCA', 'Consumible', 'Vegetales', 38.50, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(416, '144082', 'CEBOLLA MORADA', 'Consumible', 'Vegetales', 2.70, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(417, '144083', 'CEBOLLIN', 'Consumible', 'Vegetales', 7.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(418, '144085', 'CILANTRO', 'Consumible', 'Vegetales', 4.50, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(419, '144086', 'COLIFLOR LIMPIO', 'Consumible', 'Vegetales', 6.80, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(420, '144103', 'JOJOTO', 'Consumible', 'Vegetales', 3.20, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(421, '144088', 'LECHUGA LIMPIA', 'Consumible', 'Vegetales', 26.30, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(422, '144089', 'ÑAME', 'Consumible', 'Vegetales', 7.90, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(423, '144090', 'OCUMO', 'Consumible', 'Vegetales', 9.50, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(424, '144091', 'PAPA', 'Consumible', 'Vegetales', 98.50, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(425, '144093', 'PEREJIL', 'Consumible', 'Vegetales', 2.40, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(426, '144092', 'PEPINO', 'Consumible', 'Vegetales', 2.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(427, '144094', 'PIMENTON', 'Consumible', 'Vegetales', 11.90, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(428, '150535', 'PLATANO', 'Consumible', 'Vegetales', 95.20, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(429, '144095', 'REMOLACHA', 'Consumible', 'Vegetales', 18.70, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(430, '144096', 'REPOLLO BLANCO', 'Consumible', 'Vegetales', 16.10, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(431, '144097', 'REPOLLO MORADO', 'Consumible', 'Vegetales', 16.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(432, '144098', 'TOMATE', 'Consumible', 'Vegetales', 34.80, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(433, '144101', 'YUCA', 'Consumible', 'Vegetales', 41.00, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(434, '144102', 'ZANAHORIA', 'Consumible', 'Vegetales', 65.80, 'Kg', 'Cesta', 1.00, 1.00, 400.00, 'Disponible'),
(435, '150121', 'PULPAS DE FRUTAS SURTIDAS CON AZUCAR (PAQ. DE 1 KG)', 'Consumible', 'Pulpa de frutas', 106.00, 'Kg', 'Bolsa', 48.00, 1.00, 400.00, 'Disponible'),
(436, '148834', 'HUEVOS DE GALLINA', 'Consumible', 'Proteínas', 35.00, 'PCE', 'Caja', 12.00, 1.00, 400.00, 'Disponible'),
(437, '147859', 'BOLOÑA ENTERA CARNE', 'Consumible', 'Charcutería', 0.00, 'Kg', 'Panela', 3.50, 1.00, 400.00, 'Agotado'),
(438, '143927', 'JAMON DE PIERNA ENTERO', 'Consumible', 'Charcutería', 35.50, 'Kg', 'Panela', 4.20, 1.00, 400.00, 'Disponible'),
(439, '143926', 'MORTADELA DE POLLO', 'Consumible', 'Charcutería', 1.50, 'Kg', 'Saco', 10.00, 1.00, 400.00, 'Disponible'),
(440, '143874', 'CHORIZO PARRILLERO', 'Consumible', 'Charcutería', 9.60, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible'),
(441, '143946', 'SALCHICHA TIPO WIENERS', 'Consumible', 'Charcutería', 4.80, 'Unid', 'Unidad', 100.00, 1.00, 400.00, 'Disponible'),
(442, '143936', 'TOCINETA AHUMADA ENTERA', 'Consumible', 'Charcutería', 1.50, 'Kg', 'Unidad', 3.00, 1.00, 400.00, 'Disponible'),
(443, '143940', 'CREMA DE LECHE (REFRIGERADA), PRESENTACIÓN: ENVASE DE 450 A 500 GR', 'Consumible', 'Lácteos', 1.00, 'Unid', 'Lata', 1.00, 1.00, 400.00, 'Por Agotarse'),
(444, '143928', 'QUESO AMARILLO ENTERO', 'Consumible', 'Lácteos', 3.00, 'Kg', 'Panela', 1.00, 1.00, 400.00, 'Disponible'),
(445, '143925', 'QUESO MADURADO ENTERO', 'Consumible', 'Lácteos', 18.60, 'Kg', 'Unidad', 3.00, 1.00, 400.00, 'Disponible'),
(446, '143929', 'QUESO MOZARELLA ENTERO', 'Consumible', 'Lácteos', 19.60, 'Kg', 'Panela', 2.50, 1.00, 400.00, 'Disponible'),
(447, '144171', 'QUESO PASTEURIZADO ENTERO', 'Consumible', 'Lácteos', 22.60, 'Kg', 'Panela', 1.00, 1.00, 400.00, 'Disponible'),
(448, '143873', 'CARNE PARA MECHAR', 'Consumible', 'Proteínas', 69.60, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible'),
(449, '143872', 'CARNE MOLIDA DE RES', 'Consumible', 'Proteínas', 122.00, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible'),
(450, '143879', 'CHIVO', 'Consumible', 'Proteínas', 14.60, 'Kg', 'Bolsa', 5.00, 0.00, 400.00, 'Disponible'),
(451, '143882', 'GANSO O ENTRECANTO DE RES', 'Consumible', 'Proteínas', 0.00, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Agotado'),
(452, '143896', 'PULPA NEGRA DE RES', 'Consumible', 'Proteínas', 29.80, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible'),
(453, '143881', 'COSTILLAS DE RES', 'Consumible', 'Proteínas', 29.60, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible'),
(454, '143884', 'HIGADO DE RES', 'Consumible', 'Proteínas', 4.00, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible'),
(455, '143877', 'CHULETA DE RES', 'Consumible', 'Proteínas', 5.00, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible'),
(456, '143899', 'RABO DE RES', 'Consumible', 'Proteínas', 5.00, 'Unid', 'Bolsa', 5.00, 0.00, 400.00, 'Disponible'),
(457, '143892', 'MUCHACHO CUADRADO/REDONDO DE RES', 'Consumible', 'Proteínas', 25.00, 'Kg', 'Unidad', 3.00, 1.00, 400.00, 'Disponible'),
(458, '143876', 'CHULETA DE PUERCO', 'Consumible', 'Proteínas', 5.00, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible'),
(459, '143875', 'CHULETA AHUMADA, PRESENTACIÓN: PAQUETE DE 5 KG', 'Consumible', 'Proteínas', 0.00, 'Kg', 'Bolsa', 5.00, 0.00, 400.00, 'Agotado'),
(460, '143894', 'PERNIL ENTERO', 'Consumible', 'Proteínas', 6.00, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible'),
(461, '144041', 'CORVINA ENTERA', 'Consumible', 'Pescado', 56.40, 'Kg', 'Bolsa', 2.00, 1.00, 400.00, 'Disponible'),
(462, '144051', 'MOJITO DE PESCADO', 'Consumible', 'Pescado', 49.00, 'Kg', 'Bolsa', 2.00, 1.00, 400.00, 'Disponible'),
(463, '144064', 'POLLO ENTERO EMPACADO', 'Consumible', 'Proteínas', 243.50, 'Kg', 'Bolsa', 2.00, 1.00, 400.00, 'Disponible'),
(464, '154785', 'MUSLO DE POLLO', 'Consumible', 'Proteínas', 79.00, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible'),
(465, '154786', 'PECHUGA DE POLLO', 'Consumible', 'Proteínas', 250.40, 'Kg', 'Bolsa', 5.00, 1.00, 400.00, 'Disponible'),
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
(498, '150454', 'VASOS V-10, TIPO V-107 (PAQUETE DE 50 PCE)', 'No consumible', 'Desechables', 30.00, 'PK', 'Caja/Saco', 1.00, 1.00, 400.00, 'Disponible'),
(499, NULL, 'BISTEC', 'Consumible', 'Proteínas', 59.60, 'Kg', 'Bolsa', 5.00, 15.00, 400.00, 'Disponible'),
(500, NULL, 'CARITE EN RUEDA', 'Consumible', 'Pescado', 0.00, 'Kg', 'Bolsa', 2.00, 1.00, 400.00, 'Agotado'),
(501, NULL, 'RONCO ENTERO', 'Consumible', 'Pescado', 0.00, 'Kg', 'Bolsa', 2.00, 1.00, 400.00, 'Agotado'),
(502, NULL, 'CORVINA EN RUEDA', 'Consumible', 'Pescado', 0.00, 'Kg', 'Bolsa', 2.00, 1.00, 400.00, 'Agotado'),
(503, NULL, 'ALBAHACA', 'Consumible', 'Víveres', 0.50, 'Kg', 'Bolsa', 1.00, 1.00, 400.00, 'Por Agotarse'),
(504, NULL, 'ALCAPARRAS', 'Consumible', 'Víveres', 0.00, 'Kg', 'Unidad', 1.00, 1.00, 400.00, 'Agotado'),
(505, NULL, 'CARBÓN', 'Consumible', 'Víveres', 10.00, 'Kg', 'Saco', 10.00, 1.00, 400.00, 'Disponible'),
(506, NULL, 'CHOCOLATE EN TABLA OSCURO CACAO 40%', 'Consumible', 'Víveres', 0.20, 'PCE', 'Paquete', 0.20, 1.00, 400.00, 'Por Agotarse');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `inventario`
--
ALTER TABLE `inventario`
  ADD PRIMARY KEY (`id_producto`),
  ADD UNIQUE KEY `nombre_insumo` (`nombre_insumo`),
  ADD UNIQUE KEY `codigo_sku` (`codigo_sku`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `inventario`
--
ALTER TABLE `inventario`
  MODIFY `id_producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=507;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
