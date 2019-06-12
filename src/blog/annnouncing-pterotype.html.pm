#lang pollen

◊(define-meta title "Announcing Pterotype")
◊(define-meta published "2018-11-15")

◊header-image[#:src "/images/pterotype.png"]

In @link[#:href "https://jeremydormitzer.com/blog/what-is-activitypub.html"]{my last post}, I wrote about an emerging web standard called ActivityPub that lets web services interoperate and form a federated, open social network. I made an argument about how important this new standard is – how it tears down walled gardens, discourages monopolies and centralization, and encourages user freedom.

I genuinely believe what I wrote, too. And so, to put my money where my mouth is, I’m excited to announce @link[#:href "https://getpterotype.com/"]{Pterotype}! It’s a WordPress plugin that gives your blog an ActivityPub feed so that it can take advantage of all the benefits ActivityPub has to offer. 

◊heading{Why WordPress?}

My mission is to open up the entire internet. I want every website, every social network, and every blog to be a part of the Fediverse. And WordPress @link[#:href "https://w3techs.com/technologies/overview/content_management/all"]{runs literally 30% of the internet}. It’s not my favorite piece of software, and I certainly never expected to write any PHP, but the fact is that writing a WordPress plugin is the highest-impact way to grow the Fediverse the fastest.

◊heading{So wait, what does this actually do?}

Great question, glad you asked. Pterotype makes your blog look like a Mastodon/Pleroma/whatever account to users on those platforms. So, if you install Pterotype on your blog, Mastodon users will be able to search for ◊code{blog@yourawesomesite.com} in Mastodon and see your blog as if it was a Mastodon user. If they follow your blog within Mastodon (or Pleroma, or…), your new posts will show up in their home feed. This is what I meant in my last post about ActivityPub making sites first-class citizens in social networks – you don’t need a Mastodon account to make this work, and your content will show up in any service that implements ActivityPub without you needing an account on those platforms either.

Here’s what this blog looks like from Mastodon:

◊image[#:src "/images/jeremy-mastodon.png"]

The plugin also syncs up comments between WordPress and the Fediverse. Replies from Mastodon et. al on your posts will show as WordPress comments, and comments from WordPress will show up as replies in the Fediverse. This is what I meant about tearing down walled gardens: people can comment on your blog posts using the platform of their choice, instead of being limited by the platform hosting the content.

◊heading{Sounds amazing! Can I use it now?}

Yes, with caveats. Pterotype is in early beta. The core features are in there – your blog will get a Fediverse profile, posts will federate, and comments will sync up – but it’s a pretty fiddly (and sometimes buggy) experience at the moment. If you do want to try it out, the plugin is in the @link[#:href "https://wordpress.org/plugins/pterotype/"]{plugin repository}. If you install it on your blog, please consider @link[#:href "https://getpterotype.com/beta"]{signing up for the beta program} as well – it’s how I’m collecting feedback and bug reports so I can make the plugin the best that it can be.

If you’d rather just follow my progress and dive in when it’s finished, that’s fine too! I made my development roadmap @link[#:href "https://getpterotype.com/roadmap"]{publicly available}, and the plugin itself is open-source @link[#:href "https://github.com/pterotype-project/pterotype"]{on GitHub}. I’m currently doing a major refactor, pulling out all of the ActivityPub-related logic @link[#:href "https://github.com/pterotype-project/activitypub-php"]{into its own library} – once that’s done, it’ll be back to business as usual adding features and stability to Pterotype.

If you’ve read this far, and this project resonates with you, then you might be interested in @link[#:href "https://www.patreon.com/pterotype"]{becoming a sponsor on Patreon}. Pterotype is free and open-source, so this is its only source of funding. For moment-to-moment updates, you can @link[#:href "https://mastodon.technology/@jdormit"]{follow me on Mastodon}.

See you on the Fediverse!

◊(define-meta tags '("activitypub" "fediverse" "pterotype" "wordpress"))