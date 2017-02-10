module HackProject exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Http
import Json.Decode.Pipeline as JDP
import Json.Decode as JD
import Json.Encode as JE
import String



type alias Project =
    { id : Int
    , name : String
    , description : String
    }

type alias Projects =
    { projects : List Project
    }


type Status
    = Saving String
    | Saved String
    | NotSaved

projectDecoder : JD.Decoder Project
projectDecoder =
    JDP.decode Project
        |> JDP.required "id" JD.int
        |> JDP.required "name" JD.string
        |> JDP.required "description" JD.string


projectsDecoder : JD.Decoder Projects
projectsDecoder =
    JDP.decode Projects
        |> JDP.required "projects" (JD.list projectDecoder)

getProjects : Model -> Cmd Msg
getProjects model =
    let
        url =
            "/api/hackathon"
    in
        Http.send GetProjectsResponse (Http.get url projectsDecoder)


type alias Model =
    { error : Maybe String
    , projects : List Project
    }


initModel : Model
initModel =
    { error = Nothing
    , projects = []
    }


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.none )



-- update


type Msg
    =
    GetProjectsResponse (Result Http.Error Projects)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        _ ->
            (model, Cmd.none)




-- view


view : Model -> Html Msg
view model =
    div [ class "main" ]
        [ errorPanel model.error
        , viewForm model
        ]


errorPanel : Maybe String -> Html a
errorPanel error =
    case error of
        Nothing ->
            text ""

        Just msg ->
            div [ class "error" ]
                [ text msg
                ]


viewForm : Model -> Html Msg
viewForm model =
    div [] []



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
