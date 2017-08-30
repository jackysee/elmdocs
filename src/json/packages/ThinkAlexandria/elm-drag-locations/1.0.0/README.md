This library is designed for when you want to have many different draggable
elements on the same screen.


You are responsible for setting up handlers for the `mousedown` event on each
element you want to be draggable. For each handler you specify the interaction
location using a union type you define. The library handles the subscriptions
to the subsequent mousemoved and mouseup events, giving to you an easy to
pattern match report of movements, end of drag, and clicks (for when there was
no mouse movement).

TODO: add more complete readme details.
