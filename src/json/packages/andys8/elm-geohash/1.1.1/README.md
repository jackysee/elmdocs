# elm-geohash [![Travis build status](https://travis-ci.org/andys8/elm-geohash.svg?branch=master)](https://travis-ci.org/andys8/elm-geohash)

A geohash library for Elm.

## Installation

To install it in your development directory:

```sh
elm package install andys8/elm-geohash
```

## Usage

To use it from your code:

```elm
import Geohash

geohash = Geohash.encode -25.38262 -49.26561 8
```

## Javascript
Thanks to [Ning Sun](https://github.com/sunng87) for the [JavaScript implementation](https://github.com/sunng87/node-geohash).

## What is a geohash?
The geohash preserves **spatial locality** so that points close to each other in space are close to each other on disk. This is because the arrangement of the result is comparable with space filling **Z-order curves**. The length of geohashes can be chosen individually and depending on the degree of accuracy. Characters at the end are less significant. Truncating the geohash can be used to cover larger areas. In fact this can be used to build range queries based on the prefix of the primary key.

The geohash is constructed bitwise. The range of both dimensions will be cut in half. If the target point is located in the greater half of the range, the value of the first bit is `1`. Otherwise it’s `0`. The example longitude `11.53..°` would result in a `1-bit` as first value because it’s part of range `[0°, +180°]` and not `[-180°, 0°)`. This binary partitioning approach will be repeated alternately for both axes (beginning with longitude). Because the encoding is weaving the bits together, the geohash has the spatial locality property.
