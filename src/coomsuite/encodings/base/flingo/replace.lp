% Replace association variables with their actual associations
% sus needed?
&sus{X'} =: X :- replace(((X,X'),ID),_), #false : replace(((X,X'),ID),(A,N,I)), not associate(A,N,I).
