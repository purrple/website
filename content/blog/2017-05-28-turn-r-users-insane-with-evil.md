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
`evil.R` *ab*uses this randomly delete one object from the global environment. 
I initially deleted all the objects, but I then followed Hadley's advice and 
only randomly delete one object, which is even more evil. 

{{< tweet 868968133465444352 >}}

The task callback also resets the seed to `666` so that you always get the 
same random numbers. 

### random T and F


```
# random T and F
makeActiveBinding( "T", function() rbinom(1,1,.5) < .5, as.environment("evil_shims") )
makeActiveBinding( "F", function() rbinom(1,1,.5) < .5, as.environment("evil_shims") )
```

`T` and `F` don't really need a lot of work to be evil. Their use is 
discouraged by everybody as they are not reserved words as `TRUE` and `FALSE`. 
I made them randomly `TRUE` or `FALSE` using an active binding. 


### random help 

```
assign( "?", function(e1, e2){
  help( sample(ls("package:base"), 1) )
}, as.environment("evil_shims"))
```

Typing `?fun` is a very convenient way to have access to the documentation of 
the `fun` function, `evil.R` takes this from you and instead shows you the documentation 
of a function in base chosen at random. 

### printing functions

And if going to the help page of a random function is not confusing enough, `evil.R` also 
tricks function printing, so that when you type the name of a function in the console, you 
get the code of some other function. 

```
assign( "print.function", 
  function(x, ...){ 
    f <- get( sample( ls("package:base"), 1 ), "package:base" )
    base::print.function(f) 
  }, 
  as.environment("evil_shims") 
)
```

### Slow + and -

`+` and `-` are two fast, so `evil.R` makes them sleep for 5 seconds, this way you have time 
to appreciate them. 

```
# slow + and -
assign( "+", function(e1, e2){ Sys.sleep(5) ; .Primitive("+")(e1,e2) }, as.environment("evil_shims") )
assign( "-", function(e1, e2){ Sys.sleep(5) ; .Primitive("-")(e1,e2) }, as.environment("evil_shims") )
```

### Random if

You can mess with pretty much anything in R, including the `if` keyword, that 
hides a regular function behind a fancy syntax. `evil.R` discards the condition and chooses the 
branch to execute based on randomness. 

```
assign( "if",
  function(condition, true, false = NULL){
    .Primitive("if")( rbinom(1, 1, .5) < 0.5, true, false)
  },
  as.environment("evil_shims")
)
```

### A mean mean

The last trick was contributed by [@HughParsonage](https://github.com/HughParsonage) 
as a pull request on the [repo](https://github.com/romainfrancois/evil.R), 
it adds some noise to whatever you try to `mean`. Finally a `mean` that is mean. 

```
unlockBinding("mean.default", baseenv() )
assign("mean.default", 
  local({
    mean_default <- base::mean.default
    function(x, trim = 0, na.rm = FALSE, ...) {
      mean_default( x + .Machine$double.eps ^ 0.5, trim = trim, na.rm = na.rm, ... )
    }
  }), 
  pos = baseenv()
)
```

### What's next

I'm sure there's plenty more evil to be added to `evil.R`. 


