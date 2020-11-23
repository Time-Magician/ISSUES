package com.example.authorizationserver.config;

import com.example.authorizationserver.UserAuth.UserAuth;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.core.io.ClassPathResource;
import org.springframework.security.oauth2.common.DefaultOAuth2AccessToken;
import org.springframework.security.oauth2.common.OAuth2AccessToken;
import org.springframework.security.oauth2.provider.OAuth2Authentication;
import org.springframework.security.oauth2.provider.token.DefaultTokenServices;
import org.springframework.security.oauth2.provider.token.TokenEnhancer;
import org.springframework.security.oauth2.provider.token.TokenEnhancerChain;
import org.springframework.security.oauth2.provider.token.TokenStore;
import org.springframework.security.oauth2.provider.token.store.JwtAccessTokenConverter;
import org.springframework.security.oauth2.provider.token.store.JwtTokenStore;
import org.springframework.security.oauth2.provider.token.store.KeyStoreKeyFactory;
import java.security.KeyPair;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;


@Configuration
public class JWTTokenConfig {

    @Bean
    TokenStore tokenStore(){
        return new JwtTokenStore(jwtAccessTokenConverter());
    }




    /**
     * JWT内容增强
     * 在OAuth Token里面添加额外内容，而非在access_token
     */
    @Bean
    public TokenEnhancer tokenEnhancer() {
        return (accessToken, authentication) -> {
            Map<String, Object> additionalInfo = new HashMap<>();
            UserAuth userAuth = (UserAuth) authentication.getPrincipal();
            additionalInfo.put("userId",userAuth.getUserId());
            additionalInfo.put("userType",userAuth.getUserType());
            System.out.println(additionalInfo.toString());
            ((DefaultOAuth2AccessToken)accessToken).setAdditionalInformation(additionalInfo);
            return accessToken;
        };
    }

    /**
     * 从classpath下的密钥库中获取密钥对(公钥+私钥)
     */
    @Bean
    public KeyPair keyPair() {
        KeyStoreKeyFactory factory = new KeyStoreKeyFactory(
                new ClassPathResource("issues.jks"), "sjtuissues".toCharArray());
        KeyPair keyPair = factory.getKeyPair(
                "issues", "sjtuissues".toCharArray());
        return keyPair;
    }


    /**
     * 使用非对称加密算法对token签名
     */
    @Bean
    public JwtAccessTokenConverter jwtAccessTokenConverter() {
        JwtAccessTokenConverter converter = new myJwtAccessTokenConverter();
        converter.setKeyPair(keyPair());
        return converter;
    }

    /**
     * 如果想在jwt的accessToken包含额外信息，必须重写JwtAccessTokenConverter
     */
    public class myJwtAccessTokenConverter extends JwtAccessTokenConverter{
        @Override
        public OAuth2AccessToken enhance(OAuth2AccessToken accessToken, OAuth2Authentication authentication) {
            if (accessToken instanceof DefaultOAuth2AccessToken) {
                Object principal = authentication.getPrincipal();

                if (principal instanceof UserAuth) {
                    UserAuth user = (UserAuth) principal;
                    HashMap<String, Object> map = new HashMap<>();

                    map.put("userId", user.getUserId());
                    map.put("userType", user.getUserType());
                    ((DefaultOAuth2AccessToken) accessToken).setAdditionalInformation(map);
                }
            }
            return super.enhance(accessToken, authentication);
        }
    }
    /**
     * <p>注意，自定义TokenServices的时候，需要设置@Primary，否则报错，</p>
     * @return
     */
    @Primary
    @Bean
    public DefaultTokenServices myTokenServices(){
        TokenEnhancerChain tokenEnhancerChain = new TokenEnhancerChain();
        tokenEnhancerChain.setTokenEnhancers(Arrays.asList(jwtAccessTokenConverter(),tokenEnhancer()));
        DefaultTokenServices tokenServices = new DefaultTokenServices();
        tokenServices.setTokenEnhancer(tokenEnhancerChain);
        tokenServices.setTokenStore(tokenStore());
        tokenServices.setSupportRefreshToken(true);
        tokenServices.setAccessTokenValiditySeconds(60*60*12); // token有效期自定义设置，默认12小时
        tokenServices.setRefreshTokenValiditySeconds(60 * 60 * 24 * 7);//默认30天，这里修改
        return tokenServices;
    }


}
