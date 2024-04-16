type data = int
(* Le type des données sur lesquelles sont faites les requêtes *)

type answer = { sum : int; prefix : int; suffix : int; subseg : int }
(* Le type des réponses aux requêtes *)

type node = { answer : answer; left : int; right : int }
(* Les nœuds contiennent des données et les bornes gauche et droite de l’intervalle qu’ils représentent *)

(* Création d’une réponse à partir d'une unique valeur *)
let create : data -> answer = 
  fun valeur -> { sum = valeur; prefix = valeur; suffix = valeur; subseg = valeur }
;;

(* Nœud obtenu par la combinaison de deux autres nœuds *)
let combine : node -> node -> node =
  fun n m ->
  {
    answer = {
      sum = n.answer.sum + m.answer.sum ; (* La somme des deux node *)
      prefix = max (n.answer.prefix) (n.answer.sum + m.answer.prefix) ; (* La somme la plus grande en partant de la feuille la plus à gauche (mal dit : la somme tant que ya pas une valeur qui la fait baisser) *)
      suffix = max (m.answer.suffix) (m.answer.sum + n.answer.suffix) ; (* La somme la plus grande en partant de la feuille la plus à droite (mal dit : la somme tant que ya pas une valeur qui la fait baisser) *)
      subseg = max (max (n.answer.subseg) (m.answer.subseg)) (n.answer.suffix + m.answer.prefix) (* La plus grande somme contiguë dans l'intervale, c'est-à-dire, le max entre le subseg de gauche, le subseg de droit, et l'addition du suffixe de gauche et le préfixe de droite *)
      }; 
    left = n.left;
    right = m.right
  }
;;

(* Pour l'affichage des réponses *)
let to_string : answer -> string = 
  fun answer -> string_of_int answer.subseg
;;
