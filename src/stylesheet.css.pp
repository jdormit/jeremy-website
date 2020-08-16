#lang pollen

◊(define navbar-height 60)
◊(define serif-font-stack "Charter, 'Palatino Linotype', Palatino, Palladio, 'URW Palladio L', 'Book Antiqua', Baskerville, 'Bookman Old Style', 'Bitstream Charter', 'Nimbus Roman No9 L', Garamond, 'Apple Garamond', 'ITC Garamond Narrow', 'New Century Schoolbook', 'Century Schoolbook', 'Century Schoolbook L', Georgia, serif")
◊(define small-caps-font-stack "Charter, 'Palatino Linotype', Palatino, Palladio, 'URW Palladio L', 'Book Antiqua', Baskerville, 'Bookman Old Style', 'Bitstream Charter', 'Nimbus Roman No9 L', Garamond, 'Apple Garamond', 'ITC Garamond Narrow', 'New Century Schoolbook', 'Century Schoolbook', 'Century Schoolbook L', Georgia, serif")
◊(define sans-serif-font-stack "'Cooper Hewitt', Frutiger, 'Frutiger Linotype', Univers, Calibri, 'Gill Sans', 'Gill Sans MT', 'Myriad Pro', Myriad, 'DejaVu Sans Condensed', 'Liberation Sans', 'Nimbus Sans L', Tahoma, Geneva, 'Helvetica Neue', Helvetica, Arial, sans-serif;")
◊(define monospace-font-stack "Menlo, Consolas, Monaco, 'Liberation Mono', 'Lucida Console', monospace")
◊(define body-color "#404040")
◊(define link-color "royalblue")
◊(define link-hover-color "midnightblue")
◊(define link-visited-color "purple")
◊(define nav-hover-color "#707070")
◊(define divider-color "#CDCDCD")
◊(define blockquote-border-color "#CCC")
◊(define blockquote-background-color "#F9F9F9")

html {
    font-size: 20px;
}

body {
    height: 100%;
    max-width: 1920px;
    font-size: 1rem;
    font-family: ◊|serif-font-stack|;
    color: ◊|body-color|;
    line-height: 1.5;
    margin: auto;
    font-feature-settings: 'kern' 1;
    text-rendering: optimizeLegibility;
}

header {
    height: ◊|navbar-height|px;
    margin-top: 1rem;
}

footer {
    text-align: center;
    padding: 1rem 0 1rem 0;
}

h1, h2, h3, h4, h5 {
    font-weight: bold;
    font-family: ◊|sans-serif-font-stack|
}

h4, h5 {
    font-size: 1rem;
}

h3 {
    font-size: 1.25rem;
}

h2 {
    font-size: 1.563rem;
}

h1 {
    font-size: 1.953rem;
}

small {
    font-size: 0.8rem;
}

a {
    color: ◊|link-color|;
    text-decoration: none;
}

img {
    max-width: 100%;
    height: auto;
}

a:visited {
    color: ◊|link-visited-color|;
}

a:hover {
    color: ◊|link-hover-color|;
}

code, pre {
    font-family: ◊|monospace-font-stack|;
    font-size: 0.9rem;
}

ul, ol {
    margin: 0 0 1.5rem 3rem;
}

li {
    margin-top: 1rem;
}

blockquote {
	margin: 1rem 1.5rem;
	border-left: 10px solid ◊|blockquote-border-color|;
	background: ◊|blockquote-background-color|;
	padding: 1.3rem 0.5rem;
}

pre > code.hljs {
    padding: 1.5rem;
}

.site {
    height: 100%;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
}

.main {
    display: grid;
    grid-template-columns: repeat(12, 1fr);
    grid-auto-rows: auto;
    grid-gap: 1rrem;
    flex: 3;
}

.content {
    margin-top: ◊|navbar-height|px;
    grid-column: 5 / 10;
    hyphens: auto;
    max-width: 100%;
}

ul.navigation {
    list-style: none;
    margin: 0;
    padding: 0;
    display: flex;
    flex-direction: row;
    align-items: center;
}

ul.navigation > li {
    display: inline;
    margin-left: 2rem;
    margin-top: 0;
    font-family: ◊|sans-serif-font-stack|;
    letter-spacing: 0.05rem;
}

ul.navigation > li.rss {
    margin-left: auto;
    margin-right: 2rem;
}

ul.navigation > li > a {
    color: ◊|body-color|;
}

ul.navigation > li > a:hover {
    color: ◊|nav-hover-color|;
}

.float-left {
    float: left;
    margin-right: 1rem;
}

.section-header {
    margin-top: 2rem;
}

div.divider {
    margin-top: 2rem;
    margin-bottom: 2rem;
    border-top: 1px solid ◊|divider-color|;
}

@media screen and (max-width: 768px) {
    .content {
	grid-column: 2 / 12;
    }

    .float-left {
	float: none;
	margin-right: auto;
    }

    ul, ol {
	margin: 0 0 1.5rem 1rem;
    }
}
