# Filtering  of n-triples

[![Build Status](https://travis-ci.org/flarebyte/ntriples-filter.svg?branch=master)](https://travis-ci.org/flarebyte/ntriples-filter)

> This library provides an easy way of filtering a list of simplified n-triples. A simplified n-triple with a subject, a predicate and an object. It is simplified because it does not discriminate between URI, blank node, language or datatype. More about [RDF n-triples](https://en.wikipedia.org/wiki/N-Triples)

## Getting Started

### Installing Elm packages

There is no dependency.

```
elm-app package install <package-name>
```

## Create a n-triple

Create a simplified n-triple with a subject, a predicate and an object.

```
createTriple "http://example.org/show/218" "http://www.w3.org/2000/01/rdf-schema#label" "That Seventies Show"
```

Please note that intentionally this library has a very casual approach to the specs, and any string will be accepted.

## Filter a list of n-triples

Filter a list of n-triples based on a filter expression.

```
-- Select only the triples which have a given subject
filter (WithSubject (Equals "http://example.org/show/218")) listOfTriples

-- Select only the triples which have a label and which starts with "That"
filter (And (WithPredicate (Equals "http://www.w3.org/2000/01/rdf-schema#label"))(WithObject (StartsWith "That")) ) listOfTriples
```

## Filter expression

| Type          | Description                                                                                                             |
|---------------|-------------------------------------------------------------------------------------------------------------------------|
| WithSubject   | Specify a criteria for the subject field.                                                                               |
| WithPredicate | Specify a criteria for the predicate field.                                                                             |
| WithObject    | Specify a criteria for the object field.                                                                                |
| Not           | Inverts the effect of a filter expression and returns a list of triples that does not match it.                         |
| And           | Joins filter expressions clauses with a logical AND returns all the triples that match the conditions of both clauses.  |
| Or            | Joins filter expressions clauses with a logical OR returns all the triples that match the conditions of either clauses. |

## Field comparator

| Type               | Description                                                                 |
|--------------------|-----------------------------------------------------------------------------|
| IsEmpty            | Determine if the field is empty.                                            |
| Equals             | Determine if the field is equal to the given value.                         |
| StartsWith         | Determine if the field starts with the given value.                         |
| EndsWith           | Determine if the field ends with the given value.                           |
| Contains           | Determine if the field contains the given value.                            |
| Regx               | Determine if the field satisfies the given regular expression.              |
| IsTrue             | Determine if the field is true (contains the string "true").                |
| IsFalse            | Determine if the field is true (contains the string "false").               |
| EqualsAny          | Determine if the field is equal any of the given values.                    |
| GreaterThan        | Determine if the field is greater than the given float value.               |
| GreaterThanOrEqual | Determine if the field is greater or equal to the given float value.        |
| LessThan           | Determine if the field is less than the given float value.                  |
| LessThanOrEqual    | Determine if the field is less or equal to the given float value.           |
| Custom             | Determine if the field satisfies a custom function against the given value. |

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

Managed automatically by [Elm version rules](https://github.com/elm-lang/elm-package#version-rules).

## Authors

* **Olivier Huin** - *Initial work* - [olih](https://github.com/olih)

See also the list of [contributors](https://github.com/flarebyte/ntriples-filter/graphs/contributors) who participated in this project.

## License

This project is licensed under the BSD 3-Clause License - see the [LICENSE.md](LICENSE) file for details
