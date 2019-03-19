type parse_error =
  | EndOfStream
  | DoesNotSatisfy

type 'a parser =
  Parser of (char list -> ('a, parse_error) result * char list)

let parse (Parser f) = f

let pack = List.fold_left (fun acc x -> acc ^ String.make 1 x) ""
let unpack s = List.init (String.length s) (String.get s)

let pure a = Parser (fun input -> (Ok a, input))

(** Functor mapping *)
let map f p =
  Parser (fun input ->
    match parse p input with
    | (Error e, rest) -> (Error e, rest)
    | (Ok a, rest) -> (Ok (f a), rest)
  )

(** Applicative functor mapping *)
let apply pf px =
  Parser (fun input ->
    match parse pf input with
    | (Error e, rest) -> (Error e, rest)
    | (Ok f, rest) -> parse (map f px) rest
  )

(** Monadic binding *)
let bind p f =
  Parser (fun input ->
    match parse p input with
    | (Error e, rest) -> (Error e, rest)
    | (Ok a, rest) -> parse (f a) rest
  )

(** Monadic sequence *)
let andThen p1 p2 = bind p1 (fun _ -> p2)

let satisfy pred =
  Parser (function
    | [] -> (Error EndOfStream, [])
    | x::xs -> if pred x then (Ok x, xs) else (Error DoesNotSatisfy, xs)
  )

let char c = satisfy (fun x -> x = c)

let is_space = function
  | ' '
  | '\n'
  | '\r'
  | '\t' -> true
  | _ -> false

let space = satisfy (fun x -> is_space x)
