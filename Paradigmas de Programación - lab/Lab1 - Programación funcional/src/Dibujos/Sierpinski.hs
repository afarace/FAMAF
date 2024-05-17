module Dibujos.Sierpinski where
import FloatingPic
import qualified Graphics.Gloss.Data.Point.Arithmetic as V
import Graphics.Gloss ( line, blank, polygon, color, white, black)
import Dibujo



-- Supongamos que eligen.
data Sierpin = Triangulo | Fondo | Nada
    deriving (Show, Eq)

--type FloatingPic = Vector -> Vector -> Vector -> Picture
--type Output a = a -> FloatingPic


-- Las coordenadas que usamos son:
--
--  x + y
--  |
--  x --- x + w
--
-- por ahi deban ajustarlas

interSierpi :: Output Sierpin
interSierpi Triangulo x y w = color white $ line . map (x V.+) $ [c(0,0), c(50,100), c(100,0), c(0,0)]
    where
        c(a, b) = (a/100) V.* y V.+ (b/100) V.* w
interSierpi Fondo x y w = color black $ polygon . map (x V.+) $ [c(0,0), c(10,0), c(10,10), c(0,10)]
    where
        c(a, b) = (a/10) V.* y V.+ (b/10) V.* w
interSierpi Nada _ _ _ = blank

fractal :: Dibujo Sierpin -> Dibujo Sierpin
fractal d = (.-.) (juntar 0.25 0.75 (figura Nada) (juntar 0.50 0.25 d (figura Nada))) ((///) d d)

sierpinski :: Int -> Dibujo Sierpin
sierpinski n = encimar (figura Fondo) (comp n fractal (figura Triangulo)) 


sierpinskiConf :: Conf
sierpinskiConf = Conf {
    name = "Sierpinski"
    , pic = sierpinski 8
    , bas = interSierpi
}