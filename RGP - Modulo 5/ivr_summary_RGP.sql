
/* ** ROCIO GONZÁLEZ PALMETA** 

En esta función,
  se crea la tabla ivr_summary. Es una tabla resumen de cada llamada en las que se incluye los indicadores mas importantes. 
  SOLO HAY UN REGISTRO POR CADA LLAMADA. 
*/ 
  
## Se crea la tabla ivr_summary
CREATE TABLE
  `keepcoding-mysql-dw.keepcoding.ivr_summary` AS ## Se selecciona las tablas que se van a ingresar en esta nueva
SELECT
  vd.ivr_id AS ivr_id,
  MAX(CASE  --> SOLO TIENEN DOS VALORES POSIBLES, EL VALOR DEL NUMERO DE TELEFONO O UN NULL, POR ELLO,LO COMPARO PARA ELEGIR EL NUMERO EN CASO DE HABERLO
      WHEN vd.phone_number <> 'NULL' THEN vd.phone_number 
  END ) AS phone_number, --> Y LE PONGO EL NOMBRE QUE VA A LLEVAR ESA COLUMNA

  MAX(CASE WHEN vd.ivr_result <> 'NULL' THEN vd.ivr_result  END ) AS ivr_result,

  MAX(CASE --> EN ESTE CASO, COMPARO LOS VALORES QUE HAY EN LOS 3 PRIMEROS DIGITOS DE vdn_label Y LE CAMBIO EL VALOR
      WHEN LEFT(vd.vdn_label, 3) = 'ATC' THEN 'FRONT'
      WHEN LEFT(vd.vdn_label, 3) = 'TECH' THEN 'TECH'
      WHEN LEFT(vd.vdn_label, 3) = 'ABSORPTION' THEN 'ABSORPTION'
    ELSE 'RESTO'  END ) AS vdn_aggregation,

  MAX(vd.start_date) AS start_date,
  MAX(vd.end_date) AS end_date,
  MAX(vd.total_duration) AS total_duration,
  MAX(CASE WHEN vd.customer_segment <> 'NULL' THEN vd.customer_segment END ) AS customer_segment,
  MAX(CASE WHEN vd.ivr_language <> 'NULL' THEN vd.ivr_language END ) AS ivr_language,
  MAX(vd.steps_module) AS steps_module,
  MAX(CASE WHEN vd.module_aggregation <> 'NULL' THEN vd.module_aggregation END) AS module_aggregation,
  MAX(CASE WHEN vd.document_type <> 'NULL' THEN vd.document_type END ) AS document_type,
  MAX(CASE WHEN vd.document_identification <> 'NULL' THEN vd.document_identification END ) AS document_identification,
  MAX(CASE WHEN vd.customer_phone <> 'NULL' THEN vd.customer_phone END ) AS customer_phone,
  MAX(CASE WHEN vd.billing_account_id <> 'NULL' THEN vd.billing_account_id END ) AS billing_account_id,

  MAX(CASE --> QUEREMOS PONER UN FLAG PARA INDICAR SI SE HA TENIDO O NO UNA AVERIA MASIVA
      WHEN CONTAINS_SUBSTR(vd.module_aggregation, 'AVERIA_MASIVA') THEN '1'
    ELSE '0' END ) AS masiva_lg,

  MAX(CASE --> AQUI INDICAMOS UN FLAG PARA COMPROBAR SI SE HA IDENTIFICADO O NO AL CLIENTE A TRAVES DEL TELEFONO
      WHEN (vd.step_name = 'CUSTOMERINFOBYPHONE.TX') AND (vd.step_description_error = 'NULL') THEN '1'
    ELSE '0' END ) AS info_by_phone_lg,

  MAX(CASE --> AQUI INDICAMOS UN FLAG PARA COMPROBAR SI SE HA IDENTIFICADO O NO AL CLIENTE A TRAVES DEL DNI
      WHEN (vd.step_name = 'CUSTOMERINFOBYDNI.TX') AND (vd.step_description_error = 'NULL') THEN '1'
    ELSE '0' END ) AS info_by_dni_lg ,

  MAX(CASE  --> AQUI INDICAMOS UN FLAG PARA VER SI EL MISMO NUMERO HA LLAMADO 24 HORAS ANTES 
    WHEN EXISTS (
      SELECT 1
      FROM `keepcoding-mysql-dw.keepcoding.ivr_detail` AS sub
      WHERE sub.phone_number = vd.phone_number  --> Comparo las filas que contienen el mismo numero y diferente id
        AND sub.ivr_id != vd.ivr_id
        AND sub.end_date < vd.start_date --> La llamada que se compara, deberia de terminar antes de que comience la llamada que estamos verificando
        AND sub.end_date >= TIMESTAMP_SUB(vd.start_date, INTERVAL 24 HOUR) --> Y ademas, deberia de ser en las 24 h anteriores a que comience nuestra llamada
    ) THEN 1
    ELSE 0
  END) AS repeated_phone_24h,

  MAX(CASE --> AQUI INDICAMOS UN FLAG PARA VER SI EL MISMO NUMERO HA LLAMADO 24 HORAS DESPUES 
    WHEN EXISTS (
      SELECT 1
      FROM `keepcoding-mysql-dw.keepcoding.ivr_detail` AS sub
      WHERE sub.phone_number = vd.phone_number --> Comparo las filas que contienen el mismo numero y diferente id
        AND sub.ivr_id != vd.ivr_id
        AND sub.start_date > vd.end_date --> La llamada que se compara, deberia de empezar despues de que termine la llamada que estamos verificando
        AND sub.start_date <= TIMESTAMP_ADD(vd.end_date, INTERVAL 24 HOUR)--> Y ademas, deberia de ser en las 24 h posteriores a que termine nuestra llamada
    ) THEN 1
    ELSE 0
  END) AS cause_recall_phone_24h

FROM --> LA FUENTE DESDE DONDE SE RECOLECTA LOS DATOS
  `keepcoding-mysql-dw.keepcoding.ivr_detail` AS vd
GROUP BY
  ivr_id --> AGRUPAMOS PARA ASÍ SOLO TENER UN REGISTRO POR CADA ID DE LLAMADA
ORDER BY
  phone_number DESC, start_date ASC; -->ORDENAMOS POR EL MOMENTO EN EL QUE SE RECIBE LA LLAMADA 
  