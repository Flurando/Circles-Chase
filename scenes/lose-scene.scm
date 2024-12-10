(define lose-scene
  (cons
    'lose-scene
    (cons
      (lambda ()
        (draw-text "You LOSE"
          (vec2 210 220)
          #:color black
          #:scale (vec2 5.0 5.0)))
      (let ((flag #t))
       (lambda (dt )
         (when
           (and
             flag
             (mouse-button-pressed? 'left))
           (set! flag #f)
	   (after 10 (set! flag #t))
           (scene-switch!
             (list 'lose-scene)
             (list startup-scene))))))))
        


