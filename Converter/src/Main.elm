import Browser
import Html exposing (Html, Attribute, span, div, input, text)
import Html.Attributes exposing (style, value)
import Html.Events exposing (onInput)

-- MAIN

main =
    Browser.sandbox { init = init, update = update, view = view }

-- MODEL

type alias Model =
    { celsius : String
    , farenheit : String
    , inch : String
    , meter : String
    , change : (String, String)
    }

init : Model
init =
    { celsius = ""
    , farenheit = ""
    , inch = ""
    , meter = ""
    , change = ("", "")
    }

-- UPDATE

type Msg
    = Celsius String
    | Farenheit String
    | Meter String
    | Inch String

update : Msg -> Model -> Model
update msg model =
    case msg of
        Celsius input ->
            { model
            | celsius = input
            , change = ("celsius", Tuple.second model.change)
            }
        Farenheit input ->
            { model
            | farenheit = input
            , change = ("farenheit", Tuple.second model.change)
            }
        Meter input ->
            { model
            | meter = input
            , change = (Tuple.first model.change, "meter")
            }
        Inch input ->
            { model
            | inch = input
            , change = (Tuple.first model.change, "inch")
            }

-- VIEW

view : Model -> Html Msg
view model =
    div []
    [ viewTemp model
    , viewDist model
    ]

viewTemp : Model -> Html Msg
viewTemp model =
    if Tuple.first model.change == "celsius" && String.length model.celsius > 0 then
        case String.toFloat model.celsius of
            Just val ->
                viewConv2 model.celsius "black" "none" (String.fromFloat (val * 1.8 + 32))

            Nothing ->
                viewConv2 model.celsius "red" "solid" "???"
    else if Tuple.first model.change == "farenheit" && String.length model.farenheit > 0 then
            case String.toFloat model.farenheit of
                Just val ->
                    viewConv2 (String.fromFloat ((val - 32) / 1.8)) "black" "none" model.farenheit
                Nothing ->
                    viewConv2 "???" "red" "solid" model.farenheit
    else if String.length model.celsius > 0 && String.length model.farenheit > 0 then
        viewConv2 model.celsius "black" "solid" model.farenheit
    else
        viewConv2 "" "black" "solid" ""

viewConv2 : String -> String -> String -> String -> Html Msg
viewConv2 celsius color border farenheit =
    div []
    [ input [ value celsius, onInput Celsius, style "width" "40px", style "color" color ] []
    , text "°C = "
    , input [ value farenheit, onInput Farenheit, style "width" "40px", style "color" color] []
    , text "°F"
    ]

viewDist : Model -> Html Msg
viewDist model =
    if Tuple.second model.change == "meter" && String.length model.meter > 0 then
        case String.toFloat model.meter of
            Just val ->
                viewDist2 model.meter "black" "none" (String.fromFloat(val * 39.4))

            Nothing ->
                viewDist2 model.meter "red" "solid" "???"
    else if Tuple.second model.change == "inch" && String.length model.inch > 0 then
            case String.toFloat model.inch of
                Just val ->
                    viewDist2 (String.fromFloat(val * 0.0254)) "black" "none" model.inch
                Nothing ->
                    viewDist2 "???" "red" "solid" model.farenheit
    else if String.length model.meter > 0 && String.length model.inch > 0 then
        viewDist2 model.meter "black" "solid" model.inch
    else
        viewDist2 "" "black" "solid" ""

viewDist2 : String -> String -> String -> String -> Html Msg
viewDist2 celsius color border farenheit =
    div []
    [ input [ value celsius, onInput Meter, style "width" "40px", style "color" color ] []
    , text "m = "
    , input [ value farenheit, onInput Inch, style "width" "40px", style "color" color] []
    , text "in"
    ]
