# Recuento de Enchufes
{: .no_toc }

<details open markdown="block">
  <summary>
    Tabla de contenidos
  </summary>
  {: .text-delta }
1. TOC
{:toc}
</details>

El comando **Count Sockets** cuenta automáticamente los enchufes en los circuitos eléctricos seleccionados y escribe información detallada directamente en los parámetros del circuito. Obtiene una especificación completa de elementos con cantidades e información sobre su ubicación por habitaciones.

## Qué Hace el Comando

- **Cuenta enchufes simples y dobles** en cada circuito seleccionado
- **Agrupa todos los elementos por tipos** con indicación de cantidad
- **Determina la ubicación de elementos por habitaciones** desde el modelo arquitectónico vinculado
- **Escribe toda la información en parámetros del circuito** para usar en tablas e informes

## Preparación

Antes de ejecutar el comando, asegúrese de que:

1. Los circuitos eléctricos a analizar están seleccionados en el proyecto
2. Existe un modelo arquitectónico vinculado con habitaciones (generalmente con el marcador "AR01" en el nombre)
3. Los parámetros para registrar resultados están creados en el proyecto: **"Sockets single"**, **"Sockets twin"**, **"ElemsDescr"**, **"LocationDescr"**

## Uso

1. **Seleccione los circuitos eléctricos** en el modelo para los que necesita contar enchufes
2. **Ejecute el comando** Count Sockets
3. **Espere la finalización** — el comando mostrará una barra de progreso con información sobre el circuito actual que se está procesando
4. **Verifique los resultados** en las propiedades del circuito o cree una tabla con parámetros completados

## Resultados

El comando completa los siguientes parámetros en cada circuito eléctrico:

### Parámetro "Sockets single"
Número de enchufes simples (número entero).

*Ejemplo: 5*

### Parámetro "Sockets twin"
Número de enchufes dobles (número entero).

*Ejemplo: 3*

### Parámetro "ElemsDescr"
Especificación detallada de todos los elementos en el circuito por tipos (texto multilínea).

*Formato:*
```
2: Family Name: Type Name
1: Family Name 2: Type Name 2
3: Family Name 3: Type Name 3
```

*Ejemplo:*
```
5: Socket Standard: Type A
3: Socket USB: Type B
2: Socket Twin: Type C
```

### Parámetro "LocationDescr"
Información sobre la ubicación de elementos por habitaciones con códigos Sharjah (texto multilínea).

*Formato:*
```
cantidad: código_habitación Nombre Habitación
cantidad: código_habitación Nombre Habitación
cantidad: None id: element_id element_id
```

*Ejemplo:*
```
5: L01-Z02-EU03-F04-005 Office
3: L01-Z02-EU03-F04-006 Corridor
2: None id: 123456 789012
```

Los elementos con registro "None" no cayeron en ninguna habitación — se indican sus IDs de elemento.

## Características

### Detección de Enchufes Simples y Dobles
El comando clasifica automáticamente los enchufes por la presencia de palabras clave en el nombre de la familia o el nombre del tipo de elemento (no distingue mayúsculas):

- **Enchufes dobles** — contienen la palabra **"twin"** en el nombre
- **Enchufes simples** — contienen la palabra **"single"** en el nombre
- Los enchufes sin estas palabras no caen en ninguna categoría y no se cuentan en los parámetros "Sockets single" y "Sockets twin"

*Ejemplos de enchufes dobles:*
- Familia "Socket Twin"
- Tipo "Twin Type A"
- Familia "Standard Twin Socket"

*Ejemplos de enchufes simples:*
- Familia "Socket Single"
- Tipo "Single Type A"
- Familia "Standard Single Socket"

### Códigos de Habitación Sharjah
Se genera un código especial para cada habitación a partir de cinco componentes:

**Formato:** `L-Z-EU-F-S`

- **L** — Código de Nivel (Level Code)
- **Z** — Código de Zona (Zone Code)
- **EU** — Código de Usuario Final (End-User Code)
- **F** — Código de Función (Function Code)
- **S** — Número de Serie (Series Number)

Estos códigos se toman de los parámetros de habitación en el modelo arquitectónico.

### Modelo Arquitectónico Vinculado
El comando busca habitaciones en modelos Revit vinculados con el marcador **"AR01"** en el nombre. Si tiene un marcador de modelo arquitectónico diferente, contacte al desarrollador para la configuración.

### Algoritmo de Detección de Habitaciones
Para una detección precisa de habitaciones, el comando verifica la ubicación del elemento en varios niveles de altura (desde +0.2m hasta -5m desde el punto de colocación del elemento). Esto permite la operación correcta con enchufes montados en pared y elementos en pisos.

