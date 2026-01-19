# Sincronización de Datos para Esquemas HVAC (Sync Air Flow)
{: .no_toc }

<details open markdown="block">
  <summary>
    Tabla de contenidos
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

Este comando proporciona una sincronización completa de datos entre el modelo 3D y los esquemas 2D, actualizando nombres de espacios, caudales de aire y creando anotaciones de equipos.

---

### 1. Qué Hace el Comando

*   **Actualiza Nombres de Espacios:** Sincroniza el nombre en la anotación 2D del espacio (`SRS_Generic_Annotations_Schematic_Room`) con el nombre del `MEP Space` correspondiente en 3D.
*   **Sincroniza Caudal de Aire:**
    *   Determina en qué espacio del esquema se encuentra cada anotación 2D de difusor y escribe un identificador con el formato `NombreEspacio-NumeroEspacio` en su parámetro **Reference**.
    *   Usando esta **Reference**, suma el caudal de aire de los terminales 3D correspondientes y actualiza los parámetros en la anotación 2D.
*   **Sincroniza Anotaciones de Calentadores Unitarios (Nueva Función):** Crea automáticamente las anotaciones 2D que faltan para los calentadores unitarios 3D o informa sobre las sobrantes, basándose en su cantidad en cada espacio.

### 2. Preparación

Para un funcionamiento correcto, asegúrese de que:
*   Los `MEP Spaces` (espacios de instalaciones) están creados y configurados en el modelo 3D.
*   Las anotaciones 2D de espacio **SRS_Generic_Annotations_Schematic_Room** están colocadas en los planos de esquemas.
*   Las anotaciones 2D de difusor **SRS_Hvc_Generic_Annotations_Diffuser 2D** están colocadas en los planos de esquemas. Para sistemas de Retorno de Aire (Return Air), se espera el tipo de anotación 2D 'Exhaust', y para sistemas de Suministro de Aire (Supply Air), 'Supply'.
*   Para la sincronización de anotaciones de calentadores unitarios, lo siguiente debe estar cargado en el proyecto:
    *   **Equipamiento 3D:**
        *   `SRS_Hvc_Mechanical_Equipment_Wall_Unit_Heater_AHX: MODEL_15TO20KW`
        *   `SRS_Hvc_Mechanical_Equipment_Ceiling_Unit_Heater: OACP1500`
        *   `SRS_Hvc_Mechanical_Equipment_Wall_Unit_Heater: OAS02038AM`
    *   **Anotación 2D:** `SRS_Hvc_Generic_Annotations_Unit_Heater_Elec_Sch`
*   **Nota:** El comando ejecuta automáticamente `Assign Spaces To Equipment` como un paso preliminar en una transacción separada. El resultado de este paso se muestra en el informe como **Paso 0**.

### 3. Uso

1.  Vaya a la pestaña **SNR** en la cinta de opciones de Revit.
2.  Haga clic en el icono **Sync Air Flow**.
3.  El comando realizará todas las comprobaciones y la sincronización automáticamente.
4.  Al final, aparecerá un cuadro de diálogo con un informe del trabajo realizado.

### 4. Resultados

*   Se actualizará el parámetro **Room Name** en las anotaciones de espacio.
*   Se actualizarán los siguientes parámetros en las anotaciones de difusor (`SRS_Hvc_Generic_Annotations_Diffuser 2D`):
    *   **Total flow rate:** El caudal de aire total de todos los terminales 3D coincidentes.
    *   **Number of units:** El número total de terminales 3D coincidentes.
    *   **Mass flow rate:** El caudal de aire promedio (caudal total / número de unidades).
    *   **Flow Details:** Una cadena de texto con detalles del cálculo (p. ej., `2 × 150L/s + 1 × NoParam`).
*   Se crearán las anotaciones 2D que falten para los calentadores unitarios. Las nuevas anotaciones se colocan en una columna, comenzando desde la esquina inferior izquierda del espacio en el esquema.

![ejemplo de esquema](image.png)

### 5. Reporte Interactivo

El comando proporciona un informe detallado de las acciones realizadas.

*   **Reporte Corto:** La ventana principal muestra una versión resumida. Las listas largas de errores (más de 10-20) se truncan automáticamente para facilitar la lectura.
*   **Reporte Completo:** Para ver la lista completa de todos los mensajes e IDs, haga clic en el botón **Abrir informe completo**. Esto creará un archivo de texto con el informe completo y lo abrirá en su editor predeterminado.

### 6. Limitaciones y Lógica

*   **Anotaciones Sobrantes:** El comando **no elimina** las anotaciones "sobrantes" de los calentadores unitarios. En su lugar, informa sobre ellas.
*   **Lógica de Coincidencia de Sistemas (para Caudal de Aire):**
    1.  La **Clase de Sistema** (`Supply Air` o `Return Air`) se determina por el nombre del **tipo** de la anotación 2D del difusor (`Supply` o `Exhaust`).
    2.  El comando primero busca coincidencias entre las anotaciones 2D y los terminales 3D por una **coincidencia exacta** del espacio y la clase de sistema calculada.
    3.  **Si se encuentran múltiples sistemas de la misma clase en un espacio**, se activa una lógica más compleja:
    4.  El nombre de la vista donde se encuentra la anotación 2D se busca como una **subcadena** del nombre del sistema de conductos en 3D.
        *   *Ejemplo: Una anotación 2D en la vista `Plano HVAC SA-1` coincidirá con el sistema `SA-1-Oficina`.*
    5.  Si la coincidencia por nombre de vista falla, el comando realizará una coincidencia **arbitraria** y lo informará.

### 7. Configuración vía JSON

Algunos de los parámetros de funcionamiento del comando, como los **nombres de familias y parámetros**, se pueden configurar a través del archivo de configuración central de BIM Tools. Esto le permite adaptar el comando a los estándares de su proyecto sin cambiar el código.

El archivo de configuración se encuentra en:
`%AppData%\Sener\BimTools\Settings.json`

> **¿Cómo abrir esta ruta?**
> `%AppData%` es un atajo estándar de Windows para acceder a una carpeta oculta con la configuración de las aplicaciones.
>
> 1.  Copie la ruta completa (incluyendo `%AppData%`, pero sin el nombre del archivo: `%AppData%\Sener\BimTools`).
> 2.  Abra el Explorador de Windows (cualquier carpeta, p. ej., "Mi PC").
> 3.  Haga clic en la barra de direcciones, pegue la ruta copiada y presione Enter. La carpeta que contiene el archivo `Settings.json` se abrirá directamente.

Para este comando, busque la sección `SyncAirFlowSettings` en el archivo, cambie los valores deseados y guarde el archivo. No es necesario reiniciar Revit; simplemente ejecute el comando de nuevo.
