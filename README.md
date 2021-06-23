# futhark-data-sml [![CI](https://github.com/diku-dk/futhark-data-sml/workflows/build/badge.svg)](https://github.com/diku-dk/futhark-data-sml/actions)

A Standard ML implementation of the
[Futhark](https://futhark-lang.org) [binary data
format](https://futhark.readthedocs.io/en/latest/binary-data-format.html),
which is used by Futhark tooling, most importantly as the data
interchange format of [the server
protocol](https://futhark.readthedocs.io/en/latest/server-protocol.html).

## Overview of MLB files

* [lib/github.com/diku-dk/futhark-data-sml/futhark-data.mlb](lib/github.com/diku-dk/futhark-data-sml/futhark-data.mlb):

  * **signature [DATA](lib/github.com/diku-dk/futhark-data-sml/DATA.sig)** (also the documentation)
  * **structure Data**

## Use of the package

This library is set up to work well with the SML package manager
[smlpkg](https://github.com/diku-dk/smlpkg).  To use the package, in
the root of your project directory, execute the command:

```
$ smlpkg add github.com/diku-dk/futhark-data-sml
```

This command will add a _requirement_ (a line) to the `sml.pkg` file in your
project directory (and create the file, if there is no file `sml.pkg`
already).

To download the library into the directory
`lib/github.com/diku-dk/futhark-data-sml`, execute the command:

```
$ smlpkg sync
```

You can now reference the `mlb`-file using relative paths from within
your project's `mlb`-files.

Notice that you can choose either to treat the downloaded package as
part of your own project sources (vendoring) or you can add the
`sml.pkg` file to your project sources and make the `smlpkg sync`
command part of your build process.

[See also this very simple example program.](test/test.sml)

## Compatibility

Tested with MLton and MLKit.  Should in principle work with any SML
implementation that supports a reasonable subset of the Basis library
(e.g. SML/NJ), but you may need to manually load the files if they
don't support MLB.
