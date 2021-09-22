create or replace NONEDITIONABLE PACKAGE BODY RPP_RULLES_PARAMETERS IS
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: RPP_RULLES_PARAMETERS.GENERATE_RULES_PARAMETERS */
    /* DATE: 22.09.2021 */
    /* ****************************** */
    PROCEDURE GENERATE_RULES_PARAMETERS IS
        c_files_name SYS_REFCURSOR;
        c_rules SYS_REFCURSOR;
        v_object_nr NUMBER;
        v_beta NUMBER;
        v_rule VARCHAR2(2000);
        v_file_name VARCHAR2(150);
        v_name_table_rules VARCHAR2(300);
        v_sql VARCHAR2(300);
    BEGIN
        OPEN c_files_name FOR 'SELECT FILE_NAME FROM FN_FILES_NAME';
        LOOP
            FETCH c_files_name INTO v_file_name;
            EXIT WHEN c_files_name%NOTFOUND;
            v_file_name := NP_NAME_ELEMEMT.NAME_TABLE_RULES(NP_NAME_ELEMEMT.NAME_TABLE_EAV(p_text => v_file_name));
            OPEN c_rules FOR 'SELECT NR_OBJECT, BETA, RULE FROM ' || v_file_name;
            LOOP
                FETCH c_rules INTO v_object_nr, v_beta, v_rule;
                EXIT WHEN c_rules%NOTFOUND;
                /*DBMS_OUTPUT.PUT_LINE(v_object_nr || ' : ' || v_beta || ' : ' || v_rule || ' : ' || RULE_LENGTH(p_rule => v_rule) || ' : ' || SUPPORT(p_rule => v_rule, p_beta => v_beta, 
                p_table => v_file_name) || ' : ' || MISTAKE(p_rule => v_rule, p_beta => v_beta, p_table => v_file_name));*/
                v_sql := 'UPDATE ' || v_file_name || ' SET LENGTH = ' || RULE_LENGTH(p_rule => v_rule) || ', SUPPORT = ' || 
                SUPPORT(p_rule => v_rule, p_beta => v_beta, p_table => v_file_name) || ', MISTAKE = ' ||
                MISTAKE(p_rule => v_rule, p_beta => v_beta, p_table => v_file_name) || ' WHERE NR_OBJECT = ' ||
                v_object_nr || ' AND BETA = ' || v_beta;
                EXECUTE IMMEDIATE v_sql;
            END LOOP;
        END LOOP;
        EXCEPTION WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: RPP_RULLES_PARAMETERS.GENERATE_RULES_PARAMETERS');
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
            DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: RPP_RULLES_PARAMETERS.RULE_LENGTH */
    /* DATE: 22.09.2021 */
    /* ****************************** */
    FUNCTION RULE_LENGTH(p_rule IN VARCHAR2) 
    RETURN NUMBER IS
    BEGIN
        RETURN REGEXP_COUNT(p_rule, 'AND') + 1;
        EXCEPTION WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: RPP_RULLES_PARAMETERS.RULE_LENGTH');
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
            DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END RULE_LENGTH; 
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: RPP_RULLES_PARAMETERS.SUPPORT */
    /* DATE: 22.09.2021 */
    /* ****************************** */
    FUNCTION SUPPORT(p_rule IN VARCHAR2, p_beta IN NUMBER, p_table IN VARCHAR2) 
    RETURN NUMBER IS
        v_sql VARCHAR2(1000);
        v_dummy NUMBER;
    BEGIN
        v_sql := 'SELECT COUNT(1) FROM ' || p_table || ' WHERE RULE = ''' ||
        REPLACE(p_rule, '''', '''''') || ''' AND BETA = ' || p_beta;
        EXECUTE IMMEDIATE v_sql INTO v_dummy;
        RETURN v_dummy;
        EXCEPTION WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: RPP_RULLES_PARAMETERS.SUPPORT');
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
            DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END SUPPORT; 
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: RPP_RULLES_PARAMETERS.MISTAKE */
    /* DATE: 22.09.2021 */
    /* ****************************** */
    FUNCTION MISTAKE(p_rule IN VARCHAR2, p_beta IN NUMBER, p_table IN VARCHAR2) 
    RETURN NUMBER IS
        v_sql VARCHAR2(1000);
        v_dummy NUMBER;
    BEGIN
        v_sql := 'SELECT COUNT(1) FROM ' || p_table || ' R WHERE SUBSTR(R.RULE, 0, INSTR(R.RULE, ''--->'') - 2) = ' ||
        'SUBSTR(''' || REPLACE(p_rule, '''', '''''') || ''', 0, INSTR(''' || REPLACE(p_rule, '''', '''''') || ''', ''--->'') - 2)' || 
        ' AND SUBSTR(R.RULE, INSTR(R.RULE, ''--->'') + 5) <> ' ||
        'SUBSTR(''' || REPLACE(p_rule, '''', '''''') || ''', INSTR(''' || REPLACE(p_rule, '''', '''''') || ''', ''--->'') + 5)' || ' AND R.BETA = ' || p_beta;
        EXECUTE IMMEDIATE v_sql INTO v_dummy;
        RETURN v_dummy;
        EXCEPTION WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: RPP_RULLES_PARAMETERS.MISTAKE');
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
            DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END MISTAKE;
END RPP_RULLES_PARAMETERS;