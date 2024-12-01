(define enemy-position-list '())
(define enemy-speed-list '())

(define (enemy-spawn!)
  (set! enemy-position-list
	(cons (vec2 (random 640) (random 480)) enemy-position-list))
  (set! enemy-speed-list
	(cons (random:uniform) enemy-speed-list)))

(define (enemy-pop!)
  (unless (null? enemy-position-list)
    (set! enemy-position-list (cdr enemy-position-list))
    (set! enemy-speed-list (cdr enemy-speed-list))))

(define (enemy-clean!)
  (set! enemy-position-list '())
  (set! enemy-speed-list '()))

(define (enemy-auto-move)
  (unless (null? enemy-position-list)
    (for-each
     (lambda (position2 speed2)
       (let ((nvec (vec2-normalize (vec2- position position2))))
         (vec2-add! position2 (vec2* nvec speed2))))
     enemy-position-list
     enemy-speed-list)))

(define (enemy-auto-draw)
  (unless (null? enemy-position-list)
    (for-each
     (lambda (position)
       (let* ([painter (with-style ([fill-color yellow])
				   (fill (circle position 10)))]
	      [canvas (make-canvas painter)])
	 (draw-canvas canvas)))
     enemy-position-list)))
