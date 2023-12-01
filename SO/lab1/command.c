#include <assert.h>
#include <glib.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stddef.h>
#include "command.h" 
#include "strextra.h"

//struct Glib Queue

struct scommand_s {
    GQueue *sc_arg;
    char *sc_file_in;
    char *sc_file_out;
};

scommand scommand_new(void) {
    // Allocating memory for the structure.
    scommand new_sc = malloc(sizeof(struct scommand_s));
    if(new_sc == NULL){//Error en malloc
        printf("Error en malloc,\vNo se reservar memoria");
        exit(EXIT_FAILURE);
    }

    new_sc->sc_arg = g_queue_new();
    new_sc->sc_file_in = NULL;
    new_sc->sc_file_out = NULL;

    assert(new_sc != NULL && scommand_is_empty(new_sc) && scommand_get_redir_in(new_sc) == NULL
           && scommand_get_redir_out(new_sc) == NULL);
    return new_sc;
}

/*
 * Nuevo `scommand', sin comandos o argumentos y los redirectores vacíos
 *   Returns: nuevo comando simple sin ninguna cadena y redirectores vacíos.
 * Ensures: result != NULL && scommand_is_empty (result) &&
 *  scommand_get_redir_in (result) == NULL &&
 *  scommand_get_redir_out (result) == NULL
 */

scommand scommand_destroy(scommand self) {
    assert(self != NULL);
    free(self->sc_file_in);
    free(self->sc_file_out);
    g_queue_clear_full(self->sc_arg, free);
    self->sc_file_in = NULL;
    self->sc_file_out = NULL;
    free(self);
    self = NULL;
    assert(self == NULL);
    return self;
}
/*
 * Destruye `self'.
 *   self: comando simple a destruir.
 * Requires: self != NULL
 * Ensures: result == NULL
 */

/* Modificadores */

void scommand_push_back(scommand self, char * argument) {
    assert(self!=NULL && argument!=NULL);
    g_queue_push_tail(self->sc_arg, argument);
    assert(!scommand_is_empty(self));
}
/*
 * Agrega por detrás una cadena a la secuencia de cadenas.
 *   self: comando simple al cual agregarle la cadena.
 *   argument: cadena a agregar. El TAD se apropia de la referencia.
 * Requires: self!=NULL && argument!=NULL
 * Ensures: !scommand_is_empty()
 */

void scommand_pop_front(scommand self) {
    assert(self!=NULL && !scommand_is_empty(self));
    char * killme = NULL;
    killme = g_queue_pop_head(self->sc_arg);
    free(killme);
    killme = NULL;
}
/*
 * Quita la cadena de adelante de la secuencia de cadenas.
 *   self: comando simple al cual sacarle la cadena del frente.
 * Requires: self!=NULL && !scommand_is_empty(self)
 */

void scommand_set_redir_in(scommand self, char *filename) {
    assert(self != NULL);

    // si existe una dirección de redirección anterior
    if (self->sc_file_in != NULL) {
        free(self->sc_file_in);
    }// liberan la memoria utilizada 

    // nueva dirección de redirección
    self->sc_file_in = filename;
}

void scommand_set_redir_out(scommand self, char *filename) {
    assert(self != NULL);

    // Si existe una dirección de redirección anterior
    if (self->sc_file_out != NULL) {
        free(self->sc_file_out);
    }//liberan la memoria utilizada 

    // nueva dirección de redirección
    self->sc_file_out = filename;
}
/*
 * Define la redirección de entrada (salida).
 *   self: comando simple al cual establecer la redirección de entrada (salida).
 *   filename: cadena con el nombre del archivo de la redirección
 *     o NULL si no se quiere redirección. El TAD se apropia de la referencia.
 * Requires: self!=NULL
 */

/* Proyectores */

bool scommand_is_empty(const scommand self) {
    assert(self != NULL);
    return g_queue_is_empty(self->sc_arg);
}
/*
 * Indica si la secuencia de cadenas tiene longitud 0.
 *   self: comando simple a decidir si está vacío.
 *   Returns: ¿Está vacío de cadenas el comando simple?
 * Requires: self!=NULL
 */

unsigned int scommand_length(const scommand self) {
    assert(self != NULL);
    unsigned int sc_argc = g_queue_get_length(self->sc_arg);
    assert((sc_argc==0) == scommand_is_empty(self));
    return sc_argc;
}
/*
 * Da la longitud de la secuencia cadenas que contiene el comando simple.
 *   self: comando simple a medir.
 *   Returns: largo del comando simple.
 * Requires: self!=NULL
 * Ensures: (scommand_length(self)==0) == scommand_is_empty()
 *
 */

char * scommand_front(const scommand self) {
    assert(self!=NULL && !scommand_is_empty(self));
    char * result = g_queue_peek_head(self->sc_arg);
    assert(result != NULL);
    return result;
}
/*
 * Toma la cadena de adelante de la secuencia de cadenas.
 *   self: comando simple al cual tomarle la cadena del frente.
 *   Returns: cadena del frente. La cadena retornada sigue siendo propiedad
 *     del TAD, y debería considerarse inválida si luego se llaman a
 *     modificadores del TAD. Hacer una copia si se necesita una cadena propia.
 * Requires: self!=NULL && !scommand_is_empty(self)
 * Ensures: result!=NULL
 */

char * scommand_get_redir_in(const scommand self) {
    assert(self != NULL);
    char * input = self->sc_file_in;
    return input;
}

char * scommand_get_redir_out(const scommand self) {
    assert(self != NULL);
    char * output = self->sc_file_out;
    return output;
}
/*
 * Obtiene los nombres de archivos a donde redirigir la entrada (salida).
 *   self: comando simple a decidir si está vacío.
 *   Returns: nombre del archivo a donde redirigir la entrada (salida)
 *  o NULL si no está redirigida.
 * Requires: self!=NULL
 */
char **scommand_to_char_list(const scommand self) {
    assert(self != NULL);

    const unsigned int scmd_length = g_queue_get_length(self->sc_arg);
    char **argv = (char **)malloc(sizeof(char *) * (scmd_length + 1));
    //funciones como execvp identifiquen el final de la lista de argumentos.
    //es para acomodar un puntero nulo al final de la lista.
    for (unsigned int i = 0; i < scmd_length; i++) {
        argv[i] = g_queue_peek_nth(self->sc_arg, i);
    }
    argv[scmd_length] = NULL; // indica el final de la lista de argumentos.
    return argv;
}

char * scommand_to_string(const scommand self) {
    assert(self != NULL);

    char * result = NULL;
    unsigned int size_arg = g_queue_get_length(self->sc_arg);

    //IF (result != NULL) ==> result = "cmd arg1 arg2 ··· argN"

    if (size_arg != 0){
        result = strdup(g_queue_peek_nth(self->sc_arg,0u));
        for(unsigned int j = 1u; j < size_arg ;  j++){
            result = strmergefree(result," ");
            result = strmergefree(result, g_queue_peek_nth(self->sc_arg,j));
        }
        //Agregamos redireccionde entrada (si la tiene)
        if(self->sc_file_in != NULL){
            result = strmergefree(result , " < ");
            result = strmergefree(result , self->sc_file_in );
        }

        if(self->sc_file_out != NULL){
            result = strmergefree(result , " > ");
            result = strmergefree(result , self->sc_file_out );
        }

    }else{
        result =strdup("");
    }
    assert( scommand_is_empty(self) ||
        scommand_get_redir_in(self)==NULL ||
        scommand_get_redir_out(self)==NULL ||
        strlen(result)>0 );
        return result;
}
/* Preety printer para hacer debugging/logging.
 * Genera una representación del comando simple en un string (aka "serializar")
 *   self: comando simple a convertir.
 *   Returns: un string con la representación del comando simple similar
 *     a lo que se escribe en un shell. El llamador es dueño del string
 *     resultante.
 * Requires: self!=NULL
 * Ensures: scommand_is_empty(self) ||
 *   scommand_get_redir_in(self)==NULL || scommand_get_redir_out(self)==NULL ||
 *   strlen(result)>0
 */

//------------------||PIPELINE||------------------------//
/*
 * pipeline: tubería de comandos.
 * Ejemplo: ls -l *.c > out < in  |  wc  |  grep -i glibc  &
 * Secuencia de comandos simples que se ejecutarán en un pipeline,
 *  más un booleano que indica si hay que esperar o continuar.
 *
 * Una vez que un comando entra en el pipeline, la memoria pasa a ser propiedad
 * del TAD. El llamador no debe intentar liberar la memoria de los comandos que
 * insertó, ni de los comandos devueltos por pipeline_front().
 * pipeline_to_string() pide memoria internamente y debe ser liberada
 * externamente.
 *
 * Externamente se presenta como una secuencia de comandos simples donde:
 *           ______________________________
 *  front -> | scmd1 | scmd2 | ... | scmdn | <-back
 *           ------------------------------
 */

struct pipeline_s {
    GQueue *commands;
    bool should_wait;
} pipeline_s;


pipeline pipeline_new(void) {
    pipeline result;
    result = malloc(sizeof(struct pipeline_s));
    result->commands = g_queue_new();
    result->should_wait = true;

    // Verifica que la instancia de 'pipeline' ('result') no sea nula,

    assert(result != NULL && pipeline_is_empty(result) && pipeline_get_wait(result));
    return result;
}
/*
 * Nuevo `pipeline', sin comandos simples y establecido para que espere.
 *   Returns: nuevo pipeline sin comandos simples y que espera.
 * Ensures: result != NULL
 *  && pipeline_is_empty(result)
 *  && pipeline_get_wait(result)
 */
static void scommand_destroy_aux(void *self) { 
    scommand_destroy(self);
}

pipeline pipeline_destroy(pipeline self) {
    assert(self != NULL);
    g_queue_free_full(self->commands,
                      scommand_destroy_aux); // Libera y destruye y asegura que 'self' sea nulo
    self->commands = NULL;
    free(self);
    self = NULL;
    assert(self == NULL);
    return self;
}
/*
 * Destruye `self'.
 *   self: tubería a a destruir.
 * Requires: self != NULL
 * Ensures: result == NULL
 */

/* Modificadores */

void pipeline_push_back(pipeline self, scommand sc) {
    // Asegura que 'self' y 'sc' no sean nulos
    assert(self != NULL && sc != NULL);

    // Agrega 'sc' al final de la cola de comandos
    g_queue_push_tail(self->commands, sc);

    // Asegura que la cola de comandos no esté vacía después de agregar 'sc'
    assert(!pipeline_is_empty(self));
}

/*
 * Agrega por detrás un comando simple a la secuencia.
 *   self: pipeline al cual agregarle el comando simple.
 *   sc: comando simple a agregar. El TAD se apropia del comando.
 * Requires: self!=NULL && sc!=NULL
 * Ensures: !pipeline_is_empty()
 */

void pipeline_pop_front(pipeline self) {
    // Asegura que 'self' no sea nulo y que la cola de comandos no esté vacía
    assert(self != NULL && !pipeline_is_empty(self));

    // Obtiene una referencia al primer elemento de la cola
    scommand pipeline_head = g_queue_peek_head(self->commands);

    // Libera la memoria del primer elemento de la cola
    pipeline_head = scommand_destroy(pipeline_head);

    // Elimina el primer elemento de la cola
    g_queue_pop_head(self->commands);
}

/*
 * Quita el comando simple de adelante de la secuencia.
 *   self: pipeline al cual sacarle el comando simple del frente.
 *      Destruye el comando extraido.
 * Requires: self!=NULL && !pipeline_is_empty(self)
 */

void pipeline_set_wait(pipeline self, const bool w) {
    // Asegura que 'self' no sea nulo
    assert(self != NULL);

    // Establece el valor de 'should_wait' en 'w'
    self->should_wait = w;
}

/*
 * Define si el pipeline tiene que esperar o no.
 *   self: pipeline que quiere ser establecido en su atributo de espera.
 * Requires: self!=NULL
 */

/* Proyectores */

bool pipeline_is_empty(const pipeline self) {
    // Asegura que 'self' no sea nulo
    assert(self != NULL);

    // Verifica si la cola de comandos está vacía y devuelve el resultado
    return g_queue_is_empty(self->commands);
}

/*
 * Indica si la secuencia de comandos simples tiene longitud 0.
 *   self: pipeline a decidir si está vacío.
 *   Returns: ¿Está vacío de comandos simples el pipeline?
 * Requires: self!=NULL
 */

unsigned int pipeline_length(const pipeline self) {
    // Asegura que 'self' no sea nulo
    assert(self != NULL);

    // Declaración de una variable 'result' para almacenar la longitud
    unsigned int result;

    // Obtiene la longitud de la cola de comandos y la almacena en 'result'
    result = g_queue_get_length(self->commands);

    // Asegura que el resultado obtenido sea consistente con la función 'pipeline_is_empty'
    assert((result == 0) == pipeline_is_empty(self));

    // Devuelve la longitud calculada
    return result;
}

/*
 * Da la longitud de la secuencia de comandos simples.
 *   self: pipeline a medir.
 *   Returns: largo del pipeline.
 * Requires: self!=NULL
 * Ensures: (pipeline_length(self)==0) == pipeline_is_empty()
 *
 */

scommand pipeline_front(const pipeline self) {
    // Asegura que 'self' no sea nulo y que la cola de comandos no esté vacía
    assert(self != NULL && !pipeline_is_empty(self));

    // Declaración de una variable 'result' para almacenar el primer elemento
    scommand result;

    // Obtiene el primer elemento de la cola de comandos y lo almacena en 'result'
    result = g_queue_peek_head(self->commands);

    // Asegura que 'result' no sea nulo
    assert(result != NULL);

    // Devuelve el primer elemento obtenido
    return result;
}

/*
 * Devuelve el comando simple de adelante de la secuencia.
 *   self: pipeline al cual consultar cual es el comando simple del frente.
 *   Returns: comando simple del frente. El comando devuelto sigue siendo
 *      propiedad del TAD.
 *      El resultado no es un "const scommand" ya que el llamador puede
 *      hacer modificaciones en el comando, siempre y cuando no lo destruya.
 * Requires: self!=NULL && !pipeline_is_empty(self)
 * Ensures: result!=NULL
 */

bool pipeline_get_wait(const pipeline self) {
    // Asegura que 'self' no sea nulo
    assert(self != NULL);

    // Devuelve el valor de la propiedad 'should_wait'
    return self->should_wait;
}

/*
 * Consulta si el pipeline tiene que esperar o no.
 *   self: pipeline a decidir si hay que esperar.
 *   Returns: ¿Hay que esperar en el pipeline self?
 * Requires: self!=NULL
 */

char *pipeline_to_string(const pipeline self) {
    // Asegura que 'self' no sea nulo
    assert(self != NULL);

    char *result, *auxiliar_to_remove, *auxiliar_to_add;
    unsigned int length_of_pipeline;
    bool is_last_elem = false;

    // Inicializa 'result' con una cadena vacía
    result = strdup("");

    // Obtiene la longitud de la cola de comandos
    length_of_pipeline = pipeline_length(self);

    // Recorre los elementos de la cola de comandos
    for (unsigned int i = 0u; i < length_of_pipeline; ++i) {
        // Almacena temporalmente 'result' en 'auxiliar_to_remove'
        auxiliar_to_remove = result;

        // Obtiene la representación de texto del i-ésimo elemento de la cola
        auxiliar_to_add = scommand_to_string(g_queue_peek_nth(
            self->commands, i)); // g_queue_peek_nth returns the n'th element of queue.

        // Concatena la representación del elemento actual a 'result'
        result = strmerge(result, auxiliar_to_add);

        // Libera la memoria del elemento anterior y el texto adicional
        free(auxiliar_to_remove);
        free(auxiliar_to_add);

        // Verifica si es el último elemento para agregar " | " o "&" según corresponda
        is_last_elem = i == length_of_pipeline - 1;
        if (!is_last_elem) {
            // Almacena temporalmente 'result' en 'auxiliar_to_remove'
            auxiliar_to_remove = result;

            // Agrega " | " al final de 'result'
            result = strmerge(result, " | ");

            // Libera la memoria del elemento anterior
            free(auxiliar_to_remove);
        }
    }

    // Verifica si 'should_wait' es falso y agrega "&" en ese caso
    if (!pipeline_get_wait(self)) {
        // Almacena temporalmente 'result' en 'auxiliar_to_remove'
        auxiliar_to_remove = result;

        // Agrega " &" al final de 'result'
        result = strmerge(result, " &");

        // Libera la memoria del elemento anterior
        free(auxiliar_to_remove);
    }

    // Asegura que la cola de comandos esté vacía, o que 'should_wait' sea verdadero,
    // o que 'result' tenga una longitud mayor que cero
    assert(pipeline_is_empty(self) || pipeline_get_wait(self) || strlen(result) > 0);

    // Devuelve el resultado final como una cadena de caracteres
    return result;
}

/* Pretty printer para hacer debugging/logging.
 * Genera una representación del pipeline en una cadena (aka "serializar").
 *   self: pipeline a convertir.
 *   Returns: una cadena con la representación del pipeline similar
 *     a lo que se escribe en un shell. Debe destruirla el llamador.
 * Requires: self!=NULL
 * Ensures: pipeline_is_empty(self) || pipeline_get_wait(self) || strlen(result)>0
 */
