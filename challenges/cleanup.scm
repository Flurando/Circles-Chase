(define cleanup!
  (lambda ()
    (enemy-clean!)
    (set! player-health 100.0)
    (set! play-timer (make-agenda))))
