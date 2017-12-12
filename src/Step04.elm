module Step04 exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Dom.Scroll
import Task
import Time


type alias Model =
    { position : Float
    }


model : Model
model =
    { position = 0
    }


type Msg
    = ScrollTo Float
    | Tick Time.Time
    | None


containerId : String
containerId =
    "container546"


attemptToGetScrollTop : Cmd Msg
attemptToGetScrollTop =
    Task.attempt getScrollTopResult (Dom.Scroll.y containerId)


getScrollTopResult : Result error Float -> Msg
getScrollTopResult result =
    case result of
        Ok position ->
            ScrollTo position

        Err error ->
            None


attemptToSetScrollTop : Float -> Cmd Msg
attemptToSetScrollTop position =
    let
        _ =
            Debug.log "attemptToSetScrollTop" position
    in
        Task.attempt setScrollTopResult (Dom.Scroll.toY containerId position)


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
            if position == model.position then
                ( model, Cmd.none )
            else
                ( { model | position = position }, attemptToSetScrollTop position )

        None ->
            ( model, Cmd.none )

        Tick time ->
            ( model, attemptToGetScrollTop )


view : Model -> Html Msg
view model =
    div
        [ id "container546"
        , style
            [ ( "margin", "2em" )
            , ( "height", "200px" )
            , ( "overflow-y", "scroll" )
            , ( "background-color", "#ffccff" )
            ]
        ]
        [ div [ style [ ( "margin", "2em" ) ] ]
            [ h1 [] [ text "Simple Test" ]
            , button [ onClick (ScrollTo 100) ] [ text "Click here to go down 100px" ]
            , div [] (List.repeat 15 (p [] [ text """
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
            la notte ch'i' passai con tanta pieta.""" ]))
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
            ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Time.every Time.second Tick
        ]


main : Program Never Model Msg
main =
    program
        { init = ( model, Cmd.none )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
