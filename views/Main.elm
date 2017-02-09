module Main exposing (..)

import Dict exposing (Dict)
import Html exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as JD
import Json.Decode.Pipeline as JDP
import Material
import Material.Button as Button
import Material.Chip as Chip
import Material.Icon as Icon
import Material.Layout as Layout
import Material.Options as Options
import Material.Table as Table
import Material.Textfield as Textfield
import Material.Typography as Typo


-- Model

type alias User =
    {
        id : Int
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
    { users : List User
    , error : Maybe String
    , mdl : Material.Model
    }




-- Commands

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

-- Init

initModel : Model
initModel =
    { users = []
    , error = Nothing
    , mdl = Material.model
    }



-- Update


type Msg
    = ClearError
    | GetUserResponse (Result Http.Error Users)
    | Search
    | Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClearError ->
            ( { model | error = Nothing }, Cmd.none )

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
            ( model, getUsers model )

        Mdl msg_ ->
            Material.update Mdl msg_ model



-- View


boxed : List (Options.Property a b)
boxed =
    [ Options.css "margin" "auto"
    , Options.css "padding-bottom" "1%"
    , Options.css "padding-left" "4%"
    , Options.css "padding-right" "4%"
    , Options.css "padding-top" "1%"
    ]


alignLeft : Options.Property c m
alignLeft =
    Options.css "text-align" "left"


alignRight : Options.Property c m
alignRight =
    Options.css "text-align" "right"


alignCenter : Options.Property c m
alignCenter =
    Options.css "text-align" "center"


iconTaskActive : Html Msg
iconTaskActive =
    Icon.view "timer" [ (Options.css "vertical-align" "text-bottom"), Icon.size18 ]


iconTaskInactive : Html Msg
iconTaskInactive =
    Icon.view "timer_off" [ (Options.css "vertical-align" "text-bottom"), Icon.size18 ]


view : Model -> Html Msg
view model =
    Layout.render Mdl
        model.mdl
        [ Layout.fixedHeader ]
        { header =
            [ Layout.row []
                [ Layout.title [] [ text "Hack-Plan 2017" ]
                , Layout.spacer
                , Layout.navigation []
                    [ Layout.link
                        [ Layout.href "/api" ]
                        [ span [] [ text "api" ] ]
                    ]
                ]
            ]
        , drawer = []
        , tabs = ( [], [] )
        , main = [ page model ]
        }


page : Model -> Html Msg
page model =
    Options.div boxed
        [ viewErrorPanel model.error
        , viewSearchPanel model
        , viewTasks model.users
        ]


viewErrorPanel : Maybe String -> Html Msg
viewErrorPanel error =
    case error of
        Nothing ->
            text ""

        Just msg ->
            Chip.span
                [ Chip.deleteIcon "cancel", Chip.deleteClick ClearError ]
                [ Chip.content [] [ text msg ] ]


viewSearchPanel : Model -> Html Msg
viewSearchPanel model =
    Html.form [ onSubmit Search ]
        [ Textfield.render Mdl
            [ 0 ]
            model.mdl
            [ Textfield.label "Search for Users..."
            , Textfield.disabled
            ]
            []
        , Button.render Mdl
            [ 1 ]
            model.mdl
            [ Options.onClick Search
            ]
            [ text "Search" ]
        ]


viewTasksHeader : Html Msg
viewTasksHeader =
    Table.thead []
        [ Table.tr []
            [ Table.th [ alignLeft ] [ text "Id" ]
            , Table.th [ alignLeft ] [ text "Name" ]
            , Table.th [ alignLeft ] [ text "Email" ]
            ]
        ]


viewTasks : List User -> Html Msg
viewTasks users =
    users
        |> List.map viewTask
        |> Table.tbody []
        |> (\rows -> viewTasksHeader :: [ rows ])
        |> Table.table []


viewTask : User -> Html Msg
viewTask user =
        Table.tr []
            [ Table.td [ alignLeft ] [ text (toString user.id)  ]
            , Table.td [ alignLeft ] [ text (user.fristname ++ " " ++ user.surename) ]
            , Table.td [ alignLeft ] [ text user.email ]
            ]


-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- Main


main : Program Never Model Msg
main =
    Html.program
        { init = ( initModel, getUsers initModel )
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
