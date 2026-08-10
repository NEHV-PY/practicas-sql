SELECT 
    u.nombre,
    COUNT(o.id_orden) AS total_ordenes
FROM public.usuarios_ecommerce u
JOIN public.ordenes_compra o ON u.id_usuario = o.id_usuario
WHERE u.estado_cuenta = 'ACTIVO'
GROUP BY u.id_usuario, u.nombre
HAVING COUNT(o.id_orden) > ALL (
    SELECT COUNT(o2.id_orden)
    FROM public.usuarios_ecommerce u2
    JOIN public.ordenes_compra o2 ON u2.id_usuario = o2.id_usuario
    WHERE u2.estado_cuenta = 'EN_REVISION'
    GROUP BY u2.id_usuario
);
