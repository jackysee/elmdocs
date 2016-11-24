Mechanics
=========

This package is a framework for running physics simulations. You provide it with the
initial conditions and a set of differential equations, and it approximates how
the system changes over time.

[Here is a demo.](https://nphollon.github.io/pendulum.html)

This package does not yet know any physics (see below). In the example above, the equations for
the pendulum's motion were worked out by hand, and `Mechanics.evolve` was
used for animation.

## Coming Soon
  
We plan on introducing Lagrangian mechanics in version 3.1. The library will be able to compute the evolution of the system when given expressions for the kinetic and potential energies.

After 3.1 is released, expect to see some tutorials. In the meantime, please reach out to us on Github if you have any questions or feedback.