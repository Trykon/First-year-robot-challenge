#lang racket
(define-syntax-rule (with-raw body ...)
  (let ([saved #f])
    (define (stty x) (system (~a "stty " x)) (void))
    (dynamic-wind (λ() (set! saved (with-output-to-string (λ() (stty "-g"))))
                       (stty "raw -echo opost"))
                  (λ() body ...)
                  (λ() (stty saved)))))

(define (loop)
  (with-raw
   (if (char-ready?)
       (cond ((equal? "k" (read-char)) null)
             (#t (printf "~a\n" (read-char))
                 (loop)))
       (loop)))
  )

(loop)