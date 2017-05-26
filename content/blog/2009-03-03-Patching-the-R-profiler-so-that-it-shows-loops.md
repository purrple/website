---
title:   Patching the R profiler so that it shows loops
author: "Romain François"
date:  2009-03-03
slug:  Patching-the-R-profiler-so-that-it-shows-loops
tags:  [ "profiling", "R" ]
---
<div class="post-content">
<style>
pre{ 
font-size: xx-small !important; 
border: 1px solid black; 
}
</style>
<h3>The R profiler</h3>

<p>The R profiler is an amazing way to find where in your code (or someone else's code) lies some inefficiency. For example, the profiler helped in this <a href="http://wiki.r-project.org/rwiki/doku.php?id=tips:programming:code_optim2&amp;s=challenge">challenge</a> on the R wiki. See also the profiling section on the <a href="Writing%20R%20Extensions">http://cran.r-project.org/doc/manuals/R-exts.html#Profiling-R-code-for-speed</a> document</p>

<h3>What is wrong with it</h3>

<p>The profiler, however, is not able to trace uses of loops (for, while or repeat), and consequently will not identify loops as the cause of ineffiency of the code. This is a shame, because loops in R are usually closely related to inefficiency. For example, if we profile this code: </p>

<pre><font color="#000000"><span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">1 </font></span><font color="#009966"><strong>Rprof</strong></font>( )
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">2 </font></span>x <font color="#000000"><strong>&lt;-</strong></font> <font color="#009966"><strong>numeric</strong></font>( )
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">3 </font></span>    <font color="#006699"><strong>for</strong></font>( i <font color="#006699"><strong>in</strong></font> <font color="#ff0000">1</font><font color="#000000"><strong>:</strong></font><font color="#ff0000">10000</font>)<font color="#000000"><strong>{</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">4 </font></span>      x <font color="#000000"><strong>&lt;-</strong></font> <font color="#009966"><strong>c</strong></font>( x, <font color="#009966"><strong>rnorm</strong></font>(<font color="#ff0000">10</font>) )
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">5 </font></span>    <font color="#000000"><strong>}</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">6 </font></span><font color="#009966"><strong>Rprof</strong></font>( <font color="#006699"><strong>NULL</strong></font> )
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">7 </font></span><font color="#009966"><strong>print</strong></font>( <font color="#009966"><strong>summaryRprof</strong></font>( ) )
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">8 </font></span>
</font></pre>

we get : 

<pre>
$ time Rscript script1.R 
$by.self
        self.time self.pct total.time total.pct
"rnorm"      0.16      100       0.16       100

$by.total
        total.time total.pct self.time self.pct
"rnorm"       0.16       100      0.16      100

$sampling.time
[1] 0.16


real	0m7.043s
user	0m5.170s
sys	0m0.675s
</pre>

<p>So the profiler only reports about 0.22 seconds, when the actual time taken is more about 5 seconds. We can show that by wrapping the entire for loop in a function: </p>

<pre><font color="#000000"><span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   1 </font></span><font color="#009966"><strong>Rprof</strong></font>( )
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   2 </font></span>ffor <font color="#000000"><strong>&lt;-</strong></font> <font color="#006699"><strong>function</strong></font>()<font color="#000000"><strong>{</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   3 </font></span>    x <font color="#000000"><strong>&lt;-</strong></font> <font color="#009966"><strong>numeric</strong></font>( )
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   4 </font></span>    <font color="#006699"><strong>for</strong></font>( i <font color="#006699"><strong>in</strong></font> <font color="#ff0000">1</font><font color="#000000"><strong>:</strong></font><font color="#ff0000">10000</font>)<font color="#000000"><strong>{</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">   5 </font></span>      x <font color="#000000"><strong>&lt;-</strong></font> <font color="#009966"><strong>c</strong></font>( x, <font color="#009966"><strong>rnorm</strong></font>(<font color="#ff0000">10</font>) )
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   6 </font></span>    <font color="#000000"><strong>}</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   7 </font></span><font color="#000000"><strong>}</strong></font> 
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   8 </font></span><font color="#ff0033">ffor</font>()
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">   9 </font></span><font color="#009966"><strong>Rprof</strong></font>( <font color="#006699"><strong>NULL</strong></font> )
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">  10 </font></span><font color="#009966"><strong>print</strong></font>( <font color="#009966"><strong>summaryRprof</strong></font>( ) )
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">  11 </font></span>
</font></pre>

<p>which gives this :</p>

<pre>
$ time Rscript script2.R 
$by.self
        self.time self.pct total.time total.pct
"ffor"       5.14     96.3       5.34     100.0
"rnorm"      0.20      3.7       0.20       3.7

$by.total
        total.time total.pct self.time self.pct
"ffor"        5.34     100.0      5.14     96.3
"rnorm"       0.20       3.7      0.20      3.7

$sampling.time
[1] 5.34


real	0m6.434s
user	0m5.151s
sys	0m0.698s
</pre>

<p>The <code>ffor</code> function takes 100 pourcent of the times, and <code>rnorm</code> takes only 3.7 percent of the time, instead of 100 percent, which would be the conclusion of the first example.</p>

<p>But in real life, it is not possible to wrap every loop in a function as this will massively break a lot of code. Instead, we could make the profiler aware of loops. This is the purpose of the <a href="http://www.nabble.com/profiler-and-loops-td22307982.html">patch</a> I posted to R-devel</p>

<h3>The details of the implementation</h3>

<p>The patch actually only takes place in (several places of) the file <a href="https://svn.r-project.org/R/trunk/src/main/eval.c">eval.c</a></p>

<p>In the <code>do_for</code> function, a context is created for the "for" loop, using the <code>begincontext</code> function: </p>

<pre><font color="#000000"><span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">1033 </font></span>    <font color="#ff0033">begincontext</font><font color="#000000"><strong>(</strong></font><font color="#000000"><strong>&amp;</strong></font>cntxt<font color="#000000"><strong>,</strong></font> CTXT_LOOP<font color="#000000"><strong>,</strong></font> R_NilValue<font color="#000000"><strong>,</strong></font> rho<font color="#000000"><strong>,</strong></font> R_BaseEnv<font color="#000000"><strong>,</strong></font> R_NilValue<font color="#000000"><strong>,</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">1034 </font></span>         <font color="#ff0033">mkChar</font><font color="#000000"><strong>(</strong></font><font color="#ff00cc">"</font><font color="#ff00cc">[for]</font><font color="#ff00cc">"</font><font color="#000000"><strong>)</strong></font> <font color="#000000"><strong>)</strong></font><font color="#000000"><strong>;</strong></font>
</font></pre>

<p>The change here appears on the second line and simply adds a bit of information to the context that is created, similar changes are also made on the functions <code>do_repeat</code> and <code>do_while</code>.</p>

<p>Next, we need to grab this information at each tick of the profiler, which is the job of the <code>doprof</code> function: </p>

<pre><font color="#000000"><span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">168 </font></span>    <font color="#006699"><strong>if</strong></font> <font color="#000000"><strong>(</strong></font><font color="#000000"><strong>(</strong></font>cptr<font color="#000000"><strong>-</strong></font><font color="#000000"><strong>&gt;</strong></font>callflag <font color="#000000"><strong>&amp;</strong></font> <font color="#000000"><strong>(</strong></font>CTXT_FUNCTION <font color="#000000"><strong>|</strong></font> CTXT_BUILTIN<font color="#000000"><strong>)</strong></font><font color="#000000"><strong>)</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">169 </font></span>        <font color="#000000"><strong>&amp;</strong></font><font color="#000000"><strong>&amp;</strong></font> <font color="#ff0033">TYPEOF</font><font color="#000000"><strong>(</strong></font>cptr<font color="#000000"><strong>-</strong></font><font color="#000000"><strong>&gt;</strong></font>call<font color="#000000"><strong>)</strong></font> <font color="#000000"><strong>=</strong></font><font color="#000000"><strong>=</strong></font> LANGSXP<font color="#000000"><strong>)</strong></font> <font color="#000000"><strong>{</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">170 </font></span>        SEXP fun <font color="#000000"><strong>=</strong></font> <font color="#ff0033">CAR</font><font color="#000000"><strong>(</strong></font>cptr<font color="#000000"><strong>-</strong></font><font color="#000000"><strong>&gt;</strong></font>call<font color="#000000"><strong>)</strong></font><font color="#000000"><strong>;</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">171 </font></span>        <font color="#006699"><strong>if</strong></font> <font color="#000000"><strong>(</strong></font><font color="#000000"><strong>!</strong></font>newline<font color="#000000"><strong>)</strong></font> newline <font color="#000000"><strong>=</strong></font> <font color="#ff0000">1</font><font color="#000000"><strong>;</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">172 </font></span>        <font color="#ff0033">fprintf</font><font color="#000000"><strong>(</strong></font>R_ProfileOutfile<font color="#000000"><strong>,</strong></font> <font color="#ff00cc">"</font><font color="#ff00cc">\"%s\"</font><font color="#ff00cc"> </font><font color="#ff00cc">"</font><font color="#000000"><strong>,</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">173 </font></span>            <font color="#ff0033">TYPEOF</font><font color="#000000"><strong>(</strong></font>fun<font color="#000000"><strong>)</strong></font> <font color="#000000"><strong>=</strong></font><font color="#000000"><strong>=</strong></font> SYMSXP <font color="#000000"><strong>?</strong></font> <font color="#ff0033">CHAR</font><font color="#000000"><strong>(</strong></font><font color="#ff0033">PRINTNAME</font><font color="#000000"><strong>(</strong></font>fun<font color="#000000"><strong>)</strong></font><font color="#000000"><strong>)</strong></font> <font color="#000000"><strong>:</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">174 </font></span>            <font color="#ff00cc">"</font><font color="#ff00cc">&lt;Anonymous&gt;</font><font color="#ff00cc">"</font><font color="#000000"><strong>)</strong></font><font color="#000000"><strong>;</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#990066">175 </font></span>    <font color="#000000"><strong>}</strong></font> <font color="#006699"><strong>else</strong></font> <font color="#006699"><strong>if</strong></font><font color="#000000"><strong>(</strong></font> <font color="#000000"><strong>(</strong></font>cptr<font color="#000000"><strong>-</strong></font><font color="#000000"><strong>&gt;</strong></font>callflag <font color="#000000"><strong>&amp;</strong></font> CTXT_LOOP<font color="#000000"><strong>)</strong></font> <font color="#000000"><strong>)</strong></font><font color="#000000"><strong>{</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">176 </font></span>      <font color="#006699"><strong>if</strong></font> <font color="#000000"><strong>(</strong></font><font color="#000000"><strong>!</strong></font>newline<font color="#000000"><strong>)</strong></font> newline <font color="#000000"><strong>=</strong></font> <font color="#ff0000">1</font><font color="#000000"><strong>;</strong></font>
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">177 </font></span>      <font color="#ff0033">fprintf</font><font color="#000000"><strong>(</strong></font>R_ProfileOutfile<font color="#000000"><strong>,</strong></font> <font color="#ff00cc">"</font><font color="#ff00cc">\"%s\"</font><font color="#ff00cc"> </font><font color="#ff00cc">"</font><font color="#000000"><strong>,</strong></font> <font color="#ff0033">CHAR</font><font color="#000000"><strong>(</strong></font>cptr<font color="#000000"><strong>-</strong></font><font color="#000000"><strong>&gt;</strong></font>callfun<font color="#000000"><strong>)</strong></font> <font color="#000000"><strong>)</strong></font><font color="#000000"><strong>;</strong></font>  
<span style="background:#dbdbdb; border-right:solid 2px black; margin-right:5px; "><font color="#000000">178 </font></span>    <font color="#000000"><strong>}</strong></font>
</font></pre>

<p>The else branch will be executed when the context is a a loop context, and we just retrieve the callfun string we created in the <code>do_for</code> function. </p>

<p>Now, with this R patched, and compiled, Rprof is able to record loops</p>

<pre>
[]$ /home/romain/workspace/R-trunk/bin/Rscript script1.R
$by.self
        self.time self.pct total.time total.pct
"[for]"      5.28     97.4       5.42     100.0
"rnorm"      0.14      2.6       0.14       2.6

$by.total
        total.time total.pct self.time self.pct
"[for]"       5.42     100.0      5.28     97.4
"rnorm"       0.14       2.6      0.14      2.6

$sampling.time
[1] 5.42

[]$ head Rprof.out 
sample.interval=20000
"[for]" 
"[for]" 
"[for]" 
"rnorm" "[for]" 
"[for]" 
"[for]" 
"[for]" 
"[for]" 
"[for]" 
</pre>
</div>
