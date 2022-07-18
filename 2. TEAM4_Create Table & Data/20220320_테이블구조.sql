SELECT USER
FROM DUAL;
--==>>TEAM4

--------------------------------------------------------------------------------

--○ 관리자등록 테이블 생성
CREATE TABLE MANAGER_REGISTER
( MANAGER_CODE   VARCHAR2(10)
, PASSWORD       VARCHAR2(30) CONSTRAINT MA_PASSWORD_NN NOT NULL
, REGISTER_DATE  DATE DEFAULT SYSDATE
, CONSTRAINT MA_CODE_PK PRIMARY KEY(MANAGER_CODE)
);
--==>> Table MANAGER_REGISTER이(가) 생성되었습니다.
--------------------------------------------------------------------------------

--○ 교수등록 테이블 생성
CREATE TABLE TEACHER_REGISTER
( TEACHER_CODE    VARCHAR2(10)          --(교수코드)
, PASSWORD        VARCHAR2(30) CONSTRAINT TC_PASSWORD_NN NOT NULL         --(비밀번호)
, NAME            VARCHAR2(20) CONSTRAINT TC_NAME_NN NOT NULL          --(교수명)
, SSN             VARCHAR2(13) CONSTRAINT TC_SSN_NN NOT NULL          --(주민번호)
, REGISTER_DATE   DATE DEFAULT SYSDATE  --(가입일자)
, CONSTRAINT TC_CODE_PK PRIMARY KEY(TEACHER_CODE)
);
--==>> Table TEACHER_REGISTER이(가) 생성되었습니다.
--------------------------------------------------------------------------------

--○ 학생 등록(STD) 테이블 생성
CREATE TABLE STUDENT_REGISTER
( STUDENT_CODE      VARCHAR2(10)         -- (학생코드)
, PASSWORD          VARCHAR2(30) CONSTRAINT STD_PASSWORD_NN NOT NULL           -- (비밀번호)
, NAME              VARCHAR2(20) CONSTRAINT STD_NAME_NN NOT NULL           -- (학생명)
, SSN               VARCHAR2(13) CONSTRAINT STD_SSN_NN NOT NULL           -- (주민번호)
, REGISTER_DATE     DATE DEFAULT SYSDATE -- (가입일자)
, CONSTRAINT STD_STD_CODE_PK PRIMARY KEY(STUDENT_CODE)
, CONSTRAINT STD_REG_DATE_NN CHECK(REGISTER_DATE IS NOT NULL)
, CONSTRAINT STD_SSN_UK UNIQUE(SSN)
);
--==>> Table STUDENT_REGISTER이(가) 생성되었습니다.

--------------------------------------------------------------------------------

--○ 과정(COU) 테이블 생성
CREATE TABLE COURSE
( COURSE_CODE    NUMBER           -- (과정코드)
, COURSE_NAME    VARCHAR2(20) CONSTRAINT COU_NAME_NN NOT NULL    -- (과정명)
, CONSTRAINT COU_CODE_PK PRIMARY KEY(COURSE_CODE)
);
--==>> Table COURSE이(가) 생성되었습니다.
--------------------------------------------------------------------------------

--○ 강의실등록 테이블 생성(REG_CLASS)
CREATE TABLE CLASSROOM_REGISTER
( CLASSROOM_CODE      NUMBER                                    -- 강의실코드
, CLASSROOM_NAME      VARCHAR2(20) CONSTRAINT REG_CLASS_NAME_NN NOT NULL                             -- 강의실명
, CLASSROOM_CAPACITY  NUMBER CONSTRAINT REG_CLASS_CAPA_NN NOT NULL                                   -- 수용인원
, CONSTRAINT REG_CLASS_CODE_PK PRIMARY KEY (CLASSROOM_CODE)
);         
--==>> Table CLASSROOM_REGISTER이(가) 생성되었습니다.
--------------------------------------------------------------------------------

--○ 과정 개설(OP_COU) 테이블 생성
CREATE TABLE COURSE_OPEN
( OP_COURSE_CODE    VARCHAR2(10)         -- (과정개설코드)
, COURSE_CODE       NUMBER CONSTRAINT OP_COU_COU_CODE_NN NOT NULL               -- (과정코드)
, TEACHER_CODE      VARCHAR2(10)       -- (교수코드)
, CLASSROOM_CODE    NUMBER CONSTRAINT OP_COU_CLA_CODE_NN NOT NULL               -- (강의실코드)
, START_DATE        DATE CONSTRAINT OP_COU_STA_DATE_NN NOT NULL                 -- (시작일자)
, END_DATE          DATE CONSTRAINT OP_COU_END_DATE_NN NOT NULL                 -- (종료일자)
, OPEN_DATE         DATE DEFAULT SYSDATE -- (개설일자)
, CONSTRAINT OP_COU_OP_COU_CODE_PK PRIMARY KEY(OP_COURSE_CODE)
, CONSTRAINT OP_COU_COU_CODE_FK FOREIGN KEY(COURSE_CODE)
                                REFERENCES COURSE(COURSE_CODE)
, CONSTRAINT OP_COU_TEA_CODE_FK FOREIGN KEY(TEACHER_CODE)
                                REFERENCES TEACHER_REGISTER(TEACHER_CODE)
, CONSTRAINT OP_COU_CLA_CODE_FK FOREIGN KEY(CLASSROOM_CODE)
                                REFERENCES CLASSROOM_REGISTER(CLASSROOM_CODE)
);
--==>> Table COURSE_OPEN이(가) 생성되었습니다.
--------------------------------------------------------------------------------

--○ 수강신청 테이블 생성(REG_COU)
CREATE TABLE COURSE_REGISTER
( REG_COURSE_CODE   VARCHAR2(10)   
, OP_COURSE_CODE    VARCHAR2(10) CONSTRAINT REG_COU_COU_CODE_NN NOT NULL     
, STUDENT_CODE      VARCHAR2(10) CONSTRAINT REG_COU_STD_CODE_NN NOT NULL     
, REG_COURSE_DATE   DATE DEFAULT SYSDATE
, CONSTRAINT REG_COU_CODE_PK PRIMARY KEY(REG_COURSE_CODE)
, CONSTRAINT REG_COU_COU_CODE_FK FOREIGN KEY(OP_COURSE_CODE)
                                 REFERENCES COURSE_OPEN(OP_COURSE_CODE)
, CONSTRAINT TEG_COU_STD_CODE_FK FOREIGN KEY(STUDENT_CODE)
                                 REFERENCES STUDENT_REGISTER(STUDENT_CODE)
);
--==>> Table COURSE_REGISTER이(가) 생성되었습니다.
--------------------------------------------------------------------------------

--○ 중도탈락사유코드 테이블 생성(DR_RE) 
CREATE TABLE DROP_REASON
( DR_REASON_CODE   NUMBER                                   -- 중도탈락사유코드
, DETAIL           VARCHAR2(30) CONSTRAINT DR_RE_DET_NN NOT NULL                             -- 중도탈락상세사유
, CONSTRAINT DR_RE_CODE_PK PRIMARY KEY(DR_REASON_CODE)
);
--==>> Table DROP_REASON이(가) 생성되었습니다.
--------------------------------------------------------------------------------

--○ 중도탈락 테이블 생성(DR_STD)
CREATE TABLE STUDENT_DROP
( DROP_CODE         VARCHAR2(10)    
, REG_COURSE_CODE   VARCHAR2(10) CONSTRAINT DR_STD_COU_CODE_NN NOT NULL   
, DR_REASON_CODE    NUMBER
, DROP_DATE         DATE DEFAULT SYSDATE
, CONSTRAINT DR_STD_CODE_PK   PRIMARY KEY(DROP_CODE)
, CONSTRAINT DR_STD_COU_CODE_FK FOREIGN KEY(REG_COURSE_CODE)
                                REFERENCES COURSE_REGISTER(REG_COURSE_CODE)
, CONSTRAINT DR_STD_RE_CODE_FK FOREIGN KEY(DR_REASON_CODE)
                                REFERENCES DROP_REASON(DR_REASON_CODE)
);
--==>> Table STUDENT_DROP이(가) 생성되었습니다.
--------------------------------------------------------------------------------

--○ 교재 테이블 생성
CREATE TABLE TEXTBOOK
( TEXTBOOK_CODE NUMBER
, TEXTBOOK_NAME VARCHAR2(20) CONSTRAINT TXT_NAME_NN NOT NULL
, PUBLISHER     VARCHAR2(30)
, CONSTRAINT TXT_CODE_PK PRIMARY KEY (TEXTBOOK_CODE)
);
--==>> Table TEXTBOOK이(가) 생성되었습니다.
--------------------------------------------------------------------------------

--○과목 테이블
CREATE TABLE SUBJECT
( SUBJECT_CODE NUMBER
, SUBJECT_NAME VARCHAR2(20) CONSTRAINT SUB_NAME_NN NOT NULL
, CONSTRAINT SUB_CODE_PK PRIMARY KEY (SUBJECT_CODE)
);
--==>> Table SUBJECT이(가) 생성되었습니다.
--------------------------------------------------------------------------------

--○ 과목개설(OP_SUB) 테이블 생성
CREATE TABLE SUBJECT_OPEN
( OP_SUBJECT_CODE   VARCHAR2(10)            -- (과목개설코드)
, SUBJECT_CODE      NUMBER CONSTRAINT OP_SUB_SUB_CODE_NN NOT NULL                 -- (과목코드)
, TEXTBOOK_CODE     NUMBER                  -- (교재코드) 
, OP_COURSE_CODE    VARCHAR2(10) CONSTRAINT OP_SUB_OP_COU_CODE_NN NOT NULL           -- (과정개설코드)
, START_DATE        DATE CONSTRAINT OP_SUB_STR_DATE_NN NOT NULL                   -- (시작일자)
, END_DATE          DATE CONSTRAINT OP_SUB_END_DATE_NN NOT NULL                   -- (종료일자)     
, ATTENDANCE_RATE   NUMBER                  -- (출결배점)
, WRITING_RATE      NUMBER                  -- (필기배점)   
, PERFORMANCE_RATE  NUMBER                  -- (실기배점) 
, OPEN_DATE         DATE DEFAULT SYSDATE    -- (개설일자) 
, CONSTRAINT OP_SUB_CODE_PK PRIMARY KEY(OP_SUBJECT_CODE)
, CONSTRAINT OP_SUB_SUB_CODE_FK FOREIGN KEY(SUBJECT_CODE)
                                REFERENCES SUBJECT(SUBJECT_CODE)
, CONSTRAINT OP_SUB_TXT_CODE_FK FOREIGN KEY(TEXTBOOK_CODE)
                                REFERENCES TEXTBOOK(TEXTBOOK_CODE)
, CONSTRAINT OP_SUB_OP_COU_CODE_FK FOREIGN KEY(OP_COURSE_CODE)
                                REFERENCES COURSE_OPEN(OP_COURSE_CODE)
);
--==>> Table SUBJECT_OPEN이(가) 생성되었습니다.
--------------------------------------------------------------------------------

--○ 성적 입력 테이블
CREATE TABLE SCORE_INPUT
( SCORE_CODE        VARCHAR2(10)
, OP_SUBJECT_CODE   VARCHAR2(10) CONSTRAINT IN_SCR_OP_SUB_CODE_NN NOT NULL
, REG_COURSE_CODE   VARCHAR2(10) CONSTRAINT IN_SCR_REG_COU_CODE_NN NOT NULL
, ATTENDANCE_SCORE  NUMBER DEFAULT 0
, WRITING_SCORE     NUMBER DEFAULT 0
, PERFORMANCE_SCORE NUMBER DEFAULT 0
, SCORE_DATE        DATE DEFAULT SYSDATE
, CONSTRAINT IN_SCR_CODE_PK PRIMARY KEY (SCORE_CODE)
, CONSTRAINT IN_SCR_OP_SUB_CODE_FK FOREIGN KEY(OP_SUBJECT_CODE)         
                                   REFERENCES SUBJECT_OPEN(OP_SUBJECT_CODE)
, CONSTRAINT IN_SCR_REG_COU_CODE_FK FOREIGN KEY(REG_COURSE_CODE)    
                                   REFERENCES COURSE_REGISTER(REG_COURSE_CODE)
);

--------------------------------------------------------------------------------

--○ 제약조건 확인 전용 뷰(VIEW) 생성
--   (SYS 계정)GRANT CREATE VIEW TO TEAM4;
CREATE OR REPLACE VIEW VIEW_CONSTCHECK
AS
SELECT UC.OWNER "OWNER"
      ,UC.CONSTRAINT_NAME "CONSTRAINT_NAME"
      ,UC.TABLE_NAME"TABLE_NAME"
      ,UC.CONSTRAINT_TYPE"CONSTRAINT_TYPE"
      ,UCC.COLUMN_NAME"COLUMN_NAME"
      ,UC.SEARCH_CONDITION"SEARCH_CONDITION"
      ,UC.DELETE_RULE"DELETE_RULE"
FROM USER_CONSTRAINTS UC JOIN USER_CONS_COLUMNS UCC
ON UC.CONSTRAINT_NAME = UCC.CONSTRAINT_NAME;
--==>> View VIEW_CONSTCHECK이(가) 생성되었습니다.

--------------------------------------------------------------------------------
--○ 테이블조회
SELECT *
FROM USER_TABLES;

--------------------------------------------------------------------------------