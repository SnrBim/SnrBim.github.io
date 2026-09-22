# Find empty parameters
{: .no_toc }

<details open markdown="block">
  <summary>
    Tabla de contenidos
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

El comando **Find empty parameters** comprueba si los parámetros especificados están rellenados en el modelo actual de Revit y en los vínculos cargados, y genera un informe resumido en Excel.

## Qué hace el comando

- Procesa el modelo actual y los vínculos cargados disponibles.
- Comprueba únicamente las categorías de Revit seleccionadas.
- Comprueba los parámetros de las instancias y de sus tipos.
- Considera problemática una instancia si al menos uno de los parámetros comprobados está vacío.
- Genera un informe resumido con información agrupada por categoría, familia y tipo, sin una descripción independiente de cada elemento.
- Muestra el progreso del proceso y permite cancelar la comprobación.

## Uso

Introduzca los nombres de los parámetros que desea comprobar en el campo **Parameters to check**, uno por línea, y pulse **OK** o `Enter`.

Las líneas vacías se eliminan y los nombres duplicados se combinan sin distinguir mayúsculas de minúsculas. La lista de parámetros se guarda para la próxima ejecución.

Para cerrar la ventana sin iniciar la comprobación, pulse **Cancel** o `Esc`.

![Interfaz de usuario](ui1.png)

El botón **Categories (X/Y)** abre la lista de categorías que se comprobarán. `X` es el número de categorías reconocidas y `Y` es el número total de categorías introducidas. Las categorías desconocidas se omiten durante la comprobación. Sus nombres se muestran después de pulsar **OK** en la ventana de categorías.

![Categorías](ui2.png)

## Reglas de comprobación

Un parámetro se considera vacío si no existe, no tiene valor o contiene únicamente espacios en blanco.

Se comprueban los parámetros de los elementos y de sus tipos. Un elemento se considera problemático si al menos uno de los parámetros comprobados está vacío.

La columna `IsByType` indica el origen del valor vacío:

- `0` significa que el parámetro vacío se encontró en la instancia;
- `1` significa que el parámetro vacío se encontró en el tipo;
- un valor vacío significa que se encontraron parámetros vacíos en ambos orígenes para una misma instancia.

## Informe de Excel

El archivo de Excel se crea en la carpeta estándar de informes de BIMTools: `%appdata%\Sener\BimTools\Reports\EmptyParams\`.

El informe contiene una hoja `Empty parameters` con información resumida:

| Columna | Contenido |
| --- | --- |
| `Model` | Nombre corto del modelo sin la extensión `.rvt` |
| `Category` | Categoría de los elementos |
| `Total` | Número total de instancias de la categoría |
| `Problematic` | Número de instancias problemáticas |
| `IsByType` | Origen del valor vacío: `0`, `1` o vacío |
| `Family` | Familia y tipo de los elementos problemáticos |
| `Instance ID` | IDs de las instancias problemáticas |

## Proceso y cancelación

Si se cancela la comprobación, los datos procesados hasta ese momento se guardan en un informe parcial.

## Resultado

Después de crear el informe, la ventana de resultados permite abrirlo o copiar su ruta al portapapeles. También muestra:

- el número de archivos procesados y el número total de archivos;
- el número de categorías con problemas;
- el número de elementos problemáticos de cada modelo.

