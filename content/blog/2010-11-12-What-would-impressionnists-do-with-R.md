---
title:   What would impressionnists do with R ?
author: "Romain François"
date:  2010-11-12
slug:  What-would-impressionnists-do-with-R
tags:  [ "images", "R" ]
---
<div class="post-content">
<p>I've been playing with images recently, probably inspired from my trip in San Francisco. There was an <a href="http://deyoung.famsf.org/orsay">exhibit</a> at the <a href="http://deyoung.famsf.org/">De Young museum of fine arts</a> with pieces borrowed from the <a href="http://www.musee-orsay.fr/en/home.html">Musée d'Orsay</a>. I did not go to the exhibit because it is easy enough for me to just go to Paris and the Musée d'Orsay, but I guess this somewhat inspired me, along with the golden gate bridge, to do some <a href="http://www.r-project.org">R</a><a></a> based impressionnism</p>

<p>The starting point is this picture of the golden gate bridge</p>

<a href="/public/posts/goldengate/goldengate.png"><img src="/public/posts/goldengate/goldengate_m.jpg" alt="goldengate.png" style="margin: 0 auto; display: block;" title="goldengate.png, nov. 2010"></a>

<p>The <a href="http://rforge.net/png/">png package</a> makes it straightforward to import png pictures into R (There are other ways as well).</p>

<p>Then, I generate randomly spaced circles so that they don't overlap, and fill each circle with the average color (on the RGB space) of all te pixels that are inside the circle</p>

<table border="1px solid black">
<tr>
<td>
<img src="/public/posts/goldengate/circles-1_m.jpg" alt="circles-1.png" style="margin: 0 auto; display: block;" title="circles-1.png, nov. 2010" width="250px">
</td>
<td>
<img src="/public/posts/goldengate/circles-2_m.jpg" alt="circles-2.png" style="margin: 0 auto; display: block;" title="circles-2.png, nov. 2010" width="250px">
</td>
</tr>
<tr>
<td>
<img src="/public/posts/goldengate/circles-3_m.jpg" alt="circles-3.png" style="margin: 0 auto; display: block;" title="circles-3.png, nov. 2010" width="250px">
</td>
<td>
<img src="/public/posts/goldengate/circles-4_m.jpg" alt="circles-4.png" style="margin: 0 auto; display: block;" title="circles-4.png, nov. 2010" width="250px">
</td>
</tr>
</table>
<p>Then I do this many times, with translucent circles, and after some iterations ,the golden gate bridge starts to reveal itself</p>

<a href="/public/posts/goldengate/goldengate-circles.png"><img src="/public/posts/goldengate/goldengate-circles_m.jpg" alt="goldengate-circles.png" style="margin: 0 auto; display: block;" title="goldengate-circles.png, nov. 2010"></a>

<p>The code for this is included below</p>

<iframe width="500" height="500" src="/public/posts/goldengate/goldengate.html"></iframe>

<p>Here are other examples

</p>
<p>
<a href="/public/posts/goldengate/google-circles.png"><img src="/public/posts/goldengate/google-circles_m.jpg" alt="google-circles.png" style="margin: 0 auto; display: block;" title="google-circles.png, nov. 2010"></a>
</p>

<p>
<a href="/public/posts/goldengate/apple-circles.png"><img src="/public/posts/goldengate/apple-circles_m.jpg" alt="apple-circles.png" style="margin: 0 auto; display: block;" title="apple-circles.png, nov. 2010"></a>
</p>
</div>
