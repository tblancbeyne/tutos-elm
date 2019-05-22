import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random
import Svg exposing (..)
import Svg.Attributes exposing (..)



-- MAIN


main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }



-- MODEL


type alias Model =
  { dieFaces : List Int
  }


init : () -> (Model, Cmd Msg)
init _ =
  ( Model [1,1]
  , Cmd.none
  )

roll : Random.Generator Int
roll =
  Random.weighted
    (10, 1)
    [ (10, 2)
    , (10, 3)
    , (10, 4)
    , (20, 5)
    , (0, 6)
    ]


-- UPDATE


type Msg
  = Roll
  | NewFaces (List Int)
  | Add


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll ->
      ( model
      , Random.generate NewFaces (Random.list (List.length model.dieFaces) (roll))
      )

    Add ->
      ( Model (1 :: model.dieFaces)
      , Cmd.none
      )

    NewFaces newFaces ->
      ( Model newFaces
      , Cmd.none
      )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ -- div [] [ img [ src ("resources/dice" ++ String.fromInt model.dieFace ++ ".png") ] [] ]
      div [] (List.map viewdie model.dieFaces)
    , div [] [ button [ onClick Roll ] [ Html.text "Roll" ]
             , button [ onClick Add ] [ Html.text "Add" ]
             ]
    ]


viewdie : Int -> Svg Msg
viewdie dieFace =
    (svg [ Svg.Attributes.width "200", Svg.Attributes.height "200", viewBox "0 0 120 120", strokeWidth "3" ]
                  (List.append
                        [ rect [ x "10", y "10", Svg.Attributes.width "100", Svg.Attributes.height "100", rx "30", ry "30", fill "white", stroke "black"] [] ]
                        (viewdieface dieFace)))


viewdieface : Int -> List(Svg Msg)
viewdieface dieFace =
    case dieFace of
        1 -> [ circle [ cx "60", cy "60", r "10", fill "green" ] [] ]
        2 -> [ circle [ cx "30", cy "30", r "10", fill "blue" ] []
             , circle [ cx "90", cy "90", r "10", fill "red" ] []
             ]
        3 -> [ circle [ cx "30", cy "30", r "10", fill "yellow" ] []
             , circle [ cx "60", cy "60", r "10", fill "orange" ] []
             , circle [ cx "90", cy "90", r "10", fill "purple" ] []
             ]
        4 -> [ circle [ cx "30", cy "30", r "10", fill "green" ] []
             , circle [ cx "90", cy "90", r "10", fill "blue" ] []
             , circle [ cx "90", cy "30", r "10", fill "orange" ] []
             , circle [ cx "30", cy "90", r "10", fill "yellow" ] []
             ]
        5 -> [ circle [ cx "30", cy "30", r "10", fill "red" ] []
             , circle [ cx "90", cy "90", r "10", fill "blue" ] []
             , circle [ cx "90", cy "30", r "10", fill "yellow" ] []
             , circle [ cx "30", cy "90", r "10", fill "purple" ] []
             , circle [ cx "60", cy "60", r "10", fill "orange" ] []
             ]
        6 -> [ circle [ cx "30", cy "30", r "10", fill "red" ] []
             , circle [ cx "30", cy "60", r "10", fill "green" ] []
             , circle [ cx "30", cy "90", r "10", fill "blue" ] []
             , circle [ cx "90", cy "30", r "10", fill "orange" ] []
             , circle [ cx "90", cy "60", r "10", fill "yellow" ] []
             , circle [ cx "90", cy "90", r "10", fill "purple" ] []
             ]
        _ -> [ circle [ cx "30", cy "30", r "10", fill "none", stroke "red" ] [] ]
