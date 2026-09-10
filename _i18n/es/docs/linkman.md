# Administrador de vínculos
{: .no_toc }

<details open markdown="block">
  <summary>
    Tabla de contenidos
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

El administrador de vínculos permite actualizar vínculos de Revit y AutoCAD al seleccionar una carpeta de búsqueda, así como consultar la información de los vínculos.

![Interfaz de LinkMan](ui.png)

## Búsqueda y actualización de vínculos

1. Haga clic en **Select folder...** y seleccione una carpeta de búsqueda. LinkMan examina esa carpeta y sus subcarpetas, y relaciona los archivos con los vínculos del proyecto por nombre de archivo. Primero comprueba la carpeta seleccionada y después las subcarpetas por niveles; dentro de un mismo nivel, las carpetas se comprueban en orden natural inverso.
2. Cuando encuentra una coincidencia, la fila se selecciona automáticamente si la ruta nueva es diferente de la actual y el vínculo está disponible para editarse. Si la ruta coincide con la actual o el vínculo pertenece a otro usuario, la fila no se selecciona automáticamente, pero puede seleccionarla manualmente. Compruebe la ruta nueva, el tamaño y la fecha de modificación del archivo.
3. Puede seleccionar un archivo nuevo con el botón de la fila o pegar su ruta en **Found path**. **Current path** solo se puede consultar y copiar. **Found path** acepta rutas absolutas y relativas; una ruta relativa se resuelve desde la carpeta que contiene el vínculo actual.
4. La etiqueta situada a la izquierda de **Update** muestra el desglose de los vínculos seleccionados entre rutas nuevas y actuales. El botón muestra el número de vínculos seleccionados por tipo: CAD y RVT.

> Durante la actualización se muestra una ventana de progreso. Al pulsar el botón de cancelación no se interrumpe la actualización ya iniciada, pero no se procesa el vínculo siguiente.

## Limitaciones importantes

Actualizar o eliminar vínculos de Revit borra el historial de operaciones, por lo que `Ctrl+Z` no puede deshacer la acción. La actualización de vínculos de AutoCAD no tiene esta limitación.

## Gestión de advertencias de Revit

Durante la actualización, LinkMan confirma automáticamente determinadas advertencias estándar de Revit que no requieren la intervención del usuario, por ejemplo, mensajes sobre geometría que supera los límites permitidos o elementos perdidos durante la importación. Si Revit muestra una advertencia sobre la eliminación de cotas, LinkMan pulsa el botón **Delete Dimension(s)** en el diálogo de Revit, ya que no hay otra forma de continuar la actualización. Los demás diálogos no se suprimen y quedan disponibles para que el usuario los revise.

![Advertencia de referencias no válidas](invalidRefs.png) ![Advertencia de extensiones](33km.png)

> La lista de advertencias gestionadas no es completa. Si aparece un diálogo de Revit que no se gestiona automáticamente, envíe una captura de pantalla al autor de la herramienta para añadirlo al procesamiento automático.

## Consulta y visualización

- La columna **Instances** muestra el número de instancias del vínculo. Pase el cursor sobre el valor para ver un tooltip con los detalles. Haga clic derecho en el valor para copiar los datos al portapapeles.
- **Narrow view** combina la ruta actual y la nueva, el tamaño y la fecha en celdas compactas de dos líneas. Es útil para rutas largas y para comparar los archivos antiguo y nuevo; en la vista normal, la información del archivo nuevo aparece en columnas separadas.
- **Right alignment** alinea las rutas a la derecha para facilitar la comparación de los nombres de archivo sin sus carpetas.

## Eliminación de vínculos

Haga clic derecho en una fila para eliminar el vínculo; puede seleccionar varios vínculos. LinkMan solicita confirmación y muestra los elementos seleccionados. La eliminación quita los tipos de vínculo y todas sus instancias del proyecto actual, pero no elimina los archivos de origen del disco.

