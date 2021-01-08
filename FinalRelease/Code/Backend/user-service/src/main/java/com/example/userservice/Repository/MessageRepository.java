package com.example.userservice.Repository;

import com.example.userservice.Entity.Message;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;
import java.util.Optional;

public interface MessageRepository extends MongoRepository<Message, String> {
    Optional<List<Message>> findByReceiverId(int userId);
}

