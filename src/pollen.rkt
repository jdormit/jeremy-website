#lang racket

(require pollen/core
	 pollen/file
	 pollen/decode
	 txexpr
	 gregor)

(provide (all-defined-out))

(define (list-range lst start end)
  (let ((dropped (drop lst start)))
    (if (>= (length dropped) (- end start))
        (take dropped (- end start))
        dropped)))

(define (post->source post)
  (get-source (path->string (path->complete-path (symbol->string post)))))

(define (post-published-date post)
  (let ((src (post->source post)))
    (iso8601->date (select-from-metas 'published src))))

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

(define header-image
  (make-keyword-procedure
   (lambda (kws kw-args . elements)
     (txexpr 'img (with-class (zip-kws kws kw-args) "header-image") elements))))

(define codeblock
  (make-keyword-procedure
   (lambda (kws kw-args . elements)
     (let ((new-kws (map (lambda (kw)
			   (if (eq? kw '#:lang) '#:class kw))
			 kws)))
       (txexpr
	'pre empty
	(list (txexpr 'code (zip-kws new-kws kw-args) elements)))))))

(define (published-date date-str)
  (let ((publish-date (iso8601->date date-str)))
    (txexpr
     'p '((class "published-date")) `("Posted on " ,(~t publish-date "MMMM d, y")))))

(define (make-excerpt doc)
  (let ((elts (get-elements doc)))
    (txexpr 'div '((class "excerpt")) (list-range elts 2 5))))

(define (excerpt post)
  (let ((src (post->source post)))
    (if (select-from-metas 'excerpt src)
	(select-from-metas 'excerpt src)
	(make-excerpt (get-doc src)))))

(define (divider)
  (txexpr 'div '((class "divider"))))

(define italic
  (make-keyword-procedure
   (lambda (kws kw-args . elements)
     (txexpr 'em (zip-kws kws kw-args) elements))))
