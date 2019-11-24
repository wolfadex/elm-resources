module Main exposing (main)

import Array
import Browser exposing (Document)
import Browser.Dom exposing (Viewport)
import Browser.Events
import Element exposing (Color, Device, DeviceClass(..), Element, Orientation(..))
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import List.Extra as List
import Resources exposing (Detail)
import Svg
import Svg.Attributes
import Task


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }


type alias Model =
    Device


type Msg
    = Resize Int Int
    | InitialSize Viewport


init : () -> ( Model, Cmd Msg )
init _ =
    ( { class = Desktop, orientation = Landscape }
    , Browser.Dom.getViewport
        |> Task.perform InitialSize
    )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Browser.Events.onResize Resize


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        Resize w h ->
            ( Element.classifyDevice { height = h, width = w }, Cmd.none )

        InitialSize { viewport } ->
            ( Element.classifyDevice { height = floor viewport.height, width = floor viewport.width }, Cmd.none )


view : Model -> Document Msg
view { class } =
    { title = "Elm Resources"
    , body =
        [ Element.layout
            [ Element.width Element.fill
            , Element.height Element.fill
            , Background.color elmGray
            ]
          <|
            Element.column
                [ Element.width Element.fill
                , Element.padding 16
                , Element.scrollbarY
                ]
                [ titleElement
                , introElement
                , Element.el [ Element.height (Element.px 16) ] Element.none
                , viewGroup
                    "Resources"
                    (case class of
                        Phone ->
                            ( 1, True )

                        Tablet ->
                            ( 1, True )

                        _ ->
                            ( 3, False )
                    )
                    Resources.resources
                , outroElement
                ]
        ]
    }


titleElement : Element msg
titleElement =
    Element.row
        [ Border.widthEach
            { top = 0
            , bottom = 2
            , left = 0
            , right = 0
            }
        , Element.width Element.fill
        , Element.padding 8
        , Font.color (Element.rgb 1 1 1)
        , Font.size 32
        ]
        [ elmLogo
        , Element.el [ Element.width (Element.px 16) ] Element.none
        , Element.text "Elm Resources"
        ]


introElement : Element msg
introElement =
    Element.paragraph
        [ Border.widthEach
            { top = 0
            , bottom = 2
            , left = 0
            , right = 0
            }
        , Element.width Element.fill
        , Element.padding 16
        , Font.size 16
        , Font.color (Element.rgb 1 1 1)
        , Font.center
        ]
        [ Element.text "A collection of resources for learning and using Elm. There are books, courses, tutorials, and tools that other developers have found useful." ]


outroElement : Element msg
outroElement =
    Element.paragraph
        [ Border.widthEach
            { top = 2
            , bottom = 0
            , left = 0
            , right = 0
            }
        , Element.width Element.fill
        , Element.padding 8
        , Font.color (Element.rgb 1 1 1)
        , Font.size 16
        , Font.center
        ]
        [ Element.text "If you think something is missing or would like to suggest a better tutorial, guide, or tool, please file an issue or make a pull request at "
        , Element.newTabLink
            [ Font.underline
            , Font.color elmBlue
            ]
            { url = "https://github.com/wolfadex/elm-resources"
            , label = Element.text "Elm Resources on GitHub"
            }
        ]


viewGroup : String -> ( Int, Bool ) -> List Detail -> Element Msg
viewGroup title ( columns, stretch ) items =
    Element.column
        [ Element.width <|
            if stretch then
                Element.fill

            else
                Element.fill |> Element.maximum (256 * columns)
        , Element.centerX
        ]
        [ Element.el
            [ Element.width Element.fill
            , Background.color elmBlue
            , Element.padding 8
            ]
            (Element.text title)
        , Element.row
            [ Element.width Element.fill ]
            (List.map
                (\column ->
                    Element.column
                        [ Element.width Element.fill
                        , Element.alignTop
                        , Element.spacing 16
                        , Element.padding 16
                        ]
                        (List.map (viewItem stretch) column)
                )
                (groupEvery columns items)
            )
        ]


viewItem : Bool -> Detail -> Element Msg
viewItem stretch { what, url, why } =
    Element.el
        [ Border.solid
        , Border.width 2
        , Border.rounded 3
        , Element.width <|
            if stretch then Element.fill else Element.fill |> Element.maximum 256
        , Element.height (Element.px 256)
        , Element.mouseOver
            [ Border.shadow
                { blur = 10
                , color = elmOrange
                , offset = ( 0, 2 )
                , size = 1
                }
            , Border.color elmOrange
            ]
        , Element.focused
            [ Border.shadow
                { blur = 10
                , color = elmOrange
                , offset = ( 0, 2 )
                , size = 1
                }
            , Border.color elmOrange
            ]
        , Background.color (Element.rgb 1 1 1)
        ]
        (Element.newTabLink
            [ Element.padding 16
            , Element.width Element.fill
            , Element.height Element.fill
            ]
            { url = url
            , label =
                Element.column
                    [ Element.alignTop ]
                    [ Element.el [ Font.underline ] (Element.text what)
                    , Element.el [ Element.height (Element.px 16) ] Element.none
                    , Element.paragraph
                        []
                        [ Element.text why ]
                    ]
            }
        )


groupEvery : Int -> List a -> List (List a)
groupEvery every list =
    List.indexedFoldl
        (\i a acc ->
            let
                index =
                    modBy every i
            in
            case Array.get index acc of
                Nothing ->
                    Array.push (Array.fromList [ a ]) acc

                Just column ->
                    Array.set index (Array.push a column) acc
        )
        Array.empty
        list
        |> Array.map Array.toList
        |> Array.toList


elmGray : Color
elmGray =
    Element.rgb255 90 99 120


elmBlue : Color
elmBlue =
    Element.rgb255 96 181 204


elmGreen : Color
elmGreen =
    Element.rgb255 127 209 59


elmOrange : Color
elmOrange =
    Element.rgb255 240 173 0


elmLogo : Element msg
elmLogo =
    Element.el [ Border.solid, Border.width 1 ] <|
        Element.html <|
            Svg.svg
                [ Svg.Attributes.height "30", Svg.Attributes.viewBox "0 0 600 600" ]
                [ Svg.polygon [ Svg.Attributes.fill "#5A6378", Svg.Attributes.points "0,20 280,300 0,580" ] []
                , Svg.polygon [ Svg.Attributes.fill "#60B5CC", Svg.Attributes.points "20,600 300,320 580,600" ] []
                , Svg.polygon [ Svg.Attributes.fill "#60B5CC", Svg.Attributes.points "320,0 600,0 600,280" ] []
                , Svg.polygon [ Svg.Attributes.fill "#7FD13B", Svg.Attributes.points "20,0 280,0 402,122 142,122" ] []
                , Svg.polygon [ Svg.Attributes.fill "#F0AD00", Svg.Attributes.points "170,150 430,150 300,280" ] []
                , Svg.polygon [ Svg.Attributes.fill "#7FD13B", Svg.Attributes.points "320,300 450,170 580,300 450,430" ] []
                , Svg.polygon [ Svg.Attributes.fill "#F0AD00", Svg.Attributes.points "470,450 600,320 600,580" ] []
                ]
