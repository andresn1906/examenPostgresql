## 📄 **6. Enunciados de Triggers**

*1️⃣.- Actualización automática del stock en ventas:*

CREATE OR REPLACE FUNCTION fn_descuento_stock()
RETURNS TRIGGER AS $$
DECLARE
    v_stock INT;
BEGIN
    SELECT stock INTO v_stock FROM productos WHERE id = NEW.producto_id;

    IF v_stock IS NULL THEN
        RAISE EXCEPTION 'Producto % no existe', NEW.producto_id;
    ELSIF v_stock < NEW.cantidad THEN
        RAISE EXCEPTION 'Stock insuficiente para producto %, disponible: %, solicitado: %',
            NEW.producto_id, v_stock, NEW.cantidad;
    END IF;

    UPDATE productos
    SET stock = stock - NEW.cantidad
    WHERE id = NEW.producto_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_descuento_stock
BEFORE INSERT ON ventas_detalle
FOR EACH ROW
EXECUTE FUNCTION fn_descuento_stock();

-- Prueba:
INSERT INTO ventas_detalle (venta_id, producto_id, cantidad)
VALUES (1, 1, 2); -- debería descontar 2 unidades del producto 1
SELECT id, nombre, stock FROM productos WHERE id = 1;


*2️⃣.- Registro de auditoría de ventas:*
CREATE OR REPLACE FUNCTION fn_auditoria_ventas()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO auditoria_ventas (venta_id, usuario, registrado_en)
    VALUES (NEW.id, current_user, NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_auditoria_ventas
AFTER INSERT ON ventas
FOR EACH ROW
EXECUTE FUNCTION fn_auditoria_ventas();

-- Prueba:
INSERT INTO ventas (cliente_id, fecha, total)
VALUES (1, NOW(), 500);
SELECT * FROM auditoria_ventas ORDER BY id DESC LIMIT 1;

*3️⃣.- Notificación de productos agotados:*
CREATE OR REPLACE FUNCTION fn_alerta_stock()
RETURNS TRIGGER AS $$
DECLARE
    v_nombre TEXT;
BEGIN
    SELECT nombre INTO v_nombre FROM productos WHERE id = NEW.id;

    IF NEW.stock = 0 THEN
        INSERT INTO alertas_stock (producto_id, nombre_producto, mensaje, generado_en)
        VALUES (NEW.id, v_nombre, 'Producto agotado', NOW());
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_alerta_stock
AFTER UPDATE OF stock ON productos
FOR EACH ROW
WHEN (NEW.stock = 0)
EXECUTE FUNCTION fn_alerta_stock();

-- Prueba:
UPDATE productos SET stock = 0 WHERE id = 2;
SELECT * FROM alertas_stock ORDER BY id DESC LIMIT 1;

*4️⃣.- Validación de datos en clientes:*
CREATE OR REPLACE FUNCTION fn_validar_cliente()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.correo IS NULL OR NEW.correo = '' THEN
        RAISE EXCEPTION 'El correo no puede estar vacío';
    END IF;

    IF EXISTS (SELECT 1 FROM clientes WHERE correo = NEW.correo) THEN
        RAISE EXCEPTION 'El correo % ya está registrado', NEW.correo;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validar_cliente
BEFORE INSERT ON clientes
FOR EACH ROW
EXECUTE FUNCTION fn_validar_cliente();

-- Prueba:
INSERT INTO clientes (nombre, correo, estado)
VALUES ('Cliente Invalido', '', 'activo');

*5️⃣.- Historial de cambios de precio:*
CREATE OR REPLACE FUNCTION fn_historial_precios()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.precio <> OLD.precio THEN
        INSERT INTO historial_precios (producto_id, precio_anterior, precio_nuevo, cambiado_en)
        VALUES (OLD.id, OLD.precio, NEW.precio, NOW());
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_historial_precios
AFTER UPDATE OF precio ON productos
FOR EACH ROW
EXECUTE FUNCTION fn_historial_precios();

-- Prueba:
UPDATE productos SET precio = precio + 50 WHERE id = 3;
SELECT * FROM historial_precios ORDER BY id DESC LIMIT 1;

*6️⃣._ Bloqueo de eliminación de proveedores con productos activo:*
CREATE OR REPLACE FUNCTION fn_bloquear_proveedor()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM productos WHERE proveedor_id = OLD.id) THEN
        RAISE EXCEPTION 'No se puede eliminar el proveedor %, tiene productos asociados', OLD.id;
    END IF;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_bloquear_proveedor
BEFORE DELETE ON proveedores
FOR EACH ROW
EXECUTE FUNCTION fn_bloquear_proveedor();

-- Prueba:
DELETE FROM proveedores WHERE id = 1;

*7️⃣.- Control de fechas en ventas:*
CREATE OR REPLACE FUNCTION fn_validar_fecha_venta()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.fecha > NOW() THEN
        RAISE EXCEPTION 'La fecha de la venta no puede ser futura: %', NEW.fecha;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validar_fecha_venta
BEFORE INSERT ON ventas
FOR EACH ROW
EXECUTE FUNCTION fn_validar_fecha_venta();

-- Prueba:
INSERT INTO ventas (cliente_id, fecha, total)
VALUES (2, NOW() + interval '2 days', 100);

*8️⃣.- Registro de clientes inactivos:*
CREATE OR REPLACE FUNCTION fn_reactivar_cliente()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE clientes
    SET estado = 'activo'
    WHERE id = NEW.cliente_id
    AND estado = 'inactivo'
    AND (
            SELECT COALESCE(MAX(v.fecha), NOW() - interval '1 year')
            FROM ventas v
            WHERE v.cliente_id = NEW.cliente_id
        ) < NOW() - interval '6 months';
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_reactivar_cliente
BEFORE INSERT ON ventas
FOR EACH ROW
EXECUTE FUNCTION fn_reactivar_cliente();

-- Prueba:
UPDATE clientes SET estado = 'inactivo' WHERE id = 4;
INSERT INTO ventas (cliente_id, fecha, total)
VALUES (4, NOW(), 200);
SELECT id, nombre, estado FROM clientes WHERE id = 4;