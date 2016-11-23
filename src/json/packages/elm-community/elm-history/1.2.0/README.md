# elm-history

This library contains a set of the bindings to the HTML5 History API methods.
This allows you to programmatically travel backwards and forwards in the
browser history as well as detect changes to the url path or hash.

There is also a `Location` module which provides tasks to get the current
location, and to reload the page or load a new page.

Documentation for the full API of each module is available at the
[Elm package repository](http://package.elm-lang.org/packages/elm-community/elm-history/latest)
-- or, if you are already there, to the right!

## The `History` Module

### Changing the browser's history

The `History` module allows you to change the URL displayed in the location bar
(and the location stored in the browser's history), via `setPath`, `replacePath`,
or `setHash`.

In most cases, you will want to use `setPath`. If you use `setPath`, the
previous pages will be accessible to the user by pressing the browser's back
button. If this is the behavior you seek, use `setPath`.

`replacePath` is meant for transient states, i.e. states you do not want to go
back to by pressing the browser back button. These states may include, but not
limited to, login forms or slideshows. These have in common the fact that you
want them to have specific urls you can just copy-paste and have them work but
you may not want them to be accessible to the user by pressing the back button.

You can use `setHash` in cases where you want to change only the hash portion of
the URL. It will generate a new entry in the browser's history if the new hash
is different from the old one. Alternatively, you can set a hash as part of the
path when using `setPath` or `replacePath`.

### Moving through the browser history

You can move through the browser history by performing either the `back`,
`forward`, or `go` tasks.

### Reacting to url path changes

You can react to changes in the entire url with the `href` signal, or use
the `path` signal or `hash` signal to focus on parts of the url.

## The `Location` module

You can use tasks in the `Location` module to get the current location as
a record that reflects the various parts of the URL.

You can also reload the current page, or load a new URL.
