% Replace association variables with their actual associations
% sus needed?
&sus{X'} =: X :- replace((X,X'),(A,N,I)), associate(A,N,I).
