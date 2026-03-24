/*
 Navicat Premium Data Transfer

 Source Server         : kalivm-docker
 Source Server Type    : MySQL
 Source Server Version : 80031
 Source Host           : 192.168.226.128:3306
 Source Schema         : ctoip_db

 Target Server Type    : MySQL
 Target Server Version : 80031
 File Encoding         : 65001

 Date: 19/03/2023 11:20:29
*/

CREATE DATABASE IF NOT EXISTS `ctoip_db`;
USE ctoip_db;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`
(
    `id`         int(0)                                                            NOT NULL,
    `username`   varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci NOT NULL,
    `password`   varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci NOT NULL,
    `created`    datetime(0)                                                       NULL DEFAULT NULL,
    `last_login` datetime(0)                                                       NULL DEFAULT NULL,
    `statu`      int(0)                                                            NULL DEFAULT NULL,
    PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  CHARACTER SET = utf8mb4
  COLLATE = utf8mb4_unicode_520_ci
  ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user`
VALUES (1, 'admin', '$2a$10$oPL2Mkd.WHat66CVEZRxveeofILlS/oLenW9a02/Ck8fl5SkiO9Zi', '2012-12-31 11:30:45',
        '2023-03-02 02:33:51', 1);

SET FOREIGN_KEY_CHECKS = 1;
