define-module : player
  . #:use-module : utils
  . #:use-module : chickadee math
  . #:use-module : chickadee math vector
  . #:use-module : chickadee graphics color
  . #:use-module : chickadee graphics path
  . #:export : position health canvas move! draw!

define position : vec2 240.0 80.0
define health 100.0
define canvas
  make-empty-canvas #:matrix
		      make-matrix3 1 0 0
				 . 0 1 0
				 . 0 0 1

define : move!
  let :: nvec : vec2-normalize : vec2 (- (key->1 'd) (key->1 'a)) (- (key->1 'w) (key->1 's))
    vec2-add! position nvec
  set-vec2-x! position : clamp 0.0 640.0 : vec2-x position
  set-vec2-y! position : clamp 0.0 480.0 : vec2-y position

define : draw!
  let :: painter : with-style ([fill-color green]) : fill : circle position 10.0
    set-canvas-painter! canvas painter
    draw-canvas canvas
