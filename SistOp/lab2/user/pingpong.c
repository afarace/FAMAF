#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define SUCCESS 1
#define ERROR 0

int main(int argc, char *argv[]){

  int error_sem_call = 0;
  int rally = 0 ;  // Transforma el parametro de pingpong en un entero
  int pid;
  
  int sem_ping;
  int sem_pong;

  //Manejo de Errores de entrada argc debe ser == 2
  if(argc == 2){
    rally = atoi(argv[1]);
    if(rally <= 0){
      printf("ERROR: el numero de rounds debe ser mayor a 1\n");
      return ERROR;
    }
  } else {
      printf("ERROR: Error de sintaxis\n");
      return ERROR;
  }

  sem_ping = first_sem_available();

  //Semaforo padre, value = 1
  error_sem_call = sem_open(sem_ping, 1);
  if (error_sem_call == 0) {
    printf("ERROR: Error al abrir el semaforo ping\n");
    exit(ERROR);
  }

  sem_pong = first_sem_available();

  //Semaforo hijo, value = 0
  error_sem_call = sem_open(sem_pong, 0);
  if (error_sem_call == 0) {
    printf("ERROR: Error al abrir el semaforo pong1\n");
    exit(ERROR);
  }

  pid = fork();

  if (pid < 0) {
    printf("ERROR: Fallo de fork\n");
    sem_close(sem_ping);
    sem_close(sem_pong);
    exit(ERROR);
  } else if (pid >= 0) {   // Padre e Hijo

    //int contador = 2*rally;
    while(rally > 0){
        if(pid > 0){
          //Zona de exclucion padre
          sem_down(sem_ping);
          printf("ping\t\n");
          sem_up(sem_pong);
          --rally;
          //Fin Zona de exclucion padre
        } else {
          //Zona de exclucion hijo
          sem_down(sem_pong);
          printf("\tpong\n");
          sem_up(sem_ping);
          --rally;
          //Fin Zona de exclucion hijo
        }
    }//Fin while

  sem_close(sem_ping);
  sem_close(sem_pong);


  }//Fin Padre Hijo

  return SUCCESS;
}
