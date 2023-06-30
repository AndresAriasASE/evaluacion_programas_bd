# El siguiente script genera un array con 100 números aleatorios y calcula la suma de todos ellos
# ===============================================================================================
import logging
import numpy as np

# Creación del logger que muestra la información únicamente por fichero.
logging.basicConfig(
    format = '%(asctime)-5s %(name)-15s %(levelname)-8s %(message)s',
    level  = logging.DEBUG,      # Nivel de los eventos que se registran en el logger
    filename = "C:/Users/aarias/Documents/GitHub/evaluacion_programas_code/pruebas_iniciales/code/logs.log", # Fichero en el que se escriben los logs
    filemode = "w",              # a ("append"), en cada escritura, si el archivo de logs ya existe,
    datefmt='%m/%d/%Y %H:%M:%S'
)

logging.info('Inicio main script')
numeros = np.random.rand(1,100)
logging.info('Numeros aleatorios simulados')
numeros.sum()
logging.info('Suma calculada')
logging.error('Fin main script')
logging.shutdown()