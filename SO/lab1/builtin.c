#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "command.h"
#include "builtin.h"
#include "strextra.h"
#include "tests/syscall_mock.h"

#define MAX_SIZE_STRING 1024

static bool is_exit(scommand cmd){
    return strcmp(scommand_front(cmd),"exit")==0;
}

static bool is_change_directory(scommand cmd){
    return strcmp(scommand_front(cmd),"cd")==0;
}

static bool is_help(scommand cmd){
    return strcmp(scommand_front(cmd),"help")==0;
}


bool builtin_is_internal(scommand cmd){
    return is_exit(cmd) ||
    is_change_directory(cmd) ||
    is_help(cmd) ;
}
/*
 * Indica si el comando alojado en `cmd` es un comando interno
 *
 * REQUIRES: cmd != NULL
 *
 */


bool builtin_alone(pipeline p){
    assert(p != NULL);
    bool is_alone = (pipeline_length(p) == 1u) && builtin_is_internal(pipeline_front(p));

    return is_alone;
}
/*
 * Indica si el pipeline tiene solo un elemento y si este se corresponde a un
 * comando interno.
 *
 * REQUIRES: p != NULL
 *
 * ENSURES:
 *
 * builtin_alone(p) == pipeline_length(p) == 1 &&
 *                     builtin_is_internal(pipeline_front(p))
 *
 *
 */

static void help_command(void){
    printf("Integrantes:\nMarcos Avellaneda Bernardez\nAgustin Farace\nAaron Aravena\n");

}

static void change_directory_command(scommand cmd){
    assert(cmd != NULL && is_change_directory(cmd));
    unsigned int arg_count = scommand_length(cmd);
    char * home = getenv("HOME");
    char * input_path = NULL;
    unsigned int length_path = 0u;
    int return_code_chdir = 0; //chdir() retorna 0 si fue exitoso y -1 si no lo fue

    if (arg_count >= 3u){
        printf("mybash: cd: too many arguments\n");
    } else if(arg_count == 1u){
        return_code_chdir = chdir(home);
    } else {
        //Pasado este punto arg_count == 1 ó 2 unicamente
        //Seteo variables input_path y length_path
        if (arg_count == 2u) {//"cd path" --> "path"
            scommand_pop_front(cmd);
            input_path = scommand_front(cmd);
            length_path =(unsigned int) strlen(input_path);
        }

        //caso  "cd | cd ~"
        if (length_path == 1u && (input_path[0]== '~' || input_path == NULL)){
            return_code_chdir = chdir(home);
        }

        if (length_path >= 2u) {
            if(input_path[0] == '~' && input_path[1] == '/'){  /* Caso "cd ~/ " */
                return_code_chdir = chdir(strmerge(home, &input_path[1]));
            } else{
                return_code_chdir = chdir(input_path);
            }
        }

        if (return_code_chdir != 0) {
            printf("cd: %s No existe el directorio\n", input_path);
        }

    }

}//FIN change_directory_command




void builtin_run(scommand cmd){
    assert( cmd != NULL && scommand_length(cmd) >0u);
    //assert( !builtin_is_internal(cmd) );
    if(is_exit(cmd)){
        printf("mybash> Gracias por usar MyBash\n");
        exit(0);
    } else if(is_help(cmd)){
        help_command();
    } else if(is_change_directory(cmd)){
        change_directory_command(cmd);
    }
}
/*
 * Ejecuta un comando interno
 *
 * REQUIRES: {builtin_is_internal(cmd)}
 *
 */


