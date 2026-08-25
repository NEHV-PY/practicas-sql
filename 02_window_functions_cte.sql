WITH balance_calculado AS (
    SELECT 
        id_cuenta,
        monto,
        fecha_transaccion,
        AVG(monto) OVER (PARTITION BY id_cuenta) AS promedio_historico
    FROM public.transacciones_bancarias
)
SELECT 
    id_cuenta,
    monto,
    fecha_transaccion,
    promedio_historico
FROM balance_calculado
WHERE monto > promedio_historico;
