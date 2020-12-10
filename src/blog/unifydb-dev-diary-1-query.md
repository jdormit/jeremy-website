---
title: "unifyDB Dev Diary 1: the query system"
author: Jeremy Dormitzer
published: 2020-10-03
---
This is the first development diary for the database I'm writing, [unifyDB](https://github.com/unifydb/unifydb). I wrote a brief introduction to the project [here](https://jeremydormitzer.com/blog/unifydb-dev-diary-0-intro.html). In this post I'm going to talk about unifyDB's query system: what it does and how it works.

I want to start with an example of a unifyDB query, but to understand that we need to understand a bit about how unifyDB represents data. All data in unifyDB is stored as a collection of facts. A fact is a tuple with three pieces of information: an entity ID, an attribute name, and a value (actually, a fact has two additional fields, a transaction ID and an `added?` flag, but we won't worry about those until we talk about time-traveling queries, which deserves its own blog post). For example, we might represent some user records with the following set of facts:

```
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
```

This corresponds with the following records in a more conventional JSON format:

```json
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
        "preferred-theme": "dark"
    }
]
```

(The astute reader will notice that there’s not actually a way to specify using a set of facts that `"role"` is a list but `"preferred-theme"` is a scalar value, i.e. the cardinality of an attribute. This requires another database feature, attribute schemas, that I’m going to save for another blog post.)

With that under our belt, let's take a look at an example unifyDB query. The unifyDB server understands query written in [extensible data notation](https://github.com/edn-format/edn), but database clients for different programming languages will allow developers to write queries that feel native to that language. Here's a query in EDN format:

```clojure
{:find [?username]
 :where [[?e :preferred-theme "light"]
         [?e :username ?username]]}
```

This query says, “find me the values of all the `username` attributes of entities whose `preferred-theme` is `"light"`”. If we run this query on the set of facts given above, it would return:

```clojure
[["harry"]
 ["dumbledore"]]
```

Note that the return value is a list of lists —  although our query only asked for one field, `username`, it could have asked for more, in which case each result in the result list would be a list with all the requested values. Once again, although unifyDB itself returns data in EDN format, client libraries will wrap that return value in whatever native data structure is convenient.

Let’s break that query down a bit. First, a bit of notation: any symbol that starts with a `?` is called a variable, and is similar in spirit to a variable in a programming language. The query above has two major pieces: a `:find` clause and a `:where` clause. The `:find` clause is straightforward: it asks to find the value of the variable `?username`. But how does it know what value that variable has? That’s where things get interesting.

Let's take a closer look at the `:where` clause:

```clojure
:where [[?e :preferred-theme "light"]
        [?e :username ?username]]
```

It is a list of two relations - that is, expressions which assert some relationship between variables. The first relation, `[?e :preferred-theme "light"]`, declares that there is some entity `?e` whose `:preferred-theme` attribute has value `"light"`. The second relation is slightly more abstract, declaring a relation between some entity `?e` and the value of its `:username` attribute, which it assigns to the variable `?username`.

Notice that both relations share a variable, `?e`. This is where the magic happens! When two relations share a variable, they are said to *unify*. This means that the query engine finds all facts that satisfy *both* relations for some entity `?e`. In other words, unifyDB will find all sets of facts such that the facts share an entity `?e`, have one fact with attribute `:preferred-theme` and value `"light"`, and have another fact with attribute `:username` and any value.

The result of this unification process is a set of variable bindings, calculated from the facts that satisfy the query relation. In our example, we find that the following set of facts satisfies the query relation:

```
(1, "username", "harry")
(1, "preferred-theme", "light")
(2, "username", "dumbledore")
(2, "preferred-theme", "light")
```

Unifying these facts with the variables in the `:where` clause yields the following set of bindings:

```
{
    ?e: 1,
    ?username: "harry"
},
{
    ?e: 2,
    ?username: "dumbledore"
}
```

Finally, since our `:find` clause asks only for the variable `?username`, we look up that variable in the binding set, returning one result for each binding in the set:

```clojure
[["harry"]
 ["dumbledore"]]
```

This unification approach to querying makes the database particularly powerful. Although in this example we unified on the entity ID, we can also unify on the attribute name, value, or some combination of all three. This gives unifyDB the ability to function as a document store (looking up the “documents”, i.e. entities, which have attributes and values matching some pattern); or as a column-oriented database, looking for all the values of a certain attribute or even all the attributes that have a certain value. Of course, most apps will use a combination of all these different querying approaches, letting the database work for them in whatever way they need for a particular feature.

In fact, this is only half of the query engine, since it also supports adding *rules* that let you compute new facts from existing facts in the database, but that is complex enough to warrant its own post.

There is a lot more I could write about here, but this is running kind of long so I’m going to leave it at this for now. You can follow the development of unifyDB [on GitHub](https://github.com/unifydb/unifydb/) (the query engine is implemented [here](https://github.com/unifydb/unifydb/blob/master/src/unifydb/query.clj) and unification is implemented [here](https://github.com/unifydb/unifydb/blob/master/src/unifydb/unify.clj)). If you are interested in this topic and want to dive into the implementation, I based my work on the excellent logical database engine in [chapter 4.4 of Structure and Interpretation of Computer Programs](https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-29.html#%_sec_4.4).

As always, if you want to know more about unifyDB, have questions about this post or just want to geek out, hit me up [on Twitter](https://twitter.com/jeremydormitzer).
