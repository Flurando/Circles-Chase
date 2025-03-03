(define (key->1 key)
  (if (key-pressed? key)
      1
      0))

(define (void . args)
  (if #f #f))

(define cleanup!
	  (lambda ()
	    (enemy-clean!)
	    (set! player-health 100.0)
	    (set! play-timer (make-agenda))))
