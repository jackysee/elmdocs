Lexicon-based random name generator
-----------------------------------

This package can be used to generate random names according to a given lexicon.

* [Experiment with the lexicon online](https://xarvh.github.io/lexical-random-generator/).
* [See an example with a better lexicon and dynamic entries](https://xarvh.github.io/lexical-random-generator/examples/real-world).

The quality of the output depends on the quality of the lexicon.

You can check the (undocumented) [tools I used to generate the english lexion](https://github.com/xarvh/lexical-random-generator/tree/master/tools).

```elm
import LexicalRandom


lexiconString =
    """
# this is a comment

streetType
    # definitions can be separed by comma or newline, it's the same
    street,road,avenue,drive,
    parade,square,plaza

namePrefix
    Georg,Smiths,Johns

nameSuffix
    chester,ington,ton,roy

surname
    {namePrefix}son
    {namePrefix}{nameSuffix}

address
    {surname} {streetType}
"""


streetNamesLexicon =
    LexicalRandom.fromString lexiconString
        |> Random.map String.Extra.toTitleCase


streetNamesRandomGenerator : Random.Generator String
streetNamesRandomGenerator =
    LexicalRandom.generator "???" streetNamesLexicon "address"
```
