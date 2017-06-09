---
title: Go packages in R packages
author: Romain François
date: '2017-06-09'
slug: go-packages-in-r-packages
categories: []
tags:
  - go
  - R
  - package
  - cgo
banner: "img/banners/go.png"
---

The logical next step of [calling go from R](/blog/2017/05/14/calling-go-from-r) is to have
go code (and therefore go packages) in an R package. Most of the tools that we need 
are available, we can have C (or C++) code in the `src/` directory of an R package, 
and we can call go from C using [cgo](https://golang.org/cmd/cgo/), it's all there. It's just 
a matter of using these tools correctly, so I've played with the idea on 
the [gotest](https://github.com/rstats-go/gotest) repository. This was not (at least to me)
trivial to get everything so I've asked help on twitter. 

{{< tweet 872809887918587905 >}}

I received a lot of interest and help (both public and private), so I guess I'm on to 
something. Different people have different reasons to be interested in a language like go. 
Personally what attracts me is:

- Clean and simple syntax
- Concurrency features built into the language and straightforward to use
- The amazing [go standard library](https://golang.org/pkg/)
 
We have this go code we want to use in an R package: 

```go
package twice

func Twice(x int) int {
  return 2 * x ;
}
```

Pretty simple, the go package `twice` makes the `Twice` function available, which takes an `int` and 
doubles it. Go packages live in the `GOPATH` which is typically `~/go`, but we want the R package to host 
the go code, so I'm using the `src/go` directory of the package as the go path, therefore storing the
go packages in `src/go/src/`. Here is what my `src/` directory looks like: 

```
romain@sherlock ~/git/gotest/src $ tree
.
├── Makevars
├── go
│   └── src
│       ├── main
│       │   ├── main.c
│       │   └── main.go
│       └── twice
│           └── twice.go
├── gotest.h
└── gotest.so

4 directories, 6 files
```

We have already seen the `twice.go` file, which lives in the `twice` 
directory by convention. Let's have a look at the other files. 

`gotest.so` is the shared library we build from the go code, this 
is similar to one that would be built if we had C code like we usually do. 
In particular, we can declare that we use it with the `useDynLib` directive
in our `NAMESPACE` and then we call a c function that adheres to the `.Call`
interface, i.e. the relevant R code of the package: 

```
#' @useDynLib gotest
#' @export
godouble <- function(x) {
  .Call("godouble", x, PACKAGE = "gotest")
}
```

So we need to build that `gotest.so` file. That's typically the job of the `Makevars` file. Here it is: 

```
.PHONY: go

CGO_CFLAGS = "$(ALL_CPPFLAGS)"
CGO_LDFLAGS = "$(PKG_LIBS) $(SHLIB_LIBADD) $(LIBR)"
GOPATH = $(CURDIR)/go

go:
	rm -f gotest.h
	CGO_CFLAGS=$(CGO_CFLAGS) CGO_LDFLAGS=$(CGO_LDFLAGS) GOPATH=$(GOPATH)  go build -o $(SHLIB) -x -buildmode=c-shared main
```

Instead of R usually automatic tools that are not aware of go, we can use `go build -buildmode=c-shared`. It needs some help

- `-o $(SHLIB)` so that the shared library takes the place of the shared library R would typically make for the package. 
- `main` at the end says that we compile the `main` go package. We'll see what the `main` package contains later. Eventually when we have
  proper tooling in place, I would expect that the content of the `main` package be automatically generated, similar to the `RcppExports.*` 
  files in the `Rcpp` world. 
- We also need to set the `CGO_CFLAGS` and `CGO_LDFLAGS` for the compiler and linker flags and the `GOPATH`. We need information from R
 to set these variables. 
 
```
CGO_CFLAGS = "$(ALL_CPPFLAGS)"
CGO_LDFLAGS = "$(PKG_LIBS) $(SHLIB_LIBADD) $(LIBR)"
GOPATH = $(CURDIR)/go
```

This is what I spent most of my time with. I've done this before, but I keep forgetting about these. I found the 
information in the `Makeconf` file: 

```
> file.path( R.home(), "etc", "Makeconf" )
[1] "/Library/Frameworks/R.framework/Resources/etc/Makeconf"
```

Next, let's look at the `main` package and its two files `main.go` and `main.c`. 

The `main.go` file declares a go function `DoubleIt` that :

- calls the `Twice` function from the `twice` go package we've seen before. 
- is to declared to be exported to C with the `//export DoubleIt` which is used
  by `cgo` through the C pseudo package. `// export` feels like `// [[Rcpp::export]]`
  in the `Rcpp` world. 

```
package main

import "C"

import "twice"

//export DoubleIt
func DoubleIt(x int) int {
  return twice.Twice(x) ;
}

func main() {}
```

The `main` function is required, but we won't use it. The `main` package
also contains the `main.c` file. This is where we define the actual C
functions that R will `.Call`. 

```
#include <R.h>
#include <Rinternals.h>
#include "_cgo_export.h"

SEXP godouble(SEXP x){
  return Rf_ScalarInteger( DoubleIt( INTEGER(x)[0] ) ) ;
}
```

This include the `R.h` and `Rinternals.h` headers from R, this is possible thanks
to the setting of the `CGO_CFLAGS` variable earlier. 

This also include the `_cgo_exports.h` file, that is automatically generated
by `go build` prior to compiling `main.c`. The file is later copied into `src/gotest.h`. 
In particular the file declares the `DoubleIt` function. 

```
#ifdef __cplusplus
extern "C" {
#endif

extern GoInt DoubleIt(GoInt p0);

#ifdef __cplusplus
}
#endif
```

Then we can compile, load and use it, for example with 

```
install_github( "rstats-go/gotest")
gotest::godouble(21L)
```

Cool, yet another way to get `42`. 

<video src="https://media.giphy.com/media/xUPGckpoEpj0MU0HT2/giphy-hd.mp4" autoplay loop playsinline style="width:100%"></video>
