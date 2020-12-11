package com.example.authorizationserver.UserAuth;
import lombok.Data;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@Entity
@Table(name = "users_auth")
@Data
public class UserAuth implements UserDetails {
    @Id
    @Column(name = "user_id")
    private int userId;
    private String email;
    private String tel;
    private String password;

    @Column(name = "user_type")
    private int userType;

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return this.userType == 1 || this.userType == 0;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        List<GrantedAuthority> authorities = new ArrayList<>();
        authorities.add(new SimpleGrantedAuthority(userType == 0? "ADMIN":"USER"));
        return authorities;
    }

    @Override
    public String getPassword() {
        return password;
    }


    //getUsername具体的返回值不影响验证
    @Override
    public String getUsername() {
        return tel;
    }

    public String getUserType(){
        return userType == 0? "ADMIN":"USER";
    }
}
