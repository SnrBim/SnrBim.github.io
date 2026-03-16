# Sincronizar Circuito de Conducto
{: .no_toc }

<details open markdown="block">
  <summary>
    Tabla de contenidos
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

Esta herramienta está diseñada para distribuir los conductos eléctricos (Conduit) en segmentos y registrar sus rutas en los parámetros de los circuitos eléctricos para completar el journal de cables.

## Datos Requeridos

Antes de ejecutar el comando, asegúrese de que al menos un conducto en cada segmento tenga un nombre de circuito en `SRS_MEP_Circuit_Names` y que exista un circuito con el mismo nombre. Se recomienda usar el comando compañero **AssignConduitToCircuit** para esto.

## Descripción del Algoritmo

1.  **Unificación de parámetros:** Prepara los nombres de los equipos en el parámetro `SRS_Schedule_Name` concatenando `SRS_Equipment_Type` y `SRS_Equipment_Number`. El parámetro `SRS_Location` se utiliza tal cual de los elementos.
2.  **Búsqueda:** Encuentra todos los conductos y circuitos con el parámetro `SRS_MEP_Circuit_Names` definido.
3.  **Identificación de secciones:** Detecta grupos de conductos conectados entre sí (cadenas) por conexión física y por el valor compartido en `SRS_MEP_Circuit_Names`.
4.  **Agrupación por circuito:** Asocia las cadenas de conductos con sus respectivos circuitos eléctricos.
6.  **División en segmentos:** La ruta se divide en segmentos entre cajas de distribución (se permite un espacio de hasta 10 cm). El proceso se detiene con un error si hay más de 5 segmentos.
7.  **Asignación de nombres a segmentos:** A cada segmento se le asigna un nombre único con el formato `Ubicación-Cuadro/Carga-CC-TagtypeNúmero`. Las reglas para formar el nombre de la carga son las siguientes:
    | Datos de entrada                            | Nombre resultante del Carga    | Comentario                                                  |
    | ------------------------------------------- | ------------------------------ | ----------------------------------------------------------- |
    | `18D-DS-SF01`                               | `18D-DS-SF01`                  | Un único nombre se mantiene igual.                          |
    | `18D-DS-SF01`, `18D-DS-SF02`, `18D-DS-SF03` | `18D-DS-SFxx`                  | Los nombres con la misma base se agrupan con `xx` al final. |
    | `18D-DS-SF01`, `18D-DS-XY02`                | `18D-DS-SF01, 18D-DS-XY02`     | Los nombres heterogéneos se listan separados por comas.     |
    | `"" (ID: 12345)`, `18D-DS-SF01`             | `12345, 18D-DS-SF01`           | Si no hay nombre, se usa el ID del elemento.                |
8.  **Registro de datos:**
    -   Actualiza `SRS_MEP_Circuit_Names` en todos los conductos del segmento.
    -   Rellena `SRS_MEP_Conduit_From`, `SRS_MEP_Conduit_To`, y `SRS_MEP_Conduit_Tag` en los conductos.
    -   Almacena los nombres de los segmentos en los parámetros `SRS_MEP_Conduit_Segment_1` a `SRS_MEP_Conduit_Segment_5` del circuito eléctrico.
9.  **Notificación:** Confirma la operación e informa sobre distancias sospechosas (>1m) entre segmentos para detectar posibles errores de asignación.

## Posibles Errores

- **No se encontraron conductos:** Si no hay conductos con el parámetro `SRS_MEP_Circuit_Names` definido, el comando fallará. Verifique que al menos un conducto por segmento tenga este parámetro asignado (use **AssignConduitToCircuit**).
- **No se encontraron circuitos eléctricos:** Si no existen circuitos con nombres coincidentes en `SRS_MEP_Circuit_Names`, el comando fallará. Asegúrese de que los circuitos existan y tengan nombres correctos.
- **Demasiados segmentos:** Si una ruta tiene más de 5 segmentos, el proceso se detiene con un error. Simplifique la ruta o divida el circuito.
- **Parámetros faltantes:** Si algún parámetro requerido (como `SRS_Schedule_Name` en equipos) no existe o está vacío, puede causar errores. Los cambios se realizan en una transacción y pueden deshacerse con Ctrl+Z.

## Notificaciones y Estadísticas

Después de la ejecución, aparece una notificación con:
- Número de circuitos procesados.
- Longitud mínima y máxima del cable (en metros).
- Máxima separación entre segmentos (en metros) y ID del circuito.

Si la separación supera 1 m, revise las asignaciones de conductos, ya que puede indicar conexiones incorrectas.

## Consejos de Uso

- Ejecute el comando en una vista de plano para mejores resultados.
- Si los nombres de circuitos cambian, actualice manualmente `SRS_MEP_Circuit_Names` en los conductos.
- La herramienta procesa solo conductos y circuitos con el parámetro definido; ignore otros elementos.
- Para evitar errores, asegúrese de que `SRS_Schedule_Name` esté configurado en equipos eléctricos (se genera automáticamente concatenando `SRS_Location`, `SRS_Equipment_Type` y `SRS_Equipment_Number`).

![image](https://github.com/user-attachments/assets/9a9058a0-1832-4f33-b80b-af01cc471fc6)
