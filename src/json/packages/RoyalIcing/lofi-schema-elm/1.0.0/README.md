# #lofi #schema in Elm

Low fidelity schemas. Write with a friendly syntax and convert to other forms easily.

## Interactive demo

I’ve made an [online tool to convert #lofi schemas](https://schema.lofi.design/). Convert to React PropTypes, Mongoose schemas, Joi validations, and MySQL commands.

## Basic usage

```elm
lofiContent = "Click me #button #primary"
lofiElement = Lofi.parseElement lofiContent
```
