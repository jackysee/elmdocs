# English Dictionary for Elm

[![Build Status](https://travis-ci.org/ktonon/elm-english-dictionary.svg?branch=master)](https://travis-ci.org/ktonon/elm-english-dictionary)

Based on WordNet 3.0 see [WordNet License](http://wordnet.princeton.edu/wordnet/license/)

English language dictionary. Check word membership and lookup definitions. To keep the download size of the package smaller, this elm package is backed by a [serverless][] API.

## Setup

To get the full functionality, deploy the API to your AWS account:

* clone this repo
* `npm install`
* `npm run build`
* `npm run deploy`

Take note of the API endpoint, which will look something like `https://***.execute-api.us-east-1.amazonaws.com/dev`.

You can also just run the API locally by doing `npm start`, in which case your endpoint becomes `http://localhost:7631`.

Configure the `EnglishDictionary` to use the serverless API by setting the endpoint:

```elm
type alias Model =
    { engDictConfig : EnglishDictionary.Config
    , otherStuff : String
    }


reset : Model
reset =
    Model
        (EnglishDictionary.Config "http://localhost:7631")
        "foobar"
```

[serverless]:https://serverless.com/
