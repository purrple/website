---
title:   with semantics for java objects in rJava
author: "Romain François"
date:  2009-06-17
slug:  with-semantics-for-java-objects-in-rJava
tags:  [ "java", "R", "rJava" ]
---
<div class="post-content">
<style>
pre{
font-size: x-small !important; 
border: 1px solid black; 
}
</style>
<p>I've been playing with the <a href="http://www.rforge.net/rJava/">rJava</a> package recently. In a nutshell, rJava lets you create java objects and call methods on them from within the R console</p>

<pre><font color="#000000">col <font color="#000000"><strong>&lt;-</strong></font> <font color="#ff0000">.jnew</font><font color="#000000"><strong>(</strong></font> <font color="#ff00cc">"</font><font color="#ff00cc">java/awt/Color</font><font color="#ff00cc">"</font>, 255L, 0L, 0L <font color="#000000"><strong>)</strong></font>
<font color="#ff0000">.jcall</font><font color="#000000"><strong>(</strong></font> col, <font color="#ff00cc">"</font><font color="#ff00cc">I</font><font color="#ff00cc">"</font>, <font color="#ff00cc">"</font><font color="#ff00cc">getRed</font><font color="#ff00cc">"</font> <font color="#000000"><strong>)</strong></font>
<font color="#ff9999">#</font><font color="#ff9999"> </font><font color="#ff9999">[1]</font><font color="#ff9999"> </font><font color="#ff9999">255</font>
col<font color="#000000"><strong>$</strong></font><font color="#ff0000">getRed</font><font color="#000000"><strong>(</strong></font><font color="#000000"><strong>)</strong></font>
<font color="#ff9999">#</font><font color="#ff9999"> </font><font color="#ff9999">[1]</font><font color="#ff9999"> </font><font color="#ff9999">255</font>
</font>
</pre>

<p>The first call uses the regular function <code>.jcall</code> together with the <code>JNI</code> notation to call the <code>getRed</code> method of the created color, the second uses what <code>rJava</code> calls <em>syntactic</em> sugar, so that fields and methods of the object are accessed with the convenient R friendly dollar notation, great !!!</p>

<p>Here, I am just trying to add cream to make the coffee more tasty, by implementing the <code>with</code> method for java object</p>

<pre><font color="#000000"><font color="#ff9999">#</font><font color="#ff9999"> </font><font color="#ff9999">This</font><font color="#ff9999"> </font><font color="#ff9999">program</font><font color="#ff9999"> </font><font color="#ff9999">is</font><font color="#ff9999"> </font><font color="#ff9999">free</font><font color="#ff9999"> </font><font color="#ff9999">software:</font><font color="#ff9999"> </font><font color="#ff9999">you</font><font color="#ff9999"> </font><font color="#ff9999">can</font><font color="#ff9999"> </font><font color="#ff9999">redistribute</font><font color="#ff9999"> </font><font color="#ff9999">it</font><font color="#ff9999"> </font><font color="#ff9999">and/or</font><font color="#ff9999"> </font><font color="#ff9999">modify</font>
<font color="#ff9999">#</font><font color="#ff9999"> </font><font color="#ff9999">it</font><font color="#ff9999"> </font><font color="#ff9999">under</font><font color="#ff9999"> </font><font color="#ff9999">the</font><font color="#ff9999"> </font><font color="#ff9999">terms</font><font color="#ff9999"> </font><font color="#ff9999">of</font><font color="#ff9999"> </font><font color="#ff9999">the</font><font color="#ff9999"> </font><font color="#ff9999">GNU</font><font color="#ff9999"> </font><font color="#ff9999">General</font><font color="#ff9999"> </font><font color="#ff9999">Public</font><font color="#ff9999"> </font><font color="#ff9999">License</font><font color="#ff9999"> </font><font color="#ff9999">as</font><font color="#ff9999"> </font><font color="#ff9999">published</font><font color="#ff9999"> </font><font color="#ff9999">by</font>
<font color="#ff9999">#</font><font color="#ff9999"> </font><font color="#ff9999">the</font><font color="#ff9999"> </font><font color="#ff9999">Free</font><font color="#ff9999"> </font><font color="#ff9999">Software</font><font color="#ff9999"> </font><font color="#ff9999">Foundation,</font><font color="#ff9999"> </font><font color="#ff9999">either</font><font color="#ff9999"> </font><font color="#ff9999">version</font><font color="#ff9999"> </font><font color="#ff9999">2</font><font color="#ff9999"> </font><font color="#ff9999">of</font><font color="#ff9999"> </font><font color="#ff9999">the</font><font color="#ff9999"> </font><font color="#ff9999">License,</font><font color="#ff9999"> </font><font color="#ff9999">or</font>
<font color="#ff9999">#</font><font color="#ff9999"> </font><font color="#ff9999">(at</font><font color="#ff9999"> </font><font color="#ff9999">your</font><font color="#ff9999"> </font><font color="#ff9999">option)</font><font color="#ff9999"> </font><font color="#ff9999">any</font><font color="#ff9999"> </font><font color="#ff9999">later</font><font color="#ff9999"> </font><font color="#ff9999">version.</font>
<font color="#ff9999">#</font><font color="#ff9999"> </font>
<font color="#ff9999">#</font><font color="#ff9999"> </font><font color="#ff9999">This</font><font color="#ff9999"> </font><font color="#ff9999">program</font><font color="#ff9999"> </font><font color="#ff9999">is</font><font color="#ff9999"> </font><font color="#ff9999">distributed</font><font color="#ff9999"> </font><font color="#ff9999">in</font><font color="#ff9999"> </font><font color="#ff9999">the</font><font color="#ff9999"> </font><font color="#ff9999">hope</font><font color="#ff9999"> </font><font color="#ff9999">that</font><font color="#ff9999"> </font><font color="#ff9999">it</font><font color="#ff9999"> </font><font color="#ff9999">will</font><font color="#ff9999"> </font><font color="#ff9999">be</font><font color="#ff9999"> </font><font color="#ff9999">useful,</font>
<font color="#ff9999">#</font><font color="#ff9999"> </font><font color="#ff9999">but</font><font color="#ff9999"> </font><font color="#ff9999">WITHOUT</font><font color="#ff9999"> </font><font color="#ff9999">ANY</font><font color="#ff9999"> </font><font color="#ff9999">WARRANTY;</font><font color="#ff9999"> </font><font color="#ff9999">without</font><font color="#ff9999"> </font><font color="#ff9999">even</font><font color="#ff9999"> </font><font color="#ff9999">the</font><font color="#ff9999"> </font><font color="#ff9999">implied</font><font color="#ff9999"> </font><font color="#ff9999">warranty</font><font color="#ff9999"> </font><font color="#ff9999">of</font>
<font color="#ff9999">#</font><font color="#ff9999"> </font><font color="#ff9999">MERCHANTABILITY</font><font color="#ff9999"> </font><font color="#ff9999">or</font><font color="#ff9999"> </font><font color="#ff9999">FITNESS</font><font color="#ff9999"> </font><font color="#ff9999">FOR</font><font color="#ff9999"> </font><font color="#ff9999">A</font><font color="#ff9999"> </font><font color="#ff9999">PARTICULAR</font><font color="#ff9999"> </font><font color="#ff9999">PURPOSE.</font><font color="#ff9999"> </font><font color="#ff9999"> </font><font color="#ff9999">See</font><font color="#ff9999"> </font><font color="#ff9999">the</font>
<font color="#ff9999">#</font><font color="#ff9999"> </font><font color="#ff9999">GNU</font><font color="#ff9999"> </font><font color="#ff9999">General</font><font color="#ff9999"> </font><font color="#ff9999">Public</font><font color="#ff9999"> </font><font color="#ff9999">License</font><font color="#ff9999"> </font><font color="#ff9999">for</font><font color="#ff9999"> </font><font color="#ff9999">more</font><font color="#ff9999"> </font><font color="#ff9999">details.</font>
<font color="#ff9999">#</font><font color="#ff9999"> </font>
<font color="#ff9999">#</font><font color="#ff9999"> </font><font color="#ff9999">You</font><font color="#ff9999"> </font><font color="#ff9999">should</font><font color="#ff9999"> </font><font color="#ff9999">have</font><font color="#ff9999"> </font><font color="#ff9999">received</font><font color="#ff9999"> </font><font color="#ff9999">a</font><font color="#ff9999"> </font><font color="#ff9999">copy</font><font color="#ff9999"> </font><font color="#ff9999">of</font><font color="#ff9999"> </font><font color="#ff9999">the</font><font color="#ff9999"> </font><font color="#ff9999">GNU</font><font color="#ff9999"> </font><font color="#ff9999">General</font><font color="#ff9999"> </font><font color="#ff9999">Public</font><font color="#ff9999"> </font><font color="#ff9999">License</font>
<font color="#ff9999">#</font><font color="#ff9999"> </font><font color="#ff9999">along</font><font color="#ff9999"> </font><font color="#ff9999">with</font><font color="#ff9999"> </font><font color="#ff9999">this</font><font color="#ff9999"> </font><font color="#ff9999">program.</font><font color="#ff9999"> </font><font color="#ff9999"> </font><font color="#ff9999">If</font><font color="#ff9999"> </font><font color="#ff9999">not,</font><font color="#ff9999"> </font><font color="#ff9999">see</font><font color="#ff9999"> </font><font color="#ff9999">&lt;http://www.gnu.org/licenses/&gt;.</font>

with.jobjRef <font color="#000000"><strong>&lt;-</strong></font> <font color="#006699"><strong>function</strong></font><font color="#000000"><strong>(</strong></font> data, expr, ...<font color="#000000"><strong>)</strong></font><font color="#000000"><strong>{</strong></font>
    
    env <font color="#000000"><strong>&lt;-</strong></font> <font color="#ff0000">new.env</font><font color="#000000"><strong>(</strong></font> <font color="#000000"><strong>)</strong></font>
    clazz <font color="#000000"><strong>&lt;-</strong></font> <font color="#ff0000">.jcall</font><font color="#000000"><strong>(</strong></font> data, <font color="#ff00cc">"</font><font color="#ff00cc">Ljava/lang/Class;</font><font color="#ff00cc">"</font>, <font color="#ff00cc">"</font><font color="#ff00cc">getClass</font><font color="#ff00cc">"</font><font color="#000000"><strong>)</strong></font>
    fields <font color="#000000"><strong>&lt;-</strong></font> <font color="#ff0000">.jcall</font><font color="#000000"><strong>(</strong></font> clazz, 
        <font color="#ff00cc">"</font><font color="#ff00cc">[Ljava/lang/reflect/Field;</font><font color="#ff00cc">"</font>, <font color="#ff00cc">"</font><font color="#ff00cc">getFields</font><font color="#ff00cc">"</font> <font color="#000000"><strong>)</strong></font>
    <font color="#6600cc"><strong><em>lapply</em></strong></font><font color="#000000"><strong>(</strong></font> fields, <font color="#006699"><strong>function</strong></font><font color="#000000"><strong>(</strong></font>x <font color="#000000"><strong>)</strong></font><font color="#000000"><strong>{</strong></font>
        n <font color="#000000"><strong>&lt;-</strong></font> <font color="#ff0000">.jcall</font><font color="#000000"><strong>(</strong></font> x, <font color="#ff00cc">"</font><font color="#ff00cc">S</font><font color="#ff00cc">"</font>, <font color="#ff00cc">"</font><font color="#ff00cc">getName</font><font color="#ff00cc">"</font> <font color="#000000"><strong>)</strong></font>
        <font color="#ff0000">makeActiveBinding</font><font color="#000000"><strong>(</strong></font> n, <font color="#006699"><strong>function</strong></font><font color="#000000"><strong>(</strong></font>v<font color="#000000"><strong>)</strong></font><font color="#000000"><strong>{</strong></font>
            <font color="#006699"><strong>if</strong></font><font color="#000000"><strong>(</strong></font> <font color="#ff0000">missing</font><font color="#000000"><strong>(</strong></font>v<font color="#000000"><strong>)</strong></font> <font color="#000000"><strong>)</strong></font><font color="#000000"><strong>{</strong></font>
                <font color="#ff9999">#</font><font color="#ff9999"> </font><font color="#ff9999">get</font><font color="#ff9999"> </font>
                <font color="#ff0000">.jsimplify</font><font color="#000000"><strong>(</strong></font> <font color="#ff0000">.jcall</font><font color="#000000"><strong>(</strong></font> x, <font color="#ff00cc">"</font><font color="#ff00cc">Ljava/lang/Object;</font><font color="#ff00cc">"</font>, <font color="#ff00cc">"</font><font color="#ff00cc">get</font><font color="#ff00cc">"</font>, <font color="#ff0000">.jcast</font><font color="#000000"><strong>(</strong></font> data <font color="#000000"><strong>)</strong></font> <font color="#000000"><strong>)</strong></font> <font color="#000000"><strong>)</strong></font>
            <font color="#000000"><strong>}</strong></font> <font color="#006699"><strong>else</strong></font> <font color="#000000"><strong>{</strong></font>
                <font color="#ff0000">.jfield</font><font color="#000000"><strong>(</strong></font> data, n <font color="#000000"><strong>)</strong></font> <font color="#000000"><strong>&lt;-</strong></font> v
            <font color="#000000"><strong>}</strong></font>
        <font color="#000000"><strong>}</strong></font>, env <font color="#000000"><strong>)</strong></font> 
    <font color="#000000"><strong>}</strong></font> <font color="#000000"><strong>)</strong></font>
    <font color="#6633ff"><strong>methods</strong></font> <font color="#000000"><strong>&lt;-</strong></font> <font color="#ff0000">.jcall</font><font color="#000000"><strong>(</strong></font> clazz, 
        <font color="#ff00cc">"</font><font color="#ff00cc">[Ljava/lang/reflect/Method;</font><font color="#ff00cc">"</font>, <font color="#ff00cc">"</font><font color="#ff00cc">getMethods</font><font color="#ff00cc">"</font> <font color="#000000"><strong>)</strong></font>
    <font color="#6600cc"><strong><em>lapply</em></strong></font><font color="#000000"><strong>(</strong></font> <font color="#6633ff"><strong>methods</strong></font>, <font color="#006699"><strong>function</strong></font><font color="#000000"><strong>(</strong></font>m<font color="#000000"><strong>)</strong></font><font color="#000000"><strong>{</strong></font>
        n <font color="#000000"><strong>&lt;-</strong></font> <font color="#ff0000">.jcall</font><font color="#000000"><strong>(</strong></font> m, <font color="#ff00cc">"</font><font color="#ff00cc">S</font><font color="#ff00cc">"</font>, <font color="#ff00cc">"</font><font color="#ff00cc">getName</font><font color="#ff00cc">"</font> <font color="#000000"><strong>)</strong></font>
        <font color="#006699"><strong>assign</strong></font><font color="#000000"><strong>(</strong></font> n, <font color="#006699"><strong>function</strong></font><font color="#000000"><strong>(</strong></font>...<font color="#000000"><strong>)</strong></font><font color="#000000"><strong>{</strong></font>
            <font color="#ff0000">.jrcall</font><font color="#000000"><strong>(</strong></font> data, n, ...<font color="#000000"><strong>)</strong></font> 
        <font color="#000000"><strong>}</strong></font>, env <font color="#000000"><strong>=</strong></font> env <font color="#000000"><strong>)</strong></font>
    <font color="#000000"><strong>}</strong></font> <font color="#000000"><strong>)</strong></font>
    <font color="#006699"><strong>assign</strong></font><font color="#000000"><strong>(</strong></font> <font color="#ff00cc">"</font><font color="#ff00cc">this</font><font color="#ff00cc">"</font>, data, env <font color="#000000"><strong>=</strong></font> env <font color="#000000"><strong>)</strong></font>
    <font color="#006699"><strong>eval</strong></font><font color="#000000"><strong>(</strong></font> <font color="#006699"><strong>substitute</strong></font><font color="#000000"><strong>(</strong></font> expr <font color="#000000"><strong>)</strong></font>, env <font color="#000000"><strong>=</strong></font> env <font color="#000000"><strong>)</strong></font>
<font color="#000000"><strong>}</strong></font>

</font></pre>

<p>This allows to call several methods on the same object, for example: </p>

<pre>
&gt; with( col, {
+   cat( "red = ", getRed(), "\n" )
+   cat( "green = ", getGreen(), "\n" )
+   cat( "blue = ", getBlue(), "\n" )
+ })
red =  255 
green =  0 
blue =  0 
&gt; p  with( p, {
+   move( 40L , 50L )
+   x  p
[1] "Java-Object{java.awt.Point[x=50,y=50]}"
</pre>

<p>Note in the last example that the x variable that is assigned is the "x" field of the object</p>
</div>
