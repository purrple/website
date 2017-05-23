---
title:  Disambiguating Rcpp11 and Rcpp
author: "Romain François"
date:  2014-05-27
tags: ["Rcpp11", "Rcpp"]
banner: "img/banners/cplusplus.png"
---

I pushed <a href="https://github.com/Rcpp11/Rcpp11/commit/2602e7a9fd745a695f9dceb839d766b85377adf7">some code</a> this morning to allow
us to use this alternative syntax to use <a href="https://github.com/Rcpp11/Rcpp11"><code>Rcpp11</code></a>. 

```
#include <Rcpp11>
using namespace Rcpp11 ;  
```

Of course the usual code will continue to work, and might even be preferable if you write code that needs to be compatible with both <code>Rcpp11</code> and <code>Rcpp</code>, e.g. when doing comparative benchmarks ... 

```
#include <Rcpp.h>
using namespace Rcpp ;  
```

But the new syntax makes it clearer that you are using <code>Rcpp11</code>. 
