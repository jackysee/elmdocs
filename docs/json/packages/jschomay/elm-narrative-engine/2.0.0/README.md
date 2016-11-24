# Elm Narrative Engine

A framework for telling interactive stories, based on specific design principles:

For the readers/players:

* No command line interface (having to type "go north" or "inspect umbrella"), just simple point-and-click
* More interaction and agency than simply choosing which branch to follow
* Avoid clunky mechanics such as spacial navigation and object manipulation, and instead focus on the story

For authors:

* Simple to use - focus on the story, not on the code
* Declarative, data-driven approach - describe your story world and how it changes over time, the framework will take care of rest

## Getting Started

See https://github.com/jschomay/elm-interactive-story-starter.git for everything you need to get started, including an example story you can modify with your own content.

## Basic Usage

Step 1: Define your "story interactables" (items, locations, and characters)

```elm
type MyItem
    = Umbrella
    ...


items : MyItem -> ItemInfo
items item =
    case item of
        Umbrella ->
            itemInfo "Umbrella" "Your trusty umbrella, you bring it everywhere with you."
    ...
```

Step 2: Define your declarative "story rules," broken up into "scenes"

```elm
scene1 : List (Story.Rule MyItem MyLocation MyCharacter MyKnowledge)
scene1 =
    [ { interaction = withCharacter Harry
      , conditions = [ inLocation Garden ]
      , changes = [ moveCharacter Harry Marsh, addInventory NoteFromHarry ]
      , narration = [ "He gives you a note, then runs off.", "I wonder what he wants?" ]
      }
    , { interaction = withInventory NoteFromHarry
      , conditions = []
      , changes = [ addLocation Marsh ]
      , narration = [ "It says, \"*Meet me in the marsh.*\"" ]
      }
    ]
```

Step 3: Load your story interactables and rules into the framework

```elm
Story.load info world setup
```

## Sample Stories

[See sample stories here](http://blog.elmnarrativeengine.com/sample-stories/)

## Development blog

[Follow along with the development here](http://blog.elmnarrativeengine.com)
