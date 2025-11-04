define-module : scenes player
  . #:use-module : chickadee
  . #:use-module : chickadee scripting
  . #:use-module : chickadee math
  . #:use-module : chickadee math vector
  . #:use-module : chickadee math matrix
  . #:use-module : chickadee graphics color
  . #:use-module : chickadee graphics path
  . #:use-module : srfi srfi-9
  . #:export : get-health set-health! recover-health! lose-health!

define health 100
define : get-health
  . health
define : recover-health! amount
  set! health : clamp 0 100 : + health amount
define : lose-health! amount
  set! health : clamp 0 100 : - health amount
define : set-health! int
  set! health int
