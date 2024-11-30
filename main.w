include "setup.scm"
include "utils.scm"
include "player.scm"
include "enemy.scm"
include "score.scm"
include "challenge-loader.scm"

;;DRAW
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

;;UPDATE
define : update delta
  update-agenda delta  
  player-move  
  enemy-auto-move
