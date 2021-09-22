create or replace NONEDITIONABLE PACKAGE SPP_SYSTEM_PARAMS IS

    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: SPP_SYSTEM_PARAMS.R_T_TABLE_NAME */
    /* DATE: 20.08.2021 */
    /* ****************************** */
    FUNCTION R_T_TABLE_NAME RETURN VARCHAR2;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: SPP_SYSTEM_PARAMS.MULTIPLIER_BETA_TABLE_NAME */
    /* DATE: 20.08.2021 */
    /* ****************************** */
    FUNCTION MULTIPLIER_BETA_TABLE_NAME RETURN VARCHAR2;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: SPP_SYSTEM_PARAMS.R_T_COUNTED */
    /* DATE: 22.08.2021 */
    /* ****************************** */
    FUNCTION R_T_COUNTED RETURN VARCHAR2;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: SPP_SYSTEM_PARAMS.r_R_from_T_type */
    /* DATE: 23.08.2021 */
    /* ****************************** */
    TYPE r_R_from_T_type IS RECORD (
        v_r_from_t VARCHAR2(1000),
        v_value VARCHAR2(1000),
        v_result NUMBER,
        v_decision VARCHAR2(50));
    TYPE t_r_R_from_T_type IS TABLE OF r_R_from_T_type
        INDEX BY BINARY_INTEGER;
        
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: SPP_SYSTEM_PARAMS.r_R_from_T_type */
    /* DATE: 23.08.2021 */
    /* ****************************** */
    TYPE r_R_T_value_type IS RECORD (
        v_r_from_t VARCHAR2(1000),
        v_value VARCHAR2(1000));
END SPP_SYSTEM_PARAMS;