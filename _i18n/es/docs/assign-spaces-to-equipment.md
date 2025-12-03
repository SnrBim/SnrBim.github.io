# Assign spaces to equipment
{: .no_toc }

<details open markdown="block">
  <summary>
    Tabla de contenidos
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

## Breve descripción

La herramienta `Assign spaces to equipment` asigna automáticamente a los equipos mecánicos, accesorios de conducto y terminales de conducto la información del espacio MEP en el que se encuentran. Encuentra para cada elemento el espacio que lo contiene y escribe el nombre y el número de ese espacio en un parámetro del equipo.

## Cómo funciona

1.  **Recopilación de elementos**: La herramienta busca en el modelo todas las familias de las siguientes categorías:
    *   `Equipos mecánicos`
    *   `Accesorios de conducto`
    *   `Terminales de conducto`
    *   `Espacios MEP`

2.  **Búsqueda y vinculación**: Para cada elemento de las categorías monitorizadas, la herramienta determina su punto de inserción y busca el espacio MEP que contiene dicho punto.

3.  **Escritura de datos**: Si se encuentra un espacio, la herramienta crea una cadena de texto con el formato **"`<Nombre del espacio>-<Número del espacio>`"** y escribe este valor en el parámetro del equipo (cuyo nombre se puede configurar, consulte la sección "Configuración del nombre del parámetro"). Por defecto, es **`SRS_MEP_Room_Space_Mark`**.

    *Por ejemplo, si el espacio tiene el Nombre "Office" y el Número "101", en el parámetro se escribirá el valor "Office-101".*

4.  **Informe**: Al finalizar, la herramienta muestra un informe que indica:
    *   El número total de elementos encontrados.
    *   El número de elementos cuyo parámetro fue actualizado.
    *   El número de elementos cuyos datos ya estaban actualizados.
    *   El número de elementos vinculados con éxito.
    *   Una lista de errores y advertencias si no se pudo procesar algún elemento (por ejemplo, si un elemento no se encuentra en ningún espacio o si le falta el parámetro necesario).

## Configuración del nombre del parámetro

El nombre del parámetro donde se escribe la información del espacio es `SRS_MEP_Room_Space_Mark` por defecto. Puede cambiar este nombre editando el archivo de configuración del comando.

1.  **Localice el archivo de configuración**: El archivo `Settings.json` se encuentra en la siguiente ruta:
    `%APPDATA%\Sener\BimTools\Settings.json`

2.  **Abra el archivo**: Abra `Settings.json` con cualquier editor de texto (por ejemplo, Bloc de notas).

3.  **Cambie el valor**: Dentro del archivo, busque la sección relacionada con el comando `AssignSpacesToEquipment` y cambie el valor del parámetro `EquipmentSpaceParameter` al nombre deseado.

    Ejemplo:
    ```json
    {
      "SNR.BimTools.AssignSpacesToEquipment.Settings": {
        "EquipmentSpaceParameter": "Mi_Parametro_de_Espacio"
      }
    }
    ```
    Asegúrese de que el nuevo nombre del parámetro coincida exactamente con el nombre del parámetro en su proyecto de Revit.

4.  **Guarde el archivo**: Guarde los cambios en `Settings.json`. El comando utilizará el nuevo nombre del parámetro la próxima vez que se ejecute, **no es necesario reiniciar Revit**.

## Requisitos

*   Para un correcto funcionamiento, los elementos monitorizados deben tener un parámetro de texto con el nombre especificado en la configuración del comando (por defecto, es **`SRS_MEP_Room_Space_Mark`**).
*   El modelo debe contener `Espacios MEP` modelados correctamente.

## Uso

1.  Vaya a la pestaña **SENER**.
2.  En el panel de **BIM Tools**, haga clic en el botón **"Assign spaces to equipment"**.
3.  Espere a que aparezca la ventana con el informe de la operación.

La herramienta no requiere una selección previa de elementos y procesa todos los elementos compatibles en el proyecto.
