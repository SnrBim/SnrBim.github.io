# Guía de usuario para el comando "Sincronizar esquema de alarma de incendios"
{: .no_toc }

<details open markdown="block">
  <summary>
    Tabla de contenidos
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

## 1. Propósito del comando

El comando está diseñado para la creación automática y posterior sincronización de un esquema 2D de la disposición de los dispositivos de alarma de incendios a partir de un modelo 3D. Genera elementos 2D en una vista de diseño que corresponden a las habitaciones y dispositivos, y rastrea los cambios en el modelo para actualizar el esquema.

![image](.\pic1.png)

## 2. Preparación

1.  **Modelo arquitectónico:** Se debe cargar en el proyecto un modelo vinculado (Revit Link) con las habitaciones (`Rooms`) arquitectónicas.
2.  **Vista activa:** Antes de ejecutar el comando, es necesario abrir una **vista de diseño** (`Drafting View`) en la que se colocará el esquema.

## 3. Paso 1: Selección de datos de origen

Al ejecutar el comando, se abre un cuadro de diálogo en el que se deben especificar los datos de origen para la sincronización.

*   **Vínculo arquitectónico:**
    *   La lista desplegable muestra todos los archivos de Revit vinculados en los que se han encontrado habitaciones.
    *   La lista se ordena automáticamente: se da prioridad a los vínculos que contienen "AR" en su nombre y, a continuación, por el número descendente de habitaciones. Por lo general, el vínculo requerido ya está seleccionado por defecto.

*   **Niveles para la sincronización:**
    *   Después de seleccionar un vínculo, la lista inferior muestra solo aquellos niveles de ese vínculo donde se han encontrado habitaciones que contienen dispositivos de alarma contra incendios.
    *   Para cada nivel, la interfaz de usuario ahora muestra un recuento separado para **habitaciones con dispositivos** y **habitaciones vacías** en el formato `Rooms: 7 + 10`. También indica el número total de **dispositivos en habitaciones** y **dispositivos huérfanos** (no asignados a ninguna habitación).
    *   Puede seleccionar uno o varios niveles para procesar marcando las casillas correspondientes.

### 3.1. Configuración de diseño y mapeo

En la parte inferior de la ventana, hay dos campos para ajustar el comportamiento del comando:

*   **Definiciones de sensores (Sensors):**
    *   Este campo determina qué dispositivos se colocarán en la **fila superior** del esquema (considerados "sensores"). Todos los demás dispositivos se colocarán en la fila inferior.
    *   Cada línea corresponde a una regla.
    *   **Formato:** `NombreFamilia: NombreTipo`. El nombre del tipo se puede omitir, en cuyo caso todos los tipos de la familia especificada se considerarán sensores. La coincidencia es **insensible a mayúsculas y minúsculas**.

*   **Mapeo de familias (Family Mapping):**
    *   Este campo define las reglas mediante las cuales las familias y tipos de dispositivos 3D se transforman en símbolos 2D en el diagrama.
    *   **Formato:** `Familia_3D: Tipo_3D: Familia_2D: Tipo_2D`.
    *   Cada línea representa una sola regla. Por ejemplo, la línea `SRS_Smoke_Detector: Standard: Fire alarm 2d: Smoke detector` significa que todos los dispositivos 3D con la familia `SRS_Smoke_Detector` y el tipo `Standard` se representarán en el diagrama mediante el símbolo 2D `Smoke detector` de la familia `Fire alarm 2d`. La coincidencia de los nombres de familia y tipo 3D es **insensible a mayúsculas y minúsculas**.
    *   **Autocompletado automático:** Al abrir el diálogo, el comando escanea automáticamente el modelo de Revit e identifica todas las combinaciones únicas de `(Familia_3D, Tipo_3D)` de dispositivos de alarma contra incendios.
        *   Cualquier combinación `(Familia_3D, Tipo_3D)` recién descubierta que aún no esté en la configuración de mapeo guardada por el usuario se añade automáticamente a la lista. Para estas nuevas entradas, se utilizan los valores predeterminados `Fire alarm 2d` y `Generic` para la familia 2D y el tipo 2D, respectivamente.
        *   La configuración existente del usuario, incluidos los comentarios y el orden, siempre se conserva.
    *   **Características de edición:** El campo incluye un encabezado incorporado que demuestra el formato de la cadena y utiliza una fuente monoespaciada para mayor comodidad.
    *   **Comentarios:** Las líneas que comienzan con un carácter `;` se ignoran durante el análisis, pero se conservan y se pueden usar para comentarios.
    *   **Alineación:** El texto en este campo se alinea automáticamente para una mejor legibilidad.

### 3.2. Opciones Adicionales

*   **Crear habitaciones vacías:**
    *   Si esta opción está habilitada (marcada), el comando creará representaciones 2D para *todas* las habitaciones en los niveles seleccionados, incluso si no contienen ningún dispositivo de alarma de incendios.
    *   Por defecto, esta opción está deshabilitada, y las habitaciones 2D solo se crean para las habitaciones 3D que contienen al menos un dispositivo.

### 3.3. Colocación manual y bloqueo de habitaciones

Después de la creación inicial del esquema, es posible que desee ajustar manualmente la disposición de los dispositivos dentro de ciertas habitaciones y bloquear sus posiciones para evitar que se restablezcan en sincronizaciones posteriores.

Esto se logra utilizando el parámetro de instancia **"Manual placement"** (del tipo Sí/No) en la familia de la habitación 2D.

*   **Cómo funciona:**
    1.  Seleccione una o más habitaciones 2D en el esquema.
    2.  En la paleta de Propiedades, busque el parámetro **"Manual placement"** y marque la casilla (establezca su valor en "Sí").

*   **Qué sucede en la próxima sincronización:**
    *   **Las posiciones de los dispositivos se conservan:** El comando ya no organizará automáticamente los dispositivos 2D existentes dentro de esta habitación. Sus posiciones actuales quedarán bloqueadas.
    *   **El ancho de la habitación se conserva:** El ancho de esta habitación 2D también quedará bloqueado y no cambiará automáticamente según el número de dispositivos.
    *   **Nuevos dispositivos:** Si se agregan nuevos dispositivos a esta habitación en el modelo 3D, sus símbolos 2D aparecerán **en el centro** de la habitación bloqueada. Esto le permite encontrarlos fácilmente y colocarlos manualmente donde sea necesario.

## 4. Paso 2: Proceso de sincronización

Después de pulsar el botón "OK", comienza el proceso de creación y actualización del esquema 2D en la vista de diseño activa.

*   **Creación de habitaciones 2D:**
    *   Para cada habitación de los niveles seleccionados que contenga al menos un dispositivo, se crea una habitación 2D (familia "Room") en el esquema.
    *   Si ya existe una habitación 2D para dicha habitación en el esquema, no se crea una nueva, sino que se actualiza la existente.
    *   El **ancho de la habitación** se calcula automáticamente en función del número máximo de dispositivos en una de las dos filas, para que quepan todos. El ancho mínimo de la habitación es de 40 mm.
    *   En los parámetros de la habitación 2D se escriben el **Número**, el **Nombre** y el **Nivel** de la habitación 3D de origen.

*   **Creación de dispositivos 2D:**
    *   Dentro de cada habitación 2D, se colocan símbolos de dispositivos 2D de acuerdo con sus prototipos 3D.
    *   **Selección de símbolo 2D:** El tipo de símbolo 2D se determina en función de las reglas definidas en el campo **"Mapeo de familias"**. Si no se encuentra una regla adecuada para un dispositivo 3D, se utiliza un símbolo predeterminado ("Generic") y el elemento se colorea de rojo.
    *   **Ubicación:** Los dispositivos se colocan en **dos filas** según las reglas del campo **"Definiciones de sensores"**.
    *   En los parámetros del dispositivo 2D se escribe lo siguiente:
        *   `Code`: Se copia del parámetro `Mark` del dispositivo 3D.
        *   `Room`: Número y nombre de la habitación.
        *   `RoomLevel`: Nombre del nivel de la habitación.

## 5. Resultado e indicación por colores

Después de la sincronización, los elementos del esquema se colorean de forma diferente según su estado. Esto permite evaluar rápidamente qué cambios se han producido en el modelo.

*   **Negro (color estándar):**
    *   Una nueva habitación 2D y todos los dispositivos en ella, creados por primera vez.

*   **Verde:**
    *   Un nuevo dispositivo 2D que se ha añadido a una habitación 2D ya existente en el esquema.

*   **Naranja:**
    *   **Datos actualizados.** Un elemento se colorea de este modo si:
        *   El número o el nombre de la habitación ha cambiado.
        *   Se ha cambiado el tipo del dispositivo 3D, lo que ha dado lugar a un símbolo 2D diferente según las reglas de mapeo.

*   **Púrpura:**
    *   **Elemento movido.** Si un dispositivo 3D se ha movido de una habitación a otra, su símbolo 2D en el esquema también se mueve a la habitación correspondiente y se colorea de púrpura.

*   **Azul:**
    *   **Elemento movido manualmente.** Si un dispositivo 2D fue arrastrado manualmente de una habitación 2D a otra en el esquema por el usuario, su símbolo 2D se coloreará de azul. Esto indica un cambio iniciado por el usuario en el diseño del esquema que se conserva entre sincronizaciones.

*   **Rojo:**
    *   **Elemento "huérfano" o error.** Un elemento se colorea de rojo si:
        *   El elemento 3D original (habitación o dispositivo) se ha eliminado del modelo.
        *   No se encontró ninguna regla de mapeo para el dispositivo 3D y se utilizó el símbolo 2D predeterminado.

## 6. Seguimiento de cambios (Parámetro "Sync info")

Cada elemento 2D del esquema (tanto la habitación como el dispositivo) tiene un parámetro de texto **"Sync info"**. En él se registra automáticamente el historial de todos los cambios que se han producido durante la sincronización, сon la fecha y la hora.

*Ejemplo de registro: "Movido de '101 - Office' a '102 - Corridor' [2025-10-28 14:30:15]"*

![image](.\pic2.png)
![image](.\pic3.png)

## 7. Limitaciones conocidas

*   **Asignación de nivel para dispositivos "huérfanos":** Los dispositivos que no pertenecen a ninguna habitación ("huérfanos") se asignan al nivel más cercano por debajo de una lista de **"niveles válidos"** (es decir, aquellos que contienen habitaciones con dispositivos). Esto se hace para garantizar que solo se muestren los niveles relevantes en la lista de selección de niveles.
*   **Detección de habitaciones:** La detección de habitaciones se realiza con una comprobación adicional de 200 mm por encima y 1000 mm por debajo. En casos excepcionales, si los dispositivos del modelo 3D están situados muy cerca del suelo y fuera de una habitación, el algoritmo puede asignar incorrectamente el dispositivo a una habitación del piso inferior.
*   **Ajuste automático del ancho de las habitaciones:** Cuando cambia el número de dispositivos en una habitación, su ancho en el esquema se ajustará automáticamente. Este comportamiento se puede desactivar para una habitación específica utilizando el parámetro "Manual placement" (ver sección 3.3).
*   **Sin desplazamiento automático:** El script **no desplaza** las habitaciones adyacentes si una de ellas se ha expandido. Esto se hace para preservar la disposición manual de los elementos en el esquema. Si una habitación empieza a solaparse con otra, será necesario seleccionar y mover manualmente los elementos adyacentes.

