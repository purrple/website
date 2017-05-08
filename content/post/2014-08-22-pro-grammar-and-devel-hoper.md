---
title:  Pro Grammar and Devel Hoper
author: "Romain François"
date:  2014-08-22
tags: []
---

<div class="post-content">
<p>I've been teasing about this post for some time now. </p>

<blockquote class="twitter-tweet" lang="en">
<p>My next blog post is "Pro Grammar and Devel Hoper". And this not just an empty pun. Stay tuned.</p>— Romain François (@romain_francois) <a href="https://web.archive.org/web/20150304070936/https://twitter.com/romain_francois/statuses/495948962533498880">August 3, 2014</a>
</blockquote>

<blockquote class="twitter-tweet" lang="en">
<p><a href="https://web.archive.org/web/20150304070936/https://twitter.com/stefanbache">@stefanbache</a> another teaser. <a href="https://web.archive.org/web/20150304070936/https://t.co/i2ubfOyjIO">https://t.co/i2ubfOyjIO</a>iris &gt;&gt; filter( Sepal.Length &gt; 7 )iris |&gt; filter( Sepal.Length &gt; 7 )</p>— Romain François (@romain_francois) <a href="https://web.archive.org/web/20150304070936/https://twitter.com/romain_francois/statuses/496710333491601408">August 5, 2014</a>
</blockquote>

<script async src="//web.archive.org/web/20150304070936js_/http://platform.twitter.com/widgets.js" charset="utf-8"></script><p>So I'm going to try prove that this is not just for the pun, however proud of it I might be, and believe me I love it when a language plays tricks with my brain and a pun presents itself to me. This is valid for most of the languages I use daily, including <a href="https://web.archive.org/web/20150304070936/http://en.wikipedia.org/wiki/French_language">French</a>, that is described in Wikipedia as a <em>Romance language</em>,  <a href="https://web.archive.org/web/20150304070936/http://en.wikipedia.org/wiki/English_language">English</a> our current <em>lingua franca</em>, <a href="https://web.archive.org/web/20150304070936/http://en.wikipedia.org/wiki/C%2B%2B">C++</a> this weird high maintenance language that lets you accomplish amazing things once you've demonstrated that you can manage countless hours of head banging and investigate Sherlock class compiler error messages, and finally <a href="https://web.archive.org/web/20150304070936/http://www.r-project.org/">R</a>. </p>

<p>There is no describing how much I love and care about R. Well first of all, I make a living out of selling R services, that's got to count for something right. But beyond that, I've been using R for more than 13 years now. It might seem a bit irrationnal to be addicted to such a quirky language especially given all the temptations around for better, faster, cleaner, whatever, languages out there. Sure I can play with these fancy languages, but for some reason I always come back to R, R makes me tick. </p>

<p>Something else that gives me pride is that I've been able to make a difference in the R community, mostly by my involvement in bridging R and C++. When you use a language for that long you get to become familiar with the most intimate details. This had led me a few years back to play with the parser for the purpose of my syntax highlighter package, just one of those <em>why not</em>  projects, which evidently by some random course of action had the effect of landing some of my code directly into the R source. So it's like there is always a part of me in R. </p>

<p><img src="/web/20150304070936im_/http://blog.r-enthusiasts.com:80/content/images/2014/Aug/gram.png" alt=""></p>

<p>So yes, I'm proud of that. Just however, realize that me being proud of something does not necessarily make it a great accomplishment. For example, lately I've been proud I successfully managed to grow tomatoes. </p>

<iframe src="//web.archive.org/web/20150304070936if_/http://instagram.com/p/r2S9iVO05K/embed/" width="612" height="710" frameborder="0" scrolling="no" allowtransparency="true"></iframe>

<p>Anyway, the <a href="https://web.archive.org/web/20150304070936/https://github.com/wch/r-source/blob/trunk/src/main/gram.y">gram.y file</a> in which my name is, is perhaps one of the deepest component, it defines the grammar, the set of rules that make up the language. R's grammar is not that complicated and it has not changed much over the years. </p>

<p>It is one thing to add vocabulary, functions or verbs as the hipsters call them now ;) but messing with the grammar is a whole new dimension. </p>

<p>R does not really let you change its grammar from the perspective of say a package. There have been some things getting close to grammatical changes, i.e. adoption from <code>data.table</code> of the phantom <code>:=</code>  to do stuff like that: </p>

<pre><code>DT[, p := x/sum(x), by=group]  
</code></pre>

<p>However biased I might be about <code>data.table</code>, I got to admit that the use of <code>:=</code> here is beautiful. </p>

<p>This has only been possible because <code>:=</code> is syntactically valid, i.e. it parses, but it does not mean anything in standard R, so <code>data.table</code> was able to reclaim the meaning. </p>

<p>Another thing that comes close to grammatical change is the weird operator construct between two <code>%</code>. What a weird and lovely feature. You can just define whatever binary operator you like, as long as it is between two <code>%</code>  : </p>

<pre><code>&gt; `%w/o%` &lt;- function(x, y){ setdiff(x, y) }
&gt; letters %w/o% c("a", "b")
 [1] "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s" "t" "u"
[20] "v" "w" "x" "y" "z"
</code></pre>

<p>This is what makes possible the latest storm in the R world, at least as I felt it at <a href="https://web.archive.org/web/20150304070936/http://user2014.stat.ucla.edu/">useR!2014</a>, the piping operators as introduced by <a href="https://web.archive.org/web/20150304070936/https://github.com/smbache/magrittr"><code>magrittr</code></a> and excessively promoted by <a href="https://web.archive.org/web/20150304070936/https://github.com/hadley/dplyr"><code>dplyr</code></a>. </p>

<p>We've seen lots of <em>look how piping is awesome</em> in association with <code>dplyr</code> and again this is probably something I'm biased about, so I'll use a <code>dplyr</code> free piping example, taken from <a href="https://web.archive.org/web/20150304070936/https://twitter.com/stefanbache">@stefanbache</a>'s presentation in the <a href="https://web.archive.org/web/20150304070936/http://www.meetup.com/CopenhagenR-useR-Group/events/189230102/">CopenhagenR</a> meetup. </p>

<p>The example is about expressing a cooking recipe, something that appeals naturally to me as a pretentious frenchman. </p>

<p>First expressed with regular R nesting of function calls. It has obviously been made cryptic and perhaps some indenting could help. But fundamentally you can't read that. What is <code>degress</code> an argument of ? </p>

<p><img src="/web/20150304070936im_/http://blog.r-enthusiasts.com:80/content/images/2014/Aug/cook.png" alt=""></p>

<p>The pipe operator <code>%&gt;%</code> turns this around into something that looks a lot like more what a cook would do. It reads as a story. </p>

<p><img src="/web/20150304070936im_/http://blog.r-enthusiasts.com:80/content/images/2014/Aug/cook2.png" alt=""></p>

<p>Fine, enough of blind admiration for now. I love piping and I truly think this is one of the most exciting recent R innovations, but I still stand by this. <code>%&gt;%</code> is ugly. </p>

<blockquote class="twitter-tweet" lang="en">
<p><a href="https://web.archive.org/web/20150304070936/https://twitter.com/hashtag/magrittr?src=hash">#magrittr</a> piping is so popular, Id vote for an extension to the <a href="https://web.archive.org/web/20150304070936/https://twitter.com/hashtag/rstats?src=hash">#rstats</a> grammar so that we can something less ugly than %&gt;%. |&gt; or &gt;&gt; ?</p>— Romain François (@romain_francois) <a href="https://web.archive.org/web/20150304070936/https://twitter.com/romain_francois/statuses/479279015833112578">June 18, 2014</a>
</blockquote>

<p>Since I have the skills for that sort of weird stuff, I've been playing with the grammar in <a href="https://web.archive.org/web/20150304070936/https://github.com/romainfrancois/r-source/tree/grammar">this branch</a> of a fork of <a href="https://web.archive.org/web/20150304070936/https://twitter.com/winston_chang">@winston_chang</a>'s read only mirror of the R source. In a less convoluted way: I've been messing with the grammar. </p>

<p>Change the grammar has been on my list of fantasies for some time, and this gave be enough incentive to actually look into it. And this is a pretty simple change, but I'll get into other stuff later. </p>

<p>For now, what I've done in the branch is legalize some tokens. I've legalized <code>&gt;&gt;</code>, <code>|&gt;</code> and <code>&lt;&lt;</code>, but their meaning is not defined, similarly to what R does with <code>:=</code>. So we can e.g. define <code>&gt;&gt;</code> and <code>|&gt;</code> to be synonyms of magrittr's <code>%&gt;%</code> : </p>

<pre><code>`&gt;&gt;` &lt;- `|&gt;` &lt;-  magrittr::`%&gt;%`

iris &gt;&gt; summary  
iris |&gt; summary  
</code></pre>

<p>The other one <code>&lt;&lt;</code> could be used e.g. to stream some content into a file. </p>

<pre><code>`&lt;&lt;` &lt;- function(x, y){ ... }
f &lt;- file( "/tmp/yada.txt", open = "w" )  
f &lt;&lt; "yada" &lt;&lt; "yada" &lt;&lt; "yada" &lt;&lt; "I'm really tired today"  
</code></pre>

<iframe width="640" height="480" src="//web.archive.org/web/20150304070936if_/http://www.youtube.com/embed/QuYEtGBNvaE" frameborder="0" allowfullscreen></iframe>

<p>There are other things I'd like to play with in terms of the R grammar, which very likely transform into something more challenging than what I anticipate. </p>

<p>I'd like some syntax for optional typing. R is dynamically typed, and that's not going to change, we all love that, yada, yada, yada, but optional typing could help and remove some clutter. Consider: </p>

<pre><code>x &lt;- foo()  
if( ! is(x, "bar") ){  
  stop( "nope, this not a bar" )
}
</code></pre>

<p>We see many variations of that littering the code we write and the packages we use. What about something that would let you express more elegantly the type you require, i.e. something like this: </p>

<pre><code>bar x &lt;- foo()  
</code></pre>

<p>This could make its way into function arguments too and give us some method dispatch that would be for once nice to use. What's the deal with <code>setMethod</code>, <code>setGeneric</code> and all that verbosity. Other languages have come up with nicer ways to deal with overloading. We could have something like this: </p>

<pre><code>foo &lt;- function( character x ){  
   # do some characer stuff
}
foo &lt;- function( data.frame x)�?{  
   # do some data frame stuff
}
</code></pre>

<p>This could sit on top of what already exists, i.e. generate appropriate <code>setGeneric</code> and <code>setMethod</code> calls underneath, but give us some syntax that would be much nicer to use. </p>

<p>Furthermore with the verbosity, the way we define classes in R, from various implementations (S4, ref classes, R6, ...) is trapped into the whole "everything is a function call" mantra. </p>

<p>Most languages that started without OO and incorporated it later (e.g. php) had their grammar improved to deal with expressing classes. In R, we are stuck with coming up with new vocabulary. I strongly believe that we could come up with a much better way to express classes if we were willing to think about it. This is blurry to me still, but what about something like this, borrowing the <code>Person</code> class from <a href="https://web.archive.org/web/20150304070936/http://rpubs.com/wch/24456">Introduction to R6</a></p>

<pre><code>class Person {  
  character name = NA
  character hair = NA 

  Person(character name, character hair){
     if (!missing(name)) self$name &lt;- name
     if (!missing(hair)) self$hair &lt;- hair
     self$greet()
  }

  set_hair(character val) {
      self$hair &lt;- val
  }

  greet() {
      cat(paste0("Hello, my name is ", self$name, ".\n"))
  }

}
</code></pre>

<p>As I said higher up, implementing this could materialize into a big challenge, but I think R deserves a grammar update. </p>

<p>To come back to the title of this post, I hope I've demonstrated that I'm a pro grammar, i.e. I believe that we could benefit greatly from upgrading the grammar, and a devel hoper ad I hope to be able to commit enough enthusiasm to play further with this. </p>
</div>
