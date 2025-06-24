#!/bin/sh
exec guile -L ./ -x .w --language=wisp --no-auto-compile -s $0
!#

use-modules
  ;; repl server
  system repl coop-server
  ;; chickadee
  chickadee
  chickadee audio
  chickadee graphics path
  chickadee graphics engine
  chickadee graphics text
  chickadee graphics color
  chickadee graphics texture
  chickadee graphics sprite
  chickadee math
  chickadee math matrix
  chickadee math rect
  chickadee math vector
  chickadee scripting

define repl : spawn-coop-repl-server

define *window* #f
define *window-keyboard-focused?* #f

include "setup.scm"
include "utils.scm"
include "agendas.scm"
include "player.scm"
include "enemy.scm"
include "score.scm"
include "healthbar.scm"
include "sceneswitcher.scm"
include "loader.scm"

;; some wrapper as walkarounds for run-game nasty behaviour
define : draw-wrap alpha
  when *window-keyboard-focused?*
    draw alpha
define : update-wrap dt
  ;; repl server
  poll-coop-repl-server repl
  ;; stop updating when idle
  when *window-keyboard-focused?*
    update dt

define : window-keyboard-enter
  unless *window-keyboard-focused?*
    set! *window-keyboard-focused?* #t

define : window-keyboard-leave
  when *window-keyboard-focused?*
    set! *window-keyboard-focused?* #f


;;; real main procedures
;; LOAD
define : load
  set! *window* : current-window
  
;; DRAW
define : draw alpha
  scene-draw!

;; UPDATE
define : update delta
  update-agenda delta
  scene-update! delta

run-game #:window-title "Circle Chase"
	 #:window-width 640
	 #:window-height 480
	 #:window-fullscreen? #f
	 #:window-resizable? #f
	 #:window-keyboard-enter window-keyboard-enter
	 #:window-keyboard-leave window-keyboard-leave
	 #:update-hz 30
	 #:clear-color black
	 #:load load
	 #:update update-wrap
	 #:draw draw-wrap

;; Local Variables:
;; mode: Fundamental
;; End: