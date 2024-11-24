#include <assert.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>

#include "file_descriptor.h"
#include "tests/syscall_mock.h"

void redirect_input_file(char *redir_in) {
    if (redir_in != NULL) {//Verifica si redir_in es distinto de NULL
        int fd_act = open(redir_in, O_RDONLY, 0u);//modo de solo lectura
        SYS_ERROR(fd_act == -1, "OpenError");//fd_act==-1 el programa podrá leer datos desde ese archivo.

        int syscall_result = dup2(fd_act, STDIN_FILENO);//redirige la entrada estándar del programa al archivo abierto.
        SYS_ERROR(syscall_result == -1, "Dup2Error");

        syscall_result = close(fd_act);//Cierra el descriptor de archivo fd_act
        SYS_ERROR(syscall_result == -1, "CloseError");
    }
}

void redirect_output_file(char *redir_out) {
    if (redir_out != NULL) {//Verifica si redir_out no es NULL
        int fd_act = open(redir_out, O_WRONLY | O_CREAT, S_IRUSR | S_IWUSR);
        //permite que el programa escriba en el archivo y, si no existe, lo cree.
        SYS_ERROR(fd_act == -1, "OpenError");

        int syscall_result = dup2(fd_act, STDOUT_FILENO);
        //apunta al archivo abierto el programa escriba datos en ese archivo
        //todo lo que se imprima en stdout se escribirá en el archivo.
        SYS_ERROR(syscall_result == -1, "Dup2Error");

        syscall_result = close(fd_act);
        SYS_ERROR(syscall_result == -1, "CloseError");
    }
}

void redirect_input_from_fd(int fd_act) {//argumento descriptor. Nueva entrada estándar del programa.
    int syscall_result = dup2(fd_act, STDIN_FILENO);
    //cualquier lectura desde stdin ahora provendrá del archivo asociado al descriptor fd_act
    SYS_ERROR(syscall_result == -1, "Dup2Error");

    syscall_result = close(fd_act);
    SYS_ERROR(syscall_result == -1, "CloseError");
}

void redirect_output_to_fd(int fd_act) {///argumento descriptor. Nueva salida estándar del programa.
    int syscall_result = dup2(fd_act, STDOUT_FILENO);
    //cualquier información que se escriba en stdout se guardará en el archivo correspondiente.
    SYS_ERROR(syscall_result == -1, "Dup2Error");

    syscall_result = close(fd_act);
    SYS_ERROR(syscall_result == -1, "CloseError");
}

/*
 Si ocurre algún error durante cualquiera de estos pasos, 
 se utiliza SYS_ERROR para mostrar un mensaje de error 
 y salir del programa con un código de error.
*/