# Afinn 165 Elm

The [AFINN 165 dataset](https://github.com/fnielsen/afinn/blob/b82d00dcad22a30a06ed047fecb24e47815aac2e/afinn/data/AFINN-en-165.txt) available as an Elm `Dict`.

It's probably not a good idea to use this package; this module alone generates ~1.1 MB of JavaScript due to the way the Dict is compiled. You are almost certainly better off using a remote API instead.

But if you _really_ want to use Elm for this, here you go.
