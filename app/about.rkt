#lang racket

(require racket/gui)
(require racket/runtime-path)

(provide about)

(define-runtime-path aboutText "lang/about.txt")

(define (about p-frame)
  
  (define DIALOG (new dialog% (label "A Propos") (parent p-frame)
                      [min-width 300] [min-height 300]))
  (define VPANEL (new vertical-panel% (parent DIALOG) (alignment '(center top))))
  (define TEXT (new text% [auto-wrap #t]))
  (define EDITOR-CANVAS (new editor-canvas%
                             [parent VPANEL]
                             [enabled #t]
                             [style '(auto-vscroll no-hscroll)]
                             [editor TEXT]))
  (define BUTTON (new button% (label "Ok") (parent VPANEL)
                      (callback (lambda (obj evt)
                                  (send DIALOG show #f)))))
  (send TEXT insert (file->string aboutText))
  (send TEXT set-position 0)
  (send DIALOG show #t))
  
