-- Reto Nivel 5: RANK() vs DENSE_RANK()
TRUNCATE TABLE public.transacciones_bancarias;

INSERT INTO public.transacciones_bancarias (id_cuenta, monto, fecha_transaccion) VALUES
(501, 500.00, '2026-11-01'),
(501, 300.00, '2026-11-02'),
(501, 300.00, '2026-11-03'),
(501, 100.00, '2026-11-04');

SELECT 
    id_transaccion,
    id_cuenta,
    monto,
    fecha_transaccion,
    RANK() OVER (
        PARTITION BY id_cuenta 
        ORDER BY monto DESC
    ) AS ranking_rank,
    DENSE_RANK() OVER (
        PARTITION BY id_cuenta 
        ORDER BY monto DESC
    ) AS ranking_dense
FROM public.transacciones_bancarias;
