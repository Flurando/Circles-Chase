(define-module (circle-chase)
  #:use-module (chickadee)
  #:use-module (chickadee graphics color)
  #:use-module (circle-chase main)
  #:export (start))

(define start
  (λ ()
    (run-game
     #:window-title "Circle Chase"
     #:window-width 640
     #:window-height 480
     #:window-fullscreen? #f
     #:window-resizable? #f
     #:update-hz 30
     #:clear-color black
     #:load load
     #:update update
     #:draw draw)))
