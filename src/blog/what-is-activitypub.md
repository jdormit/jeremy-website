---
title: What is ActivityPub, and how will it change the internet?
author: Jeremy Dormitzer
published: 2018-09-15
---
<img alt="a network-shaped board game" src="/images/board-game.jpg" />

## A new kind of social network

There’s a new social network in town. It’s called [Mastodon](https://joinmastodon.org/). You might have even heard of it. On the surface, Mastodon feels a lot like Twitter: you post “toots” up to 500 characters; you follow other users who say interesting things; you can favorite a toot or re-post it to your own followers. But Mastodon is different from Twitter in some fundamental ways. It offers many more ways for users to control the posts they see. It fosters awareness of the effect your posts have on others through a content warning system and encourages accessibility with captioned images. At its core, though, there’s a more fundamental difference from existing social networks: Mastodon isn’t controlled by a single corporation. Anyone can operate a Mastodon server, and users on any server can interact with users on any other Mastodon server.

This decentralized model is called federation. Email is a good analogy here: I can have a Gmail account and you can have an Outlook account, but we can still send mail to each other. In the same way, I can have an account on [mastodon.technology](https://mastodon.technology/invite/JguyVqcL), and you can have an account on [mastodon.social](https://mastodon.social/), but we can still follow each other, like and re-post each other’s toots, and @mention each other. Just like Gmail servers know how to talk to Outlook servers, Mastodon servers know how to talk to other Mastodon servers (if you hear people talking about a Mastodon “instance”, they mean server). And just like Gmail and Outlook are controlled by different corporations, Mastodon servers are owned and operated by many different people and organizations. If you wanted, you could [host your own Mastodon instance](https://github.com/tootsuite/documentation#running-mastodon)!

Why does this matter? It means that Mastodon users have choice about where they hang out online. If Twitter decides that your posts shouldn’t be on their platform, they can shut down your account and there’s nothing you can do about it (or conversely, if they decide your f-ed up content is totally fine, there’s nothing anyone else can do about it). On the other hand, if you disagree with the administrators of your Mastodon instance, you have the choice to move your account to another instance (switching providers, as it were) or to host your own instance if you’re willing to dedicate the time and effort.

The federated model also tends to align incentives better than centralized alternatives. Mastodon instances are usually run and moderated by members of the community that uses that particular Mastodon server – for example, I’m part of a community of tech folks over at [mastodon.technology](https://mastodon.technology/invite/JguyVqcL), and our server is administrated and moderated by a member of the community. He has a vested interest in making mastodon.technology a nice place to hang out since he hangs out there too. Contrast that with Twitter: Twitter is owned and operated by a massive, venture-backed, for-profit corporation. Now, I’m certainly not against companies making money (more on that later), but Twitter only cares about making Twitter a nice place to hang out to the extent that they profit by it, which has led them to make [some user-unfriendly choices](http://www.slate.com/articles/technology/cover_story/2017/03/twitter_s_timeline_algorithm_and_its_effect_on_us_explained.html).

So Mastodon is pretty cool. But that’s not what really gets me excited. I’m excited about how Mastodon servers allow users on different instances to interact. It’s a protocol called [ActivityPub](https://activitypub.rocks/), and it’s going to change the way the internet works. 

## ActivityPub

ActivityPub is a social networking protocol. Think of it as a language that describes social networks: the nouns are users and posts, and the verbs are like, follow, share, create… ActivityPub gives applications a shared vocabulary that they can use to communicate with each other. If a server implements ActivityPub, it can publish posts that any other server that implements ActivityPub knows how to share, like and reply to. It can also share, like, or reply to posts from other servers that speak ActivityPub on behalf of its users.

This is how Mastodon instances let users interact with users on other instances: because every Mastodon instance implements ActivityPub, one instance knows how to interpret a post published from another instance, how to like a post from another instance, how to follow a user from another instance, etc.

ActivityPub is much bigger than just Mastodon, though. It’s a language that any application can implement. For example, there’s a YouTube clone called [PeerTube](https://joinpeertube.org/en/faq/) that also implements ActivityPub. Because it speaks the same language as Mastodon, a Mastodon user can follow a PeerTube user. If the PeerTube user posts a new video, it will show up in the Mastodon user’s feed. The Mastodon user can comment on the PeerTube video directly from Mastodon. Think about that for a second. Any app that implements ActivityPub becomes part of a massive social network, one that conserves user choice and tears down walled gardens. Imagine if you could log into Facebook and see posts from your friends on Instagram and Twitter, without needing an Instagram or Twitter account.

So here’s how ActivityPub is going to change the internet: 

## No more walled gardens

ActivityPub separates content from platform. Posts from one platform propagate to other platforms, and users don’t need to make separate accounts on every platform that they want to use. This has an additional benefit: since your ActivityPub identity (your Mastodon account, your PeerTube account, etc.) is valid across all ActivityPub-compliant applications, it serves as a much stronger identity signal, preventing malicious actors from impersonating you (e.g. creating a Twitter account in your name). If you can share one account across multiple platforms, no one can pretend to be you on those platforms – you are already there!

## Social networking comes built-in

With traditional internet media, you need to rely on external services to share your work on social networks. If you want people to share your YouTube video around, you need to post it to Facebook or Twitter. But ActvityPub-enabled applications are social by nature. A PeerTube video can be shared or liked by default by users on Mastodon. A Plume blogger can build an audience on Mastodon or PeerTube without any additional effort since Mastodon and PeerTube users can follow Plume blogs natively. Users on all these platforms see content from the other apps on the platform of their choice. And Mastodon, PeerTube, and Plume are just the beginning – as more platforms begin implementing ActivityPub, the federated network grows exponentially.

## Network effects that help users instead of harming them

“Network effects” leaves kind of a dirty taste in my mouth. It’s usually used as a euphemism for “vendor lock-in”; the reason that Facebook became such a giant was that everyone needed to be on Facebook to participate in Facebook’s network. However, ActivityPub flips this equation on its head. As more platforms become ActivityPub compliant, it becomes more valuable for platforms implement ActivityPub: more apps means more users on the federated network, more posts to read and share, and more choice for users. This network effect discourages vendor lock-in. In the end, the users win.

## It’s going to be an uphill battle

I hope I’ve convinced you of the radical impact that ActivityPub could have on the internet. But there are some significant barriers preventing widespread adoption. The thorniest one is money. 

Why is money an issue? Aren’t Mastodon and PeerTube free and open-source? Well, first of all, open source projects need funding too (that’s a big topic that deserves its own blog post, so I’m leaving it alone for now). The bigger issue right now is user adoption. The ActivityPub network is only viable if people use it, and to compete in any significant way with Facebook and Twitter we need a lot of people to use it. To compete with the big guys, we need big money. We need to be able to spread the word through marketing and blogging, to engineer new ActivityPub applications, and to support people working full-time on bringing about this revolution.

I know this isn’t necessarily a popular view in the open-source world, but I see funding as a critical priority to bring about the vision that ActivityPub promises. Unfortunately, it’s not clear how to obtain it.

All the major ActivityPub-compliant applications I’ve written about are open source projects, built and run by volunteers with [tiny budgets](https://www.patreon.com/mastodon). Traditional social networking companies like Twitter and Facebook are funded by selling advertisements on their platform. But in order to make any significant revenue from ads, you need a centralized audience whose attention you control. Facebook needs to be able to say, “we have X billion users; give us your money and we will show them your ads”. Plus, the big social companies extract value from their users by segmenting them based on their behavior and interests, enabling micro-targeted ad campaigns.

None of that is possible when the users and content are spread across many servers and platforms. There is no centralized audience to segment and advertise to. We’ll need to rethink the fundamental business model of social networking if we want ActivityPub to take off.

That being said, I do think ActivityPub offers tremendous business value. It turns your corporate blog into a social network by offering native sharing, following, liking, and replying. And it does so on your customer’s terms, which not only prevents abusive, spammy content but also helps your company’s reputation with users and potential customers. These benefits are valuable, and I think there is a way to turn that value into funding.

It’s important to think about how to make this revolution happen. ActivityPub has the potential to change the way we think and act on the internet, in a way that encourages decentralization and puts users first again. That’s a vision worth fighting for.
