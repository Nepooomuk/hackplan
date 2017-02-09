module HackBoard exposing (..)

import Date
import Date.Extra.Format as DateFormat
import Date.Extra.Config.Config_en_us as DateConfig
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Json.Decode as JD
import Json.Decode.Pipeline as JDP
import Json.Encode as JE
import String
import Time
import Http
import WebSocket as WS


-- model


type alias Hackathon =
    { id : Int
    , name : String
    , organisator : String
    }


type alias Hackathons =
    { hackathons : List Hackathon
    }

type alias Model =
    { error : Maybe String
    , query : String
    , hackathons: List Hackathon
    , searchTerm : Maybe String
    , active : Bool
    }





initModel : Model
initModel =
    { error = Nothing
    , query = ""
    , searchTerm = Nothing
    , hackathons = []
    , active = False
    }



init : ( Model, Cmd Msg )
init =
    ( initModel, getHackathons initModel )


encodeWsMsg : String -> JE.Value -> String
encodeWsMsg name data =
    JE.encode 0
        (JE.object
            [ ( "name", JE.string name )
            , ( "data", data )
            ]
        )

hackDecoder : JD.Decoder Hackathon
hackDecoder =
    JDP.decode Hackathon
        |> JDP.required "id" JD.int
        |> JDP.required "name" JD.string
        |> JDP.required "organisator" JD.string


hackathonsDecoder : JD.Decoder Hackathons
hackathonsDecoder =
    JDP.decode Hackathons
        |> JDP.required "hackathons" (JD.list hackDecoder)


getHackathons : Model -> Cmd Msg
getHackathons model =
    let
        url =
            "/api/hackathon"
    in
        Http.send GetHackathonResponse (Http.get url hackathonsDecoder)


-- update


type Msg
    = SearchInput String
    | Search
    | GetHackathonResponse (Result Http.Error Hackathons)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchInput query ->
            ( { model | query = query }, Cmd.none )

        GetHackathonResponse (Ok hackathons) ->
            ( { model | hackathons = hackathons.hackathons
              }
            , Cmd.none
            )

        Search ->
            let
                searchTerm =
                    if String.isEmpty model.query then
                        Nothing
                    else
                        Just model.query
            in
                ( { model | searchTerm = searchTerm }, getHackathons model )


        _ ->
            (model, Cmd.none)





-- view


formatDistance : Float -> String
formatDistance distance =
    if distance <= 0 then
        ""
    else
        toString ((toFloat (round (distance * 100))) / 100)


formatTime : Time.Time -> String
formatTime time =
    if time > 0 then
        time
            |> Date.fromTime
            |> DateFormat.format DateConfig.config "%H:%M:%S %P"
    else
        ""


view : Model -> Html Msg
view model =
    div [ class "main" ]
        [ errorPanel model.error
        , searchForm model.query
        , hackathons model
        ]


errorPanel : Maybe String -> Html a
errorPanel error =
    case error of
        Nothing ->
            text ""

        Just msg ->
            div [ class "error" ]
                [ text msg
                , button [ type_ "button" ] [ text "×" ]
                ]


searchForm : String -> Html Msg
searchForm query =
    Html.form [ onSubmit Search ]
        [ input
            [ type_ "text"
            , placeholder "Search for ..."
            , value query
            , onInput SearchInput
            ]
            []
        , button [ type_ "submit" ] [ text "Search" ]
        ]


hackathons : Model -> Html Msg
hackathons { hackathons } =
    hackathons
        |> List.map hackathon
        |> tbody []
        |> (\r -> hackathonsHeader :: [ r ])
        |> table []


hackathon : Hackathon -> Html Msg
hackathon hackathon =
    tr []
        [ td [] [ text (toString hackathon.id) ]
        , td [] [ text hackathon.name ]
        , td [] [ text hackathon.organisator ]
        ]


hackathonsHeader : Html Msg
hackathonsHeader =
    thead []
        [ tr []
            [ th [] [ text "id" ]
            , th [] [ text "name" ]
            , th [] [ text "organisator" ]
            ]
        ]

-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model = Sub.none
