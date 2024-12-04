(define score-and-time-scene
  (cons
    'score-and-time-scene
    (cons
      (lambda ();;this is where all drawing calls go
        (draw-text
          (format #f "Score: ~d" (score-to-show))
          (vec2 240.0 460.0)
          #:scale (vec2 2.0 2.0))
        (draw-text
          (format #f "Time: ~d seconds"
            (inexact->exact (truncate-quotient (agenda-time) 1)))
          (vec2 220.0 420.0)
          #:color red
          #:scale (vec2 2.0 2.0)))

      void)))

(scene-register! score-and-time-scene)


