#lang pollen

◊(require pollen/core
          pollen/pagetree
          pollen/file
	  gregor
          racket/path
	  racket/list)

◊(define here-path (select-from-metas 'here-path metas))
◊(define ptree (get-pagetree (build-path
                               (path-only (string->path here-path))
                               'up
                               "index.ptree")))
◊(current-pagetree ptree)

◊(define (get-posts)
   (sort (children 'blog)
         date>?
	 #:key post-published-date))

◊(define (render-post post)
   (let ((src (get-source (path->string (path->complete-path (symbol->string post))))))
     (div (title (select 'h1 src))
          (published-date (select-from-metas 'published src))
          (excerpt post)
          (link "Read more..." #:href (symbol->string post)))))

◊(let ((rendered-posts (add-between (map render-post (get-posts)) (divider))))
   `(div ,@rendered-posts))
