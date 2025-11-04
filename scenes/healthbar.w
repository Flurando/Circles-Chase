define-module : scenes healthbar
  . #:use-module : chickadee math vector
  . #:use-module : chickadee graphics path
  . #:use-module : chickadee graphics color
  . #:use-module : utils graphics
  . #:use-module : (scenes player) #:prefix player-
  . #:export : draw update

define : draw alpha
  fill-rounded-rectangle yellow 10.0 450.0 110.0 25.0
  fill-rounded-rectangle red 15.0 455.0 (player-get-health) 15.0

define update
    lambda : dt
      . #f
      
