#program new_object(name,type,parent,index,set).
% TODO: split up into different program parts for the below? (maybe not as include uses several of the below predicates)

type(name,type).
parent(name,parent).
index(name,index).
set(set,name).

#program new_constraint(cons,type).
constraint(cons,type).

#program new_column(cons,id,col,name).
column(cons,id,col,name).

#program new_unary(form,op,arg).
unary(form,op,arg).

#program new_binary(form,lhs,op,rhs).
binary(form,lhs,op,rhs).

#program new_function(fun,agg,set).
function(fun,agg,set).
