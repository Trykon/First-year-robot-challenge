#lang racket

(require "AsipMain.rkt")

(define previousLeft #f)
(define previousRight #f)

(define (sensorsLoop)
  (cond
    ((not (equal? (leftBump?) previousLeft))
     (cond ((leftBump?) (printf "Left bump pressed\n"))
           (else (printf "Left bump released\n"))
           )
     )
    )
  (cond
    ((not (equal? (rightBump?) previousRight))
     (cond ((rightBump?) (printf "Right bump pressed\n"))
           (else (printf "Right bump released\n"))
           )
     )
    )
  (set! previousLeft (leftBump?))
  (set! previousRight (rightBump?))
  
  (sleep 0.02)
  (cond ((not (and (leftBump?) (rightBump?)))
         (sensorsLoop)
         )
        )
  )

(define (minimalLoop)
  (open-asip)
  (enableBumpers 100)
  (sleep 0.5)
  (sensorsLoop)
  (close-asip)
  )