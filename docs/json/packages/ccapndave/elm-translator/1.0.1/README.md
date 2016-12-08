# elm-translator

This is package to provide type safe internationalisation, where translations can be loaded at
runtime.  Default translations, substitutions and pluralization are supported.

Substitutions are implemented by surrounding the literal in braces:

```
{
  "MyNameIs": "Je m'appelle {name}"
}
```

Pluralization is implemented by having the singular case on the left of the pipe symbol, and all
other cases on the right.  The number can be substituted using `{count}`.

```
{
  "MyAge": "I am only one year old|I'm {count} years old"
}
```

See the `example/` directory for an example of the package being used.
