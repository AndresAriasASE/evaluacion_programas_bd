import json
import pandas as pd
import mysql.connector
import logging
from mysql.connector import Erro

#Conexión instancia
def create_connection(json_host_file):
    connection = None
    print('Estableciendo Conexión..')
    try:
        #abre archivo de configuración de conexion con BD
        with open(json_host_file) as json_file:
            data = json.load(json_file)
        #extrae datos y realiza la conexión
        host_name=data['host_name']
        user_name=data['user_name']
        user_password=data['user_password']
        db_name=data['db_name']
        connection = mysql.connector.connect(
            host=host_name, user=user_name,passwd=user_password, database=db_name)
        print(f'Conexión a Base de datos MySQL "{db_name}" exitosa')
    except Error as e:
        print(f'Error: "{e}"')

    return connection

# GENERAL INSERT / UPDATE / DELETE
def execute_query(connection, query):
    cursor = connection.cursor()
    try:
        cursor.execute(query)
        connection.commit()
        print('Consulta INSERT/UPDATE/DELETE exitosa')
    except Error as e:
        print(f'Error: "{e}"')

# INSERT
def insert_from_df(table_name, df):
    print('Generando consulta INSERT SQL')
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

#SELECT
def select_all_table(table_name, connection):
    q = f"""
    SELECT * FROM {table_name}
    ;
    """
    try:
        df = pd.read_sql_query(q, connection)
        print('Consulta SELECT exitosa')
    except:
        print('Error')
        
    return df

#carga datos desde excel
def import_data_excel(excel_file, sheet_name):
    #carga archivo en un dataframe
    df = pd.read_excel(excel_file, sheet_name)
    print('\nArchivo cargado correctamente en dataframe')

    return df

#procesa los datos
#limpia df
def clean_df(df, table_name, json_file):
    with open(json_file) as json_file_map:
        map = json.load(json_file_map)

    print('Realizando filtro y cambio de nombres de columnas...') #(nombres en BD)
    try:
        rename = {}
        for i in map[table_name]:
            if i['Excel_Column'] in df.columns.tolist():
                rename[i['Excel_Column']]=i['Field']
        df.rename(columns = rename, inplace=True)
        #elimina columnas que no estan en la BD
        df = df[rename.values()].copy()
    except:
        print('Error filtro ycambio de nombres de columnas')


    print('Eliminando filas sin datos y que deberían tener')
    try:
        for i in map[table_name]:
            if i['Field'] in df.columns.tolist() and i['Null'] == 'NO':
                df.dropna(subset=[i['Field']], inplace=True)
            
    except:
        print('Error')

    print('Eliminando duplicados...') #mantiene primera ocurrencia
    try:
        for i in map[table_name]:
            if i['Field'] in df.columns.tolist() and i['Key'] in ['PRI','UNI']:
                df.drop_duplicates(subset=i['Field'], keep='first', inplace=True)
    except:
        print('Error eliminando duplicados')


    print('Conviertiendo tipos de datos...')
    try:
        for i in map[table_name]:
            if i['Field'] in df.columns.tolist():
                if i['Type'] == 'int':
                    df[i['Field']] = df[i['Field']].astype('int64')
                elif 'varchar' in i['Type']:
                    df[i['Field']] = df[i['Field']].astype('str')
                #elif date
                #elif etc
    except:
        print('Error')



    return df

#procesa los datos
#busca datos existentes en BD
def delete_duplicates_pk(connection, table_name, json_file, df_new):
    try: 
        with open(json_file) as json_file_map:
            map = json.load(json_file_map)

        df_bd = select_all_table(table_name, connection)

        if not df_bd.empty:

            for i in map[table_name]:
                if i['Field'] in df_new.columns.tolist() and i['Key']=='PRI':
                        colab_merged = pd.merge(df_bd.set_index(i['Field']), df_new.set_index(i['Field']), on=i['Field'], how="inner")
                        df_new.set_index(i['Field'], inplace=True)
                        for k in colab_merged.index:
                            df_new.drop(k, inplace=True)
                        df_new = df_new.reset_index()

    except:
        print('Error')

    return df_new