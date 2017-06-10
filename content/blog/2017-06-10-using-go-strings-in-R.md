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
  It has two functions: `Foobar` that always return the same string, and `Nbytes`
  that takes a `string` and returns the number of bytes it is made of.
- The `main` package that contains a mix of go an C code,
  using cgo and the C R API. Eventually, all of that will be generated somehow.

# Convert a go string to an R string

`Foobar` is a simple go function that always return the same string.

```go
func Foobar() string {
  return "foo" + "bar" ;
}
```

The first thing we need is an exported go function in the `main` package that calls
`rstring.Foobar`.

```go
//export Foobar
func Foobar() string {
  return rstring.Foobar() ;
}
```

The `//export` here is a special comment interpreted by `cgo` to express
that we want to be able to call this function from C. Here is the relevant
information from the generated header file:

```
typedef long long GoInt64;
typedef GoInt64 GoInt;
typedef struct { const char *p; GoInt n; } GoString;

extern GoString Foobar();
```

So, we have a C function called `Foobar` that returns a C struct `GoString`
from which we can get a pointer to the start of the string
and the number of `char`.

This is not how we would typically pass a go string with cgo,
because the string we get is not null terminated. We would typically
return a null terminated copy of the string using the [`CString`](https://github.com/golang/go/wiki/cgo#go-strings-and-c-strings)
function as explained on the go wiki.

We don't want to do that because `CString` allocates memory
using `malloc` and it becomes our responsability to free that memory, and also
because our end game here is to make it an R string, i.e. using the
global string cache of R.

Instead of that, we can use the [`mkCharLenCE` function](https://github.com/wch/r-source/blob/7f0ae7735816eccba5e2e507543f0486c264bc28/src/main/envir.c#L3839)
from the R api.

```
/* mkCharCE - make a character (CHARSXP) variable and set its
   encoding bit.  If a CHARSXP with the same string already exists in
   the global CHARSXP cache, R_StringHash, it is returned.  Otherwise,
   a new CHARSXP is created, added to the cache and then returned. */


SEXP mkCharLenCE(const char *name, int len, cetype_t enc)
```

We need to feed 3 things to `mkCharLenCE`

- `name`: a pointer to the start of the string, we have that in the `p`
  element of the `GoString` struct
- `len`: the number of bytes of the string, we have that as `n`
- `enc`: the string encoding. We'll just assume utf-8 encoding and use `CE_UTF8`

So given a `GoString` called `res` we can make it an R string using
`mkCharLenCE( res.p, res.n, CE_UTF8 )`. This gives us a "scalar" R string,
to return it to the R side, we need to turn it into a length 1 string vector using
[`ScalarString`](https://github.com/wch/r-source/blob/63460e4056f78c06275f13cac97d4116323053b0/src/include/Rinlinedfuns.h#L623).

```
SEXP foobar(){
  GoString res = Foobar() ;
  return ScalarString(mkCharLenCE( res.p, res.n, CE_UTF8 )) ;
}
```

We can `.Call` that function from the R side:

```
#' @export
foobar <- function() {
  .Call("foobar", PACKAGE = "gostring")
}
```

# Using an R string in go

For the other way around, we have the `Nbytes` function that takes a go string
and return its number of bytes:

```
func Nbytes( s string ) int {
  return len(s) ;
}
```

As before, the `//export`ed function just proxies the call to the real function.

```
//export Nbytes
func Nbytes(s string ) int {
  return rstring.Nbytes(s) ;
}
```

The interesting bit I guess is in the `.Call` ready function `nbytes`
from the `main.c` file.

```
SEXP nbytes(SEXP x){
  SEXP sx = STRING_ELT(x, 0);
  GoString gos = { (char*) CHAR(sx), SHORT_VEC_LENGTH(sx) };
  return ScalarInteger( Nbytes(gos) ) ;
}
```

First this extract the first string from the string vector using
the `STRING_ELT` macro.

```
SEXP sx = STRING_ELT(x, 0);
```

Then, it constructs a `GoString` from the R string pointer and its length, which we
can get using R api macros `CHAR` and `SHORT_VEC_LENGTH`. I'll blog
about this [separately](https://github.com/rbind/romain/issues/1)

```
GoString gos = { (char*) CHAR(sx), SHORT_VEC_LENGTH(sx) };
```

Then, we call the proxy `Nbytes` function and wraps up the returned
`int` as a length 1 integer vector using `ScalarInteger`.

```
return ScalarInteger( Nbytes(gos) ) ;
```

# wrapping up

Installing the code from this [post' companion repo](https://github.com/rstats-go/_playground_string) and calling the 
`foobar` and `nbytes` functions.

```
romain@sherlock ~/git/rbind/romain $ Rscript -e 'install_github("rstats-go/_playground_string"); gostring::foobar(); gostring::nbytes("foo")'
Using GitHub PAT from envvar GITHUB_PAT
Downloading GitHub repo rstats-go/_playground_string@master
from URL https://api.github.com/repos/rstats-go/_playground_string/zipball/master
Installing gostring
'/Library/Frameworks/R.framework/Resources/bin/R' --no-site-file --no-environ  \
  --no-save --no-restore --quiet CMD INSTALL  \
  '/private/var/folders/9k/s6066bbx22s7g9gy6sg4qy3w0000gn/T/RtmpkUIA0L/devtools12067239a4401/rstats-go-_playground_string-dd417b7'  \
  --library='/Library/Frameworks/R.framework/Versions/3.4/Resources/library'  \
  --install-tests

* installing *source* package ‘gostring’ ...
** libs
rm -f *.h
CGO_CFLAGS="-I/Library/Frameworks/R.framework/Resources/include -DNDEBUG   -I/usr/local/include" CGO_LDFLAGS="  -F/Library/Frameworks/R.framework/.. -framework R" GOPATH=/private/var/folders/9k/s6066bbx22s7g9gy6sg4qy3w0000gn/T/RtmpkUIA0L/devtools12067239a4401/rstats-go-_playground_string-dd417b7/src/go  go build -o gostring.so -buildmode=c-shared main
installing to /Library/Frameworks/R.framework/Versions/3.4/Resources/library/gostring/libs
** R
** preparing package for lazy loading
** help
*** installing help indices
** building package indices
** testing if installed package can be loaded
* DONE (gostring)
[1] "foobar"
[1] 3
```
