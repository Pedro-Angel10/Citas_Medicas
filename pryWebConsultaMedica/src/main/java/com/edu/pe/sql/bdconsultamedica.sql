-- phpMyAdmin SQL Dump
-- version 4.9.0.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 20-12-2022 a las 05:36:29
-- Versión del servidor: 10.3.15-MariaDB
-- Versión de PHP: 7.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `bdconsultamedica`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_RegistrarPaciente` (OUT `_respuesta` VARCHAR(150), `_correo` VARCHAR(60), `_pass` VARCHAR(30), `_nombres` VARCHAR(60), `_apellidos` VARCHAR(60), `_dni` CHAR(8), `_telefono` CHAR(9), `_genero` CHAR(1))  BEGIN
   DECLARE _idUsuario INT;   

   IF EXISTS (SELECT * FROM usuario WHERE correo = _correo) THEN
      SET _respuesta =  CONCAT('El correo ' , _correo , ' no se encuentra disponible. Por favor, intente con otro correo.');
   ELSE
      INSERT INTO Usuario(idRol,correo,pass,fechaRegistro,estado) VALUES (3,_correo,_pass,NOW(),1);
      
      SET _idUsuario = LAST_INSERT_ID();      

      INSERT INTO Paciente(idUsuario,nombres,apellidos,dni,telefono,genero) VALUES(_idUsuario,_nombres,_apellidos,_dni,_telefono,_genero);
      
      SET _respuesta = 'OK';
   END if;
END$$

--
-- Funciones
--
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_id` (`_idUsuario` INT) RETURNS INT(11) begin
   declare _id INT; 
      
   IF EXISTS (SELECT * FROM Medico WHERE idUsuario = _idUsuario) THEN   
       SELECT idMedico INTO _id
       FROM Medico WHERE idUsuario = _idUsuario;       
   ELSE 
       IF EXISTS (SELECT * FROM Paciente WHERE idUsuario = _idUsuario) THEN   
           SELECT idPaciente INTO _id
           FROM Paciente WHERE idUsuario = _idUsuario; 
       
        ELSE 
             SET _id = 0;             
        END IF; 
   END IF;    
   return _id;
end$$

CREATE DEFINER=`root`@`localhost` FUNCTION `fn_nomCompletos` (`_idUsuario` INT) RETURNS VARCHAR(100) CHARSET latin1 begin
   declare _nomCompletos varchar(100); 
      
   IF EXISTS (SELECT * FROM Medico WHERE idUsuario = _idUsuario) THEN   
       SELECT CONCAT(CONCAT(nombres , ' ') , apellidos) INTO _nomCompletos
       FROM Medico WHERE idUsuario = _idUsuario;       
   ELSE 
       IF EXISTS (SELECT * FROM Paciente WHERE idUsuario = _idUsuario) THEN   
           SELECT CONCAT(CONCAT(nombres , ' ') , apellidos)  INTO _nomCompletos
           FROM Paciente WHERE idUsuario = _idUsuario; 
       
        ELSE 
             SET _nomCompletos = null;             
        END IF; 
   END IF;    
   return _nomCompletos;
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `consulta`
--

CREATE TABLE `consulta` (
  `nroConsulta` int(11) NOT NULL,
  `idPaciente` int(11) DEFAULT NULL,
  `idMedico` int(11) DEFAULT NULL,
  `fechaRegistro` datetime DEFAULT NULL,
  `fechaAtencion` datetime DEFAULT NULL,
  `motivo` varchar(500) DEFAULT NULL,
  `diagnostico` varchar(500) DEFAULT NULL,
  `tratamiento` varchar(500) DEFAULT NULL,
  `estado` varchar(50) DEFAULT NULL,
  `imagen` varchar(100) DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `consulta`
--

INSERT INTO `consulta` (`nroConsulta`, `idPaciente`, `idMedico`, `fechaRegistro`, `fechaAtencion`, `motivo`, `diagnostico`, `tratamiento`, `estado`, `imagen`) VALUES
(100008, 5, 1, '2024-07-14 19:19:43', '2024-07-14 19:20:48', 'dolor de cabeza', 'tuviste fuertes impresiones que provocaron dicho dolor', 'Tomar paracetamol cada 8 horas', 'ATENDIDO', ''),
(100009, 5, 1, '2024-07-14 19:21:32', '2024-07-14 19:23:04', 'dolor de barriga, indicarle que comi demasiado la noche anterior', 'cuentas con digestion por motivo que comiste en abundancia, mesclando todo tipo de alimentos.', 'tomar agua de apio caliente sin azucar , lo puede conseguir en la tienda\r\ntomar mucha agua\r\ntomar pastilla para la digestion', 'ATENDIDO', ''),
(100010, 6, 1, '2024-07-14 19:27:50', '2024-07-14 19:29:09', 'inconnes en la cabeza cada momento', 'dolor de cabeza por fuertes impresiones', 'tomar asitimilisina cada 8 h x 2 dias', 'ATENDIDO', ''),
(100011, 6, 1, '2024-07-14 19:29:25', '2024-07-14 19:30:41', 'dolor de estomago', 'cuenta con digestion al estomago', 'tomas agua de apio caliente sin azucar\r\ntomas mucha agua\r\ntomar si esposible suero \r\nimportante tomar pastila para el acides', 'ATENDIDO', ''),
(100012, 6, 2, '2024-07-14 19:31:13', '2024-07-14 19:33:37', 'dolor de muscular', 'se debe a mucho escfuerzo fisico provocado, por favor tomar reposo y seguir las indicaciones', 'usar crema chuchuhuaza para el dolor de cierta parte del cuerpo, \r\ncomprar pastilla para el dolor muscular', 'ATENDIDO', ''),
(100013, 7, 1, '2024-07-14 19:43:47', '2024-07-14 19:45:31', 'dolor de cabeza', 'sebe a tener fguertes impresiones', 'tomar pastilla para la migraña', 'ATENDIDO', ''),
(100014, 7, 1, '2024-07-14 19:45:56', '2024-07-14 19:46:37', 'dolor de cabeza', 'se debe alas fuertes impresiones que cuenta ', 'tomar pastilla para la migraña', 'ATENDIDO', ''),
(100015, 7, 1, '2024-07-14 19:47:08', '2024-07-14 19:48:04', 'dolor de estomago', 'se debee a comer demasiado co comida pasadas', 'tomar agua de apio', 'ATENDIDO', ''),
(100016, 8, 1, '2024-07-14 20:09:27', '2024-07-14 20:11:09', 'dolor del estomago , dia anterior comi demasiado', 'tiene digestion estomacal', 'tomar agua apio \r\ntomas pastila paral dolor cada 8h', 'ATENDIDO', ''),
(100017, 9, 1, '2024-07-21 19:58:27', NULL, 'dolor de cabeza\r\nobs. Noche anterior estuve tomando', NULL, NULL, 'PENDIENTE', ''),
(100018, 6, 1, '2024-07-20 00:40:40', '2024-07-20 00:41:31', 'dolor de cabeza', 'por preocupaciones', 'Tomar paracetamos', 'ATENDIDO', ''),
(100019, 6, 1, '2024-07-20 07:28:37', '2024-07-20 07:30:15', 'dolor de muela', 'causa de caries en el diente', 'cepillarsee seguido con colinos y enjuague bucal', 'ATENDIDO', ''),
(100020, 6, 1, '2024-07-20 07:32:34', NULL, 'presento signos de fiebre con temperatura a 37grados\r\n', NULL, NULL, 'PENDIENTE', ''),
(100021, 6, 1, '2024-07-20 07:34:58', '2024-07-20 07:36:01', 'estoy con temperatura elevado a mas de 37 grados.', 'cuenta con fiebre', 'paños humedos para tratar la calentura', 'ATENDIDO', ''),
(100022, 6, 1, '2024-07-20 07:37:00', '2024-07-20 07:38:37', 'estoy con temperatura elevado a mas de 37 grados.', 'cuenta cpn fiebre de 2do grado leve.', 'Tomas paracetamol,, en caso cuente con un botitquin de primeros auxilios\r\ncaso contrario bajar la temperatura con pañol y agua fria', 'ATENDIDO', ''),
(100023, 10, 1, '2024-07-20 17:56:10', '2024-07-20 17:57:06', 'dolor de cabeza', 'por preocupacion o reaccion fuertes', 'panadol', 'ATENDIDO', ''),
(100024, 11, 2, '2024-07-20 18:28:47', '2024-07-20 18:29:41', 'dolor de diente', 'asaasasa', 'asa', 'ATENDIDO', ''),
(100025, 11, 2, '2024-07-20 18:30:12', NULL, 'asasa', NULL, NULL, 'PENDIENTE', ''),
(100026, 1, NULL, '2024-07-20 20:46:41', NULL, 'Salud empeoro', NULL, NULL, 'PENDIENTE', ''),
(100027, 1, NULL, '2024-07-20 20:46:47', NULL, 'Carga emocional', NULL, NULL, 'PENDIENTE', ''),
(100028, 1, NULL, '2024-07-20 21:19:42', NULL, '665', NULL, NULL, 'PENDIENTE', ''),
(100029, 1, NULL, '2024-07-20 21:28:27', NULL, 'dgfg', NULL, NULL, 'PENDIENTE', ''),
(100030, 1, NULL, '2024-07-20 21:59:34', NULL, 'dgfg', NULL, NULL, 'PENDIENTE', ''),
(100031, 1, NULL, '2024-07-20 22:14:13', NULL, 'ertrt', NULL, NULL, 'PENDIENTE', ''),
(100032, 1, 1, '2024-07-20 22:16:13', NULL, 'Enfermo U.u', NULL, NULL, 'PENDIENTE', 'img-68720289.jpg'),
(100033, 1, 1, '2024-07-20 23:24:18', NULL, 'Test de prueba', NULL, NULL, 'PENDIENTE', 'img-11283552.jpg');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `medico`
--

CREATE TABLE `medico` (
  `idMedico` int(11) NOT NULL,
  `idUsuario` int(11) DEFAULT NULL,
  `nombres` varchar(60) DEFAULT NULL,
  `apellidos` varchar(60) DEFAULT NULL,
  `dni` char(8) DEFAULT NULL,
  `telefono` char(9) DEFAULT NULL,
  `genero` char(1) DEFAULT NULL,
  `fechaIngreso` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `medico`
--

INSERT INTO `medico` (`idMedico`, `idUsuario`, `nombres`, `apellidos`, `dni`, `telefono`, `genero`, `fechaIngreso`) VALUES
(1, 2, 'Juan', 'Sanchez Gutierrez', '42365222', '987544523', 'M', '2022-01-10'),
(2, 3, 'Luciana', 'Fernandez Quispe', '42112365', '987542225', 'F', '2022-01-11');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `paciente`
--

CREATE TABLE `paciente` (
  `idPaciente` int(11) NOT NULL,
  `idUsuario` int(11) DEFAULT NULL,
  `nombres` varchar(60) DEFAULT NULL,
  `apellidos` varchar(60) DEFAULT NULL,
  `dni` char(8) DEFAULT NULL,
  `telefono` char(9) DEFAULT NULL,
  `genero` char(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `paciente`
--

INSERT INTO `paciente` (`idPaciente`, `idUsuario`, `nombres`, `apellidos`, `dni`, `telefono`, `genero`) VALUES
(1, 4, 'Luciano Carlos', 'Carbajal Rodriguez', '45236523', '965412365', 'M'),
(2, 5, 'Roxana', 'Gutierrez', '75236542', '965236652', 'F'),
(3, 6, 'Alan', 'Bacilio Quispe', '34355623', '965645435', 'M'),
(4, 7, 'Carlos', 'Alarcon', '64665465', '954363463', 'M'),
(5, 8, 'jp', 'olivos', '70033684', '942857117', 'M'),
(6, 9, 'user1', '002', '70033652', '942857125', 'F'),
(7, 10, 'user2', '002', '70033687', '942857115', 'M'),
(8, 11, 'user3', '003', '70033684', '942857114', 'M'),
(9, 12, 'user', '004', '70033684', '942857112', 'M'),
(10, 13, 'user05', 'pop', '70022563', '942857117', 'M'),
(11, 14, 'prueba011', 'ppopp', '45522365', '958625668', 'M');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `rol`
--

CREATE TABLE `rol` (
  `idRol` int(11) NOT NULL,
  `nomRol` varchar(60) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `rol`
--

INSERT INTO `rol` (`idRol`, `nomRol`) VALUES
(1, 'ADMIN'),
(2, 'MEDICO'),
(3, 'PACIENTE');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `idUsuario` int(11) NOT NULL,
  `idRol` int(11) DEFAULT NULL,
  `correo` varchar(60) DEFAULT NULL,
  `pass` varchar(100) DEFAULT NULL,
  `fechaRegistro` datetime DEFAULT NULL,
  `estado` tinyint(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`idUsuario`, `idRol`, `correo`, `pass`, `fechaRegistro`, `estado`) VALUES
(1, 1, 'admin@gmail.com', '123456', '2024-01-02 06:32:18', 1),
(2, 2, 'juan.sanchez@gmail.com', '123456', '2024-01-03 16:32:18', 1),
(3, 2, 'luciana.fernandez@gmail.com', '123456', '2024-01-05 12:32:18', 1),
(4, 3, 'luciano.carbajal@gmail.com', '123456', '2024-03-02 11:32:18', 1),
(5, 3, 'roxana.gutierrez@gmail.com', '123456', '2024-03-05 08:22:33', 1),
(6, 3, 'alan.bacilio@gmail.com', '123456', '2024-03-05 08:55:39', 1),
(7, 3, 'carlos.alarcon@gmail.com', '123456', '2024-03-05 14:16:02', 1),
(8, 3, 'jp.olivos@gmail.com', '123456', '2024-07-14 19:19:28', 1),
(9, 3, 'user1.002@gmail.com', '123456', '2024-07-14 19:27:16', 1),
(10, 3, 'user2.002@gmail.com', '123456', '2024-07-14 19:43:25', 1),
(11, 3, 'user3.003@gmail.com', '123456', '2024-07-14 20:08:24', 1),
(12, 3, 'user.004@gmail.com', '123456', '2024-07-21 19:57:20', 1),
(13, 3, 'user05.002@gmail.com', '12345', '2024-07-30 17:55:54', 1),
(14, 3, 'prueba011@gmail.com', '123456', '2024-07-20 18:28:29', 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `consulta`
--
ALTER TABLE `consulta`
  ADD PRIMARY KEY (`nroConsulta`),
  ADD KEY `idPaciente` (`idPaciente`);

--
-- Indices de la tabla `medico`
--
ALTER TABLE `medico`
  ADD PRIMARY KEY (`idMedico`),
  ADD KEY `idUsuario` (`idUsuario`);

--
-- Indices de la tabla `paciente`
--
ALTER TABLE `paciente`
  ADD PRIMARY KEY (`idPaciente`),
  ADD KEY `idUsuario` (`idUsuario`);

--
-- Indices de la tabla `rol`
--
ALTER TABLE `rol`
  ADD PRIMARY KEY (`idRol`),
  ADD UNIQUE KEY `nomRol` (`nomRol`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`idUsuario`),
  ADD UNIQUE KEY `correo` (`correo`),
  ADD KEY `idRol` (`idRol`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `consulta`
--
ALTER TABLE `consulta`
  MODIFY `nroConsulta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=100034;

--
-- AUTO_INCREMENT de la tabla `medico`
--
ALTER TABLE `medico`
  MODIFY `idMedico` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `paciente`
--
ALTER TABLE `paciente`
  MODIFY `idPaciente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `rol`
--
ALTER TABLE `rol`
  MODIFY `idRol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `idUsuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `consulta`
--
ALTER TABLE `consulta`
  ADD CONSTRAINT `consulta_ibfk_1` FOREIGN KEY (`idPaciente`) REFERENCES `paciente` (`idPaciente`);

--
-- Filtros para la tabla `medico`
--
ALTER TABLE `medico`
  ADD CONSTRAINT `medico_ibfk_1` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`idUsuario`);

--
-- Filtros para la tabla `paciente`
--
ALTER TABLE `paciente`
  ADD CONSTRAINT `paciente_ibfk_1` FOREIGN KEY (`idUsuario`) REFERENCES `usuario` (`idUsuario`);

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`idRol`) REFERENCES `rol` (`idRol`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
