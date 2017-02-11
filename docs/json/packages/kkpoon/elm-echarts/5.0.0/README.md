# elm-echarts

This is a [EChart](http://echarts.baidu.com/) chart option types
collection and a helper to use
[EChart WebComponent](https://github.com/kkpoon/echarts-webcomponent).

## Why Web Component?

Please watch [this](https://www.youtube.com/watch?v=ar3TakwE8o0&t=1s)
video about Elm and Web Components by Richard Feldman


## How to use?

Install the webcomponent and the dependencies from [bower](https://bower.io/)

```shell
bower install --save echarts-webcomponent
```

Add the following to your `.html` file

```html
<html>
  <head>
    <!-- your other header tags -->
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <script src="bower_components/webcomponentsjs/webcomponents-lite.min.js"></script>
    <script src="bower_components/custom-elements/custom-elements.min.js"></script>
    <script src="bower_components/echarts/dist/echarts.min.js"></script>
    <link rel="import" href="bower_components/echarts-webcomponent/echarts-webcomponent.html" />
    <!-- your other header tags -->
  </head>
  <body>
    <!-- your body -->
  </body>
</html>
```

Install `elm-echarts`

```shell
elm package install elm-echarts
```

Code

```elm
let
    title =
        { defaultTitleOption
            | text = Just "Website Traffic Sources"
            , subtext = Just "Demo Data"
            , left = Just "center"
        }

    tooltip =
        { defaultTooltipOption
            | formatter = Just "{a} <br/>{b} : {c} ({d}%)"
        }

    legend =
        { defaultLegendOption
            | orient = Just ECharts.Style.Vertical
            , left = Just "left"
            , data =
                Just <|
                    List.map
                        (\name ->
                            { name = name
                            , icon = ""
                            , textStyle = defaultTextStyleOption
                            }
                        )
                        [ "Direct", "EDM", "WebAds", "VideoAds", "Search Engine" ]
        }

    series =
        { defaultPieSeriesOption
            | radius = Just ( "0", "55%" )
            , center = Just ( "50%", "60%" )
            , data =
                Just
                    [ { value = 335, name = "Direct" }
                    , { value = 310, name = "EDM" }
                    , { value = 234, name = "WebAds" }
                    , { value = 135, name = "VideoAds" }
                    , { value = 1548, name = "Search Engine" }
                    ]
            , itemStyle =
                Just
                    { emphasis =
                        Just
                            { shadowBlur = Just 10
                            , shadowOffsetX = Just 0
                            , shadowColor = Just "rgba(0, 0, 0, 0.5)"
                            }
                    }
        }

    pieChart =
        PieChart
            ({ defaultPieChartOption
                | title = Just title
                , tooltip = Just tooltip
                , legend = Just legend
                , series = Just [ series ]
             }
            )

    chartOption =
        toJsonString pieChart
in
    node "echarts-webcomponent"
        [ style [ ( "width", "400px" ), ( "height", "300px" ) ]
        , attribute "option" chartOption
        ]
        []
```
