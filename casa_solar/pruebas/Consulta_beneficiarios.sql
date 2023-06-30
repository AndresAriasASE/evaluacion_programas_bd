-- conteo todos los beneficiarios con sistemas instalados
SELECT count(DISTINCT  postulacion.user_id) FROM hito_postulacion JOIN postulacion ON hito_postulacion.id_postulacion=postulacion.id WHERE id_hito=15;

-- listado de todos los beneficiarios con sistemas instalados
SELECT P.nombre AS Nombre, PR.id_periodo AS Convocatoria, C.nombre AS Comuna, R.nombre AS Región, U.username AS Rut
FROM hito_postulacion AS HP
	LEFT JOIN postulacion AS P ON HP.id_postulacion=P.id 
	LEFT JOIN periodo_comuna AS PC ON P.id_periodo_comuna=PC.id
	LEFT JOIN periodo_region AS PR ON PC.id_periodo_region=PR.id
	LEFT JOIN comuna AS C ON PC.id_comuna=C.id
    LEFT JOIN region AS R ON PR.id_region=R.id
    LEFT JOIN user AS U ON P.user_id=U.id
WHERE (HP.id_hito=15);

-- Conteo por llamado bajo condiciones
SELECT PR.id_periodo AS Llamado, COUNT(DISTINCT U.username) AS Cantidad_beneficiarios
FROM hito_postulacion AS HP 
	LEFT JOIN postulacion AS P ON HP.id_postulacion=P.id 
	LEFT JOIN periodo_comuna AS PC ON P.id_periodo_comuna=PC.id
	LEFT JOIN periodo_region AS PR ON PC.id_periodo_region=PR.id
	LEFT JOIN comuna AS C ON PC.id_comuna=C.id
    LEFT JOIN region AS R ON PR.id_region=R.id
    LEFT JOIN user AS U ON P.user_id=U.id
WHERE (
	-- PR.id_periodo = 1 and
    HP.id_hito = 15 and
	U.username IS NOT NULL and
    P.id_empresa_adjudicada IS NOT NULL and
    P.desistir != 1
)
GROUP BY PR.id_periodo;


SELECT *
FROM hito_postulacion AS HP 
	LEFT JOIN postulacion AS P ON HP.id_postulacion=P.id 
	LEFT JOIN periodo_comuna AS PC ON P.id_periodo_comuna=PC.id
	LEFT JOIN periodo_region AS PR ON PC.id_periodo_region=PR.id
	LEFT JOIN comuna AS C ON PC.id_comuna=C.id
    LEFT JOIN region AS R ON PR.id_region=R.id
    LEFT JOIN user AS U ON P.user_id=U.id
WHERE (
	-- PR.id_periodo = 1 and
    HP.id_hito = 1 and
	U.username IS NOT NULL and
    P.id_empresa_adjudicada IS NOT NULL
);



-- Datos planilla
SELECT 
	PR.id_periodo AS Llamado, 
    P.id AS ID_Postulación,
-- Tabla Beneficiario Natural (BN)
-- SI P.propietario = 0								
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
    P.kwp AS Potencia_Paneles
    
FROM hito_postulacion AS HP 
	LEFT JOIN postulacion AS P ON HP.id_postulacion=P.id 
	LEFT JOIN periodo_comuna AS PC ON P.id_periodo_comuna=PC.id
	LEFT JOIN periodo_region AS PR ON PC.id_periodo_region=PR.id
	LEFT JOIN comuna AS C ON PC.id_comuna=C.id
    LEFT JOIN region AS R ON PR.id_region=R.id
    LEFT JOIN user AS U ON P.user_id=U.id
    LEFT JOIN empresa_adjudicada AS EA ON P.id_empresa_adjudicada=EA.id
    LEFT JOIN consumo AS CON ON P.consumo_mensual=CON.id
    LEFT JOIN propiedad AS PRO ON P.id=PRO.postulacion_id
    
WHERE (
	PR.id_periodo = 1 and
    HP.id_hito = 15 and
	U.username IS NOT NULL and
    P.id_empresa_adjudicada IS NOT NULL and
    p.desistir = 0
);

-- Datos individuales

SELECT * FROM postulacion 
WHERE ( postulacion.id IN (2606,3045,4955,5756,5841,5942,6207,6871,7522,8084,8999,9363));


