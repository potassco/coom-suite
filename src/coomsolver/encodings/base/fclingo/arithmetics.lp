% Arithmetics
&sus{ XL;  XR } =: F :- binary(F,XL,"+",XR).
&sus{ XL; -XR } =: F :- binary(F,XL,"-",XR).

% Only linear constraints are supported
&sus{ XL*N } =: F :- binary(F,XL,"*",XR), number(XR,N).
&sus{ XR*N } =: F :- binary(F,XL,"*",XR), number(XL,N).
% TODO: Is division possible in fclingo?
% TODO: Add more arithmetics (division and power)
