import json
import pandas as pd
import mysql.connector
from mysql.connector import Error

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

    print('Eliminando columnas que no estan en la BD...')
    try:
        list1 = df.columns.tolist()
        list2 = list(map[table_name].keys())
        #cols_lost = [i for i in list1 + list2 if i not in list1] #columnas que no estan en el excel
        cols_out = [i for i in list1 + list2 if i not in list2] #columas que no estan en la BD
        df.drop(columns=cols_out, inplace=True)
    except:
        print('Error')


    print('Eliminando filas sin datos y que deberían tener')
    try:
        for i in df.columns:
            if map[table_name][i]['NN'] == 1:
                df.dropna(subset=[i], inplace=True)
    except:
        print('Error')

    print('Eliminando duplicados...') #mantiene primera ocurrencia
    try:
        for j in df.columns:
            if map[table_name][j]['UQ'] == 1:
                df.drop_duplicates(subset=[j], keep='first', inplace=True)
    except:
        print('Error')

    print('Conviertiendo tipos de datos...')
    try:
        for i in df.columns:
            data_type = map[table_name][i]['type']
            df[i] = df[i].astype(data_type)
    except:
        print('Error')

    print('Realizando cambio de nombres de columnas...') #(nombres en BD)
    try:
        rename = {}
        for k in df.columns:
            bd_column_name = map[table_name][k]['bd_column_name']
            rename[k]= bd_column_name
        print(f'\nMapeo de columnas: {rename}') 
        df.rename(columns = rename, inplace=True)
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

        for i in df_bd.columns:
            for j in map[table_name]:
                if map[table_name][j]['bd_column_name'] == i and map[table_name][j]['UQ'] == 1:
                
                    colab_merged = pd.merge(df_bd.set_index(i), df_new.set_index(i), on=i, how="inner")
                    df_new.set_index(i, inplace=True)
                    for k in colab_merged.index:
                        df_new.drop(k, inplace=True)
                    df_new = df_new.reset_index()
            
    except:
        print('Error')

    return df_new