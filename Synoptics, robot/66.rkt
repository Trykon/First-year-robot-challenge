#lang racket

(require "AsipMain.rkt")

(define nrot 2)

(define leftCount 0)
(define rightCount 0)
(define rf 0)
(define lf 0)
(define (forwardLoop nrotations)
  (define curleftcount (* -1 (getCount 0)))
  (define currightcount (* -1 (getCount 1)))
  (sleep 0.02)
  
  (cond ((and (> curleftcount (+ leftCount (* nrotations 64))) (equal? lf 0))
         (w1-stopMotor) (set! lf 1)
         )
        ((and (> currightcount (+ rightCount (* nrotations 64))) (equal? rf 0))
         (w2-stopMotor) (set! rf 1)
         )
        )
  
  (sleep 0.02)
  
  (cond ((or(< curleftcount (+ leftCount (* nrot 64)))
            (< currightcount (+ rightCount (* nrot 64)))
            )
         (cond
           ((not (or (rightBump?) (leftBump?)))
            (forwardLoop nrotations))
           (else (stopMotors))
           )
         )
        )
  )

(define (startWheels)
  (open-asip)
  (set! lf 0)
  (set! rf 0)
  (enableCounters 50)
  (sleep 0.5)
  
  (enableBumpers 50)
  (sleep 0.5)
  (set! leftCount (getCount 0))
  (set! rightCount (getCount 1))
  (setMotors -150 150)
  (forwardLoop nrot)
  (stopMotors)
  (close-asip)
  )
