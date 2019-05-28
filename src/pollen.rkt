#lang racket
(require pollen/decode txexpr)
(provide (all-defined-out))

(define (root . elements)
  (txexpr 'div
          '((class "content"))
          (decode-elements elements
                           #:txexpr-elements-proc decode-paragraphs)))

(define (zip-kws kws kw-args)
  (map list (map string->symbol (map keyword->string kws)) kw-args))

(define title
  (make-keyword-procedure
   (lambda (kws kw-args . elements)
     (txexpr 'h1 (zip-kws kws kw-args) elements))))

(define link
  (make-keyword-procedure
   (lambda (kws kw-args . elements)
     (txexpr 'a (zip-kws kws kw-args) elements))))
        
(define image
  (make-keyword-procedure
   (lambda (kws kw-args . elements)
     (txexpr 'img (zip-kws kws kw-args) elements))))
