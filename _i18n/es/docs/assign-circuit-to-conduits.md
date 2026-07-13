# Asignar Circuito a Conductos
{: .no_toc }

<details open markdown="block">
  <summary>
    Tabla de contenidos
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

Esta herramienta está diseñada para agregar información del circuito a las propiedades de los conductos eléctricos (Conduit). El usuario selecciona un circuito y los conductos correspondientes, y el algoritmo actualiza automáticamente sus parámetros, agregando la información del circuito en el parámetro `SRS_MEP_Circuit_Names`.

Antes de esto, si el nombre del circuito está vacío, el algoritmo lo genera automáticamente a partir de los valores del parámetro `SRS_Schedule_Name` de la carga y el cuadro eléctrico. Esta herramienta se utiliza para la posterior ejecución de **SyncConduitCircuit**.

## Datos Requeridos

Antes de ejecutar el comando, asegúrese de que la carga, el cuadro eléctrico y las cajas de distribución intermedias tengan nombres en el parámetro `SRS_Schedule_Name`. De lo contrario, se utilizarán sus identificadores.

## Instrucciones de Uso

1.  **Seleccionar los elementos:**
    -   Seleccione una familia de carga asociada a un circuito.
    -   Si la carga pertenece a varios circuitos, seleccione el circuito deseado usando la tecla **Tab**.
    -   Seleccione uno o varios conductos eléctricos (Conduit).

2.  **Ejecutar la herramienta:**
    -   Al iniciar, el algoritmo verificará automáticamente si la selección es válida.
    -   Si se seleccionan varios circuitos, aparecerá un mensaje de error. Si no se seleccionan conductos, se activará el **modo auxiliar**: el complemento identificará los conductos pertenecientes al circuito y la ejecución se detendrá.

3.  **Asignación automática del nombre del circuito:**
    -   El nombre del circuito se recalcula automáticamente con base en las ubicaciones y los parámetros `SRS_Schedule_Name` de la carga y el cuadro eléctrico. Si las ubicaciones del cuadro y la carga difieren, se especifican ambas (`Loc1-Cuadro/Loc2-Carga-Tag`); si son iguales, el prefijo se escribe una sola vez.
    -   La siguiente tabla detalla cómo se agrupan los nombres de las cargas para generar el nombre del segmento:

| Datos de entrada | Nombre resultante del Carga | Comentario |
| :--- | :--- | :--- |
| `18D-DS-SF01` | `18D-DS-SF01` | Un único nombre se mantiene igual. |
| `18D-DS-SF01`, `18D-DS-SF02`, `18D-DS-SF03` | `18D-DS-SFxx` | Los nombres con la misma base se agrupan con `xx` al final. |
| `18D-DS-SF01`, `18D-DS-XY02` | `18D-DS-SF01, 18D-DS-XY02` | Los nombres heterogéneos se listan separados por comas. |
| `"" (ID: 12345)`, `18D-DS-SF01` | `12345, 18D-DS-SF01` | Si no hay nombre, se usa el ID del elemento. |

4.  **Agregar la información a los conductos:**
    -   En todos los conductos seleccionados, se actualizará el parámetro `SRS_MEP_Circuit_Names`, agregando el nombre del circuito en orden alfabético sin eliminar datos previos.

5.  **Notificación:**
    -   Al finalizar, aparecerá una notificación confirmando la operación e indicando cuántos circuitos diferentes están ahora asociados a cada conducto.

![image](https://github.com/user-attachments/assets/27ea5b1c-fa1b-4901-8c08-8274da4ae6da)

![image](https://github.com/user-attachments/assets/abfc75f0-f174-4e89-8dc2-eb8db904fda4)

## Modos Especiales

### Modo Simple (Simple Mode)
Si la opción **"Overwrite existing circuits"** está activada, la herramienta borra completamente el contenido anterior del parámetro `SRS_MEP_Circuit_Names` antes de registrar el nuevo circuito. Esto es útil si cometió un error durante el trazado y desea "limpiar" el conducto.
> La herramienta mostrará una advertencia si se borran otros nombres de circuitos en el proceso.

### Sincronización Automática (Run Sync)
Si la opción **"Then run Sync for selected & show 3D View"** está activada, el plugin iniciará la herramienta de sincronización inmediatamente después de asignar el circuito.

### Modo de Inspección de Ruta
Si selecciona un circuito (o cuadro/carga) pero **no selecciona ningún conducto**, el plugin encontrará y resaltará automáticamente todos los conductos ya vinculados a ese circuito.
> En combinación con la opción **"Then run Sync for selected & show 3D View"**, esto permite abrir inmediatamente una vista 3D con la ruta actual para su verificación visual.

### Modo Silencioso (Silent Mode)
Mediante la casilla **Show UI** puede desactivar esta ventana. La herramienta se iniciará instantáneamente con los últimos ajustes guardados.
- Para invocar temporalmente la ventana cuando está desactivada, mantenga presionado **Shift** o **Ctrl** durante el inicio.

![UI](image.png)

## Historial de Cambios

2026-07-13
1. Silent Mode: Soporte para inicio instantáneo con modificadores Shift/Ctrl.
2. Simple Mode: Se añadió la opción para sobrescribir circuitos existentes en el conducto.

2026-07-09
1. Refinado el nombre de los circuitos: si las ubicaciones del cuadro y la carga difieren, se especifican ambas (Loc1-De/Loc2-A-Tag); si coinciden, se usa un solo prefijo (Loc-De/A-Tag).
2. Se implementó la selección automática del prefijo de ubicación basada en el mapeo `Functional_Breakdown_Code` en la configuración.

2026-06-19 Se corrigió la detección de circuitos para elementos que son paneles intermedios. Los nombres de parámetros se movieron a la sección `SyncConduitCircuit` en `%AppData%\Sener\BimTools\Settings.json`.

