# elm-net

Elm-net is an Elm library that provides a Hidden Layer Neural Net, forward,
and backpropagation algorithms for training. The backpropagation algorithm
is adapted from [this blog post](https://mattmazur.com/2015/03/17/a-step-by-step-backpropagation-example/).

A demo of the Neural Net can be found [here](https://github.com/cakenggt/elm-net-demo).

# Examples

To create a Neural Net immediately, use the deterministic creation function, providing
a seed value for the Random library to create the initial weights.

```
-- Creates a Neural Net with 2 input nodes, 2 hidden nodes, and 1 output node
net = createNetDeterministic 2 2 1 547623465437
```

To get a truly random Neural Net, use the random creation function to create
a command which will give you the Net in your update function. You can see in the
following stripped down example that the init function returns a deterministic
initial Net and also a command to create a truly random net, which the update
function uses to replace the model.

```
init : ( Net, Cmd Msg )
init =
	createNetDeterministic 2 2 1 547623465437 ! [ createNetRandom 2 2 1 NewNet ]

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
	case msg of
		NewNet net ->
			net ! []
```

To get values out of your Neural Net, you must pass in the Net and a list of input
values. This will provide you with a list of output values. The list of input values
must be exactly as large as the number of input nodes in the net.

```
-- net is a Neural Net with 2 inputs and 1 output
forwardPass net [1, 0] == [0.346433]
```

To train the Neural Net, we must create one or more `TrainingSet`s which have
a list of input values and the expected output values for that input. The length
of the list in the input and target sections of the training set must be equal to
the input and output sizes of the Neural Net. The first parameter to `TrainingSet`
is the input list, the second is the target list.

```
-- This would be the training set list for XOR
[ TrainingSet [0,0] [0]
, TrainingSet [0,1] [1]
, TrainingSet [1,0] [1]
, TrainingSet [1,1] [0]]
```

The backpropagation algorithm will take in the neural net, a learning rate (usually between 0 and 1),
a list of `TrainingSet`s, and a number of times to train the net. It will return the newly
trained net.

```
backpropagateSet net 0.5 [TrainingSet [1,0] [1]] 1000 /= net
```
