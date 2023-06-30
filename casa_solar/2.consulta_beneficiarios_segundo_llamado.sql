-- Conteo por llamado bajo condiciones
-- primer llamado 2825 proyectos - 2486 conectados (al 22/06/2023)
-- segundo llamado 1971 proyectos - 22 conectados (al 22/06/2023)

SELECT 
	-- ************************************* -- 
    -- Programa

	-- Convocatoria Beneficiario
    NULL AS ID_ODOO,
	'Casa Solar' AS Nombre_Convocatoria,
	PR.id_periodo AS Versión_Convocatoria,
    NULL AS RUT_Encargado, -- Profesional Agencia
    'Ventanilla Abierta' AS Mecanismo_de_Postulación, -- Confirmar
    NULL AS Fecha_de_Ingreso_de_Gestión, -- Gestidoc
    'POR BASE' AS Fecha_de_Publicación, -- Desde Bases  P1 '05/11/2020' y P2 '09/11/2021'
    'POR COMUNA' AS Fecha_Cierre, -- depende de comuna
    NULL AS Estado_de_Ejecución_Convocatoria, -- depende de comuna
    'Agencia de Sostenibilidad Energética' AS Ejecutor_Convocatoria,
    NULL AS Comentario_Convocatoria_Beneficiario,

    -- Convocatoria Proveedor
    NULL AS ID_Convocatoria_Proveedor, -- POR ZONA
    NULL AS INI_Gestidoc_Prov,
    NULL AS LIC_Gestidoc_Prov,
    NULL AS ID_ODOO_Prov,
    NULL AS Nombre_Convocatoria_Prov,
	NULL AS Versión_Convocatoria_Prov,
	NULL AS RUT_Encargado_Prov,
    NULL AS Tipo_de_Adquisición,
    NULL AS Mecanismo_de_Postulación_Prov,
    NULL AS ID_Adquisición,
    NULL AS Fechade_Ingreso_de_Gestión,
    NULL AS Fecha_Bases_TDR, 
    NULL AS Fecha_Aprobación_de_Bases_TDR,
    NULL AS Fecha_de_Publicación, 
    NULL AS Fecha_de_Cierre,
	NULL AS Estado_de_Ejecución_Convocatoria_Prov,
    NULL AS Comentario_Convocatoria_Proveedor,
    
    -- Beneficio
    P.id AS ID_Beneficio, -- ID Postulacion
    'Programa Casa Solar' AS Nombre_Beneficio,
    'Familias' AS Tipo_de_Beneficiario_Indirecto,
	P.habitantes AS Cantidad_de_Beneficiarios_Indirectos,
	NULL AS ID_OC,
    NULL AS ID_Contrato_Gestidoc,
	'Eficiencia Energética' AS Tipo_de_Beneficio,
    'Operación Iniciada' AS Estado_Beneficio, -- Operacion iniciada solo conectados + otros
    -- REVISAR FECHAS DE HITOS
	(SELECT fecha_estimada FROM hito_postulacion WHERE (15=hito_postulacion.id_hito AND hito_postulacion.id_postulacion=P.id)) AS Fecha_de_Inicio_de_Operación, -- DESDE BD
	(SELECT fecha_estimada FROM hito_postulacion WHERE (7=hito_postulacion.id_hito AND hito_postulacion.id_postulacion=P.id)) AS Fecha_de_Adjudicación_Beneficiario, -- FECHA PAGO
	(SELECT fecha_estimada FROM hito_postulacion WHERE (7=hito_postulacion.id_hito AND hito_postulacion.id_postulacion=P.id)) AS Fecha_de_Firma_de_Contrato, -- ? de proveedor? convenio?
	(SELECT fecha_estimada FROM hito_postulacion WHERE (15=hito_postulacion.id_hito AND hito_postulacion.id_postulacion=P.id)) AS Fecha_de_Finalización_Contrato, -- ? de proveedor convenio?
	(SELECT fecha_estimada FROM hito_postulacion WHERE (15=hito_postulacion.id_hito AND hito_postulacion.id_postulacion=P.id)) AS Fecha_de_Inicio_de_Beneficio , -- entrega beneficio formal
	(SELECT fecha_estimada FROM hito_postulacion WHERE (15=hito_postulacion.id_hito AND hito_postulacion.id_postulacion=P.id)) AS Fecha_de_Finalización_de_Beneficio, -- 
	(SELECT SUM(monto) FROM pago WHERE P.id=pago.id_postulacion) AS Monto_Aporte_Pecuniario_Beneficiario_CLP,
	NULL AS Destino_Aporte_Beneficiario,
    0 AS Monto_Aporte_Pecuniario_Proveedor_CLP,
	EA.nombre AS RUT_Proveedor, -- CAMBIAR POR RUT DE EMPRESA
	NULL AS Fecha_de_Adjudicación_Proveedor,
	'Solar Fotovoltaica' AS Nombre_Tecnología_Primaria,
	NULL AS Cantidad_Tecnología_Primaria,
	P.kwp AS Capacidad_Instalada_Tecnología_Primaria_kW,
	NULL AS Nombre_Tecnología_Secundaria,
	NULL AS Cantidad_Tecnología_Secundaria,
	NULL AS Capacidad_Instalada_Tecnología_Secundaria_kW,
	NULL AS Comentario_sobre_el_Beneficio,

    -- Beneficiario Natural (BN)
    U.username AS RUT_BN,
	P.nombre AS Nombre_Completo_BN,
    P.primer_nombre AS Primer_Nombre_BN,
    P.segundo_nombre AS Segundo_Nombre_BN,
	primer_apellido AS Apellido_Paterno_BN,
    segundo_apellido AS Apellido_Materno_BN,
    C.nombre AS Comuna_BN,
    P.genero AS Género_BN,
    P.etnia AS Pueblo_Originario_BN,
    PRO.latitud AS Latitud_BN,
    PRO.longitud AS Longitud_BN,
    
-- Beneficiario Jurídico (BJ)					
-- NO APLICA	
    
-- Postulante Natural (PN)								
--    U.username AS RUT_PN,
--    P.nombre AS Nombre_Completo_PN,
--    P.primer_nombre AS Primer_Nombre_PN,
--    P.segundo_nombre AS Segundo_Nombre_PN,
--    primer_apellido AS Apellido_Paterno_PN,
--    segundo_apellido AS Apellido_Materno_PN,
--    C.nombre AS Comuna_PN,
--    P.genero AS Género_PN,
--    P.etnia AS Pueblo_Originario_PN,
--    PRO.latitud AS Latitud_PN,
--    PRO.longitud AS Longitud_PN,

-- Postulante Jurídico (PJ)
-- NO APLICA					
 
-- Consumos Energéticos - Línea Base
	NULL AS Fecha_Inicio_Período_Línea_Base,
	NULL AS Fecha_Fin_Período_Línea_Base,
	'Electricidad' AS Nombre_Energético_Base_1,
	-- (SELECT promedio_consumo FROM ficha_tecnica WHERE ficha_tecnica.id_postulacion=P.id) AS Consumo_Energético_Base_1, -- revisar
	'kWh' AS Unidad_Energético_Base_1,
	'BT1' AS Tipo_de_Tarifa_1, -- confirmar
	NULL AS Costo_por_Unidad_de_Energético_1,	
	-- (SELECT distribuidora FROM ficha_tecnica WHERE ficha_tecnica.id_postulacion=P.id) AS Nombre_Compañía_Distribuidora_del_Energético_Base_1,
	NULL AS Nombre_Energético_Base_2,
	NULL AS Consumo_Energético_Base_2,
	NULL AS Unidad_Energético_Base_2,
	NULL AS Tipo_de_Tarifa_2,
	NULL AS Costo_por_Unidad_de_Energético_2,	
	NULL AS Nombre_Compañía_Distribuidora_del_Energético_Base_2,
	NULL AS Nombre_Energético_Base_3,
	NULL AS Consumo_Energético_Base_3,
	NULL AS Unidad_Energético_Base_3,
	NULL AS Tipo_de_Tarifa_3,
	NULL AS Costo_por_Unidad_de_Energético_3,	
	NULL AS Nombre_Compañía_Distribuidora_del_Energético_Base_3, 
																																				
-- Consumos Energéticos - Período de Reporte																			
	NULL AS Fecha_Inicio_Período_de_Reporte, --  instalacion?
    NULL AS Fecha_Fin_Período_de_Reporte, -- un año o no?
    'Electricidad' AS Energético_Reporte_1,
    NULL AS Consumo_Energético_Reporte_1,
    'kWh' AS Unidad_Energético_Reporte_1,
    'BT1' AS Tipo_de_Tarifa_Reporte_1,
    NULL AS Costo_por_Unidad_de_Energético_1,
    -- (SELECT distribuidora FROM ficha_tecnica WHERE ficha_tecnica.id_postulacion=P.id) AS Nombre_Compañía_Distribuidora_del_Energético_Reporte_1,
	NULL AS Energético_Reporte_2,
    NULL AS Consumo_Energético_Reporte_2,
    NULL AS Unidad_Energético_Reporte_2,
    NULL AS Tipo_de_Tarifa_Reporte_2,
    NULL AS Costo_por_Unidad_de_Energético_2,
    NULL AS Nombre_Compañía_Distribuidora_del_Energético_Reporte_2,
	NULL AS Energético_Reporte_3,
    NULL AS Consumo_Energético_Reporte_3,
    NULL AS Unidad_Energético_Reporte_3,
    NULL AS Tipo_de_Tarifa_Reporte_3,
    NULL AS Costo_por_Unidad_de_Energético_3,
    NULL AS Nombre_Compañía_Distribuidora_del_Energético_Reporte_3,	

-- Ahorros Potenciales			
	NULL AS Energía_Evitada_Potencial,
	NULL AS Energía_Generada_Potencial,
	NULL AS Emisiones_Evitadas_Potenciales,
	NULL AS Ahorro_Monetario_Potencial,

-- Repositorio Tecnologías	
	NULL AS ID_Tecnología,
	'Panel Fotovoltaico' AS Tipo_de_Tecnología,
    PRO.inversor AS Marca,
    NULL AS Modelo,
    NULL AS Potencia_Nominal,
    'kW' AS Unidad_de_Potencia_Nominal,
    NULL AS Eficiencia_Unidad_de_Eficiencia,
    NULL AS Autonomía,
    NULL AS Unidad_de_Autonomía,
    NULL AS Capacidad_de_Almacenamiento,
    NULL AS Unidad_de_Almacenamiento,
    NULL AS Potencia_de_Entrada,
    NULL AS Unidad_de_Potencia_de_Entrada,
    NULL AS Potencia_de_Salida,
    NULL AS Unidad_de_Potencia_de_Salida,
    NULL AS Nombre_de_Periférico,
    NULL AS Tipo_de_Periférico,
    
-- OTROS
    -- (SELECT numero_cliente_electricidad FROM ficha_tecnica WHERE ficha_tecnica.id_postulacion=P.id) AS NCLIENTE,
	PG.estado AS Estado_Pago,
    PG.tipo AS Tipo,
    MAX(HP.id_hito) AS Hito_maximo,
    PC.ceco AS CECO,
    PR.fecha_apertura,
    PR.fecha_cierre
    
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
    LEFT JOIN ficha_tecnica as FT ON HP.id_postulacion=FT.id_postulacion
    
WHERE (
    PR.id_periodo = 2 and
    (PG.tipo = 'final' and PG.estado = 'aprobado') and
    (P.desistir IS NULL or P.desistir=0)
    )
GROUP BY P.id;


