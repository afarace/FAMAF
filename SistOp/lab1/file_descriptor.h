#ifndef FILE_DESCRIPTOR
#define FILE_DESCRIPTOR

#define SYS_ERROR(condition, message)                                                              \
    if (condition) {                                                                               \
        perror(message);                                                                           \
        exit(EXIT_FAILURE);                                                                        \
    }

/*
 Cambia el descriptor de archivo de entrada estándar (stdin) a partir del nombre de un archivo proporcionado. 
 redir_in Nombre del archivo que se utilizará como entrada.
 */

void redirect_input_file(char *redir_in);

/*
 Cambia el descriptor de archivo de salida estándar (stdout) a partir del nombre de un archivo proporcionado.
 redir_out Nombre del archivo que se utilizará como salida.
 */

void redirect_output_file(char *redir_out);

/*
 Cambia el descriptor de archivo de entrada estándar (stdin) a partir de un descriptor de archivo existente. 
 fd_act Descriptor de archivo existente que se utilizará como entrada.
 */

void redirect_input_from_fd(int fd_act);

/*
 Cambia el descriptor de archivo de salida estándar (stdout) a partir de un descriptor de archivo existente.
 fd_act Descriptor de archivo existente que se utilizará como salida.
 */

void redirect_output_to_fd(int fd_act);

#endif