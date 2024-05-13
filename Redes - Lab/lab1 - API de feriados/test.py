import requests

# Obtener todas las películas
response = requests.get('http://localhost:5000/peliculas')
peliculas = response.json()
print("Películas existentes:")
for pelicula in peliculas:
    print(f"ID: {pelicula['id']}, Título: {pelicula['titulo']}, Género: {pelicula['genero']}")
print()

# Agregar una nueva película
nueva_pelicula = {
    'titulo': 'Pelicula de prueba',
    'genero': 'Acción'
}
response = requests.post('http://localhost:5000/peliculas', json=nueva_pelicula)
if response.status_code == 201:
    pelicula_agregada = response.json()
    print("Película agregada:")
    print(f"ID: {pelicula_agregada['id']}, Título: {pelicula_agregada['titulo']}, Género: {pelicula_agregada['genero']}")
else:
    print("Error al agregar la película.")
print()

# Obtener detalles de una película específica
id_pelicula = 1  # ID de la película a obtener
response = requests.get(f'http://localhost:5000/peliculas/{id_pelicula}')
if response.status_code == 200:
    pelicula = response.json()
    print("Detalles de la película:")
    print(f"ID: {pelicula['id']}, Título: {pelicula['titulo']}, Género: {pelicula['genero']}")
else:
    print("Error al obtener los detalles de la película.")
print()

# Actualizar los detalles de una película
id_pelicula = 1  # ID de la película a actualizar
datos_actualizados = {
    'titulo': 'Nuevo título',
    'genero': 'Comedia'
}
response = requests.put(f'http://localhost:5000/peliculas/{id_pelicula}', json=datos_actualizados)
if response.status_code == 200:
    pelicula_actualizada = response.json()
    print("Película actualizada:")
    print(f"ID: {pelicula_actualizada['id']}, Título: {pelicula_actualizada['titulo']}, Género: {pelicula_actualizada['genero']}")
else:
    print("Error al actualizar la película.")
print()

# Eliminar una película
id_pelicula = 1  # ID de la película a eliminar
response = requests.delete(f'http://localhost:5000/peliculas/{id_pelicula}')
if response.status_code == 200:
    print("Película eliminada correctamente.")
else:
    print("Error al eliminar la película.")



# PARTE 4
# Devuelve una lista de peliculas del genero enviado por el cliente
genero_pelicula = 'Drama' # GENERO de la lista de peliculas a obtener
response = requests.get(f'http://localhost:5000/peliculas/lista/genero/{genero_pelicula}')

if response.status_code == 200:
    lista_genero = response.json()
    check = (len(lista_genero) > 0)
    for index in lista_genero:
        check = check and (index['genero'] == genero_pelicula)
        if not check:
            break
    mensaje = "Prueba EXITOSA, " if check else "Prueba FALLIDA, no "
    print(f"{mensaje}todas las pelicula son de {genero_pelicula}")
else:
    print(f"Error al obtener la lista de películas de {genero_pelicula}.")


# Devuelve una lista de peliculas con un string en el titulo
titulo_pelicula = 'The' # String contenido en la lista de peliculas a obtener
response = requests.get(f'http://localhost:5000/peliculas/lista/titulo/{titulo_pelicula}')
if response.status_code == 200:
    lista_titulo = response.json()
    check = (len(lista_titulo) > 0)
    for index in lista_titulo:
        check = check and (titulo_pelicula in index['titulo'])
        if not check:
            break
    mensaje = "Prueba EXITOSA, " if check else "Prueba FALLIDA, no "
    print(f"{mensaje}todas las peliculas contienen {titulo_pelicula} en su titulo")
else:
    print(f"Error al obtener la lista de películas con {titulo_pelicula} en su titulo.")


# Obtener una pelicula aleatoria
# Test:= pelicula_aleatoria in peliculas
response = requests.get(f'http://localhost:5000/peliculas/sugerir')
if response.status_code == 200:
    check = response.json() in peliculas
    mensaje = "Prueba EXITOSA, " if check else "Prueba FALLIDA, "
    print(f"{mensaje} al obtener una pelicula aleatoria")
else:
    print("Error. lista vacia para testeo")


# Obtener una pelicula aleatoria de un determinado genero
# Test:= pelicula_aleatoria in peliculas
genero_pelicula = 'Drama' # GENERO parametro de entrada
response = requests.get(f'http://localhost:5000/peliculas/sugerir/{genero_pelicula}')
print(response.status_code)
if response.status_code == 200:
    check = response.json() in peliculas
    mensaje = "Prueba EXITOSA, " if check else "Prueba FALLIDA, "
    print(f"{mensaje} al obtener pelicula aleatoria del genero {genero_pelicula}")
else:
    print("Error. lista vacia para testeo")

# Sugerir una pelicula para el próximo feriado
genero = 'Drama'
response = requests.get(f'http://localhost:5000/peliculas/feriado/{genero}')
print(response.status_code)
if response.status_code == 200:
    feriado_pelicula =response.json()
    if feriado_pelicula['fecha'] and feriado_pelicula['motivo']:
        print(f"Fecha: {feriado_pelicula['fecha']}, motivo: {feriado_pelicula['motivo']}")
    else:
        print('No se pudo obtener el feriado')
    if feriado_pelicula['pelicula']:
        print(f"Pelicula: {feriado_pelicula['pelicula']}")
    else:
        print('No se pudo obtener la pelicula')
else:
    print('Error al obtener la pelicula para el proximo feriado')