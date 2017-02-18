# UTF-8 (Unicode Transformation Format 8-bit)

This is a port to Elm of (c) [Chris Veness](http://www.movable-type.co.uk)
library to encode / decode between multi-byte Unicode characters and UTF-8
multiple single-byte character encoding.

To use, simply import the main namespace:

    import UTF8

or specific function(s):

    import UTF8 exposing (toMultiByte,toSingleByte)
