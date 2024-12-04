(define sample-scene
  (cons
    'sample-scene
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
          #:scale (vec2 2.0 2.0))
          
        (healthbar-draw player-health)
        
        (player-draw)
        (enemy-auto-draw))

      (lambda ();;this is wehre all updating calls go
        (player-move!)
        (enemy-auto-move)
        
        ;;ADDITIONAL CHECKS FROM CHALLENGES DIRECTORY
        (lose-score-when-touched! )))));;this not only decreases score actually, but also substracts 10 from player-health which is added later then it is named like so. Maybe I should rename it, if more actions are taken in the body of the collision checks.

(scene-register! sample-scene)


