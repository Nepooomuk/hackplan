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


type alias Pagination =
    { currentPage : Int
    , pageCount : Int
    }


type alias Task =
    { id : Int
    , owner : String
    , rule : String
    , active : Bool
    , request : TaskRequest
    , labels : Dict String String
    }


type alias TaskRequest =
    { url : String
    , method : String
    }


type alias Tasks =
    { pagination : Pagination
    , tasks : List Task
    }


type alias Model =
    { tasks : List Task
    , tasksPerPage : Int
    , page : Int
    , pageCount : Int
    , error : Maybe String
    , mdl : Material.Model
    }


taskName : Task -> String
taskName task =
    Maybe.withDefault "---" (Dict.get "name" task.labels)



-- Commands


paginationDecoder : JD.Decoder Pagination
paginationDecoder =
    JDP.decode Pagination
        |> JDP.required "currentPage" JD.int
        |> JDP.required "pageCount" JD.int


taskDecoder : JD.Decoder Task
taskDecoder =
    JDP.decode Task
        |> JDP.required "id" JD.int
        |> JDP.required "owner" JD.string
        |> JDP.required "scheduling_rule" JD.string
        |> JDP.required "active" JD.bool
        |> JDP.required "request" taskRequestDecoder
        |> JDP.optional "labels" (JD.dict JD.string) Dict.empty


taskRequestDecoder : JD.Decoder TaskRequest
taskRequestDecoder =
    JDP.decode TaskRequest
        |> JDP.required "url" JD.string
        |> JDP.required "method" JD.string


tasksDecoder : JD.Decoder Tasks
tasksDecoder =
    JDP.decode Tasks
        |> JDP.required "pagination" paginationDecoder
        |> JDP.required "tasks" (JD.list taskDecoder)


getTasks : Model -> Cmd Msg
getTasks model =
    let
        url =
            "/tasks?page="
                ++ (toString model.page)
                ++ "&objectsPerPage="
                ++ (toString model.tasksPerPage)
    in
        Http.send GetTasksResponse (Http.get url tasksDecoder)



-- Init


initModel : Model
initModel =
    { tasks = []
    , tasksPerPage = 20
    , page = 1
    , pageCount = 1
    , error = Nothing
    , mdl = Material.model
    }



-- Update


type Msg
    = ClearError
    | GetTasksResponse (Result Http.Error Tasks)
    | InputTasksPerPage String
    | PageFirst
    | PageLast
    | PageNext
    | PagePrevious
    | Search
    | Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClearError ->
            ( { model | error = Nothing }, Cmd.none )

        GetTasksResponse (Ok tasks) ->
            ( { model
                | page = tasks.pagination.currentPage
                , pageCount = tasks.pagination.pageCount
                , tasks = tasks.tasks
                , error = Nothing
              }
            , Cmd.none
            )

        GetTasksResponse (Err err) ->
            ( { model | error = Just (toString err) }, Cmd.none )

        InputTasksPerPage value ->
            ( { model | tasksPerPage = Result.withDefault 0 (String.toInt value) }, Cmd.none )

        PageFirst ->
            ( model, getTasks { model | page = 1 } )

        PageLast ->
            ( model, getTasks { model | page = model.pageCount } )

        PageNext ->
            ( model, getTasks { model | page = model.page + 1 } )

        PagePrevious ->
            ( model, getTasks { model | page = model.page - 1 } )

        Search ->
            ( model, getTasks model )

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
                [ Layout.title [] [ text "Tokka Task Scheduler" ]
                , Layout.spacer
                , Layout.navigation []
                    [ Layout.link
                        [ Layout.href "/apidoc" ]
                        [ span [] [ text "apidoc" ] ]
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
        , viewPagingPanel model
        , viewTasks model.tasks
        , viewPagingPanel model
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
            [ Textfield.label "Search for Tasks..."
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
            [ Table.th [ alignLeft ] [ text "Name" ]
            , Table.th [ alignLeft ] [ text "Owner" ]
            , Table.th [ alignLeft ] [ text "Request" ]
            , Table.th [ alignLeft ] [ text "Scheduling" ]
            , Table.th [ alignCenter ]
                [ Options.span []
                    [ iconTaskActive
                    , text "/"
                    , iconTaskInactive
                    ]
                ]
            , Table.th [ alignCenter ] [ text "ID" ]
            ]
        ]


viewTasks : List Task -> Html Msg
viewTasks tasks =
    tasks
        |> List.sortBy taskName
        |> List.map viewTask
        |> Table.tbody []
        |> (\rows -> viewTasksHeader :: [ rows ])
        |> Table.table []


viewTask : Task -> Html Msg
viewTask task =
    let
        iconTask =
            if task.active then
                iconTaskActive
            else
                iconTaskInactive
    in
        Table.tr []
            [ Table.td [ alignLeft ] [ text (taskName task) ]
            , Table.td [ alignLeft ] [ text task.owner ]
            , Table.td [ alignLeft ] [ text (task.request.method ++ " " ++ task.request.url) ]
            , Table.td [ alignLeft ] [ text task.rule ]
            , Table.td [ alignCenter ] [ iconTask ]
            , Table.td [ alignCenter ] [ text (toString task.id) ]
            ]


viewPagingPanel : Model -> Html Msg
viewPagingPanel model =
    let
        props =
            [ Button.minifab ]

        propsPrevious =
            if model.page <= 1 then
                Button.disabled :: props
            else
                props

        propsNext =
            if model.page >= model.pageCount then
                Button.disabled :: props
            else
                props
    in
        div []
            [ Button.render Mdl
                [ 0 ]
                model.mdl
                ((Options.onClick PageFirst) :: propsPrevious)
                [ Icon.i "first_page" ]
            , Button.render Mdl
                [ 1 ]
                model.mdl
                ((Options.onClick PagePrevious) :: propsPrevious)
                [ Icon.i "chevron_left" ]
            , Options.styled span
                [ Typo.body1 ]
                [ text (toString model.page) ]
            , Button.render Mdl
                [ 2 ]
                model.mdl
                ((Options.onClick PageNext) :: propsNext)
                [ Icon.i "chevron_right" ]
            , Button.render Mdl
                [ 3 ]
                model.mdl
                ((Options.onClick PageLast) :: propsNext)
                [ Icon.i "last_page" ]
            ]



-- Subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- Main


main : Program Never Model Msg
main =
    Html.program
        { init = ( initModel, getTasks initModel )
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
