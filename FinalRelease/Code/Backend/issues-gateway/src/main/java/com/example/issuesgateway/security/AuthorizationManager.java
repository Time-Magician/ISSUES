package com.example.issuesgateway.security;

import cn.hutool.core.convert.Convert;
import cn.hutool.core.util.StrUtil;
import com.example.issuesgateway.config.WhiteListConfig;
import com.example.issuesgateway.constant.AuthConstants;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.http.HttpMethod;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.security.authorization.AuthorizationDecision;
import org.springframework.security.authorization.ReactiveAuthorizationManager;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.server.authorization.AuthorizationContext;
import org.springframework.stereotype.Component;
import org.springframework.util.AntPathMatcher;
import org.springframework.util.PathMatcher;
import reactor.core.publisher.Mono;
import java.util.*;

@Component
@AllArgsConstructor
@Slf4j
public class AuthorizationManager implements ReactiveAuthorizationManager<AuthorizationContext> {
    private RedisTemplate redisTemplate;

    @Override
    public Mono<AuthorizationDecision> check(Mono<Authentication> mono, AuthorizationContext authorizationContext) {
        ServerHttpRequest request = authorizationContext.getExchange().getRequest();
        //请求资源
        String path = request.getURI().getPath();
        PathMatcher pathMatcher = new AntPathMatcher();
        // 1. 对应跨域的预检请求直接放行
        if (request.getMethod() == HttpMethod.OPTIONS) {
            return Mono.just(new AuthorizationDecision(true));
        }

        // 2. token为空拒绝访问
        String token = request.getHeaders().getFirst(AuthConstants.JWT_TOKEN_HEADER);
        if (StrUtil.isBlank(token)) {
            return Mono.just(new AuthorizationDecision(false));
        }

        // 3.缓存取资源权限角色关系列表
//        Map<Object, Object> resourceRolesMap = redisTemplate.opsForHash().entries(AuthConstants.RESOURCE_ROLES_KEY);
//        Iterator<Object> iterator = resourceRolesMap.keySet().iterator();

        // 4.请求路径匹配到的资源需要的角色权限集合authorities统计
        List<String> authorities = new ArrayList<>();
        if(pathMatcher.match("/alarm-service/**",path)){
            authorities.add("ROLE_USER");
            authorities.add("ROLE_ADMIN");
        }
        if(pathMatcher.match("/user-service/**",path)){
            authorities.add("ROLE_USER");
            authorities.add("ROLE_ADMIN");
        }
        if(pathMatcher.match("/study-service/**",path)){
            log.info("study-service");
            authorities.add("ROLE_USER");
            authorities.add("ROLE_ADMIN");
        }
        Mono<AuthorizationDecision> authorizationDecisionMono = mono
                .filter(Authentication::isAuthenticated)
                .flatMapIterable(Authentication::getAuthorities)
                .map(GrantedAuthority::getAuthority)
                .any(roleId -> {
                    // 5. roleId是请求用户的角色(格式:ROLE_{roleId})，authorities是请求资源所需要角色的集合
                    log.info("访问路径：{}", path);
                    log.info("用户角色roleId：{}", roleId);
                    log.info("资源需要权限authorities：{}", authorities);
                    return authorities.contains(roleId);
                })
                .map(AuthorizationDecision::new)
                .defaultIfEmpty(new AuthorizationDecision(false));
        return authorizationDecisionMono;
    }
}
