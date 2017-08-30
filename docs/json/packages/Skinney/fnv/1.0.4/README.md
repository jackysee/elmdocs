# FNV

This is an elm implementation of the FNV hash function.
FNV is well suited for hashing strings quickly, and with a low chance of collisions.
It is not, however, suitable for cryptographic use (like hashing a password).

To use, simply import the main namespace:

    import FNV

Then hash a string

    FNV.hashString "Turn me into a hash"
