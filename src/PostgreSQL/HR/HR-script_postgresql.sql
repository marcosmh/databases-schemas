
--
-- ESQUEMA HR
-- Target DBMS : PostgreSQL
--



CREATE ROLE hr WITH
    LOGIN
    SUPERUSER
    CREATEDB
    CREATEROLE
    INHERIT
    REPLICATION
    BYPASSRLS
    CONNECTION LIMIT -1
    PASSWORD 'adminhr';
COMMENT ON ROLE hr IS 'usario hr:
adminhr';   


CREATE DATABASE hr
    WITH
    OWNER = hr
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

COMMENT ON DATABASE hr
    IS 'base de datos hr';

-- 
-- TABLE: COUNTRIES 
--

CREATE TABLE COUNTRIES(
    COUNTRY_ID    char(2)          NOT NULL,
    COUNTRY_NAME  varchar(40),
    REGION_ID     numeric(4,0),
    CONSTRAINT COUNTRY_C_ID_PK PRIMARY KEY (COUNTRY_ID)
)
;



-- 
-- TABLE: DEPARTMENTS 
--

CREATE TABLE DEPARTMENTS(
    DEPARTMENT_ID    numeric(4, 0)    NOT NULL,
    DEPARTMENT_NAME  varchar(30)      NOT NULL,
    MANAGER_ID       numeric(6, 0),
    LOCATION_ID      numeric(4, 0),
    CONSTRAINT DEPT_ID_PK PRIMARY KEY (DEPARTMENT_ID)
)
;



-- 
-- TABLE: EMPLOYEES 
--

CREATE TABLE EMPLOYEES(
    EMPLOYEE_ID     numeric(6, 0)    NOT NULL,
    FIRST_NAME      varchar(20),
    LAST_NAME       varchar(25)      NOT NULL,
    EMAIL           varchar(25)      NOT NULL,
    PHONE_NUMBER    varchar(20),
    HIRE_DATE       date             NOT NULL,
    JOB_ID          varchar(10)      NOT NULL,
    SALARY          numeric(8, 2),
    COMMISSION_PCT  numeric(2, 2),
    MANAGER_ID      numeric(6, 0),
    DEPARTMENT_ID   numeric(4, 0),
    CONSTRAINT EMP_EMP_ID_PK PRIMARY KEY (EMPLOYEE_ID)
)
;



-- 
-- TABLE: JOB_HISTORY 
--

CREATE TABLE JOB_HISTORY(
    EMPLOYEE_ID    numeric(6, 0)    NOT NULL,
    START_DATE     date             NOT NULL,
    END_DATE       date             NOT NULL,
    JOB_ID         varchar(10)      NOT NULL,
    DEPARTMENT_ID  numeric(4, 0),
    CONSTRAINT JHIST_EMP_ID_ST_DATE_PK PRIMARY KEY (EMPLOYEE_ID, START_DATE)
)
;



-- 
-- TABLE: JOBS 
--

CREATE TABLE JOBS(
    JOB_ID      varchar(10)      NOT NULL,
    JOB_TITLE   varchar(35)      NOT NULL,
    MIN_SALARY  numeric(6, 0),
    MAX_SALARY  numeric(6, 0),
    CONSTRAINT JOB_ID_PK PRIMARY KEY (JOB_ID)
)
;



-- 
-- TABLE: LOCATIONS 
--

CREATE TABLE LOCATIONS(
    LOCATION_ID     numeric(4, 0)    NOT NULL,
    STREET_ADDRESS  varchar(40),
    POSTAL_CODE     varchar(12),
    CITY            varchar(30)      NOT NULL,
    STATE_PROVINCE  varchar(25),
    COUNTRY_ID      char(2),
    CONSTRAINT LOC_ID_PK PRIMARY KEY (LOCATION_ID)
)
;



-- 
-- TABLE: REGIONS 
--

CREATE TABLE REGIONS(
    REGION_ID    numeric(4, 0)    NOT NULL,
    REGION_NAME  varchar(25),
    CONSTRAINT REG_ID_PK PRIMARY KEY (REGION_ID)
)
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

/*
ALTER TABLE DEPARTMENTS ADD CONSTRAINT DEPT_MGR_FK 
    FOREIGN KEY (MANAGER_ID)
    REFERENCES EMPLOYEES(EMPLOYEE_ID)
;
*/

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


CREATE SEQUENCE public.DEPARTMENTS_SEQ 
    INCREMENT BY 10 
    MAXVALUE 9999999999999999 
    MINVALUE 1 
;


CREATE SEQUENCE public.EMPLOYEES_SEQ 
    INCREMENT BY 1 
    MAXVALUE 9999999999999999 
    MINVALUE 1 
;


CREATE SEQUENCE public.LOCATIONS_SEQ 
    INCREMENT BY 100 
    MAXVALUE 9999999999999999 
    MINVALUE 1 
;


CREATE OR REPLACE VIEW EMP_DETAILS_VIEW AS 
SELECT
  E.EMPLOYEE_ID,
  E.JOB_ID,
  E.MANAGER_ID,
  E.DEPARTMENT_ID,
  D.LOCATION_ID,
  L.COUNTRY_ID,
  E.FIRST_NAME,
  E.LAST_NAME,
  E.SALARY,
  E.COMMISSION_PCT,
  D.DEPARTMENT_NAME,
  J.JOB_TITLE,
  L.CITY,
  L.STATE_PROVINCE,
  C.COUNTRY_NAME,
  R.REGION_NAME
FROM EMPLOYEES E
JOIN DEPARTMENTS D ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
JOIN JOBS J ON E.JOB_ID = J.JOB_ID
JOIN LOCATIONS L ON D.LOCATION_ID = L.LOCATION_ID
JOIN COUNTRIES C ON L.COUNTRY_ID = C.COUNTRY_ID
JOIN REGIONS R ON C.REGION_ID = R.REGION_ID;




CREATE OR REPLACE FUNCTION secure_dml()
RETURNS TRIGGER AS $$
DECLARE
    current_time TIME := CURRENT_TIME;
    current_day  TEXT := TO_CHAR(CURRENT_DATE, 'Dy');
BEGIN
    -- Verificar si es fin de semana (sábado o domingo)
    IF current_day IN ('Sat', 'Sun') THEN
        RAISE EXCEPTION 'Solo se permiten modificaciones durante el horario laboral: lunes a viernes, de 08:00 a 18:00.';
    END IF;

    -- Verificar si está fuera del horario laboral (antes de las 08:00 o después de las 18:00)
    IF current_time NOT BETWEEN '08:00:00' AND '18:00:00' THEN
        RAISE EXCEPTION 'Solo se permiten modificaciones durante el horario laboral: lunes a viernes, de 08:00 a 18:00.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER secure_employees
BEFORE INSERT OR UPDATE OR DELETE ON EMPLOYEES
FOR EACH ROW
EXECUTE FUNCTION secure_dml();


CREATE OR REPLACE FUNCTION add_job_history(
    p_employee_id NUMERIC,
    p_start_date DATE,
    p_end_date DATE,
    p_job_id VARCHAR,
    p_department_id NUMERIC
) RETURNS VOID AS $$
BEGIN
    INSERT INTO job_history (employee_id, start_date, end_date, job_id, department_id)
    VALUES (p_employee_id, p_start_date, p_end_date, p_job_id, p_department_id);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION trg_update_job_history()
RETURNS TRIGGER AS $$
BEGIN
    -- Llama a la función si job_id o department_id han cambiado
    IF OLD.job_id IS DISTINCT FROM NEW.job_id OR OLD.department_id IS DISTINCT FROM NEW.department_id THEN
        PERFORM add_job_history(
            OLD.employee_id,
            OLD.hire_date,
            CURRENT_DATE,
            OLD.job_id,
            OLD.department_id
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_job_history
AFTER UPDATE ON EMPLOYEES
FOR EACH ROW
EXECUTE FUNCTION trg_update_job_history();


/*
CREATE OR REPLACE FUNCTION add_job_history(
    p_employee_id NUMERIC,
    p_start_date DATE,
    p_end_date DATE,
    p_job_id VARCHAR,
    p_department_id NUMERIC
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO job_history (employee_id, start_date, end_date, job_id, department_id)
    VALUES (p_emp_id, p_start_date, p_end_date, p_job_id, p_department_id);
END;
$$ LANGUAGE plpgsql;
*/

CREATE OR REPLACE FUNCTION trg_update_job_history()
RETURNS TRIGGER AS $$
BEGIN
    -- Llamar a la función add_job_history con los valores anteriores a la actualización
    PERFORM add_job_history(
        OLD.employee_id,
        OLD.hire_date,
        CURRENT_DATE,
        OLD.job_id,
        OLD.department_id
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;



