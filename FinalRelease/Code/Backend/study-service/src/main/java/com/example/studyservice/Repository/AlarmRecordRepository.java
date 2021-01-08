package com.example.studyservice.Repository;

import com.example.studyservice.Entity.AlarmRecord;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AlarmRecordRepository extends JpaRepository<AlarmRecord,Integer> {
}
