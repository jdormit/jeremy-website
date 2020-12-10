---
title: "unifyDB Dev Diary 0: I’m building a database!"
author: Jeremy Dormitzer
published: 2020-08-09
---
Phew, it’s been a while! Over a year, in fact. And what a wild year! Lots of good things happened: I got married, got a new job that I love, moved to a nice new apartment. Also some not-so-nice things, but since you are all living through 2020 just like me I don’t think I need to go into those. But I have still found some side-project time, and I’d like to start talking about what I’m building.

So – I’m excited to announce that I’m building a database! I’m calling it unifyDB. It’s going to be a general-purpose database with some pretty interesting properties:

- It maintains a complete history of changes to all entities stored in the database
- You can make queries for historical data, e.g. “what did this user record look like last Tuesday?”
- Arbitrary metadata can be attached to transactions – for example, you can add an application user ID to every transaction your app makes
- Fine-grained access control is built into the database, allowing developers to limit access to particular attributes across all entities

This is the database that I’ve always wanted – basically, I’m tired of being in meetings where the boss says “who changed this user’s email address?” and everyone just looks at each other and shrugs.

I’m designing unifyDB to be as modular as possible – I want it to be as easy to run it as a single node on your local machine as it is to run in an autoscaling cluster on your cloud of choice.

I’ve actually been working on this on and off for over a year. The code lives in [a GitHub repository](https://github.com/unifydb/unifydb). Fair warning: it’s mostly undocumented and nowhere close to being finished. So far, I’ve written the query engine, the transaction handler, the web server (yes, it has an HTTP interface), and a bunch of underlying infrastructure. So as it currently stands, unifyDB is able to store data (in-memory since I haven’t built the storage layer yet) and issue history-aware queries. I’m in the middle of writing the authentication mechanism. After that, it’s on to the storage layer, then most likely the access control layer.

I’m going to start publishing monthly development diaries detailing the more interesting aspects of database. I’ll start with a post about the query system implementation sometime in the next couple of weeks. Sound interesting? Follow along [on Feedly](https://feedly.com/i/subscription/feed%2Fhttps%3A%2F%2Fjeremydormitzer.com%2Fblog%2Ffeed.xml) or [your RSS reader of choice](https://jeremydormitzer.com/blog/feed.xml)!.

In the meantime, if you want to know more about unifyDB or just want to geek out, hit me up [on Twitter](https://twitter.com/jeremydormitzer).
