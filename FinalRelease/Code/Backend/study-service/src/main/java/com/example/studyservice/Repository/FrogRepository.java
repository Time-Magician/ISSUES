package com.example.studyservice.Repository;

import com.example.studyservice.Entity.Frog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface FrogRepository extends JpaRepository<Frog,Integer>{
    @Query(nativeQuery = true,value="select * from frogs where user_id=?1 and is_graduated=?2")
    List<Frog> findByUserIdAndGraduated(int userId, boolean isGraduated);
}
