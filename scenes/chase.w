define-module : scenes chase
  . #:use-module : (chickadee scripting)
  . #:use-module : (chickadee math) #:select : clamp
  . #:use-module : (chickadee math rect)
  . #:use-module : (chickadee math vector)
  . #:use-module : (healthbar) #:prefix healthbar-
  . #:use-module : (player) #:prefix player-
  . #:use-module : (enemy) #:prefix enemy-
  . #:use-module : (scenes score-and-time) #:select : score-to-show score-lose! score-gain! score-reset! timer timer-reset!

define one-time-lock #f

define touch-lock #f
define : set-touch-lock!
  set! touch-lock #t
  after 2
    set! touch-lock #f
define : lose-score-when-touched!
  unless touch-lock
           map
             lambda : vec
               let : : player-rect : make-rect (- (vec2-x (player-get-position)) 10) (- (vec2-y (player-get-position)) 10) 20 20
                 when : rect-contains-vec2? player-rect vec
                   set-touch-lock!
                   player-set-health! : clamp 0.0 100.0 : - (player-get-health) 10.0
                   score-lose! 1
             enemy-get-position-list
             
define : cleanup!
  enemy-clean!
  player-set-health! 100.0
  timer-reset!
  score-reset!
  set! one-time-lock #f
  
define-public draw
     lambda : alpha
       healthbar-draw
       player-draw
       enemy-draw
define-public update
     lambda : dt
       with-agenda timer
         update-agenda dt
       ;; update
       player-update
       enemy-update
       healthbar-update
       ;; scene mechanics
       lose-score-when-touched!
       unless one-time-lock
         set! one-time-lock #t
         with-agenda timer
           ;; auto spawn enemy every 3s
           every : 3 5
             enemy-spawn!
           ;; add-1-score-every-5-seconds
           every 5
             score-gain! 1
       ;; switch
       with-agenda timer
         if (>= (agenda-time) 61)
            begin : cleanup!
              . 0
            if (zero? (player-get-health))
              begin : cleanup!
                . 1
              . #f
