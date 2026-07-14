--INSERTAR PROPIETARIO
INSERT INTO propietarios (nombre, identificacion, telefono, email, fecha_registro)
VALUES ('Loida', 7654321, '2121-2828', 'loida@gmail.com', CURRENT_DATE);
SELECT * FROM propietarios;

--INSERTAR ALOJAMIENTO
INSERT INTO alojamientos (nombre_alojamiento, direccion, precio_noche, propietario_id, activo)
VALUES ('Habitación Palida', 'El Naranjo', 250, '4', 'false');
SELECT * FROM alojamientos;

--INSERTAR HUESPED
INSERT INTO huespedes(nombre, identificacion, pais, telefono)
VALUES ('Alcir', 2112112, 'Venezuela', '3344-5566');
SELECT nombre FROM huespedes WHERE id = 19;
SELECT * FROM huespedes;

--INSERTAR RESERVA
INSERT INTO reservas (alojamiento_id, huesped_id, fecha_entrada, fecha_salida, precio_total, fecha_reserva, estado)
VALUES (6, 19, '10-07-2026', '11-07-2026', 250.00, CURRENT_TIMESTAMP, 'Pendiente');
SELECT * FROM reservas;

--INSERTAR PAGO
INSERT INTO pagos (reserva_id, monto, metodo_pago, estado_pago, fecha_pago)
VALUES (7, 250, 'Tarjeta de Débito', 'Completado', CURRENT_TIMESTAMP);
SELECT * FROM pagos;

--ALOJAMIENTOS ACTIVOS
SELECT activo FROM alojamientos;

--HUESPEDES POR PAIS
SELECT pais FROM huespedes;

--RESERVAS POR FECHA
SELECT *
FROM reservas
WHERE fecha_entrada BETWEEN '2026-07-15' AND '2026-09-10';

--ACTUALIZAR ESTADO RESERVA
UPDATE reservas
SET estado = 'Confirmada'
WHERE id = 7;

--ACTUALIZAR PRECIO
UPDATE alojamientos
SET precio_noche = 100
WHERE id = 6;

--ELIMINAR RESEÑA
DELETE FROM resenas WHERE id = 1;
SELECT * FROM resenas;

--JOIN RESERVAS + HUESPED
SELECT
    r.id AS id_reserva,
    h.nombre AS nombre_huesped,
    h.identificacion,
    h.pais,
    r.fecha_entrada,
    r.fecha_salida,
    r.precio_total,
    r.estado
FROM public.reservas r
INNER JOIN public.huespedes h
ON r.huesped_id = h.id;

SELECT * FROM alojamientos;
SELECT * FROM huespedes;
SELECT * FROM reservas;

--JOIN ALOJAMIENTO COMPLETO
SELECT
    a.id,
    a.nombre_alojamiento,
    a.direccion,
    a.precio_noche,
    p.nombre AS propietario,
    r.id AS reserva,
    h.nombre AS huesped
FROM alojamientos a
INNER JOIN propietarios p
ON a.propietario_id = p.id
INNER JOIN reservas r
ON a.id = r.alojamiento_id
INNER JOIN huespedes h
ON r.huesped_id = h.id;

--JOIN PAGOS + RESERVAS
SELECT
    p.id AS id_pago,
    p.monto,
    p.metodo_pago,
    p.estado_pago,
    r.id AS id_reserva,
    r.fecha_entrada,
    r.fecha_salida,
    r.estado
FROM pagos p
INNER JOIN reservas r
ON p.reserva_id = r.id;

--LEFT JOIN SIN RESERVAS
SELECT
    a.id,
    a.nombre_alojamiento
FROM alojamientos a
LEFT JOIN reservas r
ON a.id = r.alojamiento_id
WHERE r.id IS NULL;

--TOTAL INGRESOS
SELECT
    SUM(monto) AS total_ingresos
FROM pagos
WHERE estado_pago = 'Completado';

--PROMEDIO RATING
SELECT
    AVG(calificacion) AS promedio_rating
FROM resenas;

--TOP ALOJAMIENTOS
SELECT
    a.nombre_alojamiento,
    COUNT(r.id) AS total_reservas
FROM alojamientos a
INNER JOIN reservas r
ON a.id = r.alojamiento_id
GROUP BY a.nombre_alojamiento
ORDER BY total_reservas DESC
LIMIT 5;

--MAS DE 3 RESERVAS
SELECT
    a.nombre_alojamiento,
    COUNT(r.id) AS cantidad_reservas
FROM alojamientos a
INNER JOIN reservas r
ON a.id = r.alojamiento_id
GROUP BY a.nombre_alojamiento
HAVING COUNT(r.id) > 3;

--ALOJAMIENTO MAS CARO
SELECT
    nombre_alojamiento,
    precio_noche
FROM alojamientos
WHERE precio_noche = (
    SELECT MAX(precio_noche)
    FROM alojamientos
);