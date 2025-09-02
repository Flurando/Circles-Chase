define-module : scenes startup
  . #:use-module : (chickadee) #:select : mouse-button-pressed? mouse-x mouse-y
  . #:use-module : (chickadee math rect) #:select : rect rect-contains?
  . #:use-module : (chickadee math vector) #:select : vec2
  . #:use-module : (chickadee graphics color) #:select : white black
  . #:use-module : (chickadee graphics path) #:select : rectangle fill with-style make-canvas draw-canvas
  . #:use-module : (chickadee graphics text) #:select : draw-text
  . #:export : draw update
  
define : draw-start-button
  draw-canvas
    make-canvas
      with-style : : fill-color white
        fill : rectangle (vec2 260.0 200.0) 120.0 80.0
  draw-text "start"
    vec2 260.0 210.0
    . #:color black
    . #:scale : vec2 3.0 3.0
  
define draw
      lambda : alpha
        draw-canvas
          make-canvas
            with-style : : fill-color black
              fill : rectangle (vec2 20.0 10.0) 600.0 460.0
        draw-canvas
          make-canvas
            with-style : : fill-color white
              fill : rectangle (vec2 260.0 200.0) 120.0 80.0
        draw-text "Circle Chase"
          vec2 100.0 380.0
          . #:color white
          . #:scale : vec2 5.0 5.0
        draw-text "start"
          vec2 260.0 210.0
          . #:color black
          . #:scale : vec2 3.0 3.0
          
define update
        lambda : dt
            and
              mouse-button-pressed? 'left
              rect-contains? : rect 260.0 200.0 120.0 80.0
                mouse-x
                mouse-y ; yes, these two are procedures, not variables

