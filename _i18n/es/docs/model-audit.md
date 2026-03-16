# ModelAudit — Guía de usuario
{: .no_toc }

<details open markdown="block">
  <summary>
    Tabla de contenidos
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

ModelAudit es una herramienta de auditoría automatizada de modelos BIM en Revit. Analiza el documento actual y todos los vínculos Revit cargados, generando un informe Excel con datos detallados en 31 categorías de verificación.

---

## Interfaz

Al iniciarse se abre un diálogo con tres secciones.

### Configuration (Opcional)

Campo para la ruta al archivo Excel de configuración. Controla qué verificaciones se ejecutarán, qué categorías de Revit se exportarán y qué parámetros de elementos se incluirán en el informe.

**Si el campo está vacío** — se utiliza la configuración predeterminada incorporada (verificaciones pesadas desactivadas, conjunto estándar de categorías y parámetros).

Botones:
- **Browse…** — seleccionar un archivo de configuración existente.
- **Generate…** — crear un nuevo archivo de configuración con valores predeterminados. El diálogo sugiere la ruta `%APPDATA%\Sener\BimTools\ModelAudit\Config-{ModelName}.xlsx`. El archivo también incluye una hoja **Aliases** con nombres cortos autogenerados para los documentos vinculados — se pueden editar manualmente.

Debajo del campo se muestra un **resumen de configuración** en tres columnas:
- izquierda — número de verificaciones y categorías activas (pase el cursor para la lista completa)
- centro — número de parámetros por categoría
- derecha — nombre del archivo de configuración y hora de última modificación

Si la configuración contiene errores, se muestra un mensaje de error en lugar del resumen.

> La ruta de configuración se guarda al pulsar **Run Audit** y se restaura al abrir el diálogo la próxima vez.

### Previous Report (Opcional)

Ruta al informe anterior. Si se indica, aparecen columnas **Old** / **New** en la hoja Summary para comparar valores entre ejecuciones. Las celdas Old contienen hipervínculos a las hojas de detalle del informe anterior.

### New Report Path

Ruta para guardar el nuevo informe. Se genera por defecto como:

```
%APPDATA%\Sener\BimTools\Reports\ModelAudit\{yyyy-MM-dd HH-mm}\{ModelName}.xlsx
```

La fecha y la hora forman parte del nombre de la carpeta — ejecutar de nuevo en el mismo minuto sobrescribe el archivo en la misma carpeta.

Botones:
- **Browse…** — seleccionar la ruta manualmente mediante un diálogo de guardado.
- **Default** — generar una nueva ruta con la fecha y hora actuales.

> La ruta se guarda al pulsar **Run Audit**.

### Ejecución

- **Run Audit** (o **Enter**) — iniciar la auditoría.
- **Cancel** (o **Esc**) — cerrar el diálogo sin ejecutar.

Antes de iniciar, la herramienta comprueba si el archivo de informe está accesible: si ya está abierto en Excel aparece un diálogo Retry / Cancel.

---

## Barra de progreso

Durante el análisis se muestra una ventana de progreso con un registro de texto de la ejecución. El registro es de solo lectura. El botón **Stop** interrumpe el procesamiento.

---

## Estructura del informe

El informe es un archivo Excel (`.xlsx`) con las siguientes hojas:

### Summary

Hoja resumen. Las filas son verificaciones, las columnas son documentos (actual + vinculados).

- El encabezado de cada fila contiene el nombre de la verificación con un hipervínculo a la hoja de detalle.
- Dos columnas por documento: **Old** (valor del informe anterior) y **New** (actual).
- Última columna — **Duration** (tiempo de ejecución de la verificación, formato mm:ss).
- Los nombres cortos de los documentos en el encabezado enlazan a la hoja `_Metadata`.
- La hoja está fijada en dos filas de encabezado y las primeras dos columnas.

Esquema de colores:
- **Fondo amarillo** — estado High (el valor requiere atención).
- **Texto gris / pálido** — estado Low (valor normal o sin cambios).

### Hojas de detalle

Una hoja por verificación activa. Contiene una tabla con datos de todos los documentos juntos. Un borde horizontal separa los documentos. Los autofiltros están habilitados. La primera celda enlaza de vuelta a Summary.

### \_Metadata

Tabla de correspondencia entre nombres cortos y completos de los documentos. Los enlaces de Short Name vuelven a Summary.

### \_Config\_\* (ocultas)

Las hojas `_Config_Checks`, `_Config_Categories`, `_Config_Parameters` almacenan la configuración utilizada en la ejecución. Permiten reproducir las condiciones de análisis a partir de un informe archivado.

---

## Lista de verificaciones (31)

| # | Nombre | Hoja | Defecto | Descripción |
|---|--------|------|---------|-------------|
| 1 | Grids | DatumGrids | ✓ | Ejes: nombre, Id, monitoreo (elemento vinculado), workset |
| 2 | Levels | DatumLevels | ✓ | Niveles: cota (m), monitoreo, workset |
| 3 | Matchlines | DatumMatchLines | ✓ | Líneas de coincidencia: coordenadas de segmentos |
| 4 | ScopeBoxes | DatumScopeBoxes | ✓ | Marcos de vista: coordenadas, dimensiones, workset |
| 5 | Groups | ProjectGroups | ✓ | Grupos de modelo: nombre, Id, workset |
| 6 | FamInstances | ElementPropertyInstances | ✗ | Instancias de familias con parámetros (lento) |
| 7 | FamTypes | ElementPropertyTypes | ✗ | Tipos de familias con parámetros (lento) |
| 8 | InPlaceFams | FamiliesIsInPlace | ✓ | Familias In-Place: categoría, Id, Ids de instancias |
| 9 | FamSizes | FamiliesRFA | ✗ | Tamaño del archivo RFA por familia (muy lento — guarda cada familia en un archivo temporal) |
| 10 | LinksDwg | LinkInstanceDwg | ✓ | Vínculos DWG/DXF: estado, ruta, nivel, coordenada Z |
| 11 | LinksRaster | LinkInstanceImages | ✓ | Vínculos ráster: origen, estado, nivel |
| 12 | LinksRvt | LinkInstanceRvt | ✓ | Vínculos Revit: nombre, workset, tipo de adjunto (Overlay/Attachment), posición |
| 13 | BasePoints | LocationProjectBasePoints | ✓ | Puntos base del proyecto y de levantamiento: coordenadas (cm) |
| 14 | ProjectName | LocationProjectName | ✓ | Ubicación del proyecto: latitud, longitud, elevación, sistema de coordenadas |
| 15 | BrowserOrg | ProjectBrowserOrganization | ✓ | Esquemas de organización del navegador: tipo (vistas/hojas/planillas), activo |
| 16 | DesignOptions | ProjectDesignOptions | ✓ | Opciones de diseño: Id, nombre, activa |
| 17 | GeneralData | ProjectGeneralData | ✓ | Metadatos del documento: Long/Short Name, tamaño de archivo, vista inicial, identificadores en la nube |
| 18 | ProjectInfo | ProjectInfo | ✓ | Parámetros de ProjectInformation: todos los parámetros de la hoja |
| 19 | ParamMapping | ProjectParameters | ✓ | Enlaces de parámetros del proyecto: nombre, tipo (Instance/Type), categorías |
| 20 | Phases | ProjectPhases | ✓ | Fases del proyecto: Id, nombre |
| 21 | Warnings | ProjectWarmings | ✓ | Advertencias de Revit: descripción, gravedad, Ids de elementos |
| 22 | Worksets | ProjectWorkSets | ✓ | Worksets: Id, nombre |
| 23 | Revisions | SheetRevisions | ✓ | Revisiones de hojas: hoja, Id de revisión, fecha, número, descripción |
| 24 | Sheets | SheetsProperties | ✓ | Hojas: Id, nombre, número, IsPlaceholder, cajetín + parámetros personalizados |
| 25 | TitleBlocks | SheetTileBlocks | ✓ | Tipos de cajetín y hojas asignadas |
| 26 | Viewports | SheetViewPorts | ✓ | Viewports: tipo, vista, hoja |
| 27 | Views | ViewsProperties | ✗ | Todas las vistas con 32 propiedades (plantilla, escala, recorte lejano, ViewRange, etc.) |
| 28 | WorksetElements | WorkSetElements | ✗ | Distribución de elementos por workset: categoría, familia, tipo, cantidad (muy lento) |
| 29 | Areas | ZonesAreas | ✓ | Áreas: área, perímetro, esquema de zonificación |
| 30 | Rooms | ZonesRooms | ✓ | Habitaciones: área, altura, acabados, departamento + parámetros personalizados |
| 31 | Spaces | ZonesSpaces | ✓ | Espacios MEP: área, altura, sistema de ventilación + parámetros personalizados |

> ✗ — desactivado por defecto. Se activa en el Excel de configuración (hoja Checks, columna Active = yes).

---

## Excel de configuración

Se genera con el botón **Generate…**. Se recomienda editar el archivo antes de ejecutar la auditoría.

### Hoja Checks

Controla la actividad de las verificaciones.

| Columna | Descripción |
|---------|-------------|
| Check Name | Nombre de la verificación (coincide con el código, no modificar) |
| Active | `yes` / `no` (o `true` / `false` / `1` / `0`) |
| Sheet Name | Nombre de la hoja de detalle en el informe |
| Description | Información adicional |

### Hoja Categories

Controla las categorías activas para las verificaciones FamInstances y FamTypes.

| Columna | Descripción |
|---------|-------------|
| BuiltInCategory | Valor enum de Revit, p. ej. `OST_Walls` (no modificar) |
| Active | `yes` / `no` (o `true` / `false` / `1` / `0`) |
| Category Name | Nombre localizado (se rellena automáticamente, no modificar) |

### Hoja Parameters

Controla los parámetros de elementos a exportar.

- Primera fila — encabezados: `Common`, luego nombres de las categorías activas.
- Columna **Common** — parámetros exportados para todas las categorías activas.
- Las demás columnas — parámetros específicos de una categoría.
- Las celdas vacías se ignoran.
- Un parámetro se busca primero en la instancia y luego en el tipo.
- Los parámetros inexistentes se registran en el log.

### Hoja Aliases

Nombres cortos de los documentos para los encabezados de Summary.

| Columna | Descripción |
|---------|-------------|
| Full Name | Nombre completo del documento (clave, no modificar) |
| Short Name | Nombre de visualización abreviado (editable) |

Al generar, los nombres cortos se crean automáticamente eliminando el prefijo y sufijo común de todos los nombres de documentos. Los documentos ausentes del archivo Aliases obtienen su nombre corto generado automáticamente en tiempo de ejecución.

---

## Consejos y notas

### Configuración

- **Campo ConfigPath vacío** equivale a la configuración predeterminada incorporada — limpiar la ruta es seguro.
- El resumen debajo del campo se actualiza inmediatamente al cambiar la ruta — los errores de validación son visibles antes de ejecutar.
- La validación se repite al pulsar Run. Si la configuración es inválida, la ejecución se bloquea.
- **Nombre de verificación desconocido** en la hoja Checks → error con la lista de nombres válidos.
- **Categoría desconocida** en la hoja Categories o Parameters → error con la lista de categorías soportadas.
- El orden de las filas en las hojas Checks y Categories no importa.
- La configuración se lee de nuevo en cada ejecución (sin caché).
- La configuración utilizada en una ejecución se almacena en hojas ocultas del informe.

### Nombres de documentos

- Los nombres cortos aparecen en los encabezados de Summary — esto mantiene la tabla compacta con muchos vínculos.
- Si un documento vinculado aparece después de generar la configuración, su nombre se genera automáticamente; añádalo manualmente a la hoja Aliases si es necesario.
- Edite la hoja Aliases en la configuración antes de ejecutar si las abreviaciones autogeneradas son inconvenientes.

### Rutas de informes

- La ruta del nuevo informe se recuerda entre sesiones. Se genera automáticamente en el primer inicio.
- El botón **Default** genera una nueva ruta con la fecha actual — útil al volver a ejecutar en otro día.
- Dos ejecuciones en el mismo minuto crean el archivo en la misma carpeta → la segunda ejecución lo sobreescribirá. Use **Browse** o **Default** para crear una nueva ruta si necesita conservar ambos resultados.
- Si el archivo de informe está abierto en Excel, aparece un diálogo de reintento. La auditoría no se iniciará mientras el archivo esté bloqueado.
- La ruta del informe anterior **no se rellena automáticamente** — debe indicarse manualmente a través de Browse.

### Rendimiento

- Las verificaciones **FamInstances** y **FamTypes** están desactivadas por defecto — recorren todos los elementos de las categorías seleccionadas y extraen parámetros. El tiempo de ejecución depende del número de categorías activas y del tamaño del modelo.
- La verificación **FamSizes** está desactivada por defecto — para cada familia se llama a `EditFamily` + `SaveAs` en una carpeta temporal. En modelos grandes puede tardar varias horas.
- La verificación **WorksetElements** está desactivada por defecto — recorre todos los elementos de todos los worksets.

### Modelos vinculados

- Solo se analizan los vínculos Revit cargados.
- Los vínculos no cargados no se incluyen en el análisis.
- Los documentos con el mismo `Title` se añaden una sola vez.

### Datos del informe

- Los valores numéricos (coordenadas, áreas, distancias) se escriben como números de Excel — esto permite ordenar y filtrar correctamente.
- Los valores compuestos (p. ej. una lista de Ids separada por espacios) permanecen como cadenas de texto.
- Los saltos de línea dentro de los valores de parámetros se conservan.

