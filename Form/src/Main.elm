import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)

-- MAIN

main =
    Browser.sandbox { init = init, update = update, view = view }

-- MODEL

type alias Model =
    { name : String
    , age : String
    , password : String
    , passwordAgain : String
    , submit : Bool
    }

init : Model
init =
    Model "" "" "" "" False

-- UPDATE

type Msg
    = Name String
    | Age String
    | Password String
    | PasswordAgain String
    | Submit

update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name }

        Age age ->
            { model | age = age }

        Password password ->
            { model | password = password }

        PasswordAgain password ->
            { model | passwordAgain = password }

        Submit ->
            { model | submit = True }

-- VIEW

view : Model -> Html Msg
view model =
    div []
    [ viewInput "text" "Name" model.name Name
    , viewInput "text" "Age" model.age Age
    , viewInput "password" "Password" model.password Password
    , viewInput "password" "Re-enter Password" model.passwordAgain PasswordAgain
    , viewPassword model
    , viewAge model
    , button [ onClick Submit ] [ text "Submit" ]
    ]

viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, value v, onInput toMsg ] []

viewPassword : Model -> Html msg
viewPassword model =
    if model.submit && (String.length model.password > 0 || String.length model.passwordAgain > 0) then
        if String.length model.password < 8 then
            div [ style "color" "red" ] [ text "Password: length must be more than 8!" ]
        else if String.all Char.isAlpha model.password then
            div [ style "color" "red" ] [ text "Password: should contain at least a number!" ]
        else if String.toUpper model.password == model.password then
            div [ style "color" "red" ] [ text "Password: should contain lower case!" ]
        else if String.toLower model.password == model.password then
            div [ style "color" "red" ] [ text "Password: should contain upper case!" ]
        else if model.password /= model.passwordAgain then
            div [ style "color" "red" ] [ text "Password: do not match!" ]
        else
            div [ style "color" "green" ] [ text "Password: OK" ]
    else
        div [] []

viewAge : Model -> Html msg
viewAge model =
    if model.submit && not (String.all Char.isDigit model.age) then
        div [ style "color" "red" ] [ text "Age: in digit!" ]
    else
        div [] []
