% TODO: FIx recursive removal of attributes when removing object
#script(python)
from clingo.symbol import Function
def name(a):
    """
    Takes the name form the path bu removing the prefix and the index
    """
    name = str(a).split(".")[-1].split("[")[0]
    return Function(name, [])
#end.

% ============ Auxiliaries
% ----- Parts
included_part("root").
included_part(I):-_all(include(I)), type(I,T), part(T).
included_part(I):-include(I), type(I,T), part(T), _clinguin_browsing.
included_part_by_assumption(I):- included_part(I), _clinguin_assume(include(I),true), I!="root".
possibly_included_part(I):-_any(include(I)), type(I,T), part(T), not included_part(I).
has_larger_part(I):-included_part(I), included_part(I'), set(P,I), set(P,I'), I'>I.
% ----- Enumerations
% TODO Enumerations are also optional
included_enum(I):-_all(include(I)), type(I,T), discrete(T), included_part(P), parent(I,P).
included_enum(I):-_all(include(I)), type(I,T), integer(T), included_part(P), parent(I,P).
included_enum(I):-include(I), type(I,T), discrete(T), included_part(P), parent(I,P),_clinguin_browsing.
included_enum(I):-include(I), type(I,T), integer(T), included_part(P), parent(I,P),_clinguin_browsing.
% ----- Attributes
included_attr(I):-included_enum(P),  _all(include(I)), parent(I,P).
included_attr(I):-included_enum(P),  include(I), parent(I,P), _clinguin_browsing.
included_enum_attr(I):-included_enum(I).
included_enum_attr(I):-included_attr(I).
% ----- Values
inferred_value(I,V):-included_enum_attr(I), _all(value(I,V)), not _clinguin_assume(value(I,V),true).
inferred_value(I,V):-included_enum_attr(I), value(I,V), _clinguin_browsing.

% ============ UI


% Window
elem(window, window, root).

% Main container for root part, other parts are added below recursively
elem(icontainer("root"), container, window).


    % +++++++ TITLE

    elem(ititle(I), container, icontainer((I))) :- included_part(I).
    attr(ititle(I), order, 1) :- included_part(I).
    attr(ititle(I), class, ("d-inline-flex";"flex-row";"px-3")) :- included_part(I).

        % Title label name
        elem(ititle_l(I), label, ititle(I)) :- included_part(I).
        attr(ititle_l(I), label,@name(I)) :- included_part(I).
        attr(ititle_l(I), class, ("h4")) :- included_part(I).
        attr(ititle_l(I), order, 1) :- included_part(I).

        % Title label type
        elem(ititle_t(I), label, ititle(I)) :- included_part(I).
        attr(ititle_t(I), label,  @format("({0})",T)) :- included_part(I), type(I,T).
        attr(ititle_t(I), class, ("px-1";"m-1";"fw-lighter")) :- included_part(I).
        attr(ititle_t(I), order, 2) :- included_part(I).

        % Title container to remove the part
        elem(ititle_bc(I), container, ititle(I)) :- included_part(I).
        attr(ititle_bc(I), class,  ("ms-auto")) :- included_part(I).
        attr(ititle_bc(I), order,  3) :- included_part(I).

            % Title button to remove the part
            elem(ititle_b(I), button, ititle_bc(I)) :- included_part(I).
            attr(ititle_b(I), icon,  "fa-trash") :- included_part(I).
            attr(ititle_b(I), class,  ("border-0")) :- included_part(I).
            attr(ititle_b(I), class,  ("btn-outline-danger";"border-0")) :- included_part_by_assumption(I), not has_larger_part(I).
            attr(ititle_b(I), class,  ("btn-outline-info";"disabled")) :- included_part(I), not included_part_by_assumption(I).
            attr(ititle_b(I), tooltip,  "Can't remove inferred object") :- included_part(I), not included_part_by_assumption(I).
            attr(ititle_b(I), class,  ("btn-outline-info";"disabled")) :- included_part(I), has_larger_part(I).
            attr(ititle_b(I), tooltip, @format("Remove other {} first",T)) :- type(I,T), included_part(I), has_larger_part(I).
            % Recursive removal of parts, attributes and enumerations
            child_remove(I,I):-included_part_by_assumption(I),not has_larger_part(I).
            child_remove(I,I''):-child_remove(I, I'),parent(I'',I').
            child_assumption(I,include(I')):-child_remove(I,I').
            child_assumption(I,value(I',any)):-child_remove(I,I'), included_enum_attr(I').
            when(ititle_b(I), click,  call, remove_assumption_signature(A)) :- child_remove(I,I), child_assumption(I, A).


    % +++++++ ENUMERATIONS AND ATTRIBUTES

    %  Part container for all enumerations
    elem(ienumerations(I), container, icontainer(I)) :- included_part(I).
    attr(ienumerations(I), order, 2) :- included_part(I).
    attr(ienumerations(I), heigth, 50) :- included_part(I).
    attr(ienumerations(I), class, ("align-items-start";"d-inline-flex";"flex-row")) :- included_part(I).

        % Part container for Numeric Enumerations
        elem(inenumerations(I), container, ienumerations(I)) :- included_part(I).
        attr(inenumerations(I), order, 1) :- included_part(I).
        attr(inenumerations(I), heigth, 50) :- included_part(I).
        attr(inenumerations(I), class, ("align-items-start";"d-inline-flex";"flex-col")) :- included_part(I).

        %  Part container for Discrete enumerations
        elem(idenumerations(I), container, ienumerations(I)) :- included_part(I).
        attr(idenumerations(I), order, 2) :- included_part(I).
        attr(idenumerations(I), heigth, 50) :- included_part(I).
        attr(idenumerations(I), class, ("align-items-start";"d-inline-flex";"flex-row")) :- included_part(I).


            % Container per enumeration
            elem(eicontainer(I), container, idenumerations(P)) :- included_enum(I), parent(I,P), type(I,T), discrete(T).
            elem(eicontainer(I), container, inenumerations(P)) :- included_enum(I), parent(I,P), type(I,T), integer(T).
            attr(eicontainer(I), class, ("mx-3";"my-1";"px-2";"rounded")) :- included_enum(I).
            attr(eicontainer(I), class, ("d-inline-flex";"flex-col")) :- included_enum(I).
            attr(eicontainer(I), class, ("bg-secondary";"bg-opacity-10")) :- included_enum(I), type(I,T), discrete(T).
            attr(eicontainer(I), order, N) :- included_enum(I), #count{I':included_enum(I'), I'>I}=N.


                % Container for title and options of enumerations and attributes
                elem(eititle(I), container, eicontainer(E)) :- included_attr(I), parent(I,E).
                elem(eititle(I), container, eicontainer(I)) :- included_enum(I).
                attr(eititle(I), order, 1) :- included_enum(I).
                attr(eititle(I), order, 2) :- included_attr(I).
                attr(eititle(I), class, ("d-inline-flex";"flex-row";"justify-content-between")) :- included_enum_attr(I).

                    % Title for dropdown
                    elem(eititle_n(I), container, eititle(I)) :- included_enum_attr(I).
                    attr(eititle_n(I), class, ("d-inline-flex";"flex-row")) :- included_enum_attr(I).
                    attr(eititle_n(I), width, 200) :- included_enum_attr(I).

                        elem(eititle_l(I), label, eititle_n(I)) :- included_enum_attr(I).
                        attr(eititle_l(I), label, @name(I)) :- included_enum_attr(I).
                        attr(eititle_l(I), order, 1) :- included_enum_attr(I).
                        attr(eititle_l(I), class, "h6") :- included_enum(I).
                        attr(eititle_l(I), class, "h7") :- included_attr(I).
                        attr(eititle_l(I), class, ("fst-italic";"fw-medium")) :- included_enum(I), type(I,T), discrete(T).
                        attr(eititle_l(I), class, ("px-4";"fst-italic";"fw-light")) :- included_attr(I).
                        attr(eititle_l(I), class, ("fst-italic";"fw-light")) :- included_enum(I), type(I,T), integer(T).

                        % Added type to title only for discrete enumerations
                        elem(eititle_t(I), label, eititle_n(I)) :- included_enum(I),type(I,T), discrete(T).
                        attr(eititle_t(I), label, @format("({0})",T)) :- included_enum(I), type(I,T), discrete(T).
                        attr(eititle_t(I), class, ("px-1";"fw-lighter";"small")) :- included_enum(I),type(I,T), discrete(T).
                        attr(eititle_t(I), order, 2) :- included_enum(I),type(I,T), discrete(T).

                    % Container with dropdown
                    elem(eioption(I), container, eititle(I)) :- included_enum_attr(I).
                    attr(eioption(I), order, 3) :- included_enum_attr(I).
                    attr(eioption(I), class, "p-1") :- included_enum_attr(I).

                        elem(eioption_dd(I), dropdown_menu, eioption(I)) :- included_enum_attr(I).
                        attr(eioption_dd(I), selected, V) :- included_enum_attr(I), _all(value(I,V)), not _clinguin_browsing.
                        attr(eioption_dd(I), selected, V) :- included_enum_attr(I), value(I,V), _clinguin_browsing.


                        attr(eioption_dd(I), class, ("fw-bold")) :- included_enum_attr(I), value(I,V), _clinguin_browsing, not _all(value(I,V)).
                        attr(eioption_dd(I), class, ("opacity-50")) :- inferred_value(I,V), not _clinguin_browsing.
                        attr(eioption_dd(I), class, ("btn-secondary")) :- included_enum(I), type(I,T), discrete(T), not inferred_value(I,_).
                        attr(eioption_dd(I), class, ("btn-primary")) :- included_attr(I), type(I,T), not inferred_value(I,_).
                        attr(eioption_dd(I), class, ("btn-primary")) :- included_enum_attr(I), type(I,T), integer(T), not inferred_value(I,_).
                        attr(eioption_dd(I), class, ("border-0";"btn-outline-secondary")) :- included_enum(I), type(I,T), discrete(T), inferred_value(I,_).
                        attr(eioption_dd(I), class, ("border-0";"btn-outline-primary")) :- included_attr(I), type(I,T), inferred_value(I,_).
                        attr(eioption_dd(I), class, ("border-0";"btn-outline-primary")) :- included_enum_attr(I), type(I,T), integer(T), inferred_value(I,_).
                        attr(eioption_dd(I), class, ("btn-danger")) :- _clinguin_mus(value(I,V)).

                            option((I,V),invalid):- included_enum_attr(I), domain(T,V), type(I,T), not _any(value(I,V)), not _clinguin_assume(value(I,_),true).
                            option((I,V),valid):- included_enum_attr(I), _any(value(I,V)), not _clinguin_assume(value(I,_),true).

                            elem(eioption_ddi(I,V), dropdown_menu_item, eioption_dd(I)) :- option((I,V),_).
                            attr(eioption_ddi(I,V), label, V) :- option((I,V),_).
                            when(eioption_ddi(I,V), click, call, add_assumption(value(I,V))) :- option((I,V),_).
                            % when(eioption_ddi(I,V), click, call, (remove_assumption_signature(value(I,any)),add_assumption(value(I,V)))) :- option((I,V),_).
                            attr(eioption_ddi(I,V), class, ("text-danger")) :- option((I,V),invalid).

                            elem(eioption_ddi(I,remove), dropdown_menu_item, eioption_dd(I)) :- included_enum_attr(I).
                            attr(eioption_ddi(I,remove), icon, "fa-ban") :- included_enum_attr(I).
                            attr(eioption_ddi(I,remove), class, "text-info") :- included_enum_attr(I).
                            when(eioption_ddi(I,remove), click, call, remove_assumption_signature(value(I,any))) :- included_enum_attr(I).


    % +++++++ Parts

    %  Container for all sub-parts
    elem(ipart(I), container, icontainer(I)) :- included_part(I).
    attr(ipart(I), order, 5) :- included_part(I).
    attr(ipart(I), class, ("d-inline-flex";"flex-col")) :- included_part(I).

        % Container per part
        elem(icontainer(I), container, ipart(P)) :- included_part(I), parent(I,P).
        attr(icontainer(I), class, ("m-3";"p-3")) :- included_part(I).
        attr(icontainer(I), width, ("95%")) :- included_part(I).
        attr(icontainer(I), class, ("shadow")) :- included_part(I).
        attr(icontainer(I), class, ("bg-info";"bg-opacity-10")) :- included_part(I).
        attr(icontainer(I), class, ("bd-highlight";"d-inline-flex";"flex-col";"rounded")) :- included_part(I).
        attr(icontainer(I), class, ("border";"border-dark";"border-1")) :- included_part(I).

    % Containier for button to add a new part
    elem(iadd(I), container, icontainer(I)) :- included_part(I).
    attr(iadd(I), order, 4) :- included_part(I).
    attr(iadd(I), class, ("mx-2";"d-inline-flex";"flex-row")) :- included_part(I).

        % One container per part type to include
        elem(iposf(I), container, iadd(P)) :- possibly_included_part(I), parent(I,P), not included_part(I), #false: possibly_included_part(I'), set(X,I), set(X,I'), I'<I.

            elem(iposf_l(I), button, iposf(I)) :- elem(iposf(I),_,_).
            attr(iposf_l(I), label, @name(I)) :- elem(iposf(I),_,_).
            attr(iposf_l(I), icon, "fa-circle-plus") :- elem(iposf(I),_,_).
            attr(iposf_l(I), class, ("btn-outline-dark";"border-0")) :- elem(iposf(I),_,_).
            when(iposf_l(I), click, call, add_assumption(include(I))) :- elem(iposf(I),_,_).



    % +++++++ Messages for explanation
    elem(message_unsat(ID), message, window):-_clinguin_mus(constraint(ID,"boolean")).
    attr(message_unsat(ID), title, "Explanation"):-_clinguin_mus(constraint(ID,"boolean")).
    attr(message_unsat(ID), type, "error"):-_clinguin_mus(constraint(ID,"boolean")).
    attr(message_unsat((I,M)), message, M):-_clinguin_mus(constraint((I,M),"boolean")).



    % +++++++ Menu bar

    elem(menu_bar, menu_bar, window).
    attr(menu_bar, title, "COOM solver").
    attr(menu_bar, icon, "fa-cog").


        elem(menu_bar_restart, button, menu_bar).
        attr(menu_bar_restart, label, "Restart").
        attr(menu_bar_restart, icon, "fa-arrows-rotate").
        attr(menu_bar_restart, class, "btn-outline-danger").
        attr(menu_bar_restart, class, "border-0").
        when(menu_bar_restart, click, call, restart).

        elem(menu_bar_clear, button, menu_bar).
        attr(menu_bar_clear, label, "Clear").
        attr(menu_bar_clear, icon, "fa-trash").
        attr(menu_bar_clear, class, "btn-outline-danger").
        attr(menu_bar_clear, class, "border-0").
        when(menu_bar_clear, click, call, clear_assumptions).


        elem(menu_bar_download, button, menu_bar).
        attr(menu_bar_download, label, "Download").
        attr(menu_bar_download, icon, "fa-download").
        when(menu_bar_download, click, call, download("#show . #show include(I) : include(I), type(I,T), part(T).#show value(X,V) : value(X,V), type(X,T), integer(T). #show value(X,V) : value(X,V), type(X,T), discrete(T).", "coom_solution.lp")).


        elem(menu_bar_select, button, menu_bar).
        attr(menu_bar_select, label, "Select solution").
        attr(menu_bar_select, icon, "fa-hand-pointer").
        when(menu_bar_select, click, call, select("#show . #show include(I) : include(I), type(I,T), part(T). #show value(X,V) : value(X,V), type(X,T), integer(T). #show value(X,V) : value(X,V), type(X,T), discrete(T).")).

        elem(menu_bar_next, button, menu_bar).
        attr(menu_bar_next, label, "Next").
        attr(menu_bar_next, icon, "fa-forward-step").
        when(menu_bar_next, click, call, next_solution).
