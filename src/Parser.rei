type parser('a)
type parse_error
type result('e, 'a)
let parse : parser('a) => list(char) => (result(parse_error, 'a), list(char))
let map : ('a => 'b) => parser('a) => parser('b)
let apply : parser('a => 'b) => parser('a) => parser('b)
let wrap : 'a => parser('a)
let bind : parser('a) => ('a => parser('b)) => parser('b)
let satisfy : (char => bool) => parser(char)
let char : char => parser(char)
let unpack : string => list(char)
let pack : list(char) => string
