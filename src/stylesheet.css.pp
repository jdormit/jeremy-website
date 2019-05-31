#lang pollen

◊(define navbar-height 60)
◊(define serif-font-stack "'Century Supra', 'Palatino Linotype', Palatino, Palladio, 'URW Palladio L', 'Book Antiqua', Baskerville, 'Bookman Old Style', 'Bitstream Charter', 'Nimbus Roman No9 L', Garamond, 'Apple Garamond', 'ITC Garamond Narrow', 'New Century Schoolbook', 'Century Schoolbook', 'Century Schoolbook L', Georgia, serif")
◊(define monospace-font-stack "'Triplicate Code', SFMono-Regular, Menlo, Monaco, Consolas, 'Liberation Mono', 'Courier New', monospace")
◊(define body-color "#404040")
◊(define link-color "royalblue")
◊(define link-hover-color "midnightblue")
◊(define link-visited-color "purple")

body {
    height: 100%;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    font-size: 21px;
    font-family: ◊|serif-font-stack|;
    color: ◊|body-color|;
    line-height: 1.5;
    margin: 0;
    font-feature-settings: 'kern' 1;
    text-rendering: optimizeLegibility;
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

pre > code.hljs {
    padding: 1.5em;
}

.main {
    display: grid;
    grid-template-columns: repeat(12, 1fr);
    grid-auto-rows: auto;
    grid-gap: 1rem;
}

.content {
    margin-top: ◊|navbar-height|px;
    grid-column: 4 / 10;
    hyphens: auto;
}

.float-left {
    float: left;
    margin-right: 1em;
}
