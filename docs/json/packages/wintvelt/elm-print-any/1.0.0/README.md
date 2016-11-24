# elm-print-any

A quick &amp; dirty helper to render any record type to the DOM, for debugging purposes.

When you are dealing with large models or large records, with many fields of different shapes,
you sometimes want to be able to inspect that model.
Then the straightforward `Debug.log "my model" model` to print the model to the console will 
give you a "minified" and unreadable version of your model. Especially if there are lists in it.

The helper `view` function in this tiny library will print *any* record type to your DOM.
Anywhere in your `view` function, you can do:
```Elm
view model =
	div []
		[ ...
		, PrintAny.view model
		]
```

The output is a `<div>` with a list of indented `<p>` paragraphs in it.

The helper `log` prints a somewhat prettified version of the record to the console. It works similar to `Debug.log`
Usage is as follows:

```Elm
myNewRecord = PrintAny.log myRecord
```

Typical use case would be: your app renders a view that is different from what you expected.
And you want to inspect the contents of your model at the time of rendering.

Both functions help you do just that.

*If your record is really large, rendering will be slow.*
