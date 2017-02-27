## Bulma CSS classes organized into nested record sets

Bulma is "A modern CSS framework based on Flexbox" by frontend designer Jeremy Thomas ([docs](http://bulma.io/), [github](https://github.com/jgthms/bulma)). It's still under development, but appears to be moving quickly toward a stable release. This package will be updated when there is a new major release of Bulma.

### Why use Bulma?
Bulma is a great framework to use with Elm because:

  + Bulma is purely a CSS framework; it doesn't include any JavaScript, which is preferable because it allows you to handle any interactive functionality in Elm.

  + All of the styling happens through classes, so you don't have to waste your time overriding the default styling on HTML elements to get the layout or effects you want.

  + Bulma contains classes that make it easy to construct modern UI components and customize them as much as you need to; you don't need to be a CSS wizard to create a stylish frontend for your web application, but you won't end up with a canned theme look either.

### Why use this package and not just the class names?
There are two ways you can mess up when learning to use a CSS framework: you can try to use classes that don't exist, or you can apply classes and modifiers incorrectly (e.g., applying the class to the child when it should be applied to the parent, or vice versa).

This package helps to prevent both types of errors by storing Bulma class names in nested record sets. If you try to use something that doesn't exist, the Elm compiler will let you know. The nested record names also help you to figure out which classes should be applied to which elements so that you don't have to go back to the documentation as often.

An added benefit of using this package is that you can use the Elm REPL to get available class names. For example, if you want to know all of the size modifiers that can be used on an image container, just type `image.size` into the REPL.
