
-- 기본 tb_board 테이블. 프로젝트에 쓰인 것과 제약조건 선언이(조건명) 차이가 좀 있다.
CREATE TABLE TB_BOARD
(
	
    --IDX NUMBER PRIMARY KEY,
  	IDX NUMBER CONSTRAINT PK_TB_BOARD_IDX PRIMARY KEY(IDX),
    PARENT_IDX NUMBER,
    TITLE VARCHAR2(100) NOT NULL,
    CONTENTS VARCHAR2(4000) NOT NULL,
    HIT_CNT NUMBER NOT NULL,
    DEL_GB VARCHAR2(1) DEFAULT 'N' NOT NULL,
    CREA_DTM DATE DEFAULT SYSDATE NOT NULL,
    CREA_ID VARCHAR2(30) NOT NULL,
    COMMENTS_COUNT NUMBER(4) DEFAULT 0 -- 밑의 컬럼 추가 후, 명시적으로 여기도 추가한거임. 둘중 하나만..
);

--컬럼 추가. 위에 이미 추가되어있다.
alter table TB_BOARD
add (comments_count number(4) default 0);

-- 시퀀스 생성. START WITH 1로 하면, 2부터 시작한다.. 뭘까?
CREATE SEQUENCE SEQ_TB_BOARD_IDX
START WITH 0
INCREMENT BY 1
NOMAXVALUE
NOCACHE;

COMMIT;

BEGIN
    FOR i IN 1..500 LOOP
    INSERT INTO TB_BOARD(IDX, TITLE, CONTENTS, HIT_CNT, DEL_GB, CREA_DTM, CREA_ID)
    VALUES(SEQ_TB_BOARD_IDX.NEXTVAL, '제목 '||i, '내용 '||i, 0, 'N', SYSDATE, 'Admin');
    END LOOP;
END;

SELECT * FROM TB_BOARD
ORDER BY IDX ASC;

--코멘트 테이블 작동 확인을 위한 데이터 추가.
BEGIN
    FOR i IN 1..10 LOOP
    INSERT INTO TB_COMMENT(COMMENT_IDX, IDX, PARENTS_IDX, CREA_ID, CONTENTS, CREA_DTM)
    VALUES(SEQ_TB_COMMENT_COMMENT_IDX.NEXTVAL, 1023, null, 'Admin', '흐미흐미흐미', SYSDATE);
    END LOOP;
END;

select * from tb_comment;

COMMIT;

/*위에는 TB_BOARD의 내용. DCL은 개발자노트 사이트 참조.*/


select * from user_constraints
where table_name LIKE 'TB%';

SELECT * FROM USER_SEQUENCES;

SELECT * FROM TB_FILE;

/*
2015-08-31
- STORED_FILE_NAME 크기를 36BYTE에서 37BYTE로 늘림.
- 확장자가 4글자(JPEG등..)일 경우, 에러나기 때문.
*/
/*
파일을 업로드하면 그 파일을 서버의 어딘가에 저장이 되어야하는데 만약 파일 이름이 같을 경우, 
저장 중 문제가 발생하거나 파일 이름이 변경될 수 있다. 
따라서 파일을 저장할 때, 원본파일의 이름을 저장해놓고 서버에는 변경된 파일이름으로 파일을 저장한다. 
나중에 파일 다운로드를 할때에는, 파일의 이름을 통해서 해당 파일에 접근하기 때문에 겹치지 않는 파일이름은 필수이다.
*/
CREATE TABLE TB_FILE
(
  IDX   NUMBER, -- 첨부파일의 인덱스
  BOARD_IDX NUMBER NOT NULL, -- 게시판의 게시글 인덱스
  ORIGINAL_FILE_NAME VARCHAR2(260 BYTE) NOT NULL, -- view에 보여질 원본의 파일명.
  STORED_FILE_NAME VARCHAR2(37 BYTE) NOT NULL, -- 실 DB에 저장될 파일명
  FILE_SIZE NUMBER,
  CREA_DTM  DATE DEFAULT SYSDATE NOT NULL,
  CREA_ID   VARCHAR2(30 BYTE) NOT NULL, -- 게시글 등록자 ID
  DEL_GB    VARCHAR2(1 BYTE) DEFAULT 'N' NOT NULL
);

ALTER TABLE TB_FILE
ADD CONSTRAINT PK_TB_FILE_IDX PRIMARY KEY(IDX);

ALTER TABLE TB_FILE
ADD CONSTRAINT FK_TB_FILE_BOARD_IDX FOREIGN KEY(BOARD_IDX) REFERENCES TB_BOARD(IDX);


CREATE SEQUENCE SEQ_TB_FILE_IDX
START WITH 1
INCREMENT BY 1
NOMAXVALUE
NOCACHE;

/*2015-11-20 댓글 테이블*/
/*컬럼 설명
COMMENT_IDX 댓글 ID
IDX 게시글 ID
PARENTS_IDX 부모 댓글(해당 댓글이 리리플일때..), 
            부모의 COMMENT_IDX가 자식의 PARENT_IDX가 된다.
CREA_ID 댓글 작성자
CONTENTS 댓글 내용
CREA_DTM 댓글 작성날짜
*/
CREATE TABLE TB_COMMENT
(
    COMMENT_IDX NUMBER(10), --PK, 댓글의 식별자
    IDX NUMBER(10) NOT NULL, --FK, 게시판 인덱스
    GROUP_IDX NUMBER(10) NOT NULL,  -- 댓글과 재댓글을 그룹짓는다.
    PARENTS_IDX NUMBER(10),         -- 댓글과 재댓글을 구분한다.
    STEP_IDX NUMBER(10) NOT NULL,   -- 같은 그룹내에서 정렬한다.
    CREA_ID VARCHAR2(30) NOT NULL,  -- 댓글 작성자
    CONTENTS VARCHAR2(4000) NOT NULL, -- 댓글 내용
    CREA_DTM DATE DEFAULT SYSDATE NOT NULL, -- 댓글 작성일자
    CONSTRAINT PK_TB_COMMENT_COMMENT_IDX PRIMARY KEY(COMMENT_IDX),
    CONSTRAINT FK_TB_COMMENT_IDX FOREIGN KEY(IDX) REFERENCES TB_BOARD(IDX)
);

--truncate table tb_comment;

--drop table tb_comment;

--왜 인덱스가 2부터 시작하지? 그래서 0으로 시작으로 바꿈.
CREATE SEQUENCE SEQ_TB_COMMENT_COMMENT_IDX
START WITH 0
INCREMENT BY 1
MINVALUE 0
NOMAXVALUE
NOCACHE;

--drop sequence seq_tb_comment_comment_idx;

CREATE SEQUENCE SEQ_TB_COMMENT_GROUP_IDX
START WITH 0
INCREMENT BY 1
MINVALUE 0
NOMAXVALUE
NOCACHE;

CREATE SEQUENCE SEQ_TB_COMMENT_STEP_IDX
START WITH 0
INCREMENT BY 1
MINVALUE 0
NOMAXVALUE
NOCACHE;


SELECT * FROM USER_SEQUENCES;

DESC TB_BOARD;

COMMIT;