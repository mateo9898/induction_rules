create or replace NONEDITIONABLE PACKAGE DOTP_DELETE_OLD_TABLE IS

    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: DOTP_CREATE_OLD_TABLE.DELETE_OLD_TABLE */
    /* DATE: 14.08.2021 */
    /* ****************************** */
    PROCEDURE DELETE_OLD_TABLE;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: DOTP_CREATE_OLD_TABLE.DELETE_OLD_SEQUENCE */
    /* DATE: 14.08.2021 */
    /* ****************************** */
    PROCEDURE DELETE_OLD_SEQUENCE(p_name_sequence IN VARCHAR2);
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: DOTP_CREATE_OLD_TABLE.DELETE_TABLE */
    /* DATE: 17.08.2021 */
    /* ****************************** */
    PROCEDURE DELETE_TABLE(p_name_table IN VARCHAR2);
END DOTP_DELETE_OLD_TABLE;