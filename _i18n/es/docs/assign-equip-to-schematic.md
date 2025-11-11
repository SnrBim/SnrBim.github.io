# Asignar Equipo a Esquema
{: .no_toc }

<details open markdown="block">
  <summary>
    Tabla de contenidos
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

## Descripción General

Este comando permite asociar automáticamente un equipo MEP (familia) con uno o varios esquemas (anotaciones genéricas) dentro del modelo de Revit. Está diseñado para facilitar la documentación y el trazado de sistemas, enlazando elementos reales del modelo con sus representaciones esquemáticas.

![image](.\pic1.png)

## Funcionalidad Principal

Al ejecutar el comando con un equipo y un esquema seleccionados, se actualizan los siguientes parámetros en la anotación del esquema:

-   **`SRS_MEP_Equipment_Id`**: Contiene el ID, tipo y nombre del equipo.
    -   *Ejemplo: `123456 TipoDeFamilia: NombreDelEquipo`*

-   **`SRS_MEP_Link_Id`**: Indica el origen del equipo.
    -   Si proviene de un modelo vinculado, se muestra su nombre.
    -   Si pertenece al modelo actual, se indica como "modelo actual".

## Modo de Visualización de Estado

Si se ejecuta el comando **sin seleccionar ningún elemento**, se activa un modo de visualización gráfica en la vista activa. Este modo crea círculos de estado sobre los equipos visibles para indicar si están vinculados a un esquema 2D:

-   **Círculo Rojo**: El equipo no tiene un esquema 2D vinculado.
-   **Círculo Verde**: El equipo ya está vinculado a un esquema 2D.

Si se vuelve a ejecutar el comando sin selección, los círculos de estado se eliminarán (funciona como un interruptor).

## Pasos para Utilizar

### Asignación Estándar
1.  Selecciona un único equipo (familia) del modelo activo.
2.  Selecciona una o varias anotaciones que pertenezcan a la categoría `Generic Annotation`.
3.  Ejecuta el comando **Asignar Equipo a Esquema**.
4.  Una notificación confirmará la asignación.

### Asignación desde Archivos Vinculados
No es necesario seleccionar el equipo directamente dentro del archivo vinculado.
1.  Activa el **Modo de Visualización de Estado** para ver los círculos de colores.
2.  Selecciona el **círculo de estado** (rojo o verde) sobre el equipo que deseas vincular.
3.  Selecciona el símbolo en el esquema 2D correspondiente.
4.  Ejecuta el comando. El algoritmo detectará automáticamente el vínculo correcto entre ambos elementos.

## Requisitos y Validaciones

-   Para la asignación, solo se debe seleccionar **un** equipo (o su círculo de estado). Si se selecciona más de uno, el comando mostrará un error y se detendrá.
-   Las anotaciones deben ser de la categoría **Generic Annotations**.
