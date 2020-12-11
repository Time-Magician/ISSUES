package com.example.userservice.Repository;

import com.example.userservice.Entity.UserAuth;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface UserAuthRepository extends JpaRepository<UserAuth,Integer> {

    UserAuth findUserAuthByEmailEqualsAndPasswordEquals(String email,String password);
    UserAuth findUserAuthByTelEqualsAndPasswordEquals(String tel,String password);
    UserAuth findUserAuthByTelEquals(String tel);
    UserAuth findUserAuthByEmailEquals(String email);
    List<UserAuth> getUserAuthByUserTypeEquals(int userType);
}
