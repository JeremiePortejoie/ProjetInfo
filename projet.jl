mutable struct Case
	x::Int64
	y::Int64
	terrain::Char
	Valparcours::Int64
	Nbparcours::Int64
	Visite::Bool
	Precx::Int64
	Precy::Int64
end



#test si la case est out-of-bound
function isOOB(D::Case)
	return (D.terrain == '@' || D.terrain == 'T' || D.terrain == 'O')
end


#test si la case est déjà visitée
function estNouveau(D::Case)
	return (D.Visite == 0)
end

function updateCase(V::Case, N::Case)
	N.Valparcours = V.Valparcours + CTrans[N.terrain]
	N.Nbparcours = V.Nbparcours + 1
	N.Precx = V.x
	N.Precy = V.y
	N.Visite = 1
end



function addDijkstra(V::Vector{Case},C::Case,S::Case)
	if !isOOB(S) && estNouveau(S)
		push!(V,S)
		updateCase(C,S)
	end
end


function addAstar(V::Vector{Case},C::Case,S::Case)
	if !isOOB(S) && estNouveau(S)
		push!(V,S)
		updateCase(C,S)
	end
end



function G(D::Case)
	return D.Valparcours
end

function H(D::Case, A::Case)
	return(abs(D.x - A.x) + abs(D.y - A.y))
end

function F(D::Case, A::Case)
	return (G(D) + H(D,A))
end


function afficheRes(D::Case,cpt::Int64)
	if D.Visite == 0
		println("Pas de chemin vers le point d'arrivée")
	else
		println("Nombre de cases parcourues par le chemin optimal: ",D.Nbparcours)
		println("Valeur du chemin parcouru : ",D.Valparcours)
		println("Nombre de cases évaluées (hors points frontières) : ",cpt)
	end
end



#créer le graphe à partir du fichier texte
function InitialisationMap(Carte::String,D::Tuple{Int, Int},A::Tuple{Int, Int})
	C::IOStream = open(Carte,"r")
	tab = readlines(C)

	
	n::Int64 = length(tab)-4 #hauteur
	
	m::Int64 = 0      # largeur
	m = parse.(Int64, tab[3][7:end])

	CarteMatrixee = Vector{Vector{Case}}(undef,n)
	for j in 1:n
	CarteMatrixee[j] = Vector{Case}(undef,m)
		for i in 1:m
			CarteMatrixee[j][i] = Case(i,j,tab[j+4][i],0,0,0,0,0)
		end
	end
	
	if isOOB(CarteMatrixee[D[2]][D[1]]) #test si le point de départ est valide
		throw(DomainError(CarteMatrixee[D[2]][D[1]],"Point de départ est out-of-bound"))
		return
	end
	
	if isOOB(CarteMatrixee[A[2]][A[1]]) #test si le point d'arrivée est valide
		throw(DomainError(CarteMatrixee[A[2]][A[1]],"Point d'arrivée est out-of-bound "))
		return
	end 

	close(C)
	return(CarteMatrixee,n,m)
end



CTrans::Dict{Char,Int64} = Dict('G' => 1,
				 '.' => 1,
				 'O' => 0,
                                'T' => 0,
                                '@' => 0,
                                'S' => 5,
                                'W' => 8)

           
         
           
#affiche la distance optimale de D à A et le nobmre de case parcourue.                     
function algoDijkstra(fname::String, D::Tuple{Int, Int}, A::Tuple{Int, Int})
	Graphe, n, m = InitialisationMap(fname,D,A)
	current::Case = Graphe[D[2]][D[1]]
	arrivee::Case = Graphe[A[2]][A[1]]
	Front::Vector{Case} = [current]
	cpt::Int64 = 0
	current.Visite = 1
	a::Vector{Any} = []

	
	
	while (current != arrivee && isempty(Front) != a)
	
		if current.x > 1 && current.x < m
			addDijkstra(Front,current,Graphe[current.y][current.x + 1])
			addDijkstra(Front,current,Graphe[current.y][current.x - 1])
		elseif current.x == 1
			addDijkstra(Front,current,Graphe[current.y][current.x + 1])
		else current.x == m
			addDijkstra(Front,current,Graphe[current.y][current.x - 1])
		end
		
		if current.y > 1 && current.y < n
			addDijkstra(Front,current,Graphe[current.y + 1][current.x])
			addDijkstra(Front,current,Graphe[current.y - 1][current.x])
		elseif current.y == 1
			addDijkstra(Front,current,Graphe[current.y + 1][current.x])
		else current.y == n
			addDijkstra(Front,current,Graphe[current.y - 1][current.x])
		end
		
		cpt = cpt + 1

		temp::Int64 = 1
		for i in 1:length(Front)
			if Front[i].Valparcours < Front[temp].Valparcours
				temp = i
			end
		end
		
		if Front[temp] == arrivee
			updateCase(current,arrivee)
			arrivee.Visite = 1
		end
		
		current = Front[temp]
		deleteat!(Front,temp)
	end
	
	afficheRes(arrivee,cpt)
end



function algoAstar(fname::String, D::Tuple{Int, Int}, A::Tuple{Int, Int})
	Graphe, n, m = InitialisationMap(fname,D,A)
	current::Case = Graphe[D[2]][D[1]]
	arrivee::Case = Graphe[A[2]][A[1]]
	Front::Vector{Case} = [current]
	cpt::Int64 = 0
	current.Visite = 1
	a::Vector{Any} = []

	
	while (current != arrivee && isempty(Front) != a)
		if current.x > 1 && current.x < m
			addAstar(Front,current,Graphe[current.y][current.x + 1])
			addAstar(Front,current,Graphe[current.y][current.x - 1])
		elseif current.x == 1
			addAstar(Front,current,Graphe[current.y][current.x + 1])
		else current.x == m
			addAstar(Front,current,Graphe[current.y][current.x - 1])
		end
		
		if current.y > 1 && current.y < n
			addAstar(Front,current,Graphe[current.y + 1][current.x])
			addAstar(Front,current,Graphe[current.y - 1][current.x])
		elseif current.y == 1
			addAstar(Front,current,Graphe[current.y + 1][current.x])
		else current.y == n
			addAstar(Front,current,Graphe[current.y - 1][current.x])
		end
		
		cpt = cpt + 1

		temp::Int64 = 1
		for i in 2:length(Front)
			if (F(Front[i],arrivee) < (F(Front[temp],arrivee)))
				temp = i
			end
		end

		if Front[temp] == arrivee
			updateCase(current,arrivee)
			arrivee.Visite = 1
		end
		current = Front[temp]
		deleteat!(Front,temp)
	end

	afficheRes(arrivee,cpt)
end
