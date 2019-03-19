open Cuceta

let p : char parser = andThen (char 'e') (char 'a')

let go str =
  let input = unpack str in
  match parse p input with
  | (Error _, rest) -> print_endline ("\"" ^ pack input ^ "\"" ^ " failed. Rest of input: " ^ pack rest)
  | (Ok _, rest) -> print_endline ("\"" ^ pack input ^ "\"" ^ " succeded. Rest of input: " ^ pack rest)

let () = go "ela"
let () = go "eala"
