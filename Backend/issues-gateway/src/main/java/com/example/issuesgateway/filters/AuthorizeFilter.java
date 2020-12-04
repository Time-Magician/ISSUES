package com.example.issuesgateway.filters;

import cn.hutool.core.util.StrUtil;
import cn.hutool.json.JSONObject;
import cn.hutool.json.JSONUtil;
import com.example.issuesgateway.constant.AuthConstants;
import com.nimbusds.jose.JWSObject;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.apache.logging.log4j.util.Strings;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.cloud.gateway.filter.GlobalFilter;
import org.springframework.core.Ordered;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.text.ParseException;

@Slf4j
@Component
public class AuthorizeFilter implements GlobalFilter, Ordered {
    @Autowired
    RestTemplate restTemplate;
    @SneakyThrows
    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        log.info("here");
        String token = exchange.getRequest().getHeaders().getFirst(AuthConstants.JWT_TOKEN_HEADER);
        if (StrUtil.isBlank(token)) {
            return chain.filter(exchange);
        }
        log.info("here1");
        token = token.replace(AuthConstants.JWT_TOKEN_PREFIX, Strings.EMPTY);
        JWSObject jwsObject = null;
        try {
            jwsObject = JWSObject.parse(token);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        String payload = jwsObject.getPayload().toString();
        JSONObject jsonObject = JSONUtil.parseObj(payload);
        //解析出accessToken中Jwt中的参数
        ServerHttpRequest request = exchange.getRequest().mutate().header("userId", jsonObject.getStr("userId"))
                .header("userType",jsonObject.getStr("userType")).build();
        return chain.filter(exchange.mutate().request(request).build());
    }

    @Override
    public int getOrder() {
        return 0;
    }
}
