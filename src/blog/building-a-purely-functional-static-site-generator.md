---
title: Building a purely-functional static site generator
author: Jeremy Dormitzer
published: 2020-12-28
---
Ok, I know. That was kind of a lie. No static site generator can ever really be purely functional, since the side effects are the whole point. But I think I found a way to build a site generator that retains all the benefits of a purely functional architecture - simplicity, flexibility, and hackability.

Let me back up. I have been looking into new technology for my website for a while now. Right now I'm using a very capable site generator called [Pollen](https://docs.racket-lang.org/pollen/), but it has started to feel too complicated for my needs. I found [Gatsby.js](https://www.gatsbyjs.com/), and while it ticks most of the right boxes (able to source content from multiple sources at compile time, pluggable with a huge plugin ecosystem), it still has a ton of features I'm never going to use and feels over-architected for what should be a simple solution.

So I decided to build my own static site generator. I'm calling it [Obelix](https://github.com/obelix-site-builder/obelix), and it aims to combine the best parts of Gatsby with a stripped-down, simple architecture. This blog post was rendered in it! In this post, I'm going to give a brief overview of how Obelix works and talk about why I built it this way.

## The big picture
Obelix uses a simple internal data structure to represent the contents of a static site:

```clojure
{:metadata {}
 :routes []}
```

`:metadata` holds a dictionary of arbitrary metadata about the site as a whole, stuff like the copyright date or the last updated timestamp. `:routes` is a list of all the site's static pages. If the site consists of three routes — `index.html`, `blog/post-1.html`, `blog/post-2.html` — then the `:routes` list might look like this:

```clojure
[{:name "index.html"
  :type :page
  :content "Content here"}
 {:name "blog/post-1.html"
  :type :page
  :content "More content here"}
 {:name "blog/post-2.html"
  :type :page
  :content "So much content!"}]
```

As you can see, the elements of the `:routes` list are nodes representing the asset that lives at that URL. Asset maps can have whatever keys are necessary to render that asset.

The heart of Obelix is a pipeline of handler functions. A handler function takes in a site map and does something with it — add a key, transform a node, write stuff out to disk. Handler functions are added via plugins, which are simply modules that provide handler functions to be run at various points during the build pipeline. Obelix comes with several core plugins that always run during the build process, and more can be added via third-party or project-specific plugins.

The plugins are where all of the actual behavior of the site generator lives. For example, one plugin reads Markdown-formatted files from disk, parses them, and adds them as routes in the site list. Another plugin walks the routes, transforms the pages to text, and writes them to disk in the output directory.

The beauty of this functional approach is that it is capable of supporting basically any feature offered by other static site generators, but those features can be implemented by plugins outside the core of the generator itself. A templating engine, for example, where template files in the source directory get applied to multiple pages in the output site, can be implemented as a plugin that wraps some of the routes in the site map with new content.

I'm really happy with how Obelix turned out. It's available for installation [on NPM](https://npmjs.org/obelix) and the full source code is available on [GitHub](https://github.com/obelix-site-builder/obelix). If you’re interested in contributing plugins or want to use Obelix for your own site, let me know [on Twitter](https://twitter.com/jeremydormitzer)!
