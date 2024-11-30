use-modules : chickadee graphics path

define : draw alpha
  draw-text
    format #f "Score: ~d" score
    vec2 240.0 460.0
    . #:scale : vec2 2.0 2.0
  draw-text
    format #f "Time: ~d seconds"
      inexact->exact : truncate-quotient (agenda-time) 1
    vec2 220.0 420.0
    . #:color red
    . #:scale : vec2 2.0 2.0
    
  player-draw
  
  enemy-auto-draw

define : update delta
  update-agenda delta
  
  let
    : nvec : vec2-normalize : vec2 {(key->1 'd) - (key->1 'a)} {(key->1 'w) - (key->1 's)}
    . {position vec2-add! nvec}
  
  enemy-auto-move

;;player abstractions
define position : vec2 240.0 80.0

define player-canvas
  make-empty-canvas
    . #:matrix
    make-matrix3
      . 1 0 0
      . 0 1 0
      . 0 0 1

define : player-draw
  let 
    : painter : with-style ([fill-color green]) : fill : circle position 10.0
    set-canvas-painter! player-canvas painter
  draw-canvas player-canvas  

;;enemy abstractions
define enemy-positions-list : list

define : spawn!
  set! enemy-positions-list
    append enemy-positions-list : list : vec2 (random 640) (random 480)

define : enemy-auto-move
  unless : null? enemy-positions-list
    for-each
      lambda : position2
        let 
          : nvec : vec2-normalize {position vec2- position2}
          . {position2 vec2-add! {nvec vec2* 0.5}}
      . enemy-positions-list

define : enemy-auto-draw
  unless : null? enemy-positions-list
    for-each
      lambda : position2
        draw-text "O" position2
          . #:color black
          . #:scale : vec2 5.0 5.0
      . enemy-positions-list

;;game score
define score 0

define score-timer : make-agenda


;;scheduled tasks
every 1
  with-agenda score-timer
    update-agenda 1

with-agenda score-timer
  schedule-every
    . 5
    lambda : 
      set! score {score + 1}

every 10
  spawn!


;;set random seed according to the official manual
set! *random-state* : random-state-from-platform


;;helper functions
define : key->1 key
  if : key-pressed? key
    . 1
    . 0
