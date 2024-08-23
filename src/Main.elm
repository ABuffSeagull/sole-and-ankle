module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes as Attr exposing (class, classList)
import Svg
import Svg.Attributes as SAttr


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
    , body =
        [ superHeader
        , header
        ]
    }


superHeader =
    div [ class "bg-gray-900 px-8 py-2 flex text-gray-300 gap-6" ]
        [ div [ class "mr-auto text-white" ] [ text "Free shipping on domestic orders over $75!" ]
        , label [ class "border-b border-gray-300 relative" ]
            [ icon Search [ SAttr.class "size-4 absolute my-auto inset-y-0 left-0" ]
            , input [ Attr.placeholder "Search...", class "pl-6 bg-transparent placeholder:text-gray-500" ] []
            ]
        , a [] [ text "Help" ]
        , icon ShoppingBag [ SAttr.class "size-6" ]
        ]


header =
    nav [ class "flex justify-center relative items-end gap-12 font-medium py-5 border-b border-gray-300 text-lg" ]
        [ a [ Attr.href "/", class "font-bold text-2xl absolute left-8" ] [ text "Sole&Ankle" ]
        , a [ Attr.href "#", class "uppercase text-secondary" ] [ text "Sale" ]
        , a [ Attr.href "#", class "uppercase" ] [ text "New Releases" ]
        , a [ Attr.href "#", class "uppercase" ] [ text "Men" ]
        , a [ Attr.href "#", class "uppercase" ] [ text "Women" ]
        , a [ Attr.href "#", class "uppercase" ] [ text "Kids" ]
        , a [ Attr.href "#", class "uppercase" ] [ text "Collections" ]
        ]


type Icon
    = Search
    | ShoppingBag
    | ChevronDown
    | Menu
    | X


icon id attr =
    let
        strId =
            case id of
                Search ->
                    "search"

                ShoppingBag ->
                    "shopping-bag"

                ChevronDown ->
                    "chevron-down"

                Menu ->
                    "menu"

                X ->
                    "x"
    in
    Svg.svg attr [ Svg.use [ SAttr.xlinkHref ("/icons.svg#" ++ strId) ] [] ]
