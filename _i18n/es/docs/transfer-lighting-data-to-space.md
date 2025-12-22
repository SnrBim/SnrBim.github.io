# Transferir Datos de Iluminación a Espacios
{: .no_toc }

<details open markdown="block">
  <summary>
    Tabla de contenidos
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

Esta herramienta transfiere los resultados del análisis de iluminación desde un elemento de **Modelo Genérico** al **Espacio** en el que se encuentra.

## ¿Qué hace el comando?
- Identifica el **Espacio** que contiene el **Modelo Genérico** seleccionado.
- Copia los valores de los parámetros del elemento de origen al **Espacio** de destino.
- Utiliza un mapeo configurable para hacer coincidir los parámetros de origen y destino.
- Procesa múltiples elementos en una sola operación.

## Cómo usar
1.  **Seleccionar Elementos**: En su modelo de Revit, seleccione uno o más elementos de **Modelo Genérico** que contengan los resultados del cálculo de iluminación. Estos elementos suelen ser formas volumétricas utilizadas para el análisis en software como ElumTools.
2.  **Ejecutar el Comando**: Vaya a la pestaña **SNR** y haga clic en el botón **Transfer Light Data**.
3.  **Verificar los Resultados**: La herramienta encontrará automáticamente el **Espacio** principal para cada elemento seleccionado y transferirá los valores de los parámetros según el mapeo configurado.

## Notificaciones e Informes
Al finalizar el comando, aparecerá un cuadro de diálogo con un resumen de los resultados:
-   El número de elementos procesados con éxito.
-   El número de elementos que se omitieron (por ejemplo, si no se pudo encontrar un espacio contenedor).
-   Advertencias si surgieron problemas durante el proceso (por ejemplo, un parámetro no se encontró o es de solo lectura).

## Mapeo de Parámetros
El mapeo entre los parámetros del **Modelo Genérico** de origen y los parámetros del **Espacio** de destino es configurable. Esto le permite adaptar la herramienta a diferentes plantillas de proyecto o estándares de nomenclatura de parámetros.

El archivo de configuración se encuentra en:
`%AppData%\Sener\BimTools\Settings.json`

Dentro de este archivo, busque la sección `SNR.BimTools.TransferLightingDataToSpace.Settings`.

**Ejemplo de Mapeo por Defecto:**
```json
{
  "SNR.BimTools.TransferLightingDataToSpace.Settings": {
    "ParameterMapping": {
      "Emergency Direct Illuminance Average": "Illum em average",
      "Emergency Direct Illuminance Minimum": "Illum em minimum",
      "General Use Illuminance Average": "Illum average",
      "General Use Illuminance Minimum": "Illum minimum",
      "General Use Illuminance Maximum": "Illum maximum",
      "General Use Illuminance Minimum To Average": "Illum minimum to average",
      "General Use Illuminance Minimum To Maximum": "Illum minimum to maximum"
    }
  }
}
```
Puede editar este archivo para agregar, eliminar o cambiar los pares "parámetro de origen": "parámetro de destino".

