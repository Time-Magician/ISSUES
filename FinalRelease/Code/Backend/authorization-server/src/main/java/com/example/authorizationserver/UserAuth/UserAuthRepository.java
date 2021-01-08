package com.example.authorizationserver.UserAuth;

import com.example.authorizationserver.UserAuth.UserAuth;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface UserAuthRepository extends JpaRepository<UserAuth,Integer> {
    UserAuth getUserAuthByTelEquals(String tel);
    UserAuth getUserAuthByEmailEquals(String email);

}
