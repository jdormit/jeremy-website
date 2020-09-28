#lang pollen

◊(define-meta title "unifyDB Dev Diary 1: the query system")
◊(define-meta published "2020-09-28")

This is the first development diary for the database I'm writing, ◊link[#:href "https://github.com/unifydb/unifydb" #:target "_blank"]{unifyDB}. I wrote a brief introduction to the project ◊link[#:href "https://jeremydormitzer.com/blog/unifydb-dev-diary-0-intro.html" #:target "_blank"]{here}. In this post I'm going to talk about unifyDB's query system: what it does and how it works.

I want to start with an example of a unifyDB query, but to understand that we need to understand a bit about how unifyDB represents data. All data in unifyDB is stored as a collection of facts. A fact is a tuple with three pieces of information: an entity ID, an attribute name, and a value (actually, a fact has two additional fields, a transaction ID and an ◊code{added?} flag, but we won't worry about those until we talk about time-traveling queries, which deserves its own blog post). For example, we might represent a user record with the following set of facts:

◊codeblock{
(1, "username", "jdormit")
(1, "role", "user")
(1, "role", "admin")
(1, "preferred-theme", "light")
}

This corresponds with the following record in a more conventional JSON format:

◊codeblock[#:lang "json"]{
{
    "username": "jdormit",
    "role": ["user", "admin"],
    "preferred-theme": "light"
}
}

With that under our belt, let's take a look at an example unifyDB query. The unifyDB server understands query written in ◊link[#:href "https://github.com/edn-format/edn" #:target "_blank"]{extensible data notation}, but database clients for different programming languages will allow developers to write queries that feel native to that language. Here's a query in EDN format:

◊codeblock[#:lang "clojure"]{
{:find [?username]
 :where [[?e :preferred-theme "light"]
         [?e :username ?username]]}
}

This query says, “find me the values of all the ◊code{username} attributes of entities whose ◊code{preferred-theme} is ◊code{"light"}”. If we run this query on the set of facts given above, it would return:

◊codeblock[#:lang "clojure"]{
[["jdormit"]]
}

Note that the return value is a list of lists —  although our query only asked for one field, ◊code{username}, it could have asked for more, in which case each result in the result list would be a list with all the requested values. Once again, although unifyDB itself returns data in EDN format, client libraries will wrap that return value in whatever native data structure is convenient.

Let’s break that query down a bit. First, a bit of notation: any symbol that starts with a ◊code{?} is called a variable, and is similar in spirit to a variable in a programming language. The query above has two major pieces: a ◊code{:find} clause and a ◊code{:where} clause. The ◊code{:find} clause is straightforward: it asks to find the value of the variable ◊code{?username}. But how does it know what value that variable has? That’s where thing interesting.