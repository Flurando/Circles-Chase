define sample-scene
  cons
    . 'sample-scene
    cons
      lambda : ;;this is where all drawing calls go
        healthbar-draw player-health
        
        player-draw
        enemy-auto-draw

      lambda : ;;this is wehre all updating calls go
        player-move!
        enemy-auto-move
        
        ;;ADDITIONAL CHECKS FROM CHALLENGES DIRECTORY
        lose-score-when-touched! ;;this not only decreases score actually, but also substracts 10 from player-health which is added later then it is named like so. Maybe I should rename it, if more actions are taken in the body of the collision checks.
