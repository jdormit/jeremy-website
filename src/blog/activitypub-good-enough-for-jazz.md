---
title: "ActivityPub: Good enough for jazz"
author: Jeremy Dormitzer
published: 2019-01-07
---
<img alt="activitypub" src="/images/activitypub.png" />

[Kaniini](https://pleroma.site/users/kaniini), one of the lead developers of Pleroma, recently published a blog post called [ActivityPub: The “Worse is Better” Approach to Federated Social Networking](https://blog.dereferenced.org/activitypub-the-worse-is-better-approach-to-federated-social-networking). It’s a critique of the security and safety of the [ActivityPub protocol](https://jeremydormitzer.com/blog/what-is-activitypub-and-how-will-it-change-the-internet/). They make some good points:

- ActivityPub doesn’t support fine-grained access control checks, e.g. I want someone to be able to see my posts but not respond to them
- Instances you’ve banned can still see threads from your instance in some ActivityPub implementations, because someone from a third instance replies to the thread and that reply reaches the banned instance

The post also generated an [interesting Fediverse thread](https://playvicious.social/@Are0h/101372851868909058) discussing the tradeoffs between proliferating the existing protocol versus making changes to it, and whether it would be possible to improve the protocol without breaking backward compatibility. It’s worth a read.

Here’s the thing: ActivityPub is a protocol, and protocols are only valuable as long as there is software out there actually using the protocol. At the end of the day, that’s the most important measure of success. Don’t get me wrong – protocols need to do the job they set out to do well. But at some point, the protocol works well enough that it becomes more important to foster adoption than to continue improving. I believe that ActivityPub has reached that point.

Now, I’m not suggesting that we stop development on the protocol. But future improvements to it should be iterative, building on the existing specification, and backward compatible whenever possible. For example, by all means let’s come up with a better access control model for ActivityPub – but we should also come up with a compatibility layer that assumes some default set of access capabilities for implementations that haven’t upgraded. This lets us move forward without leaving the protocol’s participants behind, preserving ActivityPub’s value.

We are in good company here. This model is exactly how HTTP became the protocol that powers the internet. If you have the time, check out this [excellent (brief) history](https://hpbn.co/brief-history-of-http/) of the HTTP protocol. Here are the highlights: Tim Berners-Lee came up with HTTP 0.9, which was an extremely simple protocol that allowed clients to request a resource and receive a response. HTTP 1.0 added headers and a variety of other features. HTTP 1.1 added performance optimizations and fixed ambiguities in the 1.0 specification.

Critically, all of these versions of HTTP were similar enough that a server that supported HTTP 1.1 could trivially also support HTTP 1.0 and 0.9 (because 0.9 is actually a subset of 1.1). In fact, the Apache and Nginx web servers, which power most websites on the internet, still support HTTP 0.9! By designing and iterating on HTTP in a way that preserved backward compatibility, the early web pioneers were able to build a robust, performant, secure protocol while still encouraging global adoption.

If we want the Fediverse to be just as robust, performant, secure, and globally adopted, we should take the same approach.
