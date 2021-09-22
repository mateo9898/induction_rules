create or replace NONEDITIONABLE PACKAGE BODY RIP_RULE_INDUCTION IS

    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: RIP_RULE_INDUCTION.INDUCTION_CONTROLER */
    /* DATE: 22.09.2021 */
    /* ****************************** */
    PROCEDURE INDUCTION_CONTROLER IS
    BEGIN
        CREATE_MULTIPLIER_BETA;
        DOTP_DELETE_OLD_TABLE.DELETE_TABLE(p_name_table => SPP_SYSTEM_PARAMS.R_T_TABLE_NAME);
        CTP_CREATE_TABLE.CREATE_TABLE_R_T(p_name_table => SPP_SYSTEM_PARAMS.R_T_TABLE_NAME);
        CREATE_AND_GENERATE_R_T;
        INDUCTION_RULES;
        EXCEPTION 
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: RIP_RULE_INDUCTION.INDUCTION_CONTROLER');
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
                DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END INDUCTION_CONTROLER;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: RIP_RULE_INDUCTION.CREATE_MULTIPLIER_BETA */
    /* DATE: 17.08.2021 */
    /* ****************************** */
    PROCEDURE CREATE_MULTIPLIER_BETA IS
    BEGIN
        DOTP_DELETE_OLD_TABLE.DELETE_TABLE(p_name_table => 'M_' || SPP_SYSTEM_PARAMS.MULTIPLIER_BETA_TABLE_NAME);
        CTP_CREATE_TABLE.CREATE_TABLE_MULTIPLIER_BETA(p_name_table => SPP_SYSTEM_PARAMS.MULTIPLIER_BETA_TABLE_NAME);
        CTP_CREATE_TABLE.DROP_SEQUENCE_AND_CREATE_NEW(p_sequence => 'MS_' || SPP_SYSTEM_PARAMS.MULTIPLIER_BETA_TABLE_NAME);
        CTP_CREATE_TABLE.INSERT_MULTIPLIER_BETA(p_name_table => SPP_SYSTEM_PARAMS.MULTIPLIER_BETA_TABLE_NAME);
        EXCEPTION 
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: RIP_RULE_INDUCTION.CREATE_MULTIPLIER_BETA');
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
                DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END CREATE_MULTIPLIER_BETA;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: RIP_RULE_INDUCTION.CREATE_AND_GENERATE_R_T */
    /* DATE: 19.08.2021 */
    /* ****************************** */
    PROCEDURE CREATE_AND_GENERATE_R_T IS
        CURSOR c_tables_eav IS 
        SELECT TABLE_NAME FROM SYS.ALL_TABLES
        WHERE TABLE_NAME LIKE 'T_%_EAV';
        c_all_rec_from_eav SYS_REFCURSOR;
        v_table_name VARCHAR2(200);
        v_sql VARCHAR2(1000);
        v_sql_insert VARCHAR2(1000);
        v_r_t NUMBER := 0;
        v_dec_attribute VARCHAR2(200);
    BEGIN
        OPEN c_tables_eav;
        LOOP
            FETCH c_tables_eav INTO v_table_name;
            EXIT WHEN c_tables_eav%NOTFOUND;
            v_sql := 'SELECT MBC.OBJECT, MBC.ATTRIBUTE, MBC.VALUE FROM 
                      (SELECT ATTRIBUTE FROM ' || v_table_name || ' WHERE OBJECT = 1
                      MINUS
                      SELECT ATTRIBUTE FROM ' || v_table_name || ' WHERE OBJECT = 1 AND 
                      ROWNUM < (SELECT COUNT(*) FROM ' || v_table_name || ' WHERE OBJECT = 1)) DEC_A, 
                      (SELECT * FROM ' || v_table_name || ') MBC WHERE DEC_A.ATTRIBUTE = MBC.ATTRIBUTE';
            DECLARE
                v_object_1 NUMBER;
                v_attribute_1 VARCHAR2(50);
                v_value_1 VARCHAR2(50);
                v_dummy_1 NUMBER;
                v_sql_1 VARCHAR2(1000);
            BEGIN
                OPEN c_all_rec_from_eav FOR v_sql;
                LOOP
                    FETCH c_all_rec_from_eav INTO v_object_1, v_attribute_1, v_value_1;
                    EXIT WHEN c_all_rec_from_eav%NOTFOUND;
                    v_sql_1 := 'SELECT COUNT(*) FROM ' || v_table_name || ' WHERE OBJECT > ' || 
                    v_object_1 || ' AND ATTRIBUTE = ''' || v_attribute_1 || ''' AND VALUE <> ''' ||
                    v_value_1 || ''''; 
                    EXECUTE IMMEDIATE v_sql_1 INTO v_dummy_1;
                    v_r_t := v_r_t + v_dummy_1;
                END LOOP;
                v_dec_attribute := v_attribute_1;
            END;
            v_sql_insert := 'INSERT INTO '|| SPP_SYSTEM_PARAMS.R_T_TABLE_NAME || ' VALUES (''' || v_table_name ||
            ''', ' || v_r_t || ', '''|| v_dec_attribute ||''')'; 
            EXECUTE IMMEDIATE v_sql_insert;
            v_r_t := 0;
        END LOOP;
        CLOSE c_tables_eav;
        EXCEPTION 
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: RIP_RULE_INDUCTION.CREATE_AND_GENERATE_R_T');
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
                DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END CREATE_AND_GENERATE_R_T;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: RIP_RULE_INDUCTION.INDUCTION_RULES */
    /* DATE: 20.08.2021 */
    /* ****************************** */
    PROCEDURE INDUCTION_RULES IS
        c_R_T SYS_REFCURSOR;
        c_multiplier_beta SYS_REFCURSOR;
        c_object_nr SYS_REFCURSOR;
        c_row_from_eav SYS_REFCURSOR;
        v_sql_R_T VARCHAR2(1000);
        v_sql_multiplier_beta VARCHAR2(1000);
        v_table_name VARCHAR2(100);
        v_R_T NUMBER;
        v_dec_attrib VARCHAR2(100);
        v_multiplier NUMBER;
        v_sql_object_nr VARCHAR2(1000);
        v_sql_row_from_eav VARCHAR2(1000);
        v_object_nr NUMBER;
        v_attribute_row_eav VARCHAR2(50);
        v_value_row_eav VARCHAR2(50);
        t_r_R_from_T SPP_SYSTEM_PARAMS.t_r_R_from_T_type;
        empty_t_r_R_from_T SPP_SYSTEM_PARAMS.t_r_R_from_T_type;
        v_minimal_value NUMBER;
        v_index NUMBER;
        v_sql_count_R_T VARCHAR2(1000);
        v_dec_value VARCHAR2(50);
        v_sql VARCHAR2(1000);
        v_number_of_object NUMBER;
        v_dummy NUMBER;
        v_dummy_v VARCHAR2(1000);
        v_attribute_count NUMBER;
        v_R_T_value SPP_SYSTEM_PARAMS.r_R_T_value_type;
    BEGIN
        v_sql_R_T := 'SELECT T.TABLE_NAME, T.R_T, T.DEC_ATTRIB FROM ' || SPP_SYSTEM_PARAMS.R_T_TABLE_NAME || ' T';
        v_sql_multiplier_beta := 'SELECT T.MULTIPLIER FROM M_' || SPP_SYSTEM_PARAMS.MULTIPLIER_BETA_TABLE_NAME || ' T';
        v_sql_object_nr := 'SELECT DISTINCT T.OBJECT FROM '; 
        v_sql_row_from_eav := 'SELECT T.ATTRIBUTE, T.VALUE FROM ';
        v_sql_count_R_T := 'SELECT COUNT(*) FROM ';
        /* ALL TABLES */
        OPEN c_R_T FOR v_sql_R_T;
        LOOP
            FETCH c_R_T INTO v_table_name, v_R_T, v_dec_attrib;
            EXIT WHEN c_R_T%NOTFOUND;
            DOTP_DELETE_OLD_TABLE.DELETE_TABLE(p_name_table => SPP_SYSTEM_PARAMS.R_T_COUNTED);
            CTP_CREATE_TABLE.CREATE_TABLE_R_T_COUNTED(p_name_table => SPP_SYSTEM_PARAMS.R_T_COUNTED);
            v_number_of_object := COUNT_OBJECT_EAV(p_table_name => v_table_name);
            v_attribute_count := COUNT_ATTRIBUTE(p_table_name => v_table_name);
            CTP_CREATE_TABLE.CREATE_TABLE_INDUCTED_RULES(p_name_table => v_table_name);
            /* ALL MULTIPLIER FOR BETA */
            OPEN c_multiplier_beta FOR v_sql_multiplier_beta;
            LOOP
                FETCH c_multiplier_beta INTO v_multiplier;
                EXIT WHEN c_multiplier_beta%NOTFOUND;
                /* ALL OBJECT BY EAV*/
                v_sql := 'SELECT DISTINCT 1 FROM ' || NP_NAME_ELEMEMT.NAME_TABLE_RULES(v_table_name) 
                || ' WHERE BETA = ' || ROUND(v_R_T*v_multiplier);
                BEGIN
                    EXECUTE IMMEDIATE v_sql INTO v_dummy;
                    EXCEPTION WHEN NO_DATA_FOUND THEN
                        OPEN c_object_nr FOR v_sql_object_nr || v_table_name || ' T ORDER BY T.OBJECT ASC';
                        LOOP
                            FETCH c_object_nr INTO v_object_nr;
                            EXIT WHEN c_object_nr%NOTFOUND;
                            v_index := -1;
                            t_r_R_from_T := empty_t_r_R_from_T;
                            v_sql := 'SELECT T.VALUE FROM ' || v_table_name || ' T WHERE T.ATTRIBUTE = ''' ||
                            v_dec_attrib || ''' AND T.OBJECT = ' || v_object_nr;
                            EXECUTE IMMEDIATE v_sql INTO v_dec_value;
                            /* ALL RECORD FROM OBJECT EAV */
                            OPEN c_row_from_eav FOR v_sql_row_from_eav || v_table_name || ' T WHERE T.ATTRIBUTE <> ''' ||
                            v_dec_attrib || ''' AND T.OBJECT = ' || v_object_nr;
                            LOOP
                                FETCH c_row_from_eav INTO v_attribute_row_eav, v_value_row_eav;
                                EXIT WHEN c_row_from_eav%NOTFOUND;
                                v_index := v_index + 1;
                                BEGIN 
                                    v_sql := 'SELECT T.R_T, T.VALUES_, T.COUNTED, T.VALUE_DECISION FROM ' || SPP_SYSTEM_PARAMS.R_T_COUNTED || ' T WHERE T.R_T = ''' ||
                                    v_attribute_row_eav || ''' AND T.VALUES_ = ''' || v_value_row_eav || ''' AND T.VALUE_DECISION = ''' || v_dec_value || '''';
                                    EXECUTE IMMEDIATE v_sql INTO t_r_R_from_T(v_index).v_r_from_t, t_r_R_from_T(v_index).v_value, t_r_R_from_T(v_index).v_result, 
                                    t_r_R_from_T(v_index).v_decision;
                                    EXCEPTION WHEN NO_DATA_FOUND THEN
                                        v_dummy := COUNT_ALL_R_T(v_table_name, v_attribute_row_eav, v_value_row_eav, v_dec_attrib, v_number_of_object, v_dec_value);
                                        v_sql := 'INSERT INTO ' || SPP_SYSTEM_PARAMS.R_T_COUNTED || ' VALUES (''' ||
                                        v_attribute_row_eav || ''', ''' || v_value_row_eav || ''', ' ||
                                        v_dummy || ', ''' || v_dec_value || ''')';
                                        --DBMS_OUTPUT.PUT_LINE(v_sql);
                                        EXECUTE IMMEDIATE v_sql;
                                        t_r_R_from_T(v_index).v_r_from_t := v_attribute_row_eav;
                                        t_r_R_from_T(v_index).v_value := v_value_row_eav;
                                        t_r_R_from_T(v_index).v_result := v_dummy;
                                        t_r_R_from_T(v_index).v_decision := v_dec_value;
                                END;
                                --EXECUTE IMMEDIATE v_sql_count_R_T || v_table_name || ' WHERE OBJECT = ';
                                /*DBMS_OUTPUT.PUT_LINE(t_r_R_from_T(v_index).v_r_from_t || ' : ' || t_r_R_from_T(v_index).v_value || ' : ' || t_r_R_from_T(v_index).v_result || ' : ' ||
                                t_r_R_from_T(v_index).v_decision);*/
                                --DBMS_OUTPUT.PUT_LINE(COUNT_ALL_R_T(v_table_name, v_attribute_row_eav, v_value_row_eav, v_dec_attrib, v_number_of_object, v_dec_value));
                            END LOOP;
                            /* -1- OZNACZA JAK DOTAD BRAK SPELNIENTA WARUNKU <B(T)
                             * -2- OZNACZA BRAK MOZLIWOSCI SPELNIENIA WARUNKU B(T) 
                             * (ZA WYSOKI JEGO PROG ABY COKOLWIEK WYGENEROWAC) */
                            v_dummy_v := GENERATE_RULE_ROW (p_table_R_T => t_r_R_from_T, p_B_T => ROUND(v_R_T*v_multiplier));
                            --DBMS_OUTPUT.PUT_LINE(v_dummy_v);
                            WHILE v_dummy_v IN ('-1', '-2')
                            LOOP
                                v_R_T_value := MINIMAL_R_T_VALUE(p_table_R_T => t_r_R_from_T);
                                FOR i IN 0..v_attribute_count
                                LOOP
                                    IF t_r_R_from_T(i).v_r_from_t NOT LIKE '%' || v_R_T_value.v_r_from_t || '%' THEN
                                        --DBMS_OUTPUT.PUT_LINE(v_R_T_value.v_r_from_t || ' : ' || t_r_R_from_T(i).v_r_from_t);
                                       v_index := v_index + 1;
                                       BEGIN 
                                            v_sql := 'SELECT T.R_T, T.VALUES_, T.COUNTED, T.VALUE_DECISION FROM ' || SPP_SYSTEM_PARAMS.R_T_COUNTED || ' T WHERE T.R_T = ''' ||
                                            v_R_T_value.v_r_from_t || ',' || t_r_R_from_T(i).v_r_from_t || ''' AND T.VALUES_ = ''' ||
                                            v_R_T_value.v_value || ',' || t_r_R_from_T(i).v_value || ''' AND T.VALUE_DECISION = ''' || v_dec_value || '''';
                                            EXECUTE IMMEDIATE v_sql INTO t_r_R_from_T(v_index).v_r_from_t, t_r_R_from_T(v_index).v_value, t_r_R_from_T(v_index).v_result,
                                            t_r_R_from_T(v_index).v_decision;
                                            EXCEPTION WHEN NO_DATA_FOUND THEN
                                                v_dummy := COUNT_ALL_R_T(v_table_name, v_R_T_value.v_r_from_t || ',' || t_r_R_from_T(i).v_r_from_t,
                                                v_R_T_value.v_value || ',' || t_r_R_from_T(i).v_value, v_dec_attrib, v_number_of_object, v_dec_value);
                                                v_sql := 'INSERT INTO ' || SPP_SYSTEM_PARAMS.R_T_COUNTED || ' VALUES (''' ||
                                                v_R_T_value.v_r_from_t || ',' || t_r_R_from_T(i).v_r_from_t || ''', ''' ||
                                                v_R_T_value.v_value || ',' || t_r_R_from_T(i).v_value || ''', ' ||
                                                v_dummy || ', ''' || v_dec_value || ''')';
                                                EXECUTE IMMEDIATE v_sql;
                                                t_r_R_from_T(v_index).v_r_from_t := v_R_T_value.v_r_from_t || ',' || t_r_R_from_T(i).v_r_from_t;
                                                t_r_R_from_T(v_index).v_value := v_R_T_value.v_value || ',' || t_r_R_from_T(i).v_value;
                                                t_r_R_from_T(v_index).v_result := v_dummy;
                                                t_r_R_from_T(v_index).v_decision := v_dec_value;
                                       END;
                                    END IF;
                                END LOOP;
                                v_dummy_v := GENERATE_RULE_ROW (p_table_R_T => t_r_R_from_T, p_B_T => ROUND(v_R_T*v_multiplier));
                                --DBMS_OUTPUT.PUT_LINE(v_dummy_v);
                                IF v_dummy_v = '-1' AND REGEXP_COUNT(t_r_R_from_T(t_r_R_from_T.LAST).v_r_from_t, ',') = (v_attribute_count - 1) THEN
                                    v_dummy_v := '-2';
                                END IF;
                            END LOOP;
                            CTP_CREATE_TABLE.INSERT_DATA_RULE(p_name_table => v_table_name,
                                                              p_data => v_object_nr || ', ' || ROUND(v_R_T*v_multiplier) || ', ''' || REPLACE(v_dummy_v, '''', '''''') || '''');
                            DBMS_OUTPUT.PUT_LINE(v_object_nr || ': MULTIPLIER (' || v_multiplier || ') RULE ::' || v_dummy_v);
                            --DBMS_OUTPUT.PUT_LINE(v_dummy_v);
                            --DBMS_OUTPUT.PUT_LINE(v_object_nr);
                        END LOOP;
                END;
                --DBMS_OUTPUT.PUT_LINE(v_R_T*v_multiplier);
            END LOOP;
        END LOOP;
        EXCEPTION 
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: RIP_RULE_INDUCTION.INDUCTION_RULES');
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
                DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END INDUCTION_RULES;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: RIP_RULE_INDUCTION.COUNT_ALL_R_T */
    /* DATE: 22.08.2021 */
    /* ****************************** */
    FUNCTION COUNT_ALL_R_T (p_table_name IN VARCHAR2, p_attribute_row_eav IN VARCHAR2
    ,p_value_row_eav IN VARCHAR2, p_dec_attrib IN VARCHAR2, p_object_nr IN NUMBER, p_dec_value IN VARCHAR2) 
    RETURN NUMBER IS
        v_sql VARCHAR2(5000);
        v_result NUMBER := 0;
        v_pass NUMBER;
        v_value NUMBER DEFAULT NULL;
    BEGIN
        FOR i IN 1..p_object_nr 
        LOOP
            BEGIN
                v_sql := '';
                v_sql := v_sql || 'SELECT 1 FROM ' || p_table_name || ' T WHERE T.OBJECT = ' || i || ' AND T.ATTRIBUTE = ''' || p_dec_attrib ||
                ''' AND T.VALUE <> ''' || p_dec_value || '''';
                EXECUTE IMMEDIATE v_sql INTO v_pass;
                EXCEPTION WHEN NO_DATA_FOUND THEN
                    v_sql := '';
                    FOR f_record IN (SELECT REGEXP_SUBSTR(p_attribute_row_eav,'[^,]+', 1, LEVEL) AS ATTRIBUTE_, REGEXP_SUBSTR(p_value_row_eav,'[^,]+', 1, LEVEL) AS VALUE_
                    FROM DUAL CONNECT BY REGEXP_SUBSTR(p_attribute_row_eav, '[^,]+', 1, LEVEL) IS NOT NULL AND REGEXP_SUBSTR(p_value_row_eav, '[^,]+', 1, LEVEL) IS NOT NULL) 
                    LOOP
                        v_sql := v_sql || '(SELECT 1 FROM ' || p_table_name || ' T WHERE T.OBJECT = ' || i || ' AND T.ATTRIBUTE = ''' || f_record.ATTRIBUTE_ ||
                        ''' AND T.VALUE = ''' || f_record.VALUE_ || ''') INTERSECT ';
                    END LOOP;
                    v_sql := RTRIM(v_sql, ' INTERSECT ');
                    BEGIN
                        EXECUTE IMMEDIATE v_sql INTO v_pass;
                        IF v_value IS NULL THEN
                            v_sql := 'SELECT COUNT(*) FROM (SELECT DISTINCT T.OBJECT FROM ' || p_table_name || ' T WHERE (1 = 1)';
                            FOR f_record IN (SELECT REGEXP_SUBSTR(p_attribute_row_eav,'[^,]+', 1, LEVEL) AS ATTRIBUTE_, REGEXP_SUBSTR(p_value_row_eav,'[^,]+', 1, LEVEL) AS VALUE_
                            FROM DUAL CONNECT BY REGEXP_SUBSTR(p_attribute_row_eav, '[^,]+', 1, LEVEL) IS NOT NULL AND REGEXP_SUBSTR(p_value_row_eav, '[^,]+', 1, LEVEL) IS NOT NULL) 
                            LOOP
                               v_sql := v_sql || ' AND (SELECT T_2.VALUE FROM ' || p_table_name ||
                               ' T_2 WHERE T_2.OBJECT = T.OBJECT AND T_2.ATTRIBUTE = ''' || f_record.ATTRIBUTE_ || ''') = ''' || f_record.VALUE_ || '''';
                            END LOOP;
                            v_sql := v_sql || ' AND (SELECT T_2.VALUE FROM ' || p_table_name ||
                            ' T_2 WHERE T_2.OBJECT = T.OBJECT AND T_2.ATTRIBUTE = ''' || p_dec_attrib || ''') <> ''' || p_dec_value || ''')';
                            EXECUTE IMMEDIATE v_sql INTO v_value; 
                        END IF;
                        v_result := v_result + v_value;
                        EXCEPTION WHEN NO_DATA_FOUND THEN
                            NULL;
                    END;
            END;
        END LOOP;
        RETURN v_result;
        EXCEPTION 
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: RIP_RULE_INDUCTION.COUNT_ALL_R_T');
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
                DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END COUNT_ALL_R_T;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: RIP_RULE_INDUCTION.COUNT_OBJECT_EAV */
    /* DATE: 22.08.2021 */
    /* ****************************** */
    FUNCTION COUNT_OBJECT_EAV (p_table_name IN VARCHAR2) 
    RETURN NUMBER IS
        v_sql VARCHAR2(1000);
        v_result NUMBER;
    BEGIN
        v_sql := 'SELECT COUNT(*) FROM (SELECT T.OBJECT FROM ' || p_table_name || ' T GROUP BY T.OBJECT)';
        EXECUTE IMMEDIATE v_sql INTO v_result;
        RETURN v_result;
        EXCEPTION 
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: RIP_RULE_INDUCTION.COUNT_OBJECT_EAV');
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
                DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END COUNT_OBJECT_EAV;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: RIP_RULE_INDUCTION.GENERATE_RULE_ROW */
    /* DATE: 23.08.2021 */
    /* ****************************** */
    FUNCTION GENERATE_RULE_ROW (p_table_R_T IN SPP_SYSTEM_PARAMS.t_r_R_from_T_type, p_B_T IN NUMBER) 
    RETURN VARCHAR2 IS
        v_rule VARCHAR2(10000);
    BEGIN
        FOR i IN p_table_R_T.FIRST..p_table_R_T.LAST
        LOOP
            IF p_table_R_T(i).v_result <= p_B_T THEN
                FOR f_record IN (SELECT REGEXP_SUBSTR(p_table_R_T(i).v_r_from_t,'[^,]+', 1, LEVEL) AS ATTRIBUTE_, REGEXP_SUBSTR(p_table_R_T(i).v_value,'[^,]+', 1, LEVEL) AS VALUE_
                FROM DUAL CONNECT BY REGEXP_SUBSTR(p_table_R_T(i).v_r_from_t, '[^,]+', 1, LEVEL) IS NOT NULL AND REGEXP_SUBSTR(p_table_R_T(i).v_value, '[^,]+', 1, LEVEL) IS NOT NULL) 
                LOOP
                    v_rule := v_rule || '(' || f_record.ATTRIBUTE_ || ' = ''' || f_record.VALUE_ || ''') AND ';
                END LOOP;
                v_rule := RTRIM(v_rule, ' AND ') || ' ---> ' || p_table_R_T(i).v_decision;
                RETURN v_rule;
            END IF;
        END LOOP;
        RETURN '-1';
        EXCEPTION 
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: RIP_RULE_INDUCTION.GENERATE_RULE_ROW');
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
                DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END GENERATE_RULE_ROW;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: RIP_RULE_INDUCTION.COUNT_ATTRIBUTE */
    /* DATE: 23.08.2021 */
    /* ****************************** */
    FUNCTION COUNT_ATTRIBUTE (p_table_name IN VARCHAR2) 
    RETURN NUMBER IS
        v_sql VARCHAR2(500);
        v_result NUMBER;
    BEGIN
        v_sql := 'SELECT COUNT(*) FROM ' || p_table_name || ' WHERE OBJECT = 1';
        BEGIN
            EXECUTE IMMEDIATE v_sql INTO v_result;
            RETURN v_result - 1;
            EXCEPTION WHEN NO_DATA_FOUND THEN
                RETURN -1;
        END;
        EXCEPTION 
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: RIP_RULE_INDUCTION.GENERATE_RULE_ROW');
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
                DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END COUNT_ATTRIBUTE;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: RIP_RULE_INDUCTION.MINIMAL_R_T_VALUE */
    /* DATE: 23.08.2021 */
    /* ****************************** */
    FUNCTION MINIMAL_R_T_VALUE (p_table_R_T IN SPP_SYSTEM_PARAMS.t_r_R_from_T_type) 
    RETURN SPP_SYSTEM_PARAMS.r_R_T_value_type IS
        v_result SPP_SYSTEM_PARAMS.r_R_T_value_type;
        v_minimal_result NUMBER;
    BEGIN
        FOR i IN p_table_R_T.FIRST..p_table_R_T.LAST
        LOOP
            IF p_table_R_T(i).v_result < v_minimal_result OR v_minimal_result IS NULL OR 
            (REGEXP_COUNT(v_result.v_r_from_t, ',') < REGEXP_COUNT(p_table_R_T(i).v_r_from_t, ',') AND
            p_table_R_T(i).v_result = v_minimal_result) THEN
                v_result.v_r_from_t := p_table_R_T(i).v_r_from_t;
                v_result.v_value := p_table_R_T(i).v_value;
                v_minimal_result := p_table_R_T(i).v_result;
            END IF;
        END LOOP;
        RETURN v_result;
        EXCEPTION 
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: RIP_RULE_INDUCTION.MINIMAL_R_T_VALUE');
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
                DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END MINIMAL_R_T_VALUE;
END RIP_RULE_INDUCTION;