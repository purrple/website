---
title:   RcppArmadillo 0.2.1
author: "Romain François"
date:  2010-05-19
slug:  RcppArmadillo-0.2.1
tags:  [ "cplusplus", "CRAN", "Rcpp" ]
---
<div class="post-content">
<h2>Armadillo</h2>

<p><a href="http://arma.sourceforge.net/">Armadillo</a> is a C++ linear algebra library aiming towards a good balance
between speed and ease of use. Integer, floating point and complex numbers
are supported, as well as a subset of trigonometric and statistics
functions. Various matrix decompositions are provided through optional
integration with LAPACK and ATLAS libraries.</p>

<p>A delayed evaluation approach is employed (during compile time) to combine
several operations into one and reduce (or eliminate) the need for
temporaries.  This is accomplished through recursive templates and template
meta-programming.</p>

<p>This library is useful if C++ has been decided as the language of choice
(due to speed and/or integration capabilities), rather than another language
like Matlab or Octave. It is distributed under a license that is useful in
both open-source and commercial contexts.</p>

<p>Armadillo is primarily developed by
<a href="http://www.itee.uq.edu.au/~conrad/">Conrad Sanderson</a> at
<a href="http://nicta.com.au/research/project_list">NICTA</a> (Australia),
with contributions from around the world.</p>


<h2>RcppArmadillo</h2>

<p><a href="http://dirk.eddelbuettel.com/code/rcpp.armadillo.html">RcppArmadillo</a>
is an R package that facilitates using Armadillo classes
in R packages through <a href="http://dirk.eddelbuettel.com/code/rcpp.html">Rcpp</a>.
It achieves the integration by extending Rcpp's
data interchange concepts to <a href="http://arma.sourceforge.net/">Armadillo</a> classes.</p>


<h2>Example</h2>

<p>Here is a simple implementation of a fast linear regression (provided by
RcppArmadillo via the
<a href="http://finzi.psych.upenn.edu/R/library/RcppArmadillo/html/fastLm.html">fastLm()</a> function):</p>

<iframe src="/public/packages/RcppArmadillo/fastlm.cpp.html" width="500" height="400"></iframe>

<p>Note however that you may not want to compute a linear regression fit this
way in order to protect from numerical inaccuracies on rank-deficient
problems. The help page for
<a href="http://finzi.psych.upenn.edu/R/library/RcppArmadillo/html/fastLm.html">fastLm()</a>
provides an example.</p>


<h2>Using RcppArmadillo in other packages</h2>

<p><a href="http://dirk.eddelbuettel.com/code/rcpp.armadillo.html">RcppArmadillo</a>
is designed so that its classes can be used from other packages. </p>

<p>Using RcppArmadillo requires: </p>

<ul>
<li>
<p>Using the header files provided by Rcpp and RcppArmadillo. This is
   typically achieved by adding this line in the DESCRIPTION file of the
   client package:</p>

<pre>LinkingTo : Rcpp, RcppArmadillo</pre>

   <p>and the following line in the package code:</p>

<pre>#include &lt;RcppArmadillo.h&gt;</pre>
</li>

<li>
<p>Linking against Rcpp dynamic or shared library and librairies needed
   by Armadillo, which is achieved by adding this line in the src/Makevars
   file of the client package</p>

<pre>
PKG_LIBS = $(shell $(R_HOME)/bin/Rscript -e "Rcpp:::LdFlags()" ) $(LAPACK_LIBS) $(BLAS_LIBS) $(FLIBS)
</pre>

   <p>and this line in the file src/Makevars.win:</p>

<pre>
PKG_LIBS = $(shell Rscript.exe -e "Rcpp:::LdFlags()") $(LAPACK_LIBS) $(BLAS_LIBS) $(FLIBS)
</pre>
</li>
</ul>
<p>RcppArmadillo contains a function
<a href="http://finzi.psych.upenn.edu/R/library/RcppArmadillo/html/RcppArmadillo.package.skeleton.html">RcppArmadillo.package.skeleton</a>, modelled
after package.skeleton from the utils package in base R, that creates a
skeleton of a package using RcppArmadillo, including example code.</p>


<h2>Quality Assurance</h2>

<p>RcppArmadillo uses the RUnit package by Matthias Burger et al to provide
unit testing. RcppArmadillo currently has 19 unit tests (called from 8 unit
test functions). </p>

<p>Source code for unit test functions are stored in the unitTests directory
of the installed package and the results are collected in the
<a href="http://cran.r-project.org/web/packages/RcppArmadillo/vignettes/RcppArmadillo-unitTests.pdf">RcppArmadillo-unitTests</a> vignette. </p>

<p>We run unit tests before sending the package to CRAN on as many systems as
possible, including Mac OSX (Snow Leopard), Debian, Ubuntu, Fedora 12
(64bit), Win 32 and Win64.</p>

<p>Unit tests can also be run from the installed package by executing</p>

<pre>RcppArmadillo:::test()</pre>

<p>where an output directory can be provided as an optional first argument.</p>


<h2>Links</h2>

<ul>
<li>Armadillo : <a href="http://arma.sourceforge.net/">http://arma.sourceforge.net/</a>  </li>
<li>RcppArmadillo main page: <a href="http://dirk.eddelbuettel.com/code/rcpp.armadillo.html">http://dirk.eddelbuettel.com/code/rcpp.armadillo.html</a>
</li>  
<li>R-forge Rcpp project page: <a href="http://r-forge.r-project.org/projects/rcpp/">http://r-forge.r-project.org/projects/rcpp/ </a>
</li>   
<li>Dirk's blog : <a href="http://dirk.eddelbuettel.com/blog/code/rcpp/">http://dirk.eddelbuettel.com/blog/code/rcpp/ </a>
</li>
<li>Romain's blog : <a href="/tags/RcppArmadillo">https://romain.rbind.io/tags/RcppArmadillo</a>
</li>
</ul>
<h2>Support</h2>

<p>Questions about RcppArmadillo should be directed to the Rcpp-devel mailing
list at
  <a href="https://lists.r-forge.r-project.org/cgi-bin/mailman/listinfo/rcpp-devel">https://lists.r-forge.r-project.org/cgi-bin/mailman/listinfo/rcpp-devel</a>
</p>

<p>Questions about Armadillo itself should be directed to its forum
<a href="http://sourceforge.net/apps/phpbb/arma/">http://sourceforge.net/apps/phpbb/arma/</a></p>


<pre> -- Romain Francois, Montpellier, France
    Dirk Eddelbuettel, Chicago, IL, USA
    Doug Bates, Madison, WI, USA

    May 2010
</pre>
</div>
