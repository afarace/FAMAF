module Dibujos.Escher where

import Dibujo
import FloatingPic(Conf (..), Output, zero)
import Graphics.Gloss (blue, color, line, pictures, polygon)
import qualified Graphics.Gloss.Data.Point.Arithmetic as V

-- Supongamos que eligen.
data Escher = Pez | Ele
  deriving (Show, Eq)

-- type FloatingPic= Vector -> Vector -> Vector -> Picture
-- type Output a = a -> FloatingPic

-- Las coordenadas que usamos son:
--  x + y
--  |
--  x --- x + w

interEsch :: Output Escher
interEsch Pez x y w = pictures [contorno, l1, l2, l3, l4, l5, l6, t1, t2, l7, l8, l9, l10, l11, l12]
  where
    c(a, b) = (a/100) V.* y V.+ (b/100) V.* w
    cny(a, b) = (a / 100) V.* V.negate y V.+ (b / 100) V.* w
    lmw = line . map (x V.+)
    pmw = polygon . map (x V.+)
    contorno = lmw $ [zero, c(25, 25), c(55, 05),
        c(100, 0), c(75, 20), c(50, 25), c(37, 37), c(50, 50), c(50, 75),
        c(25, 80), c(0, 100), cny(05, 55), cny(25, 25), zero]
    l1 = lmw [cny(02, 06), c(11, 24)]
    l2 = lmw [cny(07, 13), c(05, 29)]
    l3 = lmw [cny(13, 18), c(02, 36)]
    l4 = lmw [cny(19, 23), cny(01, 43)]
    l5 = lmw [cny(05, 55), c(09, 35), c(25, 25)]
    l6 = lmw [c(12, 67), c(19, 51), c(30, 33), c(49, 20), c(79, 08)]
    t1 = pmw [c(04, 65), c(09, 70), c(04, 80)]
    t2 = pmw [c(13, 72), c(19, 75), c(11, 84)]
    l7 = lmw [c(25, 80), c(29, 51), c(37, 37), c(50, 25)]
    l8 = lmw [c(42, 37), c(48, 32)]
    l9 = lmw [c(45, 41), c(48, 38)]
    l10 = lmw [c(33, 50), c(47, 56)]
    l11 = lmw [c(33, 61), c(48, 63)]
    l12 = lmw [c(30, 70), c(45, 70)]
interEsch Ele x y w = pictures [frame, letter]
  where
    c(a, b) = (a / 10) V.* y V.+ (b / 10) V.* w
    frame = line . map (x V.+) $ [(0, 0), y, y V.+ w, w, (0, 0)]
    p1 = polygon . map (x V.+) $ [c(2, 8), c(3, 8), c(3, 2), c(2, 1)]
    p2 = polygon . map (x V.+) $ [c(2, 1), c(3, 2), c(3, 2), c(6, 2), c(6, 1)]
    letter = color blue $ pictures [p1, p2]

-- El dibujo u.
dibujoU :: Dibujo Escher -> Dibujo Escher
dibujoU p = encimar (encimar d1 (r90 d1)) (encimar (r90 (r90 d1)) (r270 d1))
  where
    d1 = espejar (rot45 p)

-- El dibujo t.
dibujoT :: Dibujo Escher -> Dibujo Escher
dibujoT t = encimar t (encimar d1 (r270 d1))
  where
    d1 = espejar (rot45 t)

---- Esquina con nivel de detalle en base a la figura p.
esquina :: Int -> Dibujo Escher -> Dibujo Escher
esquina 1 p = p
esquina n p = cuarteto (esquina (n - 1) p) (lado (n - 1) p) (r90 (lado (n - 1) p)) (dibujoU p)


---- Lado con nivel de detalle.
lado :: Int -> Dibujo Escher -> Dibujo Escher
lado 1 p = p
lado n p = cuarteto (lado (n - 1) p) (lado (n - 1) p) (r90 (dibujoT p)) (dibujoT p)

--
---- Por suerte no tenemos que poner el tipo! (pero lo pongo porque haskell se queja)
noneto :: 
    Dibujo a -> Dibujo a -> Dibujo a -> Dibujo a -> Dibujo a -> 
    Dibujo a -> Dibujo a -> Dibujo a -> Dibujo a -> Dibujo a
noneto p q r s t u v w x =
  apilar 1 2
    (juntar 1 2 p ((///) q r))
    ((.-.) (juntar 1 2 s ((///) t u)) (juntar 1 2 v ((///) w x)))

---- El dibujo de Escher:
escher :: Int -> Escher -> Dibujo Escher
escher n p =
  noneto
    (esquina n (figura p))
    (lado n (figura p))
    (r270 (esquina n (figura p)))
    (r90 (lado n (figura p)))
    (dibujoU (figura p))
    (r270 (lado n (figura p)))
    (r90 (esquina n (figura p)))
    (r180 (lado n (figura p)))
    (r180 (esquina n (figura p)))

escherConf :: Conf
escherConf =
  Conf
    { name = "Escher",
      pic = escher 6 Pez,
      bas = interEsch
    }