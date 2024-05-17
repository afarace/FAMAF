module Pred (
  Pred,
  cambiar, anyDib, allDib, orP, andP, falla
) where
import Dibujo (Dibujo (..), foldDib,)


-- `Pred a` define un predicado sobre figuras básicas. Por ejemplo,
-- `(== Triangulo)` es un `Pred TriOCuat` que devuelve `True` cuando la
-- figura es `Triangulo`.

type Pred a = a -> Bool

-- Dado un predicado sobre básicas, cambiar todas las que satisfacen
-- el predicado por la figura básica indicada por el segundo argumento.
cambiar :: Pred a -> (a -> Dibujo a) -> Dibujo a -> Dibujo a
cambiar p f (Encimar d1 d2)  = Encimar (cambiar p f d1) (cambiar p f d2)
cambiar p f (Apilar n1 n2 d1 d2) = Apilar n1 n2 (cambiar p f d1) (cambiar p f d2)
cambiar p f (Juntar n1 n2 d1 d2) = Juntar n1 n2 (cambiar p f d1) (cambiar p f d2)
cambiar p f (Rot45 d) = Rot45 (cambiar p f d)
cambiar p f (Rotar d) = Rotar (cambiar p f d)
cambiar p f (Espejar d) = Espejar (cambiar p f d)
cambiar p f (Figura a) = checker
    where checker | p a = f a 
                  | otherwise = Figura a 


-- Alguna básica satisface el predicado.
anyDib :: Pred a -> Dibujo a -> Bool  -- anyFig, are you?
anyDib p d = foldDib p id id id or1 or1 or2 d
    where or1 _ _ b1 b2 = b1 || b2
          or2 b1 b2     = b1 || b2

-- Todas las básicas satisfacen el predicado.
allDib :: Pred a -> Dibujo a -> Bool  -- allFig, are you?
allDib p d = foldDib p id id id and1 and1 and2 d
    where and1 _ _ b1 b2 = b1 && b2
          and2 b1 b2     = b1 && b2

-- Los dos predicados se cumplen para el elemento recibido.
andP :: Pred a -> Pred a -> Pred a
andP p1 p2 x = p1 x && p2 x

-- Algún predicado se cumple para el elemento recibido.
orP :: Pred a -> Pred a -> Pred a
orP p1 p2 x = p1 x || p2 x

falla :: Bool
falla = True