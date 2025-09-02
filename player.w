define-module : player
  . #:use-module : chickadee
  . #:use-module : chickadee scripting
  . #:use-module : chickadee math
  . #:use-module : chickadee math vector
  . #:use-module : chickadee math matrix
  . #:use-module : chickadee graphics color
  . #:use-module : chickadee graphics path
  . #:use-module : srfi srfi-9
  . #:export : get-position set-position! get-health set-health! timer timer-reset! move draw

define position (vec2 240 80)
define health 20

define : get-position
  . position
  
define : set-position! vec
  set! position vec
  
define : get-health
  . health

define : set-health! int
  set! health int

define canvas
  make-empty-canvas #:matrix
    make-matrix3 1 0 0 0 1 0 0 0 1
    
define timer : make-agenda ; this timer tracks the game time

define : timer-reset!
  set! timer : make-agenda

define : key->1 key
  if : key-pressed? key
    . 1
    . 0
    
define : move
  let : : nvec : vec2-normalize : vec2 (- (key->1 'd) (key->1 'a)) (- (key->1 'w) (key->1 's))
    vec2-add! position nvec
  set-vec2-x! position : clamp 0.0 640.0 : vec2-x position
  set-vec2-y! position : clamp 0.0 480.0 : vec2-y position

define : draw
  let : : painter : with-style ([fill-color green]) : fill : circle position 10.0
    set-canvas-painter! canvas painter
    draw-canvas canvas
