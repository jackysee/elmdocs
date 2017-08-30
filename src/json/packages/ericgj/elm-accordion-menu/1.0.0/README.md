# elm-accordion-menu

An Elm library for designing expandable menus or other "accordion" interfaces.

## Examples

[Simple example](https://github.com/ericgj/elm-accordion-menu/blob/master/examples/Simple.elm)
 | 
[Live demo](https://ericgj.github.io/elm-accordion-menu/)


## Features and constraints:

  - Menu items can be whatever you want. They have the msg type of your
    application. Builder functions are provided for common cases.

  - The only state managed by the menu is open/closed state. (If you want
    to keep track of the "last selected menu item" for instance, you do that
    within your application.)

  - Menus can respond to either clicks or hover (mouseenter/mouseleave).

  - Only a single submenu level is permitted. 

  - Absolute minimum styling, with helpers for typical cases and more fine-
    grained styling via inline styles or classes.


