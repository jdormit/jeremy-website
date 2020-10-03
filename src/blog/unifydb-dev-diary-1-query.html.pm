#lang pollen

◊(define-meta title "unifyDB Dev Diary 1: the query system")
◊(define-meta published "2020-09-28")

This is the first development diary for the database I'm writing, ◊link[#:href "https://github.com/unifydb/unifydb" #:target "_blank"]{unifyDB}. I wrote a brief introduction to the project ◊link[#:href "https://jeremydormitzer.com/blog/unifydb-dev-diary-0-intro.html" #:target "_blank"]{here}. In this post I'm going to talk about unifyDB's query system: what it does and how it works.

I want to start with an example of a unifyDB query, but to understand that we need to understand a bit about how unifyDB represents data. All data in unifyDB is stored as a collection of facts. A fact is a tuple with three pieces of information: an entity ID, an attribute name, and a value (actually, a fact has two additional fields, a transaction ID and an ◊code{added?} flag, but we won't worry about those until we talk about time-traveling queries, which deserves its own blog post). For example, we might represent some user records with the following set of facts:

◊codeblock{
(1, "username", "harry")
(1, "role", "user")
(1, "preferred-theme", "light")
(2, "username", "dumbledore")
(2, "role", "user")
(2, "role", "admin")
(2, "preferred-theme", "light")
(3, "username", "you-know-who")
(3, "role", "user")
(3, "role", "user")
(3, "role", "admin")
(3, "preferred-theme", "dark")
}

This corresponds with the following records in a more conventional JSON format:

◊codeblock[#:lang "json"]{
[
    {
        "id": 1,
        "username": "harry",
        "role": ["user"],
        "preferred-theme": "light"
    },
    {
        "id": 2,
        "username": "dumbledore",
        "role": ["user", "admin"],
        "preferred-theme": "light"
    },
    {
        "id": 3,
        "username": "you-know-who",
        "role": ["user", "admin"],
        "preferred-theme", "dark"
    }
]
}

(The astute reader will notice that there’s not actually a way to specify using a set of facts that ◊code{"role"} is a list but ◊code{"preferred-theme"} is a scalar value, i.e. the cardinality of an attribute. This requires another database feature, attribute schemas, that I’m going to save for another blog post.)

With that under our belt, let's take a look at an example unifyDB query. The unifyDB server understands query written in ◊link[#:href "https://github.com/edn-format/edn" #:target "_blank"]{extensible data notation}, but database clients for different programming languages will allow developers to write queries that feel native to that language. Here's a query in EDN format:

◊codeblock[#:lang "clojure"]{
{:find [?username]
 :where [[?e :preferred-theme "light"]
         [?e :username ?username]]}
}

This query says, “find me the values of all the ◊code{username} attributes of entities whose ◊code{preferred-theme} is ◊code{"light"}”. If we run this query on the set of facts given above, it would return:

◊codeblock[#:lang "clojure"]{
[["harry"]
 ["dumbledore"]]
}

Note that the return value is a list of lists —  although our query only asked for one field, ◊code{username}, it could have asked for more, in which case each result in the result list would be a list with all the requested values. Once again, although unifyDB itself returns data in EDN format, client libraries will wrap that return value in whatever native data structure is convenient.

Let’s break that query down a bit. First, a bit of notation: any symbol that starts with a ◊code{?} is called a variable, and is similar in spirit to a variable in a programming language. The query above has two major pieces: a ◊code{:find} clause and a ◊code{:where} clause. The ◊code{:find} clause is straightforward: it asks to find the value of the variable ◊code{?username}. But how does it know what value that variable has? That’s where things get interesting.

Let's take a closer look at the ◊code{:where} clause:

◊codeblock[#:lang "clojure"]{
:where [[?e :preferred-theme "light"]
        [?e :username ?username]]
}

It is a list of two relations - that is, expressions which assert some relationship between variables. The first relation, ◊code{[?e :preferred-theme "light"]}, declares that there is some entity ◊code{?e} whose ◊code{:preferred-theme} attribute has value ◊code{"light"}. The second relation is slightly more abstract, declaring a relation between some entity ◊code{?e} and the value of its ◊code{:username} attribute, which it assigns to the variable ◊code{?username}.

Notice that both relations share a variable, ◊code{?e}. This is where the magic happens! When two relations share a variable, they are said to ◊em{unify}. This means that the query engine finds all facts that satisfy ◊em{both} relations for some entity ◊code{?e}. In other words, unifyDB will find all sets of facts such that the facts share an entity ◊code{?e}, have one fact with attribute ◊code{:preferred-theme} and value ◊code{"light"}, and have another fact with attribute ◊code{:username} and any value.

The result of this unification process is a set of variable bindings, calculated from the facts that satisfy the query relation. In our example, we find that the following set of facts satisfies the query relation:

◊codeblock{
(1, "username", "harry")
(1, "preferred-theme", "light")
(2, "username", "dumbledore")
(2, "preferred-theme", "light")
}

Unifying these facts with the variables in the ◊code{:where} clause yields the following set of bindings:

◊codeblock{
{
    ?e: 1,
    ?username: "harry"
},
{
    ?e: 2,
    ?username: "dumbledore"
}
}

Finally, since our ◊code{:find} clause asks only for the variable ◊code{?username}, we look up that variable in the binding set, returning one result for each binding in the set:

◊codeblock[#:lang "clojure"]{
[["harry"]
 ["dumbledore"]]
}

This unification approach to querying makes the database particularly powerful. Although in this example we unified on the entity ID, we can also unify on the attribute name, value, or some combination of all three. This gives unifyDB the ability to function as a document store (looking up the “documents”, i.e. entities, which have attributes and values matching some pattern); or as a column-oriented database, looking for all the values of a certain attribute or even all the attributes that have a certain value. Of course, most apps will use a combination of all these different querying approaches, letting the database work for them in whatever way they need for a particular feature.

In fact, this is only half of the query engine, since it also supports adding ◊em{rules} that let you compute new facts from existing facts in the database, but that is complex enough to warrant its own post.

There is a lot more I could write about here, but this is running kind of long so I’m going to leave it at this for now. You can follow the development of unifyDB ◊link[#:href "https://github.com/unifydb/unifydb/" #:target "_blank"]{on GitHub} (the query engine is implemented ◊link[#:href "https://github.com/unifydb/unifydb/blob/master/src/unifydb/query.clj" #:target "_blank"]{here} and unification is implemented ◊link[#:href "https://github.com/unifydb/unifydb/blob/master/src/unifydb/unify.clj" #:target "_blank"]{here}). If you are interested in this topic and want to dive into the implementation, I based my work on the excellent logical database engine in ◊link[#:href "https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-29.html#%_sec_4.4" #:target "_blank"]{chapter 4.4 of Structure and Interpretation of Computer Programs}.

As always, if you want to know more about unifyDB, have questions about this post or just want to geek out, hit me up ◊link[#:href "https://twitter.com/jeremydormitzer" #:target "_blank"]{on Twitter}.