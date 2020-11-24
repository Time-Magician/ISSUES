package com.example.userservice.utils.msgUtils;

import net.sf.json.JSONObject;

public class Msg {
    private int status;
    private String msg;
    private Object data;
    private Object extraInfo=null;

    Msg(MsgCode msg, Object data){
        this.status = msg.getStatus();
        this.msg = msg.getMsg();
        this.data = data;
    }

    Msg(MsgCode msg, String extra, Object data){
        this.status = msg.getStatus();
        this.msg = extra;
        this.data = data;
    }

    Msg(MsgCode msg){
        this.status = msg.getStatus();
        this.msg = msg.getMsg();
        this.data = null;
    }

    Msg(MsgCode msg, String extra){
        this.status = msg.getStatus();
        this.msg = extra;
        this.data = null;
    }

    Msg(int status, String extra, Object data){
        this.status = status;
        this.msg = extra;
        this.data = data;
    }

    Msg(int status, String extra){
        this.status = status;
        this.msg = extra;
        this.data = null;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }

    public Object getExtraInfo() {
        return extraInfo;
    }

    public void setExtraInfo(Object extraInfo) {
        this.extraInfo = extraInfo;
    }

}
