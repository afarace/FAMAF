{-# OPTIONS_GHC -Wno-type-defaults #-}
module Dibujos.Grilla where
import qualified Graphics.Gloss.Data.Point.Arithmetic as V
import FloatingPic(Conf(..), Output)
import Dibujo ( Dibujo, comp, figura, cuarteto )
import Graphics.Gloss.Interface.IO.Display (Picture, Vector, pictures, text, scale, translate, color, makeColor, polygon, white)

--type FloatingPic = Vector -> Vector -> Vector -> Picture
--type Output a = a -> FloatingPic

-- Las coordenadas que usamos son:
--
--  x + y
--  |
--  x --- x + w

data Basica = Cordenada
    deriving (Show, Eq)

punto :: Vector -> Picture
punto (x1, x2) = text ("(" ++ show (round $ x1/100) ++ "," ++ show (round $ (700-x2)/100) ++ ")")

interpCord :: Output Basica
interpCord Cordenada x y w = pictures[cuar, cord]
    where 
        (x1, x2) = x
        (y1, _) = y
        (_, w2) = w
        cuadCol = makeColor ((800-x1)/800) 0.0 (x2/800) 1
        cord = color white $ translate (x1+y1/2-33) (x2+w2/2-10) $ scale 0.25 0.25 $ punto (x1, x2)
        cuar = color cuadCol $ polygon [x V.+ (2,2), x V.+ y V.+ (-2,2), x V.+ y V.+ w V.+ (-2,-2), x V.+ w V.+ (2,-2)]

grilla :: Dibujo Basica -> Dibujo Basica
grilla d = cuarteto d d d d

grillaDib :: Dibujo Basica
grillaDib = comp 3 grilla (figura Cordenada)

grillaConf :: Conf
grillaConf = Conf {
        name = "Grilla"
      , pic = grillaDib
      , bas = interpCord
    }