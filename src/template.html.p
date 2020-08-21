◊(define the-title
   (or (select-from-metas 'browser-title (current-metas))
       (select 'h1 doc)
       "Jeremy Dormitzer"))

<html lang="en">
    <head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>◊|the-title|</title>
	<link rel="alternate"  title="Jeremy Dormitzer's blog" type="application/rss+xml" href="/blog/feed.xml" /> 
	<link rel="stylesheet" type="text/css" href="/normalize.css" />
	<link rel="stylesheet" type="text/css" href="/js/highlight/styles/default.css" />
        <link rel="stylesheet" type="text/css" href="/fonts/cooper-hewitt/stylesheet.css" />
        <link rel="stylesheet" type="text/css" href="/fonts/charter/stylesheet.css" />
	<link rel="stylesheet" type="text/css" href="/stylesheet.css" />
    </head>
    <body>
	<div class="site">
	    <header>
		<nav>
		    <ul class="navigation">
			<!-- TODO refactor these into a function to make it easy to add new items -->
			<li><a href="/">home</a></li>
			<li><a href="/blog">blog</a></li>
			<li class="rss">
			    <a rel="alternate" type="application/rss+xml" href="/blog/feed.xml">
				<img src="/images/rss.svg" width="24px" height="24px" />
			    </a>
			</li>
		    </ul>
		</nav>
	    </header>
	    <div class="main">
		◊(->html doc)
	    </div>
	    <footer>
		<small>© Jeremy Dormitzer 2019 - 2020</small>
	    </footer>
	</div>
	<script src="/js/highlight/highlight.pack.js"></script> 
	<script>hljs.configure({useBR: true}); hljs.initHighlightingOnLoad();</script>
    </body>
</html> 
