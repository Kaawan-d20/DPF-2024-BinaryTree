type data = int;;
(* Le type des données sur lesquelles sont faites les requêtes *)

type answer = int;;
(* Le type des réponses aux requêtes *)

type node = { answer : answer; left : int; right : int };;
(* Les nœuds contiennent des données et les bornes gauche et droite de l’intervalle qu’ils représentent *)

(* Création d’une réponse à partir d'une unique valeur *)
let create : data -> answer = 
  fun info -> info
;;
  
(* Nœud obtenu par la combinaison de deux autres nœuds *)
let combine : node -> node -> node =
  fun n m -> 
    {answer = (n.answer + m.answer) ; left=n.left ; right=m.right} (* On fait la somme des deux noeud *)
;;

(* Pour l'affichage des réponses *)
let to_string : answer -> string = 
  fun answer -> string_of_int answer
;;