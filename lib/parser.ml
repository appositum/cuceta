type parse_error =
  | EndOfStream
  | DoesNotSatisfy

type 'a parser =
  Parser of (char list -> ('a, parse_error) result * char list)

let parse (Parser f) = f

let pure a = Parser (fun input -> (Ok a, input))

let map f p =
  Parser (fun input ->
    match parse p input with
    | (Error e, rest) -> (Error e, rest)
    | (Ok a, rest) -> (Ok (f a), rest)
  )

let apply pf px =
  Parser (fun input ->
    match parse pf input with
    | (Error e, rest) -> (Error e, rest)
    | (Ok f, rest) -> parse (map f px) rest
  )

let bind f p =
  Parser (fun input ->
    match parse p input with
    | (Error e, rest) -> (Error e, rest)
    | (Ok a, rest) -> parse (f a) rest
  )

let satisfy pred =
  Parser (function
    | [] -> (Error EndOfStream, [])
    | x::xs -> if pred x then (Ok x, xs) else (Error DoesNotSatisfy, xs)
  )

let char c = satisfy (fun x -> x = c)
