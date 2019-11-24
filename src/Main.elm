module Main exposing (main)

import Array
import Browser exposing (Document)
import Browser.Dom exposing (Viewport)
import Browser.Events
import Element exposing (Color, Device, DeviceClass(..), Element, Orientation(..))
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import List.Extra as List
import Resources exposing (Detail, Tag)
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
    { device : Device
    , filter : Maybe Tag
    }


type Msg
    = Resize Int Int
    | InitialSize Viewport
    | SetFilter Tag
    | ResetFilter


init : () -> ( Model, Cmd Msg )
init _ =
    ( { device = { class = Desktop, orientation = Landscape }
      , filter = Nothing
      }
    , Browser.Dom.getViewport
        |> Task.perform InitialSize
    )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Browser.Events.onResize Resize


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Resize w h ->
            ( { model | device = Element.classifyDevice { height = h, width = w } }, Cmd.none )

        InitialSize { viewport } ->
            ( { model | device = Element.classifyDevice { height = floor viewport.height, width = floor viewport.width } }, Cmd.none )

        SetFilter tag ->
            ( { model | filter = Just tag }, Cmd.none )

        ResetFilter ->
            ( { model | filter = Nothing }, Cmd.none )


view : Model -> Document Msg
view { device, filter } =
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
                , Element.row
                    [ Element.centerX
                    , Element.spacing 16
                    ]
                    ([ Element.el [ Font.color (Element.rgb 1 1 1) ] (Element.text "Filter:")
                     , viewFilterReset (filter == Nothing)
                     ]
                        ++ List.map (viewFilter filter) Resources.allTags
                    )
                , Element.el [ Element.height (Element.px 16) ] Element.none
                , viewResources
                    "Resources"
                    (case device.class of
                        Phone ->
                            ( 1, True )

                        Tablet ->
                            ( 1, True )

                        _ ->
                            ( 3, False )
                    )
                    (case filter of
                        Nothing ->
                            Resources.resources

                        Just tag ->
                            List.filter (\{ tags } -> List.member tag tags) Resources.resources
                    )
                , outroElement
                ]
        ]
    }


viewFilterReset : Bool -> Element Msg
viewFilterReset active =
    viewFilterButton "All" ResetFilter active


viewFilter : Maybe Tag -> Tag -> Element Msg
viewFilter filter tag =
    viewFilterButton
        (Resources.tagToString tag)
        (SetFilter tag)
        (case filter of
            Just t -> t == tag
            Nothing -> False
        )


viewFilterButton : String -> Msg -> Bool -> Element Msg
viewFilterButton label msg active =
    Input.button
        [ Border.solid
        , Border.width 1
        , Element.paddingXY 16 8
        , Background.color <| if active then elmGreen else Element.rgb 1 1 1
        , Border.rounded 3
        ]
        { onPress = Just msg
        , label = Element.text label
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


viewResources : String -> ( Int, Bool ) -> List Detail -> Element Msg
viewResources title ( columns, stretch ) items =
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
viewItem stretch { what, url, why, tags } =
    Element.el
        [ Border.solid
        , Border.width 2
        , Border.rounded 3
        , Element.width <|
            if stretch then
                Element.fill

            else
                Element.fill |> Element.maximum 256
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
                    [ Element.height Element.fill ]
                    [ Element.el [ Font.underline ] (Element.text what)
                    , Element.el [ Element.height (Element.px 16) ] Element.none
                    , Element.paragraph
                        [ Element.height Element.fill ]
                        [ Element.text why ]
                    , Element.row
                        [ Element.alignRight ]
                        (List.map viewTag tags)
                    ]
            }
        )


viewTag : Tag -> Element msg
viewTag tag =
    Element.el
        [ Background.color elmGreen
        , Element.paddingXY 8 4
        , Border.rounded 3
        , Border.solid
        , Border.width 1
        ]
        (Element.text (Resources.tagToString tag))


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



---- COLORS ----


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
