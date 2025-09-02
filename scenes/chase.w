define-module : scenes chase
  . #:use-module : (chickadee scripting)
  . #:use-module : (chickadee math) #:select : clamp
  . #:use-module : (chickadee math rect)
  . #:use-module : (chickadee math vector)
  . #:use-module : (healthbar) #:prefix healthbar-
  . #:use-module : (player) #:prefix player-
  . #:use-module : (enemy) #:prefix enemy-
  . #:use-module : score

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
  player-timer-reset!
  score-reset!
  
define-public draw
     lambda : alpha
       healthbar-draw
       player-draw
       enemy-draw
define-public update
     lambda : dt
       display "inside chase.w\n"
       with-agenda player-timer
         update-agenda dt
       display "agenda has been updated\n"
       ;; update
       player-move
       enemy-move
       healthbar-update
       display "player, enemy and healthbar have been updated\n"
       ;; scene mechanics
       lose-score-when-touched!
       display "1\n"
       unless one-time-lock
         display "2\n"
         set! one-time-lock #t
         display "3\n"
         with-agenda player-timer
           ;; auto spawn enemy every 3s
           every : 3 5
             enemy-spawn!
           ;; add-1-score-every-5-seconds
           every 5
             score-gain! 1
           display "4\n"
       ;; switch
       display "5\n"
       with-agenda player-timer
         if (>= (agenda-time) 61)
            . 0
            if (zero? (player-get-health))
              . 1
              . (begin (display 6)(newline) #f)
