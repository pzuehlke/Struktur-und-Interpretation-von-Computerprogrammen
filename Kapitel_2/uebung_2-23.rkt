;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;  Lösung zur Übung 2.23 - SICP  ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (fuer-jedes proz elemente)
  (cond ((null? elemente) (display ""))
        (else
          (proz (car elemente)) (fuer-jedes proz (cdr elemente)))))