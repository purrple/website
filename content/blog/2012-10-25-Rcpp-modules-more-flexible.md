---
title:   Rcpp modules more flexible
author: "Romain François"
date:  2012-10-25
slug:  Rcpp-modules-more-flexible
tags:  [ "cplusplus", "R", "Rcpp" ]
---
<div class="post-content">

<p>
<a href="http://dirk.eddelbuettel.com/code/rcpp.html">Rcpp</a> modules just got more flexible (as of revision 3838 of Rcpp, to become 0.9.16 in the future).
</p>

<p>
modules have allowed exposing C++ classes for some time now, but developpers had to declare custom wrap and as specializations if they wanted their classes to be used as return type or argument type of a C++ function or method. This led to writing boilerplate code. The newest devel version allows for syntax like this:
</p>

<iframe src="/public/packages/Rcpp/Mod.cpp.html" width="500" height="650" frameborder="0" scrolling="none">Mod.cpp.html</iframe>

<p>The only thing the developper has to do is to declare the class using the macro RCPP_EXPOSED_CLASS. This will declare the appropriate class traits that Rcpp is using for internal implementations of as and wrap</p>

<p>One the example we can see three examples of the new functionality:</p>
<ul>
<li>
<strong>make_foo</strong> : this returns a Foo</li>
<li>
<strong>cloner</strong>: this returns a Foo*</li>
<li>
<strong>bla</strong>: uses a const Foo&amp; as argument</li>
</ul>
<br><br>
</div>
