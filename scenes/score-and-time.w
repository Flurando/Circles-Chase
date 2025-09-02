define-module : scenes score-and-time
  . #:use-module : ice-9 format
  . #:use-module : (chickadee math vector) #:select : vec2
  . #:use-module : (chickadee graphics text) #:select : draw-text
  . #:use-module : (chickadee graphics color) #:select : red
  . #:use-module : (chickadee scripting)
  . #:use-module : (player) #:prefix player-
  . #:use-module : (score) #:select : score-to-show
  . #:export : draw update
  
define draw
      lambda : alpha
        draw-text
          format #f "Score: ~d" : score-to-show
          vec2 240.0 460.0
          . #:scale : vec2 2.0 2.0
        draw-text
          format #f "Time: ~d seconds"
            inexact->exact : truncate-quotient (with-agenda player-timer (agenda-time)) 1
          vec2 220.0 420.0
          . #:color red
          . #:scale : vec2 2.0 2.0
          
define update
      lambda : dt
        display "\n7\n"
        . #f


