---
title: trump hex and R only version
author: Romain François
date: '2017-05-31'
slug: trump-hex-and-r-only-version
categories: []
tags:
  - trump
  - R
  - segfault
banner: "img/hex/trump.png"
---

<img src="/img/hex/trump.png" style = "float: left; margin: 20px;" />

Since [last time](/blog/2016/11/16/trump-a-package-to-segfault-your-r-session/), I discovered 
  a way to bomb an R session with just R code. You just have to `attach` an object of S3 class
"UserDefinedDatabase" that isn't one. So I updated the 
[trump](https://github.com/romainfrancois/trump) package on github, 
and gave better documentation with a gif. 

`"UserDefinedDatabase"` are not just in R for the sole purpose of bombing the 
session, it is a feature of R that is not widely known that can be used to attach 
to the search path things that act like environments but are not. 

To use them you have to write some C code to react to lookups. I've been using them 
for real things in the [RProtoBuf](https://github.com/eddelbuettel/rprotobuf) and [rJava](https://cran.r-project.org/web/packages/rJava/index.html) packages, 
and more recently for an evil purpose in [`evil.R`](https://github.com/romainfrancois/evil.R) 
so that anything that starts with a 
capital letter is automatically bound to `666`. 

<img src="https://media.giphy.com/media/3oKIPx8H70SsclhKkE/giphy.gif" style = "float:right; margin: 20px; border: 1px solid lightgray" />

It is typically discouraged to use the feature offered by `"UserDefinedDatabase"` and if you 
still use it you have to make sure it answers very quikcly because it will be interrogated 
many many times. 

I'll write another post about how I the evil implementation of 
`"UserDefinedDatabase"`, but as far as `trump` is concerned, the code that is needed
to bomb an R session is as simple as attaching a dummy list with S3 class `"UserDefinedDatabase"` :

```
attach( structure(list(), class="UserDefinedDatabase") )
```

It breaks on [these lines](https://github.com/wch/r-source/blob/trunk/src/main/envir.c#L2424) of the R source : 
```
R_ObjectTable *tb = (R_ObjectTable*) R_ExternalPtrAddr(CAR(args));
if(tb->onAttach)
  tb->onAttach(tb);
PROTECT(s = allocSExp(ENVSXP));
SET_HASHTAB(s, CAR(args));
setAttrib(s, R_ClassSymbol, getAttrib(HASHTAB(s), R_ClassSymbol));
```

because there's just no way to convert the object we created to an external pointer 
to an `R_ObjectTable` struct. 

