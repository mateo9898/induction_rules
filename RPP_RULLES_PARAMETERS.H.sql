create or replace NONEDITIONABLE PACKAGE RPP_RULLES_PARAMETERS IS
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: RPP_RULLES_PARAMETERS.GENERATE_RULES_PARAMETERS */
    /* DATE: 22.09.2021 */
    /* ****************************** */
    PROCEDURE GENERATE_RULES_PARAMETERS;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: RPP_RULLES_PARAMETERS.RULE_LENGTH */
    /* DATE: 22.09.2021 */
    /* ****************************** */
    FUNCTION RULE_LENGTH (p_rule IN VARCHAR2) RETURN NUMBER;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: RPP_RULLES_PARAMETERS.SUPPORT */
    /* DATE: 22.09.2021 */
    /* ****************************** */
    FUNCTION SUPPORT(p_rule IN VARCHAR2, p_beta IN NUMBER, p_table IN VARCHAR2)  RETURN NUMBER;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: RPP_RULLES_PARAMETERS.MISTAKE */
    /* DATE: 22.09.2021 */
    /* ****************************** */
    FUNCTION MISTAKE(p_rule IN VARCHAR2, p_beta IN NUMBER, p_table IN VARCHAR2) RETURN NUMBER;
END RPP_RULLES_PARAMETERS;