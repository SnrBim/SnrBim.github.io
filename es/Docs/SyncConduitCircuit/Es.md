# SyncConduitCircuit

Esta herramienta está diseñada para distribuir los conductos eléctricos (*Conduit*) en segmentos y registrar sus rutas en los parámetros de los circuitos eléctricos para completar el **registro de cables**.

---

### **Datos requeridos:**
Antes de ejecutar el comando, asegúrese de que **al menos un conducto eléctrico en cada segmento** tenga un nombre de circuito en el parámetro `SRS_MEP_Circuit_Names` y que **exista un circuito eléctrico con el mismo nombre**.

En lugar de rellenar este parámetro manualmente, se recomienda usar la herramienta **AssignConduitToCircuit**.

---

### **Descripción del algoritmo:**
0. **Unificación previa de parámetros:**
   Antes de ejecutar la lógica principal, se realiza una fase de preparación de parámetros. Para todos los elementos **ElectricalEquipment**, los siguientes tres parámetros se concatenan en el parámetro `SRS_Schedule_Name`:
   - `SRS_Location`: parámetro de instancia; si está vacío, se asigna el valor `18D`.
   - `SRS_Equipment_Type`: parámetro de tipo.
   - `SRS_Equipment_Number`: parámetro de instancia.

1. **Búsqueda de conductos eléctricos y circuitos:**
   - El algoritmo encuentra todos los conductos eléctricos y circuitos en los que está definido el parámetro `SRS_MEP_Circuit_Names`.

2. **Identificación de secciones conectadas:**
   - Se detectan **grupos de conductos conectados entre sí** (cadenas) según dos criterios:
     - **Conexión entre conectores**.
     - **Valor del parámetro** `SRS_MEP_Circuit_Names`.

3. **Agrupación de cadenas de conductos por circuito:**
   - El algoritmo asocia las cadenas de conductos con sus respectivos circuitos eléctricos en función del nombre del circuito. **Tenga en cuenta** que al actualizar el nombre del circuito (y los nombres de los componentes del circuito), es necesario actualizar manualmente el parámetro `SRS_MEP_Circuit_Names` de cada segmento (todos sus elementos) donde pasa el cable.

4. **Determinación de la dirección de las rutas:**
   - Para cada circuito eléctrico, los conductos se ordenan **desde la carga (*Load*) hasta el cuadro eléctrico (*Cuadro*)** según su posición en el espacio.

5. **División de la ruta en segmentos:**
   - La ruta se divide en segmentos entre las **cajas de distribución**. Las cajas de distribución no requieren conexión directa entre conectores, se permite un **espacio de hasta 10 cm** entre una caja y un conector del conducto.
   - **Restricción**: si el número de segmentos supera **5**, el proceso se detiene con un error.

6. **Asignación de nombres a los segmentos:**
   - A cada segmento de la ruta se le asigna un nombre único con el siguiente formato:
     ```
     Ubicación-Cuadro/Carga-CC-TagtypeNúmero
     ```
     donde:
     - **Cuadro** y **Carga** son los nombres de los elementos extraídos del parámetro `SRS_Schedule_Name`, **sin la Ubicación (`18D-`) ni guiones**.
     - **Tagtype** es el valor del parámetro `SRS_MEP_Tag_Type_Id`.
     - **Número** se genera automáticamente para garantizar la unicidad del nombre del segmento.

     Si la carga consiste en más de un elemento, el nombre del segmento se genera siguiendo estas reglas:

     | Datos de entrada                            | Nombre resultante del Carga    | Comentario                                                  |
     | ------------------------------------------- | ------------------------------ | ----------------------------------------------------------- |
     | `18D-DS-SF01`                               | `18D-DS-SF01`                  | Un único nombre se mantiene igual.                          |
     | `18D-DS-SF01`, `18D-DS-SF02`, `18D-DS-SF03` | `18D-DS-SFxx`                  | Los nombres con la misma base se agrupan con `xx` al final. |
     | `18D-DS-SF01`, `18D-DS-XY02`                | `18D-DS-SF01, 18D-DS-XY02`     | Los nombres heterogéneos se listan separados por comas.     |
     | `"" (ID: 12345)`, `18D-DS-SF01`             | `12345, 18D-DS-SF01`           | Si no hay nombre, se usa el ID del elemento.                |

7. **Registro de datos en los parámetros:**
   - Se actualiza el parámetro `SRS_MEP_Circuit_Names` en todos los conductos del segmento, asegurando que la lista de circuitos sea coherente en toda la sección.
   - En los conductos, se rellenan los parámetros `SRS_MEP_Conduit_From`, `SRS_MEP_Conduit_To` y `SRS_MEP_Conduit_Tag` con la información de los segmentos. Estos valores se obtienen de los nombres de los elementos inicial y final del segmento a partir del parámetro `SRS_Schedule_Name`.
   - En los circuitos eléctricos, los nombres de los segmentos de los conductos se almacenan en los parámetros `SRS_MEP_Conduit_Segment_1` ... `SRS_MEP_Conduit_Segment_5`.

8. **Notificación:**
   - Después de ejecutar el comando, aparecerá una notificación de confirmación. Esta incluirá también información sobre las **distancias máximas** entre segmentos, lo que permite detectar **conductos asignados incorrectamente**.
   - Si el espacio entre segmentos supera **un metro**, se considerará sospechoso.

![image](https://github.com/user-attachments/assets/9a9058a0-1832-4f33-b80b-af01cc471fc6)
