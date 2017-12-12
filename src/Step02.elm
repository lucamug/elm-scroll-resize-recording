port module Step02 exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Dom
import Dom.Scroll
import Task


port scrollOrResize : (ScreenData -> msg) -> Sub msg


type alias ScreenData =
    { scrollTop : Float
    , pageHeight : Float
    , viewportHeight : Float
    , viewportWidth : Float
    }


type alias Model =
    { screenData : Maybe ScreenData
    }


model : Model
model =
    { screenData = Nothing
    }


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )


type Msg
    = ScrollTo Float
    | OnScroll ScreenData
    | None


parseResult : a -> Msg
parseResult result =
    let
        _ =
            Debug.log "parseResult" result
    in
        None


scrollTo : Float -> Task.Task Dom.Error ()
scrollTo position =
    -- Dom.Scroll.toY : Id -> Float -> Task Error ()
    Dom.Scroll.toY "container546" position


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
            -- ( model, Cmd.none )
            ( model, attemptToScrollTo position )

        None ->
            ( model, Cmd.none )

        OnScroll data ->
            ( { model | screenData = Just data }, attemptToScrollTo data.scrollTop )


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
        [ scrollOrResize OnScroll
        ]


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
