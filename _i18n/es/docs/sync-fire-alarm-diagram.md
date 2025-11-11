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
    *   Después de seleccionar un vínculo, la lista inferior muestra todos los niveles de ese vínculo en los que se han encontrado dispositivos de alarma de incendios.
    *   Para cada nivel, se indica el número total de habitaciones y los dispositivos que se encuentran en ellas.
    *   Puede seleccionar uno o varios niveles para procesar marcando las casillas correspondientes.

## 4. Paso 2: Proceso de sincronización

Después de pulsar el botón "OK", comienza el proceso de creación y actualización del esquema 2D en la vista de diseño activa.

*   **Creación de habitaciones 2D:**
    *   Para cada habitación de los niveles seleccionados que contenga al menos un dispositivo, se crea una habitación 2D (familia "Room") en el esquema.
    *   Si ya existe una habitación 2D para dicha habitación en el esquema, no se crea una nueva, sino que se actualiza la existente.
    *   El **ancho de la habitación** se calcula automáticamente en función del número máximo de dispositivos en una de las dos filas (ver más abajo), para que quepan todos. El ancho mínimo de la habitación es de 40 mm.
    *   En los parámetros de la habitación 2D se escriben el **Número**, el **Nombre** y el **Nivel** de la habitación 3D de origen.

*   **Creación de dispositivos 2D:**
    *   Dentro de cada habitación 2D, se colocan símbolos de dispositivos 2D (familia "Fire alarm 2d") de acuerdo con sus prototipos 3D.
    *   **Ubicación:** Los dispositivos se colocan en **dos filas**:
        1.  **Fila superior (sensores):** `Pull Station`, `Heat detector`, `Smoke detector`.
        2.  **Fila inferior (dispositivos de notificación y pulsadores manuales):** `Strobe`, `Horn strobe`, `Horn`.
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
        *   Se ha cambiado el tipo del dispositivo 3D (por ejemplo, `Smoke detector` sustituido por `Heat detector`).

*   **Púrpura:**
    *   **Elemento movido.** Si un dispositivo 3D se ha movido de una habitación a otra, su símbolo 2D en el esquema también se mueve a la habitación correspondiente y se colorea de púrpura.

*   **Rojo:**
    *   **Elemento "huérfano".** Si el elemento 3D original (habitación o dispositivo) se ha eliminado del modelo, su representación 2D en el esquema permanece, pero se colorea de rojo. Esto indica que el elemento del esquema ya no está vinculado al modelo.

## 6. Seguimiento de cambios (Parámetro "Sync info")

Cada elemento 2D del esquema (tanto la habitación como el dispositivo) tiene un parámetro de texto **"Sync info"**. En él se registra automáticamente el historial de todos los cambios que se han producido durante la sincronización, con la fecha y la hora.

*Ejemplo de registro: "Movido de '101 - Office' a '102 - Corridor' [2025-10-28 14:30:15]"*

![image](.\pic2.png)

## 7. Limitaciones conocidas

*   **Detección de habitaciones:** La detección de habitaciones se realiza con una comprobación adicional de 200 mm por encima y 1000 mm por debajo. En casos excepcionales, si los dispositivos del modelo 3D están situados muy cerca del suelo y fuera de una habitación, el algoritmo puede asignar incorrectamente el dispositivo a una habitación del piso inferior.
*   **Ajuste automático del ancho de las habitaciones:** Cuando cambia el número de dispositivos en una habitación, su ancho en el esquema se ajustará automáticamente en la siguiente sincronización.
*   **Sin desplazamiento automático:** El script **no desplaza** las habitaciones adyacentes si una de ellas se ha expandido. Esto se hace para preservar la disposición manual de los elementos en el esquema. Si una habitación empieza a solaparse con otra, será necesario seleccionar y mover manually los elementos adyacentes.

