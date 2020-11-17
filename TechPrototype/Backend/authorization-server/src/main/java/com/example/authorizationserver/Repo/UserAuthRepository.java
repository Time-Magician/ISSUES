package com.example.authorizationserver.Repo;

import com.example.authorizationserver.Entity.UserAuth;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface UserAuthRepository extends JpaRepository<UserAuth,Integer> {
//    @Query(value = "from UserAuth where username = :username and password = :password")
//    UserAuth checkUser(@Param("username") String username, @Param("password") String password);

    @Query(value = "from UserAuth where username = :username")
    UserAuth getUserAuthByUsername(@Param("username") String username);

//    @Query(value = "from UserAuth where userType <> 0")
//    List<UserAuth> getAllUsers();
}
