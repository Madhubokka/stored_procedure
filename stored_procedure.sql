CREATE OR REPLACE PROCEDURE my_procedure()
RETURNS STRING
LANGUAGE JAVASCRIPT
AS
$$
return 'Hello, world!';
$$;