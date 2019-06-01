<?php

//先回执行应用级别的配置，再执行公共配置
/**
 * 允许ip
 */
defined("SERVER_HOST") || define("SERVER_HOST", "0.0.0.0");

/**
 * 数据库配置
 */
defined("DB_HOST") || define("DB_HOST", "qfmysqlmaster.c23fxhyyvfzs.ap-northeast-1.rds.amazonaws.com");
defined("DB_PORT") || define("DB_PORT", 3306);
defined("DB_USER") || define("DB_USER", "watson");
defined("DB_PASSWORD") || define("DB_PASSWORD", "qfdb1231qaz");
defined("DB_NAME") || define("DB_NAME", "rainbow");

/**
 * session连接配置
 */
defined("SESSION_HOST") || define("SESSION_HOST", "172.31.9.87");
defined("SESSION_PORT") || define("SESSION_PORT", "6379");
defined("SESSION_PASSWORD") || define("SESSION_PASSWORD", "qfproredis");

/**
 * cache连接配置
 */
defined("CACHE_HOST") || define("CACHE_HOST", "172.31.9.76");
defined("CACHE_PORT") || define("CACHE_PORT", "6379");
defined("CACHE_PASSWORD") || define("CACHE_PASSWORD", "qfproredis");

/**
 * ElasticSearch game
 */
defined("ES_GAME_HOST") || define("ES_GAME_HOST", "https://vpc-qf-pre-es-cahce-20190530-6ffbzjpxyz555a5wa3tq4jbeji.ap-northeast-2.es.amazonaws.com");
defined("ES_GAME_PORT") || define("ES_GAME_PORT", "443");

/**
 * ElasticSearch log
 */
defined("ES_LOG_HOST") || define("ES_LOG_HOST", "https://vpc-qf-pre-es-session-20190530-igneik2w4zqbex35zyotwkxzkm.ap-northeast-2.es.amazonaws.com");
defined("ES_LOG_PORT") || define("ES_LOG_PORT", "443");

/**
 * 跨域
 */
defined("COOKIE_DOMAIN") || define("COOKIE_DOMAIN", "");
defined("ALLOW_ORIGINS") || define("ALLOW_ORIGINS", "*"); //*或者多个域名，以逗号分隔，域名包含主机名，如www.aaa.com,expert.aaa.com

/**
 * 上传
 */
defined("UPLOAD_PATH") || define("UPLOAD_PATH", '/home/projects/oss');

/**
 * 登录过期
 */
defined("LOGIN_EXPIRE") || define("LOGIN_EXPIRE", 3600);

/**
 * 用户分组模式
 */
defined("USER_GROUP_MODEL_NAME") || define("USER_GROUP_MODEL_NAME", "AdminGroup");

/**
 * 定时任务
 */
$IG_CRONTAB_COMMON = array(
//    array(
//        "time" => 时间,
//        "task" => array(
//            "path_info" => "路由地址",
//            "data" => array(
//              "get"=>get参数
//              "post"=>post参数
//            )
//        )
//    )
);
