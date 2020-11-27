package com.example.userservice.util.msgUtils;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.aliyuncs.CommonRequest;
import com.aliyuncs.CommonResponse;
import com.aliyuncs.DefaultAcsClient;
import com.aliyuncs.IAcsClient;
import com.aliyuncs.exceptions.ClientException;
import com.aliyuncs.exceptions.ServerException;
import com.aliyuncs.http.MethodType;
import com.aliyuncs.profile.DefaultProfile;

import javax.persistence.criteria.CriteriaBuilder;
import java.util.Random;

public class SendSmsUtil {
    public static Boolean sendSms(String tel) {
        DefaultProfile profile = DefaultProfile.getProfile("cn-hangzhou", "LTAI4G9pM8bq5fpppJ8abL4t", "ZPPBwfScC77YkNDLVO3BVj8nE4u7bk");
        IAcsClient client = new DefaultAcsClient(profile);

        String VerificationCode = RandomNumber();

        CommonRequest request = new CommonRequest();
        request.setSysMethod(MethodType.POST);
        request.setSysDomain("dysmsapi.aliyuncs.com");
        request.setSysVersion("2017-05-25");
        request.setSysAction("SendSms");
        request.putQueryParameter("RegionId", "cn-hangzhou");
        request.putQueryParameter("PhoneNumbers", tel);
        request.putQueryParameter("SignName", "一心APP");
        request.putQueryParameter("TemplateCode", "SMS_205881573");
        request.putQueryParameter("TemplateParam", "{\"code\":"+VerificationCode+"}");
        try {
            CommonResponse response = client.getCommonResponse(request);
            String responseData  = response.getData();
            JSONObject jsonObject = JSONObject.parseObject(responseData);
            if(jsonObject.getString("Code").equals("OK")){
                return true;
            }
            else
                return false;
        } catch (ServerException e) {
            e.printStackTrace();
            return false;
        } catch (ClientException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static String RandomNumber(){
        Integer max=999999,min=100000;
        Integer ran = (int) (Math.random()*(max-min)+min);
        System.out.println(ran.toString());
        return ran.toString();
    }
}
