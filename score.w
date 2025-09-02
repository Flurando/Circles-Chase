define-module : score
  . #:use-module : (chickadee scripting)
  . #:export : score-to-show score-lose! score-gain! score-reset!
  
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

