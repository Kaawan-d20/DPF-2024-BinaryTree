open Sig

module Make (N : NODE) : QUERY_STRUCTURE = struct
  type data = int
  (* Le type des données sur lesquelles sont faites les requêtes. *)

  type answer = N.answer
  (* Le type des réponses aux requêtes. *)

  type tree = N.node Sig.binary_tree
  (* Le type Arbre, qui sera défini comme un arbre binaire. *)
  
  (* Permet d'obtenir le node d'un arbre. *)
  let node_of_tree : tree -> N.node =
    fun arbre ->
      match arbre with
      | Node n -> n.node
      | Leaf n -> n.node
  ;;

  (* Permet d'obtenir le fils gauche d'un arbre. *)
  let getLeft : tree -> tree =
    fun arbre ->
      match arbre with
      | Node n -> n.left_child
      | _  -> failwith "Erreur getLeft"
  ;;

  (* Permet d'obtenir le fils droit d'un arbre. *)
  let getRight : tree -> tree =
    fun arbre ->
      match arbre with
      | Node n -> n.right_child
      | _  -> failwith "Erreur getRight"
  ;;

  (* Création de l’arbre.
  Résumée :
    La première fonction aux permet de transformer la data list en liste de tree.
    La deuxième partie fait la fusion des arbres et remet à la fin le nouvel arbre crée.
      Exemple : [3,3,3,3] -> [3,3,2] -> [2,2] -> [1] *)
  let create : data list -> tree = 
    fun liste ->
      (* La liste de donnée que l'on a en paramètre est transformer en une liste de Leaf. *)
      let rec aux =
        fun liste acc nb->
          match liste with
          | [] -> acc (* Toutes les données ont été converti en Leaf. *)
          | head :: tail -> aux tail (acc @ [Leaf {node = {N.answer = (N.create head) ; N.left = nb ; N.right = nb}}]) (nb + 1)  (* Appel récursif, ajout et création à la fin d'une Leaf. *)
      in let result = aux liste [] 0 in

      (* Fusionne les deux premier element et le place à la fin et quand il y a plus qu'un seul element, l'arbre est construit. *)
      let rec aux2 : tree list -> tree = 
        fun liste ->
          match liste with
          | element :: [] -> element (* Cas où il reste plus que la racine. *)
          | Node head :: Node mid :: tail -> aux2 (tail @ [(Node {node = (N.combine head.node mid.node) ; left_child = Node head ; right_child = Node mid})]) (* Cas où l'on fusionne 2 Node, utilisation du @ pour pouvoir mettre le nouvel element à la fin. *)
          | Leaf head :: Leaf mid :: tail -> aux2 (tail @ [(Node {node = (N.combine head.node mid.node) ; left_child = Leaf head ; right_child = Leaf mid})]) (* Cas où l'on fusionne 2 Leaf, utilisation du @ pour pouvoir mettre le nouvel element à la fin. *)
          | _ -> failwith "Erreur fusion create" (* Cas où l'on aurait autre chose que des Leaf ou des Node, ce qui n'est pas censé arrivée. *)
      in aux2 result
  ;;

  (* Mise à jour d’un élément de l'arbre.
  Résumé : 
    On descend à la feuille qui à le bonne indice,
    on la remplace par une nouvelle feuille qui à la nouvelle valeur,
    et en remontant dans la récursion on recrée les Nodes par lesquels on est passée. *)
  let rec update : tree -> data -> int -> tree =
    fun arbre valeur index  ->
      match arbre with
      | Node n -> 
        (* On regarde si l'index que l'on a est compris dans le fils gauche, si oui on fait l'appel récursif qui va renvoyer une nouvelle version du fils gauche et donc on recrée le node. *)
        if (node_of_tree n.left_child).right >= index && (node_of_tree n.left_child).left <= index then
          let newArbre = update n.left_child valeur index in (* Appel récursif. *)
          Node {node = (N.combine (node_of_tree newArbre) (node_of_tree n.right_child)) ; left_child = newArbre ; right_child = n.right_child} (* Création du Node avec la mise à jour qui à été fait dans l'appel récursif. *)
        (* Sinon la même chose mais avec le fils droit. *)
        else
          let newArbre = update n.right_child valeur index in (* Appel récursif. *)
          Node {node = (N.combine (node_of_tree n.left_child) (node_of_tree newArbre)) ; left_child = n.left_child ; right_child = newArbre} (* Création du Node avec la mise à jour qui à été fait dans l'appel récursif. *)
      (* Normalement c'est la feuille que l'on veut changer. *)  
      | Leaf _ -> Leaf { node = {N.answer = (N.create valeur) ; N.left = index ; N.right = index }}
  ;;

  (* Interrogation de l'arbre.
  Résumé :
    Si c'est une feuille :
      On vérifie qu'elle est bien compris dans l'interval et on la retourne sinon on lève une erreur.
    Si c'est un noeud :
      On vérifie si où l'on est c'est exactement l'interval, on le retourne.
      Sinon on regarde,
        Si l'arbre s'entrecoupe avec l'intervalle
          On regarde si les deux sous arbre s'entrecoupe avec l'intervalle, on fait l'appel récursif sur les deux sous arbre et on fusionne les résultats puis on le renvoie.
          Sinon, 
            On regarde si le sous arbre gauche s'entrecoupe avec l'intervalle, on fait l'appel récursif sur le sous arbre gauche et on le revoie.
            Sinon c'est le sous arbre gauche s'entrecoupe avec l'intervalle, on fait l'appel récursif sur le sous arbre droit et on le revoie.
        Si l'arbre ne s'entrecoupe pas avec l'intervalle, on lève une erreur
  *)
  let query : tree -> int -> int -> answer =
    fun arbre debut fin -> 
      let rec aux =
        fun arbre debut fin ->
          (* Fonction qui permet de savoir si l'intervale de arbre courant est partiellement compris dans l'interval recherché *)
          let intervalle_est_compris : int -> int -> int -> int -> bool =
            fun left right debut fin ->
              (debut <= left && left <= fin) || (debut <= right && right <= fin) || (debut > left && fin < right)
          in
          match arbre with
          (* Si on arrive sur une feuille, on ne peut pas checker les enfants, et donc elle est inclue, ou on ne devrait pas arriver là *)
          | Leaf _ -> let feuilleNode = node_of_tree arbre in
            if intervalle_est_compris feuilleNode.left feuilleNode.right debut fin then
              feuilleNode
            else
              failwith "Erreur query Leaf" (* Tu n'es pas censé(e) arriver là *)
          (* Si on arrive sur un noeud *)
          | Node _ ->
            let arbreNode = node_of_tree arbre in
            (* Si le noeud est exactement l'intervalle, alors on le retourne *)
            if arbreNode.left=debut && arbreNode.right=fin then
              arbreNode
            (* Sinon, cas par cas *)
            else
              (* Si l'arbre et l'intervalle s'entre-coupent (c'est-à-dire si il y'a le moindre element en commun entre l'arbre et l'intervalle) *)
              if intervalle_est_compris arbreNode.left arbreNode.right debut fin then
                let leftNode = node_of_tree (getLeft arbre) and rightNode = node_of_tree (getRight arbre) in
                (* Si les deux enfants du noeud s'entrecoupent avec l'intervalle, on combine le résultat des appels récursifs de la fonction pour les deux enfants *)
                if (intervalle_est_compris leftNode.left leftNode.right debut fin) && (intervalle_est_compris rightNode.left rightNode.right debut fin) then
                  N.combine (aux (getLeft arbre) debut fin) (aux (getRight arbre) debut fin)
                else
                  (* Si seul le sous arbre gauche s'entrecoupe avec l'intervalle, on renvoie le résultat de l'appel récursif sur le sous arbre gauche *)
                  if intervalle_est_compris leftNode.left leftNode.right debut fin then
                    aux (getLeft arbre) debut fin
                  (* Si seul le sous arbre droit s'entrecoupe avec l'intervalle, on renvoie le résultat de l'appel récursif sur le sous arbre droit *)
                  else
                    aux (getRight arbre) debut fin
              (* Erreur utilisateur, l'intervalle est externe a l'arbre, on ne devrait pas arriver à ce cas en récursion *)
              else
                failwith "L'intervale donnée est en dehors de l'arbre"
      in (aux arbre debut fin).answer
  ;;

  (* Pour l'affichage des réponses *)
  let to_string = N.to_string;;

end