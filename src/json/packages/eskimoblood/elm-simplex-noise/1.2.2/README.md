This is a library to generate simplex noise in Elm.

The code is a port of the [simplex noise JavaScript version](https://github.com/jwagner/simplex-noise.js) by Jonas Wagner.

## Example usage

    (perm, newSeed) = permutationTable (initialSeed 42) -- generate the permutation table
    noiseValue = noise3d perm 1 1 1
