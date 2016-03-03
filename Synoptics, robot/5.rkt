#lang racket

(require "AsipMain.rkt")

(define nrot 2)

(define leftCount 0)
(define rightCount 0)

(define (forwardLoop nrotarions)
  (define curleftcount (getCount 0))
  (define currightcount (getCount 1))
  
  (sleep 0.02)
  
  (cond ((> curleftcount (+ leftCount (* nrotations 64)))
         
         (w1-stopMotor)
         )
        ((> currightcount (+ rightCount (* nrotations 64)))
         
         (w2-stopMotor)
         )
        )
  (sleep 0.02)
  
  (cond ((or(< curleftcount (+ leftCount (* nrot 64)))
            (< curright (+ rightCount (* nrot 64)))
            )
         (forwardLoop nrotations)
         )
        )
  )

(define (startWheels)
  (open-asip)
  (enableCounters 50)
  (sleep 0.5)
  (set! leftCount (getCount 0))
  (set! rightCount (getCount 1))
  (setMotors 150 -150)
  (forwardLoop Nrot)
  (close-asip)
  )
