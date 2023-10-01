# MODULO 5 - ADVANCED SQL
***
*Rocío González Palmeta* :purple_heart: 

En esta practica trabajaremos para realizar un IVR (*Interactive Voice Response*) de atención al cliente. Para ello, partimos de las siguientes tablas:
1. ***ivr_calls***, datos referentes a las llamadas.
2. ***ivr_modules***, datos de los diferentes modulos por los que pasa cada llamada.
3. ***ivr_steps***, datos correspondientes a los pasos que da el usuario dentro de cada modulo. 

En esta practica se busca la realización de 2 tablas y una función de limpieza. 

* La primera tabla se llamará **ivr_detail**, donde se relaciona todos los datos de las 3 tablas fuentes, realizando así una tabla con **el detalle de cada llamada en cada paso que realiza**.
* La segunda tabla se llamará **ivr_summary**, donde solo aparecerá un resumen de toda la información que genera cada llamada. 
* Por último, se realiza una función que se llamará **clean_integrer** la cual, repasa todas las filas de una columna y si tiene un valor 'NULL' es reemplazado por el valor '-999999'.

También en las tablas se realiza algunos calculos, todo esta explicado en comentarios a medida que se ha realizado el código.

Como comentario personal, esta practica me ha costado entenderla en varias de estas columnas calculadas y he estado literalmente así:

![Alt text](minion.gif)

Pero con trabajo duro y cafeína se puede conseguir estas cosas, por lo que seguir progresando!! :muscle: 

Muchas gracias por leer todo esto!