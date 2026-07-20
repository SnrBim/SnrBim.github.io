# Create View Filters (Creación de filtros por lotes)
{: .no_toc }

<details open markdown="block">
  <summary>
    Tabla de contenidos
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

La herramienta permite crear y modificar de forma masiva los filtros de vista a través de Excel.

### Qué hace la comando
*   Exporta los filtros existentes a una tabla de Excel.
*   Permite cambiar de forma masiva los nombres, categorías y reglas de filtrado en la tabla.
*   Crea nuevos filtros si en la tabla no se especifica el **Id**.

### Preparación
*   En el proyecto deben estar creados al menos unos filtros básicos para el ejemplo de exportación.
*   Para nombrar los parámetros y categorías, utilice los valores exactos de Revit (lo mejor es tomarlos de la exportación inicial).

![ui](image.png)

### Uso
1.  Haga clic в el botón **Create filters**.
2.  Ordene por nombre o por novedad a través del menú contexto (botón derecho).
3.  En la ventana que se abre, seleccione los filtros deseados (utilice la búsqueda o el filtro por vista activa, selección de grupo con Shift/Ctrl).
4.  Haga clic en **Export Selected** y guarde el archivo.
5.  Edite el archivo Excel:
    *   Cambie los nombres en la columna **Name**.
    *   Edite las categorías y reglas (hasta 3 por filtro).
    *   Para crear una copia del filtro, copie la fila y limpie la columna **Id**.
6.  Vuelva a Revit, haga clic en **Import from File...** y seleccione el archivo modificado.

![excel](image-1.png)

### Resultado
*   **Nuevos filtros**: se crean en el proyecto con la configuración de Excel.
*   **Existentes**: se actualizan solo en caso de cambios reales en los datos (el algoritmo omite las filas sin cambios).
*   **Informe**: al finalizar verá una notificación con el número de elementos creados y modificados.

### Particularidades
*   Los filtros de anidamiento complejo aún no son compatibles (contacte con el desarrollador si surge la necesidad).
*   Formato de parámetros: en Excel los parámetros se guardan en el formato `ID | Nombre | Tipo`; esto es necesario para una identificación precisa. La exportación se basa en el ID, el nombre del parámetro se muestra solo para conveniencia del usuario.
*   Si el nombre del filtro ya existe en el proyecto al crear uno nuevo, la importación dará un error para evitar duplicados.

