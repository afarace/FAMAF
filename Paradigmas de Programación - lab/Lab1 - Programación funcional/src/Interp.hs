module Interp
  ( interp,
    initial,
  )
where

import Dibujo
import FloatingPic
import Graphics.Gloss (Display (InWindow), color, display, makeColorI, pictures, translate, white, Picture)
import qualified Graphics.Gloss.Data.Point.Arithmetic as V

-- Dada una computación que construye una configuración, mostramos por
-- pantalla la figura de la misma de acuerdo a la interpretación para
-- las figuras básicas. Permitimos una computación para poder leer
-- archivos, tomar argumentos, etc.
initial :: Conf -> Float -> IO ()
initial (Conf n dib intBas) size = display win white $ withGrid fig size
  where
    win = InWindow n (ceiling size, ceiling size) (0, 0)
    fig = interp intBas dib (0, 0) (size, 0) (0, size)
    desp = -(size / 2)
    withGrid p x = translate desp desp $ pictures [p, color grey $ grid (ceiling $ size / 10) (0, 0) x 10]
    grey = makeColorI 100 100 100 100

-- Definido en FloatingPic.hs:
-- type FloatingPic = Vector -> Vector -> Vector -> Picture
-- type Output a = a -> FloatingPic

-- Interpretación de (^^^)
ov :: Picture -> Picture -> Picture
ov pic1 pic2 = pictures[pic1, pic2]

r45 :: FloatingPic -> FloatingPic
r45 fp d w h = fp (d V.+ half(w V.+ h)) (half (w V.+ h)) (half (h V.- w))

rot :: FloatingPic -> FloatingPic
rot fp d w h = fp (d V.+ w) h (V.negate w)

esp :: FloatingPic -> FloatingPic
esp fp d w = fp (d V.+ w) (V.negate w)

sup :: FloatingPic -> FloatingPic -> FloatingPic
sup fp1 fp2 d w h = pictures[fp1 d w h, fp2 d w h]

jun :: Float -> Float -> FloatingPic -> FloatingPic -> FloatingPic
jun m n f1 f2 d w h = pictures[f1 d w' h, f2 (d V.+ w') (r' V.* w) h]
  where r' = n/(m+n)
        r = m/(m+n)
        w' = r V.* w

api :: Float -> Float -> FloatingPic -> FloatingPic -> FloatingPic
api m n f1 f2 d w h = pictures [f1 (d V.+ h') w (r V.* h),f2 d w h']
  where r = m/(m+n)
        r' = n/(m+n)
        h' = r' V.* h

interp :: Output a -> Output (Dibujo a)
interp fp (Figura a) = fp a
interp fp (Encimar d1 d2) = sup (interp fp d1) (interp fp d2)
interp fp (Apilar n1 n2 d1 d2) = api n1 n2 (interp fp d1) (interp fp d2)
interp fp (Juntar n1 n2 d1 d2) = jun n1 n2 (interp fp d1) (interp fp d2)
interp fp (Rot45 d) = r45 (interp fp d)
interp fp (Rotar d) = rot (interp fp d)
interp fp (Espejar d) = esp (interp fp d)

-- interp :: a -> FloatingPic -> Dibujo a -> FloatingPic