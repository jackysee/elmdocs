# Intro

Wrapper for the Stripe Checkout embedded form. See [this link](https://stripe.com/docs/checkout/tutorial) for the official documentation

# Data
i@docs Model 
Model is A simple structural type that contains all of the information passed as data-attributes to Stripe checkout script.

@docs checkout 
checkout is the function that, taking a model, returns the HTML configured with that model. It will be the "Pay with Card" button from the above linked tutorial.

-}

