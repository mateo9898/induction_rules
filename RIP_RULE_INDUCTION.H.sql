create or replace NONEDITIONABLE PACKAGE RIP_RULE_INDUCTION IS

    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: RIP_RULE_INDUCTION.CREATE_MULTIPLIER_BETA */
    /* DATE: 17.08.2021 */
    /* ****************************** */
    PROCEDURE CREATE_MULTIPLIER_BETA;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: RIP_RULE_INDUCTION.CREATE_AND_GENERATE_R_T */
    /* DATE: 19.08.2021 */
    /* ****************************** */
    PROCEDURE CREATE_AND_GENERATE_R_T;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: RIP_RULE_INDUCTION.INDUCTION_RULES */
    /* DATE: 20.08.2021 */
    /* ****************************** */
    PROCEDURE INDUCTION_RULES;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: RIP_RULE_INDUCTION.COUNT_ALL_R_T */
    /* DATE: 22.08.2021 */
    /* ****************************** */
    FUNCTION COUNT_ALL_R_T (p_table_name IN VARCHAR2, p_attribute_row_eav IN VARCHAR2
    ,p_value_row_eav IN VARCHAR2, p_dec_attrib IN VARCHAR2, p_object_nr IN NUMBER, p_dec_value IN VARCHAR2) 
    RETURN NUMBER;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: RIP_RULE_INDUCTION.COUNT_OBJECT_EAV */
    /* DATE: 22.08.2021 */
    /* ****************************** */
    FUNCTION COUNT_OBJECT_EAV (p_table_name IN VARCHAR2) 
    RETURN NUMBER;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: RIP_RULE_INDUCTION.GENERATE_RULE_ROW */
    /* DATE: 23.08.2021 */
    /* ****************************** */
    FUNCTION GENERATE_RULE_ROW (p_table_R_T IN SPP_SYSTEM_PARAMS.t_r_R_from_T_type, p_B_T IN NUMBER) 
    RETURN VARCHAR2;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: RIP_RULE_INDUCTION.COUNT_ATTRIBUTE */
    /* DATE: 23.08.2021 */
    /* ****************************** */
    FUNCTION COUNT_ATTRIBUTE (p_table_name IN VARCHAR2) 
    RETURN NUMBER;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: RIP_RULE_INDUCTION.MINIMAL_R_T_VALUE */
    /* DATE: 23.08.2021 */
    /* ****************************** */
    FUNCTION MINIMAL_R_T_VALUE (p_table_R_T IN SPP_SYSTEM_PARAMS.t_r_R_from_T_type) 
    RETURN SPP_SYSTEM_PARAMS.r_R_T_value_type;
END RIP_RULE_INDUCTION;