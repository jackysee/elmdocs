# Colorbrewer colors

This package provides the colors from http://colorbrewer2.org/ inside elm.
These colors as designed to be colorblind friendly as well as trying to let users be objected.

There are three kind of color scheme types provided:

## Sequential

![sequential colors ](https://raw.github.com/dawehner/elm-colorbrewer/master/doc/images/sequential.jpg)

Sequential colors should be used for sequential data, aka. data which is in a certain range, like
for example temperature between 0 and 30 degrees of celsius.

Many plotting libraries and people use rainbow by default, which dramatically changes the objectivity
of the shown data, see [colorscheme presentation](https://pdfs.semanticscholar.org/ee79/2edccb2c88e927c81285344d2d88babfb86f.pdf).

## Diverging

![diverging colors ](https://raw.github.com/dawehner/elm-colorbrewer/master/doc/images/diverging.jpg)

A differential color scheme should be used when you want to show differences to a common mean value.
An example would be showing the difference in temperature in the US relative to the average temperature.

## Qualitative

![qualitative colors ](https://raw.github.com/dawehner/elm-colorbrewer/master/doc/images/qualitative.jpg)

Qualitative color schemes should be used


Read more on [betterfigures](https://betterfigures.org/2015/06/23/picking-a-colour-scale-for-scientific-graphics/) about the usage of color schemes when the particular
entries are unrelated. An example would be recipe category background colors.

## Todods

* Figure out the best way to represent those numbers. Should they be Color objects themselves?
* Figure out how to make it easy to provide multiple elements. A list always returns maybes
* Write a demo which shows every color
