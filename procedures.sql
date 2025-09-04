## 📄 **5. Procedimientos y Funciones**

1️⃣ *Un procedimiento almacenado para: 
- registrar una venta
- Validar que el cliente exista
- Verificar que el stock sea suficiente antes de procesar la venta
- Si no hay stock suficiente, Notificar por medio de un mensaje en consola usando RAISE
- Si hay stock, se realiza el registro de la venta*

CREATE OR REPLACE PROCEDURE registrar_venta(
    p_cliente_id INT,
    p_productos INT[],       
    p_cantidades INT[]       
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_venta_id INT;
    v_stock_actual INT;
    v_precio NUMERIC(12,2);
    i INT;
BEGIN

    IF NOT EXISTS (SELECT 1 FROM clientes WHERE id = p_cliente_id) THEN
        RAISE EXCEPTION 'El cliente con ID % no existe', p_cliente_id;
    END IF;


    INSERT INTO ventas (cliente_id, fecha)
    VALUES (p_cliente_id, NOW())
    RETURNING id INTO v_venta_id;


    FOR i IN 1 .. array_length(p_productos, 1) LOOP

        SELECT stock, precio INTO v_stock_actual, v_precio
        FROM productos
        WHERE id = p_productos[i];

        IF v_stock_actual IS NULL THEN
            RAISE EXCEPTION 'El producto con ID % no existe', p_productos[i];
        ELSIF v_stock_actual < p_cantidades[i] THEN
            RAISE EXCEPTION 'Stock insuficiente para producto ID % (disponible: %, solicitado: %)',
                p_productos[i], v_stock_actual, p_cantidades[i];
        END IF;

        INSERT INTO ventas_detalle (venta_id, producto_id, cantidad, precio_unitario)
        VALUES (v_venta_id, p_productos[i], p_cantidades[i], v_precio);

    END LOOP;

    RAISE NOTICE 'Venta % registrada exitosamente para cliente %', v_venta_id, p_cliente_id;
END;
$$;

-- Método para probar:

CALL registrar_venta(
    1,                   
    ARRAY[1,2],          
    ARRAY[1,2]           
);

--Ventas:
SELECT * FROM ventas ORDER BY id DESC;

-- Detalle de última venta:
SELECT * FROM ventas_detalle WHERE venta_id = (SELECT MAX(id) FROM ventas);

-- Stock Productos:
SELECT id, nombre, stock FROM productos WHERE id IN (1,2);