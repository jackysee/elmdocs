# Time Overlap Function

## Introduction

A module for obtaining non overlapping events from a list of event.

An Event is something that have a start and an end time and is represented as a
Tuple (start, end) in this library.


## Usage

```elm
events = [ (1.0, 5.0), (6.0, 10.0), (3.0, 7.0) ]

unOverlap identity events == [ [ (1.0, 5.0)
                               , (6.0, 10.0)
                               ]
                             , [ (3.0, 7.0) ]
                             ]
```

Look at the tests for an example with a record.
