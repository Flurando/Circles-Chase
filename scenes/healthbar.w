define-module : scenes healthbar
  . #:use-module : chickadee math vector
  . #:use-module : chickadee graphics path
  . #:use-module : chickadee graphics color
  . #:use-module : (scenes player) #:prefix player-
  . #:export : draw update

define : draw alpha
  draw-canvas
    make-canvas
      with-style ([fill-color yellow]) : fill : rounded-rectangle (vec2 10.0 450.0) 110.0 25.0
  draw-canvas
   make-canvas
    with-style : : fill-color red
      fill : rounded-rectangle (vec2 15.0 455.0) (player-get-health) 15.0

define update
    lambda : dt
      . #f
      
