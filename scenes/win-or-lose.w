define-module : scenes win-or-lose
  . #:use-module : (chickadee scripting)
  . #:use-module : (chickadee math) #:select : clamp
  . #:use-module : (chickadee math rect)
  . #:use-module : (chickadee math vector)
  . #:use-module : (scenes player) #:prefix player-
  . #:use-module : (scenes enemy) #:prefix enemy-
  . #:use-module : (scenes score-and-time) #:select : score-to-show score-lose! score-gain! score-reset! timer timer-reset!
             
define : cleanup!
  enemy-clean!
  player-set-health! 100.0
  timer-reset!
  score-reset!
  
define-public draw
     lambda : alpha
       if #f #f
define-public update
     lambda : dt
       with-agenda timer
         update-agenda dt
       ;; switch
       with-agenda timer
         if (>= (agenda-time) 61)
            begin : cleanup!
              . 0
            if (zero? (player-get-health))
              begin : cleanup!
                . 1
              . #f
