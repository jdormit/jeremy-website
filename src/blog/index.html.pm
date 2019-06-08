#lang pollen

◊(require pollen/pagetree
          pollen/file
          racket/path)

◊(define here-path (select-from-metas 'here-path metas))
◊(define ptree (get-pagetree (build-path
                               (path-only (string->path here-path))
                               'up
                               "index.ptree")))
◊(current-pagetree ptree)

◊(define (get-posts)
   (children 'blog))

◊for/splice[((post (get-posts)))]{
    ◊let[((src (get-source (path->string (path->complete-path (symbol->string post))))))]{
    ◊(string-append "blog/" (symbol->string post))
        ◊;◊link[#:href ◊post]{◊(select 'h1 src)}
    }
}