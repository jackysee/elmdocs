# BigRatio

A module for working with big (infinite-digit numerator and denominator) rational numbers in Elm. Forked from Izzy Meckler's [Ratio](https://github.com/imeckler/ratio), on top of Javier Casas' [elm-integer](https://github.com/javcasas/elm-integer).

I needed big rational numbers to divide and then add money. 10/3 + 10/3 + 10/3 must equal 10, not 9.99..., and the size of the numerator and denominator mustn't be limited by a limited-size integer type.

will@willwhite.website
