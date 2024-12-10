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
         (set! play-timer (make-agenda))
         (enemy-clean!)
         (set! player-health 100.0)
         (when
           (and
             flag
             (mouse-button-pressed? 'left))
           (set! flag #f)
           (after 1 (set! flag #t))
           (scene-switch!
             (list 'lose-scene)
             (list startup-scene))))))))
        


