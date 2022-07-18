
--------------------------------------------------------------------------------
-- *17
-- [과정관리]
--○ 관리자의 모든 과정 정보 출력 기능
-- 출력 정보 : 과정명, 강의실, 과목명, 기간, 교재명, 교수자명
CREATE OR REPLACE VIEW VIEW_MA_COU
AS
SELECT FN_COURSE(CO.COURSE_CODE) "과정명", FN_CLASSROOM_REGISTER(CO.CLASSROOM_CODE) "강의실"
     , FN_SUBJECT(SO.SUBJECT_CODE)"과목명"
     , CO.START_DATE "시작일자", CO.END_DATE "종료일자", CO.OPEN_DATE "개설일자"
     , FN_TEXTBOOK(SO.TEXTBOOK_CODE) "교재명"
     , FN_TEACHER_REGISTER(CO.TEACHER_CODE) "교수자명"
  FROM COURSE_OPEN CO JOIN SUBJECT_OPEN SO
    ON CO.OP_COURSE_CODE = SO.OP_COURSE_CODE;

-- *40
-- [중도탈락]
--○ 중도탈락학생 조회 VIEW
CREATE OR REPLACE VIEW VIEW_DROP_STUDENT_CK
AS
SELECT CR.REG_COURSE_CODE "수강신청코드", SR.NAME "학생명", SD.DROP_DATE "중도탈락일자"
     , CASE WHEN DROP_CODE IS NOT NULL THEN '중도탈락한 학생' ELSE '중도탈락하지 않은 학생' END "중도탈락여부"
     , DR.DETAIL "중도탈락사유"
FROM STUDENT_REGISTER SR, COURSE_REGISTER CR, STUDENT_DROP SD, DROP_REASON DR
WHERE SR.STUDENT_CODE = CR.STUDENT_CODE
  AND CR.REG_COURSE_CODE = SD.REG_COURSE_CODE
  AND SD.DR_REASON_CODE = DR.DR_REASON_CODE(+);

-- *33
--○ 관리자의 학생 정보 출력 VIEW
CREATE OR REPLACE VIEW VIEW_MA_STD
AS
SELECT SR.NAME "학생이름", C.COURSE_CODE "과정명", S.SUBJECT_NAME "수강과목"
     , (SI.ATTENDANCE_SCORE*SO.ATTENDANCE_RATE*0.01+ SI.WRITING_SCORE*SO.WRITING_RATE*0.01 
      + SI.PERFORMANCE_SCORE*SO.PERFORMANCE_RATE*0.01)  "수강과목총점"
FROM STUDENT_REGISTER SR, COURSE_REGISTER CR, COURSE_OPEN CO
   , COURSE C, SUBJECT_OPEN SO, SUBJECT S, SCORE_INPUT SI
WHERE SR.STUDENT_CODE = CR.STUDENT_CODE
  AND C.COURSE_CODE = CO.COURSE_CODE
  AND CO.OP_COURSE_CODE = CR.OP_COURSE_CODE
  AND CR.REG_COURSE_CODE = SI.REG_COURSE_CODE
  AND SI.OP_SUBJECT_CODE = SO.OP_SUBJECT_CODE
  AND SO.SUBJECT_CODE = S.SUBJECT_CODE;