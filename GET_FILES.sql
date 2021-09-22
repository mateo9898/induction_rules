create or replace NONEDITIONABLE FUNCTION get_files (p_dir IN VARCHAR2)
  RETURN t_varchar2_arr PIPELINED
AS
  l_array  APEX_APPLICATION_GLOBAL.vc_arr2;
  l_string VARCHAR2(32767);
BEGIN
  l_array:= APEX_STRING.string_to_table(FILE_LIST_API.list(p_dir), ',');

  FOR i in 1..l_array.count LOOP
    PIPE ROW(l_array(i));
  END LOOP;
  RETURN;
END;
