define-module : healthbar
  . #:use-module : chickadee math vector
  . #:use-module : chickadee graphics path
  . #:use-module : chickadee graphics color
  . #:use-module : (player) #:prefix player-
  . #:export : load draw update

define background-canvas #f
define foreground-canvas #f

define : load
  set! background-canvas
    make-canvas
      with-style ([fill-color yellow]) : fill : rounded-rectangle (vec2 10.0 450.0) 110.0 25.0
  set! foreground-canvas
    make-canvas
      with-style : : fill-color red
        fill : rounded-rectangle (vec2 15.0 455.0) (player-get-health) 15.0

define : draw
  draw-canvas background-canvas
  ;;draw-canvas foreground-canvas
  draw-canvas
   make-canvas
    with-style : : fill-color red
      fill : rounded-rectangle (vec2 15.0 455.0) (player-get-health) 15.0

define update #f
let : : history-health -1.0
  set! update
    lambda ()
      unless : = (player-get-health) history-health
        set-canvas-painter! foreground-canvas
          with-style : : fill-color red
            fill : rounded-rectangle (vec2 15.0 455.0) (player-get-health) 15.0
        set! history-health (player-get-health)
      
