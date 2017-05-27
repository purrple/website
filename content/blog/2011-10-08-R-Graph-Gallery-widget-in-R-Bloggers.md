---
title:   R Graph Gallery widget in R Bloggers
author: "Romain François"
date:  2011-10-08
slug:  R-Graph-Gallery-widget-in-R-Bloggers
tags:  [ "R", "R Bloggers", "r graph gallery" ]
---
<div class="post-content">
<p>The <a href="http://www.r-bloggers.com/">R Bloggers</a> website, maintained by <a href="http://www.r-statistics.com/">Tal Galili</a>, aggregates blogs (including mine) from many people of the R community. </p>

<p>Tal and I have been wondering about how to tight R Bloggers with the gallery, supporting each other's website. To that extent, I've made a quick and dirty widget, using <a href="http://jquery.malsup.com/cycle/">the jquery cycle plugin</a> that is now on the right sidebar of R bloggers, inside the <b>related sites</b> box. </p>

<a href="/public/graphgallery/rbloggers.png"><img src="/public/graphgallery/rbloggers_m.jpg" alt="rbloggers.png" style="margin: 0 auto; display: block;" title="rbloggers.png, oct. 2011"></a>

<p>The widget first chooses 20 items from the gallery at random, and then cycles through them. </p>

<p>This is an initial design made specifically for R Bloggers, but it is quite likely that I will improve on this and make the widget more generic so that other website can use it to advertise for the gallery. </p>
</div>
