(define lose-score-when-touched-flag #f)

(define (lose-score-when-touched-flag-up!)
  (set! lose-score-when-touched-flag #t)
  (after 2
	 (set! lose-score-when-touched-flag #f)))

(define lose-score-when-touched!
  (lambda ()
    (unless lose-score-when-touched-flag
      (map (lambda (vec)
	     (let ([player-rect (make-rect (- (vec2-x position) 10) (- (vec2-y position) 10) 20 20)])
	       (when (rect-contains-vec2? player-rect vec)
		 (lose-score-when-touched-flag-up!)
		 (set! player-health (clamp 0.0 100.0 (- player-health 10.0)))
		 (set! score (- score 1)))))
	   enemy-position-list))))
