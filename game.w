define-module : game
  ;; repl server
  . #:use-module : system repl coop-server
  ;; chickadee
  . #:use-module : chickadee
  . #:use-module : chickadee scripting
  . #:use-module : chickadee graphics color
  ;; scene
  . #:use-module : (scene) #:select (load draw update) #:prefix scene-
  ;; healthar, might later moved to scene
  . #:use-module : (healthbar) #:prefix healthbar-
  
define repl : spawn-coop-repl-server

define *window* #f
define *window-keyboard-focused?* #f

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
  set! *random-state* : random-state-from-platform ; *random-state* is a global variable provided by guile, a seed for generating peseudo random sequence.
  set! *window* : current-window
  healthbar-load
  scene-load
  
;; DRAW
define : draw alpha
  scene-draw alpha

;; UPDATE
define : update delta
  update-agenda delta
  scene-update delta

run-game
    . #:window-title "Circle Chase"
    . #:window-width 640
    . #:window-height 480
    . #:window-fullscreen? #f
    . #:window-resizable? #f
    . #:window-keyboard-enter window-keyboard-enter
    . #:window-keyboard-leave window-keyboard-leave
    . #:update-hz 30
    . #:clear-color black
    . #:load load
    . #:update update-wrap
    . #:draw draw-wrap
