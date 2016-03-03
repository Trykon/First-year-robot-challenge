#lang racket

(require "AsipMain.rkt")

(define (action x y) (cond
                     ((string? x) (cond
                                    ((equal? x "right") (setMotors 0 150) (sleep y) (stopMotors))
                                    ((equal? x "left") (setMotors -150 0) (sleep y) (stopMotors))
                                    ((equal? x "back") (setMotors 150 -150) (sleep y) (stopMotors))
                                    ((equal? x "forward") (setMotors -150 150) (sleep y) (stopMotors))
                                    (#t "not proper command" (action (read)(read)))
                                  )
                     (#t "please put string data" (action (read)(read))))))
(define (move)
  (action (read) (read))
  (move)
  )

(define (loop)
  (open-asip)
  (sleep 0.2)
  (move)
  (close-asip)
  )

(loop)
