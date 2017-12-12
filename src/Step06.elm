port module Step06 exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Dom.Scroll
import Task


port scrollOrResize : (String -> msg) -> Sub msg


type alias Model =
    { position : Float
    }


model : Model
model =
    { position = 0
    }


type Msg
    = ScrollTo Float
    | OnScroll String
    | None


containerId1 : String
containerId1 =
    "container546"


containerId2 : String
containerId2 =
    "container942"


attemptToGetScrollTop : Cmd Msg
attemptToGetScrollTop =
    Task.attempt getScrollTopResult (Dom.Scroll.y containerId1)


getScrollTopResult : Result error Float -> Msg
getScrollTopResult result =
    case result of
        Ok position ->
            ScrollTo position

        Err error ->
            None


attemptToSetScrollTop2 : Float -> Cmd Msg
attemptToSetScrollTop2 position =
    let
        _ =
            Debug.log "attemptToSetScrollTop2" position
    in
        Task.attempt setScrollTopResult (Dom.Scroll.toY containerId2 position)


attemptToSetScrollTop1 : Float -> Cmd Msg
attemptToSetScrollTop1 position =
    let
        _ =
            Debug.log "attemptToSetScrollTop1" position
    in
        Task.attempt setScrollTopResult (Dom.Scroll.toY containerId1 position)


setScrollTopResult : a -> Msg
setScrollTopResult result =
    let
        _ =
            Debug.log "setScrollTopResult" result
    in
        None


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ScrollTo position ->
            if (abs (position - model.position)) < 20 then
                ( model, Cmd.none )
            else
                ( { model | position = position }
                , Cmd.batch
                    [ (attemptToSetScrollTop2 position)
                    ]
                )

        None ->
            ( model, Cmd.none )

        OnScroll text ->
            ( model, attemptToGetScrollTop )


content : String -> String -> Html msg
content containerId color =
    div
        [ id containerId
        , style
            [ ( "margin", "2em" )
            , ( "height", "200px" )
            , ( "overflow-y", "scroll" )
            , ( "background-color", color )
            ]
        ]
        [ div [ style [ ( "margin", "2em" ) ] ]
            [ h1 [] [ text "Simple Test" ]
            , div []
                (List.repeat 15
                    (div []
                        [ h2 [] [ text "Paragraph" ]
                        , p [] [ text """
    Nel mezzo del cammin di nostra vita
    mi ritrovai per una selva oscura,
    ché la diritta via era smarrita.
    Ahi quanto a dir qual era è cosa dura
    esta selva selvaggia e aspra e forte
    che nel pensier rinova la paura!
    Tant' è amara che poco è più morte;
    ma per trattar del ben ch'i' vi trovai,
    dirò de l'altre cose ch'i' v'ho scorte.
    Io non so ben ridir com' i' v'intrai,
    tant' era pien di sonno a quel punto
    che la verace via abbandonai.
    Ma poi ch'i' fui al piè d'un colle giunto,
    là dove terminava quella valle
    che m'avea di paura il cor compunto,
    guardai in alto e vidi le sue spalle
    vestite già de' raggi del pianeta
    che mena dritto altrui per ogne calle.
    Allor fu la paura un poco queta,
    che nel lago del cor m'era durata
    la notte ch'i' passai con tanta pieta.""" ]
                        ]
                    )
                )
            ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick (ScrollTo 100) ] [ text "Click here to go down 100px" ]
        , button [ onClick (ScrollTo 0) ] [ text "Click here to go to the top" ]
        , div
            [ style
                [ ( "position", "fixed" )
                , ( "top", "0" )
                , ( "right", "0" )
                , ( "padding", "5px" )
                , ( "background-color", "#eee" )
                ]
            ]
            [ text (toString model.position) ]
        , content containerId1 "#ffccff"
        , content containerId2 "#ccccff"
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ scrollOrResize OnScroll
        ]


main : Program Never Model Msg
main =
    program
        { init = ( model, Cmd.none )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
