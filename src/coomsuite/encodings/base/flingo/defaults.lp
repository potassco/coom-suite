% default value of integer variables is given by a numeric term
% the assignment defines X by the value of term G
&sus{G} =: X :- default(X,G), type(X,T), integer(T), include(X), #false : user_value(X,_), consistent(X,_).
