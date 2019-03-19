type parse_error =
  | EndOfStream
  | DoesNotSatisfy

type 'a parser =
  Parser of (char list -> ('a, parse_error) result * char list)

val pack : char list -> string
val unpack : string -> char list
val parse : 'a parser -> char list -> ('a, parse_error) result * char list
val pure : 'a -> 'a parser
val map : ('a -> 'b) -> 'a parser -> 'b parser
val apply : ('a -> 'b) parser -> 'a parser -> 'b parser
val bind : 'a parser -> ('a -> 'b parser) -> 'b parser
val satisfy : (char -> bool) -> char parser
val char : char -> char parser
val space : char parser
val andThen : 'a parser -> 'b parser -> 'b parser
