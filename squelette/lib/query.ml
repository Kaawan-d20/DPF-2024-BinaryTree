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


  let getLeft : tree -> tree =
    fun arbre ->
      match arbre with
    | Node n -> n.left_child
    | _  -> failwith "erreur ";;

    let getRight : tree -> tree =
      fun arbre ->
        match arbre with
      | Node n -> n.right_child
      | _  -> failwith "erreur ";;

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
       | head :: tail -> aux tail (acc@[Leaf { node = {N.answer = (N.create head) ; N.left = nb ; N.right = nb } }]) (nb+1)
       (*SI QUELQUE CHOSE CASSE, REGARDER CA      ^                            ^             ^*)
     in let result = aux liste [] 0 in


       let rec aux2 : tree list -> tree= 
         fun liste ->
           match liste with
           | element :: [] -> element
           | Node head :: Node mid :: tail -> aux2 (tail @ [(Node {node = (N.combine head.node mid.node); left_child = Node head; right_child = Node mid})] )
           | Leaf head :: Leaf mid :: tail -> aux2 (tail @ [(Node {node = (N.combine head.node mid.node); left_child = Leaf head; right_child = Leaf mid})])
           | _ -> failwith "erreur create"
     in aux2 result 
 
 ;;


  (* Mise à jour d’un élément de la liste *)
  (*On descend à la feuille qui à le bonne indice,
     on la remplace par une nouvelle feuille qui à la nouvelle valeur,
     et en remontant dans la récursion on recrée les Nodes par lesquells on est passée*)
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

  ;;

  let intervalle_est_compris : int -> int -> int -> int -> bool =
    fun left right debut fin ->
      (debut <= left && left <= fin) || (debut <= right && right <= fin) || (debut > left && fin < right)
  ;;






  (*On verifie si où l'on est c'est exactement l'interval *)
  let query : tree -> int -> int -> answer =
    fun arbre debut fin -> 
     let rec aux =
       fun arbre debut fin ->
        match arbre with
        (*Si on arrive sur une feuille, on ne peut pas checker les enfants, et donc elle est inclue, ou on ne devrait pas arriver là*)
        | Leaf _ -> let feuilleNode = node_of_tree arbre in
            if intervalle_est_compris feuilleNode.left feuilleNode.right debut fin then
              feuilleNode
            else
              failwith "tu n'es pas censé(e) arriver là"
        (*Si on arrive sur un noeud*)
        | Node _ ->
          let arbreNode = node_of_tree arbre in
          (* Si le noeud est exactement l'intervalle, alors on le retourne *)
          if arbreNode.left=debut && arbreNode.right=fin then
            arbreNode
          (*Sinon, cas par cas*)
          else
            (*Si l'arbre et l'intervalle s'entre-coupent (c-a-d si il y'a le moindre element en commun entre l'arbre et l'intervalle)*)
            if intervalle_est_compris arbreNode.left arbreNode.right debut fin then
              let leftNode = node_of_tree (getLeft arbre) and rightNode = node_of_tree (getRight arbre) in
              (*Si les deux enfants du noeud s'entrecoupent avec l'intervalle, on combine le résultat des appels récursifs de la fonction pour les deux enfants*)
              if (intervalle_est_compris leftNode.left leftNode.right debut fin) && (intervalle_est_compris rightNode.left rightNode.right debut fin) then
                N.combine (aux (getLeft arbre) debut fin) (aux (getRight arbre) debut fin)
              else
                (*Si seul le sous arbre gauche s'entrecoupe avec l'intervalle, on renvoie le resultat de l'appel récursif sur le sous arbre gauche*)
                if intervalle_est_compris leftNode.left leftNode.right debut fin then
                  aux (getLeft arbre) debut fin
                (*Si seul le sous arbre droit s'entrecoupe avec l'intervalle, on renvoie le resultat de l'appel récursif sur le sous arbre droit*)
                else
                  aux (getRight arbre) debut fin
            (*Erreur utilisateur, l'intervalle est externe a l'arbre, on ne devrait pas arriver à ce cas en récursion*)
            else
              failwith "L'intervale donnée est en dehors de l'arbre"
     in (aux arbre debut fin).answer

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
