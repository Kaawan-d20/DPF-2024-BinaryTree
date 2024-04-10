type data = int
type answer = { sum : int; prefix : int; suffix : int; subseg : int }
type node = { answer : answer; left : int; right : int }


let max : int -> int -> int =
  fun n m ->
    if n > m then
      n
    else
      m
;;

let create : data -> answer = 
 fun valeur -> { sum = valeur; prefix = valeur; suffix = valeur; subseg = valeur }

let combine : node -> node -> node =
 fun n m ->
  {
    answer = {
      sum = n.answer.sum + m.answer.sum ; 
    prefix = max (n.answer.prefix) (n.answer.sum + m.answer.prefix) ; 
    suffix = max (m.answer.suffix) (m.answer.sum + n.answer.suffix) ; 
    subseg = max (max (n.answer.subseg) (m.answer.subseg)) (n.answer.suffix + m.answer.prefix) }; 
    left = n.left;
    right = m.right;
  }

let to_string : answer -> string = 
 fun answer -> string_of_int answer.subseg 
