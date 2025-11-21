# Purge - Limpieza de Proyecto
{: .no_toc }

<details open markdown="block">
  <summary>
    Tabla de contenidos
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

La herramienta Purge está diseñada para limpiar un proyecto de elementos no utilizados, además del comando integrado Purgar No Utilizados.

## ¿Qué se puede eliminar?

La herramienta permite eliminar selectivamente los siguientes tipos de elementos:

*   **Vistas y Tablas sin Colocar en Planos**: Elimina vistas y tablas que no están colocadas en ningún plano del proyecto.
*   **Plantillas de Vista no Utilizadas**: Elimina plantillas de vista que no están aplicadas a ninguna vista.
*   **Filtros de Vista no Utilizados**: Elimina filtros que no se utilizan en las anulaciones gráficas de vistas.
*   **Estilos de Línea no Utilizados**: Elimina estilos de línea que no se utilizan en el proyecto.
*   **Estilos de Texto no Utilizados**: Elimina estilos de texto que no se utilizan en ninguna nota de texto o tabla.
*   **Duplicados de Materiales**: Encuentra y elimina materiales duplicados y activos de apariencia entre los elementos no utilizados. *(Disponible solo en Revit 2024 y posteriores)*

## Características Adicionales

*   **Lista de Ignorar Personalizable**: Puede especificar qué vistas o tablas deben ignorarse durante la limpieza para evitar que se eliminen. La lista de ignorar puede generarse automáticamente según la organización del navegador del proyecto.
*   **Repetición Automática**: La herramienta puede realizar múltiples pasadas de limpieza para garantizar resultados máximos, ya que eliminar algunos elementos puede hacer que otros queden sin usar.
*   **Ejecutar Purga Nativa de Revit**: La herramienta también puede ejecutar el comando integrado de Revit para purgar elementos no utilizados.
*   **Informe de Trabajo**: Después de completar la limpieza, se genera un informe de texto con la lista de todos los elementos eliminados.

![Window appearance](image.png)

## Uso

1.  Ejecute el comando "Purge" en Revit.
2.  En la ventana abierta, seleccione las categorías de elementos que desea eliminar marcando las casillas correspondientes.
    *   **Consejo**: Haga clic derecho en una casilla para seleccionar rápidamente solo esa categoría (todas las demás se deseleccionarán).
3.  Si es necesario, especifique una lista de ignorar en el cuadro de texto. Puede generar una lista predeterminada.
4.  Haga clic en el botón "Run" para iniciar el proceso de limpieza.
    *   Para operaciones con una gran cantidad de elementos (más de 1000), se mostrará una barra de progreso con opción de cancelación.
5.  Revise el informe de trabajo después de completar.

