package com.example.studyservice.Repository;

import com.example.studyservice.Entity.StudyRecord;
import org.springframework.data.jpa.repository.JpaRepository;

import javax.swing.text.Style;

public interface StudyRecordRepository extends JpaRepository<StudyRecord,Integer> {

}
