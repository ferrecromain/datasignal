#lang racket
(require racket/gui)
 
(define f (new frame% [label "l"]))
 
 
(define c%
  (class text-field%
    (define/override (on-subwindow-char a b)
      (printf "called ~v\n" (send b get-key-code))
      (super on-subwindow-char a b))
    (super-new)))
 
(new c% [label "x"] [parent f])
(send f show #t)
