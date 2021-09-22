create or replace NONEDITIONABLE PACKAGE BODY RASP_CREATE_DATA IS

    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: RASP_CREATE_DATA.READ_FROM_FILE */
    /* DATE: 13.08.2021 */
    /* ****************************** */
    PROCEDURE READ_FROM_FILE IS 
        v_dummy VARCHAR2(500);
        v_dir VARCHAR2(200) := 'FILE_DIR';
    BEGIN
        SELECT AD.DIRECTORY_PATH INTO v_dir FROM ALL_DIRECTORIES AD WHERE AD.DIRECTORY_NAME = 'FILE_DIR';
        LIST_FILES(v_dir);
        CREATE_TABLE_BY_FILE;
    END READ_FROM_FILE;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: RASP_CREATE_DATA.LIST_FILES */
    /* DATE: 13.08.2021 */
    /* ****************************** */
    PROCEDURE LIST_FILES (p_direct IN VARCHAR2) IS
        v_dummy_f NUMBER;
        v_list_file_names VARCHAR2(10000);
        v_sql VARCHAR2(500);
    BEGIN
        v_dummy_f := CTP_CREATE_TABLE.IS_TABLE_EXIST(p_table_name => 'FN_FILES_NAME');
        IF v_dummy_f = 0 THEN
            CTP_CREATE_TABLE.CR_FILES_NAME;
        ELSE 
            /* USUWANIE STARYCH */
            DOTP_DELETE_OLD_TABLE.DELETE_OLD_TABLE;
            CTP_CREATE_TABLE.DROP_SEQUENCE_AND_CREATE_NEW (p_sequence => 'FNS_FILES_NAME');
            v_sql := 'DELETE FROM FN_FILES_NAME';
            EXECUTE IMMEDIATE v_sql;
        END IF;
        v_list_file_names := FILE_LIST_API.list (p_direct);
        FOR f_record IN (SELECT REGEXP_SUBSTR(v_list_file_names,'[^,]+', 1, LEVEL) AS FILE_NAME FROM DUAL CONNECT BY REGEXP_SUBSTR(v_list_file_names, '[^,]+', 1, LEVEL) IS NOT NULL) 
        LOOP
          v_sql := 'INSERT INTO FN_FILES_NAME (ID_FILE, FILE_NAME) VALUES (FNS_FILES_NAME.NEXTVAL, ''' || f_record.FILE_NAME || ''')';
          EXECUTE IMMEDIATE v_sql;
        END LOOP;
        EXCEPTION WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: RASP_CREATE_DATA.LIST_FILES');
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
            DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END LIST_FILES;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: RASP_CREATE_DATA.CREATE_TABLE_BY_FILE */
    /* DATE: 14.08.2021 */
    /* ****************************** */
    PROCEDURE CREATE_TABLE_BY_FILE IS
        c_files_name SYS_REFCURSOR;
        v_file_name VARCHAR2(150);
        f_file UTL_FILE.FILE_TYPE;
        v_dummy VARCHAR2(500);
        v_object_nr NUMBER DEFAULT 1;
        v_columns_string VARCHAR2(500);
    BEGIN
        OPEN c_files_name FOR 'SELECT FILE_NAME FROM FN_FILES_NAME';
        LOOP
            FETCH c_files_name INTO v_file_name;
            EXIT WHEN c_files_name%NOTFOUND;
            BEGIN
                f_file := UTL_FILE.FOPEN('FILE_DIR', v_file_name, 'R');
                UTL_FILE.GET_LINE(f_file, v_columns_string);
                CTP_CREATE_TABLE.CREATE_TABLE_FROM_FILE(p_name_table => v_file_name,
                                                        p_all_column => v_columns_string);
                CTP_CREATE_TABLE.CREATE_TABLE_EAV(p_name_table => v_file_name);
                /* BECAUSE IN THIS LINE IS FORMAT COLUMN SO WE MUST SKIP */
                UTL_FILE.GET_LINE(f_file, v_dummy);
                v_object_nr := 1;
                LOOP
                    UTL_FILE.GET_LINE(f_file, v_dummy);
                    CTP_CREATE_TABLE.INSERT_DATA(p_name_table => v_file_name,
                                                 p_data => v_dummy);
                    CTP_CREATE_TABLE.INSERT_DATA_EAV(p_name_table => v_file_name,
                                                     p_data => v_dummy,
                                                     p_attribute => v_columns_string,
                                                     p_object_nr => v_object_nr);
                    v_object_nr := v_object_nr + 1;
                END LOOP;
                EXCEPTION WHEN NO_DATA_FOUND THEN
                    UTL_FILE.FCLOSE(f_file);
            END;
        END LOOP;
        EXCEPTION WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: RASP_CREATE_DATA.CREATE_TABLE_BY_FILE');
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
            DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END;
END RASP_CREATE_DATA;