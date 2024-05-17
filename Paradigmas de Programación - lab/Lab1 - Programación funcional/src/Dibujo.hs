module Dibujo (Dibujo (..), figura, encimar, apilar, juntar, rot45, rotar, espejar, -- Constructores
               comp, (^^^), (.-.), (///), r90, r180, r270, encimar4, cuarteto, ciclar, mapDib, change, foldDib) where

-- nuestro lenguaje 
data Dibujo a = Figura a
              | Encimar (Dibujo a) (Dibujo a)
              | Apilar Float Float (Dibujo a) (Dibujo a)
              | Juntar Float Float (Dibujo a) (Dibujo a)
              | Rot45 (Dibujo a)
              | Rotar (Dibujo a)
              | Espejar (Dibujo a)
              deriving (Eq, Show)

-- data TriORect = Triangulo | Rectangulo deriving (Eq, Show)
-- type Fantastica = Dibujo TriORect            

-- combinadores
infixr 6 ^^^

infixr 7 .-.

infixr 8 ///

-- Composición n-veces de una función con sí misma. Componer 0 veces
-- es la función identidad, componer 1 vez es aplicar la función 1 vez, etc.
-- Componer negativamente es un error!
comp :: Int -> (a -> a) -> a -> a
comp n f x 
    | n == 0 = x
    | n > 0 = comp (n-1) f (f x)
    | otherwise = error "No se puede componer negativamente"

-- Funciones constructoras
figura :: a -> Dibujo a
figura = Figura

encimar :: Dibujo a -> Dibujo a -> Dibujo a
encimar = Encimar

apilar :: Float -> Float -> Dibujo a -> Dibujo a -> Dibujo a
apilar = Apilar

juntar :: Float -> Float -> Dibujo a -> Dibujo a -> Dibujo a
juntar = Juntar

rot45 :: Dibujo a -> Dibujo a
rot45 = Rot45

rotar :: Dibujo a -> Dibujo a
rotar = Rotar

espejar :: Dibujo a -> Dibujo a
espejar = Espejar


-- Superpone un dibujo con otro.
(^^^) :: Dibujo a -> Dibujo a -> Dibujo a
(^^^) = encimar

-- Pone el primer dibujo arriba del segundo, ambos ocupan el mismo espacio.
(.-.) :: Dibujo a -> Dibujo a -> Dibujo a
(.-.) = apilar 1 1

-- Pone un dibujo al lado del otro, ambos ocupan el mismo espacio.
(///) :: Dibujo a -> Dibujo a -> Dibujo a
(///) = juntar 1 1

-- rotaciones
r90 :: Dibujo a -> Dibujo a
r90 = rotar

r180 :: Dibujo a -> Dibujo a
r180 = comp 2 rotar

r270 :: Dibujo a -> Dibujo a
r270 = comp 3 rotar

-- una figura repetida con las cuatro rotaciones, superimpuestas.
encimar4 :: Dibujo a -> Dibujo a
encimar4 d = (^^^) d ((^^^) ((^^^) (r90 d) (r180 d)) (r270 d))

-- cuatro figuras en un cuadrante.
cuarteto :: Dibujo a -> Dibujo a -> Dibujo a -> Dibujo a -> Dibujo a
cuarteto d1 d2 d3 d4 = (.-.) ((///) d1 d2) ((///) d3 d4)

-- Cuadrado con el mismo dibujo rotado i * 90, para i ∈ {0, ..., 3}.
-- No confundir con encimar4!
ciclar :: Dibujo a -> Dibujo a
ciclar d = (.-.) ((///) d (r270 d)) ((///) (r90 d) (r180 d)) 



-- map para nuestro lenguaje
mapDib :: (a -> b) -> Dibujo a -> Dibujo b
mapDib f (Figura a) = Figura (f a)
mapDib f (Encimar d1 d2)  = Encimar (mapDib f d1) (mapDib f d2)
mapDib f (Apilar n1 n2 d1 d2) = Apilar n1 n2 (mapDib f d1) (mapDib f d2)
mapDib f (Juntar n1 n2 d1 d2) = Juntar n1 n2 (mapDib f d1) (mapDib f d2)
mapDib f (Rot45 d) = Rot45 (mapDib f d)
mapDib f (Rotar d) = Rotar (mapDib f d)
mapDib f (Espejar d) = Espejar (mapDib f d)

-- Cambiar todas las básicas de acuerdo a la función.
change :: (a -> Dibujo b) -> Dibujo a -> Dibujo b       -- ????????
change f (Figura a) = f a
change f (Encimar d1 d2)  = Encimar (change f d1) (change f d2)
change f (Apilar n1 n2 d1 d2) = Apilar n1 n2 (change f d1) (change f d2)
change f (Juntar n1 n2 d1 d2) = Juntar n1 n2 (change f d1) (change f d2)
change f (Rot45 d) = Rot45 (change f d)
change f (Rotar d) = Rotar (change f d)
change f (Espejar d) = Espejar (change f d)

-- change f (Figura a) = f a
-- change f d = mapDib change f a 

-- Principio de recursión para Dibujos.
foldDib ::
  (a -> b) ->                         -- f1 as figura
  (b -> b) ->                         -- f2 as rot45
  (b -> b) ->                         -- f3 as rotar
  (b -> b) ->                         -- f4 as espejar
  (Float -> Float -> b -> b -> b) ->  -- f5 as apilar
  (Float -> Float -> b -> b -> b) ->  -- f6 as juntar
  (b -> b -> b) ->                    -- f7 as encimar
  Dibujo a ->                         
  b
foldDib f1 _  _  _  _  _  _  (Figura a)           = f1 a
foldDib f1 f2 f3 f4 f5 f6 f7 (Rot45 a)            = f2 (foldDib f1 f2 f3 f4 f5 f6 f7 a)
foldDib f1 f2 f3 f4 f5 f6 f7 (Rotar a)            = f3 (foldDib f1 f2 f3 f4 f5 f6 f7 a)
foldDib f1 f2 f3 f4 f5 f6 f7 (Espejar a)          = f4 (foldDib f1 f2 f3 f4 f5 f6 f7 a)
foldDib f1 f2 f3 f4 f5 f6 f7 (Apilar n1 n2 d1 d2) = f5 n1 n2 (foldDib f1 f2 f3 f4 f5 f6 f7 d1) (foldDib f1 f2 f3 f4 f5 f6 f7 d2)
foldDib f1 f2 f3 f4 f5 f6 f7 (Juntar n1 n2 d1 d2) = f6 n1 n2 (foldDib f1 f2 f3 f4 f5 f6 f7 d1) (foldDib f1 f2 f3 f4 f5 f6 f7 d2)
foldDib f1 f2 f3 f4 f5 f6 f7 (Encimar d1 d2)      = f7 (foldDib f1 f2 f3 f4 f5 f6 f7 d1) (foldDib f1 f2 f3 f4 f5 f6 f7 d2)