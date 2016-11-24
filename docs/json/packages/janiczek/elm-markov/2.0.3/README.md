elm-markov
==========

Markov chain library for Elm

## TODO

- various utilities for parsing `String`s into an input list
- transitions of order > 1 (Markov chain of order `n` depends on past `n` states)

## What is this about?

A [Markov chain](https://en.wikipedia.org/wiki/Markov_chain) can be described as a state machine going from a state to a state with some given probability.

You might have seen bots on Twitter saying random stuff - these are usually fed some text, learning the probability of eg. word "hi" being followed by the word "there". When a bot wants to generate a witty status, it starts somewhere in its state space and just walks randomly according to the probabilities.

Example might be:

```
Hello, how are you?
Did you sleep well?
Are you sure you don't need anything?
```

According to some rules (throw away punctuation, lowercase everything, ...) you parse it into:

```
anything -> ?        (100%)
are      -> you      (100%)
did      -> you      (100%)
don't    -> need     (100%)
hello    -> how      (100%)
how      -> are      (100%)
need     -> anything (100%)
sleep    -> well     (100%)
sure     -> you      (100%)
well     -> ?        (100%)
you      -> ?        ( 25%)
you      -> don't    ( 25%)
you      -> sleep    ( 25%)
you      -> sure     ( 25%)
```

Apparently all the fun will revolve around the word `you`, and if we get to `?`, we end. Let's try to generate something!

```
Did you sure you sure you don't need anything?
Are you sure you sure you sure you sure you sure you don't need anything?
Are you sure you sleep well?
Are you sure you sure you sure you sure you sleep well?
```

Maybe it's trying to give us a hint.

## How does this library help?

It will allow you to:

* parse text from a string into the state machine (customizable)
* generate a text given the state
