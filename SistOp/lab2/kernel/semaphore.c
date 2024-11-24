#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

#define SEM_MAX_AMOUNT 20

#define SEM_ON 1
#define SEM_OFF 0

#define SUCCESS 1
#define ERROR 0

//int sem;
//int value;
const int length = SEM_MAX_AMOUNT;

struct semaphore_t {
  int value;              // Valor actual del semaforo (value >= 0)
  struct spinlock lock;   // El spinlock nos asegura que estamos operando de forma atomica
  int active;             // El semaforo esta activo si ,active == 1(SEM_ON) o 0 (SEM_OFF) si no lo esta
};

//Manejamos una cantidad limitada de semaforos
struct semaphore_t sem_array[SEM_MAX_AMOUNT];


//main.c corre esta funcion para inicializar los semaforos en SEM_OFF
void init_semaphore_array(void){
  for(int i=0; i < SEM_MAX_AMOUNT ; i++){
    sem_array[i].active = SEM_OFF;
    sem_array[i].value  = 0;
  }
}

uint64 sys_sem_amount_available(void){
  //int length = 0;
  //printf("%d\n",length);
  return length;
}

uint64 sys_sem_open(void){
  int sem, value;
  argint(0, &sem);
  argint(1, &value);

  //Checkeo en caso de un input invalido
  if( sem > SEM_MAX_AMOUNT || sem < 0 || value < 0 ){
    return ERROR;
  }

  //retorna 1 ==> SUCCESS ó 0 ==> ERROR
  int result = SUCCESS;

  //Si el semaforo no esta activo lo seteamos
  if(sem_array[sem].active == SEM_OFF){

    //Inicializamos el spinlock
    initlock(&sem_array[sem].lock,"semaphore");

    // BEGING CRITICAL SECTION_______________________
    acquire(&sem_array[sem].lock);

    sem_array[sem].active = SEM_ON;
    sem_array[sem].value = value;

    release(&sem_array[sem].lock);
    // END CRITICAL SECTION__________________________
  }

  return result;
}

uint64 sys_first_sem_available(void) {
  //argint(0, &value);
  int index = -1;   //En caso de que todos los semaforos esten ocupados
  int i = 0;
  while (index < SEM_MAX_AMOUNT) {
    if(sem_array[i].active == SEM_OFF) {
      index = i;
      break;
    }
    ++i;
  }
  return index;
}

//Error cuando sem no existe
uint64 sys_sem_close(void){
  int sem;
  argint(0, &sem);
  //Checkeo en caso de un input invalido
  if( sem > SEM_MAX_AMOUNT || sem < 0){
    return ERROR;
  }
  int result = SUCCESS;

  // BEGING CRITICAL SECTION_______________________
  acquire(&sem_array[sem].lock);

  sem_array[sem].active = SEM_OFF;

  release(&sem_array[sem].lock);
  // END CRITICAL SECTION__________________________
  return result;
}

//Si semaforo esta desactivado (SEM_OFF) devuelve 0 (ERROR) y corroborar el indice sem
uint64 sys_sem_up(void){
  int sem;
  argint(0, &sem);
  //Checkeo en caso de un input invalido
  if( sem > SEM_MAX_AMOUNT || sem < 0 || sem_array[sem].active == SEM_OFF){
    return ERROR;
  }

  int result = SUCCESS;

  // BEGING CRITICAL SECTION_______________________
  acquire(&sem_array[sem].lock);

  //Despierto semaforos si esta dormido
  if(sem_array[sem].value == 0){
    wakeup(&sem_array[sem]);
  }
  ++sem_array[sem].value;

  release(&sem_array[sem].lock);
  // END CRITICAL SECTION__________________________

  return result;
}

//Si semaforo esta desactivado (SEM_OFF) devuelve 0 (ERROR) y corroborar el indice sem
uint64 sys_sem_down(void){
  int sem;
  argint(0, &sem);
  //Checkeo en caso de un input invalido
  if( sem > SEM_MAX_AMOUNT || sem < 0){
    return ERROR;
  }else if(sem_array[sem].active == SEM_OFF){
    return ERROR;
  }
  int result = SUCCESS;

  // BEGING CRITICAL SECTION_______________________
  acquire(&sem_array[sem].lock);

  //Suspendemos el proceso si, value <=0
  while(sem_array[sem].value <= 0){
    sleep(&sem_array[sem], &sem_array[sem].lock);
  }
  sem_array[sem].value--;

  release(&sem_array[sem].lock);
  // END CRITICAL SECTION__________________________

  return result;
}
