---
title: "State of unifyDB: 2021"
author: Jeremy Dormitzer
published: 2021-11-11
---

2021 is almost over! And it's been over a year since I've written anything about [my work-in-progress graph database unifyDB](./unifydb-dev-diary-0-intro.html). BUT just because I'm bad at blogging doesn't mean I haven't made any progress. In fact, a bunch of exciting stuff happened for unifyDB in 2021, and I'm going to info-dump it all on you 🙃.

## Aggregation, sorting and limiting
This one was really exciting, as it marked a huge step towards making unifyDB truly useful. I added the ability to aggregate, sort, and limit query results. Here's what the syntax looks like:

```clojure
{:find [?role (min ?age)]
 :where [[_ :employee/role ?role]
         [_ :employee/age ?age]]
 :sort-by [(min ?age) :desc]
 :limit 5}
```

Aggregate expressions appear in parentheses (like a function call) in the find clause - the `(min ?age)` in this example. This query will return five biggest minimum ages for every job role in a database of employee data. 

One feature of this system I'm particularly proud of is implicit grouping. Take a look at that find clause again: `[?role (min ?age)]`. We are asking for both a non-aggregated variable, `?role`, and an aggregated one `?age`. In a SQL query, we'd need to specify how construct groups of roles before we can find the minimum age of each group using a `GROUP BY` clause:

```sql
SELECT role, min(age)
FROM employees
GROUP BY role
```

The unifydDB query engine is smart enough to figure out that we need to group the result set by `role` before finding the minimum age of each group. If we add additional scalar or aggregate variables in the find clause, the query engine will automatically construct the appropriate groups such that all scalar variables have single values in each group.

## Entity-level transactions and "pull" queries
unifyDB is technically a tuplestore - that is, its core unit of data is a "fact" tuple consisting of `[entity attribute value]` pairs. An entity is therefore represented as a set of data tuples:

```clojure
[[1 :name "Ben Bitdiddle"]
 [1 :age 43]
 [1 :role "Software Engineer"]]
```

This data format makes unifyDB highly flexible, able to answer not only questions about entities ("who has the software engineer role") but also questions about attributes ("what's the median age across all employees") and values. However, this flexibility comes at a cost: most programs (and programmers!) think in terms of entities. They talk about data shaped more like this:

```clojure
{:id 1
 :name "Ben Bitdiddle"
 :age 43
 :role "Software Engineer"}
```

Requiring developers to transform entity-oriented data into fact-oriented data to fit unifyDB's internal data model imposes unnecessary cognitive load and violates one of unifyDB's core principles: meet the programmer where they are. In answer to this I added two features: entity transactions and "pull" queries.

Entity transactions allow data to enter the database in the shape of an entity map rather than as a set of facts. Here's how that looks:

```clojure
(transact! db
 [{:unifydb/id "alyssa"
   :name "Alyssa P. Hacker"
   :age 37
   :role {:title "Engineering Manager"
          :salary 60000}}
  {:unifydb/id "ben"
   :name "Ben Bitdiddle"
   :age 43
   :supervisor "alyssa"
   :role {:title "Software Engineer"
          :salary 40000}}])
```

This transaction creates four new entities in the database: two employees and two roles (note the use of temporary IDs to map relationships between entities in the transaction). This transaction would expand to a set of facts that looks like this:

```clojure
[;; Alyssa
 ["alyssa" :name "Alyssa P. Hacker"]
 ["alyssa" :age 37]
 ["alyssa" :role "role1"]
 ;; Alyssa's role
 ["role1" :title "Engineering Manager"]
 ["role1" :salary 60000]
 ;; Ben
 ["ben" :name "Ben Bitdiddle"]
 ["ben" :age 43]
 ["ben" :supervisor "alyssa"]
 ["ben" :role "role2"]
 ;; Ben's role
 ["role2" :title "software Engineer"]
 ["role2" :salary 40000]]
```

This set of facts then gets transacted into the database normally, resolving the temporary ids (`"alyssa"`, `"ben"`, `"role1"`, `"role2"`) and making the facts available to be queried. As you can see, nested entities get flattened to be their own fact sets as well. This transformation maintains the flexibility of a fact-oriented data architecture while allowing developers to think in entity-oriented terms. And of course, for data that isn't inherently entity-oriented, raw fact tuples can still be transacted as usual.

On the query side, the new "pull" feature adds a similarly entity-oriented way to make queries. This feature adds new syntax to the find clause that allows users to specify the shape of data they want to return. It's probably easiest to understand with an example:

```clojure
{:find [(pull ?e [:name :age {:role [:title :salary]}])]
 :where [[?e :name "Alyssa P. Hacker"]]}
```

Given the data used in the entity transaction example above, this query would return:

```clojure
[[{:name "Alyssa P. Hacker"
   :age 37
   :role {:title "Engineering Manager"
          :salary 60000}}]]
```

Let's pull apart the pull syntax (heh, see what I did there?). A pull query is a list of attributes to return, with nested entities represented as sub-maps within the list. So the query `(pull ?e [:name :age {:role [:title :salary]}])` is asking for the `:name` and `:age` values for some entity `?e`, as well as the `:title` and `:salary` attributes of the entity whose id is the value of `?e`'s `:role` attribute. This system effectively separates the logic of finding the entity you want (in this case "the entity with `:name` `"Alyssa P. Hacker"`") from the logic of specifying which attributes of that entity you care about. This system also returns the data in the entity-oriented format that the rest of your program is already using.

Taken together, these two new features allow unifyDB to function as a document store in addition to its existing utility as a tuplestore. That's a huge boost for its use as a general-purpose application database.

## unifyDB presentation at Boston Clojure Meetup
I gave a talk on unifyDB for the [Boston Clojure Meetup](https://www.meetup.com/Boston-Clojure-Group/)! Due to my aforementioned lack of blogging, this is now the most in-depth look at the database available. I covered a brief history of the project, gave a demo of its capabilities at the time of recording, and answered some questions about the codebase. Do note that this was recorded before I added most of the features discussed in this post, so parts of the demo are slightly out of date. But on the whole it's still a worthwhile showcase of some of unifyDB's core features.

Here's the full recording:

<iframe style="margin: auto auto 2em auto;" width="560" height="315" src="https://www.youtube-nocookie.com/embed/hqQQyxeE-4Q" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## What's next?
If you made it this far, thanks for sticking with me! I'm really excited about the improvements that came to unifyDB in 2021. But  there's still quite a bit more to do before we can consider this thing released. In no particular order:

- the other flagship feature, built-in access management. Alongside historical queries (which is already implemented), this is the key problem I'm trying to solve with unifyDB. The access management feature will allow fine-grained access control, letting engineers enforce rules like "only authorized admins can see personally-identifying customer data" without needing to write custom code
- a built-in distributed key-value store. Right now unifyDB sits on top of existing key-value stores to provide the persistence layer. Before I consider this project finished it'll need to ship with a built-in distributed persistence layer
- codebase improvements: there are a number of changes I want to make to the existing codebase. On the top of this list is fixing my usage of the [Manifold](https://github.com/clj-commons/manifold) library - it provides a nice async abstraction layer but in many places I'm turning an async call into a blocking call by unwrapping a Manifold `deferred` instead of mapping over it. I'd also like to add better error handling and more end-to-end tests

Hopefully I'll be a bit more public with my development efforts in 2022. I'll try to post more frequent (and shorter!) blog posts. I'll also be posting more actively into the [#unifydb channel](https://clojurians.zulipchat.com/#narrow/stream/295957-unifydb) on the Clojurians Zulip chat, so check that out if you want to follow my progress.
