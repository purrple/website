---
title:   Structure Matcher for brackets in R scripts
author: "Romain François"
date:  2009-01-14
slug:  Structure-matcher
tags:  [ "jedit" ]
---
<div class="post-content">
<p>It is often useful when you close a bracket to know which bracket is the corresponding opening bracket, for this jedit has the <a href="http://www.jedit.org/api/org/gjt/sp/jedit/textarea/StructureMatcher.html">StructureMatcher</a> interface and the <a href="http://www.jedit.org/api/org/gjt/sp/jedit/textarea/StructureMatcher.BracketMatcher.html">default implementation</a> gives you this information, by surrounding the opening bracket when you type its associated closing bracket.</p>


<p>On the other hand, the <a href="http://plugins.jedit.org/plugins/?XML">XML plugin</a> gives you a more useful information when closing an XML tag. Let's see it in action with this <a href="http://www.w3schools.com/XML/note.xml">simple XML file from the w3c</a></p>


<p><a href="/public/posts/post5-structurematcher/xml.png"><img src="/public/posts/post5-structurematcher/.xml_m.jpg" alt="xml.png" style="display:block; margin:0 auto;" title="xml.png, janv. 2009"></a></p>


<p>On the left, the caret is within the <code>&lt;/note&gt;</code> closing tag and so the entire opening <code>&lt;note&gt;</code> tag is being highlighted. Similarly, on the right, the caret is within the opening <code>&lt;heading&gt;</code> tag and consequently the closing <code>&lt;/heading&gt;</code> gets highlighted. This is particularly useful when editing xml documents.</p>


<p>So the idea was to have the same sort of behaviour for R scripts. Here's a start, but I also plan to do something with the curly brackets to deal with for loops, function definitions and various apply calls, ... (<a href="/index.php?post/2009/01/18/Structure-Matcher-for-brackets-in-R-scripts-%282%29">see that post</a>)</p>


<p><img src="/public/posts/post5-structurematcher/structurematch.png" alt="structurematch.png" style="float:left; margin: 0 1em 1em 0;" title="structurematch.png, janv. 2009"><img src="/public/posts/post5-structurematcher/structurematch2.png" alt="structurematch2.png" style="float:right; margin: 0 0 1em 1em;" title="structurematch2.png, janv. 2009"></p>
</div>
