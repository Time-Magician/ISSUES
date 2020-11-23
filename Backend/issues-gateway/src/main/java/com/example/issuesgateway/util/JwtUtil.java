package com.example.issuesgateway.util;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;

public class JwtUtil {
    public static Claims parseJWT(String jwt) throws Exception {
        return Jwts.parser()
                .parseClaimsJwt(jwt)
                .getBody();
    }
}
