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

1.  **Unificación de parámetros:** Prepara los nombres de los equipos en el parámetro `SRS_Schedule_Name` concatenando `SRS_Equipment_Type` y `SRS_Equipment_Number`. Se admite la sobrescritura de estos parámetros a nivel de instancia (tienen prioridad sobre el tipo), y los guiones redundantes en el nombre resultante se eliminan automáticamente. El parámetro `SRS_Location` se utiliza tal cual de los elementos.
2.  **Búsqueda:** Encuentra todos los conductos y circuitos con el parámetro `SRS_MEP_Circuit_Names` definido.
3.  **Identificación de secciones:** Detecta grupos de conductos conectados entre sí (cadenas) por conexión física. La herramienta reconoce automáticamente ramales paralelos dentro de un segmento mediante el parámetro `SRS_MEP_Parallel_Id`.
4.  **Agrupación por circuito:** Asocia las cadenas de conductos con sus respectivos circuitos eléctricos. Valida la unicidad de los nombres de circuitos en todo el proyecto para evitar duplicados en los esquemas de montaje.
5.  **Determinación de la dirección:** Ordena los componentes de la ruta desde la carga hacia el cuadro, gestionando los ramales paralelos de forma coherente.
6.  **División en segmentos:** La ruta se divide en segmentos lógicos entre cajas de distribución.
7.  **Asignación de nombres a segmentos:** A cada segmento se le asigna un nombre basado en las ubicaciones del cuadro y la carga. Para cadenas paralelas dentro de un mismo segmento, se generan sufijos únicos para cada ramal (p. ej., `-PS01`, `-PS02`). Las reglas para formar el nombre de la carga son las siguientes:

| Datos de entrada | Nombre resultante del Carga | Comentario |
| :--- | :--- | :--- |
| `18D-DS-SF01` | `18D-DS-SF01` | Un único nombre se mantiene igual. |
| `18D-DS-SF01`, `18D-DS-SF02`, `18D-DS-SF03` | `18D-DS-SFxx` | Los nombres con la misma base se agrupan con `xx` al final. |
| `18D-DS-SF01`, `18D-DS-XY02` | `18D-DS-SF01, 18D-DS-XY02` | Los nombres heterogéneos se listan separados por comas. |
| `"" (ID: 12345)`, `18D-DS-SF01` | `12345, 18D-DS-SF01` | Si no hay nombre, se usa el ID del elemento. |

8.  **Registro de datos:**
    -   Actualiza `SRS_MEP_Circuit_Names` en todos los conductos del segmento.
    -   Rellena `SRS_MEP_Conduit_From`, `SRS_MEP_Conduit_To` y `SRS_MEP_Conduit_Tag` en los conductos. Añade las ubicaciones del cuadro y de la carga a `From` y `To`, respectivamente.
    -   Agrupa las longitudes de conductos y accesorios dentro de cada segmento según los códigos `RGS`, `PVC` y `FIBERGLASS` del nombre del tipo. Cada grupo se redondea por separado al metro entero superior, conservando la regla de elegir la longitud máxima para ramales paralelos, y se escribe en `SRS_MEP_Length` para los elementos del grupo. Los tipos sin código reconocido forman un grupo independiente con su propia suma.
    -   La longitud del cable se registra en el parámetro `SRS_MEP_Cable_Length`, que se calcula según el siguiente algoritmo:
        1.  **Tubos y accesorios**: se toma la suma de las longitudes de todos los elementos. Para los codos, se utiliza la distancia entre conectores multiplicada por un coeficiente (**1.15** para ángulos >45° y **1.05** para ángulos ≤45°) para mantener la independencia de los parámetros de las familias.
        2.  **Huecos de equipos**: se añaden las distancias rectilíneas desde el punto objetivo virtual del cuadro hasta el primer conducto y desde el último conducto hasta el punto objetivo virtual de la carga más cercana. El punto objetivo no coincide con el punto de inserción del equipo; se sitúa en el borde vertical opuesto del equipo con respecto al extremo del conducto.
            - Los límites verticales del equipo se determinan con respecto al punto de inserción mediante los parámetros `Default Elevation` (`DE`) y `SRS_Height` (`H`).
            - Si `DE > 0`, el límite inferior es `DE - H` y el superior es `DE`.
            - Si `DE <= 0`, el límite inferior es `0` y el superior es `H`.
            - `Default Elevation` se lee del tipo de equipo. `SRS_Height` se lee primero de la instancia y, si el parámetro no existe, del tipo.
            - Si el extremo del conducto está por encima del límite superior del equipo, se utiliza el límite inferior como objetivo. Si está por debajo del límite inferior, se utiliza el límite superior.
            - Si el extremo del conducto se encuentra entre ambos límites, se selecciona el borde con mayor distancia vertical al extremo del conducto.
        3.  **Cajas de derivación**: se tienen en cuenta los huecos en los puntos de rotura de la ruta por las cajas.
        4.  **Circuitos con múltiples dispositivos**: si hay varias cargas (por ejemplo, luminarias), se calcula la ruta más corta que pase por todos los puntos ("serpiente") desde la última caja.
        5.  **Reserva**: se añade una reserva de seguridad fija de **+2 metros**.
        6.  **Redondeo**: el valor final se redondea al metro entero superior.
        - Para ramales paralelos, se registra en el circuito la longitud del **ramal más largo**.
    -   Almacena los nombres de los segmentos en los parámetros `SRS_MEP_Conduit_Segment_1` a `SRS_MEP_Conduit_Segment_5` del circuito eléctrico.
9.  **Notificación:** Confirma la operación e informa sobre distancias sospechosas (>1m) entre segmentos para detectar posibles errores de asignación.
10. **Comprobación de colisiones:** Valida los identificadores únicos (BaseCode) asignados a diferentes circuitos eléctricos. Si se encuentran solapamientos, se proporciona un informe resumen al finalizar.

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
- El parámetro `SRS_Schedule_Name` en los equipos se actualiza automáticamente durante cada sincronización (concatenando tipo y número), por lo que no es necesario rellenarlo manualmente.

![image](https://github.com/user-attachments/assets/9a9058a0-1832-4f33-b80b-af01cc471fc6)

## Opciones de Procesamiento (Processing Options)

- **Only selected conduits**: Al activarse, el algoritmo procesa solo los conductos que haya seleccionado en Revit antes de iniciar. Útil para sincronizaciones puntuales de circuitos específicos.
- **Show result in specialized 3D view**: Crea o actualiza una vista 3D especial `Conduit Review <usuario>` para una comprobación rápida del resultado.
    - **Caja de sección (Section Box)**: La herramienta ajusta automáticamente la caja de sección a los límites del área seleccionada.
    - **Aislamiento opcional**: Use "Isolate elements in 3D view" para ocultar todo excepto la ruta, el panel y las cargas. Si está desactivado, los elementos se muestran dentro del contexto del edificio.
    - **Vista limpia**: Se ocultan elementos auxiliares (líneas centrales, archivos vinculados).
    - **Vista completa del sistema**: La vista incluye automáticamente el panel eléctrico y todas las cargas del circuito.

## Interfaz (Interface)

- **Show this dialog (Shift/Ctrl to invert)**: Permite desactivar esta ventana para un inicio instantáneo con la última configuración guardada.
- **Inversión (XOR)**: Si desea abrir la ventana puntualmente cuando la opción está desactivada (o viceversa), mantenga presionada la tecla **Shift** o **Ctrl** al hacer clic en el botón en Revit.

![UI](image.png)

## Historial de Cambios

2026-08-12
1. **Ubicaciones en los parámetros de los conductos**: Se añadieron las ubicaciones del cuadro y de la carga a `SRS_MEP_Conduit_From` y `SRS_MEP_Conduit_To`, respectivamente, para mostrar la identificación completa del equipo en las tablas.
2. **Separación de longitudes por material**: Las longitudes de conductos y accesorios dentro de cada segmento se separan por los códigos `RGS`, `PVC` y `FIBERGLASS`, se redondean por separado al metro entero superior y se escriben en `SRS_MEP_Length`. Los tipos sin código se tratan como un grupo independiente.

2026-08-06
1. **Corrección del cálculo de la longitud del cable**: Se ha corregido un error por el que los extremos de las cadenas de conductos se determinaban en orden inverso en algunos casos. Esto provocaba un cálculo incorrecto de las distancias de los tramos terminales.

2026-08-03
1. **Corrección de la configuración**: La opción para ejecutar Sync después de Assign ya no afecta a la ejecución independiente de Sync. Las opciones de la vista 3D y del procesamiento de conductos seleccionados funcionan de forma independiente.
2. **Cálculo de las distancias terminales hasta los límites del equipo**: Se añadió el cálculo hasta un borde virtual del equipo en lugar del punto de inserción.
3. **Reserva fija de cable**: Según las nuevas normas, la reserva automática de cable ahora es fija, de **+2 metros** por ruta, en lugar de basarse en un porcentaje.

2026-07-30
1. **Aislamiento configurable**: Se añadió la opción de alternar entre vista aislada o en contexto.
2. **Visualización mejorada**: El panel y las cargas se incluyen ahora automáticamente en la vista de revisión.

2026-07-29
1. **Registro de longitud de segmento en conductos**: Se implementó el registro de la longitud del segmento en el parámetro `SRS_MEP_Length` de cada elemento de la ruta. El valor se redondea al metro entero superior.
2. **Actualización de la lógica de reserva**: El cálculo de la longitud de reserva del cable cambió de porcentual (5-10%) a un valor fijo (+2 metros a la longitud total de la ruta).

2026-07-23
1. **Soporte para circuitos paralelos**: Implementada la capacidad de vincular un solo circuito eléctrico a múltiples cadenas de conductos físicamente paralelas (usando el parámetro `SRS_MEP_Parallel_Id`).
2. **Numeración de ramales paralelos**: Añadida numeración única para cada ramal en un grupo paralelo (p. ej., `-PS01`, `-PS02`), garantizando la unicidad de las etiquetas y la precisión de los esquemas de montaje.
3. **Control de unicidad global**: Introducido un sistema para verificar la unicidad de `BaseCode` en todo el modelo. Si se asigna accidentalmente la misma etiqueta a diferentes circuitos, la herramienta mostrará una advertencia.
4. **Cálculo de longitud para sistemas paralelos**: El algoritmo ahora determina correctamente la longitud del cable basándose en el ramal paralelo más largo en lugar de sumarlos.

2026-07-17
1. **Soporte para codos sucesivos y cadenas de accesorios**: Se ha rediseñado el algoritmo de recorrido de conexiones. La herramienta ahora procesa correctamente los accesorios conectados directamente entre sí (sin tramos rectos de tubo intermedios).
2. **Corrección de errores (Crash)**: Se ha solucionado el error `Sequence contains no elements` al analizar rutas incompletas o vacías. Se añadieron comprobaciones de seguridad.

2026-07-15
1. **Prioridad de parámetros de instancia**: `SRS_Equipment_Type` y `SRS_MEP_Tag_Type_Id` se buscan primero en los parámetros del elemento, y solo en el tipo si están vacíos. Esto permite sobrescrituras a nivel de instancia.
2. **Limpieza de nombres**: Se mejoró la generación de `SRS_Schedule_Name`, eliminando guiones sobrantes cuando faltan datos parciales.

2026-07-13
1. **Vista 3D de Diagnóstico**: Creación automática de vista para revisión con aislamiento de ruta, ocultación de ejes y recorte automático.
2. **Modo de selección (Selection Mode)**: Soporte para procesar solo conductos seleccionados manualmente.
3. **Inicio Silencioso**: Implementación de inicio instantáneo con soporte para Shift/Ctrl para invocar los ajustes.

2026-07-09
1. Refinado el nombre de los segmentos: si las ubicaciones del cuadro y la carga difieren, se especifican ambas (Loc1-De/Loc2-A-Tag); si coinciden, se usa un solo prefijo (Loc-De/A-Tag).
2. Se eliminó la abreviatura "CC" de las etiquetas de conducto (`SRS_MEP_Conduit_Tag`).
3. Se implementó el redondeo hacia arriba de la longitud del cable calculada (`SRS_MEP_Cable_Length`) al metro más cercano (`Math.Ceiling`), manteniendo la precisión decimal en los informes de usuario para el control de huecos.
4. Se implementó la selección automática del prefijo de ubicación (p. ej., 16D, 18D) basada en el parámetro `Functional_Breakdown_Code`.

2026-06-19 Se corrigió un error cuando faltaba `SRS_Schedule_Name` en el equipo o `SRS_Location` estaba vacío (ahora se usa '18D' por defecto). Los nombres de parámetros se movieron a `%AppData%\Sener\BimTools\Settings.json`.

