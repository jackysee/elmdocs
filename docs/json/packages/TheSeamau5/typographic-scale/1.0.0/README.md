# Library for typographic scales

When dealing a lot with text, it can be very easy to be inconsistent in the font sizes used across pages and documents. This is because we tend to consider a font size as a single value in isolation. We rarely relate the size of a title or a heading to that of the body. Yet, they lie on the same space.

To solve this problem, we can resort to using scales. The idea here is that you pick a "base" size and a scale to compute all other sizes for you.

For example, suppose we pick the "base" size of `12pt`, where we consider the "base" size to mean the size of the body text. Now let's pick some scale... say the major third. The major third has an interval of `5 : 4` which means that each time you apply this scale to a value, the value grows by five fourths (i.e. continuously multiplied by 1.25).


So, if we define our scale to be:

```elm
myScale =
  majorThird 12
```

Then, we can define our font sizes as follows:

```elm
fine      = myScale -2 -- 7.68pt

small     = myScale -1 -- 9.6pt

body      = myScale 0  -- 12pt

heading3  = myScale 1  -- 15pt

heading2  = myScale 2  -- 18.75pt

heading1  = myScale 3  -- 23.4375pt

title     = myScale 4  -- 29.296875pt
```

So, now we have simple values we can use throughout our application or documents and guarantee consistency with respect to the font sizes. Furthermore, if we dislike the sizes, we need only change the definition of `myScale` to use some other scale or some other base size.
