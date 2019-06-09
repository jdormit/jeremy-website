#lang racket
(require pollen/core pollen/decode txexpr gregor)
(provide (all-defined-out))

(define (root . elements)
  (let ((the-title (select-from-metas 'title (current-metas)))
	(published (select-from-metas 'published (current-metas))))
    (txexpr 'div
	    '((class "content"))
	    `(,(when/splice the-title (title the-title))
	      ,(when/splice published (published-date published))
	      ,@(decode-elements elements
				 #:txexpr-elements-proc decode-paragraphs)))))

(define (zip-kws kws kw-args)
  (map list (map string->symbol (map keyword->string kws)) kw-args))

(define (with-class attrs cls)
  (let ((existing-cls (assoc 'class attrs)))
    (dict-set attrs 'class (if existing-cls
			       (list (string-append (cadr existing-cls) " " cls))
			       (list cls)))))

(define title
  (make-keyword-procedure
   (lambda (kws kw-args . elements)
     (txexpr 'h1 (zip-kws kws kw-args) elements))))

(define heading
  (make-keyword-procedure
   (lambda (kws kw-args . elements)
     (txexpr 'h2 (with-class (zip-kws kws kw-args) "section-header") elements))))

(define link
  (make-keyword-procedure
   (lambda (kws kw-args . elements)
     (txexpr 'a (zip-kws kws kw-args) elements))))
        
(define image
  (make-keyword-procedure
   (lambda (kws kw-args . elements)
     (txexpr 'img (zip-kws kws kw-args) elements))))

(define codeblock
  (make-keyword-procedure
   (lambda (kws kw-args . elements)
     (let ((new-kws (map (lambda (kw)
			   (if (eq? kw '#:lang) '#:class kw))
			 kws)))
       (txexpr
	'pre empty
	(list (txexpr 'code (zip-kws new-kws kw-args) elements)))))))

(define (tags . taglist)
  ;; TODO make these links to an index page for each tag
  (txexpr 'span '((class "tags")) `("Tagged " ,(string-join taglist ", "))))

(define (published-date date-str)
  (let ((publish-date (iso8601->date date-str)))
    (txexpr
     'span '((class "published-date")) `("Posted on " ,(~t publish-date "MMMM d, y")))))
