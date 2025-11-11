# De Línea a Cable
{: .no_toc }

<details open markdown="block">
  <summary>
    Tabla de contenidos
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

El comando **De Línea a Cable** permite convertir rápidamente líneas de detalle ordinarias en cables eléctricos en un proyecto de Autodesk Revit. Analiza las líneas seleccionadas, encuentra dispositivos eléctricos cercanos (como luminarias, equipos y tomas de corriente), determina sus conectores y crea automáticamente los cables que los conectan.

![image](.\pic1.png)

## Cómo Usar

1.  Dibuja líneas de detalle en tu vista de Revit para representar la ruta de los cables eléctricos.
2.  Ejecuta el comando **De Línea a Cable** desde el panel de BIM Tools.
3.  El comando detectará automáticamente las líneas y los dispositivos eléctricos cercanos.
4.  Ajusta la configuración en la ventana de diálogo si es necesario.
5.  Haz clic en "Aceptar" para crear los cables. Las líneas originales se eliminarán por defecto.

## Características y Configuración

### Modos de Operación

-   **Eliminar líneas de entrada**: (Por defecto: Activado) Elimina las líneas de detalle originales después de crear los cables.
-   **División automática por dispositivos**: (Por defecto: Activado) Divide automáticamente una sola línea en múltiples segmentos de cable donde se cruza con dispositivos eléctricos. Esto te permite dibujar una línea continua a través de varios dispositivos.
-   **Modo de desplazamiento (Shift)**: (Por defecto: Desactivado) Si el punto final de una línea coincide exactamente con un conector de dispositivo, se desplazará 1 mm para evitar posibles errores.
-   **Modo silencioso**: (Por defecto: Desactivado) Si preseleccionas las líneas en el modelo antes de ejecutar el comando, se ejecutará inmediatamente utilizando la última configuración guardada, sin mostrar la ventana de diálogo.

### Configuración

-   **Umbral de búsqueda**: (Por defecto: 30 mm) El radio alrededor de las líneas y sus puntos finales dentro del cual el comando buscará dispositivos eléctricos para conectarse.
-   **Distancia máxima de división automática**: (Por defecto: 1000 mm) Una comprobación adicional para la distancia máxima desde una línea hasta el conector de un dispositivo, lo cual es particularmente útil para líneas diagonales.

### Mapeos

#### Mapeo de Estilo de Línea a Tipo de Cable

Puedes mapear estilos de línea específicos a los tipos de cable correspondientes. Si no se proporciona un mapeo, el comando intentará hacer coincidir el tipo de cable con el nombre del estilo de línea o usará el tipo de cable por defecto del proyecto.

**Formato:**
`NombreEstiloDeLinea: NombreTipoDeCable`

*Usa un punto y coma `;` al principio de una línea para comentarla.*

**Ejemplo:**
```
LINEA_DISCONTINUA: Cable-PVC-1.5
LINEA_SOLIDA: Cable-PVC-2.5
```

#### Mapeo de Conectores

Para familias de dispositivos con múltiples conectores, puedes especificar a qué índice de conector debe conectarse el cable.

**Formato:**
`NombreFamilia: NombreTipo: IndiceConector`

*El `IndiceConector` es un número entero basado en cero.*

**Ejemplo:**
```
EnchufeGenerico: Duplex: 0
LuminariaEspecifica: Modelo-A: 1
```
