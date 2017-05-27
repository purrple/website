---
title:   Code Completion for R scripts
author: "Romain François"
date:  2009-01-09
slug:  Code-Completion-for-R-scripts
tags:  [ "jedit", "R" ]
---
<div class="post-content">
<h1>Standard Completion</h1>
<p>The power editor supports completion of R code by relying on the <a href="http://r-forge.r-project.org/plugins/scmsvn/viewcvs.php/pkg/svMisc/R/CompletePlus.R?rev=61&amp;root=sciviews&amp;view=markup">CompletePlus</a> function in the svMisc package. This function uses the completion engine that comes with R (formerly implemented in the rcompgen package and incorporated in utils in recent versions of R), and looks in documentation files for additional information related to each finding, for example when completing <code>"rnorm( "</code>, the <code>CompletePlus</code> function looks into the help page for <a href="http://finzi.psych.upenn.edu/R/library/stats/html/Normal.html">rnorm</a> and retrieves the description of each of the arguments :</p>
<pre><code>R&gt; require( svMisc )<br>Loading required package: svMisc<br>R&gt; CompletePlus( "rnorm(" )<br>     [,1]      [,2]<br>[1,] "n = "    "rnorm"<br>[2,] "mean = " "rnorm"<br>[3,] "sd = "   "rnorm"<br>     [,3]<br>[1,] "number of observations. If 'length(n) &gt; 1', the length is taken to be the number required."<br>[2,] "vector of means."<br>[3,] "vector of standard deviations."</code></pre>
<p>The power editor plugin uses this information to display completion popups:</p>
<p><img title="argumentnames.png, janv. 2009" style="margin: 0 auto; display: block;" alt="" src="/public/posts/post3_completion/argumentnames_m.jpg"></p>
<p><img title="argumentnames_or_function_names.png, janv. 2009" style="margin: 0 auto; display: block;" alt="" src="/public/posts/post3_completion/argumentnames_or_function_names_m.jpg"></p>
<h1>Completion of Colors</h1>
<p>In special cases, instead of argument or function names, the engine will complete for colours using the current R palette :</p>
<p><img title="colors_palette.png, janv. 2009" style="margin: 0 auto; display: block;" alt="" src="/public/posts/post3_completion/colors_palette_m.jpg"></p>
<p>or names of colors if you started to type a quote character</p>
<p><img title="colors_named.png, janv. 2009" style="margin: 0 auto; display: block;" alt="" src="/public/posts/post3_completion/colors_named_m.jpg"></p>
<p>here the user started to type <code>gre</code> so the completion engine looks for colors having a name that matches the pattern gre. This is basically obtained as follows: </p>
<pre><code>&gt; head( grep( "gre", colors(), value = T ) )<br>[1] "darkgreen"       "darkgrey"        "darkolivegreen"  "darkolivegreen1"<br>[5] "darkolivegreen2" "darkolivegreen3"<br><br></code></pre>
<h1>Line Type completion</h1>
<p>Usually the <code>lty</code> argument is associated with a line type, the completion engine suggests the basic line types as documented in <a href="http://finzi.psych.upenn.edu/R/library/graphics/html/par.html">?par</a></p>
<h1><img title="lty.png, janv. 2009" style="margin: 0 auto; display: block;" alt="" src="/public/posts/post3_completion/lty_m.jpg"></h1>
<h1>Plot Character Completion </h1>
<p>Same with the pch argument and the plotting character. </p>
<p><img title="pch.png, janv. 2009" style="margin: 0 auto; display: block;" alt="" src="/public/posts/post3_completion/pch_m.jpg"></p>
</div>
