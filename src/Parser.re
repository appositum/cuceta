type result('e, 'a) = Failure('e) | Success('a) 

type parse_error =
  | EndOfStream
  | EmptyInput
  | DoesNotSatisfy

type parser('a) = Parser(list(char) => (result(parse_error, 'a), list(char)))

let parse = (Parser(f)) => f

let map = (f, p) => {
  let func = input => {
    switch(parse(p, input)) {
    | (Failure(err), rest) => (Failure(err), rest)
    | (Success(a), rest) => (Success(f(a)), rest)
    }
  }

  Parser(func)
}

let wrap = a => Parser(input => (Success(a), input))

let apply = (pf, px) => {
  let func = input => {
    switch(parse(pf, input)) {
    | (Failure(err), rest) => (Failure(err), rest)
    | (Success(f), rest) => parse(map(f, px), rest)
    }
  }

  Parser(func)
}

let bind = (p, f) => {
  let func = input => {
    switch(parse(p, input)) {
    | (Failure(err), rest) => (Failure(err), rest)
    | (Success(a), rest) => parse(f(a), rest)
    }
  }

  Parser(func)
}

let satisfy = predicate => {
  let func = fun
    | [] => (Failure(EndOfStream), [])
    | [x, ...xs] =>
      if (predicate(x)) (Success(x), xs) else (Failure(DoesNotSatisfy), xs)

  Parser(func)
}

let char = c => satisfy(x => x == c)

let unpack = str => {
  let rec aux(i, xs) = {
    if (i < 0) xs else aux(i-1, [str.[i], ...xs])
  }
  aux(String.length(str) - 1, [])
}

let pack = xs => {
  xs
  |> List.map(String.make(1))
  |> String.concat("")
}
