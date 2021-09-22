create or replace NONEDITIONABLE PACKAGE BODY CTP_CREATE_TABLE IS

    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: CTP_CREATE_TABLE.CR_FILES_NAME */
    /* DATE: 13.08.2021 */
    /* ****************************** */
    PROCEDURE CR_FILES_NAME IS
        v_sql VARCHAR2(500);
        e_sequence_exist EXCEPTION;
        PRAGMA EXCEPTION_INIT(e_sequence_exist, -00955);
    BEGIN
        v_sql := 'CREATE TABLE FN_FILES_NAME (ID_FILE NUMBER PRIMARY KEY, FILE_NAME VARCHAR2(150))';
        EXECUTE IMMEDIATE v_sql;
        v_sql := 'CREATE SEQUENCE FNS_FILES_NAME START WITH 1 INCREMENT BY 1';
        EXECUTE IMMEDIATE v_sql;
        EXCEPTION 
            WHEN e_sequence_exist THEN
                DROP_SEQUENCE_AND_CREATE_NEW (p_sequence => 'FNS_FILES_NAME');
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: RASP_CREATE_DATA.CR_FILES_NAME');
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
                DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END CR_FILES_NAME;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: CTP_CREATE_TABLE.IS_TABLE_EXIST */
    /* DATE: 13.08.2021 */
    /* ****************************** */
    FUNCTION IS_TABLE_EXIST (p_table_name IN VARCHAR2) 
    RETURN NUMBER IS
        v_dummy NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_dummy FROM ALL_TABLES DT WHERE DT.TABLE_NAME = p_table_name;
        RETURN v_dummy;
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: RASP_CREATE_DATA.IS_TABLE_EXIST');
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
                DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END IS_TABLE_EXIST;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: CTP_CREATE_TABLE.DROP_SEQUENCE_AND_CREATE_NEW */
    /* DATE: 13.08.2021 */
    /* ****************************** */
    PROCEDURE DROP_SEQUENCE_AND_CREATE_NEW(p_sequence IN VARCHAR2) IS
        v_sql VARCHAR2(500);
        e_sequence_no_exist EXCEPTION;
        PRAGMA EXCEPTION_INIT(e_sequence_no_exist, -02289);
    BEGIN
        v_sql := 'DROP SEQUENCE ' || p_sequence;
        BEGIN
            EXECUTE IMMEDIATE v_sql;
        EXCEPTION
            WHEN e_sequence_no_exist THEN
                NULL;
        END;
        v_sql := 'CREATE SEQUENCE ' || p_sequence || ' START WITH 1 INCREMENT BY 1';
        EXECUTE IMMEDIATE v_sql;
        EXCEPTION 
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: RASP_CREATE_DATA.DROP_SEQUENCE_AND_CREATE_NEW');
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
                DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END DROP_SEQUENCE_AND_CREATE_NEW;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: CTP_CREATE_TABLE.CREATE_TABLE_FROM_FILE */
    /* DATE: 14.08.2021 */
    /* ****************************** */
    PROCEDURE CREATE_TABLE_FROM_FILE(p_name_table IN VARCHAR2,
                                     p_all_column IN VARCHAR2) IS
        v_sql VARCHAR2(10000);
    BEGIN
        v_sql := 'CREATE TABLE ' || NP_NAME_ELEMEMT.NAME_TABLE(p_text => p_name_table) || ' (ID_ROW NUMBER PRIMARY KEY';
        FOR f_record IN (SELECT REGEXP_SUBSTR(p_all_column,'[^,]+', 1, LEVEL) AS COLUMN_NAME FROM DUAL CONNECT BY REGEXP_SUBSTR(p_all_column, '[^,]+', 1, LEVEL) IS NOT NULL) 
        LOOP
          v_sql := v_sql || ', ' || NP_NAME_ELEMEMT.NAME_ATTRIBUTE(p_text => f_record.COLUMN_NAME) || ' VARCHAR2(75)';
        END LOOP;
        v_sql := v_sql || ')';
        EXECUTE IMMEDIATE v_sql;
        v_sql := 'CREATE SEQUENCE ' || NP_NAME_ELEMEMT.NAME_SEQUENCE(p_text => p_name_table) || ' START WITH 1 INCREMENT BY 1';
        EXECUTE IMMEDIATE v_sql;
        EXCEPTION 
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: CTP_CREATE_TABLE.CREATE_TABLE_FROM_FILE');
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
                DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END CREATE_TABLE_FROM_FILE;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: CTP_CREATE_TABLE.INSERT_DATA */
    /* DATE: 14.08.2021 */
    /* ****************************** */
    PROCEDURE INSERT_DATA(p_name_table IN VARCHAR2,
                          p_data IN VARCHAR2) IS
        v_sql VARCHAR2(10000);
    BEGIN
        v_sql := 'INSERT INTO ' || NP_NAME_ELEMEMT.NAME_TABLE(p_name_table) || 
        ' VALUES (' || NP_NAME_ELEMEMT.NAME_SEQUENCE(p_name_table) || '.NEXTVAL';
        FOR f_record IN (SELECT REGEXP_SUBSTR(p_data,'[^,]+', 1, LEVEL) AS VALUE_ FROM DUAL CONNECT BY REGEXP_SUBSTR(p_data, '[^,]+', 1, LEVEL) IS NOT NULL) 
        LOOP
          v_sql := v_sql || ', ''' || f_record.VALUE_ || '''';
        END LOOP;
        v_sql := v_sql || ')';
        EXECUTE IMMEDIATE v_sql;
        EXCEPTION 
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: CTP_CREATE_TABLE.INSERT_DATA');
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
                DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END INSERT_DATA;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: CTP_CREATE_TABLE.CREATE_TABLE_EAV */
    /* DATE: 14.08.2021 */
    /* ****************************** */
    PROCEDURE CREATE_TABLE_EAV(p_name_table IN VARCHAR2) IS
        v_sql VARCHAR2(1000);
    BEGIN
        v_sql := 'CREATE TABLE ' || NP_NAME_ELEMEMT.NAME_TABLE_EAV(p_text => p_name_table) || 
        ' (OBJECT NUMBER, ATTRIBUTE VARCHAR2(50), VALUE VARCHAR2(50))';
        EXECUTE IMMEDIATE v_sql;
        EXCEPTION 
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: CTP_CREATE_TABLE.CREATE_TABLE_EAV');
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
                DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END CREATE_TABLE_EAV;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: CTP_CREATE_TABLE.INSERT_DATA_EAV */
    /* DATE: 14.08.2021 */
    /* ****************************** */
    PROCEDURE INSERT_DATA_EAV(p_name_table IN VARCHAR2,
                              p_data IN VARCHAR2,
                              p_attribute IN VARCHAR2,
                              p_object_nr IN NUMBER) IS
        v_sql VARCHAR2(1000);
    BEGIN
        FOR f_record IN (SELECT REGEXP_SUBSTR(p_attribute,'[^,]+', 1, LEVEL) AS ATTRIBUTE_, REGEXP_SUBSTR(p_data,'[^,]+', 1, LEVEL) AS VALUE_ 
        FROM DUAL CONNECT BY REGEXP_SUBSTR(p_attribute, '[^,]+', 1, LEVEL) IS NOT NULL AND REGEXP_SUBSTR(p_data, '[^,]+', 1, LEVEL) IS NOT NULL) 
        LOOP
          v_sql := 'INSERT INTO ' || NP_NAME_ELEMEMT.NAME_TABLE_EAV(p_name_table) || ' VALUES (' || p_object_nr || ', ''' || f_record.ATTRIBUTE_ || ''', ''' || 
          f_record.VALUE_ || ''')';
          EXECUTE IMMEDIATE v_sql;
        END LOOP;
        EXCEPTION 
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: CTP_CREATE_TABLE.INSERT_DATA_EAV');
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
                DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END INSERT_DATA_EAV;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: CTP_CREATE_TABLE.CREATE_TABLE_MULTIPLIER_BETA */
    /* DATE: 17.08.2021 */
    /* ****************************** */
    PROCEDURE CREATE_TABLE_MULTIPLIER_BETA(p_name_table IN VARCHAR2) IS  
        v_sql VARCHAR2(1000);
    BEGIN
        v_sql := 'CREATE TABLE M_' || p_name_table || ' (ID_MULTIPLIER NUMBER PRIMARY KEY, MULTIPLIER NUMBER NOT NULL)';
        EXECUTE IMMEDIATE v_sql;
        EXCEPTION 
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: CTP_CREATE_TABLE.CREATE_TABLE_MULTIPLIER_BETA');
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
                DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END CREATE_TABLE_MULTIPLIER_BETA;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: CTP_CREATE_TABLE.INSERT_MULTIPLIER_BETA */
    /* DATE: 17.08.2021 */
    /* ****************************** */
    PROCEDURE INSERT_MULTIPLIER_BETA (p_name_table IN VARCHAR2) IS
        v_sql VARCHAR2(1000);
    BEGIN
        v_sql := 'INSERT INTO M_' || p_name_table || ' VALUES (MS_' || p_name_table || '.NEXTVAL, ';
        EXECUTE IMMEDIATE v_sql || '0)';
        EXECUTE IMMEDIATE v_sql || '0.01)';
        EXECUTE IMMEDIATE v_sql || '0.1)';
        EXECUTE IMMEDIATE v_sql || '0.2)';
        EXECUTE IMMEDIATE v_sql || '0.3)';
        EXECUTE IMMEDIATE v_sql || '0.5)';
        EXCEPTION 
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: CTP_CREATE_TABLE.INSERT_MULTIPLIER_BETA');
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
                DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: CTP_CREATE_TABLE.CREATE_TABLE_R_T */
    /* DATE: 20.08.2021 */
    /* ****************************** */
    PROCEDURE CREATE_TABLE_R_T(p_name_table IN VARCHAR2) IS
        v_sql VARCHAR2(1000);
    BEGIN
        v_sql := 'CREATE TABLE ' || p_name_table || 
        ' (TABLE_NAME VARCHAR2(100), R_T NUMBER, DEC_ATTRIB VARCHAR2(100))';
        EXECUTE IMMEDIATE v_sql;
        EXCEPTION 
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: CTP_CREATE_TABLE.CREATE_TABLE_R_T');
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
                DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END CREATE_TABLE_R_T;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: CTP_CREATE_TABLE.CREATE_TABLE_R_T_COUNTED */
    /* DATE: 22.08.2021 */
    /* ****************************** */
    PROCEDURE CREATE_TABLE_R_T_COUNTED(p_name_table IN VARCHAR2) IS
        v_sql VARCHAR2(1000);
    BEGIN
        v_sql := 'CREATE TABLE ' || p_name_table || 
        ' (R_T VARCHAR2(1000), VALUES_ VARCHAR2(1000), COUNTED NUMBER, VALUE_DECISION VARCHAR2(100))';
        EXECUTE IMMEDIATE v_sql;
        EXCEPTION 
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: CTP_CREATE_TABLE.CREATE_TABLE_R_T');
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
                DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END CREATE_TABLE_R_T_COUNTED;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: CTP_CREATE_TABLE.DROP_CREATE_TABLE_INDUCTED_RULES */
    /* DATE: 21.09.2021 */
    /* ****************************** */
    PROCEDURE DROP_CREATE_TABLE_INDUCTED_RULES(p_name_table IN VARCHAR2) IS
        v_sql VARCHAR2(1000);
    BEGIN
        DOTP_DELETE_OLD_TABLE.DELETE_TABLE(NP_NAME_ELEMEMT.NAME_TABLE_RULES(p_name_table));
        v_sql := 'CREATE TABLE ' || NP_NAME_ELEMEMT.NAME_TABLE_RULES(p_name_table) || 
        ' (NR_OBJECT NUMBER, BETA NUMBER, RULE VARCHAR2(2000))';
        EXECUTE IMMEDIATE v_sql;
        EXCEPTION 
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: CTP_CREATE_TABLE.DROP_CREATE_TABLE_INDUCTED_RULES');
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
                DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END DROP_CREATE_TABLE_INDUCTED_RULES;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: CTP_CREATE_TABLE.INSERT_DATA_RULE */
    /* DATE: 21.09.2021 */
    /* ****************************** */
    PROCEDURE INSERT_DATA_RULE(p_name_table IN VARCHAR2,
                               p_data IN VARCHAR2) IS
        v_sql VARCHAR2(2000);
    BEGIN
        v_sql := 'INSERT INTO ' || NP_NAME_ELEMEMT.NAME_TABLE_RULES(p_name_table) || ' VALUES (' || p_data || ')';
        EXECUTE IMMEDIATE v_sql;
        EXCEPTION 
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: CTP_CREATE_TABLE.INSERT_DATA_RULE');
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
                DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END INSERT_DATA_RULE;
END CTP_CREATE_TABLE;