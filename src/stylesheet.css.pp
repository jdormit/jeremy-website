#lang pollen

◊(define navbar-height 60)
◊(define serif-font-stack "'Century Supra', 'Palatino Linotype', Palatino, Palladio, 'URW Palladio L', 'Book Antiqua', Baskerville, 'Bookman Old Style', 'Bitstream Charter', 'Nimbus Roman No9 L', Garamond, 'Apple Garamond', 'ITC Garamond Narrow', 'New Century Schoolbook', 'Century Schoolbook', 'Century Schoolbook L', Georgia, serif")
◊(define small-caps-font-stack "'Century Supra (Small Caps)', 'Palatino Linotype', Palatino, Palladio, 'URW Palladio L', 'Book Antiqua', Baskerville, 'Bookman Old Style', 'Bitstream Charter', 'Nimbus Roman No9 L', Garamond, 'Apple Garamond', 'ITC Garamond Narrow', 'New Century Schoolbook', 'Century Schoolbook', 'Century Schoolbook L', Georgia, serif")
◊(define monospace-font-stack "'Triplicate Code', SFMono-Regular, Menlo, Monaco, Consolas, 'Liberation Mono', 'Courier New', monospace")
◊(define body-color "#404040")
◊(define link-color "royalblue")
◊(define link-hover-color "midnightblue")
◊(define link-visited-color "purple")
◊(define nav-hover-color "#707070")
◊(define divider-color "#CDCDCD")
◊(define blockquote-border-color "#CCC")
◊(define blockquote-background-color "#F9F9F9")

body {
    height: 100%;
    max-width: 1920px;
    font-size: 21px;
    font-family: ◊|serif-font-stack|;
    color: ◊|body-color|;
    line-height: 1.5;
    margin: auto;
    font-feature-settings: 'kern' 1;
    text-rendering: optimizeLegibility;
}

header {
    height: ◊|navbar-height|px;
    margin-top: 1em;
}

footer {
    text-align: center;
    padding: 1em 0 1em 0;
}

h1, h2, h3, h4, h5 {
    font-size: 21px;
    font-weight: bold;
}

a {
    color: ◊|link-color|;
    text-decoration: none;
}

img {
    max-width: 100%;
}

a:visited {
    color: ◊|link-visited-color|;
}

a:hover {
    color: ◊|link-hover-color|;
}

code, pre {
    font-family: ◊|monospace-font-stack|;
    font-size: 20px;
}

ul, ol {
    margin: 0 0 1.5em 3em;
}

li {
    margin-top: 1em;
}

blockquote {
	margin: 1em 1.5em;
	border-left: 10px solid ◊|blockquote-border-color|;
	background: ◊|blockquote-background-color|;
	padding: 1.3em 0.5em;
}

pre > code.hljs {
    padding: 1.5em;
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
    grid-gap: 1rem;
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
}

ul.navigation > li {
    display: inline;
    margin-left: 2em;
    font-family: ◊|small-caps-font-stack|;
    font-size: 25px;
    letter-spacing: 0.05rem;
}

ul.navigation > li > a {
    color: ◊|body-color|;
}

ul.navigation > li > a:hover {
    color: ◊|nav-hover-color|;
}

.float-left {
    float: left;
    margin-right: 1em;
}

.section-header {
    margin-top: 2em;
}

div.divider {
    margin-top: 2em;
    margin-bottom: 2em;
    border-top: 1px solid ◊|divider-color|;
}

@media screen and (max-width: 720px) {
    .content {
	grid-column: 2 / 12;
    }

    .float-left {
	float: none;
	margin-right: auto;
    }

    ul, ol {
	margin: 0 0 1.5em 1em;
    }
}
