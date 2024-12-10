define startup-scene
  cons
    . 'startup-scene
    cons
      lambda : 
        draw-canvas
          make-canvas
            with-style : (fill-color black)
              fill : rectangle (vec2 20.0 10.0) 600.0 460.0
        draw-canvas
          make-canvas
            with-style : (fill-color white)
              fill : rectangle (vec2 260.0 200.0) 120.0 80.0
        draw-text "Circle Chase"
          vec2 100.0 380.0
          . #:color white
          . #:scale : vec2 5.0 5.0
        draw-text "start"
          vec2 260.0 210.0
          . #:color black
          . #:scale : vec2 3.0 3.0
     let : (flag #t) (start-button-rect (rect 260.0 200.0 120.0 80.0))
       lambda : dt 
         when
           and
             . flag
             mouse-button-pressed? 'left
             rect-contains? start-button-rect
               mouse-x
               mouse-y
           set! flag #f
           after 10 : set! flag #t
           scene-switch!
             list 'startup-scene
             list sample-scene score-and-time-scene
           new-enemy-every-5s

scene-register! startup-scene

