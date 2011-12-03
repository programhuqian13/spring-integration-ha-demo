CREATE TABLE  CLUSTER_STATUS (
	APPLICATION_ID VARCHAR2(128) NOT NULL ENABLE, 
	STATUS VARCHAR2(10) DEFAULT 'RUNNING' NOT NULL ENABLE, 
	CURRENT_MASTER VARCHAR2(128), 
	LAST_PROCESSED TIMESTAMP (6), 
	PENDING_USURPER VARCHAR2(128), 
	USURP_TIMESTAMP TIMESTAMP (6), 
	 PRIMARY KEY (APPLICATION_ID) ENABLE
);

create sequence queued_sequence;

CREATE TABLE QUEUED (
	 ID 			NUMBER(11,0) NOT NULL PRIMARY KEY
	,ENTITY_ID		VARCHAR(128) NOT NULL
	,PROCESS_ID		VARCHAR(128) NOT NULL
	,TS				TIMESTAMP
	,MESSAGE		BLOB
);

create sequence lock_status_sequence;

CREATE TABLE LOCK_STATUS (
	 ID 			NUMBER(11,0) NOT NULL PRIMARY KEY
	,ENTITY_ID		VARCHAR(128) NOT NULL
	,DISPATCHER_ID	VARCHAR(128) NOT NULL
	,GLOBAL_TX		VARCHAR(128)  
	,PROCESS_ID		VARCHAR(128) NOT NULL
	,DEDUP_KEY		VARCHAR(128) 
	,STATUS			NUMBER(3,0)	 NOT NULL
	,TS				TIMESTAMP    NOT NULL
);

create sequence results_sequence;

CREATE TABLE RESULTS (
	 ID				NUMBER(11,0) NOT NULL PRIMARY KEY
	,KEY			VARCHAR(40)
	,SEQUENCE		INTEGER
	,TS				TIMESTAMP
);

CREATE OR REPLACE TRIGGER QUEUED_TS_TRG 
BEFORE INSERT OR UPDATE ON QUEUED
FOR EACH ROW
BEGIN 
	:new.TS := SYSTIMESTAMP;
	
	IF INSERTING 
	THEN
		SELECT QUEUED_SEQUENCE.NEXTVAL INTO :new.ID FROM DUAL;
	END IF;
END;

CREATE OR REPLACE TRIGGER LOCK_STATUS_TS_TRG 
BEFORE INSERT OR UPDATE ON LOCK_STATUS
FOR EACH ROW
BEGIN 
	:new.TS := SYSTIMESTAMP;
END;

CREATE OR REPLACE TRIGGER RESULTS_TS_TRG 
BEFORE INSERT OR UPDATE ON RESULTS
FOR EACH ROW
BEGIN 
	:new.TS := SYSTIMESTAMP;
	
	IF INSERTING 
	THEN
		SELECT RESULTS_SEQUENCE.NEXTVAL INTO :new.ID FROM DUAL;
	END IF;
END;