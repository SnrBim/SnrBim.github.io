# Cambiar Método de Pérdida
{: .no_toc }

<details open markdown="block">
  <summary>
    Tabla de contenidos
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

Este comando resuelve el problema de la asignación masiva de códigos ASHRAE a accesorios de sistemas de ingeniería en Revit.

## El Problema

La interfaz estándar de Revit tiene dos limitaciones significativas al trabajar con códigos ASHRAE:

1.  **Sin Procesamiento por Lotes:** Es imposible asignar códigos a múltiples elementos a la vez. Tienes que seleccionar cada accesorio individualmente y asignar el código manualmente.
2.  **Selección Compleja:** Para cada elemento, debes encontrar manually el código correcto en una larga lista basándote en sus parámetros (nombre, diámetro, ángulo, etc.), lo cual consume mucho tiempo y es propenso a errores.

![Ventana en dos variantes](pic1.gif)

## La Solución

Esta herramienta automatiza el proceso, permitiéndote asignar códigos ASHRAE a cientos de elementos a la vez basándose en una tabla pre-preparada en Excel.

### Cómo Funciona

1.  **Tabla de Búsqueda:** Creas una tabla en Excel donde se especifica el código ASHRAE correspondiente para cada tipo de accesorio (considerando su nombre, diámetro, ángulo y sistema).
2.  **Selección de Elementos:** Seleccionas todos los accesorios necesarios en Revit.
3.  **Asignación Automática:** El plugin lee los parámetros de cada elemento, encuentra el código correspondiente para él en tu tabla de Excel y lo asigna.
4.  **Informe:** Al finalizar, recibes un informe sobre a qué elementos se les aplicaron los códigos con éxito.

![Ejemplo de tabla](pic3.png)

![Ejemplo de informe](pic4.png)

