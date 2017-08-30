# URL Parser

## Introduction
This library makes it easy to Parse URLs into Elm data.
It is easily extendable and configurable based on Parser Combinators.

You can pipe the combinators or use the infix versions to create your own parsers.

## ParseUrl sage

Using either the pipe or infix example, to parse an Url.

```elm
> parseUrl rootRoutes "/"
Just Home

> parseUrl rootRoutes "/home"
Just Home

> parseUrl rootRoutes "/users/1"
Just (UserPage (UserProfile 1))

> parseUrl rootRoutes "/users/1/details"
Just (UserPage (UserDetails 1))

> parseUrl rootRoutes "/search/keyword1/keyword2"
Just (SearchPage ["keyword1","keyword2"])
```

## Example pages types

The following pages exist in the example.

```elm
type RootPage
    = Home
    | UserPage UserPage
    | SearchPage (List Keyword)
    | Contact


type alias Keyword =
    String


type UserPage
    = Users
    | UserProfile Int
    | UserDetails Int
```

## Pipe example configuration

You can use piping to configure the routes.

```elm
rootRoutes =
    oneOf
	[ return Home
	, return Home       |> follow (path "home")
	, return UserPage   |> follow (path "users")  |> apply userRoutes
	, return SearchPage |> follow (path "search") |> apply (many string)
	, return Contact    |> follow (path "contact")
	]


userRoutes =
    oneOf
	[ return Users
	, return UserProfile |> apply int
	, return UserDetails |> apply int |> follow (path "details")
	]
```	    

## Infix example configuration

But also can use the infixes.

```elm
rootRoutes =
    oneOf
	[ return Home
	, return Home       .>> path "home"
	, return UserPage   .>> path "users"  <*> userRoutes
	, return SearchPage .>> path "search" <*> many string
	, return Contact    .>> path "contact"
	]


userRoutes =
    oneOf
	[ return Users
	, return UserProfile <*> int
	, return UserDetails <*> int .>> path "details"
	]
```

## Integration with Navigation
To integrate with Navigation in your application, setup your main with Navigation:

```elm
type Msg
    = ...
    | NewLocation Location
    | ...

main : Program Flags Model Msg
main =
    Navigation.programWithFlags NewLocation
	{ init = init
	, view = view
	, update = update
	, subscriptions = subscriptions
	}
```

Then in your update function

```elm
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
	...

	NewLocation location ->
	     let
		 newPage = parseLocation rootRoutes location
	     in
		 -- Update the activePage
		 { model | activePage = newPage } ! []
            ...
```

## Contributing

```
npm install
npm test
```

## Acknowledgement

I was looking at the code of [Evan Czaplicki's URL Parser](https://github.com/evancz/url-parser) and
decided I wanted a little more fleixibility, while trying to keep a simple API.
It was also a fun exercise implementing an own Parser Combinator using these great
[blog posts](https://fsharpforfunandprofit.com/posts/understanding-parser-combinators/).