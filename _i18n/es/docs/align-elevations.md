# Alineación de cotas de luminarias
{: .no_toc }

<details open markdown="block">
  <summary>
    Tabla de contenidos
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

## Propósito

La herramienta calcula automáticamente una cota media única para grupos de luminarias del mismo tipo dentro del mismo espacio y la escribe en el parámetro de instancia especificado. Esto elimina el valor **«Varios»** en los planillas generadas debido a pendientes estructurales en el modelo.

---

## Cuándo utilizarla

Utilice la herramienta antes de finalizar las planillas si observa lo siguiente:

- Un grupo de luminarias muestra «Varios» en el parámetro de cota dentro de una planilla.
- Las luminarias están montadas sobre una estructura inclinada o un forjado con cota variable.

---

## Interfaz

![Captura de pantalla](pic.png)

| Campo | Descripción | Valor predeterminado |
|---|---|---|
| **Source param** | Nombre del parámetro de instancia del que se lee la cota individual de cada luminaria (en mm). | `SRS_MEP_Lighting_Elevation` |
| **Target param** | Nombre del parámetro de instancia en el que se escribe el valor medio redondeado. | `SRS_MEP_Lighting_Elevation_Average` |
| **Rounding (mm)** | Paso de redondeo del resultado, en milímetros. | `50` |
| **Only selected spaces** | Si está marcado — solo se procesan las luminarias en los espacios seleccionados antes del lanzamiento. Si no está marcado — se procesan todas las luminarias del proyecto. | desmarcado |

---

## Modo de uso

### Modo proyecto completo

1. Desmarque **Only selected spaces** (o déjelo desmarcado por defecto).
2. Ajuste los nombres de parámetros y el paso de redondeo si es necesario.
3. Haga clic en **OK** (o pulse `Enter`).
4. Espere a que finalice la operación y revise el informe.

### Modo espacios seleccionados

1. **Antes de lanzar** el plugin, seleccione uno o más elementos **Space** (MEP Space) en el modelo.
2. Marque **Only selected spaces**.
3. Haga clic en **OK**.

> **Importante:** si la casilla está marcada pero no hay Spaces seleccionados, el plugin mostrará un error y no escribirá ningún valor.

---

## Algoritmo

1. Se recopilan todas las luminarias (`OST_LightingFixtures`) — para todo el proyecto o filtradas por los espacios seleccionados.
2. Se determina el espacio contenedor de cada luminaria usando la siguiente secuencia: atributo `Space` integrado, luego el punto de ubicación y dos puntos de sondeo adicionales — 1,5 m y 3 m por debajo. **Las luminarias sin espacio resuelto se omiten** y se contabilizan como "Skipped" en el informe.
3. El plugin detecta automáticamente el tipo de parámetro (**Length** o **Number**) y realiza las conversiones de unidades necesarias.
4. Las luminarias se agrupan por el par **Espacio + Tipo** (el nombre del espacio incluye su número y nombre).
5. Se calcula la media aritmética del valor del parámetro de origen dentro de cada grupo.
6. La media se redondea al múltiplo más cercano del paso de redondeo: `round(avg / step) * step`.
7. El valor redondeado se escribe en el parámetro objetivo de cada luminaria del grupo — incluidos los grupos de una sola luminaria y los grupos con rango cero.
8. Se muestra un informe.

---

## Informe

Al finalizar la operación aparece un cuadro de diálogo con información resumida.

**Instrucción principal** contiene:
- Número de grupos y luminarias procesados.
- Número de luminarias omitidas sin espacio.
- Número de grupos triviales (1 luminaria o rango < 1 mm) — se escriben pero no aparecen en los detalles.

**Área de contenido** muestra el grupo con el mayor rango y la ruta al archivo de informe completo.

**Desplegable "Show details"** contiene hasta 20 grupos ordenados por rango de forma descendente. **Solo incluye grupos con ≥ 2 luminarias y rango ≥ 1 mm**.

Formato de línea:
```
101 Corridor
  Luminaire Family: Type Name
  5 fixtures  |  avg = 2850 mm  |  range = 45 mm
```

| Campo | Valor |
|---|---|
| **avg** | Media redondeada escrita (mm) |
| **range** | Dispersión = Max − Min del parámetro de origen (mm) |

**Archivo CSV completo** se guarda en `%APPDATA%\Sener\BimTools\Reports\Align Lighting Elevations\`. El archivo contiene todos los grupos relevantes con columnas: `Space Number`, `Space Name`, `Family: Type`, `Count`, `Avg (mm)`, `Min (mm)`, `Max (mm)`, `Range (mm)`.

Los grupos con un `range` elevado requieren revisión: las luminarias pueden estar ubicadas a distintas cotas o el parámetro puede haberse rellenado incorrectamente.

---

## Configuración

Todos los valores introducidos se guardan automáticamente en `%APPDATA%\Sener\BimTools\Settings.json` y se restauran en el siguiente lanzamiento.

---

## Resolución de problemas

| Situación | Causa | Solución |
|---|---|---|
| El comando se ejecuta pero el parámetro objetivo no cambia | El `Target param` no existe o es de solo lectura | Verifique el nombre del parámetro y asegúrese de que sea un parámetro de instancia modificable |
| Mensaje "Please select at least one Space" | La casilla **Only selected spaces** está marcada pero no hay Spaces seleccionados | Seleccione elementos Space en el modelo antes de lanzar el plugin |
| El valor «range» en el informe es inesperadamente grande | El parámetro de origen se rellenó manualmente con errores, o las luminarias están realmente ubicadas a distintas cotas | Inspeccione el modelo y los valores del parámetro de origen |

