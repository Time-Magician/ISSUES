package com.example.userservice.Repository;

import com.example.userservice.Entity.Friends;
import org.bson.types.ObjectId;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.Optional;

public interface FriendsRepository extends MongoRepository<Friends, Integer> {
    Optional<Friends> findByUserId(int userId);
}
