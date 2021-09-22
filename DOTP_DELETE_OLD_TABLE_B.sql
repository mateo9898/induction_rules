create or replace NONEDITIONABLE PACKAGE BODY DOTP_DELETE_OLD_TABLE IS

    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: DOTP_CREATE_OLD_TABLE.DELETE_OLD_TABLE */
    /* DATE: 14.08.2021 */
    /* ****************************** */
    PROCEDURE DELETE_OLD_TABLE IS
        c_files_name SYS_REFCURSOR;
        v_sql VARCHAR2(500);
        v_file_name VARCHAR2(150);
        e_table_no_exist EXCEPTION;
        PRAGMA EXCEPTION_INIT(e_table_no_exist, -00942);
    BEGIN
        OPEN c_files_name FOR 'SELECT FILE_NAME FROM FN_FILES_NAME';
        LOOP
            FETCH c_files_name INTO v_file_name;
            EXIT WHEN c_files_name%NOTFOUND;
            v_sql := 'DROP TABLE ' || NP_NAME_ELEMEMT.NAME_TABLE(p_text => v_file_name);
            BEGIN 
                EXECUTE IMMEDIATE v_sql;
                EXCEPTION WHEN e_table_no_exist THEN
                    NULL;
            END;
            v_sql := 'DROP TABLE ' || NP_NAME_ELEMEMT.NAME_TABLE_EAV(p_text => v_file_name);
            BEGIN 
                EXECUTE IMMEDIATE v_sql;
                EXCEPTION WHEN e_table_no_exist THEN
                    NULL;
            END;
            DELETE_OLD_SEQUENCE(p_name_sequence => v_file_name);
        END LOOP;
        EXCEPTION WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: DOTP_DELETE_OLD_TABLE.DELETE_OLD_TABLE');
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
            DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END DELETE_OLD_TABLE;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: DOTP_CREATE_OLD_TABLE.DELETE_OLD_SEQUENCE */
    /* DATE: 14.08.2021 */
    /* ****************************** */
    PROCEDURE DELETE_OLD_SEQUENCE(p_name_sequence IN VARCHAR2) IS
        v_sql VARCHAR2(500);
        e_sequence_no_exist EXCEPTION;
        PRAGMA EXCEPTION_INIT(e_sequence_no_exist, -02289);
    BEGIN
        v_sql := 'DROP SEQUENCE ' || NP_NAME_ELEMEMT.NAME_SEQUENCE(p_text => p_name_sequence);
        EXECUTE IMMEDIATE v_sql;
        EXCEPTION 
            WHEN e_sequence_no_exist THEN
                NULL;
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: DOTP_DELETE_OLD_TABLE.DELETE_OLD_SEQUENCE');
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
                DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END DELETE_OLD_SEQUENCE;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: DOTP_CREATE_OLD_TABLE.DELETE_TABLE */
    /* DATE: 17.08.2021 */
    /* ****************************** */
    PROCEDURE DELETE_TABLE(p_name_table IN VARCHAR2) IS
        v_sql VARCHAR2(500);
        e_table_no_exist EXCEPTION;
        PRAGMA EXCEPTION_INIT(e_table_no_exist, -00942);
    BEGIN
        v_sql := 'DROP TABLE ' || p_name_table;
        EXECUTE IMMEDIATE v_sql;
        EXCEPTION 
            WHEN e_table_no_exist THEN
                NULL;
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: DOTP_DELETE_OLD_TABLE.DELETE_TABLE');
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
                DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END DELETE_TABLE;
END DOTP_DELETE_OLD_TABLE;