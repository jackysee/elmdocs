# Elm Searchable Menu

After watching watching the video [elm-autocomplete with Greg Ziegan (API Design Session)](https://www.youtube.com/watch?v=KSuCYUqY058) I was inspired  to take part of a web app I was working on and separate it on a reusable component.

## Disclaimer

**elm-searchable-menu** is just an experiment in creating my first component, within my first Elm project, and as of this writing it's in a very rudimentary stage. I *strongly* recommend you to check [elm-autocomplete][elm-autocomplete] for all your menus needs.

## Demo

You can check the kind of menu you can make with this library in this [demo](https://SimplyNaOH.github.io/elm-searchable-menu).

## Use case

The main difference between this menu and elm-autocomplete is the original purpose: while elm-autocomplete's purpose is to give the user suggestions based on some input, elm-searchable-menu seeks to provide first and foremost a complete menu, with all possible options, while still providing the ability to only see a portion of them through some input.

## Usage

This library uses the same principles as [elm-autocomplete][elm-autocomplete] and [elm-sortable-table](https://github.com/evancz/elm-sortable-table/). You must include `SearchableMenu.Model` in your model to keep the menu sate (is it open? is there a search query in progress? is the user selecting something with the keyboard?) while the actual data to display lives in your model. The data must be transformable into IDs (`String`s). Besides this, you need to specify a *config* for both the update and view functions. **These configs don't belong in your model.** For the most part, they can be statically defined in your update and view code. In the [example](https://github.com/SimplyNaOH/elm-searchable-menu/blob/master/examples/src/Example.elm) you can see the `ViewConfig` being used as a static value, or constructed based on model data (for instance, to change the view behavior for things that are already selected).

The configurations are records and construction functions are provided:

    updateConfig :
        { toId : data -> String
        , textboxId : String
        , onSelectMsg : String -> msg
        }
        -> UpdateConfig msg data

    viewConfig :
        { toId : data -> String
        , div : IsOpen -> List (Attribute Never)
        , ul : List (Attribute Never)
        , li : IsSelected -> SearchResult data -> HtmlDetails Msg
        , input : List (Attribute Never)
        , prepend : Maybe (HtmlDetails Msg)
        , append : Maybe (HtmlDetails Msg)
        }
        -> ViewConfig data

The details are on the documentation of those functions, but some key points are:

- `toId`: on both configs matches an item of your data to a String. This String is used to [perform the search](#search).
- `onSelectMsg`: on the current version, the update function returns a `Maybe msg`, the idea being that you should call your own update with this message to handle the selection of an option on the menu.
- `li`: on the `ViewConfig` provides the view of your data. **However**, this function is provided with your data wrapped in a `SearchResult`. In the next section there is a description of what this is.
- **Important:** In both, the `UpdateConfig` and `ViewConfig` you must provide the same id for the input textbox.

A helper "`viewConfigWithClasses`" is provided which defines the menu view in terms of css classes.

### Search

An important aspect of the current version of this library is that it performs the search with it's own implementation (it would be wise for future versions to move the search functionality outside the library). The way the search works is that it returns a list of `SearchResult data`, where

    type alias SearchResult a =
        ( MatchedString, a )

    type alias MatchedString =
        List ( Bool, String )

The search is performed over the IDs of the data, and `MatchedString` represents the matched and not matched substrings as a list of pairs of a `Bool` (`True` for matched substrings, `False` otherwise) and substrings.

In your `ViewConfig` you must provide a function `li : IsSelected -> SearchResult data -> HtmlDetails Msg` where `type alias IsSelected = Bool`. This means that at the time of generating the view for the item in the menu, you can either deal with the original data (second element in the `SearchResult` tuple), or with the `MatchedString`. For the latter, the library provides `simpleSpanView : List (Html.Attribute Never) -> SearchResult data -> List (Html Msg)` which generates `Html.text` for the unmatched parts of the string, and `Html.span` with the given attributes for the matched parts.


## Acknowledgment

Some parts of the API code was either directly copied or ported from [elm-autocomplete][elm-autocomplete], so credit goes to [thebritican](https://github.com/thebritican) and the rest of the contributors.


[elm-autocomplete]:https://github.com/thebritican/elm-autocomplete
