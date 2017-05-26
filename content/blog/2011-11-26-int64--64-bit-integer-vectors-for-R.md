---
title:   int64- 64 bit integer vectors for R
author: "Romain François"
date:  2011-11-26
slug:  int64--64-bit-integer-vectors-for-R
tags:  [ "cplusplus", "CRAN", "int64", "package", "R", "Rcpp", "RProtoBuf" ]
---
<div class="post-content">
<a href="http://cran.r-project.org/web/packages/int64/index.html"><img src="/public/packages/int64/google-64.png" alt="google-64.png" style="margin: 0 auto; display: block;" title="google-64.png, nov. 2011"></a>

<p>The <a href="http://code.google.com/opensource/">Google Open Source Programs Office</a> sponsored me to create the new <a href="http://cran.r-project.org/web/packages/int64/index.html">int64</a> package that has been released to CRAN a few days ago. The package has been mentionned in an article in the <a href="http://google-opensource.blogspot.com/2011/11/bringing-64-bit-data-to-r.html">open source blog from Google</a>. </p>
 
<p>The package defines classes int64 and uint64 that represent signed and unsigned 64 bit integer vectors. The package also allows conversion of several types (integer, numeric, character, logical) to 64 bit integer vectors, arithmetic operations as well as other standard group generic functions, and reading 64 bit integer vectors as a data.frame column using int64 or uint64 as the colClasses argument. </p>

<p>The package has a <a href="http://cran.r-project.org/web/packages/int64/vignettes/int64.pdf">vignette</a> that details its features, several examples are given in the usual help files. Once again, I've used <a href="http://cran.r-project.org/web/packages/RUnit/index.html">RUnit</a> for quality insurance about the package code</p>

<p><a href="http://cran.r-project.org/web/packages/int64/index.html">int64</a> has been developped so that 64 bit integer vectors are represented using only R data structures, i.e data is not represented as external pointers to some C++ object. Instead, each 64 bit integer is represented as a couple of regular 32 bit integers, each of them carrying half the bits of the underlying 64 bit integer. This was a choice by design so that 64 bit integer vectors can be serialized and used as data frame columns. </p>

<p>The package contains C++ headers that third party packages can used (via LinkingTo: int64) to use the C++ internals. This allows creation and manipulation of the objects in C++. The internals will be documented in another vignette for package developpers who wish to use the internals. For the moment, the main entry point is the C++ template class LongVector. </p>

<p>I'm particularly proud that Google trusted me to sponsor the development of <a href="http://cran.r-project.org/web/packages/int64/index.html">int64</a>. The next versions of packages <a href="http://dirk.eddelbuettel.com/code/rcpp.html">Rcpp</a> and <a href="http://dirk.eddelbuettel.com/code/rprotobuf.html">RProtoBuf</a> take advantage of the facilities of <a href="http://cran.r-project.org/web/packages/int64/index.html">int64</a>, e.g. Rcpp gains wrapping of C++ containers of 64 bit integers as R objects of classes int64 and uint64 and RProtoBuf improves handling of 64 bit integers in protobuf messages. More on this later</p>
</div>
