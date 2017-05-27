---
title:   RGG-153- stars network
author: "Romain François"
date:  2009-07-03
slug:  RGG153--stars-network
tags:  [ "graphgallery", "graphics", "R" ]
---
<div class="post-content">
<p>Graham Williams sent me this graph, now item <a href="http://addictedtor.free.fr/graphiques/RGraphGallery.php?graph=153">153</a> in the graph gallery.</p>

<a href="http://addictedtor.free.fr/graphiques/RGraphGallery.php?graph=153">
<img src="/public/posts/graphgallery/graph_153_m.jpg" alt="graph_153.png" style="margin: 0 auto; display: block;" title="graph_153.png, juil. 2009"></a>

<p><i>This plot draws a network but at the nodes we have simple segment plots (and in general we might have any other kind of plot at the nodes). This code constructs a network (from the network package), plots it with the nodes being invisibly plotted (using plot.network from the sna package) and then overlays the segment plots using the star function (with the key being located at a position determined by largest.empty from the Hmisc package.</i></p>
</div>
