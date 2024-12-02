(define position (vec2 240.0 80.0))
(define player-health 100.0)
(define player-canvas
  (make-empty-canvas #:matrix
		     (make-matrix3 1 0 0
				   0 1 0
				   0 0 1)))

(define (player-move!)
  (let ((nvec (vec2-normalize (vec2 (- (key->1 'd) (key->1 'a)) (- (key->1 'w) (key->1 's))))))
    (vec2-add! position  nvec))
  (set-vec2-x! position (clamp 0.0 640.0 (vec2-x position)))
  (set-vec2-y! position (clamp 0.0 480.0 (vec2-y position))))

(define (player-draw)
  (let ((painter (with-style ([fill-color green]) (fill (circle position 10.0)))))
    (set-canvas-painter! player-canvas painter)
    (draw-canvas player-canvas)))
