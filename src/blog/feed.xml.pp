#lang pollen
◊(require gregor
          pollen/core
          pollen/pagetree
          pollen/file
	  pollen/template
	  racket/path
	  racket/string)

◊(define here-path (select-from-metas 'here-path metas))

◊(define ptree (get-pagetree (build-path
                               (path-only (string->path here-path))
                               'up
                               "index.ptree")))

◊(current-pagetree ptree)

◊(define (rfc822 dt) (~t dt "E, dd MMM yyyy HH:mm:ss Z"))

◊(define (render-item item)
   (let* ((src (get-source (path->string (path->complete-path (symbol->string item)))))
          (link (format "https://jeremydormitzer.com/blog/~a" item)))
     (format
       "<item>
          <title>~a</title>
	  <link>~a</link>
	  <guid>~a</guid>
	  <description>~a</description>
	  <pubDate>~a</pubDate>
       </item>"
       (select 'h1 src)
       link
       link
       (->html (->html (get-doc src)))
       (rfc822 (with-timezone
                 (at-midnight
	           (parse-date (select-from-metas 'published src) "yyyy-MM-dd"))
	         "America/New_York")))))

◊(define (render-items items)
   (string-join (map render-item items) "\n"))
   
◊(define today (rfc822 (now/moment)))

<rss version="2.0">
  <channel>
    <title>Jeremy Dormitzer's blog</title>
    <link>https://jeremydormitzer.com/blog</link>
    <description>Programming and general geekiness from Jeremy Dormitzer.</description>
    <language>en-us</language>
    <copyright>© Jeremy Dormitzer 2019</copyright>
    <ttl>60</ttl>
    <lastBuildDate>◊|today|</lastBuildDate>
    <pubDate>◊|today|</pubDate>
    <docs>https://validator.w3.org/feed/docs/rss2.html</docs>
    ◊(render-items (sort (children 'blog) date>? #:key post-published-date))
  </channel>
</rss>
