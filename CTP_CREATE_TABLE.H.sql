create or replace NONEDITIONABLE PACKAGE CTP_CREATE_TABLE IS

    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: CTP_CREATE_TABLE.CR_FILES_NAME */
    /* DATE: 13.08.2021 */
    /* ****************************** */
    PROCEDURE CR_FILES_NAME;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: CTP_CREATE_TABLE.IS_TABLE_EXIST */
    /* DATE: 13.08.2021 */
    /* ****************************** */
    FUNCTION IS_TABLE_EXIST(p_table_name IN VARCHAR2) RETURN NUMBER;
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: CTP_CREATE_TABLE.IS_TABLE_EXIST */
    /* DATE: 13.08.2021 */
    /* ****************************** */
    PROCEDURE DROP_SEQUENCE_AND_CREATE_NEW(p_sequence IN VARCHAR2);
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: CTP_CREATE_TABLE.CREATE_TABLE_FROM_FILE */
    /* DATE: 14.08.2021 */
    /* ****************************** */
    PROCEDURE CREATE_TABLE_FROM_FILE(p_name_table IN VARCHAR2,
                                     p_all_column IN VARCHAR2);
                                     
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: CTP_CREATE_TABLE.INSERT_DATA */
    /* DATE: 14.08.2021 */
    /* ****************************** */
    PROCEDURE INSERT_DATA(p_name_table IN VARCHAR2,
                          p_data IN VARCHAR2);
                          
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: CTP_CREATE_TABLE.CREATE_TABLE_EAV */
    /* DATE: 14.08.2021 */
    /* ****************************** */
    PROCEDURE CREATE_TABLE_EAV(p_name_table IN VARCHAR2);
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: CTP_CREATE_TABLE.INSERT_DATA_EAV */
    /* DATE: 14.08.2021 */
    /* ****************************** */
    PROCEDURE INSERT_DATA_EAV(p_name_table IN VARCHAR2,
                              p_data IN VARCHAR2,
                              p_attribute IN VARCHAR2,
                              p_object_nr IN NUMBER);
                              
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: CTP_CREATE_TABLE.CREATE_TABLE_MULTIPLIER_BETA */
    /* DATE: 17.08.2021 */
    /* ****************************** */
    PROCEDURE CREATE_TABLE_MULTIPLIER_BETA(p_name_table IN VARCHAR2);
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: CTP_CREATE_TABLE.INSERT_MULTIPLIER_BETA */
    /* DATE: 17.08.2021 */
    /* ****************************** */
    PROCEDURE INSERT_MULTIPLIER_BETA(p_name_table IN VARCHAR2);
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: CTP_CREATE_TABLE.CREATE_TABLE_R_T */
    /* DATE: 20.08.2021 */
    /* ****************************** */
    PROCEDURE CREATE_TABLE_R_T(p_name_table IN VARCHAR2);
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: CTP_CREATE_TABLE.CREATE_TABLE_R_T_COUNTED */
    /* DATE: 22.08.2021 */
    /* ****************************** */
    PROCEDURE CREATE_TABLE_R_T_COUNTED(p_name_table IN VARCHAR2);
    
    /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: CTP_CREATE_TABLE.DROP_CREATE_TABLE_INDUCTED_RULES */
    /* DATE: 21.09.2021 */
    /* ****************************** */
    PROCEDURE DROP_CREATE_TABLE_INDUCTED_RULES(p_name_table IN VARCHAR2);
    
   /* ****************************** */
    /* AUTHOR: MATEUSZ WRZOL */
    /* PROCEDURE: CTP_CREATE_TABLE.INSERT_DATA_RULE */
    /* DATE: 21.09.2021 */
    /* ****************************** */
    PROCEDURE INSERT_DATA_RULE(p_name_table IN VARCHAR2,
                               p_data IN VARCHAR2);
END CTP_CREATE_TABLE;