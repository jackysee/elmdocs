## Natural numbers 

A library for natural numbers. Every natural number is either a zero or a positive number. The numbers are
represented as [Peano](https://en.wikipedia.org/wiki/Peano_axioms) numbers using only zero value and a successor
function.

```elm
type Nat = Z | S Nat
```