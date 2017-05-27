---
title:   What functions are called by my function
author: "Romain François"
date:  2009-03-07
slug:  What-functions-are-called-by-my-function
tags:  [ "R" ]
---
<div class="post-content">
<style>
pre{
  font-size: xx-small !important;
  border: 1px solid black ;
}
</style>
<p>Quite often, it can be useful to identify which functions are being called by an R function. There are many ways to achieve this, such as for example massage the text representation of the function with regular expressions to basically find out what is just before round brackets. </p>

<p>The <code>codetools</code> package actually provides a much better way to do that, with the <code>walkCode</code> function.</p>

<style type="text/css">

.number{
	color: rgb(21,20,181) ;
}

.functioncall{
	color: red ;
}

.string{
	color: rgb(153,153,255) ;
}

.keyword{
	font-weight: bolder ;
	color: black;
}

.argument{
	color: rgb( 177,63,5) ;
}

.comment{
	color: rgb( 204,204,204) ;
}

.roxygencomment{
	color: rgb(0,151,255);
}

.formalargs{
	color: rgb(18,182,18);
}

.eqformalargs{
	color: rgb(18,182,18);
}

.assignement{
	font-weight: bolder;
	color: rgb(55,55,98);
}

.package{
	color: rgb(150,182,37);
}

.slot{
	font-style:italic;
}

.symbol{
	color: black ;
}

.prompt{
	color: black ;
}

</style>
<pre>
<span class="comment"># This program is free software: you can redistribute it and/or modify</span>
<span class="comment"># it under the terms of the GNU General Public License as published by</span>
<span class="comment"># the Free Software Foundation, either version 3 of the License, or</span>
<span class="comment"># (at your option) any later version.</span>
<span class="comment"># </span>
<span class="comment"># This program is distributed in the hope that it will be useful,</span>
<span class="comment"># but WITHOUT ANY WARRANTY; without even the implied warranty of</span>
<span class="comment"># MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the</span>
<span class="comment"># GNU General Public License for more details.</span>
<span class="comment"># </span>
<span class="comment"># You should have received a copy of the GNU General Public License</span>
<span class="comment"># along with this program.  If not, see <http:></http:>.</span>

<span class="roxygencomment">#' Gets the functions called by fun</span>
<span class="roxygencomment">#' </span>
<span class="roxygencomment">#' @param fun a function, or a character string</span>
<span class="roxygencomment">#' @return a named vector of occurences of each function, the values are </span>
<span class="roxygencomment">#'         the number of times and the names are the functions</span>
<span class="symbol">callees</span> <span class="assignement"> <span class="keyword">function</span><span class="keyword">(</span> <span class="formalargs">fun</span> <span class="keyword">)</span><span class="keyword">{</span>

    <span class="comment">## dump the function and read it back in the expression e</span>
    <span class="comment"># TODO: is there a better way</span>
    <span class="comment">#       If I just use body( fun ), I don't get the arguments</span>
    <span class="symbol">fun</span> <span class="assignement"> <span class="functioncall">match.fun</span><span class="keyword">(</span> <span class="symbol">fun</span> <span class="keyword">)</span>
    <span class="symbol">con</span> <span class="assignement"> <span class="functioncall">textConnection</span><span class="keyword">(</span> NULL<span class="keyword">,</span> <span class="argument">open</span> <span class="argument">=</span> <span class="string">"w"</span> <span class="keyword">)</span>
    <span class="functioncall">dump</span><span class="keyword">(</span> <span class="string">"fun"</span><span class="keyword">,</span> <span class="symbol">con</span> <span class="keyword">)</span>
    <span class="symbol">e</span> <span class="assignement"> <span class="functioncall">parse</span><span class="keyword">(</span> <span class="argument">text</span> <span class="argument">=</span> <span class="functioncall">textConnectionValue</span><span class="keyword">(</span><span class="symbol">con</span><span class="keyword">)</span> <span class="keyword">)</span><span class="keyword">[[</span><span class="number">1</span><span class="keyword">]</span><span class="keyword">]</span>
    <span class="functioncall">close</span><span class="keyword">(</span> <span class="symbol">con</span> <span class="keyword">)</span>


    <span class="comment"># initiate the functions vector whcih will be populated within</span>
    <span class="comment"># the code walker</span>
    <span class="symbol">functions</span> <span class="assignement"> NULL
    <span class="symbol">env</span> <span class="assignement"> <span class="functioncall">environment</span><span class="keyword">(</span><span class="keyword">)</span>

    <span class="comment"># a code walker (see package codetools) that records function calls</span>
    <span class="comment"># this is inspired from the code walker used by showTree</span>
    <span class="symbol">cw</span> <span class="assignement"> <span class="functioncall">makeCodeWalker</span> <span class="keyword">(</span>
        <span class="argument">call</span> <span class="argument">=</span> <span class="keyword">function</span> <span class="keyword">(</span><span class="formalargs">e</span><span class="keyword">,</span> <span class="formalargs">w</span><span class="keyword">)</span> <span class="keyword">{</span>
            <span class="keyword">if</span><span class="keyword">(</span> <span class="functioncall">is.null</span><span class="keyword">(</span><span class="symbol">e</span><span class="keyword">)</span> <span class="keyword">||</span> <span class="functioncall">length</span><span class="keyword">(</span><span class="symbol">e</span><span class="keyword">)</span> == <span class="number">0</span> <span class="keyword">)</span> <span class="functioncall">return</span><span class="keyword">(</span><span class="keyword">)</span>

            <span class="comment"># add the current function to the list</span>
            <span class="symbol">env</span><span class="symbol"></span><span class="keyword">[[</span><span class="string">"functions"</span><span class="keyword">]</span><span class="keyword">]</span> <span class="assignement">
                    <span class="functioncall">c</span><span class="keyword">(</span> <span class="symbol">env</span><span class="keyword">[[</span><span class="string">"functions"</span><span class="keyword">]</span><span class="keyword">]</span><span class="keyword">,</span> <span class="functioncall">as.character</span><span class="keyword">(</span><span class="symbol">e</span><span class="keyword">[[</span><span class="number">1</span><span class="keyword">]</span><span class="keyword">]</span><span class="keyword">)</span> <span class="keyword">)</span>

            <span class="comment"># process the list of expressions</span>
            <span class="symbol">w</span><span class="keyword">$</span><span class="functioncall">call.list</span><span class="keyword">(</span> <span class="symbol">e</span><span class="keyword">[</span><span class="keyword">-</span><span class="number">1</span><span class="keyword">]</span> <span class="keyword">,</span> <span class="symbol">w</span> <span class="keyword">)</span>

        <span class="keyword">}</span><span class="keyword">,</span>
        <span class="argument">leaf</span> <span class="argument">=</span> <span class="keyword">function</span><span class="keyword">(</span> <span class="formalargs">e</span><span class="keyword">,</span> <span class="formalargs">w</span> <span class="keyword">)</span><span class="keyword">{</span>
            <span class="comment"># deal with argument list of functions</span>
            <span class="keyword">if</span><span class="keyword">(</span> <span class="functioncall">typeof</span><span class="keyword">(</span> <span class="symbol">e</span> <span class="keyword">)</span> == <span class="string">"pairlist"</span> <span class="keyword">)</span><span class="keyword">{</span>
                <span class="symbol">w</span><span class="keyword">$</span><span class="functioncall">call.list</span><span class="keyword">(</span> <span class="symbol">e</span><span class="keyword">,</span> <span class="symbol">w</span> <span class="keyword">)</span>
            <span class="keyword">}</span>
        <span class="keyword">}</span><span class="keyword">,</span>
        <span class="argument">call.list</span> <span class="argument">=</span> <span class="keyword">function</span><span class="keyword">(</span> <span class="formalargs">e</span><span class="keyword">,</span> <span class="formalargs">w</span> <span class="keyword">)</span><span class="keyword">{</span>
            <span class="keyword">for</span><span class="keyword">(</span> <span class="symbol">a</span> <span class="keyword">in</span> <span class="functioncall">as.list</span><span class="keyword">(</span><span class="symbol">e</span><span class="keyword">)</span> <span class="keyword">)</span><span class="keyword">{</span>
                <span class="keyword">if</span><span class="keyword">(</span> <span class="keyword">!</span><span class="functioncall">missing</span><span class="keyword">(</span> <span class="symbol">a</span><span class="keyword">)</span> <span class="keyword">)</span><span class="keyword">{</span>
                    <span class="functioncall">walkCode</span><span class="keyword">(</span> <span class="symbol">a</span><span class="keyword">,</span> <span class="symbol">w</span> <span class="keyword">)</span>
                <span class="keyword">}</span>
            <span class="keyword">}</span>
        <span class="keyword">}</span><span class="keyword">,</span>
        <span class="argument">env</span> <span class="argument">=</span> <span class="symbol">env</span> <span class="comment"># so that we can populate "functions"</span>
    <span class="keyword">)</span>

    <span class="comment"># walk through the code with our code walker</span>
    <span class="functioncall">walkCode</span><span class="keyword">(</span> <span class="symbol">e</span><span class="keyword">,</span>  <span class="argument">w</span> <span class="argument">=</span> <span class="symbol">cw</span> <span class="keyword">)</span>

    <span class="comment"># clean the output</span>
    <span class="symbol">out</span> <span class="assignement"> <span class="functioncall">table</span><span class="keyword">(</span> <span class="symbol">functions</span> <span class="keyword">)</span>
    <span class="symbol">out</span><span class="keyword">[</span> <span class="functioncall">order</span><span class="keyword">(</span> <span class="functioncall">names</span><span class="keyword">(</span><span class="symbol">out</span><span class="keyword">)</span> <span class="keyword">)</span> <span class="keyword">]</span>

<span class="keyword">}</span>
</span></span></span></span></span></span></span></span></span></pre>


Let's try this on the <code>jitter</code> function:

<pre>
&gt; require( codetools )
&gt; source("http://romainfrancois.blog.free.fr/public/posts/callees/callees.R")
&gt; jitter
function (x, factor = 1, amount = NULL)
{
    if (length(x) == 0L)
        return(x)
    if (!is.numeric(x))
        stop("'x' must be numeric")
    z 
&gt; callees( jitter )
functions
        </pre>
</div>
