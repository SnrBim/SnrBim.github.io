# Sincronizar Equipo con Esquema
{: .no_toc }

<details open markdown="block">
  <summary>
    Tabla de contenidos
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

## Descripción

Este comando actualiza automáticamente los datos de las anotaciones esquemáticas (Generic Annotation) en Revit, basándose en el ID de equipo previamente asignado.

![image](.\pic1.png)

## Funcionalidad

Para cada anotación de esquema procesada, el comando realiza las siguientes acciones:

1.  Busca el equipo correspondiente utilizando los valores de los parámetros `SRS_MEP_Equipment_Id` y `SRS_MEP_Link_Id`.
2.  Una vez encontrado el equipo, determina el espacio (MEP Space) y el nivel en el que este se encuentra.
3.  Actualiza los siguientes parámetros en la anotación:
    -   **`SRS_MEP_Location`**: Se actualiza con el nombre del espacio.
    -   **`SRS_MEP_RoomID`**: Se actualiza con el ID del espacio.
    -   **`SRS_MEP_Level`**: Se actualiza con el nombre del nivel.

## Pasos para Usar

1.  Asegúrate de que las anotaciones de esquema que deseas actualizar ya tienen asignados los valores en los parámetros `SRS_MEP_Equipment_Id` y `SRS_MEP_Link_Id`.
2.  Ejecuta el comando **Sync equip to schematic**.
3.  El sistema recorrerá las anotaciones y actualizará automáticamente los datos de ubicación en cada una.

## Notas Importantes

-   Se mostrará una advertencia en caso de que no se encuentre un equipo correspondiente al ID especificado en una anotación.
-   El valor del ID de equipo debe ser numérico para que el proceso funcione correctamente.
-   La búsqueda de espacios está optimizada; el comando prioriza la reutilización de espacios ya encontrados para mejorar el rendimiento.

