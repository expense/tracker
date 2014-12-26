
Hacker-Friendly Expense Tracking App!
=====================================

This is my expense tracker.

I used it privately until I showed it to my colleague.
He said that it'd be a good idea to publicize it, so here it is.

But however, the current state of the code is very ugly.
Fork with care, because it may get radical breaking change in the near future,
and you may have to migrate your data over.


Idea
----

You know, programmers are lazy.

I tried to track my expense.
At first, I used a Numbers "personal budget" template,
However, it's a hassle to keep them in sync on iCloud,
since connectivity isn't so good.
I usually get things like "Damn, they're both modified! Choose one to keep."
Anyway, I successfully used it for two months.

I also tried creating a full-fledged expense tracker,
but then I gave up.


### A Web Service

Then this idea dawned on my mind.
As a programmer, I like to write more than being asked!

I prefer to do this:

```
100F
```

Rather than do this:

```
Amount:    100
Category:  F
Date:      2014 12 25
Time:      11 12
Comment:

[Save]   [Cancel]
```


So I decided to create an expense tracking chat bot.
I wrote them in two separate projects.

- A web service that receives chat messages, translates them into commands,
  stores them in the database, and returns a text response (this project).
- A chat bot that passes messages between chat client and the web service.

This makes it possible to experiment with multiple chat clients and/or user
interfaces. So far, I tried these (they are not published yet):

- XMPP client to a bot account on Google Hangouts
    - Didn't work, because I don't use Google Hangouts much. Too lazy to open it.
    - It is responding very slowly too!
- Flowdock client.
    - I also became lazy at opening the Flowdock app. It boot slowly.
* Facebook chat client (using the same XMPP code to chat.facebook.com).
    - I use Facebook often, so it helps, especially with the chat heads.
    - But I still get lazy.
- A custom made chat client written using PhoneGap that talks directly to the web service.
    - I became lazy.
- A GUI application that lets me type number, pick category, and time, and converts that into commands. Also talks directly to the web service.
    - I also became lazy. Also, as I said before, in the end I don't like using GUIs.

The next thing I'll try to implement is:

- A chat client with a smart, context-aware keyboard.
    - However, because of the current command grammar, this is impossible to implement.
    - Therefore, I will have to revamp the whole command interface.

I also discussed with my colleague, here are some more ideas:

- Write an iPhone Today widget or Android Lock Screen Widget
- Send an email with command to myself.
- Embed an expense tracking application into a calculator or something.

For me, my conclusion is this: __there is no end to programmer laziness__.


Setting Up
----------

Just push the thing to Heroku, then:

    heroku config:set API_KEY=makeSomethingRandomHereAndKeepItSecret

If you don't do this, __UR APP NO HAS SECURITYZ!!!!11__


Usage
-----

* Go to /chat to chat with the bot
* Go to /items to bring up the rails scaffold
* Go to /stats to see a stats visualization with stupid react app


Chat Commands
-------------

Read the specs!










