# Gigan

### NOTE:

This package has been renamed to williamwhitacre/scaffold for the sake of explicit naming policy.
Core has been renamed to App, since it represents the means by which one sets up the root of an
application, Stem has been renamed to Machine because of it's role in representing and manipulating
instantaneous descriptions of state, Knowledge has been renamed to Resource to explicate it's role
in managing (possibly) remote resources, and the Orbiter concept has been renamed to Program to
explicate it's role in defining per-component programs. Please inquire
[here](http://package.elm-lang.org/packages/williamwhitacre/scaffold/) for the latest work on this
package.


## What is this?

Gigan is an application programming framework for Elm. It's goals are as follows:

1. Supply a fully functioning component system with the prettiest syntax possible.
2. Provide a dynamic environment in which to construct the view output of a component so that any large views can be efficiently updated in a scalable way.
3. Supply a system with a rich and comprehensive DSL that models and maps data or components in a succinct and powerful nestable way. Ultimately, the intent is to, at worst, at least have the _ease of use of_ the active record pattern.


## How do I use it?

A comprehensive set of runnable examples is underway. Right now, the only working example is a full
production application that will be released before the end of April, 2016. Time should allow me to
complete the examples sometime before that as well.

In the meantime, if you are the sort of person who likes to study, then I suggest reading the
documentation and code thoroughly, as a lot is explained, albeit in overwhelming volume to the
uninitiated. The examples are obviously intended to cure this and lend these modules some
credibility.


## Is it done?

Never. Basically. Sort of. Everything contained herein works. That, however, does not have any
bearing on whether or not it is done. There are further development plans beyond the examples for
this first usable edition. These include:

1. Convert Layout to use HTML instead of Graphics, given that Graphics is no longer under active development to the best of my knowledge. To avoid forcing the version up again, this will be placed in a new module called Layout2.
2. Build a set of database back-end adapters for the Knowledge system for general use. Currently, we have one for internal use that I do not believe is clean enough to give out as-is. For this reason, Gigan's provided back-end and localstorage adapters for knowledge base will be released only when deemed fit to share. This is also likely to happen soon, within two months.


## Getting Started

The following is the list of currently planned examples in the short term. The first of these is
written, the others will follow very soon.

1. `HelloGigan_ex0.elm`     -- The obligatory hello example, which demonstrates how to set up your first orbiter.
2. `UsingStems_ex1.elm`     -- Showing how to use the Stem module to build components.
3. `UsingKnowledge_ex2.elm` -- Build on the Stem example by using KnowledgeBase for collections within components.
4. `StemKnowledge_ex3.elm`  -- An example of how to build a dynamic collection of like components using Stem and KnowledgeBase in conjunction.


## Software License

Gigan is released under the BSD3 license. The full text of this license is available in the `LICENSE`
file in the source repository, and it is also available from
[here](https://opensource.org/licenses/BSD-3-Clause).
