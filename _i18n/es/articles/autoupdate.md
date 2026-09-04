# Actualización automática de BIMTools

---

## 1. Qué ha cambiado para el usuario

* **Antes:** El complemento mostraba una ventana de diálogo y descargaba un instalador MSI. El usuario tenía que completar manualmente los pasos de instalación, cerrar Revit y los proyectos abiertos, y confirmar la carga de cada nueva versión al iniciar Revit.
* **Ahora:** Las actualizaciones se descargan silenciosamente en segundo plano. Para empezar a trabajar con la nueva versión, basta con cerrar y volver a abrir Revit, sin ventanas de instalación ni acciones manuales.
* **Hot-reload:** Ahora es posible aplicar una actualización ya descargada sobre la marcha, sin reiniciar Revit ni volver a abrir modelos pesados.
> **Nota:** La actualización automática está disponible a partir de la versión **v25.33** (7 de mayo de 2026). Si actualizó el complemento después de esa fecha, el cargador ya está instalado y la función está activa.

---

## 2. Instrucciones de uso (menú Info -> Extra)

### Modo automático

* Al iniciar Revit y después cada 2 horas, el complemento comprueba si hay actualizaciones en el servidor.
* La nueva versión se descarga silenciosamente en segundo plano.
* En el siguiente inicio de Revit se carga la versión más reciente, se eliminan las versiones antiguas y se muestra una notificación con un breve resumen de cambios y un enlace a GitHub.

### Comprobar manualmente (`Check for updates now`)

Inicia inmediatamente una comprobación del servidor e informa del estado:

* No hay actualizaciones disponibles.
* La actualización se ha descargado y se aplicará después de reiniciar Revit.
* Las actualizaciones automáticas están desactivadas.

### Aplicar sin reiniciar (`Apply downloaded update now`)

Inicia el procedimiento de **Hot-reload**. Es útil cuando hay un modelo pesado abierto y reiniciar Revit resulta inconveniente. La nueva versión se carga inmediatamente en la sesión actual.

### Carga manual de una DLL (`Load DLL manually...`)

Permite seleccionar un archivo `.dll` del disco, por ejemplo una compilación de prueba de un desarrollador, y activarlo inmediatamente en la sesión actual mediante Hot-reload.

> **Importante:** La carga desde la interfaz es **temporal**. Después de reiniciar Revit, volverá a cargarse la versión oficial instalada.

### Gestión de las actualizaciones automáticas (`Auto-update enabled`)

Esta casilla controla la comprobación y la descarga en segundo plano. Al desmarcarla, se desactiva el modo automático, pero la comprobación manual sigue disponible.

![Ventana Info](infoWindow.png)

---

## 3. Detalles técnicos (Cómo funciona internamente)

### Arquitectura del cargador ligero (Loader) y el aviso de seguridad para complementos sin firmar

Revit solicita al usuario que confirme el inicio de un complemento sin firmar cuando su archivo binario ha cambiado. Para evitar comprar un certificado costoso y distribuir certificados autofirmados a través del departamento de TI de la empresa, la arquitectura se divide en dos partes:

1. El manifiesto `.addin` (`%APPDATA%\Autodesk\Revit\Addins\20YY\`) registra `BimToolsLoader.dll`, que normalmente no cambia cuando se actualizan los comandos del complemento.
2. El usuario aprueba el inicio del Loader en Revit una sola vez.
3. Al iniciarse, el Loader examina el directorio de trabajo (`%APPDATA%\Sener\BimTools\bin\`), selecciona la subcarpeta con la versión más reciente e inicia la DLL principal.
4. Desde el punto de vista de Revit, el registro del complemento permanece sin cambios, por lo que no aparecen ventanas de confirmación del complemento durante las actualizaciones.

<details markdown="block">
<summary>Cómo abrir la carpeta AppData en Windows</summary>

> `%appdata%` es una variable del sistema que apunta a la carpeta oculta de configuración de aplicaciones del usuario actual: `C:\Users\<user>\AppData\Roaming`.
> 
> La forma más rápida:
> 
> 1. Pulse **Win + R**.
> 2. Pegue `%appdata%\Autodesk\Revit\Addins`.
> 3. Pulse **Enter**.
> 
> También puede pegar esta ruta en la barra de direcciones del Explorador de archivos de Windows y pulsar **Enter**.

</details>

### Particularidades del mecanismo Hot-reload

No es posible reemplazar directamente una `.dll` mientras Revit está en ejecución porque el sistema operativo bloquea el archivo. Hot-reload resuelve este problema cargando la nueva versión junto a la anterior y desvinculando la versión anterior de los eventos de Revit:

* **Limitación de .NET:** La DLL anterior no se puede descargar completamente del dominio de aplicación principal de Revit y permanece en memoria hasta que se cierra el programa.
* **Interfaz:** La pestaña anterior de la cinta se oculta y se crea una nueva.
* **Efectos secundarios:** Las teclas de acceso rápido (Hotkeys) y los botones añadidos a la barra de herramientas de acceso rápido (QAT) permanecen vinculados a la primera versión cargada. El consumo de memoria también aumenta ligeramente.

*Por estas limitaciones, Hot-reload es una acción manual opcional. La forma estándar de aplicar las actualizaciones es reiniciar Revit.*

### Mantener una DLL personalizada y reglas de nomenclatura de versiones

Si necesita mantener una DLL de prueba activa después de reiniciar Revit:

* Coloque la DLL manualmente en `%APPDATA%\Sener\BimTools\bin\X.Y.1\` (las versiones oficiales utilizan `X.Y`, sin un tercer componente).
* **Importante:** No cree manualmente una carpeta para la siguiente versión mayor `X.Y+1`. El cargador la considerará más reciente y bloqueará la descarga de la versión oficial `X.Y+1`. El uso de un tercer componente (`X.Y.1`) mantiene el funcionamiento correcto de las actualizaciones automáticas.

## Registro de cambios

2026-09-04 v26.12 - añadida una notificación al iniciar una versión actualizada.
