--
-- ER/Studio 8.0 SQL Code Generation
-- Company :      Hewlett-Packard Company
-- Project :      hr_oracle.DM1
-- Author :       ProDesk
--
-- Date Created : Friday, November 21, 2014 13:55:56
-- Target DBMS : Oracle 11g
--

-- 
-- TABLE: COUNTRIES 
--

CREATE TABLE COUNTRIES(
    COUNTRY_ID      CHAR(2)         NOT NULL,
    COUNTRY_NAME    VARCHAR2(40),
    REGION_ID       NUMBER,
    CONSTRAINT COUNTRY_C_ID_PK PRIMARY KEY (COUNTRY_ID)
)ORGANIZATION INDEX
PCTTHRESHOLD 50
OVERFLOW LOGGING
;



-- 
-- TABLE: DEPARTMENTS 
--

CREATE TABLE DEPARTMENTS(
    DEPARTMENT_ID      NUMBER(4, 0)    NOT NULL,
    DEPARTMENT_NAME    VARCHAR2(30)    NOT NULL,
    MANAGER_ID         NUMBER(6, 0),
    LOCATION_ID        NUMBER(4, 0),
    CONSTRAINT DEPT_ID_PK PRIMARY KEY (DEPARTMENT_ID)
)
;



-- 
-- TABLE: EMPLOYEES 
--

CREATE TABLE EMPLOYEES(
    EMPLOYEE_ID       NUMBER(6, 0)    NOT NULL,
    FIRST_NAME        VARCHAR2(20),
    LAST_NAME         VARCHAR2(25)    NOT NULL,
    EMAIL             VARCHAR2(25)    NOT NULL,
    PHONE_NUMBER      VARCHAR2(20),
    HIRE_DATE         DATE            NOT NULL,
    JOB_ID            VARCHAR2(10)    NOT NULL,
    SALARY            NUMBER(8, 2)    
                      CONSTRAINT EMP_SALARY_MIN CHECK (salary > 0),
    COMMISSION_PCT    NUMBER(2, 2),
    MANAGER_ID        NUMBER(6, 0),
    DEPARTMENT_ID     NUMBER(4, 0),
    CONSTRAINT EMP_EMP_ID_PK PRIMARY KEY (EMPLOYEE_ID),
    CONSTRAINT EMP_EMAIL_UK  UNIQUE (EMAIL)
)
;



-- 
-- TABLE: JOB_HISTORY 
--

CREATE TABLE JOB_HISTORY(
    EMPLOYEE_ID      NUMBER(6, 0)    NOT NULL,
    START_DATE       DATE            NOT NULL,
    END_DATE         DATE            NOT NULL,
    JOB_ID           VARCHAR2(10)    NOT NULL,
    DEPARTMENT_ID    NUMBER(4, 0),
    CONSTRAINT JHIST_EMP_ID_ST_DATE_PK PRIMARY KEY (EMPLOYEE_ID, START_DATE)
)
;



-- 
-- TABLE: JOBS 
--

CREATE TABLE JOBS(
    JOB_ID        VARCHAR2(10)    NOT NULL,
    JOB_TITLE     VARCHAR2(35)    NOT NULL,
    MIN_SALARY    NUMBER(6, 0),
    MAX_SALARY    NUMBER(6, 0),
    CONSTRAINT JOB_ID_PK PRIMARY KEY (JOB_ID)
)
;



-- 
-- TABLE: LOCATIONS 
--

CREATE TABLE LOCATIONS(
    LOCATION_ID       NUMBER(4, 0)    NOT NULL,
    STREET_ADDRESS    VARCHAR2(40),
    POSTAL_CODE       VARCHAR2(12),
    CITY              VARCHAR2(30)    NOT NULL,
    STATE_PROVINCE    VARCHAR2(25),
    COUNTRY_ID        CHAR(2),
    CONSTRAINT LOC_ID_PK PRIMARY KEY (LOCATION_ID)
)
;



-- 
-- TABLE: REGIONS 
--

CREATE TABLE REGIONS(
    REGION_ID      NUMBER          NOT NULL,
    REGION_NAME    VARCHAR2(25),
    CONSTRAINT REG_ID_PK PRIMARY KEY (REGION_ID)
)
;



-- 
-- INDEX: DEPT_LOCATION_IX 
--

CREATE INDEX DEPT_LOCATION_IX ON DEPARTMENTS(LOCATION_ID)
;
-- 
-- INDEX: EMP_DEPARTMENT_IX 
--

CREATE INDEX EMP_DEPARTMENT_IX ON EMPLOYEES(DEPARTMENT_ID)
;
-- 
-- INDEX: EMP_JOB_IX 
--

CREATE INDEX EMP_JOB_IX ON EMPLOYEES(JOB_ID)
;
-- 
-- INDEX: EMP_MANAGER_IX 
--

CREATE INDEX EMP_MANAGER_IX ON EMPLOYEES(MANAGER_ID)
;
-- 
-- INDEX: EMP_NAME_IX 
--

CREATE INDEX EMP_NAME_IX ON EMPLOYEES(LAST_NAME, FIRST_NAME)
;
-- 
-- INDEX: JHIST_JOB_IX 
--

CREATE INDEX JHIST_JOB_IX ON JOB_HISTORY(JOB_ID)
;
-- 
-- INDEX: JHIST_EMPLOYEE_IX 
--

CREATE INDEX JHIST_EMPLOYEE_IX ON JOB_HISTORY(EMPLOYEE_ID)
;
-- 
-- INDEX: JHIST_DEPARTMENT_IX 
--

CREATE INDEX JHIST_DEPARTMENT_IX ON JOB_HISTORY(DEPARTMENT_ID)
;
-- 
-- INDEX: LOC_CITY_IX 
--

CREATE INDEX LOC_CITY_IX ON LOCATIONS(CITY)
;
-- 
-- INDEX: LOC_STATE_PROVINCE_IX 
--

CREATE INDEX LOC_STATE_PROVINCE_IX ON LOCATIONS(STATE_PROVINCE)
;
-- 
-- INDEX: LOC_COUNTRY_IX 
--

CREATE INDEX LOC_COUNTRY_IX ON LOCATIONS(COUNTRY_ID)
;
-- 
-- TABLE: COUNTRIES 
--

ALTER TABLE COUNTRIES ADD CONSTRAINT COUNTR_REG_FK 
    FOREIGN KEY (REGION_ID)
    REFERENCES REGIONS(REGION_ID)
;


-- 
-- TABLE: DEPARTMENTS 
--

ALTER TABLE DEPARTMENTS ADD CONSTRAINT DEPT_LOC_FK 
    FOREIGN KEY (LOCATION_ID)
    REFERENCES LOCATIONS(LOCATION_ID)
;

ALTER TABLE DEPARTMENTS ADD CONSTRAINT DEPT_MGR_FK 
    FOREIGN KEY (MANAGER_ID)
    REFERENCES EMPLOYEES(EMPLOYEE_ID)
;


-- 
-- TABLE: EMPLOYEES 
--

ALTER TABLE EMPLOYEES ADD CONSTRAINT EMP_DEPT_FK 
    FOREIGN KEY (DEPARTMENT_ID)
    REFERENCES DEPARTMENTS(DEPARTMENT_ID)
;

ALTER TABLE EMPLOYEES ADD CONSTRAINT EMP_JOB_FK 
    FOREIGN KEY (JOB_ID)
    REFERENCES JOBS(JOB_ID)
;

ALTER TABLE EMPLOYEES ADD CONSTRAINT EMP_MANAGER_FK 
    FOREIGN KEY (MANAGER_ID)
    REFERENCES EMPLOYEES(EMPLOYEE_ID)
;


-- 
-- TABLE: JOB_HISTORY 
--

ALTER TABLE JOB_HISTORY ADD CONSTRAINT JHIST_DEPT_FK 
    FOREIGN KEY (DEPARTMENT_ID)
    REFERENCES DEPARTMENTS(DEPARTMENT_ID)
;

ALTER TABLE JOB_HISTORY ADD CONSTRAINT JHIST_EMP_FK 
    FOREIGN KEY (EMPLOYEE_ID)
    REFERENCES EMPLOYEES(EMPLOYEE_ID)
;

ALTER TABLE JOB_HISTORY ADD CONSTRAINT JHIST_JOB_FK 
    FOREIGN KEY (JOB_ID)
    REFERENCES JOBS(JOB_ID)
;


-- 
-- TABLE: LOCATIONS 
--

ALTER TABLE LOCATIONS ADD CONSTRAINT LOC_C_ID_FK 
    FOREIGN KEY (COUNTRY_ID)
    REFERENCES COUNTRIES(COUNTRY_ID)
;


https://github.com/connormcd/misc-scripts/blob/master/hr_quick_start.sql

