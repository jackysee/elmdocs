# elm-cart
Elm lang shopping Cart implementation. Provide a way to add/remove product to/from cart, increment and decrement quantity of product in a cart. Also calculate total quantity and cart subtotal. Cart item stores datetime when the product was added to a cart. This date should be passed to ```add``` function as present in the example below.

Please look into examples/Cartapp.elm for the reference.

```elm
  import Cart exposing (..)

  type alias Product = { id : Int, price : Float, title : String }
  apple = Product 1 10.0 "Apple"

  add apple cart 12345 ==
    [{ product = { id = 1, price = 10.0, title = "Apple" }, qty = 1, date_added = 12345 }]
  inc apple (add apple cart 12345 ) ==
    [{ product = { id = 1, price = 10.0, title = "Apple" }, qty = 2, date_added = 12345 }]


  subtotal .price (add apple cart 12345) == 10.0
  subtotal .price (inc apple (add apple cart 12345)) == 20.0

```


You can also find Cart examples in tests/CartTests.elm file.
