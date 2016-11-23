# elm-sentiment

elm-sentiment is an Elm module that uses the [AFINN-111](http://www2.imm.dtu.dk/pubdb/views/publication_details.php?id=6010) wordlist to perform [sentiment analysis](http://en.wikipedia.org/wiki/Sentiment_analysis) on arbitrary blocks of input text. Other wordlists are easy to integrate.

It is inspired by the the [Sentiment](https://github.com/thisandagain/sentiment)-module for Node.js.

**Please note** that a wordlist-based approach for sentiment analysis might not be the best available approach for every (your) application. It is a simple and easy to use solution that does not need training like a Bayes classifier, that might perform better in classifying sentiments.  

## Installation

```bash
elm package install ggb/elm-sentiment
```

## Usage

Usage is straightforward: 

```elm
import Sentiment

tweet = """
#StarWars fans are the best kind of people. 
I'm so, so lucky & honored to get to hang 
out with you at Celebration. Thank you for 
being you.
"""

Sentiment.analyse tweet

-- Result:
--
-- { tokens = ["starwars","fans","are","the","best", ... ,"for","being","you"]
-- , score = 12
-- , words = ["best","kind","lucky","honored","thank"]
-- , positive = [3,2,3,2,2]
-- , negative = []
-- , comparative = 0.42857142857142855 
-- }

```

For more advanced usage please take a look at the function-level documentation
and especially at the analyseWith-function.

## Future

There are lots of possibilities to improve the current module. Some ideas:

* handling of negations
* more and different word lists
* compression of word lists
* possibility to train a model (word list as fallback or support)