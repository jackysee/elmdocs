# Elm-Bricks

elm-bricks is a library that define "brick" components that behave similarly
as Html elements. Differently than Html objects, bricks can be 
stored in models and serialized/deserialized as JSON. This makes it ideal to
talk to a server that might render HTML fragments in a JSON representation
which is then controlled by Elm's mainloop.

The main goal is to interact seamlessly with the [django-bricks](https://github.com/fabiommendes/django-bricks/) 
library and consume brick elements from a Django server. The serialization 
protocol, however is very simple and can be easily implemented in different
backends.  

## Usage

Basic example (rendering a Brick from Json data):

```elm
module App exposing (..)

import Bricks
import Html


json : String
json =
    """
{
    "tag": "div",
    "children": [
        {
            "tag": "h1",
            "children": ["Hello!"]
        },
        {
            "tag": "p",
            "children": ["Hello Bricks!"]
        },
        {
            "tag": "input",
            "attrs": [["value", "Button"], ["type", "submit"]]
        }
    ]
}
"""


main =
    Html.beginnerProgram
        { view = Bricks.viewString
        , model = json
        , update = \msg m -> m
        }
```