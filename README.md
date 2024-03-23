# Devoir de Programmation Fonctionnelle 2023-2024 BinaryTree

Ce repository contient le code OCaml 🐫 du projet de Programmation Fonctionnelle de L2S4 du meilleur groupe d'Etudiants de la fac d'info d'Orléans :)

- Dany Dudiot
- Agathe Papineau
- Nathan Rissot

Ce devoir est dù au plus tard pour le **21 avril 2024**, sous la forme d'une Archive nommée `DUDIOT-PAPINEAU-RISSOT.zip` du dossier /squelette. il ne devra pas contenir de fichier pré-compilé (`dune clean` avant de compresser).

> ⚠ Il est demandé de **ne changer aucun nom de fichier** et d’utiliser **uniquement** les fichiers fournis.

## Description

L’objectif de ce projet est de concevoir une **structure de données** représentant un tableau de $n$ entiers sous forme **d’arbre binaire** et permettant de répondre **efficacement** à une requête donnée sur ce tableau, comme par exemple calculer la somme contenue dans un sous-tableau, la plus grande somme contenue dans un sous-tableau ou encore connaître le nombre de zéros dans un sous-tableau.

Dans l’arbre binaire, chaque **noeud** correspond à un **intervalle du tableau** et stocke une information permettant de répondre facilement à une requête donnée.

Ces informations peuvent être de diverses formes mais auront toujours le point commun suivant : 

Les noeuds contiendront dans tous les cas la valeur des bornes gauche et droite des intervalles qu’ils représentent. 

La racine correspond ainsi à l’intervalle $[0 ... n−1]$ du tableau et les feuilles aux intervalles $[i ... i]$ pour $0 ≤i ≤n −1$. 

L’arbre est ensuite construit récursivement en combinant les valeurs des deux noeuds enfants pour obtenir le noeud parent.


ex : maximum d'un sous tableau
:::mermaid
graph TD
0[max = 1, \n intervalle 0...0]
1[max = -4, \n intervalle 1...1]
2[max = 6, \n intervalle 2...2]
3[max = 8, \n intervalle 3...3]

01[max = 1, \n intervalle 0...1]
23[max = 8n \n intervalle 2...3]

03[max = 3, \n intervalle 0...3]

01 --- 0
01 --- 1

23 --- 2
23 --- 3

03 --- 01
03 --- 23
:::

## Organisation

Le dossier `\squelette` est un fichier de projet dune. c'est ce fichier qu'il faudra Zipper pour rendre.

Le fichier `\squelette\GROUPE.md` contient nos noms ainsi qu'un récapitulatifs de l'Organisation des tâches (CF ci dessous)

Le fichier `\squelette\README.md` contient un set d'instructions et de rappels du CM7 concernant l'utilisation de dune.

le dossier `\squelette\lib` contient les interface format `.mli` et le code au format `.ml` des différents modules a completer / implémenter

## Répartitions des Tâches

### Dany Dudiot :
- to be determined.

### Agathe Papineau :
- to be determined.

### Nathan Rissot :
- to be determined.

