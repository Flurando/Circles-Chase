define-module : scene
  . #:use-module : srfi srfi-9
  . #:export : load draw update make-scene combine-scene set-current-scene! set-next! set-state! get-draw get-update

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

define : set-current-scene! new-scene ; dangerous procedure, only intended to be use by specified (now, scenes.w) module to set the first scene to display
    set! current-scene new-scene
  
define : combine-scene scene-list
  let ((draws (map-in-order get-draw scene-list)) (updates (map-in-order get-update scene-list)))
    if : null? scene-list
      make-empty-scene
      make-scene (lambda (alpha) (map-in-order (lambda (x) (x alpha)) draws)) (lambda (dt) (let ((result ((car updates) dt))) (map-in-order (lambda (x) (x dt)) (cdr updates)) result))
      
define : draw alpha
  (get-draw current-scene) alpha

define : update dt
  set-state! current-scene : (get-update current-scene) dt ; play-scene can't pass this line
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

define-syntax gen-scene
  syntax-rules () : (_ name) (make-scene (@ (scenes name) draw) (@ (scenes name) update))
  
;;; below are stuff about the scenes/ folder, you shall register new ones here if you want to add new scene in that folder
;; the first scene to show when the game is started
define startup-scene : gen-scene startup ; main scene

;; main game play components
define chase-scene : gen-scene chase ; mechanics of the game
define healthbar-scene : gen-scene healthbar ; draw healthbar
define score-and-time-scene : gen-scene score-and-time ; type score and time passed
define player-scene : gen-scene player ; draw player
define enemy-scene : gen-scene enemy ; draw enemy

define play-scene : combine-scene : list chase-scene score-and-time-scene healthbar-scene player-scene enemy-scene ; combined together as the main game scene

;; special scene
define win-scene : gen-scene win
define lose-scene : gen-scene lose

define : load  
  set-next! startup-scene play-scene
  set-next! play-scene : list win-scene lose-scene
  set-next! win-scene startup-scene
  set-next! lose-scene startup-scene

  set-current-scene! startup-scene
