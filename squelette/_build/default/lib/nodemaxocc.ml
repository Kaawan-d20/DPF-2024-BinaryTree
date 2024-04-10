type data = int
type answer = int * int
type node = { answer : answer; left : int; right : int }

let max_tup : answer -> answer -> answer =
  fun (a, b) (c,d) ->
    if a = c then
      (a, b+d)
    else if a > c then
      (a,b)
    else
      (c,d)

let create : data -> answer = 
 fun valeur -> (valeur,1)

let combine : node -> node -> node =
 fun n m -> { answer = max_tup n.answer m.answer; left = n.left; right = m.right }

let to_string : answer -> string = 
 fun (a,b) -> "(" ^ string_of_int a ^ ", " ^ string_of_int b ^ ")"
