---
title:   C++ exceptions at the R level
author: "Romain François"
date:  2009-12-29
slug:  new-things-in-Rcpp
tags:  [ "cplusplus", "exception", "package", "R", "Rcpp" ]
---
<div class="post-content">
<style type="text/css">
pre{ solid black 1px;}
.warning{ font-size: bigger ; font-weight: bold ; border: 2px solid red ; background: yellow ; }
</style>
<div class="warning">
The feature described in this post is no longer valid with recent versions of Rcpp. Setting a terminate handler does not work reliably on windows, so we don't do it at all anymore. Exceptions need to be caught and relayed to R. Bracketing the code with BEGIN_RCPP / END_RCPP does it simply. See the Rcpp-introduction vignette for details.  
</div>

<p>I've recently offered an extra set of hands to <a href="http://dirk.eddelbuettel.com">Dirk</a> to work on the <a href="http://dirk.eddelbuettel.com/code/rcpp.html">Rcpp</a> package, this serves a good excuse to learn more about C++</p>

<p>Exception management was quite high on my list. C++ has nice exception handling (well not as nice as java, but nicer than C). </p>

<p>With previous versions of Rcpp, the idiom was to wrap up everything in a try/catch block and within the catch block, call the <code>Rf_error</code> function to send an R error, equivalent of calling stop. Now things have changed and, believe it or not, you can now catch a C++ exception at the R level, using the standard <a href="http://finzi.psych.upenn.edu/R/library/base/html/conditions.html">tryCatch</a> mechanism</p>, so for example when you <code>throw</code> a C++ exception (inheriting from the class <code>std::exception</code>) at the C++ level, and the exception is not picked up by the C++ code, it automatically sends an R condition that contain the message of the exception (what the <a href="http://gcc.gnu.org/onlinedocs/libstdc++/libstdc++-html-USERS-3.3/classstd_1_1exception.html#std_1_1ios__base_1_1failurea0">what</a> member function of std::exception gives) as well as the class of the exception (including namespace)

<p>This, combined with the new <a href="http://dirk.eddelbuettel.com/blog/2009/12/28#inline_0.3.4">inline</a> support for Rcpp, allows to run this code, (also available in the inst/examples/RcppInline directory of Rcpp)</p>

<pre><font color="#000000"><font color="#ff0000">require</font><font color="#000000"><strong>(</strong></font>Rcpp<font color="#000000"><strong>)</strong></font>
<font color="#ff0000">require</font><font color="#000000"><strong>(</strong></font>inline<font color="#000000"><strong>)</strong></font>
funx <font color="#000000"><strong>&lt;-</strong></font> <font color="#ff0000">cfunction</font><font color="#000000"><strong>(</strong></font><font color="#ff0000">signature</font><font color="#000000"><strong>(</strong></font><font color="#000000"><strong>)</strong></font>, <font color="#6666ff">'</font>
<font color="#6666ff">throw</font><font color="#6666ff"> </font><font color="#6666ff">std::range_error("boom")</font><font color="#6666ff"> </font><font color="#6666ff">;</font>
<font color="#6666ff">return</font><font color="#6666ff"> </font><font color="#6666ff">R_NilValue</font><font color="#6666ff"> </font><font color="#6666ff">;</font>
<font color="#6666ff">'</font>, Rcpp<font color="#000000"><strong>=</strong></font><font color="#cc00cc">TRUE</font>, verbose<font color="#000000"><strong>=</strong></font><font color="#cc00cc">FALSE</font><font color="#000000"><strong>)</strong></font>
</font></pre>

<p>Here, we create the <code>funx</code> "function" that compiles itself into a C++ function and gets dynamically linked into R (thanks to the inline package). The relevant thing (at least for this post) is the <code>throw</code> statement. We throw a C++ exception of class "std::range_error" with the message "boom", and what follows shows how to catch it at the R level:</p>

<pre><font color="#000000"><font color="#33cc00"><strong>tryCatch</strong></font><font color="#000000"><strong>(</strong></font>  <font color="#ff0000">funx</font><font color="#000000"><strong>(</strong></font><font color="#000000"><strong>)</strong></font>, <font color="#6666ff">"</font><font color="#6666ff">C++Error</font><font color="#6666ff">"</font> <font color="#000000"><strong>=</strong></font> <font color="#006699"><strong>function</strong></font><font color="#000000"><strong>(</strong></font>e<font color="#000000"><strong>)</strong></font><font color="#000000"><strong>{</strong></font>
    <font color="#ff0000">cat</font><font color="#000000"><strong>(</strong></font> <font color="#ff0000">sprintf</font><font color="#000000"><strong>(</strong></font> <font color="#6666ff">"</font><font color="#6666ff">C++</font><font color="#6666ff"> </font><font color="#6666ff">exception</font><font color="#6666ff"> </font><font color="#6666ff">of</font><font color="#6666ff"> </font><font color="#6666ff">class</font><font color="#6666ff"> </font><font color="#6666ff">'%s'</font><font color="#6666ff"> </font><font color="#6666ff">:</font><font color="#6666ff"> </font><font color="#6666ff">%s\n</font><font color="#6666ff">"</font>, <font color="#6633ff"><strong>class</strong></font><font color="#000000"><strong>(</strong></font>e<font color="#000000"><strong>)</strong></font><font color="#000000"><strong>[</strong></font>1L<font color="#000000"><strong>]</strong></font>, e<font color="#000000"><strong>$</strong></font>message  <font color="#000000"><strong>)</strong></font> <font color="#000000"><strong>)</strong></font>
<font color="#000000"><strong>}</strong></font> <font color="#000000"><strong>)</strong></font>
<font color="#a19d9d">#</font><font color="#a19d9d"> </font><font color="#a19d9d">or</font><font color="#a19d9d"> </font><font color="#a19d9d">using</font><font color="#a19d9d"> </font><font color="#a19d9d">a</font><font color="#a19d9d"> </font><font color="#a19d9d">direct</font><font color="#a19d9d"> </font><font color="#a19d9d">handler</font><font color="#a19d9d"> </font>
<font color="#33cc00"><strong>tryCatch</strong></font><font color="#000000"><strong>(</strong></font>  <font color="#ff0000">funx</font><font color="#000000"><strong>(</strong></font><font color="#000000"><strong>)</strong></font>, <font color="#6666ff">"</font><font color="#6666ff">std::range_error</font><font color="#6666ff">"</font> <font color="#000000"><strong>=</strong></font> <font color="#006699"><strong>function</strong></font><font color="#000000"><strong>(</strong></font>e<font color="#000000"><strong>)</strong></font><font color="#000000"><strong>{</strong></font>
        <font color="#ff0000">cat</font><font color="#000000"><strong>(</strong></font> <font color="#ff0000">sprintf</font><font color="#000000"><strong>(</strong></font> <font color="#6666ff">"</font><font color="#6666ff">C++</font><font color="#6666ff"> </font><font color="#6666ff">exception</font><font color="#6666ff"> </font><font color="#6666ff">of</font><font color="#6666ff"> </font><font color="#6666ff">class</font><font color="#6666ff"> </font><font color="#6666ff">'%s'</font><font color="#6666ff"> </font><font color="#6666ff">:</font><font color="#6666ff"> </font><font color="#6666ff">%s\n</font><font color="#6666ff">"</font>, <font color="#6633ff"><strong>class</strong></font><font color="#000000"><strong>(</strong></font>e<font color="#000000"><strong>)</strong></font><font color="#000000"><strong>[</strong></font>1L<font color="#000000"><strong>]</strong></font>, e<font color="#000000"><strong>$</strong></font>message  <font color="#000000"><strong>)</strong></font> <font color="#000000"><strong>)</strong></font>
<font color="#000000"><strong>}</strong></font> <font color="#000000"><strong>)</strong></font>
</font></pre>

<p>... et voila</p>

<p>Under the carpet, the <a href="http://gcc.gnu.org/onlinedocs/libstdc++/libstdc++-html-USERS-4.3/a01696.html">abi</a> unmangling namespace is at work, and the function that grabs the uncaught exceptions is much inspired from the verbose <a href="http://www.cs.huji.ac.il/~etsman/Docs/gcc-3.4-base/libstdc++/html/18_support/howto.html#4">terminate handler</a> that comes with the GCC</p>

<p>Part of this was inspired from the new java exception handling that came with the version 0.8-0 of <a href="http://www.rforge.net/rJava/news.html">rJava</a>, but cooked with C++ ingredients</p>
</div>
