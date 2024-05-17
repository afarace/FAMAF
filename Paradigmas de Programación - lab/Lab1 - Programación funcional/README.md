---
title: Laboratorio de Funcional
author: Agustín Farace, Wilfredo Avila, Marcos Avellaneda.
---
[Consigna del laboratorio](./Consigna-Lab1.pdf)

# 1. Tareas

## Verificación de que pueden hacer las cosas.

- [x] Haskell instalado y testeos provistos funcionando. (En Install.md están las instrucciones para instalar.)

## 1.1. Lenguaje

- [x] Módulo `Dibujo.hs` con el tipo `Dibujo` y combinadores. Puntos 1 a 3 de la consigna.
- [x] Definición de funciones (esquemas) para la manipulación de dibujos.
- [x] Módulo `Pred.hs`. Punto extra si definen predicados para transformaciones innecesarias (por ejemplo, espejar dos veces es la identidad).

## 1.2. Interpretación geométrica

- [x] Módulo `Interp.hs`.

## 1.3. Expresión artística (Utilizar el lenguaje)

- [x] El dibujo de `Dibujos/Feo.hs` se ve lindo.
- [x] Módulo `Dibujos/Grilla.hs`.
- [x] Módulo `Dibujos/Escher.hs`.
- [x] Módulo `Dibujos/Sierpinski.hs`.
- [x] Listado de dibujos en `Main.hs`.

## 1.4 Tests

- [x] Tests para `Dibujo.hs`.
- [x] Tests para `Pred.hs`.

# 2. Experiencia

Gracias a este laboratorio pudimos profundizar más de lo que aprendimos en primer año sobre programación funcional. Conceptos como:

- **Pensamiento declarativo:** donde te concentras en describir *qué* debe hacer un programa en lugar de *cómo* hacerlo.
- **Inmutabilidad y pureza:** trabajando con funciones no tienen efectos secundarios y siempre producen el mismo resultado dado el mismo conjunto de entradas (MONADAS NO INCLUIDAS).
- **Abstracciones:** escribiendo funciones fáciles de leer y entender al manejarse siempre en una misma capa de abstracción (no hay ejemplo más claro que el `modulo Dibujo`).
- **Funciones de Composición:** que se procesan junto con funciones auxiliares: `comp` o `foldDib` son ejemplos perfectos para evitar escribir código de formas más *ad hoc*.
- **Uso efectivo del sistema de tipos:** porque como dijo el profesor Martín Domínguez en AyEDI:
`-- En Haskell TODO tiene un tipo.` Y esta propiedad de tipos fuerte y estática que nos ayudó mucho a interpretar lo que debería hacer cada función pedida, además de atrapar errores en tiempo de compilación y escribir código más seguro y robusto.

 >**Nota:** Costo mucho entender el manejo de dependencias con cabal.

# 3. Preguntas

1. ¿Por qué están separadas las funcionalidades en los módulos indicados? Explicar detalladamente la responsabilidad de cada módulo.

2. ¿Por qué las figuras básicas no están incluidas en la definición del lenguaje, y en vez de eso, es un parámetro del tipo?

3. ¿Qué ventaja tiene utilizar una función de `fold` sobre hacer pattern-matching directo?

4. ¿Cuál es la diferencia entre los predicados definidos en Pred.hs y los tests?

## Respuestas:

1. Las funcionalidades están separadas en módulos por varias razones:
    1. Para que el código sea más fácil de leer.
    2. Para que, al momento de testear las funcionalidades, se testeen directamente los módulos. Esto hace que sea más fácil debuggear.
    3. Para que el código sea reutilizable, es decir, si en un futuro proyecto se quieren usar algunas de estas funcionalidades directamente se puede importar el módulo.
    4. Para agilizar el desarrollo del programa, ya que múltiples equipos pueden trabajar en distintas partes del programa.
    - Entre otras más...

    ***Responsabilidades de cada módulo:***

    - **Dibujo.hs**: En este módulo está la implementación del lenguaje y las funciones constructoras que nos servirán para manipular expresiones que representan un dibujo.

    - **Interp.hs**: Se encarga de representar la especificación del dibujo en una imagen utilizando la librería Gloss (este interprete es para Gloss). La función interp hace la interpretación del dibujo, que se hace de manera recursiva. La función inicial muestra el dibujo en pantalla.

    - **Main.hs**: El módulo encargado de ejecutar los dibujos.

    - **Pred.hs**: En este módulo hay funciones que determinan predicados sobre dibujos.

2. Las figuras básicas no están incluidas en la definición del lenguaje, y en vez de eso, es un parámetro del tipo porque la idea del lenguaje Dibujo es que sea polimórfico, es decir, que pueda representar un dibujo de cualquier forma que defina el usuario.

3. Con fold, se definen operaciones sobre Dibujo de manera más abstracta y generalizada. Esto evita la repetición de código.
    - Al reducir la cantidad de código que se necesita, se es menos propenso a errores.
    - Hace que el código sea más legible, ya que expresa de manera más clara la transformación de la lista.

4. La diferencia es que los predicados de Pred.hs se pueden usar para validar propiedades de ciertos dibujos para, por ejemplo, modificarlos según el cumplimiento o no de estas propiedades en tiempo de ejecución. Mientras que los tests son agentes externos al programa que nos ayudan a controlar el correcto funcionamiento del mismo.

# 4. Extras

- Se añadió un dibujo nuevo: `Sierpinski.hs` ¡Es un fractal!
- Se dibujo el pez que uso Henderson en su paper.
- Se añadió colores distintos a cada cuadrante de la grilla.

# 5. FAQ

- Antes que nada. Hay que configurar y compilar el proyecto:

    ```bash
    cabal configure
    cabal build
    ```

- ¿Cómo veo los dibujos?

    ```bash
    cabal run dibujos <Nombre_del_dibujo>
    # Elegible entre: Escher, Grilla, Feo y Sierpinski  
    ```

- ¿Cómo corro los test?

    ```bash
    cabal test <Nombre_del_test>
    # Elegible entre: dibujo, gloss y predicados  
    ```

