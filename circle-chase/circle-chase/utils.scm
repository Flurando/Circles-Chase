(define-module (circle-chase utils)
  #:use-module (ice-9 format)
  #:use-module (ice-9 exceptions)
  #:export (throw-error))

(define (throw-error msg)
  (let ([msg (if (string? msg)
		 msg
		 (format #f "~a" msg))])
    (raise-exception (make-exception-with-message msg))))
