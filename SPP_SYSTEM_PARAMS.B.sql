create or replace NONEDITIONABLE PACKAGE BODY SPP_SYSTEM_PARAMS IS

    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: SPP_SYSTEM_PARAMS.R_T_TABLE_NAME */
    /* DATE: 20.08.2021 */
    /* ****************************** */
    FUNCTION R_T_TABLE_NAME RETURN VARCHAR2 IS
    BEGIN
        RETURN 'M_R_T_BY_TABLE_NAME';
    END R_T_TABLE_NAME;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: SPP_SYSTEM_PARAMS.R_T_TABLE_NAME */
    /* DATE: 20.08.2021 */
    /* ****************************** */
    FUNCTION MULTIPLIER_BETA_TABLE_NAME RETURN VARCHAR2 IS
    BEGIN
        RETURN 'MULTIPLIER_BETA';
    END MULTIPLIER_BETA_TABLE_NAME;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: SPP_SYSTEM_PARAMS.R_T_COUNTED */
    /* DATE: 22.08.2021 */
    /* ****************************** */
    FUNCTION R_T_COUNTED RETURN VARCHAR2 IS
    BEGIN
        RETURN 'R_T_COUNTED';
    END R_T_COUNTED;
END SPP_SYSTEM_PARAMS;