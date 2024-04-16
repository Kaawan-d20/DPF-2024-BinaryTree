type data = int
(* Le type des données sur lesquelles sont faites les requêtes *)

type answer = int * int
(* Le type des réponses aux requêtes *)

type node = { answer : answer; left : int; right : int }
(* Les nœuds contiennent des données et les bornes gauche et droite de l’intervalle qu’ils représentent *)

(* Création d’une réponse à partir d'une unique valeur *)
let create : data -> answer = 
  fun valeur -> (valeur,1)
;;

(* Nœud obtenu par la combinaison de deux autres nœuds *)
let combine : node -> node -> node =
  fun n m ->
    let max_tup : answer -> answer -> answer =
      fun (a, b) (c,d) ->
        if a = c then (* Si le les deux node sont égaux, alors on fait la somme de leur nombre d'occurrence *)
          (a, b+d)
        else if a > c then
          (a,b)
        else
          (c,d)
    in { answer = max_tup n.answer m.answer; left = n.left; right = m.right }
;;

(* Pour l'affichage des réponses *)
let to_string : answer -> string = 
  fun (a,b) -> "(" ^ string_of_int a ^ ", " ^ string_of_int b ^ ")"
;;