(define score 0)
(define score-timer (make-agenda))

(define (score-to-show)
  (if (> score 0)
      score
      0))

(define (score-lose! num)
  (set! score (- score num)))

(define (score-gain! num)
  (set! score (+ score num)))

(every 1
       (with-agenda score-timer
		    (update-agenda 1)))

(with-agenda score-timer
	     (schedule-every
	      5
	      (lambda ()
		(score-gain! 1))))

