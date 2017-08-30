# elm-infinite-zipper

An infinite zipper list that will always focus on an element. Once a zipper is initialized, you can move backwards and forwards and the zipper will circle around once it passes an end focus.

When the cursor is at the end of the list, right will return focus to the front of the list.  
When the cursor is at the beginning of the list, previous will return focus to the end of the list.  

## As an example:

```
  InfiniteZipper.fromListWithDefault 4 [1, 2, 3]  
    |> InfiniteZipper.next  
    |> InfiniteZipper.next  
    |> InfiniteZipper.next  
    |> InfiniteZipper.current  
    -- 1  
```
