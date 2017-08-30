# Description
This library exposes functions for conditionally viewing HTML elements
inside a modal dialog.

Please note that this library only makes sure that all modals have similar
markup with consistent CSS classes; it's still up to you to provide the CSS
to actually make the modal appear and disappear. However, you can use
[this](src/modal.css) as a starting point!

# Guidelines
- The markup should be as simple as possible
- The CSS classes assigned to each element should be fully customizable
- No inline CSS
- Can't have internal state (duh!)
- Should have a backdrop. Clicking it should (*read*: issue a message to) close the dialog
- Only message it produces should be for closing the dialog. Meaning that the content of the dialog is completely up to you
- Some basic animations when opening or closing (*read*: CSS transitions only)
- Using it shouldn't be too different than using any other Elm Html element function, meaning it should take at the very least:
    - a list of properties (for the top-level element)
    - a list of children elements (the content)

# Usage
See the Elm package documentation
