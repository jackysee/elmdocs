# SHA (Secure Hash Algorithm)

This is a port to Elm of (c) [Chris Veness](http://www.movable-type.co.uk) SHA
cryptographic libraries. The library is passing
all
[FIPS 180-4: SHA Test Vectors for Hashing Byte-Oriented Messages](http://csrc.nist.gov/groups/STM/cavp/secure-hashing.html#test-vectors).

To use, simply import the main namespace:

    import SHA 

or specific function(s):

    import SHA
        exposing
            ( sha1bytes
            , sha224bytes
            , sha256bytes
            , sha1sum
            , sha224sum
            , sha256sum
            )

