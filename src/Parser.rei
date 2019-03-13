type parser('a)
type parse_error
type result('e, 'a)
let parse : parser('a) => list(char) => (result(parse_error, 'a), list(char))
let map : ('a => 'b) => parser('a) => parser('b)
let apply : parser('a => 'b) => parser('a) => parser('b)
let return : 'a => parser('a)
let satisfy : (char => bool) => parser(char)
let char : char => parser(char)
