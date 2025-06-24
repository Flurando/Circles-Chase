define-module : utils
  . #:use-module (chickadee)
  . #:export (key->1 void)

define : key->1 key
  if : key-pressed? key
    . 1
    . 0

define : void . args
  if #f #f
