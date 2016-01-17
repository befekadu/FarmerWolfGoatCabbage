% states that they must change sides of the river. 
opposite(e,w).
opposite(w,e).

% Farmer (F1) takes himself and nothing with him across the river (F2). 
% The move only happens if this move is a safe state and if opposite checks out which states that they must change side of river. 
move([F1,W,G,C],[F2,W,G,C]) :- opposite(F1,F2),safe([F2,W,G,C]).
 
% Farmer and wolf are on same side of river before move (S1) and on same side of river after move (S2). 
% The move only happens if this move is a safe state and if opposite checks out which states that they must change side of river.
move([S1,S1,G,C],[S2,S2,G,C]) :- opposite(S1,S2),safe([S2,S2,G,C]). 

% Farmer and goat are on same side of river before move (S1) and on same side of river after move (S2). 
% The move only happens if this move is a safe state and if opposite checks out which states that they must change side of river.
move([S1,W,S1,C],[S2,W,S2,C]) :- opposite(S1,S2),safe([S2,W,S2,C]). 

% Farmer and cabbage are on same side of river before move (S1) and on same side of river after move (S2). 
% The move only happens if this move is a safe state and if opposite checks out which states that they must change side of river.
move([S1,W,G,S1],[S2,W,G,S2]) :- opposite(S1,S2),safe([S2,W,G,S2]). 

% If it does not equal unsafe then the move is safe.
safe([F,W,G,C]) :- \+(unsafe([F,W,G,C])). 

% This says if at least one of the goat or the wolf is on the same bank as the farmer
unsafe([S1,S2,S2,_]) :- opposite(S1,S2). 

% (continuing from last one) and if at least one of the goat or cabbage is on the same side as the farmer, then the state is safe.
unsafe([S1,_,S2,S2]) :- opposite(S1,S2).

% Initial state with all 4 (farmer, wolf, goat, cabbage) on west bank.  
solution([[w,w,w,w]]). 

% Solution is defined recursively as one move that takes you to your next move followed by another solution. 
solution([State1, State2 | Tail]) :- move(State1, State2), solution([State2|Tail]). 

% The starting configuration is [e,e,e,e] and if the statelist sent in to find a solution for is less than 8 then it should take you to your goal.
% the cut operator is only going to terminate at the first solution.
puzzle([Start|StateList]) :- Start = [e,e,e,e], length(StateList,L), L<8, solution([Start|StateList]), printSolution([Start|StateList]),!. 

printSolution([X|Y]) :- write('Start. '), writeLocation(X),!,printMoves([X|Y]), write('Solved.\n').
writeLocation(X) :- getList(X, e, E), getList(X, w, W), write('East: '), writeList(E), write('West: '), writeList(W), write('\n').

getList([],_,[]).
getList([H],H,[cabbage|L]) :- length([H],N), N=1, getList(Tail,H,L).
getList([H|Tail],H,[goat|L]) :- length([H|Tail],N), N=2, getList(Tail,H,L).
getList([H|Tail],H,[wolf|L]) :- length([H|Tail],N), N=3, getList(Tail,H,L).
getList([H|Tail],H,[farmer|L]) :- length([H|Tail],N), N=4, getList(Tail,H,L).
getList([H|Tail],Z,L) :- \+ (H=Z), getList(Tail, Z, L).

writeList([]). 
writeList([X]) :- write(X), write(' ').
writeList([H|L]) :- write(H), write(', '), writeList(L).

% Print the moves 
printMoves([]).
printMoves([_]).
printMoves([X, Y|Z]) :- X = [A, B, C, D], Y = [E, B, C, D], opposite(A, E), write('Farmer takes himself. '), writeLocation(Y), printMoves([Y|Z]).
printMoves([X, Y|Z]) :- X = [A, A, C, D], Y = [E, E, C, D], opposite(A, E), write('Farmer takes wolf. '), writeLocation(Y), printMoves([Y|Z]).
printMoves([X, Y|Z]) :- X = [A, B, A, D], Y = [E, B, E, D], opposite(A, E), write('Farmer takes goat. '), writeLocation(Y), printMoves([Y|Z]).
printMoves([X, Y|Z]) :- X = [A, B, C, A], Y = [E, B, C, E], opposite(A, E), write('Farmer takes cabbage. '), writeLocation(Y), printMoves([Y|Z]).
