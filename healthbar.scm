(define healthbar-background-canvas
  (make-canvas
   (with-style ([fill-color black])
	       (fill (rounded-rectangle (vec2 10.0 450.0) 110.0 25.0)))))

(define healthbar-foreground-canvas
  (make-empty-canvas))

(define healthbar-draw #f)
(let ((history-health -1.0))
  (set! healthbar-draw
	(lambda (health)
	  (draw-canvas healthbar-background-canvas)
	  (unless (= health history-health)
	    (set-canvas-painter! healthbar-foreground-canvas
				 (with-style ([fill-color red])
					     (fill (rounded-rectangle (vec2 15.0 455.0) health 15.0))))
	    (set! history-health health))
	  (draw-canvas healthbar-foreground-canvas))))
