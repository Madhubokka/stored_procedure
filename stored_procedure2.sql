CREATE OR REPLACE PROCEDURE my_procedure2()
RETURNS STRING
LANGUAGE JAVASCRIPT
AS
$$
return 'Hello, world!-2';
$$;