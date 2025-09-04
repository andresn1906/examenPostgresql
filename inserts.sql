## 📄 **3. Inserción de Datos:**

INSERT INTO proveedores (nombre) VALUES
('TechSupplier'),
('GadgetWorld'),
('CompuParts'),
('MobileStore'),
('DataCenter Pro'),
('ElectroMax'),
('PCFactory'),
('SmartSolutions'),
('FutureTech'),
('MegaTech'),
('SysTech'),
('HardParts'),
('SoftWorld'),
('TechNova'),
('GlobalElectronics');

INSERT INTO productos (nombre, categoria, precio, stock, proveedor_id) VALUES
('Laptop Lenovo ThinkPad', 'Computadores', 2500.00, 10, 1),
('Mouse Logitech MX', 'Accesorios', 120.00, 4, 2),
('Teclado Mecánico Redragon', 'Accesorios', 180.00, 6, 2),
('Smartphone Samsung Galaxy S21', 'Celulares', 3200.00, 8, 4),
('Monitor LG 24"', 'Monitores', 950.00, 5, 3),
('Impresora HP LaserJet', 'Impresoras', 600.00, 12, 6),
('Disco SSD Kingston 1TB', 'Almacenamiento', 420.00, 15, 5),
('Memoria RAM Corsair 16GB', 'Componentes', 350.00, 20, 7),
('Cargador Universal', 'Accesorios', 60.00, 25, 8),
('Auriculares Sony WH-1000XM4', 'Audio', 1100.00, 7, 9),
('Tablet Apple iPad Air', 'Tablets', 2700.00, 9, 10),
('Cámara Canon EOS M50', 'Cámaras', 3900.00, 3, 11),
('Router TP-Link Archer', 'Redes', 300.00, 14, 12),
('Proyector Epson XGA', 'Proyectores', 2500.00, 2, 13),
('Consola PlayStation 5', 'Consolas', 4500.00, 6, 14);



INSERT INTO clientes (nombre, correo, telefono, estado) VALUES
('Juan Pérez', 'juan.perez@mail.com', '3001234567', 'activo'),
('Ana Gómez', 'ana.gomez@mail.com', '3017654321', 'activo'),
('Luis Torres', 'luis.torres@mail.com', '3029876543', 'activo'),
('María Rodríguez', 'maria.rod@mail.com', '3041122334', 'inactivo'),
('Carlos Hernández', 'carlos.hdz@mail.com', '3052233445', 'activo'),
('Laura Sánchez', 'laura.san@mail.com', '3063344556', 'activo'),
('Pedro Ramírez', 'pedro.ram@mail.com', '3074455667', 'activo'),
('Sofía Morales', 'sofia.mor@mail.com', '3085566778', 'activo'),
('Miguel Castro', 'miguel.cas@mail.com', '3096677889', 'activo'),
('Camila Ruiz', 'camila.ruiz@mail.com', '3107788990', 'activo'),
('Andrés López', 'andres.lopez@mail.com', '3118899001', 'activo'),
('Valentina Díaz', 'valentina.d@mail.com', '3129900112', 'activo'),
('Jorge Silva', 'jorge.sil@mail.com', '3131011121', 'activo'),
('Daniela Vargas', 'daniela.var@mail.com', '3142122232', 'activo'),
('Ricardo Mendoza', 'ricardo.men@mail.com', '3153233343', 'activo');


INSERT INTO ventas (cliente_id, fecha) VALUES
(1, '2025-08-01 10:00:00'),
(2, '2025-08-02 15:30:00'),
(3, '2025-08-03 16:45:00'),
(4, '2025-08-04 11:20:00'),
(5, '2025-08-05 09:10:00'),
(6, '2025-08-06 14:50:00'),
(7, '2025-08-07 12:00:00'),
(8, '2025-08-08 17:35:00'),
(9, '2025-08-09 13:15:00'),
(10, '2025-08-10 19:00:00'),
(11, '2025-08-11 10:40:00'),
(12, '2025-08-12 15:25:00'),
(13, '2025-08-13 16:05:00'),
(14, '2025-08-14 18:45:00'),
(15, '2025-08-15 09:55:00');


INSERT INTO ventas_detalle (venta_id, producto_id, cantidad, precio_unitario) VALUES
(1, 1, 1, 2500.00),
(2, 2, 2, 120.00),
(3, 4, 1, 3200.00),
(4, 5, 1, 950.00),
(5, 6, 1, 600.00),
(6, 7, 2, 420.00),
(7, 8, 2, 350.00),
(8, 9, 3, 60.00),
(9, 10, 1, 1100.00),
(10, 11, 1, 2700.00),
(11, 12, 1, 3900.00),
(12, 13, 1, 300.00),
(13, 14, 1, 2500.00),
(14, 15, 1, 4500.00),
(15, 3, 2, 180.00);