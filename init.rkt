#lang racket
(require "lib/minimodem.rkt")
(require "app/lib/appconf.rkt")
(require "app/main.rkt")
(require racket/date)
(require racket/runtime-path)

(date-display-format 'indian)
(define-runtime-path configFile "app/config/app.conf")

(define config (new appconfig% [fichier configFile]))
(define minimodem (new minimodem%
                       [bauds (send config get "bauds")]
                       [alsa (send config get "alsa")]
                       [sampleRate (send config get "samplerate")]))

(define app-tools (hash "minimodem" minimodem "config" config))

(main app-tools) ; on lance la fenetre principale
