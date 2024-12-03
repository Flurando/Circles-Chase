(define scene-pool '())

(define (scene-register! scene)
  ;;I refer to scenes as the checks and the drawings, the variables in memory to me now is not that important.
  ;;Thus, I would assume a scene as a pair whose car is the alist key and cdr is another pair, whose car is a procedure which would call all the drawing procedures and the cdr is another procedure calling all the checking procedures.
  (set! scene-pool (cons scene scene-pool)))

(define (scene-draw!)
  (for-each (lambda (x) (apply x '()))
	    (map (lambda (p)
		   (cadr p))
		 scene-pool)))

(define (scene-update!);;not naming it ...-check! just to be the same of the main game loop naming conventions
  (for-each (lambda (x) (apply x '()))
	    (map (lambda (p)
		   (cddr p))
		 scene-pool)))