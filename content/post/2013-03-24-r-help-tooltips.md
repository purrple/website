---
title:  R Help tooltips
author: "Romain François"
date:  2013-03-24

---

<div class="entry-content">
						<p>I created a simple <a href="https://web.archive.org/web/20130516083840/http://jquery.com/">jquery</a> plugin to display some information when hovering links to r documentation files hosted at <a href="help.r-enthusiasts.com">help.r-enthusiasts.com</a></p>
<p>Below is a snapshot from <a href="https://web.archive.org/web/20130516083840/http://highlight.r-enthusiasts.com">highlight.r-enthusiasts.com</a> that uses the tooltips:</p>
<p><img src="https://web.archive.org/web/20130516083840im_/http://blog.r-enthusiasts.com/wp-content/uploads/2013/03/tooltip.png"></p>
<p>See also a live example here: <a href="https://web.archive.org/web/20130516083840/http://help.r-enthusiasts.com/library/base/html/data.frame.html">data.frame</a></p>
<p>Using this feature is simple. You just need to include jquery and my plugin like this:</p>
<pre><span class="syntax0"><span class="syntax-MARKUP">&lt;link</span><span class="syntax-MARKUP"> </span><span class="syntax-MARKUP">rel</span><span class="syntax-OPERATOR">=</span><span class="syntax-LITERAL1">'</span><span class="syntax-LITERAL1">stylesheet</span><span class="syntax-LITERAL1">'</span><span class="syntax-MARKUP"> </span><span class="syntax-MARKUP">href</span><span class="syntax-OPERATOR">=</span><span class="syntax-LITERAL1">'</span><span class="syntax-LITERAL1">/</span><span class="syntax-LITERAL1">/</span><span class="syntax-LITERAL1">highlight</span><span class="syntax-LITERAL1">.</span><span class="syntax-LITERAL1">r</span><span class="syntax-LITERAL1">-</span><span class="syntax-LITERAL1">enthusiasts</span><span class="syntax-LITERAL1">.</span><span class="syntax-LITERAL1">com</span><span class="syntax-LITERAL1">/</span><span class="syntax-LITERAL1">css</span><span class="syntax-LITERAL1">/</span><span class="syntax-LITERAL1">highlight</span><span class="syntax-LITERAL1">.</span><span class="syntax-LITERAL1">css</span><span class="syntax-LITERAL1">'</span><span class="syntax-MARKUP">&gt;</span>
<span class="syntax-MARKUP">&lt;script</span><span class="syntax-MARKUP"> </span><span class="syntax-MARKUP">src</span><span class="syntax-OPERATOR">=</span><span class="syntax-LITERAL2">"</span><span class="syntax-LITERAL2">/</span><span class="syntax-LITERAL2">/</span><span class="syntax-LITERAL2">highlight</span><span class="syntax-LITERAL2">.</span><span class="syntax-LITERAL2">r</span><span class="syntax-LITERAL2">-</span><span class="syntax-LITERAL2">enthusiasts</span><span class="syntax-LITERAL2">.</span><span class="syntax-LITERAL2">com</span><span class="syntax-LITERAL2">/</span><span class="syntax-LITERAL2">js</span><span class="syntax-LITERAL2">/</span><span class="syntax-LITERAL2">highlight</span><span class="syntax-LITERAL2">.</span><span class="syntax-LITERAL2">js</span><span class="syntax-LITERAL2">"</span><span class="syntax-MARKUP">&gt;</span><span class="syntax-MARKUP">&lt;/script&gt;</span>
</span></pre>
<p>And thats it, all links similar to</p>
<pre>
&lt;a href="http://help.r-enthusiasts.com/library/base/html/data.frame.html"&gt;data.frame&lt;/a&gt;
</pre>
<p>will get a nice tooltip showing extra information.</p>
											</div>

