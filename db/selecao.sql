﻿--
-- Script was generated by Devart dbForge Studio for MySQL, Version 7.0.52.0
-- Product home page: http://www.devart.com/dbforge/mysql/studio
-- Script date 16/06/2016 21:17:28
-- Server version: 5.6.17
-- Client version: 4.1
--


--
-- Disable foreign keys
--
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

--
-- Set SQL mode
--
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

--
-- Set character set the client will use to send SQL statements to the server
--
SET NAMES 'utf8';

--
-- Create database "selecao_fullstack"
--
CREATE DATABASE selecao_fullstack
  CHARACTER SET utf8
  COLLATE utf8_general_ci;

--
-- Set default database
--
USE selecao_fullstack;

--
-- Definition for table animal
--
DROP TABLE IF EXISTS animal;
CREATE TABLE animal (
  ani_int_codigo INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Código',
  ran_int_codigo INT(11) UNSIGNED NULL COMMENT 'Raça',
  pro_int_codigo INT(11) UNSIGNED NULL COMMENT 'Proprietário',
  ani_var_nome VARCHAR(50) NOT NULL COMMENT 'Nome',
  ani_cha_vivo CHAR(1) NOT NULL DEFAULT 'S' COMMENT 'Vivo|S:Sim;N:Não',
  ani_dec_peso DECIMAL(8, 3) DEFAULT NULL COMMENT 'Peso',
  ani_dti_inclusao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Inclusão',
  PRIMARY KEY (ani_int_codigo),
  CONSTRAINT FK_animal_raca_animal_ran_int_codigo FOREIGN KEY (ran_int_codigo)
    REFERENCES raca_animal(ran_int_codigo) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT FK_animal_proprietario_pro_int_codigo FOREIGN KEY (pro_int_codigo)
    REFERENCES proprietario(pro_int_codigo) ON DELETE RESTRICT ON UPDATE RESTRICT
)
ENGINE = INNODB
AUTO_INCREMENT = 1
AVG_ROW_LENGTH = 8192
CHARACTER SET utf8
COLLATE utf8_general_ci
COMMENT = 'Animal';

--
-- Definition for table usuario
--
DROP TABLE IF EXISTS usuario;
CREATE TABLE usuario (
  usu_int_codigo INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Código',
  usu_var_nome VARCHAR(50) NOT NULL COMMENT 'Nome',
  usu_var_email VARCHAR(100) NOT NULL COMMENT 'Email',
  usu_cha_status CHAR(1) NOT NULL DEFAULT 'A' COMMENT 'Status|A:Ativo;I:Inativo',
  usu_dti_inclusao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Inclusão',
  PRIMARY KEY (usu_int_codigo),
  INDEX IDX_usuario_usu_dti_inclusao (usu_dti_inclusao),
  INDEX IDX_usuario_usu_var_nome (usu_var_nome),
  UNIQUE INDEX UK_usuario_usu_var_email (usu_var_email)
)
ENGINE = INNODB
AUTO_INCREMENT = 1
AVG_ROW_LENGTH = 16384
CHARACTER SET utf8
COLLATE utf8_general_ci
COMMENT = 'Usuario';

--
-- Definition for table vacina
--
DROP TABLE IF EXISTS vacina;
CREATE TABLE vacina (
  vac_int_codigo INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Código',
  vac_var_nome VARCHAR(50) NOT NULL COMMENT 'Nome',
  vac_dti_inclusao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Inclusão',
  PRIMARY KEY (vac_int_codigo)
)
ENGINE = INNODB
AUTO_INCREMENT = 1
AVG_ROW_LENGTH = 5461
CHARACTER SET utf8
COLLATE utf8_general_ci
COMMENT = 'Vacina';

--
-- Definition for table animal_vacina
--
DROP TABLE IF EXISTS animal_vacina;
CREATE TABLE animal_vacina (
  anv_int_codigo INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Codigo',
  ani_int_codigo INT(11) UNSIGNED NOT NULL COMMENT 'Animal',
  vac_int_codigo INT(11) UNSIGNED NOT NULL COMMENT 'Vacina',
  anv_dat_programacao DATE NOT NULL COMMENT 'Data Programacao',
  anv_dti_aplicacao DATETIME DEFAULT NULL COMMENT 'Data Aplicacao',
  usu_int_codigo INT(11) UNSIGNED DEFAULT NULL COMMENT 'Usuario que aplicou',
  anv_dti_inclusao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Inclusao',
  PRIMARY KEY (anv_int_codigo),
  CONSTRAINT FK_animal_vacina_animal_ani_int_codigo FOREIGN KEY (ani_int_codigo)
    REFERENCES animal(ani_int_codigo) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT FK_animal_vacina_usuario_usu_int_codigo FOREIGN KEY (usu_int_codigo)
    REFERENCES usuario(usu_int_codigo) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT FK_animal_vacina_vacina_vac_int_codigo FOREIGN KEY (vac_int_codigo)
    REFERENCES vacina(vac_int_codigo) ON DELETE RESTRICT ON UPDATE RESTRICT
)
ENGINE = INNODB
AUTO_INCREMENT = 1
AVG_ROW_LENGTH = 16384
CHARACTER SET utf8
COLLATE utf8_general_ci
COMMENT = 'AnimalVacina||Agenda de Vacinação';

--
-- Definition for table raça_animal
--
DROP TABLE IF EXISTS raca_animal;
CREATE TABLE raca_animal (
  ran_int_codigo INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Código',
  ran_var_nome VARCHAR(50) NOT NULL COMMENT 'Nome',
  ran_dti_inclusao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Inclusão',
  PRIMARY KEY (ran_int_codigo)
)
ENGINE = INNODB
AUTO_INCREMENT = 1
AVG_ROW_LENGTH = 5461
CHARACTER SET utf8
COLLATE utf8_general_ci
COMMENT = 'Raça de Animal';

--
-- Definition for table proprietario
--
DROP TABLE IF EXISTS proprietario;
CREATE TABLE proprietario (
  pro_int_codigo INT(11) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Código',
  pro_var_nome VARCHAR(50) NOT NULL COMMENT 'Nome',
  pro_var_email VARCHAR(100) NOT NULL COMMENT 'Email',
  pro_var_telefone VARCHAR(14) NOT NULL COMMENT 'Telefone',
  pro_dti_inclusao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Inclusão',
  PRIMARY KEY (pro_int_codigo)
)
ENGINE = INNODB
AUTO_INCREMENT = 1
AVG_ROW_LENGTH = 5461
CHARACTER SET utf8
COLLATE utf8_general_ci
COMMENT = 'Proprietário';

DELIMITER $$

--
-- Definition for procedure sp_animalvacina_aplica
--
DROP PROCEDURE IF EXISTS sp_animalvacina_aplica$$
CREATE PROCEDURE sp_animalvacina_aplica(IN p_anv_int_codigo INT(11), IN p_ani_int_codigo INT(11), IN p_usu_int_codigo INT(11), IN p_aplica CHAR(1), INOUT p_status BOOLEAN, INOUT p_msg TEXT)
  SQL SECURITY INVOKER
  COMMENT 'Procedure de Update'
BEGIN

  DECLARE v_existe boolean;
  DECLARE v_ani_cha_vivo char(1);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SET p_status = FALSE;
    SET p_msg = 'Erro ao executar o procedimento.';
  END;

  SET p_msg = '';
  SET p_status = FALSE;


    -- VALIDACOES
   SELECT IF(count(1) = 0, FALSE, TRUE)
  INTO v_existe
  FROM animal_vacina
  WHERE anv_int_codigo = p_anv_int_codigo;
  IF NOT v_existe THEN
    SET p_msg = concat(p_msg, 'Registro não encontrado.<br />');
  END IF;

  -- VALIDAÇÕES
  SELECT a.ani_cha_vivo
  INTO v_ani_cha_vivo
  FROM animal a
  WHERE a.ani_int_codigo = p_ani_int_codigo;
  IF v_ani_cha_vivo = 'N' THEN
    SET p_msg = CONCAT(p_msg, 'Não pode ser programada uma vacina para um animal morto. <br />');
   END IF;

  IF p_aplica NOT IN ('S', 'N') THEN
    SET p_msg = CONCAT(p_msg, 'Tipo de Aplicação Inválido. <br />');
  END IF;

  IF p_msg = '' THEN

    START TRANSACTION;

    UPDATE animal_vacina SET
      anv_dti_aplicacao = IF(p_aplica = 'S', CURRENT_TIMESTAMP(), NULL),
      usu_int_codigo = IF(p_aplica = 'S',  p_usu_int_codigo, NULL)
    WHERE anv_int_codigo = p_anv_int_codigo;

    COMMIT;

    SET p_status = TRUE;
    SET p_msg = 'O registro foi alterado com sucesso.';

  END IF;

END
$$

--
-- Definition for procedure sp_animalvacina_del
--
DROP PROCEDURE IF EXISTS sp_animalvacina_del$$
CREATE PROCEDURE sp_animalvacina_del(IN p_anv_int_codigo INT(11), INOUT p_status BOOLEAN, INOUT p_msg TEXT)
  SQL SECURITY INVOKER
  COMMENT 'Procedure de Delete'
BEGIN

  DECLARE v_existe BOOLEAN;
  DECLARE v_row_count int DEFAULT 0;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SET p_status = FALSE;
    SET p_msg = 'Erro ao executar o procedimento.';
  END;

  SET p_msg = '';
  SET p_status = FALSE;

  -- VALIDAÇÕES
  SELECT IF(count(1) = 0, FALSE, TRUE)
  INTO v_existe
  FROM animal_vacina
  WHERE anv_int_codigo = p_anv_int_codigo;
  IF NOT v_existe THEN
    SET p_msg = concat(p_msg, 'Registro não encontrado.<br />');
  END IF;

  IF p_msg = '' THEN

    START TRANSACTION;

    DELETE FROM animal_vacina
    WHERE anv_int_codigo = p_anv_int_codigo;

    SELECT ROW_COUNT() INTO v_row_count;

    COMMIT;

    IF (v_row_count > 0) THEN
      SET p_status = TRUE;
      SET p_msg = 'O Registro foi excluído com sucesso';
    END IF;

  END IF;

END
$$


--
-- Definition for procedure sp_animal_del
--
DROP PROCEDURE IF EXISTS sp_animal_del$$
CREATE PROCEDURE sp_animal_del(IN p_ani_int_codigo INT(11), INOUT p_status BOOLEAN, INOUT p_msg TEXT)
  SQL SECURITY INVOKER
  COMMENT 'Procedure de Delete'
BEGIN

  DECLARE v_existe BOOLEAN;
  DECLARE v_row_count int DEFAULT 0;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SET p_status = FALSE;
    SET p_msg = 'Erro ao executar o procedimento.';
  END;

  SET p_msg = '';
  SET p_status = FALSE;

  -- VALIDAÇÕES
  SELECT IF(count(1) = 0, FALSE, TRUE)
  INTO v_existe
  FROM animal
  WHERE ani_int_codigo = p_ani_int_codigo;
  IF NOT v_existe THEN
    SET p_msg = concat(p_msg, 'Registro não encontrado.<br />');
  END IF;

  IF p_msg = '' THEN

    START TRANSACTION;

    DELETE FROM animal
    WHERE ani_int_codigo = p_ani_int_codigo;

    SELECT ROW_COUNT() INTO v_row_count;

    COMMIT;

    IF (v_row_count > 0) THEN
      SET p_status = TRUE;
      SET p_msg = 'O Registro foi excluído com sucesso';
    END IF;

  END IF;

END
$$

--
-- Definition for procedure sp_animal_ins
--
DROP PROCEDURE IF EXISTS sp_animal_ins$$
CREATE PROCEDURE sp_animal_ins(IN p_ran_int_codigo INT(11), IN p_pro_int_codigo INT(11), IN p_ani_var_nome VARCHAR(50), IN p_ani_dec_peso DECIMAL(8,3), IN p_ani_cha_vivo CHAR(1), INOUT p_status BOOLEAN, INOUT p_msg TEXT, INOUT p_insert_id INT(11))
  SQL SECURITY INVOKER
  COMMENT 'Procedure de Insert'
BEGIN

  DECLARE v_existe boolean;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SET p_status = FALSE;
    SET p_msg = 'Erro ao executar o procedimento.';
  END;

  SET p_msg = '';
  SET p_status = FALSE;

  -- VALIDAÇÕES
  IF p_ani_var_nome IS NULL THEN
    SET p_msg = concat(p_msg, 'Nome não informado.<br />');
  END IF;
  IF p_ani_cha_vivo IS NULL THEN
    SET p_msg = concat(p_msg, 'Status não informado.<br />');
  ELSE
    IF p_ani_cha_vivo NOT IN ('S','N') THEN
      SET p_msg = concat(p_msg, 'Status inválido.<br />');
    END IF;
  END IF;

  IF p_msg = '' THEN

    START TRANSACTION;

    INSERT INTO animal (ran_int_codigo, pro_int_codigo, ani_var_nome, ani_dec_peso, ani_cha_vivo)
    VALUES (p_ran_int_codigo, p_pro_int_codigo, p_ani_var_nome, p_ani_dec_peso, p_ani_cha_vivo);

    COMMIT;

    SET p_status = TRUE;
    SET p_msg = 'Um novo registro foi inserido com sucesso.';
    SET p_insert_id = LAST_INSERT_ID();

  END IF;

END
$$

--
-- Definition for procedure sp_usuario_del
--
DROP PROCEDURE IF EXISTS sp_usuario_del$$
CREATE PROCEDURE sp_usuario_del(IN p_usu_int_codigo INT(11), INOUT p_status BOOLEAN, INOUT p_msg TEXT)
  SQL SECURITY INVOKER
  COMMENT 'Procedure de Delete'
BEGIN

  DECLARE v_existe BOOLEAN;
  DECLARE v_row_count int DEFAULT 0;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SET p_status = FALSE;
    SET p_msg = 'Erro ao executar o procedimento.';
  END;

  SET p_msg = '';
  SET p_status = FALSE;

  -- VALIDAÇÕES
  SELECT IF(count(1) = 0, FALSE, TRUE)
  INTO v_existe
  FROM usuario
  WHERE usu_int_codigo = p_usu_int_codigo;
  IF NOT v_existe THEN
    SET p_msg = concat(p_msg, 'Registro não encontrado.<br />');
  END IF;

  IF p_msg = '' THEN

    START TRANSACTION;

    DELETE FROM usuario
    WHERE usu_int_codigo = p_usu_int_codigo;

    SELECT ROW_COUNT() INTO v_row_count;

    COMMIT;

    IF (v_row_count > 0) THEN
      SET p_status = TRUE;
      SET p_msg = 'O Registro foi excluído com sucesso';
    END IF;

  END IF;

END
$$

--
-- Definition for procedure sp_usuario_ins
--
DROP PROCEDURE IF EXISTS sp_usuario_ins$$
CREATE PROCEDURE sp_usuario_ins(IN p_usu_var_nome VARCHAR(50), IN p_usu_var_email VARCHAR(100), IN p_usu_cha_status CHAR(1), INOUT p_status BOOLEAN, INOUT p_msg TEXT, INOUT p_insert_id INT(11))
  SQL SECURITY INVOKER
  COMMENT 'Procedure de Insert'
BEGIN

  DECLARE v_existe boolean;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SET p_status = FALSE;
    SET p_msg = 'Erro ao executar o procedimento.';
  END;

  SET p_msg = '';
  SET p_status = FALSE;

  -- VALIDAÇÕES
  IF p_usu_var_nome IS NULL THEN
    SET p_msg = concat(p_msg, 'Nome não informado.<br />');
  END IF;
  IF p_usu_var_email IS NULL THEN
    SET p_msg = concat(p_msg, 'Email não informado.<br />');
  ELSE
    IF p_usu_var_email NOT REGEXP '^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$' THEN
      SET p_msg = concat(p_msg, 'Email em formato inválido.<br />');
    END IF;
  END IF;
  IF p_usu_cha_status IS NULL THEN
    SET p_msg = concat(p_msg, 'Status não informado.<br />');
  ELSE
    IF p_usu_cha_status NOT IN ('A','I') THEN
      SET p_msg = concat(p_msg, 'Status inválido.<br />');
    END IF;
  END IF;

  SELECT IF(COUNT(1) > 0, TRUE, FALSE)
  INTO v_existe
  FROM usuario
  WHERE usu_var_email = p_usu_var_email;
  IF v_existe THEN
    SET p_msg = concat(p_msg, 'Já existe usuário com este email.<br />');
  END IF;

  IF p_msg = '' THEN

    START TRANSACTION;

    INSERT INTO usuario (usu_var_nome, usu_var_email, usu_cha_status)
    VALUES (p_usu_var_nome, p_usu_var_email, p_usu_cha_status);

    COMMIT;

    SET p_status = TRUE;
    SET p_msg = 'Um novo registro foi inserido com sucesso.';
    SET p_insert_id = LAST_INSERT_ID();

  END IF;

END
$$

--
-- Definition for procedure sp_usuario_upd
--
DROP PROCEDURE IF EXISTS sp_usuario_upd$$
CREATE PROCEDURE sp_usuario_upd(IN p_usu_int_codigo INT(11), IN p_usu_var_nome VARCHAR(50), IN p_usu_var_email VARCHAR(100), IN p_usu_cha_status CHAR(1), INOUT p_status BOOLEAN, INOUT p_msg TEXT)
  SQL SECURITY INVOKER
  COMMENT 'Procedure de Update'
BEGIN

  DECLARE v_existe BOOLEAN;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SET p_status = FALSE;
    SET p_msg = 'Erro ao executar o procedimento.';
  END;

  SET p_msg = '';
  SET p_status = FALSE;

  -- VALIDAÇÕES
  SELECT IF(count(1) = 0, FALSE, TRUE)
  INTO v_existe
  FROM usuario
  WHERE usu_int_codigo = p_usu_int_codigo;
  IF NOT v_existe THEN
    SET p_msg = concat(p_msg, 'Registro não encontrado.<br />');
  END IF;

  -- VALIDAÇÕES
  IF p_usu_int_codigo IS NULL THEN
    SET p_msg = concat(p_msg, 'Código não informado.<br />');
  END IF;
  IF p_usu_var_nome IS NULL THEN
    SET p_msg = concat(p_msg, 'Nome não informado.<br />');
  END IF;
  IF p_usu_var_email IS NULL THEN
    SET p_msg = concat(p_msg, 'Email não informado.<br />');
  ELSE
    IF p_usu_var_email NOT REGEXP '^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$' THEN
      SET p_msg = concat(p_msg, 'Email em formato inválido.<br />');
    END IF;
  END IF;
  IF p_usu_cha_status IS NULL THEN
    SET p_msg = concat(p_msg, 'Status não informado.<br />');
  ELSE
    IF p_usu_cha_status NOT IN ('A','I') THEN
      SET p_msg = concat(p_msg, 'Status inválido.<br />');
    END IF;
  END IF;

  SELECT IF(COUNT(1) > 0, TRUE, FALSE)
  INTO v_existe
  FROM usuario
  WHERE usu_var_email = p_usu_var_email
        AND usu_int_codigo <> p_usu_int_codigo;
  IF v_existe THEN
    SET p_msg = concat(p_msg, 'Já existe usuário com este email.<br />');
  END IF;

  IF p_msg = '' THEN

    START TRANSACTION;

    UPDATE usuario
    SET usu_var_nome = p_usu_var_nome,
        usu_var_email = p_usu_var_email,
        usu_cha_status = p_usu_cha_status
    WHERE usu_int_codigo = p_usu_int_codigo;

    COMMIT;

    SET p_status = TRUE;
    SET p_msg = 'O registro foi alterado com sucesso';

  END IF;

END
$$

---------------------------------------------------------------------

-- PROCEDURES DE PROPRIETÁRIO

--
-- Definition for procedure sp_proprietario_del
--
DROP PROCEDURE IF EXISTS sp_proprietario_del$$
CREATE PROCEDURE sp_proprietario_del(IN p_pro_int_codigo INT(11), INOUT p_status BOOLEAN, INOUT p_msg TEXT)
  SQL SECURITY INVOKER
  COMMENT 'Procedure de Delete'
BEGIN

  DECLARE v_existe BOOLEAN;
  DECLARE v_row_count int DEFAULT 0;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SET p_status = FALSE;
    SET p_msg = 'Erro ao executar o procedimento.';
  END;

  SET p_msg = '';
  SET p_status = FALSE;

  -- VALIDAÇÕES
  SELECT IF(count(1) = 0, FALSE, TRUE)
  INTO v_existe
  FROM proprietario
  WHERE pro_int_codigo = p_pro_int_codigo;
  IF NOT v_existe THEN
    SET p_msg = concat(p_msg, 'Registro não encontrado.<br />');
  END IF;

  IF p_msg = '' THEN

    START TRANSACTION;

    DELETE FROM proprietario
    WHERE pro_int_codigo = p_pro_int_codigo;

    SELECT ROW_COUNT() INTO v_row_count;

    COMMIT;

    IF (v_row_count > 0) THEN
      SET p_status = TRUE;
      SET p_msg = 'O Registro foi excluído com sucesso';
    END IF;

  END IF;

END
$$


--
-- Definition for procedure sp_proprietario_ins
--
DROP PROCEDURE IF EXISTS sp_proprietario_ins$$
CREATE PROCEDURE sp_proprietario_ins(IN p_pro_var_nome VARCHAR(50), IN p_pro_var_email VARCHAR(100), IN p_pro_var_telefone VARCHAR(14), INOUT p_status BOOLEAN, INOUT p_msg TEXT, INOUT p_insert_id INT(11))
  SQL SECURITY INVOKER
  COMMENT 'Procedure de Insert'
BEGIN

  DECLARE v_existe boolean;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SET p_status = FALSE;
    SET p_msg = 'Erro ao executar o procedimento.';
  END;

  SET p_msg = '';
  SET p_status = FALSE;

  -- VALIDAÇÕES
  IF p_pro_var_nome IS NULL THEN
    SET p_msg = concat(p_msg, 'Nome não informado.<br />');
  END IF;
  IF p_pro_var_email IS NULL THEN
    SET p_msg = concat(p_msg, 'Email não informado.<br />');
  ELSE
    IF p_pro_var_email NOT REGEXP '^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$' THEN
      SET p_msg = concat(p_msg, 'Email em formato inválido.<br />');
    END IF;
  END IF;
  IF p_pro_var_telefone IS NULL THEN
    SET p_msg = concat(p_msg, 'Telefone não informado.<br />');
  END IF;

  SELECT IF(COUNT(1) > 0, TRUE, FALSE)
  INTO v_existe
  FROM proprietario
  WHERE pro_var_email = p_pro_var_email;
  IF v_existe THEN
    SET p_msg = concat(p_msg, 'Já existe proprietário com este email.<br />');
  END IF;

  IF p_msg = '' THEN

    START TRANSACTION;

    INSERT INTO proprietario (pro_var_nome, pro_var_email, pro_var_telefone)
    VALUES (p_pro_var_nome, p_pro_var_email, p_pro_var_telefone);

    COMMIT;

    SET p_status = TRUE;
    SET p_msg = 'Um novo registro foi inserido com sucesso.';
    SET p_insert_id = LAST_INSERT_ID();

  END IF;

END
$$


--
-- Definition for procedure sp_proprietario_upd
--
DROP PROCEDURE IF EXISTS sp_proprietario_upd$$
CREATE PROCEDURE sp_proprietario_upd(IN p_pro_int_codigo INT(11), IN p_pro_var_nome VARCHAR(50), IN p_pro_var_email VARCHAR(100), IN p_pro_var_telefone VARCHAR(14), INOUT p_status BOOLEAN, INOUT p_msg TEXT)
  SQL SECURITY INVOKER
  COMMENT 'Procedure de Update'
BEGIN

  DECLARE v_existe BOOLEAN;

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    SET p_status = FALSE;
    SET p_msg = 'Erro ao executar o procedimento.';
  END;

  SET p_msg = '';
  SET p_status = FALSE;

  -- VALIDAÇÕES
  SELECT IF(count(1) = 0, FALSE, TRUE)
  INTO v_existe
  FROM proprietario
  WHERE pro_int_codigo = p_pro_int_codigo;
  IF NOT v_existe THEN
    SET p_msg = concat(p_msg, 'Registro não encontrado.<br />');
  END IF;

  -- VALIDAÇÕES
  IF p_pro_int_codigo IS NULL THEN
    SET p_msg = concat(p_msg, 'Código não informado.<br />');
  END IF;
  IF p_pro_var_nome IS NULL THEN
    SET p_msg = concat(p_msg, 'Nome não informado.<br />');
  END IF;
  IF p_pro_var_email IS NULL THEN
    SET p_msg = concat(p_msg, 'Email não informado.<br />');
  ELSE
    IF p_pro_var_email NOT REGEXP '^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$' THEN
      SET p_msg = concat(p_msg, 'Email em formato inválido.<br />');
    END IF;
  END IF;
  IF p_pro_var_telefone IS NULL THEN
    SET p_msg = concat(p_msg, 'Telefone não informado.<br />');
  END IF;

  SELECT IF(COUNT(1) > 0, TRUE, FALSE)
  INTO v_existe
  FROM proprietario
  WHERE pro_var_email = p_pro_var_email
        AND pro_int_codigo <> p_pro_int_codigo;
  IF v_existe THEN
    SET p_msg = concat(p_msg, 'Já existe proprietário com este email.<br />');
  END IF;

  IF p_msg = '' THEN

    START TRANSACTION;

    UPDATE proprietario
    SET pro_var_nome = p_pro_var_nome,
        pro_var_email = p_pro_var_email,
        pro_var_telefone = p_pro_var_telefone
    WHERE pro_int_codigo = p_pro_int_codigo;

    COMMIT;

    SET p_status = TRUE;
    SET p_msg = 'O registro foi alterado com sucesso';

  END IF;

END
$$


DELIMITER ;

--
-- Definition for view vw_animal
--
DROP VIEW IF EXISTS vw_animal CASCADE;
CREATE OR REPLACE
  SQL SECURITY INVOKER
VIEW vw_animal
AS
  select `animal`.`ani_int_codigo` AS `ani_int_codigo`,`animal`.`ani_var_nome` AS `ani_var_nome`,`animal`.`ani_dec_peso` AS `ani_dec_peso`, `raca_animal`.`ran_var_nome` AS `ran_var_nome`, `proprietario`.`pro_var_nome` AS `pro_var_nome`, `animal`.`ani_cha_vivo` AS `ani_cha_vivo`, (case `animal`.`ani_cha_vivo` when 'S' then 'Sim' when 'N' then 'Não' end) AS `ani_var_vivo`, `animal`.`ani_dti_inclusao` AS `ani_dti_inclusao`,date_format(`animal`.`ani_dti_inclusao`,'%d/%m/%Y %H:%i:%s') AS `ani_dtf_inclusao` from `animal` inner join `raca_animal` on `animal`.`ran_int_codigo` = `raca_animal`.`ran_int_codigo` inner join proprietario on `animal`.`pro_int_codigo` = `proprietario`.`pro_int_codigo`;


--
-- Definition for view vw_usuario
--
DROP VIEW IF EXISTS vw_usuario CASCADE;
CREATE OR REPLACE
  SQL SECURITY INVOKER
VIEW vw_usuario
AS
  select `usuario`.`usu_int_codigo` AS `usu_int_codigo`,`usuario`.`usu_var_nome` AS `usu_var_nome`,`usuario`.`usu_var_email` AS `usu_var_email`,`usuario`.`usu_cha_status` AS `usu_cha_status`,(case `usuario`.`usu_cha_status` when 'A' then 'Ativo' when 'I' then 'Inativo' end) AS `usu_var_status`,`usuario`.`usu_dti_inclusao` AS `usu_dti_inclusao`,date_format(`usuario`.`usu_dti_inclusao`,'%d/%m/%Y %H:%i:%s') AS `usu_dtf_inclusao` from `usuario`;

--
-- Definition for view vw_vacina
--
DROP VIEW IF EXISTS vw_vacina CASCADE;
CREATE OR REPLACE
  SQL SECURITY INVOKER
VIEW vw_vacina
AS
  select `vacina`.`vac_int_codigo` AS `vac_int_codigo`,`vacina`.`vac_var_nome` AS `vac_var_nome`,`vacina`.`vac_dti_inclusao` AS `vac_dti_inclusao`,date_format(`vacina`.`vac_dti_inclusao`,'%d/%m/%Y %H:%i:%s') AS `vac_dtf_inclusao` from `vacina`;


--
-- Definition for view vw_proprietario
--
DROP VIEW IF EXISTS vw_proprietario CASCADE;
CREATE OR REPLACE
  SQL SECURITY INVOKER
VIEW vw_proprietario
AS
  select `proprietario`.`pro_int_codigo` AS `pro_int_codigo`,`proprietario`.`pro_var_nome` AS `pro_var_nome`,`proprietario`.`pro_var_email` AS `pro_var_email`,`proprietario`.`pro_var_telefone` AS `pro_var_telefone`,`proprietario`.`pro_dti_inclusao` AS `pro_dti_inclusao`,date_format(`proprietario`.`pro_dti_inclusao`,'%d/%m/%Y %H:%i:%s') AS `pro_dtf_inclusao` from `proprietario`;



--
-- Dumping data for table usuario
--
INSERT INTO usuario VALUES
(1, 'Joe', 'joe@doe.com', 'A', '2016-03-25 13:23:14');

--
-- Dumping data for table vacina
--
INSERT INTO vacina VALUES
(1, 'Vanguard', '2016-03-25 15:03:35'),
(2, 'Anti-rábica', '2016-03-25 15:03:44'),
(3, 'Leshimune', '2016-03-25 15:04:15');

--
-- Dumping data for table raca_animal
--
INSERT INTO raca_animal VALUES
(1, 'Cachorro - Poodle', '2018-01-17 15:03:35'),
(2, 'Cachorro - Bull Terrier', '2018-01-17 15:03:44'),
(3, 'Gato - Siamês', '2018-01-17 15:04:15'),
(4, 'Gato - Sphynx', '2018-01-17 15:04:15'),
(5, 'Cavalo - Mangalarga', '2018-01-17 15:04:15');

--
-- Restore previous SQL mode
--
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;

--
-- Enable foreign keys
--
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;

--
-- Create user "selecao_fullstack"
--
CREATE USER 'selecao_fullstack'@'localhost';
GRANT ALL PRIVILEGES ON *.* TO 'selecao_fullstack'@'localhost'
WITH GRANT OPTION;
SET PASSWORD FOR 'selecao_fullstack'@'localhost' = PASSWORD ('barcelona');
GRANT SELECT, INSERT, UPDATE, DELETE, ALTER, ALTER ROUTINE, CREATE, CREATE ROUTINE, CREATE TEMPORARY TABLES, CREATE VIEW, DROP, EVENT, EXECUTE, GRANT OPTION, INDEX, LOCK TABLES, REFERENCES, SHOW VIEW, TRIGGER ON selecao_fullstack.* TO 'selecao_fullstack'@'localhost';