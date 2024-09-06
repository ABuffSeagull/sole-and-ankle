module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes as Attr exposing (class, classList)
import Json.Decode as D
import Svg
import Svg.Attributes as SAttr


main : Program D.Value Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type alias Model =
    { shoes : List Shoe, now : Int }


init value =
    let
        decoder =
            D.map2 (\shoes now -> { shoes = shoes, now = now })
                (D.field "shoes" (D.list shoeDecoder))
                (D.field "now" D.int)

        result =
            D.decodeValue decoder value
    in
    case result of
        Ok { shoes, now } ->
            ( { shoes = shoes, now = now }, Cmd.none )

        Err _ ->
            ( { shoes = [], now = 0 }, Cmd.none )


type Msg
    = Noop


subscriptions model =
    Sub.none


update msg model =
    ( model, Cmd.none )


view model =
    { title = "Sole and Ankle"
    , body =
        [ viewSuperHeader
        , viewHeader
        , viewShell <|
            div [] []
        ]
    }


viewSuperHeader =
    div [ class "bg-gray-900 px-8 py-2 flex text-gray-300 gap-6" ]
        [ div [ class "mr-auto text-white" ] [ text "Free shipping on domestic orders over $75!" ]
        , label [ class "border-b border-gray-300 relative" ]
            [ icon Search [ SAttr.class "size-4 absolute my-auto inset-y-0 left-0" ]
            , input [ Attr.placeholder "Search...", class "pl-6 bg-transparent placeholder:text-gray-500" ] []
            ]
        , a [] [ text "Help" ]
        , icon ShoppingBag [ SAttr.class "size-6" ]
        ]


viewHeader =
    nav [ class "pl-8 flex items-end gap-12 font-medium py-5 border-b border-gray-300 text-lg" ]
        [ div [ class "flex-1" ] [ a [ Attr.href "/", class "font-bold text-2xl" ] [ text "Sole&Ankle" ] ]
        , a [ Attr.href "#", class "uppercase text-secondary" ] [ text "Sale" ]
        , a [ Attr.href "#", class "uppercase" ] [ text "New Releases" ]
        , a [ Attr.href "#", class "uppercase" ] [ text "Men" ]
        , a [ Attr.href "#", class "uppercase" ] [ text "Women" ]
        , a [ Attr.href "#", class "uppercase" ] [ text "Kids" ]
        , a [ Attr.href "#", class "uppercase" ] [ text "Collections" ]
        , div [ class "flex-1" ] []
        ]


viewShell children =
    main_ [ class "flex pt-16" ]
        [ div [ class "flex flex-col gap-4 px-8 basis-80 flex-none" ]
            [ div [ class "flex gap-2 mb-8" ] <|
                List.map (List.singleton >> span [])
                    [ text "Home", text "/", text "Sale", text "/", text "Shoes" ]
            , a [ Attr.href "#", class "font-medium" ] [ text "Lifestyle" ]
            , a [ Attr.href "#", class "font-medium" ] [ text "Jordan" ]
            , a [ Attr.href "#", class "font-medium text-primary" ] [ text "Running" ]
            , a [ Attr.href "#", class "font-medium" ] [ text "Basketball" ]
            , a [ Attr.href "#", class "font-medium" ] [ text "Training & Gym" ]
            , a [ Attr.href "#", class "font-medium" ] [ text "Football" ]
            , a [ Attr.href "#", class "font-medium" ] [ text "Skateboarding" ]
            , a [ Attr.href "#", class "font-medium" ] [ text "American Football" ]
            , a [ Attr.href "#", class "font-medium" ] [ text "Baseball" ]
            , a [ Attr.href "#", class "font-medium" ] [ text "Golf" ]
            , a [ Attr.href "#", class "font-medium" ] [ text "Tennis" ]
            , a [ Attr.href "#", class "font-medium" ] [ text "Athletics" ]
            , a [ Attr.href "#", class "font-medium" ] [ text "Walking" ]
            ]
        , div [ class "grow pr-8" ]
            [ div [ class "flex items-center gap-5" ]
                [ h2 [ class "font-medium text-2xl mr-auto" ] [ text "Running" ]
                , span [ class "text-gray-700" ] [ text "Sort" ]
                , div [ class "bg-gray-100 rounded-lg px-4 py-3 font-medium" ]
                    [ text "Newest Releases"
                    , icon ChevronDown [ SAttr.class "inline-block ml-3 size-4" ]
                    ]
                ]
            , children
            ]
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


type alias Shoe =
    { slug : String
    , name : String
    , imageSrc : String
    , price : Int
    , salePrice : Maybe Int
    , releaseDate : Int
    , numOfColors : Int
    }


shoeDecoder : D.Decoder Shoe
shoeDecoder =
    D.map7 Shoe
        (D.field "slug" D.string)
        (D.field "name" D.string)
        (D.field "imageSrc" D.string)
        (D.field "price" D.int)
        (D.field "salePrice" (D.maybe D.int))
        (D.field "releaseDate" D.int)
        (D.field "numOfColors" D.int)
