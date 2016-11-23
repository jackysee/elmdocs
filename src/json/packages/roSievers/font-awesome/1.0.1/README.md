# Icons from FontAwesome

The roSievers/font-awesome library provides [Font Awesome](http://fontawesome.io/) icons for use with elm-html.

The module `FontAwesome.Icons` exposes all available icon classes from the Font Awesome project. The initial "fa-" is droped and hyphens are replaced by underscores. The function `toHtml` is used to turn an `Icon` into a `<span>` with corresponding Font Awesome classes.

```elm
import FontAwesome exposing (Icon, toHtml)
import FontAwesome.Icons as Fa

cake_icon = Fa.birthday_cake : Icon

cake_html = toHtml Fa.birthday_cake : Html msg
```

You can modify the intermediate `Icon` value before turning it into Html.

```elm
import FontAwesome.Modifiers as FaMod

myIcon =
  Fa.birthday_cake
    |> FaMod.double
    |> FaMod.rotate90
    |> toHtml
```

This corresponds to a scaled and rotated birthday cake icon. The Html is as follows:

```html
<span class="fa fa-birthday-cake fa-2x fa-rotate-90"></span>
```

## Installing Font Awesome

Make sure to embed the [Font Awesome style sheet](http://fontawesome.io/get-started/) into your application. There are several ways to do this. This README can be improved by giving a short tutorial on this.


## What is missing from the current release

This package aims to implement everything from the [example page](http://fontawesome.io/examples/) of Font Awesome but a few things are still missing. (Mostly because I don't need them myself.)

 - List Icons
 - Stacked Icons
 - Custom CSS classes in Icons
