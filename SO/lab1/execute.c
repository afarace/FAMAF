#include <assert.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#include "tests/syscall_mock.h"

#include "builtin.h"
#include "command.h"
#include "execute.h"
#include "file_descriptor.h"

static void do_an_execute_single_command(pipeline apipe, int fd_read, int fd_write,
                                         int fd_read_not_used) {
    scommand cmd = pipeline_front(apipe);

    if (builtin_alone(apipe)) {
        builtin_run(pipeline_front(apipe));
        // Finaliza la ejecución del comando
    } else {
        int pid = fork();
        SYS_ERROR(pid == -1, "ForkError");

        if (pid == 0) { // proceso hijo
            // Ejecución general de la instrucción en scommand

            if (fd_read_not_used != -1) {
                // Cierra el descriptor de archivo
                close(fd_read_not_used);
            }

            if (fd_read != -1) {
                // Cambia la entrada del proceso al descriptor de archivo fd_lectura
                redirect_input_from_fd(fd_read);
            }

            if (fd_write != -1) {
                // Cambia la salida del proceso al descriptor de archivo fd_escritura
                redirect_output_to_fd(fd_write);
            }

            // Cambia los descriptores de archivo si hay redirecciones de entrada/salida a un archivo

            redirect_input_file(scommand_get_redir_in(cmd));
            redirect_output_file(scommand_get_redir_out(cmd));

            // Ejecuta el comando con los archivos correspondientes de entrada/salida

            char **argv = scommand_to_char_list(cmd);
            execvp(argv[0], argv);
            SYS_ERROR(true, argv[0]);
        }
    }
}

static void do_an_execute_pipeline(pipeline apipe, int fd_read) {
    assert(apipe != NULL);

    if (pipeline_length(apipe) == 1) { // caso base
        do_an_execute_single_command(apipe, fd_read, -1, -1);
        pipeline_pop_front(apipe);

    } else { // recursivo
        // Crear los buffers del pipe de entrada y salida
        int fd_pipe[2];//
        int syscall_result = pipe(fd_pipe);  // Salida del comando actual
        SYS_ERROR(syscall_result == -1, "PipeError");

        do_an_execute_single_command(apipe, fd_read, fd_pipe[1], fd_pipe[0]);

        // Cerramos el descriptor de archivo de escritura del pipe
        close(fd_pipe[1]);

        pipeline_pop_front(apipe);

        do_an_execute_pipeline(apipe, fd_pipe[0]); // fd_pipe[0] es la entrada del próximo comando

        // Cerramos el descriptor de archivo de lectura del pipe
        close(fd_pipe[0]);
    }
}

void execute_pipeline(pipeline apipe) {
    // REQUISITOS
    assert(apipe != NULL);

    if (!pipeline_is_empty(apipe)) {

        int syscall_result;

        // ¡¡¡ Todas las comandos internos se ignoran en un pipe !!!

        if (pipeline_get_wait(apipe)) {
            // Ejecución de la tubería en modo SEGUNDO PLANO

            int cnt_child_process;
            if (builtin_alone(apipe)) {
                cnt_child_process = 0;
            } else {
                cnt_child_process = pipeline_length(apipe);
            }

            do_an_execute_pipeline(apipe, -1);

            // Bloque de espera, evitar que los comandos en segundo plano y primer plano colapsen
            while (cnt_child_process > 0) {
                int exit_signal = -1;
                wait(&exit_signal);
                if (exit_signal != EXIT_BACKGROUND) {
                    cnt_child_process--;
                }
            }

        } else {
            // Ejecución dl pipe en modo PRIMER PLANO
            int pid = fork();
            SYS_ERROR(pid == -1, "Error en Fork");

            if (pid == 0) { // Un proceso hijo
                // Cerramos todas las llamadas al sistema de escritura y redirigimos la entrada a STDIN.
                int fd_act[2];
                syscall_result = pipe(fd_act);
                SYS_ERROR(syscall_result == -1, "PipeError");

                int cnt_child_process;
                if (builtin_alone(apipe)) {
                    cnt_child_process = 0;
                } else {
                    cnt_child_process = pipeline_length(apipe);
                }


                do_an_execute_pipeline(apipe, fd_act[0]);

                while (cnt_child_process > 0) {
                    wait(NULL);
                    cnt_child_process--;
                }

                close(fd_act[0]);
                close(fd_act[1]);

                //printf("=== Process with PID %d finished === \n", getpid());

                exit(EXIT_BACKGROUND);
            } else {
                //printf("=== Process with PID %d initialized === \n", pid);
            }
        }
    }
}

