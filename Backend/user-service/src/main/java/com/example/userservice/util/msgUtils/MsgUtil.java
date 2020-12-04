package com.example.userservice.util.msgUtils;

public class MsgUtil {

    public static final int SUCCESS = 0;
    public static final int ERROR = -1;
    public static final int LOGIN_USER_ERROR = -100;
    public static final int NOT_LOGGED_IN_ERROR = -101;

    public static final String SUCCESS_MSG = "成功！";
    public static final String LOGIN_SUCCESS_MSG = "登录成功！";
    public static final String LOGOUT_SUCCESS_MSG = "登出成功！";
    public static final String LOGOUT_ERR_MSG = "登出异常！";
    public static final String PERMISSION_DENIED = "你没有相关的权限!";
    public static final String ERROR_MSG = "错误！";
    public static final String LOGIN_USER_ERROR_MSG = "用户名或密码错误，请重新输入！";
    public static final String NOT_LOGGED_IN_ERROR_MSG = "登录失效，请重新登录！";
    public static final String FORBIDDEN_MSG = "您的账号已经被禁用！";
    public static final String SIGNUP_SUCCESS_MSG = "注册成功！";
    public static final String EMAIL_DUPLICATE_MSG = "你的邮箱已被注册！";
    public static final String TEL_DUPLICATE_MSG = "你的电话号码已被注册！";
    public static final String MSG_SENT_SUCCESS_MSG = "验证短信发送成功" ;
    public static final String VERIFY_TRY_AGAIN_MSG = "验证码发送出错了，请重试！";
    public static final String VERIFY_ERROR_MSG = "验证码错误，请重试！";
    public static final String PASSWORD_ERROR = "你的密码是错误的";



    public static Msg makeMsg(MsgCode code, Object data){
        return new Msg(code, data);
    }

    public static Msg makeMsg(MsgCode code, String msg,Object data){
        return new Msg(code, msg, data);
    }

    public static Msg makeMsg(MsgCode code){
        return new Msg(code);
    }

    public static Msg makeMsg(MsgCode code, String msg){
        return new Msg(code, msg);
    }

    public static Msg makeMsg(int status, String msg, Object data){
        return new Msg(status, msg, data);
    }

    public static Msg makeMsg(int status, String msg){
        return new Msg(status, msg);
    }
}
