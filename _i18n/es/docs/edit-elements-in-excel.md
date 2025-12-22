# Edición de parámetros en Excel
{: .no_toc }

<details open markdown="block">
  <summary>
    Tabla de contenidos
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

## Descripción

Este comando permite exportar los parámetros seleccionados de elementos de Revit a un archivo de Excel para una edición cómoda y, a continuación, importar los datos modificados de nuevo al modelo de Revit. Admite el uso de fórmulas de Excel y puede actualizar o añadir datos a archivos creados anteriormente.

## Funciones adicionales

-   **Columnas personalizadas en Excel**: Puede añadir nuevas columnas (parámetros) directamente en el archivo de Excel. Al utilizar la función "Update file...", el comando reconoce automáticamente estas nuevas columnas y las rellena con datos, eliminando la necesidad de seleccionar los parámetros en la interfaz cada vez que se ejecuta.

-   **Conservación de fórmulas y orden de columnas**: Si utiliza fórmulas de Excel en las celdas, se conservarán al actualizar el archivo (dichas celdas se marcan en verde). El orden de las columnas también se mantiene, lo que le permite personalizar la vista de la tabla según sus necesidades.

-   **Modo de edición en TXT**: Para ediciones sencillas, puede utilizar la opción "Edit as txt file" del menú de opciones adicionales (⋮). Los datos se exportan a un archivo de texto donde cada valor se encuentra en una nueva línea.

-   **Parámetros especiales (nonParams)**: El comando permite exportar no solo los parámetros estándar de Revit, sino también valores especiales calculados. Tienen un prefijo `_` (por ejemplo, `_Coordinates`, `_HostId`, `_SpaceName`, `_RoomNumber`). Estos parámetros son de solo lectura.

## Uso

1.  Ejecute el comando "Edit in Excel" desde la pestaña BIMTools en Revit.
2.  En la ventana que aparece, seleccione los parámetros de los elementos que desea exportar/editar.
3.  Utilice las opciones para incluir parámetros de tipo, parámetros de instancia, ordenación alfabética o incluir una hoja con información del proyecto.
4.  Haga clic en "Edit in Excel" para exportar y comenzar a editar.
    *   El comando creará un archivo de Excel con los elementos de Revit como filas y los parámetros seleccionados como columnas.
    *   Después de terminar de editar en Excel, confirme en Revit para importar los cambios.
    *   **Nota:** Cuando utilice la opción "Edit in Excel" para exportar datos y esperar su edición, el archivo Excel creado se guarda por defecto en la carpeta: `%appdata%\Roaming\Sener\BimTools\Reports\EditInExcel\<Nombre_del_Modelo_Revit>\`, con un nombre que incluye la fecha y hora actuales.
5.  Utilice "Write to file..." para guardar el archivo de Excel sin esperar a la importación.
6.  Utilice "Update file..." para añadir nuevos elementos o actualizar los existentes en un archivo de Excel ya creado.
7.  Utilice "Read from file..." para importar datos de un archivo de Excel guardado anteriormente.

![alt text](image.png)

## Ejemplos de uso

### 1. Renumeración de planos o habitaciones

-   **Tarea**: Tiene un gran conjunto de planos (por ejemplo, más de 100) y necesita cambiar rápidamente su numeración añadiendo un prefijo (por ejemplo, `A-101` -> `AR-101`). Hacerlo manualmente en Revit es lento e incómodo.
-   **Solución**:
    1.  Seleccione todos los planos en el Navegador de proyectos.
    2.  Ejecute el comando "Edit in Excel" y exporte el parámetro "Número de plano".
    3.  En el archivo de Excel resultante, utilice fórmulas para cambiar los números en bloque. Por ejemplo, en una celda adyacente, escriba `="AR-" & EXTRAE(A2;3;100)`, copie la fórmula en todas las filas y, a continuación, copie el resultado como valores de nuevo en la columna "Número de plano".
    4.  Guarde el archivo e importe los cambios de nuevo en Revit. Todos los planos se renumerarán al instante.

### 2. Copiar la longitud de los muros al parámetro "Comentarios"

-   **Tarea**: Para crear una tabla de planificación o un informe externo, necesita que la longitud de cada muro se escriba en su parámetro "Comentarios".
-   **Solución**:
    1.  Seleccione todos los muros deseados.
    2.  Ejecute el comando y exporte los parámetros "Longitud" и "Comentarios".
    3.  En el archivo de Excel, obtendrá dos columnas. En la columna "Comentarios", introduzca una fórmula sencilla que haga referencia a la celda con la longitud (por ejemplo, `=C2`) y arrástrela a todas las filas.
    4.  También puede añadir texto, por ejemplo, `="Longitud del muro: " & C2 & " mm"`.
    5.  Guarde el archivo e importe los cambios. El parámetro "Comentarios" de todos los muros se rellenará con el valor de su longitud.

### 3. Actualización masiva de datos desde un archivo externo

-   **Tarea**: Un ingeniero o diseñador le ha enviado una hoja de cálculo de Excel сon datos actualizados para las habitaciones (por ejemplo, nuevos nombres, acabado del suelo, acabado del techo). Introducir estos cambios manualmente lleva mucho tiempo y es propenso a errores.
-   **Solución**:
    1.  Seleccione todas las habitaciones del modelo de Revit.
    2.  Exporte a Excel los parámetros que deben actualizarse (por ejemplo, "Número", "Nombre", "Acabado de suelo"), así como el `ElementId`.
    3.  Utilice el `ElementId` o el "Número" de la habitación como clave única para vincularlo con el archivo externo. Con la función `BUSCARV` (`VLOOKUP`) en Excel, transfiera los datos actualizados del archivo del ingeniero a su hoja de trabajo.
    4.  Guarde el archivo e importe. Todos los datos de las habitaciones en el modelo de Revit se actualizarán de acuerdo con la hoja de cálculo.
