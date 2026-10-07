-- Reto Nivel Cosmico: CTE + Window Function + EXISTS
WITH promedio_calculado AS (
    SELECT 
        id_transaccion,
        id_cuenta,
        monto,
        fecha_transaccion,
        AVG(monto) OVER (PARTITION BY id_cuenta) AS promedio_historico
    FROM public.transacciones_bancarias
)
SELECT 
    A.id_transaccion,
    A.id_cuenta,
    A.monto,
    A.fecha_transaccion,
    A.promedio_historico
FROM promedio_calculado A
WHERE A.monto > A.promedio_historico
  AND EXISTS (
      SELECT 1 
      FROM public.transacciones_bancarias B
      WHERE B.id_cuenta = A.id_cuenta
        AND B.fecha_transaccion = A.fecha_transaccion
        AND B.id_transaccion <> A.id_transaccion
  );
