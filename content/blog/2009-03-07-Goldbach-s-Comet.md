---
title:   Goldbach's Comet
author: "Romain François"
date:  2009-03-07
slug:  Goldbach-s-Comet
tags:  [ "profiling", "R" ]
---
<div class="post-content">
<style>
pre{
font-size:xx-small !important;
border: 1px solid black;
} 
</style>
<p>Murali Menon has posted <a href="http://jostamon.blogspot.com/2009/02/goldbachs-comet.html">on his blog</a> code to calculate <a href="http://en.wikipedia.org/wiki/Goldbach%27s_conjecture">Goldbach partitions</a>. Murali describes his approach to write the function, starting from brute force approach of loops, though the use of the <code>Vectorize</code> function, to some further optimized code using <code>outer</code></p>

<p>This post is a follow up on Murali's attempt refining the extra mile</p>

<p>This is the last implementation on Murali's blog : </p>

<pre><font color="#000000"><span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000"> 1 </font></span>goldbach4 <font color="#000000"><strong>&lt;-</strong></font> <font color="#006699"><strong>function</strong></font>(n) <font color="#000000"><strong>{</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000"> 2 </font></span>    xx <font color="#000000"><strong>&lt;-</strong></font> <font color="#ff0000">1</font> <font color="#000000"><strong>:</strong></font> n
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000"> 3 </font></span>    xx <font color="#000000"><strong>&lt;-</strong></font> <font color="#9900cc">xx</font>[<font color="#ff0033">isprime</font>(xx) <font color="#000000"><strong>&gt;</strong></font> <font color="#ff0000">0</font>]
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000"> 4 </font></span>    xx <font color="#000000"><strong>&lt;-</strong></font> <font color="#9900cc">xx</font>[<font color="#000000"><strong>-</strong></font><font color="#ff0000">1</font>]
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066"> 5 </font></span>    z <font color="#000000"><strong>&lt;-</strong></font> <font color="#009966"><strong>as.numeric</strong></font>(<font color="#ff0033">upperTriangle</font>(<font color="#009966"><strong>outer</strong></font>(xx, xx, <font color="#ff00cc">"</font><font color="#ff00cc">+</font><font color="#ff00cc">"</font>), 
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000"> 6 </font></span>                    <font color="#009966"><strong>diag</strong></font> <font color="#000000"><strong>=</strong></font> <font color="#006699"><strong>TRUE</strong></font>))
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000"> 7 </font></span>    z <font color="#000000"><strong>&lt;-</strong></font> <font color="#9900cc">z</font>[z <font color="#000000"><strong>&lt;=</strong></font> n]
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000"> 8 </font></span>    <font color="#009966"><strong>hist</strong></font>(z, <font color="#009966"><strong>plot</strong></font> <font color="#000000"><strong>=</strong></font> <font color="#006699"><strong>FALSE</strong></font>, 
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000"> 9 </font></span>         <font color="#0099ff"><strong>breaks</strong></font> <font color="#000000"><strong>=</strong></font> <font color="#009966"><strong>seq</strong></font>(<font color="#ff0000">4</font>, <font color="#009966"><strong>max</strong></font>(z), <font color="#009966"><strong>by</strong></font> <font color="#000000"><strong>=</strong></font> <font color="#ff0000">2</font>))$counts
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">10 </font></span><font color="#000000"><strong>}</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">11 </font></span>
</font></pre>

<p>As pointed out on the blog, although this is fast thanks to the clever vectorization of <code>outer</code>, there is some frustration of having to allocate a matrix of size N * N when you only need the upper triangle ( N*(N+1)/2 ). Furthermore, if we look in <code>outer</code>, we see that not only an N*N sized vector is created for the result (robj), but also for the vectors X and Y: </p>

<pre><font color="#000000"><span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">31 </font></span>        FUN <font color="#000000"><strong>&lt;-</strong></font> <font color="#009966"><strong>match.fun</strong></font>(FUN)
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">32 </font></span>        Y <font color="#000000"><strong>&lt;-</strong></font> <font color="#009966"><strong>rep</strong></font>(Y, <font color="#009966"><strong>rep.int</strong></font>(<font color="#009966"><strong>length</strong></font>(X), <font color="#009966"><strong>length</strong></font>(Y)))
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">33 </font></span>        <font color="#006699"><strong>if</strong></font> (<font color="#009966"><strong>length</strong></font>(X)) 
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">34 </font></span>            X <font color="#000000"><strong>&lt;-</strong></font> <font color="#009966"><strong>rep</strong></font>(X, times <font color="#000000"><strong>=</strong></font> <font color="#009966"><strong>ceiling</strong></font>(<font color="#009966"><strong>length</strong></font>(Y)<font color="#000000"><strong>/</strong></font><font color="#009966"><strong>length</strong></font>(X)))
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">35 </font></span>        robj <font color="#000000"><strong>&lt;-</strong></font> <font color="#ff0033">FUN</font>(X, Y, ...)
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">36 </font></span>        <font color="#009966"><strong>dim</strong></font>(robj) <font color="#000000"><strong>&lt;-</strong></font> <font color="#009966"><strong>c</strong></font>(dX, dY)
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">37 </font></span>    <font color="#000000"><strong>}</strong></font>
</font></pre>

<p>This reminded me of the fun we had a few years ago with a similar problem. See the <a href="http://wiki.r-project.org/rwiki/doku.php?id=tips:programming:code_optim2">R wiki</a> for a detailed optimization, and I am borrowing Tony Plate's idea for the <code>goldbach5</code> approach here. The idea is basically to figure out the indices of the upper triangle part of the matrix before calculating it: </p>

<pre><font color="#000000"><span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">12 </font></span>goldbach5 <font color="#000000"><strong>&lt;-</strong></font> <font color="#006699"><strong>function</strong></font>(n) <font color="#000000"><strong>{</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">13 </font></span>    xx <font color="#000000"><strong>&lt;-</strong></font> <font color="#ff0000">1</font> <font color="#000000"><strong>:</strong></font> n
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">14 </font></span>    xx <font color="#000000"><strong>&lt;-</strong></font> <font color="#9900cc">xx</font>[<font color="#ff0033">isprime</font>(xx) <font color="#000000"><strong>&gt;</strong></font> <font color="#ff0000">0</font>]
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">15 </font></span>    xx <font color="#000000"><strong>&lt;-</strong></font> <font color="#9900cc">xx</font>[<font color="#000000"><strong>-</strong></font><font color="#ff0000">1</font>]
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">16 </font></span>    
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">17 </font></span>    <font color="#ff9999">#</font><font color="#ff9999"> </font><font color="#ff9999">generates</font><font color="#ff9999"> </font><font color="#ff9999">row</font><font color="#ff9999"> </font><font color="#ff9999">indices</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">18 </font></span>    x <font color="#000000"><strong>&lt;-</strong></font> <font color="#006699"><strong>function</strong></font>(N)<font color="#000000"><strong>{</strong></font> 
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">19 </font></span>        <font color="#009966"><strong>rep.int</strong></font>( <font color="#ff0000">1</font><font color="#000000"><strong>:</strong></font>N, N<font color="#000000"><strong>:</strong></font><font color="#ff0000">1</font>) 
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">20 </font></span>    <font color="#000000"><strong>}</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">21 </font></span>    <font color="#ff9999">#</font><font color="#ff9999"> </font><font color="#ff9999">generates</font><font color="#ff9999"> </font><font color="#ff9999">column</font><font color="#ff9999"> </font><font color="#ff9999">indices</font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">22 </font></span>    y <font color="#000000"><strong>&lt;-</strong></font> <font color="#006699"><strong>function</strong></font>(N)<font color="#000000"><strong>{</strong></font> 
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">23 </font></span>        <font color="#009966"><strong>unlist</strong></font>( <font color="#009966"><strong>lapply</strong></font>( <font color="#ff0000">1</font><font color="#000000"><strong>:</strong></font>N, seq.int, to <font color="#000000"><strong>=</strong></font> N ) ) 
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">24 </font></span>    <font color="#000000"><strong>}</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">25 </font></span>    z <font color="#000000"><strong>&lt;-</strong></font> <font color="#9900cc">xx</font>[ <font color="#ff0033">x</font>(<font color="#009966"><strong>length</strong></font>(xx)) ] <font color="#000000"><strong>+</strong></font> <font color="#9900cc">xx</font>[ <font color="#ff0033">y</font>(<font color="#009966"><strong>length</strong></font>(xx)) ]
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">26 </font></span>    z <font color="#000000"><strong>&lt;-</strong></font> <font color="#9900cc">z</font>[z <font color="#000000"><strong>&lt;=</strong></font> n]
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">27 </font></span>    tz <font color="#000000"><strong>&lt;-</strong></font> <font color="#009966"><strong>tabulate</strong></font>(z, n )
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">28 </font></span>    <font color="#9900cc">tz</font>[ tz <font color="#000000"><strong>!=</strong></font> <font color="#ff0000">0</font> ]
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">29 </font></span><font color="#000000"><strong>}</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">30 </font></span>
</font></pre>


<p>This gives a further boost to the execution time (only really visible with large n)</p>

<pre>
&gt; system.time( out 
&gt; system.time( out 

<p>Let's take a look at the output from the profiler output for both functions</p>

<pre>
&gt; Rprof( "goldbach5.out" ); out  summaryRprof( "goldbach5.out" )$by.total
            total.time total.pct self.time self.pct
"goldbach5"       6.60     100.0      2.88     43.6
"&lt;="              1.60      24.2      1.60     24.2
"+"               0.72      10.9      0.72     10.9
".C"              0.48       7.3      0.48      7.3
"unlist"          0.48       7.3      0.30      4.5
"tabulate"        0.48       7.3      0.00      0.0
"y"               0.48       7.3      0.00      0.0
"rep.int"         0.36       5.5      0.36      5.5
"x"               0.36       5.5      0.00      0.0
"lapply"          0.18       2.7      0.18      2.7
".Call"           0.08       1.2      0.08      1.2
"isprime"         0.08       1.2      0.00      0.0

&gt; Rprof( "goldbach4.out" ); out  summaryRprof( "goldbach4.out" )$by.total
                 total.time total.pct self.time self.pct
"goldbach4"           31.60     100.0      1.28      4.1
"upperTriangle"       23.56      74.6      2.10      6.6
"upper.tri"           12.48      39.5      0.00      0.0
"outer"                8.98      28.4      7.38     23.4
"col"                  5.96      18.9      5.96     18.9
"row"                  5.40      17.1      5.40     17.1
"hist.default"         5.24      16.6      0.86      2.7
"hist"                 5.24      16.6      0.00      0.0
".C"                   3.98      12.6      3.98     12.6
"&lt;="                   2.02       6.4      2.02      6.4
"FUN"                  1.60       5.1      1.60      5.1
"as.numeric"           0.54       1.7      0.54      1.7
"max"                  0.22       0.7      0.22      0.7
"seq"                  0.22       0.7      0.00      0.0
"seq.default"          0.22       0.7      0.00      0.0
"is.finite"            0.16       0.5      0.16      0.5
".Call"                0.08       0.3      0.08      0.3
"isprime"              0.08       0.3      0.00      0.0
"sort.int"             0.02       0.1      0.02      0.1
"<anonymous>"          0.02       0.1      0.00      0.0
"median.default"       0.02       0.1      0.00      0.0
"sort"                 0.02       0.1      0.00      0.0
"sort.default"         0.02       0.1      0.00      0.0
</anonymous></pre>

<p>Or a graphical display (see <a href="http://wiki.r-project.org/rwiki/doku.php?id=tips:misc:profiling">the R wiki</a> for the perl script that makes the graph): </p>

<p>goldbach4</p>
<a href="/public/posts/goldbach/goldbach4.png"><img src="/public/posts/goldbach/goldbach4_m.jpg" alt="goldbach4.png" style="margin: 0 auto; display: block;" title="goldbach4.png, mar. 2009"></a>

<p>goldbach5</p>
<a href="/public/posts/goldbach/goldbach5.png"><img src="/public/posts/goldbach/goldbach5_m.jpg" alt="goldbach5.png" style="margin: 0 auto; display: block;" title="goldbach5.png, mar. 2009"></a>

<p>The question is now, can we go further. I believe we can, because we still allocate a lot of things we trash eventually, any takers ?</p></pre>
</div>
