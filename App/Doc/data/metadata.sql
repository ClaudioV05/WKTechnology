-- --------------------------------------------------------
-- Host:                    127.0.0.1
-- Server OS:               Win64
-- Network type:            MariaDB or MySQL (TCP/IP)
-- Server version:          10.6.5-MariaDB - mariadb.org binary distribution
-- Generation Time:         10-JUN-2022 05:20
-- --------------------------------------------------------

--
-- Dumping database structure for `wktechnology`
--
CREATE DATABASE IF NOT EXISTS `wktechnology`;

USE `wktechnology`;

ALTER DATABASE `wktechnology` CHARSET = `utf8mb4` COLLATE = `utf8mb4_general_ci`;

--
-- Dumping structure for table `CLIENTES`
--
CREATE TABLE IF NOT EXISTS `CLIENTES` (
  `CODIGO` INT(11),
  `NOME` VARCHAR(100) NOT NULL,
  `CIDADE` VARCHAR(80) DEFAULT NULL,
  `UF` CHAR(2) DEFAULT NULL,
  `ATIVO` CHAR(1) DEFAULT 'T'
) 
ENGINE = InnoDB
COLLATE = `utf8mb4_general_ci`;

--
-- Dumping data for table `CLIENTES`
--
INSERT INTO `CLIENTES` (`CODIGO`, `NOME`, `CIDADE`, `UF`, `ATIVO`)
VALUES (1, 'VITOR DE LIMA', 'Recife', 'PE', 'T'),
       (2, 'CLAUDIO DE LIMA', 'Recife', 'PE', 'T'),
       (3, 'ANTONIO PEREIRA', 'Recife', 'PE', 'T'),
       (4, 'REGINALDO FELIX', 'Recife', 'PE', 'T'),
       (5, 'JOÁS OLIVEIRA', 'Recife', 'PE', 'T'),
       (6, 'CRISTIANO RONALDO', 'Recife', 'PE', 'T'),
       (7, 'JOSIBERTO GOMES', 'Recife', 'PE', 'T'),
       (8, 'GOMES ALUISIO', 'Recife', 'PE', 'T'),
       (9, 'ANTONIO JOSELITO', 'Recife', 'PE', 'T'),
       (10, 'NEYMAR JUNIOR', 'Recife', 'PE', 'T'),
       (11, 'ALUISIO VON CLEIN', 'Recife', 'PE', 'T'),
       (12, 'TOBIAS MANUEL', 'Recife', 'PE', 'T'),
       (13, 'NATHALIA PEREIRA', 'Recife', 'PE', 'T'),
       (14, 'MARCIA CRISTINA', 'Recife', 'PE', 'T'),
       (15, 'DARAH SMITH', 'Recife', 'PE', 'T'),
       (16, 'MARIA CLAUDIA', 'Recife', 'PE', 'T'),
       (17, 'LETICIA FERNANDA', 'Recife', 'PE', 'T'),
       (18, 'MANUEL PEREIRA', 'Recife', 'PE', 'T'),
       (19, 'SAMUEL FERNANDO', 'Recife', 'PE', 'T'),
       (20, 'MARINA DE LIMA', 'Recife', 'PE', 'T'),
       (21, 'JANETE DE FREITAS', 'Recife', 'PE', 'T'),
       (22, 'MEYRI LANNUCE', 'Recife', 'PE', 'T'),
       (23, 'ANGELICA MACDOWELL', 'Recife', 'PE', 'T'),
       (24, 'ALBERTINA PEREIRA', 'Recife', 'PE', 'T'),
       (25, 'JOSUE FREITAS', 'Recife', 'PE', 'T'),
       (26, 'ADONIAS ANDRADE', 'Recife', 'PE', 'T'),
       (27, 'JOICE RIBEIRO', 'Recife', 'PE', 'T'),
       (28, 'RAYANA GALVAO', 'Recife', 'PE', 'T'),
       (29, 'YASMIN ANDRADE', 'Recife', 'PE', 'T'),
       (30, 'ADIEL GOMES', 'Recife', 'PE', 'T'),
       (31, 'JACIARA FERREIRA', 'Recife', 'PE', 'T'),
       (32, 'GUSTAVO BUENO', 'Recife', 'PE', 'T'),
       (33, 'ANTONIO FIGUEIREDO', 'Recife', 'PE', 'T'),
       (34, 'IRANILDO SANTOS', 'Recife', 'PE', 'T'),
       (35, 'FRANCISCO FELIX', 'Recife', 'PE', 'T'),
       (36, 'WILIAM BERNARDES', 'Recife', 'PE', 'T'),
       (37, 'ANSELMO MARTINS', 'Recife', 'PE', 'T'),
       (38, 'AUGUSTO NUNES', 'Recife', 'PE', 'T'),
       (39, 'FARIAS DE FREITAS', 'Recife', 'PE', 'T'),
       (40, 'GABRIEL DE LIMA', 'Recife', 'PE', 'T');

--
-- Dumping structure for table `PRODUTOS`
--
CREATE TABLE IF NOT EXISTS `PRODUTOS` (
  `CODIGO` INT(11),
  `DESCRICAO` VARCHAR(80) NOT NULL,
  `PRECOVENDA` DECIMAL(10, 2) NOT NULL,
  `ATIVO` CHAR(1) DEFAULT 'T'
) 
ENGINE = InnoDB
COLLATE = `utf8mb4_general_ci`;

--
-- Dumping data for table `PRODUTOS`
--
INSERT INTO `PRODUTOS` (`CODIGO`, `DESCRICAO`, `PRECOVENDA`, `ATIVO`)
VALUES (1, 'ARROZ DO PADRE', 10.9, 'T'),
       (2, 'FEIJAO TURQUEZA', 5.00, 'T'),
       (3, 'CARNE DE PORCO', 55.4, 'T'),
       (4, 'TOMATE', 1.00, 'T'),
       (5, 'CEBOLA', 2.26, 'T'),
       (6, 'BOLACHA FORTALEZA', 5.20, 'T'),
       (7, 'BISCOITO TRELOSO', 1.00, 'T'),
       (8, 'FERMENTO DE BOLO', 1.09, 'T'),
       (9, 'GOMA', 5.21, 'T'),
       (10, 'PIPOCA BOKAO', 2.20, 'T'),
       (11, 'SONHO DE VALSA', 3.29, 'T'),
       (12, 'AMENDOAS', 20.2, 'T'),
       (13, 'AVEIA', 14.70, 'T'),
       (14, 'MACARRAO', 2.40, 'T'),
       (15, 'BANANA', 5.97, 'T'),
       (16, 'CONFEITOS ASSAY', 10.9, 'T'),
       (17, 'CHOCOLATE EM BARRA', 8.56, 'T'),
       (18, 'ABACAXI', 3.30, 'T'),
       (19, 'GOIABA', 2.56, 'T'),
       (20, 'LIMAO', 6.10, 'T'),
       (21, 'UVA', 4.10, 'T'),
       (22, 'AMEIXA SECA', 12.1, 'T'),
       (23, 'FRANGO', 20.1, 'T'),
       (24, 'CARNE BOVINA', 30.12, 'T'),
       (25, 'CENOURA', 1.75, 'T'),
       (26, 'COUVE MANTEIGA', 3.20, 'T'),
       (27, 'CAMARAO', 12.99, 'T'),
       (28, 'OVOS DE GALINHA', 12.70, 'T'),
       (29, 'PEIXES', 40.21, 'T'),
       (30, 'PERU/CHESTER/PERNIL', 20.71, 'T'),
       (31, 'LEITE', 6.29, 'T'),
       (32, 'FARINHA DE TRIGO', 10.20, 'T'),
       (33, 'BATATA', 3.10, 'T'),
       (34, 'ACHOCOLATADO', 12.50, 'T'),
       (35, 'BOLO DE BRIGADEIRO', 20.55, 'T'),
       (36, 'ADOCANTE', 5.51, 'T'),
       (37, 'CAFÉ', 2.21, 'T'),
       (38, 'COCADA', 1.28, 'T'),
       (39, 'ERVILHAS', 6.89, 'T'),
       (40, 'MILHO COZIDO', 2.15, 'T');

--
-- Dumping structure for table `PEDIDOS`
--
CREATE TABLE IF NOT EXISTS `PEDIDOS` (
  `CODIGO` INT(11),
  `CODCLIENTE` INT(11) NOT NULL,
  `DATAEMISSAO` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP(),
  `VALORTOTAL` DECIMAL(10, 2) DEFAULT 0
) 
ENGINE = InnoDB
COLLATE = `utf8mb4_general_ci`;

--
-- Dumping structure for table `PEDIDOSDET`
--
CREATE TABLE IF NOT EXISTS `PEDIDOSDET` (
  `CODIGO` INT(11),
  `SEQUENCIAL` INT(11),
  `CODPRODUTO` INT(11) UNSIGNED  NOT NULL DEFAULT 0,
  `QUANTIDADE` DOUBLE PRECISION NOT NULL DEFAULT 0,
  `PRECOUNITARIO` DECIMAL(10, 2) DEFAULT 0,
  `VALORTOTAL` DECIMAL(10, 2) DEFAULT 0
) 
ENGINE = InnoDB
COLLATE = `utf8mb4_general_ci`;

-- --------------------------------------------------------

--
-- Indexes for dumped tables
--

--
-- Indexes for table `CLIENTES`
--
ALTER TABLE `CLIENTES`
  ADD PRIMARY KEY (`CODIGO`) USING BTREE;

--
-- AUTO_INCREMENT for table `CLIENTES`
--
ALTER TABLE `CLIENTES`
  MODIFY `CODIGO` INT(11) NOT NULL AUTO_INCREMENT;

--
-- CREATE INDEX for table `CLIENTES`
--
CREATE UNIQUE INDEX IDX_COD_CLIENTE ON CLIENTES(CODIGO) USING BTREE;

--
-- Indexes for table `PRODUTOS`
--
ALTER TABLE `PRODUTOS`
  ADD PRIMARY KEY (`CODIGO`) USING BTREE;

--
-- AUTO_INCREMENT for table `PRODUTOS`
--
ALTER TABLE `PRODUTOS`
  MODIFY `CODIGO` INT(11) NOT NULL AUTO_INCREMENT;

--
-- Create Index for table `PRODUTOS`
--
CREATE UNIQUE INDEX IDX_COD_PRODUTO ON PRODUTOS(CODIGO) USING BTREE;

--
-- Indexes for table `PEDIDOS`
--
ALTER TABLE `PEDIDOS`
  ADD PRIMARY KEY (`CODIGO`) USING BTREE, 
  ADD KEY `CODCLIENTE` (CODCLIENTE) USING BTREE;

--
-- AUTO_INCREMENT for table `PEDIDOS`
--
ALTER TABLE `PEDIDOS`
  MODIFY `CODIGO` INT(11) NOT NULL AUTO_INCREMENT;

--
-- Create Index for table `PEDIDOS`
--
CREATE UNIQUE INDEX IDX_COD_PEDIDOS ON PEDIDOS(CODIGO) USING BTREE;

--
-- Indexes for table `PEDIDOSDET`
--
ALTER TABLE `PEDIDOSDET`
  ADD KEY (`SEQUENCIAL`) USING BTREE,
  ADD KEY `CODIGO` (CODIGO) USING BTREE,
  ADD KEY `CODPRODUTO` (CODPRODUTO) USING BTREE;

ALTER TABLE `PEDIDOSDET`
  MODIFY `CODIGO` INT(11) NOT NULL;

--
-- AUTO_INCREMENT for table `PEDIDOSDET`
--
ALTER TABLE `PEDIDOSDET`
  MODIFY `SEQUENCIAL` INT(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Limiters for the table `PEDIDOS`
--
ALTER TABLE `PEDIDOS`
  ADD CONSTRAINT CODCLIENTE FOREIGN KEY (CODIGO) REFERENCES CLIENTES(CODIGO)
  ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limiters for the table `PEDIDOSDET`
--
ALTER TABLE `PEDIDOSDET`
  ADD CONSTRAINT CODPRODUTO FOREIGN KEY (CODIGO) REFERENCES PRODUTOS(CODIGO)
  ON DELETE NO ACTION ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;