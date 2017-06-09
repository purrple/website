---
title: Using Go strings in R
author: Romain François
date: '2017-06-10'
slug: using-go-strings-in-r
categories: []
tags:
  - go
  - R
  - package
  - cgo
  - string
banner: "img/banners/go.png"
---

So far we've only looked at passing `int` back and forth between
R ang go. `double` would be simple to tackle so I probably won't do
a dedicated post about it.

Before we look into how we can use interoperate between R vectors and
go slices, we need to look into strings. Go has the `string` type built in the
language and the [strings](https://golang.org/pkg/strings/) package
to manipulate UTF-8 encoded strings, further explained
in [this blog post](https://blog.golang.org/strings).

Go's support for
unicode is great and could easily be enough motivation to consider learning
the language.

I've setup the [rstats-go/_playground_string](https://github.com/rstats-go/_playground_string)
repository to play with strings. It contains an R package `gostring`
based on the structure I've used for
[this post](/blog/2017/06/09/go-packages-in-r-packages).

As previously, I've organized the GOPATH so that it contains:

- The `rstring` package that contains only go code, e.g. using the `string` type.
  Eventually when we have everything in place for `rgo` this will be the only
  we will have to write.
- The `main` package that contains a mix of go an C code, using cgo and the C R API.

First let's look at the `rstring` package and its two simple go functions.

```go
package rstring

func Foobar() string {
  return "foo" + "bar" ;
}

func Nbytes( s string ) int {
  return len(s) ;
}
```

`Foobar` just return a go string, and `Nbytes` takes a string and return the number
of bytes it is made of. 
