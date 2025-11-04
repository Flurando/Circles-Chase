define-module : scene
  . #:use-module : srfi srfi-9
  . #:export : load draw update make-scene combine-scene set-current-scene! set-next! set-state! get-draw get-update register-scene

define-record-type <scene>
  %make-scene state draw update next
  . scene?
  state get-state set-state!
  draw get-draw
  update get-update
  next get-next set-next! ; this should not be handled by scenes folder stuff, instead we handle this here, about how to connect scenes

define : make-scene draw update
  %make-scene #f draw update #f

define : make-empty-scene
  make-scene (lambda (x) (if #f #f)) (lambda (x) #f)

define current-scene : make-empty-scene

define : set-current-scene! new-scene ; dangerous procedure, only intended to be use by specified module to set the first scene to display
    set! current-scene new-scene
  
define : combine-scene scene-list
  let ((draws (map-in-order get-draw scene-list)) (updates (map-in-order get-update scene-list)))
    if : null? scene-list
      make-empty-scene
      make-scene (lambda (alpha) (map-in-order (lambda (x) (x alpha)) draws)) (lambda (dt) (let ((result ((car updates) dt))) (map-in-order (lambda (x) (x dt)) (cdr updates)) result)) ; see the "(result ((car updates) dt))"? Yes, In combined-scene, the first scene's update procedure return value decides the combined scene's update return value, further deciding whether or not or even which next scene to switch, thus the main child scene.
      
define : draw alpha
  (get-draw current-scene) alpha

define : update dt
  set-state! current-scene : (get-update current-scene) dt
  ;; when current scene is over
  ;; state: #f means can't switch
  ;; since #t can be other stuff, it would be easier to have multiple next
  ;; we check whether it has a next scene
  ;; if it does, we switch to it
  ;; if it doesn't, we stay on it
  when : get-state current-scene
    let : : next-scene : get-next current-scene
      when next-scene
        if : list? next-scene
          set-current-scene! : list-ref next-scene : get-state current-scene
          set-current-scene! next-scene

;; helper to "register" scene from the scenes/ folder
define-syntax gen-scene
  syntax-rules ()
    (_ parent-name child-name ...) (make-scene (@ (scenes parent-name child-name ...) draw) (@ (scenes parent-name child-name ...) update))
  
define-syntax register-scene
  lambda : x
    define : name-the-scene lst
      if : null? lst
        . 'null-scene
        symbol-append
          car lst
          let loop : : lst : cdr lst
            if : null? lst
              . '-
              symbol-append '- : car lst
                loop : cdr lst
          . 'scene
    syntax-case x ()
      (_ parent-name child-name ...)
        with-syntax : : scene-name : datum->syntax #'parent-name (name-the-scene (cons (syntax->datum #'parent-name) (map-in-order syntax->datum #'(child-name ...))))
          . #`(define scene-name (gen-scene parent-name child-name ...))
  
;;; below are stuff about the scenes/ folder, you shall register new ones here if you want to add new scene in that folder

;; the first scene to show when the game is started
;;define startup-scene : gen-scene startup ; main scene
register-scene startup

;; main game play components
register-scene main
register-scene healthbar
register-scene score-and-time
register-scene sea tentacle

define play-scene : combine-scene : list main-scene sea-tentacle-scene score-and-time-scene healthbar-scene ; combined together as the main game scene

define : load  
  set-next! startup-scene play-scene
  set-next! play-scene : list startup-scene startup-scene

  set-current-scene! startup-scene
