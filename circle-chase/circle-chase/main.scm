(define-module (circle-chase main)
  #:use-module (circle-chase player)
  #:use-module (circle-chase enemy)
  #:export (load
	    update
	    draw))

(define (load)
  (set! *random-state* (random-state-from-platform)))

(define (draw alpha)
  (player-draw alpha))

(define (update dt)
  (player-update dt))
