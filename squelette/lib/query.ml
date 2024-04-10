open Sig

module Make (N : NODE) : QUERY_STRUCTURE = struct
  type data = int
  (* Le type des données sur lesquelles sont faites les requêtes *)

  type answer = N.answer
  (* Le type des réponses aux requêtes *)

  type tree = N.node Sig.binary_tree
  (* Le type Arbre, qui sera défini comme un arbre binaire *)
  
  

  let node_of_tree : tree -> N.node =
    fun arbre ->
      match arbre with
      | Node n -> n.node
      | Leaf n -> n.node
    ;;
  let treeNode_of_node : N.node -> tree -> tree -> tree =
    fun noeud filsgauche filsdroit ->
      Node {node=noeud; left_child = filsgauche; right_child = filsdroit};;

  let treeLeaf_of_node : N.node -> tree =
    fun noeud ->
      Leaf {node = noeud}






    (* Création de l’arbre *)
    (*Résumée :
       la première fonction aux permet de transformer la data list en liste de tree
       la deuxième partie fait la fusion des arbres et remet à la fin le nouvel arbre crée
       exemple : [3,3,3,3] -> [3,3,2] -> [2,2] -> [1]
       *)
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
    fun arbre valeur index  ->
      let rec aux = fun arbre valeur index ->
        match arbre with
        | Node n -> 
            if (node_of_tree n.left_child).right >= index && (node_of_tree n.left_child).left <= index then
              let newArbre = aux n.left_child valeur index in
              treeNode_of_node (N.combine (node_of_tree newArbre) (node_of_tree n.right_child)) newArbre n.right_child
            else
              let newArbre = aux n.right_child valeur index in
              treeNode_of_node (N.combine (node_of_tree n.left_child) (node_of_tree newArbre)) n.left_child newArbre
  
        | Leaf _ -> Leaf { node = {N.answer = (N.create valeur) ; N.left = index ; N.right = index }}
      in aux arbre valeur index




  let query : tree -> int -> int -> answer =
   fun arbre debut fin -> 
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
