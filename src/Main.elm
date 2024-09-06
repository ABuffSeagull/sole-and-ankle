module Main exposing (main)

import Browser exposing (Document)
import Html exposing (..)
import Html.Attributes as Attr exposing (class, classList)
import Json.Decode as D
import Svg
import Svg.Attributes as SAttr
import Time


main : Program D.Value Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type alias Model =
    { shoes : List Shoe
    , now : Time.Posix
    , currentZone : Time.Zone
    }


init : D.Value -> ( Model, Cmd Msg )
init value =
    let
        decoder =
            D.map3 (\shoes now currentZone -> { shoes = shoes, now = now, currentZone = currentZone })
                (D.field "shoes" (D.list shoeDecoder))
                (D.map Time.millisToPosix (D.at [ "now", "epochMilliseconds" ] D.int))
                (D.map (\offset -> Time.customZone offset []) (D.field "currentOffset" D.int))

        result =
            D.decodeValue decoder value
    in
    case result of
        Ok model ->
            ( model, Cmd.none )

        Err _ ->
            ( { shoes = [], now = Time.millisToPosix 0, currentZone = Time.utc }, Cmd.none )


type Msg
    = Noop


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Document Msg
view model =
    { title = "Sole and Ankle"
    , body =
        [ viewSuperHeader
        , viewHeader
        , viewShell <|
            viewShoes model
        ]
    }


viewSuperHeader : Html Msg
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


viewHeader : Html Msg
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


viewShell : Html Msg -> Html Msg
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


viewShoes : Model -> Html Msg
viewShoes model =
    div [ class "flex flex-wrap gap-8 mt-8" ] <|
        List.map (viewShoe model.currentZone model.now) model.shoes


viewShoe : Time.Zone -> Time.Posix -> Shoe -> Html Msg
viewShoe zone now shoe =
    let
        flag =
            let
                isNew =
                    Time.toMonth zone shoe.releaseDate == Time.toMonth zone now
            in
            case ( shoe.salePrice, isNew ) of
                ( Just _, _ ) ->
                    div [ class "absolute bg-primary text-white text-sm p-2 rounded -right-1 top-4 font-medium" ] [ text "Sale" ]

                ( Nothing, True ) ->
                    div [ class "absolute bg-secondary text-white text-sm p-2 rounded -right-1 top-4 font-medium" ] [ text "Just Released!" ]

                ( Nothing, False ) ->
                    div [] []
    in
    div [ class "flex-auto basis-[300px] max-w-[600px] relative" ]
        [ flag
        , img [ class "w-full rounded-lg", Attr.src shoe.imageSrc, Attr.width 340, Attr.height 312 ] []
        , div [ class "flex justify-between mt-3" ]
            [ div []
                [ div [ class "font-medium" ] [ text shoe.name ]
                , div [ class "text-gray-700" ]
                    [ text (String.fromInt shoe.numOfColors)
                    , text <|
                        if shoe.numOfColors == 1 then
                            " Color"

                        else
                            " Colors"
                    ]
                ]
            , div []
                [ div [ classList [ ( "line-through text-gray-700", shoe.salePrice /= Nothing ) ] ] [ text ("$" ++ String.fromInt (shoe.price // 100)) ]
                , div [ class "text-primary font-medium" ]
                    [ let
                        salePrice =
                            case shoe.salePrice of
                                Just price ->
                                    "$" ++ String.fromInt (price // 100)

                                Nothing ->
                                    ""
                      in
                      text salePrice
                    ]
                ]
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
    , releaseDate : Time.Posix
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
        (D.map Time.millisToPosix (D.field "releaseDate" D.int))
        (D.field "numOfColors" D.int)
