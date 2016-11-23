## Data Join for Elm

A Join is a set of data that changes at discrete moments. A join tracks items that are entering the set, exiting the
set, or updating from one value to another. Elements are tracked across updates not by equality but by index or a key
function.

You can use this library to transition between views of data. For example, some data points might transition away as
they're filtered out, while others will smoothly change size or position. The enter-update-exit pattern has been very
successful in [D3](http://d3js.org/). Here, we've removed the DOM entirely; BYO rendering pipeline.
