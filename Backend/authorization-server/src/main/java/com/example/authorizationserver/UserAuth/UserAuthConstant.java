package com.example.authorizationserver.UserAuth;

import java.util.HashMap;
import java.util.Map;

public class UserAuthConstant {
    public static Map<Integer,String> userTypeToAuthority;
    static {
        userTypeToAuthority = new HashMap<>();
        userTypeToAuthority.put(0,"ADMIN");
        userTypeToAuthority.put(1,"USER");
        userTypeToAuthority.put(0,"DISABLED");
    }
}
