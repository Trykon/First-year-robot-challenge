#lang racket

(require "AsipMain.rkt")

;; ---------------------------------------------------------
;; A simple control loop to print the value of IR sensors
;; every 2 seconds (interval can be modified
;; ---------------------------------------------------------

(define (sStart) (setMotors -170 170))
(define (tLeft) (setMotors -150 170))
(define (tRight) (setMotors -170 150))
(define (rLeft)
  (setMotors -150 50)
  )
(define (rRight) 
  (setMotors -50 150)
  )

(define previousTime (current-inexact-milliseconds))

(define currentTime 0)

(define oldleftsensor 0)
(define oldrightsensor 0)

;; How often should we print?
(define interval 10)

;; The list of IR sensors (used in map below)
(define irSensors (list 0 1 2))

(define (irLoop)
  (set! currentTime (current-inexact-milliseconds))
  
  (cond 
    ((> (- currentTime previousTime) interval)
     ;; We use a map function to print the value
     (map (lambda (i) (printf "IR sensor ~a -> ~a; " i (getIR i))) irSensors)
     (printf "\n")
     (set! previousTime (current-inexact-milliseconds))
     (cond
       ((or (>= (getIR 2) 200) (>= (getIR 0) 200))
        (set! oldleftsensor (getIR 2))
        (set! oldrightsensor (getIR 0))
        
        (printf "\nLeft ~a " oldleftsensor)
        (printf "Right ~a\n" oldrightsensor)
        )
       (#t))
     )
    )
  
  
  
  ;; Required in Win
  (sleep 0.02)
  
  ;;A loop to keep calling itself. 
  (cond
    ;If the middel sensor is reading higher than 200 it will continue straight
    ((>= (getIR 1) 200)
     (sStart)
     (irLoop)
     )
    
    (#t (cond
          ;If the sensor for the right side is high it turns right
          ((>= (getIR 0) 200) 
           (tLeft)
           (sleep 0.1)
           (sStart)
           (irLoop)
           )
          ;If the sensor for the left side is high it turns left
          ((>= (getIR 2) 200) 
           (tRight)
           (sleep 0.1)
           (sStart)
           (irLoop)
           )
          (#t 
           (cond
             ((> oldleftsensor oldrightsensor) 
              (printf "\nLeft ~a " oldleftsensor)
              (printf "Right ~a\n" oldrightsensor)
              (rLeft)
              (irLoop)
              )
             ((> oldrightsensor oldleftsensor)
              (printf "\nLeft ~a " oldleftsensor)
              (printf "Right ~a\n" oldrightsensor)
              (rRight)
              (irLoop)
              )
             )))
        )
    )
  (irLoop)
  )

(define (minimalLoop)
  (open-asip)
  
  ;; let ’s take things easy ...
  (sleep 0.2)
  (enableCounters 10)
  (sleep 0.2)
  (enableIR 10)
  (sleep 0.2)
  
  (sStart)
  ;; half a second to stabilise
  (sleep 0.5)
  
  (irLoop)
  (close-asip)
  )

(minimalLoop)