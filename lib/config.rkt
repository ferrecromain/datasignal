#lang racket

#| Api d'accès et de définition d'options dans un fichier de configuration |#

(provide config%)

(define config%
  (class object%
    (init-field fichier)
    
    (define/public (get name)
      (get-preference (string->symbol name) (lambda () #f) 'timestamp fichier))

    (define/public (setTo name val)
      (put-preferences `(,(string->symbol name)) `(,val) #f fichier))

    (super-new)))

      
