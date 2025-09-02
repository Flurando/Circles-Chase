define-module : scenes lose
  . #:use-module : (chickadee) #:select : mouse-button-pressed?
  . #:use-module : chickadee scripting
  . #:use-module : (chickadee math vector) #:select : vec2
  . #:use-module : chickadee graphics color
  . #:use-module : (chickadee graphics text) #:select : draw-text
  . #:export : draw update
  
define draw
      lambda : alpha
        draw-text "You LOSE"
          vec2 210 220
          . #:color white
          . #:scale : vec2 5.0 5.0

define update
      lambda : dt
          mouse-button-pressed? 'left
        


