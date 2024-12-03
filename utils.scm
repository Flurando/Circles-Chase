(define (key->1 key)
  (if (key-pressed? key)
      1
      0))

(define (void)
  (if #f #f))
