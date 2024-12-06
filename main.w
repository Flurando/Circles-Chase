include "setup.scm"
include "utils.scm"
include "agendas.scm"
include "player.scm"
include "enemy.scm"
include "score.scm"
include "healthbar.scm"
include "sceneswitcher.scm"
include "loader.scm"

;;DRAW
define : draw alpha
  scene-draw!

;;UPDATE
define : update delta
  update-agenda delta
  scene-update! delta

;;TEMPERARY SNIPPETS IN WISP GOES BELOW
;;of course, one can always write a .w file and translate that into .scm file using wisp2lisp
