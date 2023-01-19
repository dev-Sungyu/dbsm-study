/*
 * 자동차
 * 
 * - 자동차 번호
 * - 자동차 브랜드
 * - 출시 날짜
 * - 색상
 * - 가격
 * 
 * */
CREATE TABLE TBL_CAR(
   CAR_ID NUMBER,
   CAR_BRAND VARCHAR2(1000),
   CAR_RELEASE_DATE DATE,
   CAR_COLOR VARCHAR2(1000),
   CAR_PRICE NUMBER,
   CONSTRAINT PK_CAR PRIMARY KEY(CAR_ID)
);

CREATE TABLE TBL_CAR(
   CAR_ID NUMBER PRIMARY KEY,
   CAR_BRAND VARCHAR2(1000),
   CAR_RELEASE_DATE DATE,
   CAR_COLOR VARCHAR2(1000),
   CAR_PRICE NUMBER
);

CREATE TABLE TBL_CAR(
   CAR_ID NUMBER CONSTRAINT PK_CAR PRIMARY KEY,
   CAR_BRAND VARCHAR2(1000),
   CAR_RELEASE_DATE DATE,
   CAR_COLOR VARCHAR2(1000),
   CAR_PRICE NUMBER
);

DROP TABLE TBL_CAR;

ALTER TABLE TBL_CAR DROP CONSTRAINT PK_CAR;
ALTER TABLE TBL_CAR ADD CONSTRAINT PK_CAR PRIMARY KEY(CAR_ID);

/*
 * 동물 테이블 생성
 * 
 * - 고유 번호
 * - 종류
 * - 나이
 * - 먹이
 * 
 * */

CREATE TABLE TBL_ANIMAL(
   ANIMAL_ID NUMBER CONSTRAINT PK_ANIMAL PRIMARY KEY,
   ANIMAL_TYPE VARCHAR2(1000),
   ANIMAL_AGE NUMBER,
   ANIMAL_FEED_NAME VARCHAR2(1000)
);

CREATE TABLE TBL_ANIMAL(
   ANIMAL_ID NUMBER,
   ANIMAL_TYPE VARCHAR2(1000),
   ANIMAL_AGE NUMBER,
   ANIMAL_FEED_NAME VARCHAR2(1000),
   CONSTRAINT PK_ANIMAL PRIMARY KEY(ANIMAL_ID)
);

ALTER TABLE TBL_ANIMAL DROP CONSTRAINT PK_ANIMAL;
ALTER TABLE TBL_ANIMAL ADD CONSTRAINT PK_ANIMAL PRIMARY KEY(ANIMAL_ID);


DROP TABLE TBL_ANIMAL;

/*
 * 학생 테이블 생성
 * 
 * - 학생 번호
 * - 학생 아이디
 * - 학생 이름
 * - 전공
 * - 성별
 * - 생년월일
 * - 학생 나이 NOT NULL, DEFAULT는 생년월일로 계산된 나이, 19보다 커야한다
 * - 학생 학점(A+ ~ F) 'A+', 'A', 'B+', 'B', 'C+', 'C', 'D+', 'D', 'F'
 * 
 * */

CREATE TABLE TBL_STUDENT(
   STUDENT_ID NUMBER CONSTRAINT PK_STUDENT PRIMARY KEY,
   STUDENT_IDENTIFICATION VARCHAR2(1000) CONSTRAINT UK_STUDENT UNIQUE,
   STUDENT_NAME VARCHAR2(1000) CONSTRAINT REQUIER_NAME NOT NULL,
   STUDENT_MAJOR VARCHAR2(1000) CONSTRAINT REQUIER_MAJOR NOT NULL,
   STUDENT_GENDER CHAR(1) DEFAULT 'N' CONSTRAINT BAN_CHAR CHECK(STUDENT_GENDER IN('M','F','N')) CONSTRAINT REQUIER_GENDER NOT NULL,
   STUDENT_BIRTH DATE CONSTRAINT BAN_DATE CHECK(STUDENT_BIRTH >= TO_DATE('1985-01-01', 'YYYY-MM-DD')) CONSTRAINT REQUIER_BIRTH NOT NULL
);

/*학생 아이디는 NULL을 허용하지 않는다. NOT NULL 제약 조건은 추가가 아닌 수정으로 한다.*/
ALTER TABLE TBL_STUDENT MODIFY STUDENT_IDENTIFICATION CONSTRAINT REQUIER_IDENTIFICATION NOT NULL;
/*제약조건의 이름을 설정하지 않으면 시스템 이름으로 설정되기 때문에 지우고 다시 이름을 붙여주는 것이 좋다.*/
ALTER TABLE TBL_STUDENT DROP CONSTRAINT SYS_C007014;
/*기존 BAN_CHAR 제약조건을 없앤다.*/
ALTER TABLE TBL_STUDENT DROP CONSTRAINT BAN_CHAR;
/*BAN_CHAR 제약조건을 추가한다. 성별에는 M, W, N 이외의 문자가 들어가지 못하게 한다.*/
ALTER TABLE TBL_STUDENT ADD CONSTRAINT BAN_CHAR CHECK(STUDENT_GENDER IN ('M','W','N'));
/*DEFAULT 제약조건은 추가가 아닌 수정으로 진행하며, 학생 성별에 W를 기본 값으로 설정한다.*/
ALTER TABLE TBL_STUDENT MODIFY STUDENT_GENDER DEFAULT 'W';
/*학생 나이 컬럼 추가*/
ALTER TABLE TBL_STUDENT ADD(STUDENT_AGE NUMBER);
/*학생 학점 컬럼 추가*/
ALTER TABLE TBL_STUDENT ADD(STUDENT_GRADE VARCHAR2(10));
/*학생 나이는 필수 요소로서 NULL을 허용하지 않는다.*/
ALTER TABLE TBL_STUDENT MODIFY STUDENT_AGE CONSTRAINT REQUIER_AGE NOT NULL;
/*학생 나이는 19세가 넘어야 된다.*/
ALTER TABLE TBL_STUDENT ADD CONSTRAINT CHECK_AGE CHECK(STUDENT_AGE > 19);
/*DEFAULT 제약조건에 다른 컬럼의 값을 가져와 연산할 수 없다. INSERT 또는 다른 언어로 처리해야 한다.*/
/*ALTER TABLE TBL_STUDENT MODIFY STUDENT_AGE DEFAULT TRUNC((SYSDATE - STUDENT_BIRTH) / 365);*/
/*학생 학점은 IN절에 작성된 문자만 사용 가능하다.*/
/*COLUMN IN(A, B, C) => COLUMN = A OR COLUMN = B OR COLUMN = C*/
ALTER TABLE TBL_STUDENT ADD CONSTRAINT BAN_GRADE CHECK(STUDENT_GRADE IN('A+', 'A', 'B+', 'B', 'C+', 'C', 'D+', 'D', 'F'));

/*전체 조회*/
SELECT * FROM TBL_STUDENT;

/*정보 추가*/
INSERT INTO TBL_STUDENT 
(STUDENT_ID, STUDENT_IDENTIFICATION, STUDENT_NAME, STUDENT_MAJOR, STUDENT_BIRTH, STUDENT_AGE, STUDENT_GRADE)
VALUES(1, 'hds', '한동석', '컴퓨터공학', '1985-12-30', 40, 'A+');

INSERT INTO TBL_STUDENT 
(STUDENT_ID, STUDENT_IDENTIFICATION, STUDENT_NAME, STUDENT_MAJOR, STUDENT_GENDER, STUDENT_BIRTH, STUDENT_AGE, STUDENT_GRADE)
VALUES(2, 'hgd', '홍길동', '전자공학', 'M', '1990-02-01', 34, 'D');

/*정보 수정*/
UPDATE TBL_STUDENT
SET STUDENT_GENDER = 'N'
WHERE STUDENT_ID = 1;

/*정보 삭제*/
DELETE FROM TBL_STUDENT;
WHERE STUDENT_ID = 2;

/*정보 삭제, 복구 불가능*/
TRUNCATE TABLE TBL_STUDENT;

/*조합 키
 * 
 * 하나의 PK에 2개 이상의 컬럼이 조합된 형태
 * 
 * */

/*
 * 
 * TBL_FLOWER
   ---------------------------------
   FLOWER_NAME : VARCHAR2 PK_FLOWER
   FLOWER_COLOR : VARCHAR2 PK_FLOWER
   ---------------------------------
   FLOWER_PRICE : NUMBER NOT NULL
 * 
 * */
CREATE TABLE TBL_FLOWER(
   FLOWER_NAME VARCHAR2(1000),
   FLOWER_COLOR VARCHAR2(1000),
   FLOWER_PRICE NUMBER CONSTRAINT REQUIER_PRICE NOT NULL,
   CONSTRAINT PK_FLOWER PRIMARY KEY(FLOWER_NAME, FLOWER_COLOR)
);

DROP TABLE TBL_FLOWER;
/*
   TBL_POT
   ---------------------------------
   POT_ID : NUMBER PK_POT
   ---------------------------------
   POT_COLOR : VARCHAR2 NOT NULL
   POT_SHAPE : VARCHAR2 NOT NULL
   FLOWER_NAME : VARCHAR2 FOREIGN KEY NOT NULL
   FLOWER_COLOR : VARCHAR2 FOREIGN KEY NOT NULL
 * 
 * */
CREATE TABLE TBL_POT(
   POT_ID NUMBER CONSTRAINT PK_POT PRIMARY KEY,
   POT_COLOR VARCHAR2(1000) CONSTRAINT REQUIER_COLOR NOT NULL,
   POT_SHAPE VARCHAR2(1000) CONSTRAINT REQUIER_SHAPE NOT NULL,
   FLOWER_NAME VARCHAR2(1000),
   FLOWER_COLOR VARCHAR2(1000),
   CONSTRAINT FK_POT_FLOWER FOREIGN KEY(FLOWER_NAME, FLOWER_COLOR)
   REFERENCES TBL_FLOWER(FLOWER_NAME, FLOWER_COLOR)
);

/*정보 조회*/
SELECT * FROM TBL_FLOWER;
SELECT * FROM TBL_POT;

/*정보 추가*/
INSERT INTO TBL_FLOWER
(FLOWER_NAME, FLOWER_COLOR, FLOWER_PRICE)
VALUES('장미', '빨간색', 10000);

INSERT INTO TBL_FLOWER
(FLOWER_NAME, FLOWER_COLOR, FLOWER_PRICE)
VALUES('장미', '노란색', 11000);

INSERT INTO TBL_POT
(POT_ID, POT_COLOR, POT_SHAPE, FLOWER_NAME, FLOWER_COLOR)
VALUES(1, '검은색', '정육면체', '장미', '노란색');

INSERT INTO TBL_POT
(POT_ID, POT_COLOR, POT_SHAPE, FLOWER_NAME, FLOWER_COLOR)
VALUES(2, '노란색', '벽돌집', '장미', '노란색');

INSERT INTO TBL_POT
(POT_ID, POT_COLOR, POT_SHAPE, FLOWER_NAME, FLOWER_COLOR)
VALUES(3, '초록색', '원기둥', '장미', '빨간색');

UPDATE TBL_POT
SET FLOWER_COLOR = '빨간색'
WHERE POT_ID = 2;

DELETE FROM TBL_POT
WHERE FLOWER_NAME = '장미';

DELETE FROM TBL_FLOWER
WHERE FLOWER_NAME = '장미';

/*
   TBL_OWNER
   -----------------------------
   OWNER_NUMBER NUMBER PK_OWNER
   -----------------------------
   OWNER_NAME VARCHAR2 NOT NULL
   OWNER_AGE NUMBER
   OWNER_ADDRESS VARCHAR2 NOT NULL
   OWNER_PHONE VARCHAR2 NOT NULL
*/
CREATE TABLE TBL_OWNER(
   OWNER_NUMBER NUMBER CONSTRAINT PK_OWNER PRIMARY KEY,
   OWNER_NAME VARCHAR2(1000) CONSTRAINT REQUIER_OWNER_NAME NOT NULL,
   OWNER_AGE NUMBER,
   OWNER_ADDRESS VARCHAR2(1000) CONSTRAINT REQUIER_OWNER_ADDRESS NOT NULL,
   OWNER_PHONE VARCHAR2(1000) CONSTRAINT REQUIER_OWNER_PHONE NOT NULL
);

/*
   TBL_PET
   --------------------------
   PET_NUMBER NUMBER PK_PET
   --------------------------
   PET_TYPE VARCHAR2 NOT NULL
   PET_NAME VARCHAR2 NOT NULL
   PET_AGE NUMBER NOT NULL
   PET_ILL_NAME VARCHAR2 NOT NULL
   OWNER_NUMBER NUMBER FK_PET_OWNER
*/

CREATE TABLE TBL_PET(
   PET_NUMBER NUMBER CONSTRAINT PK_PET PRIMARY KEY,
   PET_TYPE VARCHAR2(1000) CONSTRAINT REQUIER_PET_TYPE NOT NULL,
   PET_NAME VARCHAR2(1000) CONSTRAINT REQUIER_PET_NAME NOT NULL,
   PET_AGE NUMBER CONSTRAINT REQUIER_PET_AGE NOT NULL,
   PET_ILL_NAME VARCHAR2(1000) CONSTRAINT REQUIER_PET_ILL_NAME NOT NULL,
   OWNER_NUMBER NUMBER,
   CONSTRAINT FK_PET_OWNER FOREIGN KEY(OWNER_NUMBER)
   REFERENCES TBL_OWNER(OWNER_NUMBER)
);

/*시퀀스 생성*/
CREATE SEQUENCE SEQ_OWNER;
CREATE SEQUENCE SEQ_PET;

/*===========================OWNER=============================*/
/*정보 조회*/
SELECT * FROM TBL_OWNER;

/*정보 추가*/
INSERT INTO TBL_OWNER
(OWNER_NUMBER, OWNER_NAME, OWNER_AGE, OWNER_ADDRESS, OWNER_PHONE)
VALUES(SEQ_OWNER.NEXTVAL, '한동석', 20, '경기도 남양주시', '01012341234');

/*정보 수정*/
/*두 번째 한동석을 이순신으로 변경*/
UPDATE TBL_OWNER
SET OWNER_NAME = '이순신'
WHERE OWNER_NUMBER = 2;

/*===========================PET=============================*/
/*정보 조회*/
SELECT * FROM TBL_PET;

/*반려 동물 추가: 동일한 보호자로 지정*/
INSERT INTO TBL_PET
(PET_NUMBER, PET_TYPE, PET_NAME, PET_AGE, PET_ILL_NAME, OWNER_NUMBER)
VALUES(SEQ_PET.NEXTVAL, '강아지', '뽀삐', 3, '감기', 1);

INSERT INTO TBL_PET
(PET_NUMBER, PET_TYPE, PET_NAME, PET_AGE, PET_ILL_NAME, OWNER_NUMBER)
VALUES(SEQ_PET.NEXTVAL, '고양이', '톰', 1, '장염', 1);

INSERT INTO TBL_PET
(PET_NUMBER, PET_TYPE, PET_NAME, PET_AGE, PET_ILL_NAME, OWNER_NUMBER)
VALUES(SEQ_PET.NEXTVAL, '쥐', '햄토리', 4, '배탈', 2);

INSERT INTO TBL_PET
(PET_NUMBER, PET_TYPE, PET_NAME, PET_AGE, PET_ILL_NAME, OWNER_NUMBER)
VALUES(SEQ_PET.NEXTVAL, '원숭이', '킹콩', 2, '목', 2);

/*두 마리 이상의 반려동물 보호자의 핸드폰 번호를 다른 번호로 변경*/
UPDATE TBL_OWNER
SET OWNER_PHONE = '01099998888'
WHERE OWNER_NUMBER IN 
(
   SELECT OWNER_NUMBER FROM TBL_PET
   GROUP BY OWNER_NUMBER
   HAVING COUNT(OWNER_NUMBER) > 1
);

/*반려 동물을 키우고 있는 보호자를 병원 보호자 명단에서 삭제*/
DELETE FROM TBL_PET
WHERE OWNER_NUMBER IS NOT NULL;

DELETE FROM TBL_OWNER
WHERE OWNER_NUMBER IN(1, 2);














