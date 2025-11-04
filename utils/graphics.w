;;; Some macros or procedures to make drawing easier
define-module : utils graphics
  . #:export : fill-rounded-rectangle print-text
  
define-syntax fill-rounded-rectangle
  lambda : x
    syntax-case x ()
      (_ filled-color left-bottom-x left-bottom-y width height)
        with-syntax
          : draw-canvas #'(@ (chickadee graphics path) draw-canvas)
            make-canvas #'(@ (chickadee graphics path) make-canvas)
            with-style #'(@ (chickadee graphics path) with-style)
            color
              if : symbol? : syntax->datum #'filled-color
                . #'(@ (chickadee graphics color) filled-color)
                . #'filled-color
            fill #'(@ (chickadee graphics path) fill)
            rounded-rectangle #'(@ (chickadee graphics path) rounded-rectangle)
            vec2 #'(@ (chickadee math vector) vec2)
          syntax
            draw-canvas
              make-canvas
                with-style : : fill-color color
                  fill
                    rounded-rectangle
                      vec2 left-bottom-x left-bottom-y
                      . width height

define-syntax print-text
  lambda : x
    syntax-case x ()
      (_ message left-bottom-x left-bottom-y scaler-width scaler-height)
        with-syntax
          : draw-text #'(@ (chickadee graphics text) draw-text)
            vec2 #'(@ (chickadee math vector) vec2)
          syntax
            draw-text
              . message
              vec2 left-bottom-x left-bottom-y
              . #:scale : vec2 scaler-width scaler-height
