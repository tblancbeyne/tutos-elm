import Browser
import Html exposing (Html, Attribute, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)

-- MAIN

main =
  Browser.sandbox { init = init, update = update, view = view }



-- MODEL

type alias Model =
  { content : String
  }


init : Model
init =
  { content = "" }



-- UPDATE

type Msg
  = Change String | Reset


update : Msg -> Model -> Model
update msg model =
  case msg of
    Change newContent ->
      { model | content = newContent }
    Reset ->
      { model | content = ""}



-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ input [ placeholder "Text to reverse", value model.content, onInput Change, onClick Reset ] []
    , div [] [ text (String.reverse model.content) ]
    ]
