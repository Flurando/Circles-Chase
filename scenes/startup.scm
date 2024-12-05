(define startup-scene
  (cons
    'startup-scene
    (cons
      (lambda ()
        (draw-canvas
          (make-canvas
            (with-style ((fill-color black))
              (fill (rectangle (vec2 20.0 10.0) 600.0 460.0)))))
        (draw-text "Circle Chase"
          (vec2 250.0 380.0)
          #:color white
          #:scale (vec2 5.0 5.0))
        (draw-text "start"
          (vec2 260.0 200.0)
          #:color white
          #:scale (vec2 3.0 3.0)))
     (let ((flag #t) (start-button-rect (rect 260.0 200.0 60.0 30.0)))
       (lambda ()
         (when
           (and
             flag
             (mouse-button-pressed? 'left)
             (rect-contains? start-button-rect
               (mouse-x)
               (mouse-y)))
           (set! flag #f)
           (call-when
             (and
               (mouse-button-released? 'left)
               (rect-contains? start-button-rect
                 (mouse-x)
                 (mouse-y)))
             (lambda ()
               (scene-delete! 'startup-scene)
               (scene-register! sample-scene)
               (scene-register! score-and-time-scene)))))))))

(scene-register! startup-scene)



