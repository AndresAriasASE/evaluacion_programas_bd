import json
import logging
import pandas as pd
import mysql.connector
from mysql.connector import Error
pd.options.display.max_columns = None


def log_config(log_file):
    # Creación del logger que muestra la información únicamente por fichero.
    date_fmt='%m/%d/%Y %H:%M:%S'
    fmt = '%(asctime)-5s %(name)-15s %(levelname)-8s %(message)s'

    if logging.getLogger('').hasHandlers():
        logging.getLogger('').handlers.clear()

    logging.basicConfig(
        level  = logging.INFO,
        filename = log_file, 
        filemode = 'w',
        format = fmt,
        datefmt = date_fmt,
        encoding ='utf-8'
    )

    # Handler nivel info con salida a consola
    consola_handler = logging.StreamHandler()
    consola_handler.setLevel(logging.INFO)
    consola_handler_format = logging.Formatter(fmt=fmt, datefmt = date_fmt)
    consola_handler.setFormatter(consola_handler_format)
    logging.getLogger('').addHandler(consola_handler)
    logging.info('Log creado')

#Conexión instancia
def create_connection(json_host_file, log_info=True):
    connection = None
    try:
        #abre archivo de configuración de conexion con BD
        with open(json_host_file) as map_file:
            data = json.load(map_file)
        #extrae datos y realiza la conexión
        host_name=data['host_name']
        user_name=data['user_name']
        user_password=data['user_password']
        db_name=data['db_name']
        connection = mysql.connector.connect(
            host=host_name, user=user_name,passwd=user_password, database=db_name)
        if log_info:
            logging.info(f'Conexión a Base de datos MySQL "{db_name}" exitosa')
    except Error as e:
        logging.error(f'Error: "{e}"')

    return connection

# GENERAL INSERT / UPDATE / DELETE
def execute_query(connection, query, log_info=True):
    cursor = connection.cursor()
    try:
        cursor.execute(query)
        connection.commit()
        if log_info:
            logging.info('Consulta INSERT/UPDATE/DELETE exitosa')
    except Error as e:
        logging.error(f'Error: "{e}"')

# INSERT
def insert_from_df(table_name, df, log_info=True):
    if log_info:
        logging.info('Generando consulta INSERT SQL')
    #obtiene listado de columnas desde df
    c = 0
    for i in df.columns:
        if c == 0:
            columns = '(' + i
            c=+1
        else:
            columns = columns +', ' + i
    columns = columns + ')'

    #obtiene listado de valores  desde df
    values = ''
    for i in df.values:
        values_i = str(tuple(j for j in i))
        values = values + values_i + ', '
    values = values[:-2]

    #construye la consulta
    q = f"""
    INSERT INTO {table_name} {columns}
    VALUES {values};
    """

    return q

#SELECT ALL
def select_all_table(table_name, connection, log_info=True):
    q = f"""
    SELECT * FROM {table_name}
    ;
    """
    try:
        df = pd.read_sql_query(q, connection)
        if log_info:
            logging.info(f'Consulta "SELECT * FROM {table_name}" exitosa')
    except:
        logging.error(f'Error "SELECT * FROM {table_name}"')
        
    return df

#carga datos desde excel
def import_data_excel(excel_file, sheet_name, log_info=True):
    #carga archivo en un dataframe
    try:
        df = pd.read_excel(excel_file, sheet_name)
        if log_info:
            logging.info(f'Archivo: {excel_file} / hoja: "{sheet_name}" cargado correctamente')
    except:
        logging.error(f'No se ha cargado el archivo: {excel_file} / hoja: "{sheet_name}"')
        
    return df

#procesa los datos y limpia df
def clean_df(df, table_name, map_file, connection, log_info=True):
    try:
        with open(map_file) as mapping:
            map = json.load(mapping)

        #renombra columnas
        rename = {}
        for i in map[table_name]:
            if i['Excel_Column'] in df.columns.tolist():
                rename[i['Excel_Column']]=i['Field']
        df.rename(columns = rename, inplace=True)
        if log_info:
            logging.info(f'Columnas renombradas: {rename}') 

        #elimina columnas que no estan en la BD
        df = df[rename.values()].copy()
        
        #elimina filas nulas
        for i in map[table_name]:
            f = i['Field']
            n = i['Null']
            if f in df.columns.tolist() and n == 'NO':
                null_rows = df[df[f].isna()]
                if not null_rows.empty:
                    if log_info:
                        logging.info(f'Filas nulas a descartar: {null_rows}')
                    df.dropna(subset=[i['Field']], inplace=True)
                
        #elimina duplicados
        for i in map[table_name]:
            f = i['Field']
            k = i['Key']
            if f in df.columns.tolist() and k in ['PRI','UNI']:
                dupl_rows = df[df.duplicated(subset=f, keep='last')]
                if not dupl_rows.empty:
                    if log_info:
                        logging.info(f'Filas duplicadas a descartar:\n {dupl_rows}')
                    df.drop_duplicates(subset=f, keep='first', inplace=True)
        
        #cambia tipo de datos
        for i in map[table_name]:
            f = i['Field']
            t = i['Type']
            if f in df.columns.tolist():
                if t == 'int':
                    df[f] = df[f].astype('int64')
                elif 'varchar' in i['Type']:
                    df[f] = df[f].astype('str')
                #elif date
                #elif etc
        df_types = pd.DataFrame([df.dtypes])
        if log_info:
            logging.info(f'Nuevos tipos de datos:\n {df_types}')

        #elimina duplicados existentes en BD
        #No considera otros duplicados en la BD, solo PK
        df_bd = select_all_table(table_name, connection, log_info=False)
        if not df_bd.empty:
            for i in map[table_name]:
                f = i['Field']
                k = i['Key']
                if f in df.columns.tolist() and k=='PRI':
                    colab_merged = pd.merge(df_bd.set_index(f), df.set_index(f), on=f, how="inner")
                    df.set_index(f, inplace=True)
                    if log_info:
                        logging.info(f'Llaves Primarias existentes en BD a descartar:\n {colab_merged.index.tolist()}')
                    for j in colab_merged.index:
                        df.drop(j, inplace=True)
                    df = df.reset_index()

    except:
        logging.error('Problema al transformar datos')      

    return df