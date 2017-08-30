# elm-github-events

An elm package to fetch the latest public github events for a list of users.

## Example

A huge, but runnable, example in a single `Main.elm` file.

```elm
module Main exposing (..)

import Html exposing (program, img, a, div, text, span)
import Html.Attributes exposing (href, src, height, width)
import Github


type alias Repo =
    { name : String
    , url : String
    }


type alias Profile =
    { name : String
    , url : String
    }


type alias Entry =
    { user : Profile
    , action : Github.EventAction
    , avatar : String
    , timestamp : String
    , repo : Repo
    }


type alias EntriesModel =
    List Entry


type alias Username =
    String


type alias Usernames =
    List Username


entryView : Entry -> Html.Html t
entryView entry =
    div []
        [ img [ src entry.avatar, height 20, width 20 ] []
        , text " "
        , a [ href entry.user.url ] [ text entry.user.name ]
        , text " "
        , description entry
        ]


pullView : Github.PullRequest -> Html.Html t
pullView pr =
    a [ href pr.url ]
        [ text
            ("pull request #"
                ++ (toString pr.number)
                ++ " - "
                ++ pr.title
            )
        ]


description : Entry -> Html.Html t
description entry =
    let
        repo =
            repoView entry.repo
    in
        case entry.action of
            Github.EventActionPullRequestReviewComment comment pr ->
                span []
                    [ a [ href comment.url ] [ text "placed a review comment" ]
                    , text " in "
                    , pullView pr
                    ]

            Github.EventActionPullRequest pr ->
                span []
                    [ text (pr.action ++ " ")
                    , pullView pr
                    , text " in "
                    , repo
                    ]

            Github.EventActionDelete del ->
                span []
                    [ text ("deleted " ++ del.ref_type ++ " " ++ del.ref ++ " in ")
                    , repo
                    ]

            Github.EventActionPush _ ->
                span []
                    [ text "pushed to ", repo ]

            Github.EventActionIssue issueAction ->
                span []
                    [ text (issueAction.action ++ " ")
                    , a [ href issueAction.issue.url ]
                        [ text
                            ("issue #"
                                ++ (toString issueAction.issue.number)
                                ++ " - "
                                ++ issueAction.issue.title
                            )
                        ]
                    , text " in "
                    , repo
                    ]

            Github.EventActionIssueComment issueComment ->
                span []
                    [ a [ href issueComment.comment.url ] [ text "commented" ]
                    , text " on "
                    , a [ href issueComment.issue.url ]
                        [ text
                            ("issue #"
                                ++ (toString issueComment.issue.number)
                            )
                        ]
                    , text " in "
                    , repo
                    ]

            Github.EventActionCommitComment comment ->
                span []
                    [ a [ href comment.url ] [ text "commented" ]
                    , text " on a commit in "
                    , repo
                    ]

            Github.EventActionFork ->
                span [] [ text "forked ", repo ]

            Github.EventActionWatch ->
                span [] [ text "starred ", repo ]

            Github.EventActionMember user action ->
                span []
                    [ text user
                    , text " "
                    , text action
                    , text " to "
                    , repo
                    ]

            Github.EventActionCreate ref refType description ->
                case refType of
                    "repository" ->
                        span []
                            [ text ("created the " ++ refType ++ " ")
                            , repo
                            , text
                                (Maybe.withDefault " "
                                    (Maybe.map
                                        (\d -> " - " ++ d ++ " ")
                                        description
                                    )
                                )
                            ]

                    "branch" ->
                        span []
                            [ text
                                ("created a "
                                    ++ refType
                                    ++ " in "
                                )
                            , repo
                            ]

                    _ ->
                        text ""

            Github.EventActionUnknown actionType ->
                span []
                    [ text ("<unhandled event type " ++ actionType ++ "> ")
                    , repo
                    ]


repoView : Repo -> Html.Html t
repoView repo =
    a [ href repo.url ] [ text repo.name ]


type alias Model =
    EntriesModel


type Action
    = FetchEventsResult (Result Github.ApiError Github.Events)


users : List String
users =
    [ "torgeir"
    , "emilmork"
    , "mikaelbr"
    ]


initialModel : Model
initialModel =
    []


subscriptions : Model -> Sub Action
subscriptions model =
    Sub.none


init : ( Model, Cmd Action )
init =
    ( initialModel, (Github.fetchAllEvents FetchEventsResult users) )


view : Model -> Html.Html msg
view model =
    div [] (List.map entryView model)


joinEntries : Model -> Model -> Model
joinEntries entries moreEntries =
    entries
        |> List.append moreEntries
        |> List.sortBy .timestamp
        |> List.reverse


eventToEntry : Github.Event -> Entry
eventToEntry event =
    { action = event.action
    , user = Profile event.actor.display_login event.actor.url
    , avatar = event.actor.avatar_url
    , timestamp = event.created_at
    , repo = Repo event.repo.name event.repo.url
    }


update : Action -> Model -> ( Model, Cmd Action )
update msg model =
    case msg of
        FetchEventsResult (Err error) ->
            let
                errorText =
                    (toString error)
            in
                Debug.log
                    errorText
                    ( model, Cmd.none )

        FetchEventsResult (Ok eventList) ->
            ( (joinEntries model (List.map eventToEntry eventList)), Cmd.none )


main : Program Never Model Action
main =
    program
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
```

![example image](https://raw.githubusercontent.com/torgeir/elm-github-events/master/elm-github-events.png)
