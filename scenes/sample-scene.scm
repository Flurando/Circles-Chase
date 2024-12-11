(define sample-scene
  (cons
    'sample-scene
    (cons
      (lambda ();;this is where all drawing calls go
        (healthbar-draw player-health)
        
        (player-draw)
        (enemy-auto-draw))

      (lambda (dt );;this is wehre all updating calls go
        (with-agenda play-timer
          (update-agenda dt))
        (player-move!)
        (enemy-auto-move)
        
        ;;ADDITIONAL CHECKS FROM CHALLENGES DIRECTORY
        (lose-score-when-touched! );;this not only decreases score actually, but also substracts 10 from player-health which is added later then it is named like so. Maybe I should rename it, if more actions are taken in the body of the collision checks.
        (define cleanup!
	  (lambda ()
	    (enemy-clean!)
	    (set! player-health 100.0)
	    (set! play-timer (make-agenda))))
	
        (with-agenda play-timer
		     (when {(agenda-time) > 61}
		       (scene-switch!
			(list 'sample-scene 'score-and-time-scene)
			(list win-scene))
		       (clean-up!)))
        
        (when (zero? player-health)
          (scene-switch!
           (list 'sample-scene 'score-and-time-scene)
           (list lose-scene))
	  (clean-up!))))))
