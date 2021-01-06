package com.example.studyservice.Repository;

import com.example.studyservice.Entity.StudyRecord;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import javax.swing.text.Style;
import java.sql.Date;
import java.util.List;

public interface StudyRecordRepository extends JpaRepository<StudyRecord,Integer> {
    @Query(nativeQuery = true,value="select * from study_records where user_id=?1")
   List<StudyRecord> getStudyRecordsByUser(int userId);

    @Query(nativeQuery = true,value="select * from study_records where user_id=?1 and start_time = ?2")
    StudyRecord getStudyRecordByUserAndStartTime(int userId, Date startTime);
}
