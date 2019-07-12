#lang pollen

◊(define-meta title "More than JSON: ActivityPub and JSON-LD")
◊(define-meta published "2019-04-23")

◊blockquote{◊italic{In which our hero discovers the power of normalization and JSON-LD}}

◊heading{The problem with JSON}

I’ve been doing a lot of research for my current side project, ◊link[#:href "https://jeremydormitzer.com/blog/announcing-pterotype/"]{Pterotype}. It’s a new kind of social network built as a WordPress plugin that respects your freedom, encourages choice, and interoperates with existing social networks through the power of ◊link[#:href "https://jeremydormitzer.com/blog/what-is-activitypub-and-how-will-it-change-the-internet/"]{ActivityPub}. It’s undergone several iterations already – the beta has been out for a while now, and I’ve been working hard on a version 2 for the last several months.

One of the things I wasn’t satisfied with in the first version of Pterotype was the way it stores incoming data. ActivityPub messages are serialized in a dialect of JSON called ◊link[#:href "https://json-ld.org/"]{JSON-LD}. I didn’t really get JSON-LD when I started this project. It seems overcomplicated and confusing, and I was more interested in shipping something that worked than understanding the theoretical underpinnings of the federated web. So I just kept the incoming data in JSON format. This worked, sort of, but I kept running into annoying, hard-to-reason about situations. For example, consider this ActivityPub object, representing a new note that Sally published:

◊codeblock[#:lang "json"]{
{
  "@context": "https://www.w3.org/ns/activitystreams",
  "id": "https://example.org/activities/1",
  "type": "Create",
  "actor": {
    "type": "Person",
    "id": "https://example.org/sally",
    "name": "Sally"
  },
  "object": {
    "id": "https://example.org/notes/1",
    "type": "Note",
    "content": "This is a simple note"
  },
  "published": "2015-01-25T12:34:56Z"
}
}

The problem is that the above object, according to the ActivityPub specification, is semantically equivalent to this one:

◊codeblock[#:lang "json"]{
{
  "@context": "https://www.w3.org/ns/activitystreams",
  "id": "https://example.org/activities/1",
  "type": "Create",
  "actor": "https://example.org/sally",
  "object": "https://example.org/notes/1",
  "published": "2015-01-25T12:34:56Z"
}
}

This is the object graph in action – the ◊code{actor} and ◊code{object} properties are pointers to other objects, and as such they can either be JSON objects embedded within the ◊code{Create} activity, or URIs that dereference to the actual object (dereferencing is a fancy word for following the URI and replacing it with whatever JSON object is on the other side). Since I was representing these ActivityPub objects in this JSON format, that meant that whenever I saw an ◊code{actor} or ◊code{object} property, I always had to check whether it was an object or a URI and if it was a URI I had to dereference it to the proper object. This led to tons of annoying boilerplate and conditionals:

◊codeblock[#:lang "php"]{
if ( is_string( $activity['object'] ) ) {
    $activity['object'] = dereference_object( $activity['object'] );
}
}

Yikes. So I came up with what I thought was a clever solution: just walk the object graph and dereference every URI I found whenever I saw a new JSON object. So I would receive Sally’s ◊code{Create} activity and traverse the JSON representation of its graph, dereferencing the ◊code{actor} and ◊code{object} objects in the process. This effectively turned the second representation above into the first one. Problem solved, right?

Well, not quite. There are actually a bunch of problems with that approach. First, not all URIs in the JSON object should be dereferenced. For example, there is an ActivityPub attribute called ◊code{url} that is – you guessed it – a URL! And it is supposed to stay a URL, not get dereferenced to some other thing. Okay, so I’ll only dereference URIs that belong to attributes I know should contain references to other objects – ◊code{actor}, ◊code{object}, etc. But there’s still a problem! There’s no guarantee that we’ll be able to successfully dereference a URI. Maybe the server that was hosting that object went down. Maybe there’s a temporary network failure. Maybe it’s the year 3000 and bitrot has taken down 80% of the internet. The point is, even if we preemptively dereference all the URIs we can, we still need to handle the case where we couldn’t access the actual object and are stuck with the URI. Which means we still need those stupid conditionals everywhere!

◊heading{JSON-LD to the rescue}

So what’s the actual solution for this? Well, as it turns out these were exactly the types of issues that JSON-LD is designed to solve. JSON-LD provides a way to normalize data into a standard form based on a ◊italic{context} that defines a schema for the data. Here’s the second version of Sally’s activity from above after undergoing JSON-LD expansion:

◊codeblock[#:lang "json"]{
[
  {
    "https://www.w3.org/ns/activitystreams#actor": [
      {
        "@id": "https://example.org/sally"
      }
    ],
    "@id": "https://example.org/activities/1",
    "https://www.w3.org/ns/activitystreams#object": [
      {
        "@id": "https://example.org/notes/1"
      }
    ],
    "https://www.w3.org/ns/activitystreams#published": [
      {
        "@type": "http://www.w3.org/2001/XMLSchema#dateTime",
        "@value": "2015-01-25T12:34:56Z"
      }
    ],
    "@type": [
      "https://www.w3.org/ns/activitystreams#Create"
    ]
  }
]
}

So what’s up with those weird URL-looking attributes? And why has everything become an array?

The expansion algorithm has normalized the data into a form that is supposed to be universally normalized. The attributes – ◊code{object}, ◊code{actor}, etc. – have become URIs with a universal meaning and a known schema. In other words, any application that speaks JSON-LD knows what an ◊code{https://www.w3.org/ns/activitystreams#actor} is, even if they don’t know what an actor is.

Importantly for our purposes, take a look at what the ◊code{object} field has turned into. We went from:

◊codeblock[#:lang "json"]{
"object": "https://example.org/notes/1"
}

To:

◊codeblock[#:lang "json"]{
"https://www.w3.org/ns/activitystreams#object": [
  {
    "@id": "https://example.org/notes/1"
  }
]
}

Because the object attribute is specified in the ◊link[#:href "https://www.w3.org/ns/activitystreams.jsonld"]{ActivityStreams JSON-LD vocabulary} to be of ◊code{@type}: ◊code{@id}, the expansion process was able to infer that ◊code{object} ought to be, well, an object. This neatly solves the problem of “is this string attribute actually a reference” – all references are clearly marked by their ◊code{@id} attributes now. Plus, this allows us to be smarter about when we dereference an object – for example, we can defer dereferencing until we actually need to access the attributes of the linked object. This approach also addresses the problem of network errors when dereferencing – if we can’t dereference, we just end up with an object that has only an ◊code{@id}, which can still be handled gracefully by the application.

Hopefully this gave some insight into the types of challenges involved with building ActivityPub-powered applications and the point of JSON-LD. Have questions? Did I do something wrong? Let me know in the comments or on the ◊link[#:href "https://mastodon.technology/@jdormit"]{Fediverse}!