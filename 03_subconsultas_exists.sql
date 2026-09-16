SELECT 
    A.id_transaccion,
    A.id_cuenta,
    A.monto,
    A.fecha_transaccion
FROM public.transacciones_bancarias A
WHERE EXISTS (
    SELECT 1 
    FROM public.transacciones_bancarias B
    WHERE B.id_cuenta = A.id_cuenta
      AND B.monto = A.monto
      AND B.fecha_transaccion = A.fecha_transaccion
      AND B.id_transaccion <> A.id_transaccion
);
