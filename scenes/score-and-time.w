define-module : scenes score-and-time
  . #:use-module : ice-9 format
  . #:use-module : (chickadee math vector) #:select : vec2
  . #:use-module : (chickadee graphics text) #:select : draw-text
  . #:use-module : (chickadee graphics color) #:select : red
  . #:use-module : (chickadee scripting)
  . #:use-module : (scenes player) #:prefix player-
  . #:export : draw update score-to-show score-lose! score-gain! score-reset! timer timer-reset!
  
define draw
      lambda : alpha
        draw-text
          format #f "Score: ~d" : score-to-show
          vec2 240.0 460.0
          . #:scale : vec2 2.0 2.0
        draw-text
          format #f "Time: ~d seconds"
            inexact->exact : truncate-quotient (with-agenda timer (agenda-time)) 1
          vec2 220.0 420.0
          . #:color red
          . #:scale : vec2 2.0 2.0
          
define update
      lambda : dt
        . #f

define score 0

define : score-to-show
  if : > score 0
    . score
    . 0

define : score-lose! num
  set! score : - score num

define : score-gain! num
  set! score : + score num
  
define : score-reset!
  set! score 0

define timer : make-agenda ; this timer tracks the game time

define : timer-reset!
  set! timer : make-agenda
