---
title:   Structure Matcher for brackets in R scripts (2)
author: "Romain François"
date:  2009-01-18
slug:  Structure-Matcher-for-brackets-in-R-scripts--2-
tags:  [ "jedit" ]
---
<div class="post-content">
<p>A few coding hours in the train later, I've added new features to the <a href="/index.php?post/2009/01/14/Structure-matcher">structure matcher</a> for R scripts. Basically I've been working to improve the matching of closing curly brackets in particular cases. This is how it proceeds: when you close a curly bracket, it looks for the corresponding opening bracket (thanks to the <a href="http://www.jedit.org/api/org/gjt/sp/jedit/TextUtilities.html">TextUtilities</a> class), then looks if there is a closing round bracket just before, finds the matching opening round bracket, identifies which word is before. Then</p>
<ul>
<li>if this word is one of <strong>if</strong>, <strong>for</strong>, <strong>while</strong>, <strong>repeat</strong> or <strong>function</strong> the macth is considered to start from the word up to the closing curly bracket</li>
<li>Otherwise, the match is just the closing curly bracket as usual</li>
</ul>
<p>... but it is probably better to show some screenshots to get a better idea:</p>


<p><img src="/public/posts/post5-structurematcher/Screenshot-1.png" alt="Screenshot-1.png" style="float:left; margin: 0 1em 1em 0;" title="Screenshot-1.png, janv. 2009"></p>


<p><img src="/public/posts/post5-structurematcher/Screenshot-2.png" alt="Screenshot-2.png" style="float:left; margin: 0 1em 1em 0;" title="Screenshot-2.png, janv. 2009"></p>


<p><img src="/public/posts/post5-structurematcher/Screenshot-3.png" alt="Screenshot-3.png" style="float:left; margin: 0 1em 1em 0;" title="Screenshot-3.png, janv. 2009"></p>


<p><img src="/public/posts/post5-structurematcher/Screenshot-4.png" alt="Screenshot-4.png" style="float:left; margin: 0 1em 1em 0;" title="Screenshot-4.png, janv. 2009"></p>


<p><img src="/public/posts/post5-structurematcher/Screenshot-5.png" alt="Screenshot-5.png" style="float:left; margin: 0 1em 1em 0;" title="Screenshot-5.png, janv. 2009"></p>


<p><img src="/public/posts/post5-structurematcher/Screenshot-6.png" alt="Screenshot-6.png" style="float:left; margin: 0 1em 1em 0;" title="Screenshot-6.png, janv. 2009"></p>


<p><img src="/public/posts/post5-structurematcher/Screenshot-7.png" alt="Screenshot-7.png" style="float:left; margin: 0 1em 1em 0;" title="Screenshot-7.png, janv. 2009"></p>
</div>
