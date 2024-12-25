(define-module (circle-chase player)
  #:use-module (chickadee)
  #:use-module (chickadee math)
  #:use-module (chickadee math vector)
  #:use-module (chickadee graphics color)
  #:use-module (chickadee graphics text)
  #:use-module (chickadee scripting)
  #:use-module (ice-9 format)
  #:use-module (circle-chase utils)
  #:export (get-player-health
	    player-health-up!
	    player-health-down!
	    get-player-position
	    set-player-position!
	    set-player-position-x!
	    set-player-position-y!
	    get-player-agenda-time
	    player-agenda-update
	    player-agenda-schedule-at
	    player-agenda-schedule-after
	    player-agenda-schedule-every
	    player-agenda-at
	    player-agenda-after
	    player-agenda-every
	    player-agenda-call-when
	    player-draw
	    player-update))

(define player-health 100)
(define (get-player-health)
  "return the player-health variable as a string"
  (format #f "~d" player-health))
(define (make-player-health-changer operator)
  (lambda (x)
    (if (number? x)
	(clamp 0 100 (operator player-health x))
	(throw-error "[circle-chase::player::make-player-health-changer]expecting a number"))))
(define player-health-up!
  (make-player-health-changer +))
(define player-health-down!
  (make-player-health-changer -))

(define player-position (vec2 0.0 0.0))
(define player-velocity (vec2 0.0 0.0))
(define (get-player-position)
  (vec2-copy player-position))
(define (set-player-position! new-vec)
  (if (vec2? new-vec)
      (set! player-position new-vec)
      (throw-error "[circle-chase::player::set-player-position!]expecting a vec2 object")))
(define (set-player-position-x! x)
  (if (number? x)
      (set-vec2-x! player-position x)
      (throw-error "[circle-chase::player::set-player-position-x!]expecting a number")))
(define (set-player-position-y! y)
  (if (number? y)
      (set-vec2-y! player-position y)
      (throw-error "[circle-chase::player::set-player-position-y!]expecting a number")))
(define (get-player-velocity)
  (vec2* (vec2-normalize player-velocity) 60))
(define (reset-player-velocity!)
  (set-vec2! player-velocity 0.0 0.0))

(define player-agenda (make-agenda))
(define player-agenda-update
  (λ (dt)
    (with-agenda player-agenda
		 (update-agenda dt))))
(define get-player-agenda-time
  (λ ()
    (with-agenda player-agenda
		 agenda-time)))
(define player-agenda-schedule-at
  (λ (time thunk)
    (with-agenda player-agenda
		 (schedule-at time thunk))))
(define player-agenda-schedule-after
  (λ (delay thunk)
    (with-agenda player-agenda
		 (schedule-after time thunk))))
(define player-agenda-schedule-every
  (lambda args
    (with-agenda player-agenda
		 (apply schedule-every args))))
(define-syntax player-agenda-at
  (syntax-rules ()
    [(_ time body ...)
     (with-agenda player-agenda
		  (at time body ...))]))
(define-syntax player-agenda-after
  (syntax-rules ()
    [(_ delay body ...)
     (with-agenda player-agenda
		  (after delay body ...))]))
(define-syntax player-agenda-every
  (syntax-rules ()
    [(_ interval body ...)
     (with-agenda player-agenda
		  (every interval body ...))]
    [(_ (interval n) body ...)
     (with-agenda player-agenda
		  (every (interval n) body ...))]))
(define player-agenda-call-when
  (λ (pred thunk)
    (with-agenda player-agenda
		 (call-when pred thunk))))

(define player-draw
  (λ (alpha)
    (draw-text "player"
	       player-position
	       #:color white
	       #:scale (vec2 2 2))))

(define player-update-velocity!
  (λ ()
    (let ((state (list (key-pressed? 'up)
		       (key-pressed? 'down)
		       (key-pressed? 'left)
		       (key-pressed? 'right))))
      (if (list-ref state 0) 
	  (if (list-ref state 1)
	      *unspecified*
	      (set-vec2-y! player-velocity 1.0))
	  (if (list-ref state 1)
	      (set-vec2-y! player-velocity -1.0)
	      *unspecified*))
      (if (list-ref state 2) 
	  (if (list-ref state 3)
	      *unspecified*
	      (set-vec2-x! player-velocity -1.0))
	  (if (list-ref state 3)
	      (set-vec2-x! player-velocity 1.0)
	      *unspecified*)))))

(define (player-update-position! dt)
  (vec2-add! player-position (vec2* (get-player-velocity) dt)))

(define (player-update dt)
  (player-update-velocity!)
  (player-update-position! dt)
  (reset-player-velocity!))
