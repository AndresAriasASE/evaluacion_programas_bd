-- Conteo por llamado bajo condiciones
-- primer llamado 2825 proyectos - 2486 conectados
-- segundo llamado 1971 proyectos - 22 conectados

SELECT 	
    -- informacion de postulacion
    -- NULL AS TempField,
    PR.id_periodo AS Llamado,
    P.id AS ID_Postulación,
    MAX(HP.id_hito) AS Hito_Cumplido,
    -- informacion beneficiario Natural (BN)
    U.username AS RUT_BN,
	P.nombre AS Nombre_Completo_BN,
    P.primer_nombre AS Nombre_BN,
	primer_apellido AS Apellido_Paterno_BN,
    segundo_apellido AS Apellido_Materno_BN,
    C.nombre AS Comuna_BN,
    P.genero AS Género_BN,
    P.etnia AS Pueblo_Originario_BN,
    PRO.latitud AS Latitud_BN,
    PRO.longitud AS Longitud_BN,
-- Consumos Energéticos - LB																		
	CON.kwh AS Consumo_Energético_Base,
-- Convocatoria Proveedor															
	PC.ceco AS CECO,
    EA.nombre AS Empresa,
-- Tecnologia
	PRO.inversor AS Inversor,
    P.kwp AS Potencia_Paneles,
-- Pagos
	PG.estado AS Estado_Pago,
    PG.tipo AS Tipo
    
FROM hito_postulacion AS HP
	LEFT JOIN postulacion AS P ON HP.id_postulacion=P.id 
	LEFT JOIN periodo_comuna AS PC ON P.id_periodo_comuna=PC.id
	LEFT JOIN periodo_region AS PR ON PC.id_periodo_region=PR.id
	LEFT JOIN comuna AS C ON PC.id_comuna=C.id
    LEFT JOIN region AS R ON PR.id_region=R.id
    LEFT JOIN user AS U ON P.user_id=U.id
	LEFT JOIN empresa_adjudicada AS EA ON P.id_empresa_adjudicada=EA.id
    LEFT JOIN consumo AS CON ON P.consumo_mensual=CON.id
    LEFT JOIN pago AS PG ON P.id=PG.id_postulacion
    LEFT JOIN propiedad AS PRO ON PG.id_postulacion=PRO.id
WHERE (
    PR.id_periodo = 1 and
    (PG.tipo = 'final' and PG.estado = 'aprobado') and
    (P.desistir IS NULL or P.desistir=0)
    )
GROUP BY P.id;


