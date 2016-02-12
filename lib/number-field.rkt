#lang racket

(require racket/gui)

(provide number-field%)

#| Formulaire de saisis de nombres |#
(define number-field%
  (class text-field%
    (define/override (on-subwindow-char obj evt)
      (let ([key (send evt get-key-code)])
        (when (or (symbol? key)
                  (char-numeric? key)
                  (char=? key #\backspace)
                  (char=? key #\rubout)
                  (char=? key #\.))
          (super on-subwindow-char obj evt))))
    (super-new)))
