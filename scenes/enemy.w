define-module : scenes enemy
  . #:use-module : chickadee math vector
  . #:use-module : chickadee graphics color
  . #:use-module : chickadee graphics path
  . #:use-module : chickadee scripting
  . #:use-module : (scenes player) #:prefix player-
  . #:use-module : scenes score-and-time
  . #:use-module : (scenes sea tentacle) #:prefix tentacle- #:select : get-position
  . #:export : get-position-list spawn! pop! clean! update draw

define *radius* 30
define position-list '()

define : get-position-list
  . position-list

define : spawn!
  set! position-list
    cons : vec2 (+ 100 (random 440)) (+ 240 (random 240))
      . position-list

define : pop!
  unless : null? position-list
    set! position-list : cdr position-list

define : clean!
  set! position-list '()

;; TODO make the enemy move aimlessly
;; need to generate normalized vector with random direction
;; DONE check position list against tentacle position
;; delete the touched enemy
;; DONE for untouched enemy existing
;; lose 5 health every 5 seconds
define-syntax distance
  lambda : x
    syntax-case x ()
      (_ v1 v2)
        . #'((@ (chickadee math vector) vec2-magnitude) ((@ (chickadee math vector) vec2-) v1 v2))
        
define *script* #f
define *check-script* #f
define *reward-script* #f
define : update dt
  unless *script*
    set! *script*
      script
        while #t
          spawn!
          spawn!
          sleep 5
          player-lose-health! 20
  unless *check-script*
    set! *check-script*
      script
        while #t
          sleep 0.5
          let : : t-pos : tentacle-get-position
            set! position-list
              let loop : : lst : get-position-list
                if : null? lst
                  . '()
                  let : : e-pos : car lst
                    if {(distance t-pos e-pos) <= {3 * *radius*}}
                      loop : cdr lst
                      cons e-pos : loop : cdr lst
  unless *reward-script*
    set! *reward-script*
      script
        while #t
          sleep 3
          when {(player-get-health) >= 95}
            score-gain! 1
  when : null? position-list
    cancel-script *script*
    cancel-script *check-script*
    set! *script* #f
    set! *check-script* #f
    player-recover-health! 5
  . #f

define : draw alpha
  unless : null? position-list
    for-each
      lambda : position
        let* ((painter (with-style ((fill-color yellow)) (fill (circle position *radius*)))) (canvas (make-canvas painter)))
          draw-canvas canvas
      . position-list
 
