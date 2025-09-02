define-module : scenes enemy
  . #:use-module : chickadee math vector
  . #:use-module : chickadee graphics color
  . #:use-module : chickadee graphics path
  . #:use-module : (scenes player) #:prefix player-
  . #:export : get-position-list spawn! pop! clean! update draw

define position-list '()

define : get-position-list
  . position-list
  
define speed-list '()

define : spawn!
  set! position-list
    cons : vec2 (random 640) (random 480)
      . position-list
  set! speed-list
    cons : random:uniform
      . speed-list

define : pop!
  unless : null? position-list
    set! position-list : cdr position-list
    set! speed-list : cdr speed-list

define : clean!
  set! position-list '()
  set! speed-list '()

define : update dt
  unless : null? position-list
    for-each
     lambda : position2 speed2
       let : : nvec : vec2-normalize : vec2- (player-get-position) position2
         vec2-add! position2 : vec2* nvec speed2
     . position-list
     . speed-list

define : draw alpha
  unless : null? position-list
    for-each
      lambda : position
        let* ((painter (with-style ((fill-color yellow)) (fill (circle position 10)))) (canvas (make-canvas painter)))
          draw-canvas canvas
      . position-list
 
