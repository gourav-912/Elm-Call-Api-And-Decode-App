module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick)
import Http
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, optional, requiredAt, optionalAt)


json =
    """
    [
        {
          "userId": 1,
          "id": 1,
          "title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
          "body": "quia et suscipito"
        },
        {
          "userId": 1,
          "id": 2,
          "title": "qui est esse",
          "body": "est rerum tempore vitae"
        }
        ]
    """


type alias Post =
    { userId : Int
    , id : Int
    , title : String
    , body : String
    }


postDecoder : Decoder Post
postDecoder =
    decode Post
        |> required "userId" int
        |> required "id" int
        |> required "title" string
        |> required "body" string


responseDecoder : Decoder (List Post)
responseDecoder =
    Json.Decode.list postDecoder


decodeResults : String -> List Post
decodeResults json =
    case decodeString responseDecoder json of
        Ok posts ->
            posts

        Err message ->
            []


main =
    decodeResults json
        |> toString
        |> text
