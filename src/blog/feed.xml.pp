#lang pollen
◊(require pollen/core
          pollen/pagetree
          pollen/file
	  racket/path
	  racket/string)

◊(define here-path (select-from-metas 'here-path metas))

◊(define ptree (get-pagetree (build-path
                               (path-only (string->path here-path))
                               'up
                               "index.ptree")))

◊(current-pagetree ptree)

◊(define (render-item item)
   (let ((src (get-source (path->string (path->complete-path (symbol->string item))))))
     (format
       "<item>
          <title>~a</title>
	  <link>~a</link>
       </item>"
       (select 'h1 src)
       (format "https://jeremydormitzer.com/blog/~a" item))))

◊(define (render-items items)
   (string-join (map render-item items) "\n"))

<rss version="2.0">
  <channel>
    <title>Jeremy Dormitzer's blog</title>
    <link>https://jeremydormitzer.com/blog</link>
    <description>Programming and general geekiness from Jeremy Dormitzer.</description>
    <language>en-us</language>
    <copyright>© Jeremy Dormitzer 2019</copyright>
    <ttl>60</ttl>
    ◊(render-items (children 'blog))
  </channel>
</rss>
