# Position Check
{: .no_toc }

<details open markdown="block">
  <summary>
    Tabla de contenidos
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

El comando rastrea cambios en posiciones y tamaños de equipos en espacios entre dos instantáneas del modelo, generando un informe detallado en Excel para determinar si es necesario recalcular la iluminación.

## Qué hace el comando

- Recopila todas las familias de equipos (tamaño > 100 mm) del proyecto actual y archivos vinculados
- Agrupa equipos por espacios (MEP Spaces)
- Compara el estado actual con el informe anterior (si se especifica)
- Determina tipos de cambios: elementos nuevos, eliminados, movidos, con tamaño cambiado
- Rastrea cambios en parámetros de espacios (área, perímetro)
- Genera informe Excel con dos hojas: resumen por espacios y detalle por elementos
- Muestra quién editó por última vez cada elemento

## Preparación

**Requisitos:**
- El proyecto debe contener MEP Spaces (espacios)
- Las familias de equipos deben tener dimensión máxima mayor de 100 mm
- Para rastrear cambios: informe anterior generado por este comando

**Recomendaciones:**
- Asegúrese de que todos los espacios estén colocados correctamente y tengan área
- Para la primera ejecución, no se requiere informe anterior: se creará una instantánea base

## Uso

1. Inicie el comando **Position Check** desde el panel BIMTools
2. En la ventana abierta, especifique las rutas de archivos:
   - **Previous Report**: ruta al informe Excel anterior *(opcional, déjelo vacío para la primera ejecución)*
   - **New Report Path**: ruta y nombre de archivo para el nuevo informe Excel *(obligatorio)*
3. Use los botones **Browse...** para seleccionar archivos mediante diálogo
4. Haga clic en el botón **Run** (o presione Enter)
5. Espere a que se complete el análisis: la barra de progreso mostrará el procesamiento de espacios
6. Después de completar, abra el archivo Excel generado

## Resultados

El comando crea un archivo Excel con dos hojas:

### Hoja "Summary" (Resumen)

Contiene información para cada espacio:

| Columna | Descripción | Ejemplo |
|---------|-------------|---------|
| **Space** | Nombre del espacio (enlace clicable a detalles) | "Office 101" |
| **Area (m²)** | Área del espacio en metros cuadrados | 42.5 |
| **Perimeter (m)** | Perímetro del espacio en metros | 26.3 |
| **Status** | Estado de cambios | "Equipment changed" |
| **Changed Count** | Número de elementos cambiados | 3 |
| **Sample Items** | Primeros 5 elementos cambiados | "Lamp_01, Lamp_02, Socket_03" |
| **Deltas** | Distancias de movimiento en metros | "0.5, 0.3, 1.2" |

**Estados de espacios:**
- `Unchanged` — sin cambios
- `Equipment changed` — equipos cambiados
- `Space changed` — parámetros del espacio cambiados
- `Space and equipment changed` — ambos cambiados

### Hoja "Detail" (Detalle)

Contiene información detallada para cada elemento:

| Columna | Descripción |
|---------|-------------|
| **Space** | Nombre del espacio (enlace clicable al resumen) |
| **Model** | Nombre del modelo (documento actual o archivo vinculado) |
| **Element Id** | Identificador del elemento en Revit |
| **Element Name** | Nombre del elemento |
| **Category** | Categoría del elemento |
| **Old X/Y/Z (m)** | Posición anterior en metros |
| **New X/Y/Z (m)** | Posición actual en metros |
| **Delta (m)** | Distancia de movimiento |
| **Old Size (m)** | Tamaño anterior (An × Al × Pr) |
| **New Size (m)** | Tamaño actual (An × Al × Pr) |
| **Status** | Tipo de cambio: New, Deleted, Moved, SizeChanged, Unchanged |
| **Last Changed By** | Nombre del último editor *(solo proyectos workshared)* |

**Ordenamiento:** Los elementos dentro de cada espacio están ordenados por distancia de movimiento (descendente).

**Navegación:** Todos los nombres de espacios son hipervínculos para navegación rápida entre hojas Summary y Detail.

## Características

**Umbral de detección de cambios:**
- El movimiento se detecta cuando el desplazamiento supera 50 mm (0.05 m)
- El cambio de tamaño se detecta cuando la diferencia supera 50 mm

**Tamaño de elementos:**
- Solo se rastrean elementos con dimensión máxima mayor de 100 mm
- No se incluyen elementos pequeños (sujetadores, herrajes)

**Identificación única:**
- Cada elemento se identifica por combinación de nombre de modelo y Element ID
- Esto permite rastrear correctamente elementos de diferentes archivos vinculados

## Limitaciones conocidas

- El comando rastrea solo elementos con punto de inserción (`LocationPoint`), no se incluyen elementos lineales (`LocationCurve`)
- Los elementos fuera de espacios no se incluyen en el informe
- Para obtener información del último editor, el proyecto debe ser workshared
- En la primera ejecución (sin informe anterior), todos los elementos se marcarán como `New`
- La recopilación de espacios de modelos vinculados está deshabilitada (se puede habilitar si es necesario)

