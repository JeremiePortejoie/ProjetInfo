S'assurer que la carte que l'on va utiliser soit dans le même dossier que projet.jl et qu'elle commence de la même manière que les autres (type octale ...)

Faire dans le REPL julia : include("projet.jl")

Le REPL va afficher la méthode algoAstar()

pour exécuter, appeler au choix :
-algoDijkstra(fname,D,A)
-algoAstar(fname,D,A)

où fname est le nom du fichier à lire sous forme de chaine de caractère
où D est le point d'origine sous forme de Tuple {Int, Int}
où A est le point d'arrivée sous forme de Tuple {Int, Int}

à noter que le coin Nord-Ouest est le point (1,1), Nord-Est (n,1), Sud-Est (n,m), Sud-Ouest (1,m) avec n la largeur et m la hauteur.

l'algo retournera soit :
-une erreur si le point de départ OU le point d'arrivée sont out-of-bound
-un message indiquant, si c'est le cas, qu'il n'y a pas de chemin entre le point d'arrivée et le point de départ
-sinon si le chemin existe, indique le nombre de case empruntée, la valeur finale de ce chemin et le nombre de case visitées.

Ce fichier à été entièrement réalisé sur les machines de la fac, en cas de problème, n'hésitez pas à me contacter.