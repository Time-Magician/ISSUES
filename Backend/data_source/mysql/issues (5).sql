/*
 Navicat Premium Data Transfer

 Source Server         : joshua
 Source Server Type    : MySQL
 Source Server Version : 50727
 Source Host           : localhost:3306
 Source Schema         : issues

 Target Server Type    : MySQL
 Target Server Version : 50727
 File Encoding         : 65001

 Date: 07/01/2021 17:24:11
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for alarm_records
-- ----------------------------
DROP TABLE IF EXISTS `alarm_records`;
CREATE TABLE `alarm_records`  (
  `user_id` int(11) NULL DEFAULT NULL,
  `alarm_id` int(11) NULL DEFAULT NULL,
  `frog_id` int(11) NULL DEFAULT NULL,
  `id` int(11) NOT NULL,
  `duration` int(11) NULL DEFAULT NULL,
  `mission` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of alarm_records
-- ----------------------------

-- ----------------------------
-- Table structure for alarms
-- ----------------------------
DROP TABLE IF EXISTS `alarms`;
CREATE TABLE `alarms`  (
  `alarm_id` int(11) NOT NULL,
  `time` time(0) NULL DEFAULT NULL,
  `label` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `audio` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `mission` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `user_id` int(11) NOT NULL,
  `duplicate` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `id` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of alarms
-- ----------------------------
INSERT INTO `alarms` VALUES (145, '17:06:00', '闹钟', 'audio4', '指定物品拍照', 4, '周四 周五', 2);

-- ----------------------------
-- Table structure for frogs
-- ----------------------------
DROP TABLE IF EXISTS `frogs`;
CREATE TABLE `frogs`  (
  `frog_id` int(11) NOT NULL,
  `user_id` int(11) NULL DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `level` int(11) NULL DEFAULT NULL,
  `exp` int(11) NULL DEFAULT NULL,
  `is_graduated` tinyint(1) NULL DEFAULT NULL,
  `graduate_date` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `school` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`frog_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of frogs
-- ----------------------------
INSERT INTO `frogs` VALUES (3, 3, '沈铁柱', 0, 0, 0, '', '电子蝌大');
INSERT INTO `frogs` VALUES (4, 4, '吴翠花', 0, 2, 0, '', '电子蝌大');

-- ----------------------------
-- Table structure for study_records
-- ----------------------------
DROP TABLE IF EXISTS `study_records`;
CREATE TABLE `study_records`  (
  `id` int(11) NOT NULL,
  `start_time` datetime(0) NULL DEFAULT NULL,
  `end_time` datetime(0) NULL DEFAULT NULL,
  `frog_id` int(11) NULL DEFAULT NULL,
  `user_id` int(11) NULL DEFAULT NULL,
  `duration` int(11) NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of study_records
-- ----------------------------
INSERT INTO `study_records` VALUES (1, '2021-01-07 00:00:00', '2021-01-07 00:00:00', 1, 1, 2);
INSERT INTO `study_records` VALUES (2, '2021-01-07 00:00:00', '2021-01-07 00:00:00', 4, 4, 1);

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `user_id` int(11) NOT NULL,
  `username` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `gender` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `tel` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `profile_picture` blob NULL,
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (3, '0UcLhNHCA', '', NULL, NULL, '13890066477', NULL);
INSERT INTO `users` VALUES (4, 'H39onwuXE', '', NULL, NULL, '15867227160', NULL);

-- ----------------------------
-- Table structure for users_auth
-- ----------------------------
DROP TABLE IF EXISTS `users_auth`;
CREATE TABLE `users_auth`  (
  `user_id` int(11) NOT NULL,
  `tel` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `user_type` int(11) NOT NULL,
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of users_auth
-- ----------------------------
INSERT INTO `users_auth` VALUES (3, '13890066477', '$2a$10$naDm5NrXJSR4XWPV.DiUu.4m2KCCzSPBIJSNmtV5MGOER9fdw5rYu', NULL, 1);
INSERT INTO `users_auth` VALUES (4, '15867227160', '$2a$10$5QmOMorJmPgde.dfnAfQ..gJz3j7pot6/PQNjLlQw.LvEnRIyJ.7K', NULL, 1);

SET FOREIGN_KEY_CHECKS = 1;
