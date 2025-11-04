define-module : scenes race lane
  . #:use-module : (chickadee) #:select : key-pressed?
  . #:use-module : (chickadee math) #:select : clamp
  . #:use-module : (chickadee math vector) #:select : vec2
  . #:use-module : (chickadee math bezier) #:select : make-bezier-curve bezier-curve-point-at
  . #:use-module : (chickadee math easing) #:select : smoothstep
  . #:use-module : utils graphics
  . #:use-module : srfi srfi-9
  . #:export : draw update

;; suppose the default lane is represented by quadratic bezier curve
;; we emulate this using chickadee's cubic version with two same start point
define : make-quadratic-bezier-curve p0 p1 p2
  make-bezier-curve p0 p0 p1 p2
define : get-lane offset
  make-quadratic-bezier-curve
    get-start offset
    get-control offset
    get-end offset

define-syntax draw-point
  lambda : x
    syntax-case x ()
      (_ color point width height) ; here point is the center of the rectangle
        with-syntax
          : point-x #'(- ((@ (chickadee math vector) vec2-x) point) (/ width 2))
            point-y #'(- ((@ (chickadee math vector) vec2-y) point) (/ height 2))
          . #'(fill-rounded-rectangle color point-x point-y width height)
define-syntax draw-point-with-random-color
  lambda : x
    syntax-case x ()
      (_ point width height)
        with-syntax
          : color #`((@ (chickadee graphics color) make-color) #,(random 1.0) #,(random 1.0) #,(random 1.0) 1.0)
          . #'(draw-point color point width height)
define-syntax draw-point-with-random-color-by-point-y
  lambda : x
    syntax-case x ()
      (_ point)
        with-syntax
          : point-y #'((@ (chickadee math vector) vec2-y) point)
          with-syntax ; here we suppose nearest is 200 wide, the farest is 20 wide, with height always 5
            : height #'5
              width #'{{-1/2 * point-y} + 200}
            . #'(draw-point-with-random-color point width height)
define-syntax draw-lane-with-offset
  lambda : x
    syntax-case x ()
      (_ offset)
        with-syntax
          : lane #'(get-lane offset)
          syntax
            ;; we need a bunch of t between 0 and 1 to be feed to bezier-curve-point-at
            ;; (bezier-curve-point-at lane t)
            ;; for each t, it returns a vec2 to be feed to draw-point-with-random-color-by-point-y
            let : : step 1/10 ; use 1/n if we want to draw (n+1) points
              let loop : : t 0
                if {t > 1}
                  . *unspecified*
                  begin
                    draw-point-with-random-color-by-point-y : bezier-curve-point-at lane t
                    loop {t + step}
                
  
;; a single line, when drawing initial lane, make the width in line function like w=ky+b
;; y=0, w=200; y=360, w=20
;; so k=-1/2, b=200
;; start(double!) would always be (320, 0) and end would initally be at (320, 360) for easiness, while that above y=360 would be sky or anything else
define *initial-x-for-start-point* 320.0
define *initial-y-for-start-point* 0.0
define : get-start offset
  vec2 *initial-x-for-start-point* *initial-y-for-start-point*
  
define *initial-x-for-control-point* *initial-x-for-start-point*
define *initial-y-for-control-point* *initial-y-for-end-point*
define *b-for-control-point-ecllipse* : abs {{*initial-y-for-end-point* - *initial-y-for-start-point*} / 2}
define *a-for-control-point-ecllipse* : abs {*b-for-control-point-ecllipse* / 2}
define *last-control-drew-is-on-top* #f ; start with #f because initially there is no last drew, and we do start on top for the first draw
define : get-control offset
  define abs-offset : abs offset
  define sym-offset : if (zero? offset) 0 : if (positive? offset) 1 -1
  define y
    if *last-control-drew-is-on-top* ; this flag is ought to be managed by other procedure, we just use it here
      . {{*initial-y-for-control-point* - *b-for-control-point-ecllipse*} - {(smoothstep {1 - abs-offset}) * *b-for-control-point-ecllipse*}}
      . {{*initial-y-for-control-point* - *b-for-control-point-ecllipse*} + {(smoothstep {1 - abs-offset}) * *b-for-control-point-ecllipse*}}
  define : square x
    . {x * x}
  define x {*initial-x-for-control-point* + {sym-offset * (sqrt {1 - (square {{y - {*initial-y-for-control-point* - *b-for-control-point-ecllipse*}} / {*initial-y-for-control-point* - *b-for-control-point-ecllipse*}})})}}
  vec2 x y
  
define *initial-x-for-end-point* *initial-x-for-start-point*
define *initial-y-for-end-point* 360.0
define *largest-offset-for-end-point* : abs {*a-for-control-point-ecllipse* + {{*b-for-control-point-ecllipse* - *a-for-control-point-ecllipse*} / 3}}
define : get-end offset
  if : zero? offset
    vec2 *initial-x-for-end-point* *initial-y-for-end-point*
    if : positive? offset
      vec2 : - *initial-x-for-end-point* : * *largest-offset-for-end-point* : smoothstep offset
        . *initial-y-for-end-point*
      vec2 : + *initial-x-for-end-point* : * *largest-offset-for-end-point* : smoothstep : - offset
        . *initial-y-for-end-point*
        
;; at any offset, the end point goes left/right, the control point goes on an ecclipse curve
;; (x-320)^2/90^2 + (y-180)^2/180^2 = 1
;; suppose rightward as positive direction
;; offset is a number between -1 and +1
;; so a random one could be made with (- (* (random) 2) 1)
;; when offset is positive, the controller is leftsided and the end point is rightsided, negative the opposite
;; you can image the controller goes in clockwise from (320.0, 360.0), and the end point start leftwards
;; when offset is small, controller should be near middle line
;; when offset abs is large, the controller should be near the furthermost points
;; we can distinguish left and right with the symbol of offset
;; but how could me distinguish up and down?
;; it is true that just given an offset
;; we have no way to say whether the turn should be near bottom or near top
;; however we can just make a local memory, so if the last offset abs 0->1 is drawn on top, now we draw it on bottom
;; in this way we can make sure they take turns
;; the problem becomes how to make a procedure to manage the local memory about last drawn stuff

define *offset* 0

define : draw alpha
  draw-lane-with-offset *offset*
define update
    lambda : dt
      let
        : a-pressed : key-pressed? 'a
          d-pressed : key-pressed? 'd
        when a-pressed
          set! *offset* : clamp -1 1 {*offset* - dt}
        when d-pressed
          set! *offset* : clamp -1 1 {*offset* + dt}
        unless : or a-pressed d-pressed
          set! *offset*
            if : zero? *offset*
              . *unspecified*
              if : positive? *offset*
                set! *offset* : clamp 0 *offset* : - *offset* dt
                set! *offset* : clamp *offset* 0 : + *offset* dt
