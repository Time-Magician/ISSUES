package com.example.authorizationserver;
import com.example.authorizationserver.Entity.UserAuth;
import com.example.authorizationserver.Repo.UserAuthRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.stereotype.Component;


@Slf4j
@Component(value = "UserDetailsServiceImpl")
public class UserDetailsServiceImpl implements UserDetailsService {
    @Autowired
    private UserAuthRepository userAuthRepository;

//    @Autowired
//    private PasswordEncoder passwordEncoder;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
//        UserAuth userAuth = userAuthRepository.getUserAuthByUsername(username);
//        if(userAuth == null){
//            return  null;
//        }
//        System.out.println(userAuth.getPassword());
//        return userAuth;
        System.out.println("WO here");
        return User.withUsername("sjw")
                .password(new BCryptPasswordEncoder().encode("123"))
                .authorities("ROLE_USER")
                .build();
    }

}
