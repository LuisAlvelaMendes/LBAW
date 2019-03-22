slots(4).
discipline(12).
discipline(1,[1,2,3,4,5]). %Alunos 1,2,3,4,5 inscritos à discipline 1
discipline(2,[6,7,8,9]).
discipline(3,[10,11,12]).
discipline(4,[1,2,3,4]).
discipline(5,[5,6,7,8]).
discipline(6,[9,10,11,12]).
discipline(7,[1,2,3,5]).
discipline(8,[6,7,8]).
discipline(9,[4,9,10,11,12]).
discipline(10,[1,2,4,5]).
discipline(11,[3,6,7,8]).
discipline(12,[9,10,11,12]). %Alunos 9,10,11,12 inscritos à discipline 12


countCommon([], _, Count, Count).

countCommon([D1|T], D2, Count, NewCount):-
	member(D1, D2),
	C1 is Count + 1,
	countCommon(T, D2, C1, NewCount).
	
countCommon([_|T], D2, Count, NewCount):-
	countCommon(T, D2, Count, NewCount).

tabelaIncompatibilidade(Discipline1, Discipline2, Count):-
	discipline(Discipline1, DiscList1),
	discipline(Discipline2, DiscList2),
	countCommon(DiscList1, DiscList2, 0, Count), !.
