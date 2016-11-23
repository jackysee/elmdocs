[![Build Status](https://travis-ci.org/teocollin1995/complex.svg?branch=master)](https://travis-ci.org/teocollin1995/complex)

# complex
A complex number library for Elm. Someone needed to write one. 

# Tests

I've found that testing numeric computations in elm can be a little bit annoying. Just testing a few critical values is not good enough so you need to randomly generate values and you need to compute the correct values from those values. This could be done with native, but that is rather annoying. Instead, I decided to have python to calculate a bunch of correct values from some randomly generated complex numbers and then write the test code from that. How I do this can be seen in testgen.py, which is not yet documented. 

# Functionality 

All tests pass except for those of the power function, which has some numeric difficulties.


