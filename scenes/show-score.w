define-module : scenes show-score
  . #:use-module : ice-9 format
  . #:use-module : chickadee
  . #:use-module : utils graphics
  . #:use-module : scenes score-and-time
  . #:use-module : scenes win-or-lose
  . #:export : draw update

define : draw alpha
  let : : msg : format #f "score ~d" (score-to-show)
    print-text msg 200.0 200.0 3.0 3.0

define update
    lambda : dt
      if : or (key-pressed? 'space) (key-pressed? 'return) ; make sure to type key representation correct, if you mistype 'return as 'enter, guile would only complain about expecting exact integar but get #f in unknown file!
        begin : cleanup!
          . #t
        . #f
      
