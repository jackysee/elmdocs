# Folding (by Composing) a list of functions by means of an accumulator function.

Before showing how to write a function that folds a list of functions, let's go throw two simple use-cases: filtering with multiple predicate functions and sorting with multiple compare functions.

## Filtering with a list of predicates

we want to filter a list of integers [-100..100] in order to keep
 - the integer '0'
 - all numbers greater than 99
 - all numbers lower than -99
 - any number between -20 and 20 that is a multiple 7

the filter function can be created dynamicaly by combining **orN** and **andN** functions with lists of predicates functions.

    fun = orN [ (\x->x==0)
              , (\x->x<(-99))
              , (\x->x>99)
              , andN [ (\x->(rem x 7)==0)
                     , (\x->x<20)
                     , (\x->x>(-20))
                     ]
              ]
    result = List.filter fun [-100..100]
    expected = [-100,-14,-7,0,7,14,100]

## Sorting with a list of compare functions

we want to sort a list of persons by name, age and adresse.  The resulting compare function can been written directly in elm code in a static way, but the whole point here is to have a compare function that can be change a runtime. Imagine a table rendered in your application and you want to let the user change the sort order.

The compare function can be created dynamically with the **compareN** function and a list of compare functions.

    type alias Person = { name: String
                        , age : Int
                        , adr : String
 
    louis id age adr = Person
                      ("Louis"++(toString id))
                      age
                      ((toString adr))}

    fun = compareN [ (\x y -> compare x.name y.name)
                   , (\x y -> compare x.age y.age)
                   , (\x y -> compare x.adr y.adr)
                   ]
                          
    sortedList = List.sortWith fun [ louis 2 1 1                                               
                                   , louis 1 2 2
                                   , louis 1 1 1
                                   , louis 1 2 3                                                
                                   , louis 2 1 2
                                   , louis 1 2 2
                                   ]
    expected = [ louis 1 1 1
               , louis 1 2 2
               , louis 1 2 2
               , louis 1 2 3
               , louis 2 1 1
               , louis 2 1 2
               ]

## Writing your own function folding functions

Really simple to write, the **AndN** function is defined with **foldlFun** and accumulator function (&&) and an initial value (False).

    andN : List (a->Bool) -> a -> Bool
    andN =
      foldlFun (&&) False


## Have fun and create your own!


