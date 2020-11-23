package com.example.authorizationserver.UserAuth;
import com.example.authorizationserver.UserAuth.UserAuthRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;


@Slf4j
@Component(value = "UserDetailsServiceImpl")
public class UserDetailsServiceImpl implements UserDetailsService {
    @Autowired
    private UserAuthRepository userAuthRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        UserAuth userAuth = new UserAuth();

        if(username.contains("@")) {
            userAuth = userAuthRepository.getUserAuthByEmailEquals(username);
        }
        else {
            userAuth = userAuthRepository.getUserAuthByTelEquals(username);
        }

        if(userAuth == null){
            throw new UsernameNotFoundException("UsernameNotFound!");
        }
        return userAuth;
    }

}
