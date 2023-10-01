
/* ** ROCIO GONZÁLEZ PALMETA**

En esta función, se crea la tabla ivr_detail, 
  en ella se ingresa los detalles de las llamadas:
    - Los datos de las llamadas
    - Modulos por los que pasa CADA LLAMADA
    - PASOS DE CADA LLAMADA por los que pasa CADA USUARIO 
*/


## Se crea la tabla ivr_detail
CREATE TABLE `keepcoding-mysql-dw.keepcoding.ivr_detail` AS
 ## Se selecciona las tablas que se van a ingresar en esta nueva
SELECT
  c.*,
  FORMAT_DATE('%Y%m%d', start_date) AS calls_star_date_id,   ## Obtiene la fecha en ivr_calls y se pone en formato yyyymmdd
  FORMAT_DATE('%Y%m%d', end_date) AS calls_end_date_id,
  m.* except(ivr_id), ## No se coge esa columna, ya que se duplica y sale error
  s.* except(ivr_id, module_sequece)
FROM
  `keepcoding-mysql-dw.keepcoding.ivr_calls` AS c
INNER JOIN            ##la primera unión de datos, de ivr_calls e ivr_modules por la id de la llamada
  `keepcoding-mysql-dw.keepcoding.ivr_modules` AS m
ON
  c.ivr_id = m.ivr_id   
INNER JOIN            ## Se agrega otro inner join para relacionar los datos con la tabla de ivr_steps, mediante el campo ivr_id y module_sequence
  `keepcoding-mysql-dw.keepcoding.ivr_steps` AS s
ON
  m.ivr_id = s.ivr_id
  AND m.module_sequece = s.module_sequece ; 
