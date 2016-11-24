# elm-media [![Build Status](https://travis-ci.org/liamcurry/elm-media.svg?branch=master)](https://travis-ci.org/liamcurry/elm-media)

`elm-media` is a small Elm library for extracting social media URLs from text.
The typical use-case for this library is to embed videos and images from around
the web into webpages.

[Demo](http://liamcurry.com/elm-media/) |
[Docs](http://package.elm-lang.org/packages/liamcurry/elm-media/)

## Example

```elm
import Media
import Media.Site as Site

text = """https://imgur.com/cjCGCNH
https://youtu.be/oYk8CKH7OhE
https://www.youtube.com/watch?v=DfLvDFxcAIA
"""

{- This will extract media references in "text" for all supported sites, and
   generate URLs for each reference.
-}
results =
  text
    |> Media.find Site.all
    |> Media.urls
```

## Supported sites

- [Gfycat](https://gfycat.com)
- [Imgur](https://imgur.com)
- [Livecap](https://livecap.tv)
- [Oddshot](https://oddshot.tv)
- [Twitch](https://twitch.tv)
- [YouTube](https://youtube.com)

## Future sites

- Reddit
- Twitter
- Github
- Gist
- Instagram
- Facebook
- Google+
- Vine
- Vimeo
- Steam

## TODO

- Linking to videos at specific times
- Supporting embeds that require script tags
- oEmbed URLs

## Development

Want to add a new site? No problem! Just fork this repo and create a
pull-request. Once you have a copy on your local machine:

```shell
cd elm-media
npm install
npm start
```
