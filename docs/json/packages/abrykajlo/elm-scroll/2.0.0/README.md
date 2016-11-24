# Elm Scroll

An Elm Library for scrolling through a page and handling events. 
 Meant to be used alongside StartApp.

## Usage

### Installation

```
$ elm package install abrykajlo/elm-scroll
```

### Examples

```
$ git clone https://github.com/abrykajlo/elm-scroll
$ cd elm-scroll/examples
$ make elm
```

Open index.html in your browser.

### index.html

```html
<!DOCTYPE html>
<html>
<head>
	<title>Adam Brykajlo</title>
	<link rel="stylesheet" type="text/css" href="css/main.css">
	<script type="text/javascript" src="js/main.js"></script>
</head>
<body>
<div id="main"></div>
<script>
	var scroll = window.pageYOffset || document.body.scrollTop;
	var myApp = Elm.fullscreen(Elm.Main, {scroll: [scroll,scroll]});

	window.onscroll = function() {
		var newScroll = window.pageYOffset || document.body.scrollTop;
		myApp.ports.scroll.send([scroll, newScroll]);
		scroll = newScroll;
	};
</script>
</body>
</html>

```

### Inside Elm file

```elm
port scroll : Signal Scroll.Move

-- app definition
app =
	{ init = init 
	, view = view
	, update = update
	, inputs = [ Signal.map ScrollAction scroll ]
	}

update action model =
	case action of
		ScrollAction move ->
            Scroll.handle
                [ update Grow
                  |> Scroll.onCrossDown 400
                , update Shrink
                  |> Scroll.onCrossUp 400
                ]
                move model
```