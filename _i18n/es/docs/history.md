# Historial de vistas
{: .no_toc }

<details open markdown="block">
  <summary>
    Tabla de contenidos
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

La herramienta **View History** guarda las vistas de Revit visitadas recientemente y permite volver rápidamente a ellas. El historial se conserva entre sesiones de Revit y se muestra en el panel **History** de la pestaña **SNR**.

> **Ubicación temporal:** Esta página utiliza actualmente la entrada legacy History en la estructura de documentación. La función descrita aquí es el nuevo View History y esta página debe trasladarse a una entrada de documentación independiente.
{: .warning }

![Panel de la cinta](ribbon.png)

## Para qué sirve el historial de vistas

Es fácil perder el contexto de trabajo en Revit: un proyecto puede tener abiertas decenas de plantas, secciones, vistas 3D y planos, y durante el trabajo es necesario cambiar constantemente entre ellas. Después de cambiar de vista, no siempre es fácil encontrar la vista necesaria entre las pestañas o en el Navegador de proyectos.

El historial de vistas reduce este problema:

- muestra qué vistas se han utilizado recientemente, independientemente del orden en que se abrieron originalmente;
- permite volver a una vista con un clic, sin buscarla en la estructura del proyecto;
- ayuda a cambiar rápidamente entre la vista actual y la anterior con el botón Prev o `Ctrl+Tab`;
- conserva el contexto entre sesiones de Revit: después de volver a abrir un proyecto, puede seleccionar la vista necesaria desde el historial sin buscarla en el Navegador de proyectos;
- ayuda a distinguir las vistas de distintos documentos abiertos mediante etiquetas y nombres, sin cambiar de ventana ni recordar dónde estaba la vista necesaria;
- permite sustituir los nombres largos y difíciles de leer de proyectos y vistas por nombres cortos y claros mediante alias;
- permite marcar las vistas importantes como favoritas para que no se pierdan entre cambios menos relevantes.

## Activar el registro del historial

El registro del historial está desactivado de forma predeterminada. Se activa en **Info > Extra**. Después de activarlo, el panel **History** se añade a la cinta y comienza a formarse una lista de las vistas visitadas recientemente.

## Trabajar con la lista de vistas

Abra **View history** para ver las vistas visitadas recientemente. El contenido y el orden de la información mostrada se configuran en **Settings -> View history display**.

![Lista del historial de vistas en la cinta](combobox.png)

Seleccione una entrada para activar la vista correspondiente. Si mantiene pulsada una tecla modificadora al seleccionarla (Ctrl, Shift, Alt o Win), la herramienta cierra las demás vistas de Revit.

La lista puede contener espacios vacíos. Esto se debe a las limitaciones de la interfaz Ribbon de Revit y no indica un error en el historial.

## Navegación entre vistas

El panel **History** ofrece estos comandos:

- **Prev**: cambia a la vista anterior, alternando entre dos vistas;
- **Back**: retrocede por el historial de navegación de la sesión actual;
- **Forward**: avanza después de retroceder.

Cuando está activada la opción **Use view history for Ctrl+Tab navigation** (activada de forma predeterminada), están disponibles estos atajos de teclado:

- `Ctrl+Tab`: vista anterior;
- `Ctrl+Shift+Tab`: avanzar;
- pulsar `Tab` de nuevo mientras se mantiene `Ctrl`: retroceder por el historial.

## Configuración de la visualización

Para abrir la configuración, seleccione **Open settings...** en la lista desplegable del historial.

En la sección **View history display** puede configurar:

- mostrar los números de las posiciones;
- mostrar la hora de la última visita;
- mostrar la actividad total o la actividad de sesiones anteriores;
- mostrar la actividad de la sesión actual;
- marcar las visitas breves;
- excluir las visitas más cortas que la duración indicada;
- marcar las vistas con mucha actividad;
- mostrar la etiqueta del proyecto;
- mostrar el nombre del proyecto;
- ocultar la información del proyecto cuando solo hay un documento abierto.

La etiqueta del proyecto se calcula automáticamente y muestra cuánto tiempo ha pasado desde la última visita al proyecto. El documento activo recibe el índice `0`, mientras que los demás documentos abiertos se numeran según la hora de su última visita: `1`, `2`, `3`, etc. La letra `P` representa un proyecto y `F` representa una familia. Por ejemplo, `P0` es el proyecto activo, `P1` es el proyecto anterior y `F2` es una familia visitada antes que `P1`.

El umbral de duración se indica como una cadena con una unidad de tiempo, por ejemplo `5s`, `30m` o `2h`.

![Ventana de configuración del historial de vistas](settings.png)

El nombre de una vista no siempre permite entender su importancia para el trabajo actual: los nombres pueden ser largos, parecidos entre sí o no indicar con qué frecuencia se utiliza la vista. Por eso, el historial muestra estadísticas adicionales: la hora de la última visita, el tiempo total de trabajo con la vista y la actividad de la sesión actual. Estos datos facilitan distinguir una vista de trabajo a la que se vuelve regularmente de una vista abierta por casualidad o durante poco tiempo.

De forma predeterminada, la lista de vistas contiene la cantidad mínima de información para que sea más fácil de entender al comenzar a trabajar. Los usuarios experimentados pueden activar opciones de visualización adicionales según sus necesidades y el contexto de trabajo.

![Esquema de configuración](image.png)

## Ámbito y filtros del historial

En la sección **History scope and filtering** están disponibles estos parámetros:

- el período durante el que se muestran las vistas visitadas;
- el número máximo de entradas de la lista;
- mostrar únicamente las vistas favoritas;
- mostrar únicamente la última vista de cada documento en segundo plano;
- limitar el número de documentos en segundo plano;
- mostrar únicamente las vistas del documento activo;
- utilizar el historial para la navegación `Ctrl+Tab` (esto sustituye el comportamiento nativo de Revit, en el que el orden de cambio depende del orden en que se abrieron las vistas y no de las visitas).

Los filtros solo afectan a la lista mostrada. No eliminan entradas del archivo de historial.

## Vistas favoritas

Para marcar la vista actual como favorita, active **Favorite current view** en la ventana de configuración. Las vistas favoritas no son desplazadas por las vistas normales cuando se limita el número de entradas y ocupan las posiciones disponibles antes que ellas. También es posible mantener una vista favorita en la lista al activar el filtro **Only favorites**.

## Alias de documentos y vistas

En **Aliases for docs and views** puede definir nombres personalizados para documentos y vistas. Cada línea define un alias con este formato:

```text
ALIAS nombre_mostrado
```

El alias es la primera palabra de la línea. El primer espacio separa el alias del nombre completo del documento o de la vista, por lo que el alias no puede contener espacios. El nombre del documento o de la vista sí puede contenerlos. Por ejemplo:

```text
MyView Original Long View Name
```

Aquí, `MyView` es el alias y `Original Long View Name` es el nombre de la vista. Si escribe `My View Original Long View Name`, el alias se reconoce como `My` y el nombre de la vista como `View Original Long View Name`.

Las líneas que empiezan por `;` se consideran comentarios y no se procesan.

El menú `...` de la esquina del campo permite:

- añadir un alias para el documento activo;
- añadir un alias para la vista activa;
- ordenar las líneas por el nombre del alias;
- ordenar las líneas por el nombre del documento o de la vista.

Los alias se conservan al restablecer el resto de la configuración.

## Gestionar el historial

En la ventana de configuración están disponibles estos comandos:

- **Reset settings to default (except aliases)**: restablecer la configuración conservando los alias;
- **Clear active doc history**: eliminar el historial del documento activo;
- **Clear other docs history**: eliminar el historial de todos los documentos excepto el activo, incluidos los documentos cerrados cuyas entradas estén guardadas en el registro;
- **Show history file**: abrir la carpeta que contiene el archivo de historial;
- **Reload history**: volver a leer el historial desde el disco.

El historial se guarda en el archivo:

```text
%APPDATA%\Sener\BimTools\ViewHistory.json
```

Al alcanzar el límite de tamaño, el archivo antiguo se mueve automáticamente a un archivo de respaldo.

Pulse **Save** para aplicar los cambios. **Cancel** cierra la ventana sin aplicar los cambios.

## Rendimiento y estabilidad

El historial registra los cambios de vista y realiza un procesamiento adicional cuando cambian. En condiciones normales no debería notarse, pero la función puede afectar a la velocidad de cambio o a la estabilidad de Revit si se producen errores.

Durante los primeros meses, se recomienda observar el funcionamiento de Revit después de activar el registro del historial. Informe al desarrollador sobre problemas de rendimiento, retrasos o inestabilidad e indique la versión de Revit y la secuencia de acciones después de la cual apareció el problema.

El registro del historial está desactivado de forma predeterminada. Durante el futuro próximo, la función se distribuirá desactivada para que los usuarios puedan activarla conscientemente y comprobar el funcionamiento de Revit en su entorno de trabajo.

