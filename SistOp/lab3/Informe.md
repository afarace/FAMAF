# Informe Sistemas Operativos Grupo 35

## Laboratorio 3 - Planificador de Procesos

### Integrantes:  

- Marcos Avellaneda Bernardez
    - email: marcos.avellaneda.bernardez@mi.unc.edu.ar

- Agustin Farace
    - email: agustin.farace@mi.unc.edu.ar

- Ramiro Cuellar
    - email: ramiro.cuellar@mi.unc.edu.ar

- Aravena Aron Lihuel
    - email: aaron.aravena@mi.unc.edu.ar

## Introduccion 
Los objetivos de este laboratorio son estudiar el funcionamiento del scheduler original de xv6-riscv; **analizar** los procesos que se
benefician/perjudican con esta decisión de diseño; por último desarrollar una
implementación reemplazando la política de planificación por una propia que
deberá respetar ciertos condiciones y analizar como afecta a los procesos en
comparación con el planificador original.

### ¿Cómo compilar?

    $ git clone https://<User>bitbucket.org/sistop-famaf/so23lab3g35.git
    $ cd so23lab3g32
    $ make CPUS=1 qemu

### Primera parte: Estudiando el planificador de xv6-riscv

### ¿Qué política de planificación utiliza xv6-riscv para elegir el próximo proceso a ejecutarse? Pista: xv6-riscv nunca sale de la función scheduler  por medios “normales”.

Utiliza la política Round Robin. Esto lo podemos ver gracias a la función scheduler (kernel/proc.c:452) que recorre una tabla de procesos, selecciona un proceso cuyo estado sea RUNNABLE, cambia su estado a RUNNING,  ocurre un context switch usando la función swtch.S, comienza a ejecutarse y luego de un quantum selecciona otro proceso usando el mismo criterio y así sucesivamente.

### ¿Cuánto dura un quantum en xv6-riscv?

Un quantum en xv6-riscv es un intervalo de 1.000.000 de ciclos. En qemu un ciclo dura 1/10 segundos. Esto podemos verlo en start.c, donde dentro de la función timerinit() se define un intervalo de ciclos (start.c:72).

### ¿Cuánto dura un cambio de contexto en xv6-riscv?

Para medir cuanto dura un cambio de contexto se realizó el siguiente experimento: Reducir el quantum hasta hasta que no se ejecutara ningún proceso. De esta manera, el context switch tiene una duración entre 50-100 ciclos, ya que en este intervalo a veces los procesos iniciales se ejecutaban.

### ¿El cambio de contexto consume tiempo de un quantum?
Si. Esto se deduce directamente de la pregunta anterior, pues si un quantum es muy corto, los procesos no llegan a ejecutarse porque consumen todo su tiempo de quantum.

### ¿Hay alguna forma de que a un proceso se le asigne menos tiempo?

No, debido a la planificación Round Robin de xv6 cada proceso se ejecutará una cantidad de tiempo establecida por un quantum.

### ¿Cúales son los estados en los que un proceso puede permanecer en xv6-riscv y que los hace cambiar de estado?

Los estados en los que un proceso de xv6-riscv puede permanecer son:
UNUSED, USED, SLEEPING, RUNNABLE, RUNNING, ZOMBIE. (kernel/proc.h:82)

Aqui una breve descripción de cómo cambian los estados de los procesos:

- **UNUSED**: Al inicializar una tabla de procesos, todos están en este estado. Un proceso pasa de USED a UNUSED cuando se elimina mediante la syscall freeproc().

- **USED**: Cuando se crea un nuevo proceso mediante fork() se usa la función allocproc() que busca en la tabla de procesos la primer posición que esté en UNUSED y la cambia a USED.

- **SLEEPING**: Un proceso que esté en el estado RUNNING pasa al estado SLEEPING cuando se realiza una operación I/O. Se usa la syscall sleep para ponerlo a dormir.
  
- **RUNNABLE**: Un proceso pasa del estado SLEEPING a RUNNABLE cuando un proceso finaliza una operacion I/O. Se despierta mediante la syscall wakeup(). También pasa de estado USED a RUNNABLE luego de setearlo en la tabla de procesos como  USED cuando se usa fork() para crear un nuevo proceso. Pasa del estado RUNNING a RUNNABLE cuando se ejecuta un trap hacia espacio kernel debido a una interrupción por tiempo, excepción o syscall. Pasa del estado SLEEPING a RUNNABLE cuando se lo mata mediante la syscall kill().

- **RUNNING**: Un proceso está en el estado RUNNING cuando el planificador selecciona un proceso de la tabla de procesos que está en estado RUNNABLE.

- **ZOMBIE**: Un proceso se encuentra en estado ZOMBIE luego de terminar su ejecución y no haber sido liberado del sistema.

### Segunda parte: Cómo el planificador afecta los procesos

Esta parte tiene el objetivo de analizar cómo el planificador afecta los procesos mediante los programas cpubench e iobench que miden operaciones de CPU e I/O respectivamente. Para esto agregamos un contador en la struct proc (proc.h:110) que cuente cuantas veces el proceso es elegido por el planificador.

Vamos a analizar 5 casos de ejecución: 1 iobench solo, 1 cpubench solo, 1 iobench y 1 cpubench en paralelo, 2 cpubench en paralelo y 2 cpubench y 1 iobench en paralelo. Cada uno de estos casos tendrá 2 escenarios: ejecución con el quantum por defecto de xv6 (1) y ejecución con un quantum 10 veces menor (2).

Las imagenes correspondientes a cada caso y escenario se encuentran en un PDF llamado "Mediciones" dentro del repositorio.

**Caso 0**: iobench

Se ejecuta iobench solo.

- Escenario 1: No hay mucho para analizar. El proceso hace solicitudes de I/O y se queda en sleeping. Al finalizar la solicitud, el proceso vuelve a ejecutarse.
- Escenario 2: Al reducir el quantum 10 veces notamos que el proceso aumenta cantidad de operaciones realizadas (no entendemos muy bien por qué). Más allá de eso, la única diferencia es en la cantidad de veces que el planificador selecciona el proceso, al ser el quantum más corto, el proceso y como es el único ejecutandose, se selecciona más veces.

**Caso 1**: cpubench

se ejecuta cpubench solo.

- Escenario 1: El proceso usa todo su quantum para realizar operaciones de CPU.
- Escenario 2: Con un quantum 10 veces menor, el proceso realiza menos cantidad de operaciones debido a las interrupciones. También aumentó 10 veces la cantidad de veces que el planificador selecciona al proceso.

**Caso 2**: 1 iobench, 1 cpubench

Se ejecuta iobench y cpubench en paralelo.

- Escenario 1: Se realizan menos operaciones de CPU debido al tiempo que demanda el context switch y muchísimas operaciones menos de I/O debido a que cuando realiza una solicitud se bloquea y el planificador cambia a cpubench, que se ejecuta un quantum entero
- Escenario 2: Con un quantum 10 veces menor se reducen más las operaciones de CPU mientras que las de I/O aumentan ya que deben esperar menos tiempo para volver a ejecutarse. Ambos procesos son seleccionados 10 veces más que con su quantum normal

**Caso 3**: 2 cpubench

Se ejecutan 2 cpubench en paralelo.

- Escenario 1: La cantidad de operaciones que realiza cada proceso son casi iguales pues el programa solo es interrumpido por el quantum. Se realizan más operaciones que cuando se ejecuta solo 1 cpubench (No encontramos explicación)
- Escenario 2: La cantidad de operaciones realizadas disminuye mucho debido al menor quantum y al context switch. Ambos procesos son elegidos aproximadamente 10 veces más que con el quantum normal.

**Caso 4**: 2 cpubench y 1 iobench

Se ejecutan 2 cpubench y 1 iobench en paralelo

- Escenario 1: Al igual que en el caso de 2 cpubench, ambos CPU realizan casi la misma cantidad de operaciones y al igual que el caso 2 la cantidad de operaciones I/O que se realizan es menor ya que ahora debe esperar 2 quantums (1 de cada cpubench).
- Escenario 2: Al igual que el caso 2 aumentan un poco las operaciones de I/O debido al menor tiempo de quantum.Aumenta casi 10 veces la cantidad de veces que son seleccionados los procesos.

### Tercera parte: Rastreando la prioridad de los procesos

Para la realización de esta parte, agregamos a la struct proc (kernel/proc.h:87) un campo que indica su prioridad que puede ir de 0 a NPRIO - 1 siendo NPRIO = 3. También le agregamos otro campo que es un contador que indica las veces que fue elegido por el planificador. Se inicializa en 0 cuando el proceso se crea y se incrementa dentro de la función scheduler() (kernel/proc.c:454) luego de que el planificador elige el proceso.

Para implementar la regla 3 de MLFQ, al momento de crear el proceso en allocproc() (kernel/proc.c:113) le asignamos al proceso la prioridad máxima NPRIO - 1. En la regla 4, para descender la prioridad de un proceso luego de un quantum, modificamos la función usertrap() (kernel/trap.c:37) para que cuando verifique que una interrupción es por tiempo se baje la prioridad del proceso (a no ser que ya sea mínima). Luego, para incrementar la prioridad cada vez que un proceso se bloquea modificamos la syscall sleep() (kernel/proc.c:550) que es la encargada de mandar a dormir los procesos haciendo que si la prioridad de un proceso no es la máxima, entonces la incremente.

### Cuarta parte: Implementando MLFQ
Las modificaciones requeridas para la implementación de las reglas 1 y 2 del planificador MLFQ ocurren dentro del scheduler (kernel/proc.c:492).
Con ayuda de una función static (kernel/proc.c:449) se seleccionara el siguiente proceso que correrá , esta función recorre de manera lineal (con un bucle for) la tabla de procesos hasta encontrar uno que cumpla con los requisitos :
- Regla 1:
    - Corre el proceso con mayor prioridad ( priority(A) > priority(B) → A corre y B no )
- Regla 2:
    - Si 2 o mas procesos tienen la misma prioridad , corre el proceso que fue elegido menos veces por el planificador

Analizaremos los mismos casos que la parte 2 con los mismos escenarios.

**Caso 0**: iobench

Se ejecuta un iobench solo

- Escenario 1: Resultados similares a los del planificador RR debido a que es 1 solo proceso ejecutándose. Notamos una menor cantidad de operaciones realizadas. Creemos que esto se debe a la complejidad de seleccionar el próximo proceso a ejecutar por el planificador.
- Escenario 2: Lo mismo que sucede en el escenario 1. Con un quantum reducido, el proceso es seleccionado más veces.

**Caso 1**: cpubench

Se ejecuta un cpubench solo

- Escenario 1: Se comporta igual que en RR debido a que es solo 1 proceso ejecutandose.
- Escenario 2: Lo mismo que sucede en el escenario 1. Con un quantum reducido, el proceso es seleccionado más veces.

**Caso 2**: 1 iobench, 1 cpubench

Se ejecutan un cpubench e iobench en paralelo

- Escenario 1: Resultados parecidos a RR pues cuando se ejecuta cpubench utiliza todo su quantum, luego ejecuta iobench, se bloquea y vuelve a ejecutar cpubench durante todo su quantum y asi sucesivamente.
- Escenario 2: 2: Lo mismo que sucede en el escenario 1. Con un quantum reducido, los procesos son seleccionados más veces.

**Caso 3**: 2 cpubench

Se ejecutan 2 cpubench en paralelo.

- Escenario 1: En este escenario también los resultados son casi iguales a los de RR ya que se ejecutará un cpubench durante un quantum, luego se ejecutara otro durante un quantum y asi sucesivamente.
- Escenario 2:Lo mismo que el escenario 2 de RR sumado a que se seleccionan mas veces debido al tiempo de quantum.

**Caso 4** 2 cpubench y 1 iobench

Se ejecutan en paralelo 2 cpubench y un iobench

- Escenario 1: Los resultados son que al ejecutarlos con el planificador RR. Sin embargo podemos notar que iobench realiza casi el doble de operaciones que en RR y además es seleccionado el doble de veces que los 2 cpubench debido a la política de la mayor prioridad
- Escenario 2: Lo mismo que en el escenario 1 sumado a que todos los procesos son seleccionados casi 10 veces más debido al tamaño del quantum-

### Posible Starvation
Desafortunadamente si.

Con esta implementacion los procesos cpubound (por lo general) tienen una menor prioridad, debido a que suelen ocupar todo el quantum al momento de ser elegidos por el planificador 

i.e. solo entregan el control del cpu cuando terminan su ejecucion 

Haria falta algun especie de boost de las prioridades de los procesos para evitar starvation


## Concluciones
Se probaron escenarios utilizando 2 planificadores (schedulers) ,a continuación describiremos una serie de comportamientos que notamos:

**1)**   En escenarios puramente CPUbound , el quantum se distribuye de forma pareja corriendo en Round Robin como en MLFQ (nuestra implementación) con el quantum original como en el reducido (reducido 10 veces). Las mediciones R2, R4, R7, R9, M2, M4, M7 y M9 lo corroboran

**2)**  En escenarios compartido con 1 iobench con 2 cpubench : el scheduler MLFQ favorece las operaciones I/Os en aproximadamente el doble de un CPUbound tanto para el quantum original como el reducido, i.e. \#1iobench ~ \#2cpubench , (mediciones M5 y M10).
  Para este mismo escenario corriendo con Round Robin y el quantum original (medición R5), se distribuye un poco mas parejo pero aun a favor de las operaciones I/O a razón aproximada de 13/10. Sin embargo con el quantum reducido (medición R10) la diferencia es mucho menor (pero aun a favor de operaciones I/Os) de 10600 ~ 10500 aprox

**3)**  En los escenarios que involucran operaciones I/Os corriendo en Round Robin ,son favorecidas por el scheduler las mediciones con un quantum reducido, en comparación a las realizadas con el quantum original (R1 vs R6, R3 vs R8 y R5 vs R10) i.e. el scheduler los elige mas veces

**4)** En escenarios de todos cpubench ,el promedio de MFLOPS/100T disminuye levemente al reducir el quantum ya sea corriendo en Round Robin o con nuestro MLFQ (mediciones R2, R4, R7, R9, M2, M4, M7 y M9)

**5)** No se observo cambio notable ,respecto a las mediciones, al correr varias veces el mismo escenario 
