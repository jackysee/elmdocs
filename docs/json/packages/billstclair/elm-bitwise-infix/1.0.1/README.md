# Infix versions of Elm's Bitwise module functions

When converting code from JavaScript, it's a real pain to change all the bitwise operators from infix to prefix. This module makes that unnecessary. You just add a twiddle prefix (~) to the operators.

```Bitwise.not``` has no infix operator, since Elm doesn't provide single argument "infix" operators. So I named it ```BitwiseInfix.lognot```, in honor of its Common Lisp name.

All the operators are left associative.

I mirrored the [JavaScript precedences](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Operator_Precedence), putting the shift operators at lower precedence than arithmetic, but higher than comparison, and the others lower than comparison.

```(~<<)```, ```(~>>)```, and ```(~>>>)``` have a precedence of 5.<br/>
```(~&)``` has a precedence of 3.<br/>
```(~^)``` has a precedence of 2.<br/>
```(~|)``` has a precedence of 1.

Examples:

```
import BitwiseInfix exposing (..)

3 ~& 1 ~| 4 ~& 12     -- 5
3 ~& (1 ~| 4) ~& 12   -- 0
2 ~<< 1 ~| 2          -- 6
2 ~<< (1 ~| 2)        -- 16
1 ~| 2 ~^ 2 ~| 1      -- 1
(1 ~| 2) ~^ (2 ~| 1)  -- 0
3 ~& 1 ~^ 4 ~& 12     -- 5
3 ~& (1 ~^ 4) ~& 12   -- 0
9 ~>> 1 ~<< 1         -- 8
9 ~>> (1 ~<< 1)       -- 2
```

