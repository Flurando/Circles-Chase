(define-module (circle-chase enemy)
  #:use-module (chickadee math)
  #:use-module (chickadee math vector)
  #:use-module (srfi srfi-9)
  #:export (enemy-spawn!
	    enemy-clear!))

(define-record-type enemy
  (make-enemy position)
  enemy?
  (position enemy-position set-enemy-position!))

(define enemy-list '())

(define (enemy-spawn!)
  (set! enemy-list
	(cons
	 (make-enemy (vec2 (random 640.0)
			   (random 480.0)))
	 enemy-list)))

(define (enemy-clear!)
  (set! enemy-list '()))
