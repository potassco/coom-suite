% Replace association variables with their actual associations
% sus needed?
&sus{X'} =: X :- replace((X,X'),(A,I)), associate(A,I).
