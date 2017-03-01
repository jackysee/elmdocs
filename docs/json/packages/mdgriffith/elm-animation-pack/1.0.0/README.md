# Manage your Elm animation states!

Managing your animation states in Elm can be a pain.  This module is an attempt at making it a little bit easier.

Essentially this module uses a dict behind the scenes to keep track of your animation states.  This comes with some tradeoffs, check the __warnings__ section at the bottom of the doc.


## Code Example

Initial model and subscription.
```elm
import Color
import Animation
import Animation.Pack

type MyStyles 
    = MyStyle 
    | OtherStyle

-- Fancy alias for the tuple comma
(=>) = (,)

-- Your initial model.
init =
    { styles = 
        Animation.Pack.init
            [ MyStyle =>
                [ Animation.opacity 0.0
                , Animation.color Color.blue
                , Animation.left (px 0.0)
                ]
            , OtherStyle =>
                [ Animation.opacity 0.0
                , Animation.color Color.blue
                , Animation.left (px 0.0)
                ]
            ]
    }

-- .. add the subscription to your subs
   , subscriptions = (\model -> Animation.Pack.subscription Animate model.styles)

-- .. Add an animation update command to your update function.
    Animate animMsg ->
        let
            (newStyles, cmds) = Animation.Pack.update animMsg model.styles
        in
            ( { model | styles = newStyles}
            , cmds
            )



```
#### Now you can animate!

```elm
    StartAnimation ->
        let
            newStyles =
                model.styles
                    |> Animation.Pack.animate MyStyle
                        [ Animation.to
                            [ Animation.left (px 0.0)
                            , Animation.opacity 1.0
                            ]
                        ]
                    |> Animation.Pack.animate OtherStyle
                        [ Animation.to
                            [ Animation.color Color.red
                            , Animation.top (px 80)
                            ]
                        ]
                }
        in
            ( { model | styles = newStyles }
            , Cmd.none
            )
```


## More Advanced Usage

You can dynamically add an `Animation.State` to your pack by using `Animation.Pack.add`.  This is useful when you need to start animating something you didn't have when the app started!


## Warnings

Because this module is using a dict behind the scenes, you lose some of the strengths of elm's type checking.

Here are all the pitfalls you need to be aware of:

  * If you try to update/animate a state that doesn't exist, you'll get a logged warning (i.e. runtime notification) and _nothing else will happen_!
  * Be careful about using `Animation.Pack.add` all the time.  Use it only when you're _sure_ you need it.  Remember to `Animation.Pack.remove` any states you're not using.
  * Don't use functions as keys for `Animation.Pack`.  If you do, you'll have a bad time.







