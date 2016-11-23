# elm-widgets
Analog control widgets in ELM (unpublished) written in elm-svg

demo: https://obscure-sands-3870.herokuapp.com/

### Seven Segment
```sh
sevenSegment : SevenSegmentProperties -> SevenSegmentStyle -> Svg
```
usage example:
```sh
let sevenSegmentProperties = { defaultSevenSegmentProperties | digits <- "1020" }
    sevenSegmentStyle = { defaultSeventSegmentStyle | textColor <- "#AAF"
                                                    , backgroundColor <- "#FFF" }
in sevenSegment sevenSegmentProperties sevenSegmentStyle
```

### Segmented Bar Graph
```sh
segmentedBarGraph : SegmentedBarGraphProperties -> SegmentedBarGraphStyle -> Svg
```
usage example:
```sh
let segmentedBarGraphProperties = { defaultSegmentedBarGraphProperties | digits <- "1020" }
    segmentedBarGraphStyle = { defaultSegmentedBarGraphStyle  | emptyColor <- "#555"
                                                              , backgroundColor <- "#FFF" }
in segmentedBarGraph segmentedBarGraphProperties segmentedBarGraphStyle
```

### Simulated Analog Meter
```sh
simulatedAnalogMeter : SimulatedAnalogMeterProperties -> SimulatedAnalogMeterStyle -> Svg
```
usage example:
```sh
let simulatedAnalogMeterProperties =
      { defaultSimulatedAnalogMeterProperties | currentValue <- "22"
                                              , ranges <- [ { color = "#00F"
                                                            , minValue = 0
                                                            , maxValue = 29.99 }
                                                          , { color = "#0F0"
                                                            , minValue = 0
                                                            , maxValue = 70.99 }
                                                          , { color = "#F00"
                                                            , minValue = 0
                                                            , maxValue = 70.99 ]}
    simulatedAnalogMeterStyle = defaultSimulatedAnalogMeterStyle
in simulatedAnalogMeter simulatedAnalogMeterProperties simulatedAnalogMeterStyle
```

Installation:
elm-package install remoteradio/elm-widgets
