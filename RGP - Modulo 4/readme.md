#MODULO 4 - Modelado y SQL
***

La práctica de este modulo consiste en la creación de un modelo Entidad-Relación normalizado para una flota de vehiculos y un fichero con los comandos DDL para la creación del modelo diseñado así como los comandos DML para cargar las tablas.



Los datos que tenemos de los vehiculos son los siguientes:
* Matricula 
* Grupo al que pertenece la marca
* Marca del coche
* Modelo 
* Fecha_compra 
* Color 
* Aseguradora 
* Número de poliza
* Fecha_alta_seguro 
* Importe_revision, con revision nos referimos a la inspección tecnica, ITV de España por ejemplo
* Moneda del pago de la revisión
* Kms_revision
* Fecha_revision 
* Kms_totales, que tiene actualmente el coche

[~En esta dirección se puede ver el diagrama que se ha seguido para relacionar los datos.~](https://viewer.diagrams.net/?tags=%7B%7D&highlight=0000ff&edit=_blank&layers=1&nav=1#G1a5_gSdSXBAlj_-aiysiI8V8fSUnuL3d3)

Aparte del script, se realiza una consulta SQL para sacar el siguiente listado de coches activos:

- Nombre modelo, marca y grupo de coches (los nombres de todos)
- Fecha de compra
- Matricula
- Nombre del color del coche
- Total de kilómetros
- Nombre empresa que está asegurado el coche
- Numero de póliza
