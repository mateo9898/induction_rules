create or replace NONEDITIONABLE PACKAGE NP_NAME_ELEMEMT IS

    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: NP_NAME_ELEMEMT.NAME_TABLE */
    /* DATE: 14.08.2021 */
    /* ****************************** */
    FUNCTION NAME_TABLE(p_text IN VARCHAR2) RETURN VARCHAR2;

    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: NP_NAME_ELEMEMT.NAME_SEQUENCE */
    /* DATE: 14.08.2021 */
    /* ****************************** */
    FUNCTION NAME_SEQUENCE(p_text IN VARCHAR2) RETURN VARCHAR2;

    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: NP_NAME_ELEMEMT.NAME_ATTRIBUTE */
    /* DATE: 14.08.2021 */
    /* ****************************** */
    FUNCTION NAME_ATTRIBUTE(p_text IN VARCHAR2) RETURN VARCHAR2;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: NP_NAME_ELEMEMT.NAME_TABLE_EAV */
    /* DATE: 14.08.2021 */
    /* ****************************** */
    FUNCTION NAME_TABLE_EAV(p_text IN VARCHAR2) RETURN VARCHAR2;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: NP_NAME_ELEMEMT.NAME_TABLE_RULES */
    /* DATE: 21.09.2021 */
    /* ****************************** */
    FUNCTION NAME_TABLE_RULES(p_text IN VARCHAR2) RETURN VARCHAR2;
END NP_NAME_ELEMEMT;