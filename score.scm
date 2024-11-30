(define score 0)
(define score-timer (make-agenda))

(every 1
       (with-agenda score-timer
		    (update-agenda 1)))

(with-agenda score-timer
	     (schedule-every
	      5
	      (lambda () 
		(set! score (+ score 1)))))

