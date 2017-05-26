---
title:   celebrating R commit -50000
author: "Romain François"
date:  2009-10-09
slug:  celebrating-R-commit-50000
tags:  [ "R" ]
---
<div class="post-content">
<style>
pre{
  font-size: x-small !important ;
  border: 1px solid black ;
}
</style>
<p>Today, Brian Ripley commited the revision 50 000 into R svn repository. </p>

<pre>
------------------------------------------------------------------------
r50000 | ripley | 2009-10-09 10:34:17 +0200 (Fri, 09 Oct 2009) | 1 line
Changed paths:
   M /branches/R-2-10-branch/src/library/stats/R/plot.lm.R

port r49999 from trunk
------------------------------------------------------------------------
r49999 | ripley | 2009-10-09 10:33:28 +0200 (Fri, 09 Oct 2009) | 2 lines
Changed paths:
   M /trunk/src/library/stats/R/plot.lm.R

workaround for PR#13899 (that in the report is broken and fails make check!)
</pre>

<p>so it is time to celebrate and have some fun with the svn log to analyze the 50 000 commits ... with R of course.</p>

<h2>data extraction</h2>

<p>First we need to grab the full svn log, using command line svn, something like this: </p>

<pre>
$ svn log -v https://svn.r-project.org/R &gt; rsvn.log
</pre>

<p> ... or you can download it <a href="http://addictedtor.free.fr/misc/R50000/rsvn.log">from my website</a> if you don't have svn on your machine</p>

<p>now we need to read the data into R :</p>

<iframe src="/public/R50000/rsvnlog.R.html" width="500" height="500" frameborder="1"></iframe>

<p>we might also be interested in release date, version number and size of the distribution of each R release that is archived on CRAN, which we can get like this :</p>

<iframe src="/public/R50000/releases.R.html" width="500" height="550" frameborder="1"></iframe>

<h2>graphics</h2>

<p>now we can do some graphics. I'm using lattice here because I am familiar with it, but I'm sure interesting plots could be done using <a href="http://had.co.nz/ggplot2/">ggplot2</a>, in fact checkout <a href="http://yihui.name/en/2009/10/50000-revisions-committed-to-r/">this post from Yihui Xie</a> using ggplot2</p>

<p>First I need to define some helper panel functions I'll use in the plots below</p>

<iframe src="/public/R50000/lattice-helpers.R.html" width="500" height="500" frameborder="1"></iframe>

<h3>Number of commits per day</h3>

<a href="/public/R50000/commits_day.png"><img src="/public/R50000/.commits_day_m.jpg" alt="commits_day.png" style="margin: 0 auto; display: block;" title="commits_day.png, oct. 2009"></a>

<iframe src="/public/R50000/commits_day.html" width="500" height="150" frameborder="1"></iframe>

<h3>... split by author</h3>

<a href="/public/R50000/commits_author_day.png"><img src="/public/R50000/.commits_author_day_m.jpg" alt="commits_author_day.png" style="margin: 0 auto; display: block;" title="commits_author_day.png, oct. 2009"></a>

<iframe src="/public/R50000/commits_day_author.html" width="500" height="150" frameborder="1"></iframe>

<h3>The number of commits per month</h3>

<a href="/public/R50000/commits_month.png"><img src="/public/R50000/.commits_month_m.jpg" alt="commits_month.png" style="margin: 0 auto; display: block;" title="commits_month.png, oct. 2009"></a>

<iframe src="/public/R50000/commits_month.html" width="500" height="150" frameborder="1"></iframe>

<h3>... split by author</h3>

<a href="/public/R50000/commits_author_month.png"><img src="/public/R50000/.commits_author_month_m.jpg" alt="commits_author_month.png" style="margin: 0 auto; display: block;" title="commits_author_month.png, oct. 2009"></a>

<iframe src="/public/R50000/commits_month_author.html" width="500" height="150" frameborder="1"></iframe>

<h2>blogroll</h2>

<ul>
<li>
<a href="http://blog.revolution-computing.com/2009/10/analyzing-rs-rate-of-change.html">Analyzing R's rate of change</a> on revolution's blog</li>
<li>
<a href="http://yihui.name/en/2009/10/50000-revisions-committed-to-r/">50000 Revisions Committed to R</a> on Yihui Xie's blog</li>
</ul>
</div>
