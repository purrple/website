---
title:   Goldbach's Comet - take 2
author: "Romain François"
date:  2009-03-08
slug:  Goldbach-s-Comet-take-2
tags:  [ "profiling", "R" ]
---
<div class="post-content">
<style>
pre{
font-size:xx-small !important;
border:1px solid black;
}
</style>
<p>Following this <a href="/index.php?post/2009/03/07/Goldbach-s-Comet">post</a>, there is still room for improvement. Recall the last implementation (goldbach5)</p>

<pre><font color="#000000"><span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">12 </font></span>goldbach5 <font color="#000000"><strong>&lt;-</strong></font> <font color="#006699"><strong>function</strong></font>(n) <font color="#000000"><strong>{</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">13 </font></span>    xx <font color="#000000"><strong>&lt;-</strong></font> <font color="#ff0000">1</font> <font color="#000000"><strong>:</strong></font> n
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">14 </font></span>    xx <font color="#000000"><strong>&lt;-</strong></font> <font color="#9900cc">xx</font>[<font color="#ff0033">isprime</font>(xx) <font color="#000000"><strong>&gt;</strong></font> <font color="#ff0000">0</font>][<font color="#000000"><strong>-</strong></font><font color="#ff0000">1</font>]
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">15 </font></span>    
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">16 </font></span>    <font color="#ff9999">#</font><font color="#ff9999"> </font><font color="#ff9999">generates</font><font color="#ff9999"> </font><font color="#ff9999">row</font><font color="#ff9999"> </font><font color="#ff9999">indices</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">17 </font></span>    x <font color="#000000"><strong>&lt;-</strong></font> <font color="#006699"><strong>function</strong></font>(N)<font color="#000000"><strong>{</strong></font> 
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">18 </font></span>        <font color="#009966"><strong>rep.int</strong></font>( <font color="#ff0000">1</font><font color="#000000"><strong>:</strong></font>N, N<font color="#000000"><strong>:</strong></font><font color="#ff0000">1</font>) 
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">19 </font></span>    <font color="#000000"><strong>}</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">20 </font></span>    <font color="#ff9999">#</font><font color="#ff9999"> </font><font color="#ff9999">generates</font><font color="#ff9999"> </font><font color="#ff9999">column</font><font color="#ff9999"> </font><font color="#ff9999">indices</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">21 </font></span>    y <font color="#000000"><strong>&lt;-</strong></font> <font color="#006699"><strong>function</strong></font>(N)<font color="#000000"><strong>{</strong></font> 
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">22 </font></span>        <font color="#009966"><strong>unlist</strong></font>( <font color="#009966"><strong>lapply</strong></font>( <font color="#ff0000">1</font><font color="#000000"><strong>:</strong></font>N, seq.int, to <font color="#000000"><strong>=</strong></font> N ) ) 
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">23 </font></span>    <font color="#000000"><strong>}</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">24 </font></span>    z <font color="#000000"><strong>&lt;-</strong></font> <font color="#9900cc">xx</font>[ <font color="#ff0033">x</font>(<font color="#009966"><strong>length</strong></font>(xx)) ] <font color="#000000"><strong>+</strong></font> <font color="#9900cc">xx</font>[ <font color="#ff0033">y</font>(<font color="#009966"><strong>length</strong></font>(xx)) ]
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">25 </font></span>    z <font color="#000000"><strong>&lt;-</strong></font> <font color="#9900cc">z</font>[z <font color="#000000"><strong>&lt;=</strong></font> n]
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">26 </font></span>    tz <font color="#000000"><strong>&lt;-</strong></font> <font color="#009966"><strong>tabulate</strong></font>(z, n )
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">27 </font></span>    <font color="#9900cc">tz</font>[ tz <font color="#000000"><strong>!=</strong></font> <font color="#ff0000">0</font> ]
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">28 </font></span><font color="#000000"><strong>}</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">29 </font></span>
</font></pre>

<p>The first thing to notice right away is that when we build <code>xx</code> in the first place, we are building integers from 1 to n, and check if they are prime afterwards. In that case, we are only going to need odd numbers in xx, so we can build them dircetly as: </p>

<pre><font color="#000000"><span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">31 </font></span>    xx <font color="#000000"><strong>&lt;-</strong></font> <font color="#ff0033">seq.int</font>( <font color="#ff0000">3</font>, n, <font color="#009966"><strong>by</strong></font> <font color="#000000"><strong>=</strong></font> <font color="#ff0000">2</font>)
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">32 </font></span>    xx <font color="#000000"><strong>&lt;-</strong></font> <font color="#9900cc">xx</font>[<font color="#ff0033">isprime</font>(xx) <font color="#000000"><strong>&gt;</strong></font> <font color="#ff0000">0</font>]
</font></pre>

<p>The next thing is that, even though the <code>goldbach5</code> version only builds the upper triangle of the matrix, which saves some memory, we don't really need all the numbers, since eventually we just want to count how many times each of them appears. For that, there is no need to store them all in memory. </p>

<p>The version <code>goldbach6</code> below takes this idea forward implementing the counting in C using the <code>.C</code> interface. See this <a href="http://cran.r-project.org/doc/manuals/R-exts.html#Interface-functions-_002eC-and-_002eFortran">section</a> of writing R extensions for details of the <code>.C</code> interface. </p>

<pre><font color="#000000"><span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">30 </font></span>goldbach6 <font color="#000000"><strong>&lt;-</strong></font> <font color="#006699"><strong>function</strong></font>( n )<font color="#000000"><strong>{</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">31 </font></span>    xx <font color="#000000"><strong>&lt;-</strong></font> <font color="#ff0033">seq.int</font>( <font color="#ff0000">3</font>, n, <font color="#009966"><strong>by</strong></font> <font color="#000000"><strong>=</strong></font> <font color="#ff0000">2</font>)
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">32 </font></span>    xx <font color="#000000"><strong>&lt;-</strong></font> <font color="#9900cc">xx</font>[<font color="#ff0033">isprime</font>(xx) <font color="#000000"><strong>&gt;</strong></font> <font color="#ff0000">0</font>]
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">33 </font></span>    out <font color="#000000"><strong>&lt;-</strong></font> <font color="#009966"><strong>integer</strong></font>( n )
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">34 </font></span>    tz <font color="#000000"><strong>&lt;-</strong></font> <font color="#009966"><strong>.C</strong></font>( <font color="#ff00cc">"</font><font color="#ff00cc">goldbach</font><font color="#ff00cc">"</font>, xx <font color="#000000"><strong>=</strong></font><font color="#009966"><strong>as.integer</strong></font>(xx), nx <font color="#000000"><strong>=</strong></font> <font color="#009966"><strong>length</strong></font>(xx), 
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">35 </font></span>      out <font color="#000000"><strong>=</strong></font> out, n <font color="#000000"><strong>=</strong></font> <font color="#009966"><strong>as.integer</strong></font>(n), DUP<font color="#000000"><strong>=</strong></font><font color="#006699"><strong>FALSE</strong></font> )$out
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">36 </font></span>    <font color="#9900cc">tz</font>[ tz <font color="#000000"><strong>!=</strong></font> <font color="#ff0000">0</font> ]
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">37 </font></span><font color="#000000"><strong>}</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">38 </font></span>
</font></pre>

<p>and the C function that goes with it</p>

<pre><font color="#000000"><span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   1 </font></span><font color="#009966"><strong>#</strong></font><font color="#0000ff">include</font> <font color="#ff00cc">&lt;</font><font color="#ff00cc">R.h</font><font color="#ff00cc">&gt;</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   2 </font></span> 
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   3 </font></span><font color="#006699"><strong>void</strong></font> <font color="#ff0033">goldbach</font><font color="#000000"><strong>(</strong></font><font color="#0099ff"><strong>int</strong></font> <font color="#000000"><strong>*</strong></font> xx<font color="#000000"><strong>,</strong></font> <font color="#0099ff"><strong>int</strong></font><font color="#000000"><strong>*</strong></font> nx<font color="#000000"><strong>,</strong></font> <font color="#0099ff"><strong>int</strong></font><font color="#000000"><strong>*</strong></font> out<font color="#000000"><strong>,</strong></font> <font color="#0099ff"><strong>int</strong></font><font color="#000000"><strong>*</strong></font> n<font color="#000000"><strong>)</strong></font><font color="#000000"><strong>{</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   4 </font></span>    <font color="#0099ff"><strong>int</strong></font> i<font color="#000000"><strong>,</strong></font>j<font color="#000000"><strong>,</strong></font>k<font color="#000000"><strong>;</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">   5 </font></span>    
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   6 </font></span>    <font color="#006699"><strong>for</strong></font><font color="#000000"><strong>(</strong></font> i<font color="#000000"><strong>=</strong></font><font color="#ff0000">0</font><font color="#000000"><strong>;</strong></font> i<font color="#000000"><strong>&lt;</strong></font><font color="#000000"><strong>*</strong></font>nx<font color="#000000"><strong>;</strong></font> i<font color="#000000"><strong>+</strong></font><font color="#000000"><strong>+</strong></font><font color="#000000"><strong>)</strong></font><font color="#000000"><strong>{</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   7 </font></span>        <font color="#006699"><strong>for</strong></font><font color="#000000"><strong>(</strong></font> j<font color="#000000"><strong>=</strong></font>i<font color="#000000"><strong>;</strong></font> j<font color="#000000"><strong>&lt;</strong></font><font color="#000000"><strong>*</strong></font>nx<font color="#000000"><strong>;</strong></font> j<font color="#000000"><strong>+</strong></font><font color="#000000"><strong>+</strong></font><font color="#000000"><strong>)</strong></font><font color="#000000"><strong>{</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   8 </font></span>            k <font color="#000000"><strong>=</strong></font> xx<font color="#000000"><strong>[</strong></font>i<font color="#000000"><strong>]</strong></font> <font color="#000000"><strong>+</strong></font> xx<font color="#000000"><strong>[</strong></font>j<font color="#000000"><strong>]</strong></font> <font color="#000000"><strong>;</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   9 </font></span>            <font color="#006699"><strong>if</strong></font><font color="#000000"><strong>(</strong></font> k <font color="#000000"><strong>&gt;</strong></font> <font color="#000000"><strong>*</strong></font>n<font color="#000000"><strong>)</strong></font><font color="#000000"><strong>{</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">  10 </font></span>                <font color="#006699"><strong>break</strong></font><font color="#000000"><strong>;</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  11 </font></span>            <font color="#000000"><strong>}</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  12 </font></span>            out<font color="#000000"><strong>[</strong></font>k<font color="#000000"><strong>-</strong></font><font color="#ff0000">1</font><font color="#000000"><strong>]</strong></font><font color="#000000"><strong>+</strong></font><font color="#000000"><strong>+</strong></font> <font color="#000000"><strong>;</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  13 </font></span>        <font color="#000000"><strong>}</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  14 </font></span>    <font color="#000000"><strong>}</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">  15 </font></span><font color="#000000"><strong>}</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  16 </font></span>
</font></pre>

<p>We need to build the shared object</p>

<pre>
$ R CMD SHLIB goldbach.c
gcc -std=gnu99 -I/usr/local/lib/R/include  -I/usr/local/include    -fpic  -g -O2 -c goldbach.c -o goldbach.o
gcc -std=gnu99 -shared -L/usr/local/lib -o goldbach.so goldbach.o   -L/usr/local/lib/R/lib -lR
</pre>

<p>and load it in R: </p>

<pre>
&gt; dyn.load( "goldbach.so" )
</pre>

<p>And now, let's see if it was worth the effort</p>

<pre>
&gt; system.time( out  system.time( out  system.time( out 

<p>We could also have a look at the memoty footprint of each of the three functions using the memory profiler. </p>

<pre>
&gt; gc(); Rprof( "goldbach4.out", memory.profiling=T ); out  gc(); Rprof( "goldbach5.out", memory.profiling=T ); out  gc(); Rprof( "goldbach6.out", memory.profiling=T ); out  rbind( summaryRprof( filename="goldbach4.out", memory="both" )$by.total[1,] ,
+        summaryRprof( filename="goldbach5.out", memory="both" )$by.total[1,],
+        summaryRprof( filename="goldbach6.out", memory="both" )$by.total[1,] )
            total.time total.pct mem.total self.time self.pct
"goldbach4"      32.08       100     712.6      1.26      3.9
"goldbach5"       6.66       100     306.7      2.80     42.0
"goldbach6"       0.22       100       0.2      0.00      0.0
</pre></pre>
</div>
