# encoding: utf-8
# Revisión 2019 (a Python 3 y base64): Pablo Ventura
# Copyright 2014 Carlos Bederián
# $Id: connection.py 455 2011-05-01 00:32:09Z carlos $

import socket
from constants import *
from base64 import b64encode
import os

class Connection(object):
    """
    Conexión punto a punto entre el servidor y un cliente.
    Se encarga de satisfacer los pedidos del cliente hasta
    que termina la conexión.
    """

    def __init__(self, socket, directory):
        # Inicializar atributos de Connection
        self.s = socket
        self.directory = directory
        self.connected = True
        self.buffer = ''

    def _recv(self):
        """
        Recibe datos y acumula en el buffer interno.

        Para uso privado del servidor.
        """
        data = self.s.recv(4096).decode("ascii")
        self.buffer += data
        if len(data) == 0:
            self.connected = False

    def read_line(self):
        """
        Espera datos hasta obtener una línea completa delimitada por el
        terminador del protocolo.

        Devuelve la línea, eliminando el terminador y los espacios en blanco
        al principio y al final.
        """
        while not EOL in self.buffer and self.connected:
            self._recv()
        if EOL in self.buffer:
            response, self.buffer = self.buffer.split(EOL, 1)
            if '\n' in response:
                error = f'{BAD_EOL} {error_messages[BAD_EOL]}{EOL}'
                self.s.send(error.encode("ascii"))
                return []
            return response.split()
        else:
            self.connected = False
            return []
            
    def get_file_listing(self):
        """
        Lista los archivos de un directorio

        """
        response = f"{CODE_OK} {error_messages[CODE_OK]}{EOL}"
        directories = os.listdir(self.directory)
        for dir in directories:
            response += dir + EOL
        response += EOL
        self.s.send(response.encode("ascii"))


    def quit(self):
        response = f"{CODE_OK} {error_messages[CODE_OK]}{EOL}"
        self.s.send(response.encode())
        self.connected = False

    def get_metadata(self, filename):
        """
        Obtiene en el server el tamaño del archivo con el nombre dado.
        Devuelve None en caso de error.
        """
        file = os.path.join(self.directory, filename)
        if os.path.isfile(file):
            response = f"{CODE_OK} {error_messages[CODE_OK]}{EOL}"
            size = os.path.getsize(file)
            response += str(size) + EOL
            self.s.send(response.encode("ascii"))
        else:
            error = f'{FILE_NOT_FOUND} {error_messages[FILE_NOT_FOUND]}{EOL}'
            self.s.send(error.encode("ascii"))

    def get_slice(self, filename, start, length):
        """
        Obtiene una parte del archivo filename, el pedazo 
        es tamaño lengtth y comienza en start
        """
        #Lamada a get_slice fue Exitosa
        response = f"{CODE_OK} {error_messages[CODE_OK]}{EOL}"
        #Abimos archivo en modo 'rb' y vamos a la posicion 'start'
        path = os.path.join(self.directory, filename)
        file_slice = open(path, "rb")
        file_slice.seek(int(start))
        #Leemos 'length' bytes del archivo solicitado y cerramos el archivo
        data_slice = file_slice.read(int(length))
        #data_slice += EOL
        file_slice.close()
        #Adjuntamos a 'response' los datos solicitados
        response += str(b64encode(data_slice).decode())
        #Enviamos 'responce'
        response += EOL
        self.s.send(response.encode("ascii"))

    def handle(self):
        """
        Atiende eventos de la conexión hasta que termina.
        """
        while self.connected:
            data = self.read_line()
            if len(data) == 0:
                self.connected = False
            else:
                if data[0] == 'quit':
                    if len(data) != 1:
                        error = f"{INVALID_ARGUMENTS} {error_messages[INVALID_ARGUMENTS]}{EOL}"
                        self.s.send(error.encode("ascii"))
                    else:
                        self.quit()
                elif data[0] == 'get_file_listing':
                    if len(data) != 1:
                        error = f"{INVALID_ARGUMENTS} {error_messages[INVALID_ARGUMENTS]}{EOL}"
                        self.s.send(error.encode("ascii"))
                    else:
                        self.get_file_listing()
                elif data[0] == 'get_metadata':
                        if len(data) != 2:
                            error = f"{INVALID_ARGUMENTS} {error_messages[INVALID_ARGUMENTS]}{EOL}"
                            self.s.send(error.encode("ascii"))
                        else:
                            self.get_metadata(data[1])
                elif data[0] == 'get_slice':
                    if len(data) != 4:
                        error = f"{INVALID_ARGUMENTS} {error_messages[INVALID_ARGUMENTS]}{EOL}"
                        print('error1')
                        self.s.send(error.encode("ascii"))
                    elif not (data[2].isnumeric() and data[3].isnumeric()):
                        error = f"{INVALID_ARGUMENTS} {error_messages[INVALID_ARGUMENTS]}{EOL}"
                        self.s.send(error.encode("ascii"))
                    elif int(data[2])<=0 and int(data[3])<=0:
                        error = f"{BAD_OFFSET} {error_messages[BAD_OFFSET]}{EOL}"
                        self.s.send(error.encode("ascii"))
                    elif not os.path.isfile( os.path.join(self.directory, data[1])):
                        error = f"{FILE_NOT_FOUND} {error_messages[FILE_NOT_FOUND]}{EOL}"
                        self.s.send(error.encode("ascii"))
                    else:
                        self.get_slice(data[1], data[2], data[3])
                else:
                    error = f"{INVALID_COMMAND} {error_messages[INVALID_COMMAND]}{EOL}"
                    self.s.send(error.encode("ascii"))
        self.s.close()