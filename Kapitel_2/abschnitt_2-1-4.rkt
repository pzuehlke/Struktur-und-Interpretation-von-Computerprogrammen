;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  SICP - Abschnitt 2.1.4  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#lang racket

(provide add-intervall mul-intervall kehr-intervall
         div-intervall sub-intervall drucke-intervall
         konstr-intervall untere-grenze obere-grenze
         konstr-mittel-breite mittel par1 par2
         I J K L)

; Implementierung von Intervallen:

(define (konstr-intervall a b)
  (cons a b))

(define (untere-grenze I) (car I))

(define (obere-grenze I) (cdr I))

; Implementierung einer "Intervallarithmetik"

(define (add-intervall I J)
  (konstr-intervall (+ (untere-grenze I) (untere-grenze J))
                    (+ (obere-grenze I) (obere-grenze J))))

(define (mul-intervall I J)
  (let ((p1 (* (untere-grenze I)    (untere-grenze J)))
        (p2 (* (untere-grenze I)    (obere-grenze J)))
        (p3 (* (obere-grenze I)     (untere-grenze J)))
        (p4 (* (obere-grenze I)     (obere-grenze J))))
    (konstr-intervall (min p1 p2 p3 p4)
                      (max p1 p2 p3 p4))))

(define (kehr-intervall I)
  (konstr-intervall (/ 1.0 (obere-grenze I))
                    (/ 1.0 (untere-grenze I))))

(define (div-intervall I J)
  (mul-intervall I (kehr-intervall J)))

(define (sub-intervall I J)
  (konstr-intervall
    (- (untere-grenze I)    (obere-grenze J))
    (- (obere-grenze I)     (untere-grenze J))))

(define (drucke-intervall I)
  (display "[")
  (display (untere-grenze I))
  (display " , ")
  (display (obere-grenze I))
  (display "]"))

(define (konstr-mittel-breite m b)
  (konstr-intervall (- m b) (+ m b)))

(define (mittel I)
  (/ (+ (untere-grenze I) (obere-grenze I)) 2))

(define (par1 I J)
  (div-intervall (mul-intervall I J)
                 (add-intervall I J)))

(define (par2 I J)
  (let ((eins (konstr-intervall 1 1)))
    (div-intervall eins
                   (add-intervall (div-intervall eins I)
                                  (div-intervall eins J)))))

; Beispiele von Intervallen:

; I = [1, 3]
(define I (konstr-intervall 1 3))
 
; J = [2, 4]
(define J (konstr-intervall 2 4))

; K = [-1, 1]
(define K (konstr-intervall (- 1) 1))

; L = [-3, -1]
(define L (konstr-intervall (- 3) (- 1)))
