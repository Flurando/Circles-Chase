(define (new-enemy-every-5s)
  (with-agenda play-timer
	       (every (5 5)
		      (enemy-spawn!))))

(new-enemy-every-5s)
