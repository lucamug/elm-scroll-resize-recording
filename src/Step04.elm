module Step04 exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Dom
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


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )


type Msg
    = ScrollTo Float
    | Tick Time.Time
    | None


parseResult : a -> Msg
parseResult result =
    let
        _ =
            Debug.log "parseResult" result
    in
        None


getScrollPositionResult : Result error Float -> Msg
getScrollPositionResult result =
    case result of
        Ok position ->
            ScrollTo position

        Err error ->
            None


scrollTo : Float -> Task.Task Dom.Error ()
scrollTo position =
    -- Dom.Scroll.toY : Id -> Float -> Task Error ()
    Dom.Scroll.toY "container546" position


getScrollPosition : Task.Task Dom.Error Float
getScrollPosition =
    -- Dom.Scroll.toY : Id -> Float -> Task Error ()
    Dom.Scroll.y "container546"


attemptToGetScrollPosition : Cmd Msg
attemptToGetScrollPosition =
    -- Task.attempt : (Result x a -> msg) -> Task x a -> Cmd msg
    Task.attempt getScrollPositionResult getScrollPosition


attemptToScrollTo : Float -> Cmd Msg
attemptToScrollTo position =
    let
        _ =
            Debug.log "attemptToScrollTo" position
    in
        -- Task.attempt : (Result x a -> msg) -> Task x a -> Cmd msg
        Task.attempt parseResult (scrollTo position)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ScrollTo position ->
            if position == model.position then
                ( model, Cmd.none )
            else
                ( { model | position = position }, attemptToScrollTo position )

        None ->
            ( model, Cmd.none )

        Tick time ->
            ( model, attemptToGetScrollPosition )


view : Model -> Html Msg
view model =
    div []
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
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
