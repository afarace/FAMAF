module Dibujo where

-- Definicion  del lenguaje
data Dibujo a = Basica a 
              | Rotar (Dibujo a)
              | Apilar Int Int (Dibujo a) (Dibujo a)
              | Encimar (Dibujo a) (Dibujo a)
              | Resize Int (Dibujo a)
              deriving(Show, Eq)


-- Funcion Map (de Basicas) para nuestro sub-lenguaje.
mapDib :: (a -> b) -> Dibujo a -> Dibujo b
mapDib f (Basica x) = Basica (f x) 
mapDib f (Rotar d1) = Rotar (mapDib f d1)
mapDib f (Apilar n m d1 d2) = Apilar n m (mapDib f d1) (mapDib f d2)
mapDib f (Encimar d1 d2) = Encimar (mapDib f d1) (mapDib f d2)
mapDib f (Resize x dib) = Resize x (mapDib f dib)


-- Funcion Fold para nuestro sub-lenguaje.
foldDib :: (a -> b) -> (b -> b) ->
       (Int -> Int -> b -> b -> b) -> 
       (b -> b -> b) ->
       (Int -> b -> b) ->
       Dibujo a -> b

foldDib sB sR sA sEn sRe d =
    let foldDibRecursiva = foldDib sB sR sA sEn sRe
    in case d of
        Basica x -> sB x
        Rotar d -> sR $ foldDibRecursiva d
        Apilar m n d1 d2 -> sA m n (foldDibRecursiva d1) (foldDibRecursiva d2)
        Encimar d1 d2 -> sEn (foldDibRecursiva d1) (foldDibRecursiva d2)
        Resize x dib -> sRe x (foldDibRecursiva dib)
     



--COMPLETAR (EJERCICIO 1-a)
toBool:: Dibujo (Int,Int) -> Dibujo Bool
toBool  (Basica (a, b)) | mod b a == 0 = Basica True
                        | otherwise = Basica False
toBool (Rotar dib) = Rotar (toBool dib)
toBool (Apilar n m d1 d2) = Apilar n m (toBool d1) (toBool d2)
toBool (Encimar d1 d2) = Encimar (toBool d1) (toBool d2)
tobool (Resize x dib) = Resize x (toBool dib)

--COMPLETAR (EJERCICIO 1-b)
toBool2:: Dibujo (Int,Int) -> Dibujo Bool
toBool2 dib = mapDib (\(a, b) -> mod b a == 0)  dib

--COMPLETAR (EJERCICIO 1-c)

profundidad:: Dibujo a -> Int
profundidad (Basica x) = 1
profundidad (Rotar dib) = 1 + profundidad dib
profundidad (Apilar n m d1 d2) = 1 + max (profundidad d1) (profundidad d2)
profundidad (Encimar d1 d2) = 1 + max (profundidad d1) (profundidad d2)
profundidad (Resize x dib) = profundidad dib


--COMPLETAR (EJERCICIO 1-d)
profundidad2:: Dibujo a -> Int
profundidad2 dib = foldDib (\x -> 1)
                          (\x -> 1 +  x)
                          (\i j x y -> 1 + max x y)
                          (\x y -> 1 + max x y)
                          (\i x -> x)
                          dib


