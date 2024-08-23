module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class, classList)


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type alias Model =
    {}


init _ =
    ( {}, Cmd.none )


type Msg
    = Noop


subscriptions model =
    Sub.none


update msg model =
    ( model, Cmd.none )


view model =
    { title = "Sole and Ankle"
    , body = []
    }
