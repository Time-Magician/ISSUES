package com.example.userservice.Repository;

import com.example.userservice.Entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User,Integer> {
    User getUserByEmailEquals(String email);
    User getUserByTelEquals(String tel);
}
