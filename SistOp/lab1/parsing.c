#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <assert.h>

#include "parsing.h"
#include "parser.h"
#include "command.h"

static bool has_symbols(const char *argument) {
    char *forbbiden_char = ",#!$%%?*[]{}()¡¿;";
    
    for (int i = 0; argument[i] != '\0'; i++) {
        if (strchr(forbbiden_char, argument[i]) != NULL) {
            return true; // La cadena contiene al menos uno de los caracteres prohibidos
        }
    }
    return false; // La cadena no contiene ninguno de los caracteres prohibidos
}

static scommand parse_scommand(Parser p) {
    arg_kind_t type;
    scommand command = NULL;

    // Parsea el primer argumento del comando
    char * argument = parser_next_argument(p, &type);

    if (argument != NULL) {
        command = scommand_new();
    } else {
        return command;
    }
    while (argument != NULL) {
        switch (type) {
        case ARG_NORMAL:
            // Si el argumento no tiene simbolos invalidos se agrega al comando
            if (!has_symbols(argument)) {
                scommand_push_back(command, argument);
            }
            else {
                fprintf(stderr, "Error: invalid symbols\n");
                command = scommand_destroy(command);
                return command;
            }
            break;

        case ARG_INPUT:
            if (argument != NULL) {       
                scommand_set_redir_in(command, argument);
            }
            else {
                fprintf(stderr, "Error: no input\n");
                command = scommand_destroy(command);
                return command;
            }
            break;

        case ARG_OUTPUT:
            if (argument != NULL) {
                scommand_set_redir_out(command, argument);
            }
            else {
                fprintf(stderr, "Error: no output\n");
                command = scommand_destroy(command);
                return command;
            }
            break;
        
        default:
            break;
        }

        // Parsea el proximo argumento
        argument = parser_next_argument(p, &type);  /* Lee el proximo argumento */

    }
    return command;
}

pipeline parse_pipeline(Parser p) {
    assert(p != NULL && !parser_at_eof(p));
    pipeline result = pipeline_new();
    scommand cmd = NULL;
    bool error = false, another_pipe=true, was_op_background = false, garbage = false;
    cmd = parse_scommand(p);
    error = (cmd==NULL); /* Comando inválido al empezar */

    if (!error) {
        pipeline_push_back(result, cmd);
        parser_op_pipe(p, &another_pipe);
    } else {
        parser_garbage(p, &garbage);
        result = pipeline_destroy(result);
        return result;
    }

    while (another_pipe && !error) {
        cmd = parse_scommand(p);
        error = (cmd==NULL); /* Comando inválido al empezar */
        if (!error) {
            pipeline_push_back(result, cmd);
            parser_op_pipe(p, &another_pipe);
        }
    }

    /* Tolerancia a espacios posteriores */
    parser_skip_blanks(p);

    /* Opcionalmente un OP_BACKGROUND al final */
    parser_op_background(p, &was_op_background);
    if (was_op_background == true){
        pipeline_set_wait(result, false);
    }

    /* Consumir todo lo que hay inclusive el \n */
    parser_garbage(p, &garbage);

    /* Si hubo error, hacemos cleanup */
    if (garbage == true) {
        result = pipeline_destroy(result);
        fprintf(stderr, "Invalid command\n");
        return result;
    }
    
    return result;
}