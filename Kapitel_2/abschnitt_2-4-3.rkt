;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  SICP - Abschnitt 2.4.3  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#lang racket

(define (etikettieren typ-etikett inhalt)
  (cons typ-etikett inhalt))

(define (installiere-rechteck-package)
  ; interne Prozeduren:
  (define (reeller-teil z) (car z))
  (define (imag-teil z) (cdr z))
  (define (konstr-aus-reell-imag x y) (cons x y))
  (define (abs-wert z)
    (sqrt (+ (quadrat (reeller-teil z)) (quadrat imag-teil z))))
  (define (winkel z)
    (atan (imag-teil z) (reeller-teil z)))
  (define (konstr-aus-abs-wkl r a)
    (cons (* r (cos a)) (* r (sin a))))

  ; Schnittstelle zum übrigen System:
  (define (etikett x) (etikettieren 'rechteck x))
  (put 'reeller-teil '(rechteck) reeller-teil)
  (put 'imag-teil '(rechteck) imag-teil)
  (put 'abs-wert '(rechteck) abs-wert)
  (put 'winkel '(rechteck) winkel)
  (put 'konstr-aus-reell-imag 'rechteck
       (lambda (x y) (etikett (konstr-aus-reell-imag x y))))
  (put 'konstr-aus-abs-wkl 'rechteck
       (lambda (r a) (etikett (konstr-aus-abs-wkl r a))))
  'fertig)

(define (installiere-polar-package)
  ; interne Prozeduren:
  (define (abs-wert z) (car z))
  (define (winkel z) (cdr z))
  (define (konstr-aus-abs-wkl r a) (cons r a))
  (define (reeller-teil z)
    (* (abs-wert z) (cos (winkel z))))
  (define (imag-teil z)
    (* (abs-wert z) (sin (winkel z))))
  (define (konstr-aus-reell-imag x y)
    (cons (sqrt (+ (quadrat x) (quadrat y)))
          (atan y x)))

  ; Schnittstelle zum übrigen System:
  (define (etikett x) (etikettieren 'polar x))
  (put 'reeller-teil '(polar) reeller-teil)
  (put 'imag-teil '(polar) imag-teil)
  (put 'abs-wert '(polar) abs-wert)
  (put 'winkel '(polar) winkel)
  (put 'konstr-aus-reell-imag 'polar
       (lambda (x y) (etikett (konstr-aus-reell-imag x y))))
  (put 'konstr-aus-abs-wkl 'polar
       (lambda (r a) (etikett (konstr-aus-abs-wkl r a))))
  'fertig)

; Implementierung einer allgemeinen Operations-Prozedur
(define (anwenden-generisch op . args)
  (let ([typ-etiketten (map etikettieren args)])
    (let ([proc (get op typ-etiketten)])
      (if proc
        (apply proc (map inhalt args))
        (error "Keine Methode für diese Typen -- ANWENDEN-GENERISCH"
               (list op typ-etiketten))))))

; Implementierung der generischen Selektoren
(define (reeller-teil z) (anwenden-generisch 'reeller-teil z))
(define (imag-teil z) (anwenden-generisch 'imag-teil z))
(define (abs-wert z) (anwenden-generisch 'abs-wert z))
(define (winkel z) (anwenden-generisch 'winkel z))

; Implementierung der generischen Konstruktoren:
(define (konstr-aus-reell-imag x y)
  ((get 'konstr-aus-reell-imag 'rechteck) x y))

(define (konstr-aus-abs-wkl r a)
  (('konstr-aus-abs-wkl 'polar) r a))


; Zusätzliche Prozedur:
(define (quadrat t) (* t t))