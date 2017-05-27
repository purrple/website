---
title:   CPP package- exposing C++ objects
author: "Romain François"
date:  2009-12-22
slug:  CPP-package---exposing-C-objects
tags:  [ "cplusplus", "package", "R" ]
---
<div class="post-content">
<p>I've just started working on the new package <strong>CPP</strong>, as usual the project is maintained in <a href="http://r-forge.r-project.org/projects/cpp/">r-forge</a>. The package aims at exposing C++ classes at the R level, starting from classes from the c++ standard template library.</p>

<p>key to the package is the <strong>CPP</strong> function (much inspired from the <a href="http://finzi.psych.upenn.edu/R/library/rJava/html/J.html">J</a> function of rJava). The CPP function builds an S4 object of class "C++Class". The "C++Class" currently is a placeholder wrapping the C++ class name, and defines the <strong>new</strong> method (again this trick or making <code>new</code> S4 generic comes from rJava). For example to create an R object that wraps up a <strong>std::vector&lt;int&gt;</strong>, one would go like this: </p>

<pre>
x 

<p>This is no magic and don't expect to be able to send anything to CPP (C++ does not have reflection capabilities), currently only these classes are defined : <strong>std::vector&lt;int&gt;</strong>, <strong>vector&lt;double&gt;</strong>, <strong>vector&lt;raw&gt;</strong> and <strong>set&lt;int&gt;</strong></p>

<p>Because C++ does not offer reflection capabilities, we have to do something else to be able to invoke methods on the wrapped objects. Currently the approach that the package follows is a naming convention. The <code>$</code> method create the name of the C routine it wants to call based on the C++ class the object is wrapping, the name of the method, and the types of the input parameters. So for example calling the <code>size</code> method for a <code>vector&amp;lt:int&gt;</code> object yields this routine name: "vector_int____size", calling the <code>push_back</code> method of the <code>vector&lt;double&gt;</code>
class, passing an integer vector as the first parameter yields this signature : "vector_double____push_back___integer" .... (the CPP:::getRoutineSignature implements the convention)</p>

<p>Here is a full example using the <code>set&lt;int&gt;</code> class. <a href="http://www.cplusplus.com/reference/stl/set/">Sets</a> are a good example of a data structure that is not available in R. Basically it keeps its objects sorted</p>

<pre>
&gt; # create the object
&gt; x  # insert data using the insert method
&gt; # see : <a href="http://www.cplusplus.com/reference/stl/set/insert/">insert</a>
&gt; x$insert( sample( 1:20 ) )
&gt; # ask for the size of the set
&gt; x$size()
[1] 20
&gt; # bring it back as an R classic integer vector
&gt; as.vector( x )
 [1]  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20
</pre>

<p>Currently the package is my excuse to learn about the standard template library, and it is quite possible that the functionality will be merged into the <a href="http://dirk.eddelbuettel.com/code/rcpp.html">Rcpp</a> it currently depends on. Because of this volatility, I'll use the <a href="https://lists.r-forge.r-project.org/cgi-bin/mailman/listinfo/rcpp-devel">Rcpp-devel</a> mailing list instead of creating a new one.</p></pre>
</div>
