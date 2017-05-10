---
title:  Web Hosted R Syntax Highlighter
author: "Romain François"
date:  2013-03-24

---


						<p><a href="http://highlight.r-enthusiasts.com/">highlight</a> uses simple jquery command to syntax highlight R code contained in any regular <code>&lt;pre&gt;</code> element.</p>
<p>For example, this chunk of code, from the <a href="http://help.r-enthusiasts.com/library/datasets/html/cars.html">datasets::cars</a> help file.</p>
<pre class="code_r">
require(stats); require(graphics)
plot(cars, xlab = "Speed (mph)", ylab = "Stopping distance (ft)",
     las = 1)
lines(lowess(cars$speed, cars$dist, f = 2/3, iter = 3), col = "red")
title(main = "cars data")
plot(cars, xlab = "Speed (mph)", ylab = "Stopping distance (ft)",
     las = 1, log = "xy")
title(main = "cars data (logarithmic scales)")
</pre>
<p>More details is given at <a href="http://highlight.r-enthusiasts.com/">highlights page</a> on how to use it on your own page.</p>
