-- Conteo por llamado bajo condiciones
-- segundo llamado 1971 proyectos - 22 conectados (al 22/06/2023)

SELECT 
	-- ************************************* -- 
    ROW_NUMBER() OVER( ORDER BY P.id) AS Nº,
    -- Programa
    '' AS ID_Programa,
    'Casa Solar' AS Programa_Agencia,
    '1.- Implementación' Tipo_de_Programa,
    'Plan de EE Sector Edificación' AS Programa_Público,
    'Desarrollo experiencias de renovación energética viviendas existentes: casa solar, abriguemos chile' AS Componente_PAEE,
    '' AS RUT_Jefatura,
    2022 AS Año,

	-- Convocatoria Beneficiario
    '' AS ID_Convocatoria_Beneficiario,
    'INI-27' AS INI_Gestidoc,
    '' AS LIC_Gestidoc,
    '' AS ID_ODOO,
	'Casa Solar 2.0' AS Nombre_Convocatoria,
	2 AS Versión_Convocatoria,
    '' AS RUT_Encargado, -- Profesional Agencia
    'Ventanilla Abierta' AS Mecanismo_de_Postulación, -- Confirmar
    '' AS Fecha_de_Ingreso_de_Gestión, -- Gestidoc
    '09/11/2021' AS Fecha_de_Publicación, -- Desde Bases
    '' AS Fecha_Cierre, --
    'Adjudicada' AS Estado_de_Ejecución_Convocatoria, -- depende de comuna
    'Agencia de Sostenibilidad Energética' AS Ejecutor_Convocatoria,
    '' AS Comentario_Convocatoria_Beneficiario,

    -- Convocatoria Proveedor
    '' AS ID_Convocatoria_Proveedor,
    '' AS INI_Gestidoc_Prov,
    '' AS LIC_Gestidoc_Prov,
    '' AS ID_ODOO_Prov,
    'Casa Solar 2.0' AS Nombre_Convocatoria_Prov,
	'' AS Versión_Convocatoria_Prov,
	'' AS RUT_Encargado_Prov,
    'Licitaciones Públicas / Concursos - Portal Mercado Público' AS Tipo_de_Adquisición,
    'Mercado Público' AS Mecanismo_de_Postulación_Prov,
    'DESDE MP LICITACION' AS ID_Adquisición, -- Por licitacion
    '' AS Fechade_Ingreso_de_Gestión, 
    '' AS Fecha_Bases_TDR, -- Gestidoc o similar
    '' AS Fecha_Aprobación_de_Bases_TDR, -- Gestidoc o similar
    'DESDE MP LICITACION' AS Fecha_de_Publicación, -- desde MP
    'DESDE MP LICITACION' AS Fecha_de_Cierre, -- desde MP
	'Adjudicada' AS Estado_de_Ejecución_Convocatoria_Prov,
    '' AS Comentario_Convocatoria_Proveedor, -- desde MP
    
    -- Beneficio
    P.id AS ID_Beneficio, -- ID Postulacion
    'Casa Solar 2.0' AS Nombre_Beneficio,
    'Familias' AS Tipo_de_Beneficiario_Indirecto,
	P.habitantes AS Cantidad_de_Beneficiarios_Indirectos,
	'' AS ID_OC,
    '' AS ID_Contrato_Gestidoc,
	'Eficiencia Energética' AS Tipo_de_Beneficio,
    'Implementación Iniciada' AS Estado_Beneficio, -- Operacion iniciada solo conectados + otros
    -- REVISAR FECHAS DE HITOS
	(SELECT fecha_estimada FROM hito_postulacion WHERE (15=hito_postulacion.id_hito AND hito_postulacion.id_postulacion=P.id)) AS Fecha_de_Inicio_de_Operación, -- DESDE BD
	(SELECT fecha_estimada FROM hito_postulacion WHERE (7=hito_postulacion.id_hito AND hito_postulacion.id_postulacion=P.id)) AS Fecha_de_Adjudicación_Beneficiario, -- FECHA PAGO
	'' AS Fecha_de_Firma_de_Contrato, -- ? de proveedor? convenio?
	'' AS Fecha_de_Finalización_Contrato, -- ? de proveedor convenio?
	(SELECT fecha_estimada FROM hito_postulacion WHERE (15=hito_postulacion.id_hito AND hito_postulacion.id_postulacion=P.id)) AS Fecha_de_Inicio_de_Beneficio , -- entrega beneficio formal
	'' AS Fecha_de_Finalización_de_Beneficio, -- 
	(SELECT SUM(monto) FROM pago WHERE P.id=pago.id_postulacion) AS Monto_Aporte_Pecuniario_Beneficiario_CLP,
	'Agencia de Sostenibilidad Energética' AS Destino_Aporte_Beneficiario,
    0 AS Monto_Aporte_Pecuniario_Proveedor_CLP,
	EA.nombre AS RUT_Proveedor, -- CAMBIAR POR RUT DE EMPRESA
	'' AS Fecha_de_Adjudicación_Proveedor,
	'Solar Fotovoltaica' AS Nombre_Tecnología_Primaria,
	'' AS Cantidad_Tecnología_Primaria,
	P.kwp AS Capacidad_Instalada_Tecnología_Primaria_kW,
	'' AS Nombre_Tecnología_Secundaria,
	'' AS Cantidad_Tecnología_Secundaria,
	'' AS Capacidad_Instalada_Tecnología_Secundaria_kW,
	'' AS Comentario_sobre_el_Beneficio,

    -- Beneficiario Natural (BN)
    U.username AS RUT_BN,
    -- P.nombre AS Nombre_Completo_BN,
    P.primer_nombre AS Nombre_BN,
	P.primer_apellido AS Apellido_Paterno_BN,
    P.segundo_apellido AS Apellido_Materno_BN,
    C.nombre AS Comuna_BN,
    P.genero AS Género_BN,
    P.etnia AS Pueblo_Originario_BN,
    PRO.latitud AS Latitud_BN,
    PRO.longitud AS Longitud_BN,
    
-- Beneficiario Jurídico (BJ)					
	'' AS RUT_BJ,
	'' AS Nombre_Completo_BJ,
	'' AS RBD,
	'' AS Comuna_BJ,
	'' AS Latitud_BJ,
	'' AS Longitud_BJ,
    
-- Postulante Natural (PN)								
	'' AS RUT_PN,
	'' AS Nombre_PN,
	'' AS Apellido_Paterno_PN,
	'' AS Apellido_Materno_PN,
	'' AS Comuna_PN,
	'' AS Género_PN,
	'' AS Pueblo_Originario_PN,
	'' AS Latitud_PN,
	'' AS Longitud_PN,

-- Postulante Jurídico (PJ)
	'' AS RUT_PJ,
	'' AS Nombre_PJ,
    '' AS RBD,
	'' AS Comuna_PJ,
	'' AS Latitud_PJ,
	'' AS Longitud_PJ,	
 
-- Consumos Energéticos - Línea Base
	(SELECT fecha_estimada FROM hito_postulacion WHERE (15=hito_postulacion.id_hito AND hito_postulacion.id_postulacion=P.id)) AS Fecha_Inicio_Período_Línea_Base,
	'' AS Fecha_Fin_Período_Línea_Base,
	'Electricidad SEN 2022' AS Nombre_Energético_Base_1,
	'' AS Consumo_Energético_Base_1, -- revisar
	'kWh' AS Unidad_Energético_Base_1,
	'BT1' AS Tipo_de_Tarifa_1, -- confirmar
	'' AS Costo_por_Unidad_de_Energético_1,	
	'' AS Nombre_Compañía_Distribuidora_del_Energético_Base_1,
    '' AS Nombre_Energético_Base_2,
	'' AS Consumo_Energético_Base_2,
	'' AS Unidad_Energético_Base_2,
	'' AS Tipo_de_Tarifa_2,
	'' AS Costo_por_Unidad_de_Energético_2,	
	'' AS Nombre_Compañía_Distribuidora_del_Energético_Base_2,
	'' AS Nombre_Energético_Base_3,
	'' AS Consumo_Energético_Base_3,
	'' AS Unidad_Energético_Base_3,
	'' AS Tipo_de_Tarifa_3,
	'' AS Costo_por_Unidad_de_Energético_3,	
	'' AS Nombre_Compañía_Distribuidora_del_Energético_Base_3, 
																																				
-- Consumos Energéticos - Período de Reporte																			
	'' AS Fecha_Inicio_Período_de_Reporte, --  instalacion?
    '' AS Fecha_Fin_Período_de_Reporte, -- un año o no?
    'Electricidad SEN 2023' AS Energético_Reporte_1,
    '' AS Consumo_Energético_Reporte_1,
    'kWh' AS Unidad_Energético_Reporte_1,
    'BT1' AS Tipo_de_Tarifa_Reporte_1,
    '' AS Costo_por_Unidad_de_Energético_1,
    '' AS Nombre_Compañía_Distribuidora_del_Energético_Reporte_1,
	'' AS Energético_Reporte_2,
    '' AS Consumo_Energético_Reporte_2,
    '' AS Unidad_Energético_Reporte_2,
    '' AS Tipo_de_Tarifa_Reporte_2,
    '' AS Costo_por_Unidad_de_Energético_2,
    '' AS Nombre_Compañía_Distribuidora_del_Energético_Reporte_2,
	'' AS Energético_Reporte_3,
    '' AS Consumo_Energético_Reporte_3,
    '' AS Unidad_Energético_Reporte_3,
    '' AS Tipo_de_Tarifa_Reporte_3,
    '' AS Costo_por_Unidad_de_Energético_3,
    '' AS Nombre_Compañía_Distribuidora_del_Energético_Reporte_3,	

-- Ahorros Potenciales			
	'' AS Energía_Evitada_Potencial,
	'' AS Energía_Generada_Potencial,
	'' AS Emisiones_Evitadas_Potenciales,
	'' AS Ahorro_Monetario_Potencial,

-- Repositorio Tecnologías	
	'' AS ID_Tecnología,
	'Panel Fotovoltaico' AS Tipo_de_Tecnología,
    PRO.inversor AS Marca,
    '' AS Modelo,
    '' AS Potencia_Nominal,
    'kW' AS Unidad_de_Potencia_Nominal,
    '' AS Eficiencia_Unidad_de_Eficiencia,
    '' AS Autonomía,
    '' AS Unidad_de_Autonomía,
    '' AS Capacidad_de_Almacenamiento,
    '' AS Unidad_de_Almacenamiento,
    '' AS Potencia_de_Entrada,
    '' AS Unidad_de_Potencia_de_Entrada,
    '' AS Potencia_de_Salida,
    '' AS Unidad_de_Potencia_de_Salida,
    '' AS Nombre_de_Periférico,
    '' AS Tipo_de_Periférico,
    
-- OTROS
    P.nombre AS Nombre_Completo_BN,
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


