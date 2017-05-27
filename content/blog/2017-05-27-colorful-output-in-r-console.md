---
title: Colorful Output in R Console
author: Romain François
date: '2017-05-27'
slug: colorful-output-in-r-console
categories: []
tags:
  - R
  - crayon
  - colformat
  - rstudio
banner: "img/banners/retro-r-logo-pixelized.png"
---

Typical saturday morning, so I make [pain perdu](https://fr.wikipedia.org/wiki/Pain_perdu) from 
this week's bread leftovers to make up for the `FOMO` related to the `#runconf17` 
hashtag on twitter. 

{{< instagram BUlodEuAwog >}}

As every year, [ROpenSci's unconf](http://unconf17.ropensci.org) looks amazing, and it 
definitely looks like a lot went on if I believe the tweetstorm. One particular tweet that caught my attention was this tweet about the 
[available package](https://github.com/ropenscilabs/available). 

{{< tweet 868275628776148992 >}}

Sounds like a nice implementation of a cool idea. But that's not what woke me up, as 
I already had seen mentions of `available`. What surprised me was the use of color in the 
rstudio console output. It could only mean one thing, rstudio now supports colored outputs
we this far could only used on capable terminals through the 
[`crayon`](https://github.com/gaborcsardi/crayon) package, and indeed here's the 
relevant extract of [the NEWS.md file](https://github.com/rstudio/rstudio/blob/master/NEWS.md)

<img src="/img/rstudio-colored-output.png" width="100%" />

For this to work for me, I had to download a <a href="https://dailies.rstudio.com">daily build</a>
of rstudio, update the [`rstudioapi`](https://github.com/rstudio/rstudioapi) and 
[`crayon`](https://github.com/gaborcsardi/crayon) packages, and then I could enjoy 
some color: 

<img src="/img/crayon.png" width="100%" />

This is not a new interest to me, I played with color on the terminal back in 
[2009](/blog/2009/04/18/colorful-terminal--the-r-package--xterm256/) with the `xterm256` package. 

<a href="/blog/2009/04/18/colorful-terminal--the-r-package--xterm256/">
  <img src="/public/posts/xterm256/lef-2.png" width="100%" />
</a>


but having this
supported in rstudio is opening another kind of Pandora's box. I feel like my parents
when colour first appeared on television. 

{{< youtube _cabEkOqgFY >}}

... but with more exciting content. Unsurprisingly Hadley is already using this, and his 
[`colformat`](https://github.com/hadley/colformat) package looks promising. 

![](/img/colformat.png)




