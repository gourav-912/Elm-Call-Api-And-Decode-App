module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Task exposing (Task)
import Http
import Json.Decode exposing (string, int, list, field, map3, decodeString, Decoder)
import Json.Decode.Pipeline exposing (decode, required)


tableStyle : List ( String, String )
tableStyle =
    [ ( "width", "100%" )
    , ( "margin-bottom", "1rem" )
    , ( "background-color", "transparent" )
    , ( "border-collapse", "collapse" )
    ]


tdStyle : List ( String, String )
tdStyle =
    [ ( "vertical-align", "middle" )
    , ( "padding", ".75rem" )
    , ( "border-top", "1px solid #dee2e6" )
    , ( "text-align", "center" )
    ]


thStyle : List ( String, String )
thStyle =
    [ ( "border-bottom", "2px solid #dee2e6" )
    , ( "vertical-align", "middle" )
    , ( "padding", ".75rem" )
    , ( "border-top", "1px solid #dee2e6" )
    ]


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { url : String
    , results : List UserModel
    , errorMessage : Maybe String
    }


init : ( Model, Cmd Msg )
init =
    ( Model "https://jsonplaceholder.typicode.com/posts" [] Nothing
    , getUsers "https://jsonplaceholder.typicode.com/posts"
    )


type alias UserModel =
    { userId : Int
    , id : Int
    , title : String
    , description : String
    }


type Msg
    = HandleResponse (Result Http.Error (List UserModel))


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


getUsers : String -> Cmd Msg
getUsers url =
    Http.get url userResponseDecoder
        |> Http.send HandleResponse


userResponseDecoder : Decoder (List UserModel)
userResponseDecoder =
    Json.Decode.list userDecoder


userDecoder : Decoder UserModel
userDecoder =
    decode UserModel
        |> Json.Decode.Pipeline.required "userId" int
        |> Json.Decode.Pipeline.required "id" int
        |> Json.Decode.Pipeline.required "title" string
        |> Json.Decode.Pipeline.required "body" string


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HandleResponse (Ok apiResult) ->
            ( { model | results = apiResult }, Cmd.none )

        HandleResponse (Err _) ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div [ style [ ( "font-family", "arial" ) ] ]
        [ h2 [] [ text model.url ]
        , br [] []
        , table [ style tableStyle ]
            ([ thead []
                [ th [ style (List.append thStyle [ ( "width", "10%" ) ]) ] [ text "User Id" ]
                , th [ style (List.append thStyle [ ( "width", "5%" ) ]) ] [ text "Id" ]
                , th [ style (List.append thStyle [ ( "width", "25%" ) ]) ] [ text "Title" ]
                , th [ style (List.append thStyle [ ( "width", "60%" ) ]) ] [ text "Description" ]
                ]
             ]
                ++ List.map toTableRow model.results
            )
        ]


toTableRow : UserModel -> Html Msg
toTableRow item =
    tr []
        [ td [ style tdStyle ] [ text (toString item.userId) ]
        , td [ style tdStyle ] [ text (toString item.id) ]
        , td [ style tdStyle ] [ text item.title ]
        , td [ style tdStyle ] [ text item.description ]
        ]
