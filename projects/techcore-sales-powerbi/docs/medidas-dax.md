# Catálogo de medidas DAX

Expresiones extraídas del modelo real, sin reescribir sus cálculos. Todas las medidas actuales pertenecen a `_Medidas`. Las medidas de costo y margen indicadas como simuladas forman parte del supuesto académico.

## VentasTotales

Tabla: `_Medidas`.

```dax
SUM(Facturas[TotalVenta])
```

Formato: `\$#,0.###############;(\$#,0.###############);\$#,0.###############`.

## TotalUnidadesVendidas

Tabla: `_Medidas`.

```dax
SUM(DetalleFacturas[Cantidad])
```

Formato: `0`.

## TotalFacturas

Tabla: `_Medidas`.

```dax
DISTINCTCOUNT(Facturas[FacturaID])
```

Formato: `0`.

## TicketPromedio

Tabla: `_Medidas`.

```dax

    DIVIDE(
        [VentasTotales],
        [TotalFacturas],
        0
    )
```

Formato: `\$#,0.###############;(\$#,0.###############);\$#,0.###############`.

## PrecioPromedioPorUnidad

Tabla: `_Medidas`.

```dax

    DIVIDE(
        [VentasTotales],
        [TotalUnidadesVendidas],
        0
    )
```

## TotalDescuento

Tabla: `_Medidas`.

```dax
SUM(Facturas[DescuentoVenta])
```

Formato: `0`.

## % Descuento Sobre Ventas

Tabla: `_Medidas`.

```dax

    DIVIDE(
        [TotalDescuento],
        [VentasTotales] + [TotalDescuento], // Sobre el total antes de descuento
        0
    )
```

## CostoTotal (Simulado)

Tabla: `_Medidas`.

```dax
[VentasTotales] * 0.65

```

## MargenBruto (Simulado)

Tabla: `_Medidas`.

```dax
[VentasTotales] - [CostoTotal (Simulado)]
```

## % Margen (Simulado)

Tabla: `_Medidas`.

```dax

    DIVIDE(
        [MargenBruto (Simulado)],
        [VentasTotales],
        0
    )
```

Formato: `0.00\ %;-0.00\ %;0.00\ %`.

## % Participacion Ciudad

Tabla: `_Medidas`.

```dax

    DIVIDE(
        [VentasTotales],
        CALCULATE(
            [VentasTotales],
            ALLSELECTED(Ciudades[NombreCiudad])
        )
    )

```

## % Participacion Marca

Tabla: `_Medidas`.

```dax

    DIVIDE(
        [VentasTotales],
        CALCULATE(
            [VentasTotales],
            ALLSELECTED(Productos[MarcaProducto])
        )
    )

```

## % Participacion MetodoPago

Tabla: `_Medidas`.

```dax

    DIVIDE(
        [VentasTotales],
        CALCULATE(
            [VentasTotales],
            ALLSELECTED(MetodosPago[TipoMetodoPago])
        )
    )
```

## Ventas YTD (Año hasta la fecha)

Tabla: `_Medidas`.

```dax
TOTALYTD([VentasTotales], dCalendario[Date])
```

Formato: `0`.

## Ventas MTD (Mes hasta la fecha)

Tabla: `_Medidas`.

```dax
TOTALMTD([VentasTotales], dCalendario[Date])
```

Formato: `0`.

## Ventas PY (Año Anterior)

Tabla: `_Medidas`.

```dax

    CALCULATE(
        [VentasTotales],
        SAMEPERIODLASTYEAR(dCalendario[Date])
    )

```

Formato: `0`.

## Crecimiento Ventas % (vs PY)

Tabla: `_Medidas`.

```dax

    DIVIDE(
        [VentasTotales] - [Ventas PY (Año Anterior)],
        [Ventas PY (Año Anterior)],
        BLANK()
    )
```

## Ventas PM (Mes Anterior)

Tabla: `_Medidas`.

```dax

    CALCULATE(
        [VentasTotales],
        DATEADD(dCalendario[Date], -1, MONTH)
    )
```

Formato: `0`.

## Crecimiento Ventas % (vs PM)

Tabla: `_Medidas`.

```dax

    DIVIDE(
        [VentasTotales] - [Ventas PM (Mes Anterior)],
        [Ventas PM (Mes Anterior)],
        BLANK()
    )

```

## TotalClientes

Tabla: `_Medidas`.

```dax
DISTINCTCOUNT(Facturas[ClienteID])
```

Formato: `0`.

## VentasPromedioPorCliente

Tabla: `_Medidas`.

```dax

    DIVIDE(
        [VentasTotales],
        [TotalClientes],
        0
    )

```

## TotalVendedores

Tabla: `_Medidas`.

```dax
DISTINCTCOUNT(Facturas[VendedorID])
```

Formato: `0`.

## VentasPromedioPorVendedor

Tabla: `_Medidas`.

```dax

    DIVIDE(
        [VentasTotales],
        [TotalVendedores],
        0
    )

```

## Ranking Marcas

Tabla: `_Medidas`.

```dax

    RANKX(
        ALLSELECTED(Productos[MarcaProducto]),
        [VentasTotales],
        ,
        DESC,
        Dense
    )
```

Formato: `0`.

## Total Sucursales

Tabla: `_Medidas`.

```dax
DISTINCTCOUNT(Sucursales[SucursalID])
```

Formato: `0`.

## Total Marcas

Tabla: `_Medidas`.

```dax
DISTINCTCOUNT(Productos[MarcaProducto])
```

Formato: `0`.
