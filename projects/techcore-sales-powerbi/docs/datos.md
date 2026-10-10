# Datos y diccionario

El caso académico presenta los datos como ficticios. Los archivos de `datos` son copias byte a byte de las fuentes de los avances anteriores; esta entrega no transforma de nuevo el dataset.

| Archivo | Procedencia | Codificación / separador | Filas de datos | Columnas |
| --- | --- | --- | ---: | ---: |
| `ventas.csv` | Avance 1, fuente original | `utf-8-sig` / `,` | 30,307 | 30 |
| `ventasTransformed.csv` | Avance 1, salida transformada | `cp1252` / `;` | 30,000 | 33 |
| `modeloVentas.xlsx` | Avance 2, salida del modelado relacional | Excel | Por tabla | Por tabla |

El conteo del CSV original es 30.307 registros y el transformado contiene 30.000. Se documentan los archivos incluidos; para revisar las decisiones de limpieza y modelado, consulta los PBIX y el notebook de `historico/entrega_anterior/Avances`.

El CSV transformado usa punto y coma y Windows-1252. Abrirlo como UTF-8 o separar por coma puede producir caracteres incorrectos o una única columna. Los iniciadores conservan las consultas de origen del modelo.

## Columnas de los CSV

### ventas.csv

| Posición | Columna |
| ---: | --- |
| 1 | `VentaID` |
| 2 | `FechaVenta` |
| 3 | `HoraVenta` |
| 4 | `SucursalNombre` |
| 5 | `CiudadSucursal` |
| 6 | `VendedorNombre` |
| 7 | `Cliente_Nombre` |
| 8 | `GeneroCliente` |
| 9 | `edadcliente` |
| 10 | `EmailCliente` |
| 11 | `TelefonoCliente` |
| 12 | `Direccion_Cliente` |
| 13 | `MetodoPago` |
| 14 | `NombreProducto1` |
| 15 | `MarcaProducto1` |
| 16 | `CantidadProducto1` |
| 17 | `PrecioUnitarioProducto1` |
| 18 | `SubtotalProducto1` |
| 19 | `NombreProducto2` |
| 20 | `MarcaProducto2` |
| 21 | `CantidadProducto2` |
| 22 | `PrecioUnitarioProducto2` |
| 23 | `SubtotalProducto2` |
| 24 | `NombreProducto3` |
| 25 | `MarcaProducto3` |
| 26 | `CantidadProducto3` |
| 27 | `PrecioUnitarioProducto3` |
| 28 | `SubtotalProducto3` |
| 29 | `DescuentoVenta` |
| 30 | `TotalVenta` |

### ventasTransformed.csv

| Posición | Columna |
| ---: | --- |
| 1 | `VentaID` |
| 2 | `FechaVenta` |
| 3 | `HoraVenta` |
| 4 | `SucursalNombre` |
| 5 | `CiudadSucursal` |
| 6 | `VendedorNombre` |
| 7 | `Cliente_Nombre` |
| 8 | `GeneroCliente` |
| 9 | `edadcliente` |
| 10 | `EmailCliente` |
| 11 | `TelefonoCliente` |
| 12 | `Direccion_Cliente` |
| 13 | `MetodoPago` |
| 14 | `Producto1Nombre` |
| 15 | `Producto1Marca` |
| 16 | `Producto1Cantidad` |
| 17 | `Producto1PrecioUnitario` |
| 18 | `Producto1Subtotal` |
| 19 | `Producto2Nombre` |
| 20 | `Producto2Marca` |
| 21 | `Producto2Cantidad` |
| 22 | `Producto2PrecioUnitario` |
| 23 | `Producto2Subtotal` |
| 24 | `Producto3Nombre` |
| 25 | `Producto3Marca` |
| 26 | `Producto3Cantidad` |
| 27 | `Producto3PrecioUnitario` |
| 28 | `Producto3Subtotal` |
| 29 | `DescuentoVenta` |
| 30 | `TotalVenta` |
| 31 | `MesVenta` |
| 32 | `MesNumero` |
| 33 | `AñoVenta` |

## Columnas del modelo semántico

Los tipos siguientes se extraen de `database.json`. Las expresiones calculadas y consultas completas permanecen en el código fuente del modelo.

### Ciudades

| Columna | Tipo del modelo | Calculada |
| --- | --- | --- |
| `CiudadID` | `int64` | No |
| `NombreCiudad` | `string` | No |

### Clientes

| Columna | Tipo del modelo | Calculada |
| --- | --- | --- |
| `ClienteID` | `int64` | No |
| `Cliente_Nombre` | `string` | No |
| `GeneroCliente` | `string` | No |
| `edadcliente` | `int64` | No |
| `EmailCliente` | `string` | No |
| `TelefonoCliente` | `string` | No |
| `Direccion_Cliente` | `string` | No |
| `Rango de Edad` | `string` | Sí |

### DetalleFacturas

| Columna | Tipo del modelo | Calculada |
| --- | --- | --- |
| `DetalleID` | `int64` | No |
| `FacturaID` | `int64` | No |
| `ProductoID` | `int64` | No |
| `Cantidad` | `int64` | No |
| `PrecioUnitario` | `int64` | No |
| `Subtotal` | `int64` | No |

### Facturas

| Columna | Tipo del modelo | Calculada |
| --- | --- | --- |
| `FacturaID` | `int64` | No |
| `FechaVenta` | `dateTime` | No |
| `HoraVenta` | `dateTime` | No |
| `SucursalID` | `int64` | No |
| `ClienteID` | `int64` | No |
| `VendedorID` | `int64` | No |
| `MetodoPagoID` | `int64` | No |
| `DescuentoVenta` | `int64` | No |
| `TotalVenta` | `int64` | No |
| `MesVenta` | `string` | No |
| `MesNumero` | `int64` | No |
| `AñoVenta` | `int64` | No |

### MetodosPago

| Columna | Tipo del modelo | Calculada |
| --- | --- | --- |
| `MetodoPagoID` | `int64` | No |
| `TipoMetodoPago` | `string` | No |

### Productos

| Columna | Tipo del modelo | Calculada |
| --- | --- | --- |
| `ProductoID` | `int64` | No |
| `NombreProducto` | `string` | No |
| `MarcaProducto` | `string` | No |
| `PrecioUnitario` | `int64` | No |

### Sucursales

| Columna | Tipo del modelo | Calculada |
| --- | --- | --- |
| `SucursalID` | `int64` | No |
| `SucursalNombre` | `string` | No |
| `CiudadID` | `int64` | No |
| `NombreCiudad_Rel` | `string` | Sí |

### Vendedores

| Columna | Tipo del modelo | Calculada |
| --- | --- | --- |
| `VendedorID` | `int64` | No |
| `VendedorNombre` | `string` | No |

### dCalendario

| Columna | Tipo del modelo | Calculada |
| --- | --- | --- |
| `Date` | `dateTime` | No |
| `Año` | `int64` | No |
| `MesNumero` | `int64` | No |
| `NombreMes` | `string` | No |
| `Trimestre` | `string` | No |
| `AñoTrimestre` | `string` | No |
| `AñoMes` | `string` | No |
| `DiaSemana` | `int64` | No |
| `NombreDia` | `string` | No |

### UsuariosRLS

| Columna | Tipo del modelo | Calculada |
| --- | --- | --- |
| `UserEmail (UPN)` | `string` | No |
| `RolAsignado` | `string` | No |
| `CiudadFiltro` | `string` | No |
| `SucursalFiltro` | `string` | No |
