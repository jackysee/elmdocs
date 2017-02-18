# elm-image-collection [![][badge-doc]][doc]  [![][badge-license]][license]

[badge-doc]: https://img.shields.io/badge/documentation-latest-yellow.svg?style=flat-square
[doc]: http://package.elm-lang.org/packages/mpizenberg/elm-image-collection/latest
[badge-license]: https://img.shields.io/badge/license-MPL%202.0-blue.svg?style=flat-square
[license]: https://www.mozilla.org/en-US/MPL/2.0/

This package aims at easing the manipulation and display of a collection of images.

## Installation

```bash
elm-package install mpizenberg/elm-image-collection
```

## Usage

A `Collection` is basically an elm `Dict String Image`.
So anything you can do with a `Dict` can be done with a `Collection`.
For example, to add an image to the collection, simply use `Dict.insert`:

```elm
collection : Collection
collection = Dict.empty

newCollection = Dict.insert "1" (Image "1.jpg" 320 240) collection
```

A running example is available in the file `example/collection.elm`.

## Documentation

You can find the package documentation on the [elm package website][doc]

## License

This Source Code Form is subject to the terms of the Mozilla Public License,v. 2.0.
If a copy of the MPL was not distributed with this file,
You can obtain one at https://mozilla.org/MPL/2.0/.

## Contact

Feel free to contact me at matthieu.pizenberg@gmail.com for any question.

## Credits

Great thanks to Matthias [KtorZ](https://github.com/KtorZ) who introduced me to elm.
