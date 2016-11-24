# elm-bloom: Bloom Filter for Elm

Elm [Bloom filter](https://en.wikipedia.org/wiki/Bloom_filter) implementation using [Murmur3](https://en.wikipedia.org/wiki/MurmurHash). It may not be the fastest implementation, but it is simple and easy to use. This [blog post](https://corte.si/posts/code/bloom-filter-rules-of-thumb/index.html) with rules of thumb for choosing m and k might be helpful. 

## Installation

```bash
elm package install ggb/elm-bloom
```

## Usage

Usage is straightforward: 

```elm
import Bloom exposing (empty, add, test)

-- create an empty filter with m elements and k hashes
emptyFilter = empty 1000 4

-- add elements to the filter
filter = 
  List.foldr 
    add
    emptyFilter 
    ["foo", "bar", "baz", ... ]

-- check if elements are recognized by the filter
test "bar" filter == True
test "barr" filter == False
```