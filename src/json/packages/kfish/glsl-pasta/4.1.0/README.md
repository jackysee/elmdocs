# glsl-pasta

This is a crude way of combining GLSL shaders for use with Elm
[webgl](http://package.elm-lang.org/packages/elm-community/elm-webgl/latest/WebGL).

GLSLPasta allows you to extract common functionality from shaders into reusable Components,
then combine these to generate specific shaders.

This package also includes a library of common routines for generating lighting shaders,
with or without normal and diffuse texture maps.

Some terminology, then a quick example.

## Components

GLSLPasta components contain blocks of code which get pasted together to form a shader. These include:

  * Globals: declarations of attributes, uniforms, varyings and const values
  * Functions: the text of entire functions
  * Splices: snippets of code that get spliced into main()

Each component additionally specifies:

  * Dependencies: a list of other Components which GLSLPasta will automatically include
  * Provides: a list of Features, given as arbitrary Strings, which this component provides
  * Requirements: a list of Features which this component needs

You combine a list of components together with a call to `GLSLPasta.combine`, which will automatically
pull in dependencies and will check that requirements are satisfied:

```elm
   combine : List Component -> String
```

the output of which you can pass to `WebGL.unsafeShader`.


## Examples

Various lighting components are provided in the module `GLSLPasta.Lighting`. Some preliminary imports:


```elm
import GLSLPasta
import GLSLPasta.Lighting exposing (..)
import WebGL
```

## Vertex Shader Example

You could construct a shader that interpolates between vertex normals using:

```elm
interpolateNormals =
    GLSLPasta.combine [ vertex_gl_Position, vertexNoTangent ]
    |> WebGL.unsafeShader
```

or you could construct a similar shader that uses a texture to provide normals:


```elm
textureNormals =
    GLSLPasta.combine [ vertex_gl_Position, vertex_vTexCoord, vertexNoTangent ]
    |> WebGL.unsafeShader
```

Alternatively you could construct a vertex shader that generates normals via a
Tangent, Bitangent, Normal (TBN) matrix:

```elm
textureNormals =
    GLSLPasta.combine [ vertex_gl_Position, vertex_vTexCoord, vertexTBN ]
    |> WebGL.unsafeShader
```

## Fragment Shader Examples


`GLSL.Lighting` provides components which implement variations of the Phong shading model, such as
`fragment_lambert`, `fragment_diffuse` and `fragment_specular`.

You may have alternative ways of providing input to these. For example, `fragment_lambert` requires
a `pixelNormal`. If we are using any of the vertex shaders above, we could calculate these via
interpolation between vertices:


```elm
                [ fragment_interpolatedNormal, fragment_lambert ]
```

However if we additionally have a normal texture map available, and we use one of the above shaders that
generates `vTexCoord`, we can modify this to:

```elm
                [ fragment_textureNormal, fragment_lambert ]
```

which will include the extra globals:

```elm
        , globals =
            [ Uniform "sampler2D" "textureNorm"
            , Varying "vec2" "vTexCoord"
            ]
```


Similarly for diffuse maps, we could specify


```elm
                [ fragment_textureDiffuse, fragment_diffuse ]
```

for objects with diffuse maps, or


```elm
                [ fragment_constantDiffuse, fragment_diffuse ]

```

to generate a simple shader with constant `diffuseColor`.

## Error handling

Note that `fragment_diffuse` simply requires that some earlier Component has generated `diffuseColor`. What if
this requirement is not met?

```elm
> import GLSLPasta exposing (..)
> import GLSLPasta.Lighting exposing (..)
> combine [ fragment_diffuse ]
Missing requirement diffuseColor, needed by lighting.fragment_diffuse: "<<GLSLPasta>>"
""
    : String
```

`GLSLPasta.combine` will log errors to the Javascript console, and return an empty String.

## Putting it all together

A complete Phong lighting shader generates `gl_FragColor` with `fragment_phong`, which requires
that earlier components have generated "ambient", "diffuse", "specular" and "attenuation".

A complete shader that supports normal and diffuse maps looks like:

```elm
normalDiffuseTextures =
    GLSLPasta.combine
        [ fragment_textureNormal
        , fragment_lambert
        , fragment_textureDiffuse
        , fragment_diffuse
        , fragment_ambient_03
        , fragment_specular
        , fragment_attenuation
        , fragment_phong
        ]
    |> WebGL.unsafeShader
```

whereas a simpler shader that interpolates normals and uses a constant diffuseColor looks like:


```elm
simplePhong =
    GLSLPasta.combine
        [ fragment_interpolatedNormal
        , fragment_lambert
        , fragment_constantDiffuse
        , fragment_diffuse
        , fragment_ambient_02
        , fragment_specular
        , fragment_attenuation
        , fragment_phong
        ]
    |> WebGL.unsafeShader
```


## Implementation

You define a part of a shader with type `Component`:

```elm
    type alias Component =
        { id : ComponentId -- used in error messages
        , dependencies : Dependencies
        , provides : List Feature
        , requires : List Feature
        , globals : List Global
        , functions : List Function
        , splices : List Splice
        }
```

Most of these fields are `String`s, apart from dependencies (which wraps a list of other `Component`s) and
`Global`s, which are:

```elm
type Global
    = Attribute Type Name
    | Uniform Type Name
    | Varying Type Name
    | Const Type Name Value
```

where, again, `Type`, `Name` and `Value` are just `String`s.

## How it works

Once all dependencies and requirements are resolved, GLSLPasta simply generates code for the globals
and fills in the functions and main() splices according to a template.
The default template is:

```elm
   defaultTemplate : String
   defaultTemplate =
   """
   precision mediump float

   __PASTA_GLOBALS__

   __PASTA_FUNCTIONS__

   void main()
   {
       __PASTA_SPLICES__
   }

   """
```

Here, `__PASTA_GLOBALS__` is replaced with a all the globals from all the Components (with duplicates removed),
`__PASTA_FUNCTIONS__` is replaced with all the functions from all the Components,
and `__PASTA_SPLICES__` is replaced with all the splices from all the Components, in the order the list of Components.

Note that the functions and splices are replaced as arbitrary strings, and glsl-pasta makes no
attempt to parse or sanity-check these.


## Credits

The code in GLSLPasta.Lighting is extracted from @Zinggi's example code in
[elm-object-loader](https://github.com/Zinggi/elm-obj-loader/tree/master/examples).
