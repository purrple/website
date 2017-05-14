---
title:  A package about nothing
author: "Romain François"
date:  2014-07-25

---

<div class="post-content">
<p><a href="https://github.com/romainfrancois/nothing">nothing</a> is a package about nothing. </p>

<p><img src="https://web.archive.org/web/20141010151932im_/http://media.tumblr.com/tumblr_lkw5e6ANdS1qf7q1s.png" alt=""></p>

<p>The idea is that when you do <code>require(nothing)</code> you express that you don't need <br>
anything, and therefore <code>nothing</code> assumes you are fine just using the <br><code>base</code> package, so it detaches all other packages. </p>

<pre><code>&gt; loadedNamespaces()
 [1] "base"      "datasets"  "devtools"  "digest"    "evaluate"  "graphics"
 [7] "grDevices" "httr"      "memoise"   "methods"   "parallel"  "RCurl"
[13] "stats"     "stringr"   "tools"     "utils"     "whisker"
&gt;
&gt; require(nothing)
Loading required package: nothing  
unloading 'methods' package ...  
Failed with error:  ‘invalid 'pos' argument’  
&gt;
&gt; loadedNamespaces()
[1] "base"
</code></pre>

<p>I agree, this is completely useless. </p>
</div>
