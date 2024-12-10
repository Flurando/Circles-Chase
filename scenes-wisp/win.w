define win-scene
  cons
    . 'win-scene
    cons
      lambda : 
        draw-text "You WIN"
          vec2 210 220
          . #:color black
          . #:scale : vec2 5.0 5.0
      let : (flag #t)
       lambda : dt 
         when
           and
             . flag
             mouse-button-pressed? 'left
           set! flag #f
           after 10 : set! flag #t
           set! play-timer : make-agenda
           enemy-clean!
           scene-switch!
             list 'win-scene
             list startup-scene
          
