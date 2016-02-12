#lang racket

(require racket/gui)
(require racket/date)

(provide textRefresher%)

(define textRefresher%
  (class object%
    (init-field text-field mmOutputPort)
    (define textColor (make-object style-delta% 'change-normal-color))
    (define refreshThread void)

    (define/public (start)
      (set! refreshThread
            (thread
             (lambda ()
               (let loop ()
                 (define charBuffer (read-char mmOutputPort))

                 ; Corrige le bug dans le cas ou l'on demande pulseaudio alors
                 ; qu'il est inexistant du système
                 (when (eof-object? charBuffer)
                   (send this stop))
                 
                 ;(send textColor set-delta-foreground "orange")
                 ;(send text-field change-style textColor)
                 ;(send text-field insert
                 ;      (format "~a :\n" (date->string (current-date) #t)))
                 (send textColor set-delta-foreground "white")
                 (send text-field change-style textColor)
                 (send text-field insert (format "~a" charBuffer))
                 (loop))))))
    
    (define/public (stop)
      (kill-thread refreshThread))

    (define/public (restart)
      (send this stop)
      (send this start))

    (define/public (setMmOutputPort val)
      (set! mmOutputPort val))

    (super-new)))
