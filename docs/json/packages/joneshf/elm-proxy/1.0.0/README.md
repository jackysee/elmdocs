# elm-proxy

A library to pass around type information when you either don't care about or don't have values.
Roughly similar to `()` with extra type information.

This can be useful in a few different cases:

* You might have an algorithm that you want to force invariants on, but you don't want users to be able to invalidate the invariants. You can expose just the types that enforce the invariants, and dish any value level stuff to `Proxy a`.
* If you're decoding something and don't care about the actual value decoded—but do care whether or not it decoded—you can pass a `Proxy a` for the decoded value with type information.
* You might want to remove the possibility for bugs to appear by restricting the type of a view to `Proxy a`.

That last example can be explained a bit.

Let's say we have different permission levels for our users.
The simple approach would create a union type of the different levels and stuff them into a model:

```elm
type Permissions
  = User
  | Moderator
  | Administrator

type alias Model =
  { name : String
  , permissions : Permissions
  , ...
  }
```

When we go to display a view for the user, we end up having to case on the permissions and make a judgement call of what to display at the value level.
In other words, the type checker will give us no help if we accidentally display the `Administrator` view for an `Moderator`:

```elm
view : Model -> Html Msg
view model =
  case model.permissions of
    User ->
      viewUser

    Moderator ->
      viewAdministrator

    Administrator ->
      viewModerator

viewUser : Html msg
viewUser =
  text "Welcome friend!"

viewModerator : Html Msg
viewModerator =
  button [ onClick Warn ]
    [ text "Warn all users" ]

viewAdministrator : Html Msg
viewAdministrator =
  button [ onClick Delete ]
    [ text "Delete all users" ]
```

We're trying to do name-based programming here for the sake of simplicity and failing.
Luckily, we can take advantage of the type checker to help us out.

One way to verify that we're displaying the correct view is to pass in an argument of the appropriate type.
If we pass in `Permissions` as it is now, we don't gain any compile time advantages:

```elm
view : Model -> Html Msg
view model =
  case model.permissions of
    User ->
      viewUser model.permissions

    Moderator ->
      viewAdministrator model.permissions

    Administrator ->
      viewModerator model.permissions

viewUser : Permissions -> Html msg
viewUser permissions =
  case persmissions of
    User ->
      text "Welcome friend!"

    _ ->
      text ""

viewModerator : Permissions -> Html Msg
viewModerator permissions =
  case persmissions of
    Moderator ->
      button [ onClick Warn ]
        [ text "Warn all users" ]
    _ ->
      text ""

viewAdministrator : Permissions -> Html Msg
viewAdministrator permissions =
  case persmissions of
    Administrator ->
      button [ onClick Delete ]
        [ text "Delete all users" ]
    _ ->
      text ""
```

What happened here is that we don't display anything to the user if we make a mistake.
What we want is to be able to say something like `User -> Html msg` or `Administrator -> Html Msg`.
This way, the type checker will reject the program if we mix something up.

So let's make that move.
We turn each of the cases in the union type into their own types:

```elm
type User
  = User

type Moderator
  = Moderator

type Administrator
  = Administrator
```

Then, each view can take one of those values as its first argument:

```elm
viewUser : User -> Html msg
viewUser User =
  text "Welcome friend!"

viewModerator : Moderator -> Html Msg
viewModerator Moderator =
  button [ onClick Warn ]
    [ text "Warn all users" ]

viewAdministrator : Administrator -> Html Msg
viewAdministrator Administrator =
  button [ onClick Delete ]
    [ text "Delete all users" ]
```

Now we need a way to call each of these functions.
If we create a new type that combines them together,
we can dispatch on the cases.

```elm
type Permissions
  = U User
  | M Moderator
  | A Administrator

viewPermissions : Permissions -> Html msg
viewPermissions permissions =
  case permissions of
    U User ->
      viewUser User
    M Moderator ->
      viewModerator Moderator
    A Administrator ->
      viewAdministrator Administrator
```

Great, so all together we have:

```elm
type User
  = User

type Moderator
  = Moderator

type Administrator
  = Administrator

type Permissions
  = U User
  | M Moderator
  | A Administrator

type alias Model =
  { name : String
  , permissions : Permissions
  , ...
  }

view : Model -> Html Msg
view model =
  case model.permissions of
    U User ->
      viewUser User
    M Moderator ->
      viewModerator Moderator
    A Administrator ->
      viewAdministrator Administrator

viewUser : User -> Html msg
viewUser User =
  text "Welcome friend!"

viewModerator : Moderator -> Html Msg
viewModerator Moderator =
  button [ onClick Warn ]
    [ text "Warn all users" ]

viewAdministrator : Administrator -> Html Msg
viewAdministrator Administrator =
  button [ onClick Delete ]
    [ text "Delete all users" ]
```

Notice that in each of the view functions the argument is ignored at the value level.
We don't do anything with the fact that `viewUser` has a `User` value passed to it.
We do care that the type of the argument is `User` though.
We'd like to communicate that fact through to someone else that picks up this code.

This is where `Proxy a` comes in.
Since we don't care what the argument is—just that the one that's there is the right type—we'd like to not worry about what we're passing to these functions.
We want something like `()` that carries type level information with it:

```elm
type Proxy a
  = Proxy
```

This simple type is our way of communicating to other people reading your code that you aren't going to do anything specific with the `a` value in your function.
This is apparent in the fact that the `a` doesn't show up at all on the right side of the equals sign.
And this invariant is enforced by the type checker, so you can't do anything with the `a` value even if you tried!

This changes the views slightly:

```elm
viewUser : Proxy User -> Html msg
viewUser Proxy =
  text "Welcome friend!"

viewModerator : Proxy Moderator -> Html Msg
viewModerator Proxy =
  button [ onClick Warn ]
    [ text "Warn all users" ]

viewAdministrator : Proxy Administrator -> Html Msg
viewAdministrator Proxy =
  button [ onClick Delete ]
    [ text "Delete all users" ]
```

Since the values are unimportant, we can just ignore them altogether.

```elm
viewUser : Proxy User -> Html msg
viewUser _ =
  text "Welcome friend!"

viewModerator : Proxy Moderator -> Html Msg
viewModerator _ =
  button [ onClick Warn ]
    [ text "Warn all users" ]

viewAdministrator : Proxy Administrator -> Html Msg
viewAdministrator _ =
  button [ onClick Delete ]
    [ text "Delete all users" ]
```

Then we change the type of `Permissions`:

```elm
type Permissions
  = U (Proxy User)
  | M (Proxy Moderator)
  | A (Proxy Administrator)
```

And we can now hook up the rest of the program:

```elm
type User
  = User

type Moderator
  = Moderator

type Administrator
  = Administrator

type Permissions
  = U (Proxy User)
  | M (Proxy Moderator)
  | A (Proxy Administrator)

type alias Model =
  { name : String
  , permissions : Permissions
  , ...
  }

view : Model -> Html Msg
view model =
  case model.permissions of
    U proxy ->
      viewUser proxy
    M proxy ->
      viewModerator proxy
    A proxy ->
      viewAdministrator proxy

viewUser : Proxy User -> Html msg
viewUser _ =
  text "Welcome friend!"

viewModerator : Proxy Moderator -> Html Msg
viewModerator _ =
  button [ onClick Warn ]
    [ text "Warn all users" ]

viewAdministrator : Proxy Administrator -> Html Msg
viewAdministrator _ =
  button [ onClick Delete ]
    [ text "Delete all users" ]
```

Great! So we've gone from name-based programming at the value level with no guarantee that we're displaying the proper view,
to a type checked dispatching of displaying the appropriate view!

There are obviously more things you'd have to do to ensure you don't accidentally pass the wrong thing around,
but this was a contrived example :).
