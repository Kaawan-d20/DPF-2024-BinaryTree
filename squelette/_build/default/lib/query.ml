open Sig

module Make (N : NODE) : QUERY_STRUCTURE = struct
  type data = int
  (* Le type des données sur lesquelles sont faites les requêtes *)

  type answer = N.answer
  (* Le type des réponses aux requêtes *)

  type tree = N.node Sig.binary_tree
  (* Le type Arbre, qui sera défini comme un arbre binaire *)
  
  
    (* Création de l’arbre *)
let create : data list -> tree = 
  fun liste -> 
   let rec aux =
     fun liste acc nb->
       match liste with
       | [] -> acc
       | head :: tail -> aux tail (Leaf { node = {N.answer = (N.create head) ; N.left = nb ; N.right = nb } }::acc) (nb+1)
       (*SI QUELQUE CHOSE CASSE, REGARDER CA      ^                            ^             ^*)
     in let result = aux liste [] 0 in
       let rec aux2 : tree list -> tree= 
         fun liste ->
           match liste with
           | [element] -> element
           | Node head :: Node mid :: tail -> aux2 ([(Node {node = (N.combine head.node mid.node); left_child = Node head; right_child = Node mid})] @ tail)
           | Leaf head :: Leaf mid :: tail -> aux2 ([(Node {node = (N.combine head.node mid.node); left_child = Leaf head; right_child = Leaf mid})] @ tail)
           | _ -> raise Not_found
     in aux2 result 
 
 ;;

  (* Mise à jour d’un élément de la liste *)
  let update : tree -> data -> int -> tree =
   fun _ _ _  ->
    Leaf { node = { answer = N.create 0 ; left = 0 ; right = 0 } }

  let query : tree -> int -> int -> answer =
   fun _ _ _ -> 
    N.create 0

  let to_string = N.to_string
  
end


(*
type 'a binary_tree =
  | Leaf of { node : 'a }
  | Node of {
      node : 'a;
      left_child : 'a binary_tree;
      right_child : 'a binary_tree;
    }*)
