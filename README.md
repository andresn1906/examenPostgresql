# **🛒 Sistema de Gestión de Ventas en PostgreSQL**

## 📌 Descripción del proyecto:
Este proyecto implementa un sistema de gestión de ventas utilizando PostgreSQL.

El objetivo es simular el flujo de información en una tienda de productos electrónicos, permitiendo:
- Registrar proveedores, productos, clientes y ventas.
- Controlar automáticamente el stock de productos al realizar ventas.
- Mantener un historial de cambios de precios.
- Auditar operaciones sensibles como ventas y eliminaciones de proveedores.
- Generar alertas de stock cuando un producto se agote.
- Consultar información relevante sobre clientes, productos y ventas.

El proyecto incluye: 
- tablas normalizadas hasta 3FN
- procedimientos almacenados 
- triggers 
- consultas SQL avanzadas.


## 🖼️ Modelo Entidad-Relación:
El modelo E-R de la base de datos se encuentra en el archivo:

[Modelo E-R](imagenes/modelo_er.png)

## 📂 Descripción de archivos:

- *db.sql* → Contiene la definición de todas las tablas con sus restricciones y relaciones.
- *insert.sql* → Inserta datos de ejemplo para proveedores, productos, clientes y ventas.
- *procedure.sql* → Procedimientos almacenados, incluyendo el registro de ventas con validaciones.
- *triggers.sql* → Triggers para controlar stock, auditoría, historial de precios, validaciones y alertas.
- *queries.sql* → Consultas SQL para análisis de ventas, clientes y productos.
- *imagenes/modelo_er.png* → Modelo E-R de la base de datos

## 🧪 Ejecución de ejemplos:

### ▶️ Ejecutar una consulta
- *Ejemplo: listar productos con stock menor a 5 unidades*
```sql
SELECT p.id, p.nombre AS Producto, p.stock AS Stock
FROM productos p
WHERE p.stock < 5
ORDER BY p.stock ASC, p.nombre;
```

### ▶️ Ejecutar el procedimiento almacenado:
- *Registrar una venta (ejemplo: cliente 1 compra 2 unidades del producto 3):*
```sql
CALL registrar_venta(1, 3, 2);
```

## 👨‍💻 Autores:

Proyecto académico de sistema de gestión de ventas desarrollado en SQL con PostgreSQL.
Desarrollado por:
- Camilo Andrés Suárez Niño
- Juan Sebastián Mora Patiño
