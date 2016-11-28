## legacy-elm-test

An implementation of the legacy `ElmTest` module for backwards compatibility.

If you are currently using `ElmTest` and want to upgrade your version of
`elm-test` to access the improved test runners, but still want your existing
code to compile, just replace your current `import ElmTest` with this:

    import Legacy.ElmTest as ElmTest

That's it!

To get the equivalent for `Check.Test` (for `elm-check` integration), do this:

    import Legacy.Check.Test as CheckTest

(Then you'll probably want to find/replace `Check.Test` with `CheckTest`.)
