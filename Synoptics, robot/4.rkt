#lang racket

(require "AsipMain.rkt")

(define ptime (current-inexact-milliseconds))
(define ctime 0)
(define interval 3000)
(define irsensors (list 0 1 2))

(define (irLoop)
  (set! ctime (current-inexact-milliseconds))
  (cond
    ((> (- ctime ptime) interval)
     (map (λ (i) (printf "IR sensor ~a -> ~a; " i (getIR i))) irsensors)
     (printf "\n")
     (set! ptime (current-inexact-milliseconds))
     )
    )
  (sleep 0.02)
  
  (cond ((not (and (leftBump?) (rightBump?)))
         (irLoop))))

(define (minimalLoop)
  (open-asip)
  (sleep 0.2)
  (enableIR 100)
  (sleep 0.2)
  (enableBumpers 100)
  (sleep 0.5)
  (irLoop)
  (close-asip)
  )