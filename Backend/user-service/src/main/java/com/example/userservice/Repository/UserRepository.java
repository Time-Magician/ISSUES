package com.example.userservice.Repository;

import com.example.userservice.Entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface UserRepository extends JpaRepository<User,Integer> {
    User getUserByEmailEquals(String email);
    User getUserByTelEquals(String tel);
    List<User> getUserByUserIdIsNotIn(List<Integer> userIds);
}
