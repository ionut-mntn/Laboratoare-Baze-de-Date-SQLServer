SELECT DISTINCT
       o.name AS Object_Name,
       o.type_desc
  FROM sys.sql_modules m
       INNER JOIN
       sys.objects o
         ON m.object_id = o.object_id
 --WHERE  '.' + m.definition + '.' LIKE '%[^a-z]employeeid[^a-z]%'
 order by type_desc, object_name