% TODO: add external active(index)
% needed in the include choice rule but probably also good for all the computation rules?
#program new_object(name,type,parent,index,set).

type(name,type).
parent(name,parent).
index(name,index).
set(set,name).

defined(name) :- value(name,_).

#program new_constraint(cons,type).
constraint(cons,type).

#program new_column(cons,id,col,name).
column(cons,id,col,name).

#program new_unary(form,op,arg).
unary(form,op,arg).

defined(form) :- value(form,_).

#program new_binary(form,lhs,op,rhs).
binary(form,lhs,op,rhs).

defined(form) :- value(form,_).

#program new_function(fun,agg,set).
function(fun,agg,set).

defined(fun) :- value(fun,_).
