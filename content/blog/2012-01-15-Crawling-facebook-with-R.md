---
title:   Crawling facebook with R
author: "Romain François"
date:  2012-01-15
slug:  Crawling-facebook-with-R
tags:  [ "facebook", "R" ]
---
<div class="post-content">
<script type="text/javascript"><!--
google_ad_client = "ca-pub-0193080271541659";
/* blog */
google_ad_slot = "4394100836";
google_ad_width = 468;
google_ad_height = 60;
//-->
</script><script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script><br><p>So, let's crawl some data out of facebook using R. Don't get too excited though, this is just a weekend whatif project. Anyway, so for example, I want to download some photos where I'm tagged.</p>

<p>First, we need an access token from facebook. I don't know how to get this programmatically, so let's get one manually, log on to facebook and then go to the <a href="https://developers.facebook.com/tools/explorer">Graph API Explorer</a></p>

<a href="/public/posts/facebook/graph_api_explorer.png"><img src="/public/posts/facebook/graph_api_explorer_m.jpg" alt="graph_api_explorer.png" style="margin: 0 auto; display: block;" title="graph_api_explorer.png, janv. 2012"></a>

<p>Grab the access token and save it into a variable in R</p>

<pre>
access_token 

<p>Now we need to study the <a href="http://developers.facebook.com/docs/reference/api/">graph api</a> to figure out the url we need to build to do what we want to do, e.g. here we want "me/photos". I've wrapped this into an R function: </p>

<iframe src="/public/posts/facebook/facebook.R.html" width="500" height="250"></iframe>

<p>And then we can use it:</p>

<iframe src="/public/posts/facebook/dl_photos.R.html" width="500" height="150"></iframe>

<p>That's it, I told you it was not that exciting, but it was still worth playing with ...</p>

<p>
Blogroll: 
</p></pre>
<ul>
<li>
<a href="http://applyr.blogspot.com/2012/01/mining-facebook-data-most-liked-status.html?spref=tw">
Mining Facebook Data: Most "Liked" Status and Friendship Network</a>.
</li>
<li><a href="http://www.statsravingmad.com/blog/digital-life/download-your-facebook-photos-using-r/"> Download your Facebook photos using R </a></li>
</ul>
<br>
</div>
