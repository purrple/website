---
title:  Simpler R help tooltips
author: "Romain François"
date:  2013-03-25
tags: []
---

<div class="entry-content">
						<p>I posted yesterday about <a href="https://web.archive.org/web/20130516110133/http://blog.r-enthusiasts.com/2013/03/24/r-help-tooltips/">R Help tooltips</a>. I have started to use them e.g. on the <a href="https://web.archive.org/web/20130516110133/http://gallery.r-enthusiasts.com/graph/splom_:_scatter_plot_matrices_50">graph gallery</a></p>
<p>However, Im quickly frustrated with having to write the full url, i.e if I want to add a link to the help page for the <code>pacf</code> function in <code>stats</code>, I need to find this link:</p>
<pre>
&lt;a href="http://help.r-enthusiasts.com/library/stats/html/acf.html"&gt;pacf&lt;/a&gt;
</pre>
<p>Note here that the <code>pacf</code> function is documented in the <code>acf.html</code> file.</p>
<p>I then modified the tooltip plugin so that links like these get the tooltip</p>
<pre>
&lt;a data-rhelp="stats::pacf"&gt;pacf&lt;/a&gt;
</pre>
<p>And the plugin finds the correct link, set it to the <code>href</code> attribute, and enable the tooltip</p>
<p>Some examples: <a data-rhelp="stats::pacf">pacf</a>, <a data-rhelp="lattice::barchart">barchart</a></p>
											</div>

