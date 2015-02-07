Will Caltrain Suck Today?
=========================

Originally [a slight fork](https://github.com/edanaher/willcaltrainsucktoday-js) of [isthereagiantsgametoday](http://isthereagiantsgametoday.com/) based on a silly tweet, eventually rewritten in [Ur/Web](http://www.impredicative.com/ur/) as a learning experience and to add Sharks games (many months) after a Facebook request.

I no longer ride Caltrain, and only ever did reverse-commute so am not quite sure how accurate these judgments are: do 1:00 Giants games cause the Southbound afternoon commute to suck?  What effect do Sharks games have?  Apparently some, but I don't know when/which way.  If you have this information, feel free to submit a pull request, file an issue, or use the contact link from [the page itself](http://wilcaltrainsucktoday.com)

You can also check another day by going to [willcaltrainsucktoday.com/on/2015/04/03]() or similar.  (Incidentally, I believe that's the only "VERY" bad day in 2015.)

Random notes
------------

Yeah, Ur/web is obscure.  But it looks good, and I've been wanting to use it for a while.  And it lets me do server-side page generation (avoiding the annoying multi-round-trip javascript of the original, and working on browsers without javascript) with basically no CPU/RAM, which is nice since I'm hosting it on a tiny VPS.

And the contact link has a timestamp.  This will make it trivial to block if it gets picked up by spambots, as e-mails always do.

TODO
----

- An option to show a given day without typing in the URL
- Break out southbound/northbound/morning/afternoon as appropriate given better information.
- Add preferences to only show relevant information (e.g., commute/reverse commute care about different segments)
- Add event submission form for one-off events (e.g., Giants parade)
