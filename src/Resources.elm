module Resources exposing (Detail, Tag, resources, tagToString, allTags)

type alias Detail =
    { what : String
    , url : String
    , why : String
    , tags : List Tag
    }


type Tag
    = Text
    | Tool
    | Book
    | Video


tagToString : Tag -> String
tagToString tag =
    case tag of
        Book -> "Book"
        Text -> "Text"
        Video -> "Video"
        Tool -> "Tool"


allTags : List Tag
allTags =
    [ Text, Tool ]


resources : List Detail
resources =
    [ { what = "Official Guide"
      , url = "https://guide.elm-lang.org/"
      , why = "The best starting place"
      , tags = [ Text ]
      }
    , { what = "TEA Explained"
      , url = "https://medium.com/@l.mugnaini/the-elm-architecture-tea-animation-3efc555e8faf"
      , why = "An animated explication of The Elm Architechture (TEA)."
      , tags = [ Text ]
      }
    , { what = "Elm Bridge"
      , url = "https://elmbridge.github.io/curriculum/"
      , why = "Tutorials for learning the basics and a small application."
      , tags = [ Text ]
      }
    , { what = "elm-format"
      , url = "https://github.com/avh4/elm-format"
      , why = "For formatting your files. Keeps things consistent with other developers."
      , tags = [ Tool ]
      }
    , { what = "Ellie"
      , url = "https://ellie-app.com/"
      , why = "To test your ideas and share snippets of code."
      , tags = [ Tool ]
      }
    , { what = "Task Chaining"
      , url = "https://korban.net/posts/elm/2019-02-15-combining-http-requests-with-task-in-elm/"
      , why = "An excellent tutorial on chaining Tasks. Useful for sequential http requests."
      , tags = [ Text ]
      }
    , { what = "Exercism"
      , url = "https://exercism.io/tracks/elm"
      , why = "A website for practicing Elm, and other languages."
      , tags = [ Tool ]
      }
    , { what = "svg-to-elm"
      , url = "https://levelteams.com/svg-to-elm"
      , why = "A free utility for converting raw SVGs into elm/svg code."
      , tags = [ Tool ]
      }
    , { what = "Elm Doc Preview"
      , url = "https://github.com/dmy/elm-doc-preview"
      , why = "Offline documentation and previewer."
      , tags = [ Tool ]
      }
    , { what = "Elm Analyse"
      , url = "https://stil4m.github.io/elm-analyse/"
      , why = "Allows you to analyse your Elm code, identify deficiencies, and apply best practices."
      , tags = [ Tool ]
      }
    -- Not sure which book(s) to recommend
    --, { what = "Programming Elm"
    --  , url = "https://pragprog.com/book/jfelm/programming-elm"
    --  , why = "Written by Jeremy Fairbank and available on The Pragmatic Bookshelf."
    --  }
    --, { what = "Elm in Action"
    --  , url = "https://www.manning.com/books/elm-in-action"
    --  , why = "Written by Richard Feldman and available on Manning Publications"
    --  }
    --, { what = "Practical Elm: For a Busy Developer"
    --  , url = "https://korban.net/elm/book/"
    --  , why = "Written by Alex S. Korban and available on their website."
    --  }
    --, { what = "Intro to Elm"
    --  , url = "https://frontendmasters.com/courses/intro-elm/"
    --  , why = "Frontend Masters course on Elm, taught by Richard Feldman"
    --  }
    ]
