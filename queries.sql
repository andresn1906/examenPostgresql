## 📄 **4. Consultas SQL (queries.sql)**

1️⃣ *Listar los productos con stock menor a 5 unidades:*    

SELECT p.id, p.nombre AS Producto, p.stock AS Stock
FROM productos p
WHERE p.stock < 5
ORDER BY p.stock ASC, p.nombre;

2️⃣ *Calcular ventas totales de un mes específico:*

SELECT TO_CHAR(v.fecha, 'YYYY-MM') AS Mes,
SUM(vd.cantidad * vd.precio_unitario) AS TotalVentas
FROM ventas v
INNER JOIN ventas_detalle vd ON v.id = vd.venta_id
WHERE DATE_TRUNC('month', v.fecha) = DATE_TRUNC('month', DATE '2025-08-10')
GROUP BY Mes;

3️⃣ *Obtener el cliente con más compras realizadas:*

SELECT cl.id, cl.nombre AS Cliente, COUNT(v.id) AS TotalCompras
FROM clientes cl
INNER JOIN ventas v ON cl.id = v.cliente_id
GROUP BY cl.id, cl.nombre
ORDER BY TotalCompras DESC
LIMIT 1;

4️⃣ *Listar los 5 productos más vendidos:*

SELECT p.id, p.nombre AS producto, 
SUM(vd.cantidad) AS TotalVendido
FROM productos p
INNER JOIN ventas_detalle vd ON p.id = vd.producto_id
GROUP BY p.id, p.nombre
ORDER BY TotalVendido DESC
LIMIT 5;

5️⃣ *Consultar ventas realizadas en un rango de fechas de tres Días y un Mes:*

SELECT v.id, v.fecha AS Fecha,
SUM(vd.cantidad * vd.precio_unitario) AS TotalVentas
FROM ventas v
INNER JOIN ventas_detalle vd ON v.id = vd.venta_id
WHERE v.fecha BETWEEN '2025-08-03' AND '2025-08-05'
GROUP BY v.id, v.fecha
ORDER BY v.fecha;

6️⃣ *Identificar clientes que no han comprado en los últimos 6 meses:*

SELECT cl.id, cl.nombre AS Cliente, cl.correo AS Correo
FROM clientes cl
WHERE NOT EXISTS (
    SELECT 1
    FROM ventas v
    WHERE v.cliente_id = cl.id
    AND v.fecha >= (CURRENT_DATE - INTERVAL '6 months')
)
ORDER BY cl.nombre;
