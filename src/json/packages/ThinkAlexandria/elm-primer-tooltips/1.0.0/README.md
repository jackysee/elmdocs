# Elm friendly Primer CSS Tooltips

[![Build Status](https://travis-ci.org/ThinkAlexandria/elm-primer-tooltips.svg?branch=master)](https://travis-ci.org/ThinkAlexandria/elm-primer-tooltips)

> Add tooltips built entirely in CSS to nearly any element. Just add a few classes and an aria-label attribute.

This repository is a port of
[primer-tooltip](https://github.com/primer/primer-tooltip) to expose the CSS
selectors as an Elm union type. This port may be useful if you have some sort
of tool that takes advantage of the Elm AST to generate optimized CSS
selectors.

## Install

This repository is distributed with Git and elm-package. Install the elm bindings with this command.

```
$ elm package install elm-primer-tooltips
```

## Usage

The source files included are written in [Sass][sass] (`scss`) You can simply point your sass `include-path` at your `elm-stuff/packages/ThinkAlexandria/` directory and import it like this.

```scss
@import "elm-primer-tooltips/1.0.0/index.scss";
```

You can also import specific portions of the module by importing those partials from the `/lib/` folder. _Make sure you import any requirements along with the modules._

## Build


## Documentation

<!-- %docs
title: Tooltips
status: Stable
-->

Add tooltips built entirely in CSS to nearly any element. Just add a few classes and an `aria-label` attribute.

**Attention**: we use `aria-label` for tooltips instead of something like `data-tooltip` because it is crucial that the tooltip content is available for screen reader users as well. However, `aria-label` **replaces** the text content of an element for screen reader users, so only use tooltip if there is no better way to present the information, or consider using `title` for supplement information.

In addition, you'll want to specify a direction:

- `.ToolTippedN`
- `.ToolTippedNE`
- `.ToolTippedE`
- `.ToolTippedSE`
- `.ToolTippedS`
- `.ToolTippedSW`
- `.ToolTippedW`
- `.ToolTippedNW`

Tooltip classes will conflict with Octicon classes, and as such, must go on a parent element instead of the icon.

```html
<span class="ToolTipped ToolTippedN border p-2 mb-2 mr-2 float-left" aria-label="This is the tooltip on the North side.">
  Tooltip North
</span>
<span class="ToolTipped ToolTippedNE border p-2 mb-2 mr-2 float-left" aria-label="This is the tooltip on the North East side.">
  Tooltip North East
</span>
<span class="ToolTipped ToolTippedE border p-2 mb-2 mr-2 float-left" aria-label="This is the tooltip on the East side.">
  Tooltip East
</span>
<span class="ToolTipped ToolTippedSE border p-2 mb-2 mr-2 float-left" aria-label="This is the tooltip on the South East side.">
  Tooltip South East
</span>
<span class="ToolTipped ToolTippedS border p-2 mb-2 mr-2 float-left" aria-label="This is the tooltip on the South side.">
  Tooltip South
</span>
<span class="ToolTipped ToolTippedSW border p-2 mb-2 mr-2 float-left" aria-label="This is the tooltip on the South West side.">
  Tooltip South West
</span>
<span class="ToolTipped ToolTippedW border p-2 mb-2 mr-2 float-left" aria-label="This is the tooltip on the West side.">
  Tooltip West
</span>
<span class="ToolTipped ToolTippedNW border p-2 mb-2 mr-2 float-left" aria-label="This is the tooltip on the North West side.">
  Tooltip North West
</span>
```

#### Tooltips with multiple lines
Use `.ToolTippedMultiline` when you have long content. This style has some limitations: you cannot pre-format the text with newlines, and tooltips are limited to a max-width of `250px`.


```html
<span class="ToolTipped ToolTippedMultiline ToolTippedN border p-2" aria-label="This is the tooltip with multiple lines. This is the tooltip with multiple lines.">
  Tooltip with multiple lines
</span>
```

#### Tooltips No Delay

By default the tooltips have a slight delay before appearing. This is to keep multiple tooltips in the UI from being distracting. There is a modifier class you can use to override this. `.ToolTippedNoDelay`

```html
<span class="ToolTipped ToolTippedN ToolTippedNoDelay border p-2" aria-label="This is the tooltip on the no delay side.">
  Tooltip no delay
</span>
```

<!-- %enddocs -->

## License

[MIT](./LICENSE) &copy; [GitHub](https://github.com/), &copy; Th!nk Inc.

[primer-css]: https://github.com/primer/primer
[docs]: http://primercss.io/
[npm]: https://www.npmjs.com/
[install-npm]: https://docs.npmjs.com/getting-started/installing-node
[sass]: http://sass-lang.com/
