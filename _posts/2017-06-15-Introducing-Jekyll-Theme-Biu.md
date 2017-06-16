---
layout: post
title:  'Introducing Jekyll theme "Biu"'
date:   2017-06-15 16:09:11 +0800
---

Link: https://github.com/RedL0tus/Biu-Jekyll-Theme  
License: MIT


Yes, this is the theme this blog is using.

It's a fork of [Alex Carpenter](https://github.com/alexcarpenter)'s [Butane-jekyll-theme](https://github.com/alexcarpenter/butane-jekyll-theme).

It looks quite same but with several difference:

1. Changed fonts to Inconsolata ([All hail monospaced fonts!](https://github.com/RedL0tus/Biu-Jekyll-Theme/commit/6d08203aefdb36e7f172d1a15dc47b5df89cde96)).
2. Modified headers in post pages.
3. Modified footers.
4. Add Google Analytics support
5. Add Structured Data support.
6. Add Accelerated Mobile Pages support.
7. Add a random fortune at footer.

P.S. There are some slight difference between the version in the theme's repo and the version I'm using right now. Such as Service Worker and Progressive Web APP's manifest. That's because the service worker I'm using right now is written by others :)

How to deploy:  

    $ git clone https://github.com/RedL0tus/Biu-Jekyll-Theme.git  
    $ cd Biu-Jekyll-Theme  
    $ rm -rf CHANGELOG.md README.md
    $ nano  _config.yml #Or any other editor you prefer   
    $ jekyll serve # Please deploy Jekyll first.  