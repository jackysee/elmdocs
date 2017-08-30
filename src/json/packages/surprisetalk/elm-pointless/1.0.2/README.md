
# Pointless

Transform function arguments with infix operators.

Here's why I named this library "pointless":
- there's pointy arrows
- encourages more less-confusing [point-free]() functions
- this library is pointless

## Tutorial

### Conventional Composition

Suppose we have a function.

``` elm
a_to_b : a -> b
```

Now let's transform the argument `a` into `x`.

``` elm
x_to_b : x -> b
x_to_b x = a_to_b (x_to_a x)
           -- wrap

x_to_b : x -> b
x_to_b x = x_to_a x |> a_to_b
           -- pipe

x_to_b : x -> b
x_to_b = x_to_a >> a_to_b
         -- compose
```

### Multivariate Composition

Easy! But what if our function has more variables?

``` elm
a_to_b_to_c : a -> b -> c
```

Also imagine we have some fun transformations that we want to apply to the function's *arguments*.

``` elm
x_to_a : x -> a
y_to_b : y -> b
```

Yeesh. It's painful to transform `b` alone.

``` elm
a_to_y_to_c : a -> y -> c
a_to_y_to_c a y = a_to_b_to_c a (y_to_b y)
                  -- wrap

a_to_y_to_c : a -> y -> c
a_to_y_to_c a y = y_to_b y |> a_to_b_to_c a 
                  -- pipe

a_to_y_to_c : a -> y -> c
a_to_y_to_c a = y_to_b >> a_to_b_to_c a 
                -- compose
```

Let's try this with the "flarg" operator.

``` elm
a_to_y_to_c : a -> y -> c
a_to_y_to_c = a_to_b_to_c 
              |~> identity ~> y_to_b ~> identity
              -- transform the second argument
```


### Composing Results

What if we want to change the *result* at the end?

``` elm
c_to_z : c -> z
```

Let's try this with conventional methods.

``` elm
a_to_b_to_z : a -> b -> z
a_to_b_to_z a b = c_to_z (a_to_b_to_c a b)
                  -- wrap

a_to_b_to_z : a -> b -> z
a_to_b_to_z a b = a_to_b_to_c a b |> c_to_z
                  -- pipe

a_to_b_to_z : a -> b -> z
a_to_b_to_z a = a_to_b_to_c a >> c_to_z
                -- compose

a_to_b_to_z : a -> b -> z
a_to_b_to_z = a_to_b_to_c >>> c_to_z
              -- super compose!
              -- (just kidding)
```

How does it look in a flarg-chain?

``` elm
a_to_b_to_z : a -> b -> z
a_to_b_to_z = a_to_b_to_c 
              |~> identity ~> identity ~> c_to_z
              -- transform the result
```


### Intermediate Transformations

Now let's do some more interesting stuff.

``` elm
x_to_y_to_z : x -> y -> z
x_to_y_to_z = a_to_b_to_c 
              |~> x_to_a ~> y_to_b ~> c_to_z
              -- transform both arguments and the result

x_to_b_to_z : x -> b -> z
x_to_b_to_z = a_to_b_to_c 
              |~> x_to_a ~> identity ~> c_to_z
              -- transform the first argument and the result
```

You can even chain the flarg-chains together!

``` elm
x_to_y_to_z : x -> y -> z
x_to_y_to_z = a_to_b_to_c 
              |~> identity ~> y_to_q   ~> identity
              |~> x_to_a   ~> identity ~> identity
              |~> identity ~> q_to_b   ~> c_to_z
```

Neato!


### Skipping Arguments

As you've probably noticed, `identity` can be pretty cumbersome. Let's add some sugar.

#### Skipping Middle Arguments

Here's how you skip an argument using the "narg" operators.

``` elm
x_to_b_to_z : x -> b -> z
x_to_b_to_z = a_to_b_to_c 
              |~> x_to_a ~> identity ~> c_to_z

x_to_b_to_z : x -> b -> z
x_to_b_to_z = a_to_b_to_c 
              |~> x_to_a -~> c_to_z
```

I interpret `-~>` as: 
- `-` : skip arg
- `~` : transform arg
- `>` : flow

#### Skipping Beginning Arguments
                  
And here's how you skip the first argument using the "barg" operators.

``` elm
a_to_y_to_z : a -> y -> z
a_to_y_to_z = a_to_b_to_c 
              |~> identity ~> y_to_b ~> c_to_z

a_to_y_to_z : a -> y -> z
a_to_y_to_z = a_to_b_to_c 
              |-~> y_to_b ~> c_to_z
```

Think of `|-~>` like: 
- `|` : begin flarg-chain
- `-` : skip arg
- `~` : transform arg
- `>` : flow

#### Skipping Two Middle Arguments

You can skip two arguments by replacing your hyphen (`-`) with an equals (`=`).

``` elm
p_to_b_to_c_to_s : p -> b -> c -> s
p_to_b_to_c_to_s = a_to_b_to_c_d 
                   |~> p_to_a ~> identity ~> identity ~> d_to_s

p_to_b_to_c_to_s : p -> b -> c -> s
p_to_b_to_c_to_s = a_to_b_to_c_d 
                   |~> p_to_a ~> identity -~> d_to_s

p_to_b_to_c_to_s : p -> b -> c -> s
p_to_b_to_c_to_s = a_to_b_to_c_d 
                   |~> p_to_a -~> identity ~> d_to_s

p_to_b_to_c_to_s : p -> b -> c -> s
p_to_b_to_c_to_s = a_to_b_to_c_d 
                   |~> p_to_a =~> d_to_s
```

We can break `=~>` up like so: 
- `=` : skip two args
- `~` : transform arg
- `>` : flow

#### Skipping Two Beginning Arguments

Double-skipping also works for bargs.

``` elm
a_to_b_to_z : a -> b -> z
a_to_b_to_z = a_to_b_to_c 
              |~> identity ~> identity ~> c_to_z

a_to_b_to_z : a -> b -> z
a_to_b_to_z = a_to_b_to_c 
              |-~> identity ~> c_to_z

a_to_b_to_z : a -> b -> z
a_to_b_to_z = a_to_b_to_c 
              |=~> c_to_z
```

We can break `=~>` up like so: 
- `|` : begin flarg-chain
- `=` : skip two args
- `~` : transform arg
- `>` : flow
                  

### Ending Chains

Recall that we can "collapse" repeated `~> identity` at the end of our flarg-chain.

``` elm
a_to_y_to_c_to_d : a -> y -> c -> d
a_to_y_to_c_to_d = a_to_b_to_c_to_d
                   |~> identity ~> y_to_b ~> identity ~> identity
                   -- expanded

a_to_y_to_c_to_d : a -> y -> c -> d
a_to_y_to_c_to_d = a_to_b_to_c_to_d
                   |~> identity ~> y_to_b ~> identity
                   -- hooray for currying!

a_to_y_to_c_to_d : a -> y -> c -> d
a_to_y_to_c_to_d = a_to_b_to_c_to_d
                   |-~> y_to_b ~> identity
                   -- skip the first argument

a_to_y_to_c_to_d : a -> y -> c -> d
a_to_y_to_c_to_d = a_to_b_to_c_to_d
                   |-~-> y_to_b
                   -- skip the first argument
                   -- then process `y_to_b`
                   -- then skip another argument (end the chain)
```

I like to represent `|-~->` as the following: 
- `|` : begin flarg-chain
- `-` : skip an arg
- `~` : transform arg
- `-` : end the flarg-chain
- `>` : flow
                  


## Inspiration

* https://www.reddit.com/r/haskell/comments/ej646/composing_over_later_arguments/c18jgtz/
  * http://matt.immute.net/content/pointless-fun
  * http://conal.net/blog/posts/semantic-editor-combinators


## Further Reading

* https://wiki.haskell.org/Pointfree
