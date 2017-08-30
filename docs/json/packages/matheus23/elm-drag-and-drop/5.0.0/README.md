# Drag And Drop

I experienced the html5 drag and drop api to be buggy and inconsistend across browsers, but all building blocks to roll a pure-elm version exist: mouseover and mouseleave events, a subscription to mouseup events and voila.

However, I reuse the dragstart event (from the html5 api), so that draggable elements can still receive onclick events.

## Demo

An example can be tested out by cloning the repo locally and running `elm-reactor`:

```sh
$ git clone https://github.com/matheus23/elm-drag-and-drop.git
$ elm-package install
$ elm-reactor
```

Now open a webbrowser and go to `localhost:8000/src/Example.elm`.

## Disclaimer

This package is still under construction and documentation is limited. This may change in the future when the API does not change that much anymore.

## 'Low' level API

Can be found in the module `DragAndDrop`. It is used to implement a higher level API for reorderable lists.

## 'High' level API

Can be found in the module `DragAndDrop.ReorderList` together with `DragAndDrop.Divider`. Can be used to implement a list of things that can be reordered by dragging its elements.
