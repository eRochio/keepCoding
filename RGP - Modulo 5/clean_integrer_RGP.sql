
/* ** ROCIO GONZÁLEZ PALMETA**

En esta función, se ingresa el nombre de una columna y reemplaza todos los valores 'NULL' 
  (de tipo string o un valor nulo simplemente).

Luego he usado esa misma función para crear una versión 'limpia' d enuestra tabla 'ivr_summary', 
  poniendole todos los nombres de sus columna. Creo una nueva pq con un update y set me sale 
  la opcion de pago.

*/

CREATE FUNCTION keepcoding.clean_integrer (name_colum STRING) RETURNS STRING AS ( 
    CASE WHEN name_colum = 'NULL' or name_colum IS NULL THEN '-999999'
    ELSE name_colum
    END
);

-- actualiazación de la tabla

CREATE TABLE `keepcoding-mysql-dw.keepcoding.ivr_summary_CLEAN` AS
SELECT
  keepcoding.clean_integrer(phone_number) AS phone_number,
  keepcoding.clean_integrer(ivr_result) AS ivr_result,
  keepcoding.clean_integrer(vdn_aggregation) AS vdn_aggregation,
  keepcoding.clean_integrer(customer_segment) AS customer_segment,
  keepcoding.clean_integrer(ivr_language) AS ivr_language,
  keepcoding.clean_integrer(module_aggregation) AS module_aggregation,
  keepcoding.clean_integrer(document_type) AS document_type,
  keepcoding.clean_integrer(document_identification) AS document_identification,
  keepcoding.clean_integrer(customer_phone) AS customer_phone,
  keepcoding.clean_integrer(billing_account_id) AS billing_account_id,
  keepcoding.clean_integrer(masiva_lg) AS masiva_lg,
  keepcoding.clean_integrer(info_by_phone_lg) AS info_by_phone_lg,
  keepcoding.clean_integrer(info_by_dni_lg) AS info_by_dni_lg
FROM `keepcoding-mysql-dw.keepcoding.ivr_summary` AS s;
