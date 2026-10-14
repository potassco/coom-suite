%%% Instantiate combination tables

table(C,X) :- coom_combinations(C,_,_), coom_context(C,Ctx), type_aux(X,Ctx).

% Base case: produce tuple (X,()) where X is the ground variable of the last column of the table
combinations_tuple((C,Ctx),Col,(X,())) :- table(C,Ctx),
                                          coom_combinations(C,Col,P), not coom_combinations(C,Col+1,_),
                                          path_to(Ctx,P,X).
% Recursive extension: add the ground variable of Col to the tuple of Col+1
combinations_tuple((C,Ctx),Col,(X',X)) :- combinations_tuple((C,Ctx),Col+1,X),
                                          coom_combinations(C,Col,P), Col >= 0,
                                          path_to(Ctx,P,X').

combinations_tuple(C,CT) :- combinations_tuple(C,0,CT).

combinations_column(C,CT,0,X)     :- combinations_tuple(C,CT), CT=(X,_).
combinations_column(C,CT,Col+1,X) :- combinations_column(C,CT,Col,_), combinations_suffix(CT,Col+1,(X,_)).

combinations_suffix(CT,0,CT)     :- combinations_tuple(_,CT).
combinations_suffix(CT,Col+1,CT'):- combinations_suffix(CT,Col,(_,CT')), CT' != ().

% Base case: top level combinations tuples
in_tuple((X,CT'),CT',X) :- combinations_tuple(_,CT), CT=(X,CT').
% Recursively unpack the CT' tuple
in_tuple(CT,CT',X)      :- in_tuple(CT,(X,CT'),_).

in_tuple(CT,X)          :- in_tuple(CT,_,X).
