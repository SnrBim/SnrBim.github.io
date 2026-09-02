# Equilibrado de fases (Balance Panels)
{: .no_toc }

<details open markdown="block">
  <summary>
    Tabla de contenidos
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

Esta herramienta está diseñada para analizar la jerarquía de cuadros y redistribuir automáticamente los circuitos para minimizar el desequilibrio de cargas entre fases.

## Características principales

1.  **Mapa interactivo de cuadros:** Visualización de toda la red eléctrica del proyecto en forma de grafo. Admite dos modos:
    *   **Hierarchical (Jerárquico):** el clásico árbol de potencia de "arriba hacia abajo".
    *   **Organic (Orgánico):** un modelo basado en física, útil para encontrar grupos aislados или trabajar con redes muy grandes.
2.  **Diagnóstico de desequilibrio:** El color de los cuadros cambia según el porcentaje de desequilibrio de fases.
3.  **Indicador de potencial:** El brillo de los nodos (círculos) muestra cuánto se puede mejorar realmente el equilibrio en un cuadro específico. Si el círculo es tenue, el equilibrio es cercano al ideal para ese conjunto de circuitos.
4.  **Equilibrado inteligente:** El algoritmo prueba combinaciones de circuitos (1P, 2P, 3P) para lograr el desequilibrio teórico mínimo.

![UI](image.png)

## Indicación por colores

Los colores de los nodos dependen de los umbrales (**Thresholds**) configurados en la parte superior izquierda de la ventana:

*   **Zona Verde:** El equilibrio está dentro de los límites normales (por defecto <5%).
*   **Zona Amarilla:** Desequilibrio medio.
*   **Zona Roja:** Desequilibrio alto, requiere corrección.
*   **Borde Negro:** El cuadro tiene un alto potencial de mejora (el equilibrio teórico es significativamente mejor que el actual).
*   **Borde Blanco/Gris:** El equilibrio ya es cercano al máximo posible para el conjunto actual de cargas.

## Instrucciones de uso

1.  **Inicio:** Haz clic en el botón **Balance Panels** en el panel de Sener.
2.  **Análisis:** Examina el árbol de cuadros. Usa el cuadro de búsqueda (arriba) para encontrar rápidamente un cuadro específico.
3.  **Selección:** Selecciona uno o varios cuadros en el grafo.
4.  **Ajustes de vista:** Puedes cambiar el modo **Hierarchical**, el **Level Separation** (separación de niveles) y el **Node Spacing** (espaciado de nodos). Estos cambios se aplican solo después de pulsar el botón **Redraw** (Redibujar).
5.  **Equilibrado:** Haz clic en el botón **Balance**. La herramienta intentará mover automáticamente los huecos (slots) en la tabla de planificación del cuadro.
6.  **Resultado:** Al finalizar, recibirás un informe con las métricas de desequilibrio "Antes" y "Después".
7.  **Modos de visualización:** Usa la casilla **Hierarchical** en los ajustes. Cuando está activada, el grafo crea una estructura de árbol clara desde la fuente hacia los consumidores. Cuando está desactivada, el grafo entra en modo "telaraña" (orgánico), donde los nodos se colocan más libremente, lo cual es útil para una visión general de sistemas complejos.

## Solución de problemas (Workflow)

En algunos casos, la API de Revit no permite que el programa mueva automáticamente circuitos multifásicos (2P, 3P) debido a limitaciones del sistema. Si ocurre un error durante el equilibrado:

1.  Selecciona el cuadro problemático en la ventana de la herramienta.
2.  Haz clic en el botón **Open Panel Schedule View** (icono de tabla).
3.  En la vista estándar de tabla de planificación de Revit que se abre, ejecuta el comando nativo **Rebalance loads**.

Actualmente (debido a las limitaciones técnicas con los cuadros multifásicos), la herramienta sirve como un "navegador", ayudándote a concentrarte solo en los cuadros que realmente requieren atención y pueden ser mejorados.

