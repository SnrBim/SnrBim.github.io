# Crear y actualizar soportes
{: .no_toc }

<details open markdown="block">
  <summary>
    Tabla de contenidos
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

El comando **Create hangers** coloca soportes para tuberías, conductos y bandejas portacables, y actualiza los soportes existentes.

### Ejemplos de colocación de soportes

<div class="image-compare-gallery">
	<a class="image-compare" href="11.png" src="12.png"><img src="11.png" width="240" loading="lazy" alt="1. Conductos circulares de distintos tamaños y cantidades"></a>
	<a class="image-compare" href="21.png" src="22.png"><img src="21.png" width="240" loading="lazy" alt="2. Conductos circulares de distintos tamaños y cantidades (se selecciona el más largo)"></a>
	<a class="image-compare" href="31.png" src="32.png"><img src="31.png" width="240" loading="lazy" alt="3. Conductos rectangulares de distintos tamaños"></a>
	<a class="image-compare" href="41.png" src="42.png"><img src="41.png" width="240" loading="lazy" alt="4. Diferentes formas agrupadas"></a>
	<a class="image-compare" href="51.png" src="52.png"><img src="51.png" width="240" loading="lazy" alt="5. Soportes de tuberías fijados a paredes"></a>
	<a class="image-compare" href="61.png" src="62.png"><img src="61.png" width="240" loading="lazy" alt="6. Búsqueda automática de techos y vigas"></a>
	<a class="image-compare" href="71.png" src="72.png"><img src="71.png" width="240" loading="lazy" alt="7. Detección de interferencias"></a>
</div>

**Proyecto de demostración con familias:** [descargar Demo23.rvt](https://github.com/SnrBim/BimTools/releases/download/v26.20/Demo23.rvt).

## Crear soportes

### 1. Prepare la vista y seleccione las instalaciones

Abra una vista 3D y seleccione las instalaciones que necesitan soportes. A continuación, ejecute **Create hangers**. Puede seleccionar elementos del modelo anfitrión y elementos individuales de vínculos de Revit cargados.

Para limitar la colocación de soportes a una zona, configure la **Section Box** antes de ejecutar el comando. Los puntos de colocación se distribuyen a lo largo del tramo de cada instalación que queda dentro del recorte.

### 2. Configure la distribución

Defina la separación y los desplazamientos en milímetros:

- **Max distance between points** — separación máxima entre los puntos de colocación de los soportes.
- **Distribute evenly** — coloca los soportes a intervalos iguales sin superar la separación máxima. Si esta opción está desactivada, los soportes se colocan con la separación indicada y el intervalo restante en uno de los extremos es más corto.
- **Offset from duct ends** — distancia desde los extremos de la instalación.

### 3. Defina la fijación superior

Los siguientes ajustes de **Distribution settings** determinan la superficie o la cota hasta la que llegan las varillas de un soporte de techo.

**Cota especificada.** Introduzca **Ceiling elevation** en milímetros. Sin **From element**, se utiliza una cota absoluta en las coordenadas del modelo. Con **From element**, el valor es un desplazamiento respecto a la cota de referencia de la instalación: los valores positivos van hacia arriba y los negativos, hacia abajo.

**Búsqueda de estructura.** Active **Search for ceiling within** e indique una distancia positiva de búsqueda hacia arriba, en milímetros. El comando busca la superficie más cercana de un forjado, cubierta o viga en el modelo anfitrión y en los vínculos cargados, incluidos los elementos ocultos en la vista. La búsqueda se realiza por separado para las varillas izquierda y derecha. Si no se encuentra ninguna superficie, se utiliza **Ceiling elevation** aplicando **From element**; por ello, indique esta cota también cuando la búsqueda esté activada.

**Cara seleccionada.** Pulse **Select face** y seleccione una cara de un elemento del modelo anfitrión o de un vínculo cargado hasta la que deban llegar las varillas.

Una cara plana se trata como un plano infinito, por lo que la fijación puede calcularse más allá de sus límites. No se admiten caras planas verticales. Para las caras curvas se tienen en cuenta sus límites reales.

### 4. Configure el análisis de interferencias

**Analyze clashes** comprueba si los soportes intersectan las instalaciones y asigna tipos de advertencia a los soportes problemáticos. La comprobación incluye el modelo anfitrión y los vínculos cargados, así como las instalaciones y el aislamiento ocultos.

Cuando se detecta una intersección, el comando asigna al soporte un tipo de advertencia:

- **warning red** — la varilla de un soporte principal o un elemento de fijación circular independiente intersecta una instalación.
- **warning orange** — el perfil horizontal superior de un conjunto multinivel intersecta una instalación.

Al crear soportes, no se comprueban el perfil inferior ni los elementos de fijación circulares dentro de un conjunto compartido. Por tanto, la ausencia de advertencias no significa que todo el conjunto esté libre de interferencias. La comprobación de las varillas no tiene en cuenta su grosor y la de los perfiles se basa en la altura de las instalaciones.

Los ID de los elementos que intersectan se añaden a los comentarios del soporte. Antes de los ID de los elementos se indica el ID de la instancia del vínculo; `0` identifica el modelo anfitrión. Utilice estos ID para localizar los elementos problemáticos. Para mostrar las advertencias correspondientes, la familia debe incluir tipos cuyo nombre contenga **warning red** y **warning orange**.

### 5. Elija las opciones de montaje

- **Ceiling** — soporte fijado al techo.
- **Wall** — soporte fijado a la pared para tuberías y conductos circulares.
- **Auto** — selecciona automáticamente el montaje en pared o techo según la dirección de la instalación y la posición de las paredes cercanas.

>Para instalaciones inclinadas al menos 15° respecto a la horizontal, se selecciona el montaje en pared. Si no se encuentra una pared, el soporte se crea igualmente con una distancia de reserva respecto a ella.  
>Para instalaciones horizontales o con menor inclinación, solo se selecciona el montaje en pared si se encuentra cerca una pared paralela al trazado en planta, con una desviación máxima de 5°. La distancia permitida entre el eje de la instalación y la pared es de 1000 mm más la mitad de la dimensión exterior mayor de su sección. Si no se encuentra una pared adecuada, se selecciona el montaje en techo.  
>La pared se comprueba cerca del punto medio del tramo visible de la instalación. Si hay una **Section Box** activa, se utiliza el punto medio del tramo dentro del recorte; el método de montaje seleccionado se aplica a todo el elemento.

**Limit wall search to the active 3D view** limita la búsqueda de paredes a la vista activa para que las paredes ocultas no afecten a la selección del montaje en pared. Si esta opción está desactivada, también se tienen en cuenta las paredes que no están visibles en la vista activa. Este ajuste no afecta a la búsqueda de estructura situada sobre un soporte de techo.

### 6. Elija la agrupación de soportes

Seleccione **Individual hangers (no grouping)** para crear soportes separados para cada elemento seleccionado. Las instalaciones cercanas no se incluyen en un soporte compartido.

Seleccione **Group selected elements (nearby and parallel only)** si los soportes compartidos deben sostener únicamente las instalaciones seleccionadas previamente. Los elementos seleccionados deben ser paralelos y estar próximos entre sí (< 3 m).

En este modo, los soportes se distribuyen a lo largo del tramo visible más corto de las instalaciones seleccionadas. Si una instalación termina antes que las demás, deja de incluirse en el soporte compartido después de su extremo. No se tienen en cuenta las instalaciones vecinas que no se hayan seleccionado.

Seleccione **Group by nearby search** para incluir automáticamente instalaciones cercanas en los soportes compartidos. Las posiciones de los soportes se determinan a partir de los elementos seleccionados y se buscan instalaciones vecinas cerca de cada punto de colocación. Si no se encuentran instalaciones adecuadas, se crea un soporte independiente. Las instalaciones sostenidas pueden variar de un soporte a otro.

Para **Group by nearby search**, defina la zona de búsqueda en milímetros:

- **X (along)** — a lo largo de la instalación.
- **Y** — en sentido transversal a la instalación.
- **Z** — en vertical.

Los campos X/Y/Z solo se utilizan con **Group by nearby search**.

### 7. Cree los soportes

Pulse **Create**. Compruebe la posición de los soportes y su fijación a la estructura. En los soportes compartidos, compruebe qué instalaciones incluyen. Si aparecen tipos de advertencia, utilice los ID de los comentarios del soporte para localizar los elementos que intersectan.

![alt text](ui.png)

## Actualizar los soportes existentes

### 1. Seleccione los soportes

En una vista 3D, seleccione los soportes existentes de la categoría **Structural Connections** y, a continuación, abra **Create hangers**.

Al actualizar las dimensiones y la posición, la selección determina qué instalaciones se utilizan para recalcular los soportes:

- **Solo soportes:** se busca la instalación adecuada más cercana a cada soporte dentro de la zona de búsqueda.
- **Soportes e instalaciones:** las dimensiones y la posición se calculan a partir del grupo seleccionado, sin buscar instalaciones vecinas. Las opciones de **Hanger grouping** no afectan a la composición de este grupo.

### 2. Configure las fijaciones y el análisis de interferencias

Para cambiar la fijación superior, defina la cota, la búsqueda de estructura o la cara seleccionada en **Distribution settings**, como al crear soportes. Al actualizar con **From element**, el desplazamiento se mide desde la posición del soporte después de recalcular sus dimensiones y posición, si se ha activado esa actualización.

**Analyze clashes** vuelve a comprobar los soportes seleccionados y actualiza sus advertencias. Si ya no hay interferencias, al soporte se le asigna su tipo normal. El resto del texto de los comentarios se conserva. Desactive el análisis si desea cambiar la geometría o la fijación sin volver a comprobar los tipos de advertencia ni los registros de interferencias existentes.

A diferencia de la creación, durante la actualización se comprueban los perfiles horizontales de todos los soportes rectangulares seleccionados, incluidos los inferiores. Si se detecta una intersección tanto de una varilla como de un perfil, se asigna **warning red**.

### 3. Elija qué actualizar — Create vs Update

- **Update dimensions and position** — recalcula las dimensiones y la posición a partir de las instalaciones.
- **Update upper attachment** — recalcula la fijación superior con los nuevos ajustes de cota, búsqueda de estructura o cara seleccionada.

Las dimensiones y la fijación superior se pueden actualizar por separado o conjuntamente.

### 4. Ejecute la actualización

Pulse **Update**. Los soportes seleccionados se modifican sin volver a crearlos; no se añaden soportes nuevos para niveles adicionales. Compruebe las dimensiones, la posición y la fijación superior, y revise las advertencias restantes si el análisis de interferencias está activado.

