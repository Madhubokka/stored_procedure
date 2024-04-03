CREATE OR REPLACE PROCEDURE my_procedure1()
RETURNS STRING
LANGUAGE JAVASCRIPT
AS
$$
return 'Hello, world!-1';
$$;