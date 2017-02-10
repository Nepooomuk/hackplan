port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Navigation
import HackBoard
import Login
import HackProject


-- model


type Page
    = NotFound
    | HackBoardPage
    | LoginPage
    | ProjectPage


securePages : List Page
securePages =
    []



--- [ ProjectPage ]


loginTarget : Page -> String -> String
loginTarget page target =
    case page of
        LoginPage ->
            target

        _ ->
            pageToHash page


pageOrLoginPage : Page -> String -> Bool -> ( Page, String, Cmd Msg )
pageOrLoginPage page target loggedIn =
    if loggedIn || not (List.member page securePages) then
        ( page
        , loginTarget page target
        , Cmd.none
        )
    else
        ( LoginPage
        , loginTarget page target
        , pageToCmd LoginPage
        )


type alias Model =
    { page : Page
    , target : String
    , leaderBoard : HackBoard.Model
    , login : Login.Model
    , runner : HackProject.Model
    , token : Maybe String
    }


init : Flags -> Navigation.Location -> ( Model, Cmd Msg )
init flags location =
    let
        target =
            location.hash

        page =
            hashToPage target

        ( securePage, secureTarget, secureCmd ) =
            pageOrLoginPage page target (flags.token /= Nothing)

        ( lbInitModel, lbInitCmd ) =
            HackBoard.init

        ( loginInitModel, loginInitCmd ) =
            Login.init

        ( runnerInitModel, runnerInitCmd ) =
            HackProject.init

        initModel =
            { page = securePage
            , target = secureTarget
            , leaderBoard = lbInitModel
            , login = loginInitModel
            , runner = runnerInitModel
            , token = flags.token
            }

        initCmd =
            Cmd.batch
                [ Cmd.map HackBoardMsg lbInitCmd
                , Cmd.map LoginMsg loginInitCmd
                , Cmd.map ProjectMsg runnerInitCmd
                , secureCmd
                ]
    in
        ( initModel, initCmd )


loggedIn : Model -> Bool
loggedIn model =
    model.token /= Nothing



-- update


type Msg
    = Navigate Page
    | ChangePage Page
    | HackBoardMsg HackBoard.Msg
    | LoginMsg Login.Msg
    | ProjectMsg HackProject.Msg
    | Logout


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Navigate page ->
            ( model, pageToCmd page )

        ChangePage page ->
            let
                ( securePage, secureTarget, secureCmd ) =
                    pageOrLoginPage page model.target (loggedIn model)
            in
                ( { model | page = securePage, target = secureTarget }, secureCmd )

        HackBoardMsg msg ->
            let
                ( lbModel, lbCmd ) =
                    HackBoard.update msg model.leaderBoard
            in
                ( { model | leaderBoard = lbModel }
                , Cmd.map HackBoardMsg lbCmd
                )

        LoginMsg msg ->
            let
                ( loginModel, loginToken, loginCmd ) =
                    Login.update msg model.login model.target

                saveTokenCmd =
                    case loginToken of
                        Just jwt ->
                            saveToken jwt

                        Nothing ->
                            Cmd.none
            in
                ( { model
                    | login = loginModel
                    , token = loginToken
                  }
                , Cmd.batch
                    [ Cmd.map LoginMsg loginCmd
                    , saveTokenCmd
                    ]
                )

        ProjectMsg msg ->
            let
                token =
                    Maybe.withDefault "" model.token

                ( runnerModel, runnerCmd ) =
                    HackProject.update msg model.runner
            in
                ( { model | runner = runnerModel }
                , Cmd.map ProjectMsg runnerCmd
                )

        Logout ->
            ( { model | token = Nothing }
            , Cmd.batch
                [ deleteToken ()
                , pageToCmd HackBoardPage
                ]
            )



-- view


view : Model -> Html Msg
view model =
    let
        page =
            case model.page of
                HackBoardPage ->
                    model.leaderBoard |> HackBoard.view |> Html.map HackBoardMsg

                LoginPage ->
                    model.login |> Login.view |> Html.map LoginMsg

                ProjectPage ->
                    model.runner |> HackProject.view |> Html.map ProjectMsg

                NotFound ->
                    div [ class "main" ]
                        [ h1 []
                            [ text "Page Not Found" ]
                        ]
    in
        div []
            [ pageHeader model
            , page
            ]


pageHeader : Model -> Html Msg
pageHeader model =
    header [ style [("background-image","url(assets/header-background_img.jpg)")] ]
        [ a [ onClick (Navigate HackBoardPage) ] [ text "Hackplan 2017" ]
        , ul []
            [ li []
                [ addRunnerLinkView model ]
            ]
        , ul []
            [ li []
                [ loginLinkView model ]
            ]
        ]


addRunnerLinkView : Model -> Html Msg
addRunnerLinkView model =
    if loggedIn model then
        a [ onClick (Navigate ProjectPage) ] [ text "Add Project" ]
    else
        text ""


loginLinkView : Model -> Html Msg
loginLinkView model =
    if loggedIn model then
        a [ onClick Logout ] [ text "Logout" ]
    else
        a [ onClick (Navigate LoginPage) ] [ text "Login" ]



-- navigation


hashToPage : String -> Page
hashToPage hash =
    case hash of
        "" ->
            HackBoardPage

        "#/" ->
            HackBoardPage

        "#/login" ->
            LoginPage

        "#/projects" ->
            ProjectPage

        _ ->
            NotFound


pageToHash : Page -> String
pageToHash page =
    case page of
        HackBoardPage ->
            "#/"

        LoginPage ->
            "#/login"

        ProjectPage ->
            "#/projects"

        NotFound ->
            "#notfound"


pageToCmd : Page -> Cmd Msg
pageToCmd page =
    page |> pageToHash |> Navigation.modifyUrl


locationToMsg : Navigation.Location -> Msg
locationToMsg location =
    location.hash |> hashToPage |> ChangePage



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ model.leaderBoard |> HackBoard.subscriptions |> Sub.map HackBoardMsg
        , model.login |> Login.subscriptions |> Sub.map LoginMsg
        , model.runner |> HackProject.subscriptions |> Sub.map ProjectMsg
        ]



-- ports


port saveToken : String -> Cmd msg


port deleteToken : () -> Cmd msg



-- main


type alias Flags =
    { token : Maybe String }


main : Program Flags Model Msg
main =
    Navigation.programWithFlags locationToMsg
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
