CREATE SEQUENCE SEQ_USER;

/*회원번호, 아이디, 이름, 비밀번호, 전화번호, 닉네임, 이메일, 주소, 생년월일, 성별, 추천인 아이디*/
CREATE TABLE TBL_USER(
   USER_ID NUMBER CONSTRAINT PK_USER PRIMARY KEY,
   USER_IDENTIFICATION VARCHAR2(500) UNIQUE NOT NULL,
   USER_NAME VARCHAR2(500) NOT NULL,
   USER_PASSWORD VARCHAR2(500) NOT NULL,
   USER_PHONE VARCHAR2(100) NOT NULL,
   USER_NICKNAME VARCHAR2(500),
   USER_EMAIL VARCHAR2(100) CONSTRAINT UK_USER UNIQUE NOT NULL,
   USER_ADDRESS VARCHAR2(500),
   USER_BIRTH DATE,
   USER_GENDER CHAR(1) DEFAULT 'N' CHECK(USER_GENDER IN('M', 'W', 'N')),
   USER_RECOMMENDER_ID VARCHAR2(500)
);

CREATE TABLE TBL_RECOMMEND(
   USER_ID NUMBER,
   RECOMMEND_COUNT NUMBER DEFAULT 0,
   CONSTRAINT FK_RECOMMEND_USER FOREIGN KEY(USER_ID) REFERENCES TBL_USER(USER_ID),
   CONSTRAINT PK_RECOMMEND PRIMARY KEY(USER_ID)
);

ALTER TABLE TBL_RECOMMEND DROP CONSTRAINT FK_RECOMMEND_USER;
ALTER TABLE TBL_RECOMMEND ADD 
CONSTRAINT FK_RECOMMEND_USER FOREIGN KEY(USER_ID) REFERENCES TBL_USER(USER_ID)
ON DELETE CASCADE;

/*ALTER TABLE TBL_USER ADD RECOMMEND_COUNT NUMBER DEFAULT 0;*/
/*ALTER TABLE TBL_USER DROP COLUMN RECOMMEND_COUNT;*/

INSERT INTO TBL_USER
(USER_ID, USER_IDENTIFICATION, USER_NAME, USER_PASSWORD, USER_PHONE, USER_EMAIL, USER_ADDRESS)
VALUES(SEQ_USER.NEXTVAL, 'hds12345', '한동석', '1234', '01032341234', 'hds12345@gmail.com', '경기도 남양주시');

DELETE FROM TBL_USER WHERE USER_ID = 23;

SELECT * FROM TBL_USER;
SELECT * FROM TBL_RECOMMEND;

DROP TRIGGER TRIGGER_RECOMMEND;

CREATE OR REPLACE TRIGGER TRIGGER_RECOMMEND
AFTER
INSERT ON TBL_USER
FOR EACH ROW
DECLARE
BEGIN
   INSERT INTO TBL_RECOMMEND (USER_ID, RECOMMEND_COUNT) 
   VALUES(:NEW.USER_ID, 0);
END;

