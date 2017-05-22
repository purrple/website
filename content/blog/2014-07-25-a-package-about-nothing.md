---
title:  A package about nothing
author: "Romain François"
date:  2014-07-25
tags: ["nothing"]
banner: "img/banners/nothing.png"
---

<a href="https://github.com/romainfrancois/nothing">nothing</a> is a package about nothing. 

<img src="/img/banners/nothing.png" />

The idea is that when you do <code>require(nothing)</code> you express that you don't need
anything, and therefore <code>nothing</code> assumes you are fine just 
using the <br><code>base</code> package, so it detaches all other packages. 

```
> loadedNamespaces()
 [1] "base"      "datasets"  "devtools"  "digest"    "evaluate"  "graphics"
 [7] "grDevices" "httr"      "memoise"   "methods"   "parallel"  "RCurl"
[13] "stats"     "stringr"   "tools"     "utils"     "whisker"
>
> require(nothing)
Loading required package: nothing  
unloading 'methods' package ...  
Failed with error:  ‘invalid 'pos' argument’  
>
> loadedNamespaces()
[1] "base"
```

I agree, this is completely useless. 

