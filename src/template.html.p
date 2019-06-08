<html>
    <head>
	<meta charset="utf-8">
	<title>◊(or (select 'h1 doc) "Jeremy Dormitzer")</title>
	<link rel="stylesheet"  type="text/css"  href="/js/highlight/styles/default.css" />
	<link rel="stylesheet"  type="text/css" href="/fonts/century-supra/stylesheet.css" />
	<link rel="stylesheet"  type="text/css" href="/fonts/triplicate/stylesheet.css" />
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
		    </ul>
		</nav>
	    </header>
	    <div class="main">
		◊(->html doc)
	    </div>
	</div>
	<footer>
	    © Jeremy Dormitzer 2019
	</footer>
	<script src="/js/highlight/highlight.pack.js"></script> 
	<script>hljs.initHighlightingOnLoad();</script>
    </body>
</html> 
