from flask import Flask, jsonify, request 
import random
import proximo_feriado

ERR_PEL_NO_ENCONTRADA = {'error':'Pelicula no encontrada'}

app = Flask(__name__)
peliculas = [
    {'id': 1, 'titulo': 'Indiana Jones', 'genero': 'Acción'},
    {'id': 2, 'titulo': 'Star Wars', 'genero': 'Acción'},
    {'id': 3, 'titulo': 'Interstellar', 'genero': 'Ciencia ficción'},
    {'id': 4, 'titulo': 'Jurassic Park', 'genero': 'Aventura'},
    {'id': 5, 'titulo': 'The Avengers', 'genero': 'Acción'},
    {'id': 6, 'titulo': 'Back to the Future', 'genero': 'Ciencia ficción'},
    {'id': 7, 'titulo': 'The Lord of the Rings', 'genero': 'Fantasía'},
    {'id': 8, 'titulo': 'The Dark Knight', 'genero': 'Acción'},
    {'id': 9, 'titulo': 'Inception', 'genero': 'Ciencia ficción'},
    {'id': 10, 'titulo': 'The Shawshank Redemption', 'genero': 'Drama'},
    {'id': 11, 'titulo': 'Pulp Fiction', 'genero': 'Crimen'},
    {'id': 12, 'titulo': 'Fight Club', 'genero': 'Drama'}
]


def obtener_peliculas():
    return jsonify(peliculas), 200


def obtener_pelicula(id):
    # Lógica para buscar la película por su ID y devolver sus detalles
    try:
        i = buscar_pelicula(id)
        pelicula_encontrada = peliculas[i]
    except TypeError:
        return jsonify(ERR_PEL_NO_ENCONTRADA), 400
    return jsonify(pelicula_encontrada), 200


def agregar_pelicula():
    nueva_pelicula = {
        'id': obtener_nuevo_id(),
        'titulo': request.json['titulo'],
        'genero': request.json['genero']
    }
    peliculas.append(nueva_pelicula)
    print(peliculas)
    return jsonify(nueva_pelicula), 201


def actualizar_pelicula(id):
    # Lógica para buscar la película por su ID y actualizar sus detalles
    try:
        i = buscar_pelicula(id)
        peliculas[i]['titulo'] = request.json['titulo']
        peliculas[i]['genero'] = request.json['genero']
        pelicula_actualizada = peliculas[i]
    except TypeError:
        return jsonify(ERR_PEL_NO_ENCONTRADA)
    return jsonify(pelicula_actualizada), 200


def eliminar_pelicula(id):
    # Lógica para buscar la película por su ID y eliminarla
    try:
        i = buscar_pelicula(id)
        peliculas.pop(i)
    except TypeError:
        return jsonify(ERR_PEL_NO_ENCONTRADA), 400
    return jsonify({'mensaje': 'Película eliminada correctamente'}), 200

# Función auxiliar para buscar peliculas
def buscar_pelicula(id):
    for i,pelicula in enumerate(peliculas):
        if peliculas[i]['id'] == id:
            return i
    return None

def obtener_nuevo_id():
    if len(peliculas) > 0:
        ultimo_id = peliculas[-1]['id']
        return ultimo_id + 1
    else:
        return 1


def peliculas_por_genero_lista(genero):
    lista = buscar_peliculas(genero)
    for pel_index in peliculas:
        if pel_index['genero'] == genero:
            lista.append(pel_index)

    return jsonify(lista), 200


def peliculas_por_titulo_lista(titulo):
    lista = []
    titulo = decodificar(titulo)

    for pel_index in peliculas:
        if titulo in pel_index['titulo']:
            lista.append(pel_index)

    return jsonify(lista), 200


def sugerir_pelicula_aleatoria():
    if len(peliculas) > 0:
        random_index = random.randint(0, len(peliculas)-1)
        return jsonify(peliculas[random_index]), 200
    else:
        return jsonify({'mensaje': 'sin peliculas para recomendar'}), 404


def sugerir_peliculas_por_genero(genero):
    lista = buscar_peliculas(genero)
    if len(lista) == 0:
        return jsonify({'mensaje': 'sin peliculas para recomendar'}), 404
    else:
        return jsonify(lista[random.randint(0, len(lista)-1)]), 200
    
def sugerir_pelicula_feriado(genero):
    prox_feriado = proximo_feriado.NextHoliday()
    prox_feriado.fetch_holidays()
    if prox_feriado.holiday:
        fecha = str(prox_feriado.holiday['dia']) + ' de ' + proximo_feriado.months[prox_feriado.holiday['mes'] - 1]
        motivo = prox_feriado.holiday['motivo']
        peliculas_por_genero = buscar_peliculas(genero)
        if peliculas_por_genero:
            pelicula = random.choice(peliculas_por_genero)
            titulo = pelicula['titulo']
            return jsonify({'fecha': fecha,
                            'motivo': motivo,
                            'pelicula': titulo
            })
        else:
            return jsonify({'mensaje': 'No se pudieron obtener peliculas'})
    else:
        return jsonify({'mensaje': 'No se pudieron obtener los feriados'})
        
def buscar_peliculas(genero):
    lista = []
    genero = decodificar(genero)
    for pel_index in peliculas:
        if pel_index['genero'] == genero:
            lista.append(pel_index)
    return lista


#Funcion auxiliar para decodificar strings
def decodificar(string):
    #decodificar strings a "utf-8
    bytes = string.encode("iso-8859-1")
    string = bytes.decode("utf-8")
    
    #reemplazar los '_' por ' '
    string = string.replace('_',' ')

    return string

app.add_url_rule('/peliculas', 'obtener_peliculas', obtener_peliculas, methods=['GET'])
app.add_url_rule('/peliculas/<int:id>', 'obtener_pelicula', obtener_pelicula, methods=['GET'])
app.add_url_rule('/peliculas', 'agregar_pelicula', agregar_pelicula, methods=['POST'])
app.add_url_rule('/peliculas/<int:id>', 'actualizar_pelicula', actualizar_pelicula, methods=['PUT'])
app.add_url_rule('/peliculas/<int:id>', 'eliminar_pelicula', eliminar_pelicula, methods=['DELETE'])
app.add_url_rule('/peliculas/lista/genero/<string:genero>', 'peliculas_por_genero_lista', peliculas_por_genero_lista, methods=['GET'])
app.add_url_rule('/peliculas/lista/titulo/<string:titulo>', 'peliculas_por_titulo_lista', peliculas_por_titulo_lista, methods=['GET'])
app.add_url_rule('/peliculas/sugerir', 'sugerir_pelicula_aleatoria', sugerir_pelicula_aleatoria, methods=['GET'])
app.add_url_rule('/peliculas/sugerir/<string:genero>', 'sugerir_peliculas_por_genero', sugerir_peliculas_por_genero, methods=['GET'])
app.add_url_rule('/peliculas/feriado/<string:genero>', 'sugerir_pelicula_feriado', sugerir_pelicula_feriado, methods=['GET'])

if __name__ == '__main__':
    app.run()
