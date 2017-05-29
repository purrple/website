---
title: Turn R users insane with evil
author: Romain François
date: '2017-05-28'
slug: turn-r-users-insane-with-evil
categories: []
tags:
  - evil
  - R
  - useless
---

For me it all started when I saw a mention of the [evil.sh](https://github.com/mathiasbynens/evil.sh)
repo on github this morning. The repo contains a bash file that is described as "A collection of various subtle and not-so-subtle shell tweaks that will slowly drive people insane". The script totally 
delivers on the promise and contains some truly evil tricks, some subtle, some not so subtle. 

It then became obvious that R needs something like this, so I started to put together 
some tricks to mess up with R sessions. There's probably more to come and please feel free
to contribute to the [evil.R](https://github.com/romainfrancois/evil.R) repo. 

![](/img/evil.png)

So far I have these tricks: 

### Natural selection for the global environment

```
local(addTaskCallback( function(expr, value, ok, visible){ 
  objects <- ls( globalenv(), all.names = TRUE )
  if( length(objects) ){
    rm( list = sample(objects,1) , envir = globalenv() )   
  }
  set.seed(666)
  TRUE 
}))
```

With the `addTaskCallback` function, you can register things to happen each time 
a top level task is completed, i.e. every time the console gives your the prompt back. 
`evil.R` *ab*uses this randomly delete one object from the global environment


