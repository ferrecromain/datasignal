#lang racket

(require racket/gui)
(require racket/date)
(require "options.rkt" "about.rkt")
(require "lib/textRefresher.rkt")

(provide main)

(define (main app-tools)
  (define minimodem (hash-ref app-tools "minimodem"))
  
  (define FRAME (new (class frame% (super-new)
                       (define/augment (on-close)
                         (send minimodem killBothTransmissionReception)
                         (send textRefresher stop)))
                     [label "DataSignal"]
                     [min-width 500]
                     [min-height 500]))
  
  (define VPANEL (new vertical-panel% (parent FRAME)))
  
  (define RECEPTION-TEXT-COLOR (make-object style-delta% 'change-normal-color))
  (define RECEPTION-TEXT-SIZE (make-object style-delta% 'change-toggle-size-in-pixels))
  (define RECEPTION-TEXT (new text% [auto-wrap #t]))
  (define RECEPTION-CANVAS (new editor-canvas%
                                (parent VPANEL)
                                (enabled #f)
                                (style '(auto-vscroll no-hscroll))
                                (editor RECEPTION-TEXT)))
  
  (define TRANSMISSION-FIELD (new text-field% (parent VPANEL) (label "")
                                  (callback (λ (obj evt)
                                              (when (equal? (send evt get-event-type) 'text-field-enter)
                                                (send ENVOYER-BUTTON command 'button))))))
  (define HPANEL (new horizontal-panel% (parent VPANEL) (stretchable-height #f)))
  (define ENVOYER-BUTTON (new button%
                              (parent HPANEL)
                              (label "Envoyer")
                              (callback (lambda (obj evt)
                                          (let ([textToSend (send TRANSMISSION-FIELD get-value)])
                                            (unless (equal? textToSend "")
                                              (send minimodem sendText textToSend)
                                              (send TRANSMISSION-FIELD set-value "")))))))
  (define OPTIONS-BUTTON (new button% (parent HPANEL) (label "Options")
                              (callback (λ (obj evt)
                                          (options app-tools FRAME textRefresher)))))
  (define ABOUT-BUTTON (new button% (parent HPANEL) (label "A propos")
                              (callback (λ (obj evt)
                                          (about FRAME)))))
  ; Tache de rafraichissement du panneau de reception
  (define textRefresher (new textRefresher%
                             [text-field RECEPTION-TEXT]
                             [mmOutputPort (send minimodem getOutputPort)]))
  (send textRefresher start)
  
  ; Fond noir sur la fenetre de reception et d'emission
  (send RECEPTION-CANVAS set-canvas-background (make-object color% "black"))
  
  ; Taille fixe de 10 pixels
  (send RECEPTION-TEXT-SIZE set-size-in-pixels-on 10)
  (send RECEPTION-TEXT change-style RECEPTION-TEXT-SIZE)
  
  (send FRAME show #t))


