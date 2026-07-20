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

ModelAudit es una herramienta de auditoría automatizada de modelos BIM en Autodesk Revit. Analiza el documento actual y todos los vínculos Revit cargados. El resultado es un informe Excel con datos detallados para cada una de las más de treinta verificaciones.

---

## Interfaz

Al iniciarse se abre un diálogo con tres secciones.

![Ventana principal de ModelAudit](ui-dialog.png)

### Configuration (Opcional)

Ruta al archivo Excel de configuración. Controla qué verificaciones ejecutar, qué categorías de Revit exportar y qué parámetros de elementos incluir en el informe.

**Si está vacío** — se utiliza la configuración predeterminada incorporada (verificaciones pesadas desactivadas, conjunto estándar de categorías y parámetros).

Botones:
- **Browse…** — seleccionar un archivo de configuración existente.
- **Generate…** — crear un nuevo archivo de configuración con valores predeterminados. El diálogo sugiere la ruta `%APPDATA%\Sener\BimTools\ModelAudit\Config-{ModelName}.xlsx`. El archivo también incluye una hoja **Aliases** con nombres cortos autogenerados para los documentos vinculados — se pueden editar manualmente.

Se muestra un **resumen de configuración** debajo del campo en tres columnas:
- izquierda — número de verificaciones y categorías activas (pase el cursor para la lista completa)
- centro — número de parámetros por categoría
- derecha — nombre del archivo de configuración y hora de última modificación

Si la configuración contiene errores, se muestra un mensaje de error en lugar del resumen.

> La ruta de configuración se guarda entre sesiones.

### Previous Report (Opcional)

Ruta al informe anterior. Si se indica, aparecen columnas **Old** / **New** en la hoja Summary para comparar valores entre ejecuciones. Las celdas Old contienen hipervínculos a las hojas de detalle del informe anterior.

### New Report Path

Ruta para guardar el nuevo informe. Por defecto se genera como:

```
%APPDATA%\Sener\BimTools\Reports\ModelAudit\{yyyy-MM-dd}\{ModelName}.xlsx
```

La fecha forma parte del nombre de la carpeta — ejecutar de nuevo el mismo día sobrescribe el archivo en la misma carpeta.

**Checkbox "Usar ruta relativa"** (activo solo si se especifica archivo de configuración):

Al activarlo, la ruta del informe se calcula automáticamente en relación a la carpeta del archivo de configuración:

```
[ConfigDir]/Reports/{ModelName}.xlsx
```

El campo de ruta y los botones quedan deshabilitados — la ruta solo se puede ver. En cada sobrescritura, el informe anterior se guarda automáticamente como copia de seguridad:

```
[ConfigDir]/Reports/backup/{ModelName}_{yyyy-MM-dd_HH-mm-ss}.xlsx
```

El estado del checkbox se guarda entre sesiones. Si el archivo de configuración no está especificado o no existe, el checkbox está deshabilitado.

Botones (solo disponibles cuando "Usar ruta relativa" está desactivado):
- **Browse…** — seleccionar la ruta manualmente mediante un diálogo de guardado.
- **Default** — generar una nueva ruta con la fecha actual.

> La ruta absoluta se guarda entre sesiones. En modo relativo no se sobrescribe — al desactivar el checkbox se restaura la ruta absoluta anterior.

### Ejecución

- **Create / Update** (o **Enter**) — crear o actualizar el informe.
- **Cancel** (o **Esc**) — cerrar el diálogo sin ejecutar.

---

## Barra de progreso

Durante el análisis se muestra una ventana de progreso con un registro de texto de la ejecución. El registro es de solo lectura. El botón **Stop** interrumpe el procesamiento.

---

## Estructura del informe

El informe es un archivo Excel (`.xlsx`). Los nombres de las hojas son intencionalmente cortos (`gr`, `lv`, `bo`, etc.) — la navegación se realiza mediante hipervínculos, no cambiando pestañas manualmente: Summary enlaza a cada hoja de detalle y matriz; la primera celda de cada hoja vuelve a la fila correspondiente en Summary.

### Summary

Hoja resumen. Las filas son verificaciones, las columnas son documentos (actual + vinculados).

![Summary — 14 proyectos, 33 verificaciones](summary.png)

- Nombre de verificación — hipervínculo a la hoja de detalle.
- La columna **Extra** contiene enlaces:
  - **⊞** — a la hoja de matriz (tabla resumen para todos los proyectos).
  - **☰** — a hojas de detalle adicionales (p. ej., desglose de vistas por tipo).
- Dos columnas por documento: **Old** (valor del informe anterior) y **New** (actual). Las celdas Old contienen hipervínculos a las hojas de detalle del informe anterior.
- Columnas derechas **DateTime** y **Duration** — fecha de la última ejecución y tiempo de ejecución.
- Al pasar el cursor sobre el nombre corto del documento en el encabezado se muestra el nombre completo del archivo.

Color scheme:
- **Fondo amarillo** — estado High (el valor requiere atención) o advertencia específica en la matriz (p. ej., múltiples instancias del mismo vínculo).
- **Texto gris / pálido** — estado Low (valor normal o sin cambios).

### Hojas de detalle

Una hoja por verificación activa. La mayoría de las hojas incluyen columnas **Workset**, **CreatedBy**, **LastChangedBy**.

![Hoja de detalle Grids](detail-grids.png)

### Hojas de matriz

Las verificaciones pueden generar hojas de matriz (nombre: `M` + abreviatura de la hoja de detalle) u hojas anidadas adicionales. Los enlaces a ellas están en la columna **Extra** de Summary. No todas las hojas tienen enlaces (p. ej., 5 hojas adicionales de vistas).

| Hoja | Filas × Columnas |
|------|-----------------|
| Mgr  | Ejes × Documentos. `Mon` — monitorizado, `No` — presente pero no monitorizado |
| Mlv  | Niveles × Documentos. Celda: valor de cota, gris si no está monitorizado |
| Mlr  | Archivos vinculados × Documentos. Celda: número de instancias del vínculo. Amarillo — más de una instancia. |
| Mbo  | Documentos × Tipo de organización del navegador (Views / Schedules / Sheets / Modified) |
| Mpi  | Documentos × Parámetros ProjectInfo |
| Mpm  | Parámetros × Documentos. Celda: número de categorías en el binding |
| Mph  | Documentos × Fases |
| Mwr  | Advertencias × Documentos |
| Mw1  | Worksets × Documentos |
| Mw2  | Matriz en bloque: categorías × worksets (bloque separado por documento) |
| Mun  | Tipos de unidades × Documentos. Muestra las unidades de medida configuradas en los proyectos donde se han modificado. |
| vpE  | (Hoja extra) Ubicación de los viewports en los planos + enlace al visor HTML interactivo. |

![Matriz Mgr — ejes con tooltip Created/Modified](matrix-grids.png)

![Matriz Mw1 — tooltip con usuarios y tipos](matrix-worksets.png)

### Aliases (oculta)

Tabla de correspondencia entre nombres cortos y completos de los documentos.

### Config (hojas ocultas)

Las hojas `Checks`, `Categories`, `Parameters` almacenan la configuración utilizada en la ejecución. Permiten reproducir las condiciones de análisis a partir de un informe archivado.

---

## Lista de verificaciones

| # | Nombre | Hoja | Descripción |
|---|--------|------|-------------|
| 1 | Grids | gr | Ejes: nombre, Id, monitoreo (elemento vinculado), workset |
| 2 | Levels | lv | Niveles: cota (m), monitoreo, workset |
| 3 | Matchlines | ml | Líneas de coincidencia: coordenadas de segmentos |
| 4 | ScopeBoxes | sb | Marcos de vista: coordenadas, dimensiones, workset |
| 5 | Groups | gp | Grupos de modelo: nombre, Id, workset |
| 6 | FamInstances | ei | Instancias de familias con parámetros (lento) |
| 7 | FamTypes | et | Tipos de familias con parámetros (lento) |
| 8 | InPlaceFams | ip | Familias In-Place: categoría, Id, Ids de instancias |
| 9 | FamSizes | fs | Tamaño del archivo RFA por familia (muy lento — guarda cada familia en un archivo temporal) |
| 10 | LinksDwg | ld | Vínculos DWG/DXF: estado, ruta, nivel, coordenada Z |
| 11 | LinksRaster | li | Vínculos ráster: origen, estado, nivel |
| 12 | LinksRvt | lr | Vínculos Revit: nombre, workset, tipo de adjunto (Overlay/Attachment), posición |
| 13 | BrowserOrg | bo | Esquemas de organización del navegador: tipo (vistas/hojas/planillas), activo |
| 14 | DesignOptions | do | Opciones de diseño: Id, nombre, activa |
| 15 | GeneralData | gd | Metadatos del documento: Long/Short Name, tamaño de archivo, vista inicial, identificadores en la nube |
| 16 | ProjectInfo | pi | Parámetros de ProjectInformation: todos los parámetros excepto los NonVisible |
| 17 | ParamMapping | pm | Bindings de parámetros del proyecto: nombre, tipo (Instance/Type), categorías |
| 18 | Phases | ph | Fases del proyecto: Id, nombre |
| 19 | Warnings | wr | Advertencias de Revit: descripción, gravedad, Ids de elementos |
| 20 | Worksets | ws | Worksets: Id, nombre |
| 21 | Revisions | re | Resumen de revisiones: Id, fecha, descripción, SheetCount donde está presente. |
| 22 | Sheets | sh | Hojas: Id, número, nombre, IsPlaceholder, cajetín, parámetros de agrupación, CurrentRevisionId. |
| 23 | TitleBlocks | tb | Tipos de cajetín: familia, tipo, InstanceCount en el documento. |
| 24 | Viewports | vp | Viewports: tipo, vista, hoja. Genera hoja extra vpE e informe HTML. |
| 25 | Views | vw | Vistas: propiedades principales + hojas extra agrupadas por tipo (Planos, Secciones, 3D, Tablas, Otros). |
| 26 | Areas | ar | Áreas: área, perímetro, esquema de zonificación |
| 27 | Rooms | rm | Habitaciones: área, altura, acabados, departamento + parámetros personalizados |
| 28 | Spaces | sp | Espacios MEP: área, altura, sistema de ventilación + parámetros personalizados |
| 29 | Units | un | Unidades: desviaciones de los valores predeterminados |
| 30 | Coordinates | co | Coordenadas del proyecto: puntos base, levantamiento, ángulo, nombre del sitio |

> Algunas verificaciones están desactivadas en la configuración predeterminada — gestionadas en el Excel de configuración (hoja Checks, columna Active).

---

## Excel de configuración

Se genera con el botón **Generate…**. Se recomienda editar el archivo antes de ejecutar la auditoría.

![Hojas de configuración](config.png)

### Hoja Checks

Controla la actividad de las verificaciones.

| Columna | Descripción |
|---------|-------------|
| Check Name | Nombre de la verificación (coincide con el código, no modificar) |
| Active | `yes` / `no` (o `true` / `false` / `1` / `0`) |
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

Al generar, los nombres cortos se crean automáticamente eliminando el prefijo y sufijo común. Los documentos ausentes del archivo Aliases obtienen su nombre corto generado automáticamente en tiempo de ejecución.

---

## Consejos y notas

### Configuración

- **Campo ConfigPath vacío** equivale a la configuración predeterminada incorporada — limpiar la ruta es seguro.
- El resumen debajo del campo se actualiza inmediatamente al cambiar la ruta — los errores de validación son visibles antes de ejecutar.
- La validación se repite al pulsar Create/Update. Si la configuración es inválida, la ejecución se bloquea.
- **Nombre de verificación desconocido** en la hoja Checks → error con la lista de nombres válidos.
- **BuiltInCategory inválida** → error. Se acepta cualquier BIC válida de la API de Revit.
- El orden de las filas en las hojas Checks y Categories no importa.
- La configuración se lee de nuevo en cada ejecución (sin caché).
- La configuración utilizada en una ejecución se almacena en hojas ocultas del informe.

### Nombres de documentos

- Los nombres cortos aparecen en los encabezados de Summary — mantiene la tabla compacta con muchos vínculos.
- Si un documento vinculado aparece después de generar la configuración, su nombre se genera automáticamente; añádalo manualmente a la hoja Aliases si es necesario.
- Edite la hoja Aliases en la configuración antes de ejecutar si las abreviaciones autogeneradas son inconvenientes.

### Rutas de informes

- La ruta del nuevo informe se recuerda entre sesiones. Al primer inicio se genera automáticamente.
- El botón **Default** genera una nueva ruta con la fecha actual — útil al volver a ejecutar en otro día.
- Dos ejecuciones el mismo día crean el archivo en la misma carpeta → la segunda ejecución lo sobrescribirá. Use **Browse** o **Default** para crear una nueva ruta si necesita conservar ambos resultados.
- **"Usar ruta relativa"** — útil para trabajo en equipo: el informe se guarda junto a la configuración, no en `%APPDATA%`. Cada sobrescritura crea automáticamente una copia de seguridad con timestamp en la carpeta `backup/`.
- Si el archivo de informe está abierto en Excel, aparece un diálogo de reintento. La auditoría no se iniciará mientras el archivo esté bloqueado.
- La ruta del informe anterior **no se rellena automáticamente** — debe indicarse manualmente a través de Browse.

### Rendimiento

- **FamInstances** y **FamTypes** están desactivadas por defecto — recorren todos los elementos de las categorías seleccionadas y extraen parámetros. El tiempo de ejecución depende del número de categorías activas y del tamaño del modelo.
- **FamSizes** está desactivada por defecto — para cada familia se llama a `EditFamily` + `SaveAs` en una carpeta temporal. En modelos grandes puede tardar varias horas.

### Modelos vinculados

- Solo se analizan los vínculos Revit cargados.
- Los vínculos no cargados no se incluyen en el análisis.
- Los documentos con el mismo `Title` se añaden una sola vez.

### Datos del informe

- Los valores numéricos (coordenadas, áreas, distancias) se escriben como números de Excel — permite ordenar y filtrar correctamente.
- Los valores compuestos (p. ej. una lista de Ids separada por espacios) permanecen como cadenas de texto.
- Los saltos de línea dentro de los valores de parámetros se conservan.

---

## Historial de cambios

### [25.44] — 2026/07/17
- Coordinates: Se ha corregido el cálculo del ángulo (Angle to True North) — se ha invertido la dirección (CCW → CW) para que los datos del informe coincidan con los valores de la interfaz de Revit.

### [25.39] — 2026/06/30
- Coordinates ampliado; eliminados SiteLocations, BasePoints y WorksetElements redundantes.
- TitleBlocks y Revisions: salida comprimida — reducido el número de filas añadiendo una columna Count.
- Datos de Views duplicados en 5 hojas extra (agrupadas por ViewType).
- Units: implementada una matriz que muestra las desviaciones de unidades respecto a los valores métricos por defecto en todos los proyectos.
- Sheets: Añadida columna CurrentRevisionId.
- LinksRvt: Ahora resalta en amarillo las celdas de la matriz si hay más de una instancia del mismo vínculo cargada en un archivo.
- Viewports: Creado un nuevo informe interactivo HTML. Se genera una hoja extra vpE con un enlace al mapa HTML para la comprobación de Viewports, mostrando la distribución de TitleBlocks y tipos de viewports en los planos.

### [25.34] — 2026/05/14
- En las comprobaciones de **Sheets** y **Views** ahora se incluyen los parámetros de agrupación del Navegador de Proyectos.
- Los parámetros integrados, que antes se establecían a través de la configuración, ahora siempre se incluyen de forma fija (por ejemplo, IFC para familias, Area Type/Design Option/Comments para Áreas, etc.). Esto garantiza el funcionamiento correcto independientemente del idioma de Revit; otros parámetros pueden añadirse mediante la configuración.
- En los informes de **FamInstances** y **FamTypes**, los parámetros de tipo ya no se muestran para las instancias.
- Añadida función **"Usar ruta relativa"** en la sección New Report Path.

### [25.31] — 2026/04/13
- Corregido un error que se producía al ejecutar la auditoría en proyectos con modelos vinculados anidados (vínculos dentro de vínculos). La verificación **RVT Links** ahora procesa correctamente todos los niveles de vínculos.

