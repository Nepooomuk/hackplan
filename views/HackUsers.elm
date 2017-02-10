module HackUsers exposing (..)

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


type alias User =
    { id : Int
    , surename : String
    , fristname : String
    , isadmin : Bool
    , email : String
    , password : String
    }


type alias Users =
    { users : List User
    }


type alias Model =
    { error : Maybe String
    , query : String
    , users: List User
    , searchTerm : Maybe String
    , active : Bool
    }

initModel : Model
initModel =
    { error = Nothing
    , query = ""
    , searchTerm = Nothing
    , users = []
    , active = False
    }


init : ( Model, Cmd Msg )
init =
    ( initModel, getUsers initModel )

userDecoder : JD.Decoder User
userDecoder =
    JDP.decode User
        |> JDP.required "id" JD.int
        |> JDP.required "surename" JD.string
        |> JDP.required "firstname" JD.string
        |> JDP.required "isadmin" JD.bool
        |> JDP.required "email" JD.string
        |> JDP.required "password" JD.string


usersDecoder : JD.Decoder Users
usersDecoder =
    JDP.decode Users
        |> JDP.required "users" (JD.list userDecoder)


getUsers : Model -> Cmd Msg
getUsers model =
    let
        url =
            "/api/user"
    in
        Http.send GetUserResponse (Http.get url usersDecoder)

-- update


type Msg
    = SearchInput String
    | Search
    | GetUserResponse (Result Http.Error Users)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchInput query ->
            ( { model | query = query }, Cmd.none )

        GetUserResponse (Ok users) ->
            ( { model
                | users = users.users
                , error = Nothing
              }
            , Cmd.none
            )

        GetUserResponse (Err err) ->
            ( { model | error = Just (toString err) }, Cmd.none )

        Search ->
            let
                searchTerm =
                    if String.isEmpty model.query then
                        Nothing
                    else
                        Just model.query
            in
                ( { model | searchTerm = searchTerm }, getUsers model )





-- view


view : Model -> Html Msg
view model =
    div [ class "main" ]
        [ errorPanel model.error
        , div [style [("text-align","center")]] [img [ src "assets/hackathon-graphic.png"] []]
        , searchForm model.query
        , users model
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


users : Model -> Html Msg
users { users } =
    users
        |> List.map user
        |> tbody []
        |> (\r -> hackathonsHeader :: [ r ])
        |> table []


user : User -> Html Msg
user user =
    tr []
        [ td [] [ text (toString user.id) ]
        , td [] [ text user.fristname ]
        , td [] [ text user.surename ]
        , td [] [ text user.email ]
        ]


hackathonsHeader : Html Msg
hackathonsHeader =
    thead []
        [ tr []
            [ th [] [ text "id" ]
            , th [] [ text "vorname" ]
            , th [] [ text "nachname" ]
            , th [] [ text "email" ]
            ]
        ]

-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model = Sub.none
