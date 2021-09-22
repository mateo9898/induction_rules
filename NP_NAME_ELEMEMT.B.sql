create or replace NONEDITIONABLE PACKAGE BODY NP_NAME_ELEMEMT IS

    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: NP_NAME_ELEMEMT.NAME_TABLE */
    /* DATE: 14.08.2021 */
    /* ****************************** */
    FUNCTION NAME_TABLE(p_text IN VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN 'T_' || UPPER(REGEXP_REPLACE(p_text, '[^0-9A-Za-z]', '_'));
        EXCEPTION 
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: NP_NAME_ELEMEMT.NAME_TABLE');
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
                DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END NAME_TABLE;

    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: NP_NAME_ELEMEMT.NAME_SEQUENCE */
    /* DATE: 14.08.2021 */
    /* ****************************** */
    FUNCTION NAME_SEQUENCE(p_text IN VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN 'TS_' || UPPER(REGEXP_REPLACE(p_text, '[^0-9A-Za-z]', '_'));
        EXCEPTION 
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: NP_NAME_ELEMEMT.NAME_SEQUENCE');
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
                DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END NAME_SEQUENCE;

    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: NP_NAME_ELEMEMT.NAME_ATTRIBUTE */
    /* DATE: 14.08.2021 */
    /* ****************************** */
    FUNCTION NAME_ATTRIBUTE(p_text IN VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN UPPER(REGEXP_REPLACE(p_text, '[^0-9A-Za-z]', '_')) || '_';
        EXCEPTION 
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: NP_NAME_ELEMEMT.NAME_ATTRIBUTE');
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
                DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END NAME_ATTRIBUTE;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: NP_NAME_ELEMEMT.NAME_TABLE_EAV */
    /* DATE: 14.08.2021 */
    /* ****************************** */
    FUNCTION NAME_TABLE_EAV(p_text IN VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN 'T_' || UPPER(REGEXP_REPLACE(p_text, '[^0-9A-Za-z]', '_')) || '_EAV';
        EXCEPTION 
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: NP_NAME_ELEMEMT.NAME_TABLE_EAV');
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
                DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END NAME_TABLE_EAV;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: NP_NAME_ELEMEMT.NAME_TABLE_RULES */
    /* DATE: 21.09.2021 */
    /* ****************************** */
    FUNCTION NAME_TABLE_RULES(p_text IN VARCHAR2) RETURN VARCHAR2 IS
    BEGIN
        RETURN 'RULES_' || UPPER(REGEXP_REPLACE(p_text, '[^0-9A-Za-z]', '_'));
        EXCEPTION 
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('ERROR IN PROCESS: NP_NAME_ELEMEMT.NAME_TABLE_RULES');
                DBMS_OUTPUT.PUT_LINE(SQLERRM);
                DBMS_OUTPUT.PUT_LINE(SQLCODE);
    END NAME_TABLE_RULES;
END NP_NAME_ELEMEMT;