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

% ----------- FEATURES
% ----- Parts (COOM Structures)
included_part("root").
included_part(I) :- _all(include(I)), type(I,T), part(T).
included_part(I) :- include(I), type(I,T), part(T), _clinguin_browsing.
included_part_by_assumption(I) :- included_part(I), _clinguin_assume(include(I),true), I!="root".
possibly_included_part(I) :- _any(include(I)), type(I,T), part(T), not included_part(I).
has_larger_part(I) :- included_part(I), included_part(I'), set(P,I), set(P,I'), I'>I.

% ----- Attributes (Enumerations and Numeric Features Attributes of enumerations)
attr_type(I,discrete) :- type(I,T), discrete(T).
attr_type(I,integer)  :- type(I,T), integer(T).
included_attr(I,AT)   :-  attr_type(I, AT),  _all(include(I)).
included_attr(I,AT)   :-  attr_type(I, AT),  include(I), _clinguin_browsing.
discrete_main_attr(I) :-included_attr(I,discrete), parent(I,P), included_part(P). %To treat differently the discrete sub-attributes

% ----- Values
included_value(I,V) :- included_attr(I,_), _all(value(I,V)).
included_value(I,V) :- included_attr(I,_), value(I,V), _clinguin_browsing.
% included_value_by_assumption(I):- included_value(I,V), _clinguin_assume(value(I,V),true).



% ============ UI

% Window
elem(window, window, root).

% Main container for root part, other parts are added below recursively
elem(part_container("root"), container, window).


    % +++++++ TITLE

    elem(part_title(I), container, part_container((I)))             :- included_part(I).
    attr(part_title(I), order, 1)                                   :- included_part(I).
    attr(part_title(I), class, ("d-inline-flex";"flex-row";"px-3")) :- included_part(I).

        % Title label name
        elem(part_title_l(I), label, part_title(I)) :- included_part(I).
        attr(part_title_l(I), label,@name(I))       :- included_part(I).
        attr(part_title_l(I), class, ("h4"))        :- included_part(I).
        attr(part_title_l(I), order, 1)             :- included_part(I).

        % Title label type
        elem(part_title_t(I), label, part_title(I))               :- included_part(I).
        attr(part_title_t(I), label,  @format("({0})",T))         :- included_part(I), type(I,T).
        attr(part_title_t(I), class, ("px-1";"m-1";"fw-lighter")) :- included_part(I).
        attr(part_title_t(I), order, 2)                           :- included_part(I).

        % Title container to remove the part
        elem(part_title_bc(I), container, part_title(I)) :- included_part(I).
        attr(part_title_bc(I), class,  ("ms-auto"))      :- included_part(I).
        attr(part_title_bc(I), order,  3)                :- included_part(I).

            % Title button to remove the part
            elem(part_title_b(I), button, part_title_bc(I))                    :- included_part(I).
            attr(part_title_b(I), icon,  "fa-trash")                           :- included_part(I).
            attr(part_title_b(I), class,  ("border-0"))                        :- included_part(I).
            attr(part_title_b(I), class,  ("btn-outline-danger";"border-0"))   :- included_part_by_assumption(I), not has_larger_part(I).
            attr(part_title_b(I), class,  ("btn-outline-info";"disabled"))     :- included_part(I), not included_part_by_assumption(I).
            attr(part_title_b(I), tooltip,  "Can't remove inferred object")    :- included_part(I), not included_part_by_assumption(I).
            attr(part_title_b(I), class,  ("btn-outline-info";"disabled"))     :- included_part(I), has_larger_part(I).
            attr(part_title_b(I), tooltip, @format("Remove other {} first",T)) :- included_part(I), type(I,T), has_larger_part(I).
            % Recursive removal of parts, attributes and enumerations
            child_remove(I,I)   :- included_part_by_assumption(I), not has_larger_part(I).
            child_remove(I,I'') :- child_remove(I, I'), parent(I'',I').
            child_assumption(I,include(I'))                                     :- child_remove(I,I').
            child_assumption(I,value(I',any))                                   :- child_remove(I,I'), included_attr(I',_).
            when(part_title_b(I), click,  call, remove_assumption_signature(A)) :- child_remove(I,I), child_assumption(I, A).

    % +++++++ Parts

    %  Container for all sub-parts
    elem(parts_container(I), container, part_container(I))        :- included_part(I).
    attr(parts_container(I), order, 5)                            :- included_part(I).
    attr(parts_container(I), class, ("d-inline-flex";"flex-col")) :- included_part(I).

        % Container per part
        elem(part_container(I), container, parts_container(P))                                :- included_part(I), parent(I,P).
        attr(part_container(I), class, ("m-3";"p-3"))                                         :- included_part(I).
        attr(part_container(I), width, ("95%"))                                               :- included_part(I).
        attr(part_container(I), class, ("shadow"))                                            :- included_part(I).
        attr(part_container(I), class, ("bg-info";"bg-opacity-10"))                           :- included_part(I).
        attr(part_container(I), class, ("bd-highlight";"d-inline-flex";"flex-col";"rounded")) :- included_part(I).
        attr(part_container(I), class, ("border";"border-dark";"border-1"))                   :- included_part(I).
        % attr(part_container(I), "border-style", "dotted") :- included_part(I), _clinguin_browsing, not _all(include(I)).

            % Containier for button to add a new part
            elem(possible_parts(I), container, part_container(I))               :- included_part(I).
            attr(possible_parts(I), order, 4)                                   :- included_part(I).
            attr(possible_parts(I), class, ("mx-2";"d-inline-flex";"flex-row")) :- included_part(I).

                % One container per part type to include
                elem(possible_part(I), container, possible_parts(P)) :- possibly_included_part(I), parent(I,P), #false: possibly_included_part(I'), set(X,I), set(X,I'), I'<I.

                    elem(possible_part_b(I), button, possible_part(I))                :- elem(possible_part(I),_,_).
                    attr(possible_part_b(I), label, @name(I))                         :- elem(possible_part(I),_,_).
                    attr(possible_part_b(I), icon, "fa-circle-plus")                  :- elem(possible_part(I),_,_).
                    attr(possible_part_b(I), class, ("btn-outline-dark";"border-0"))  :- elem(possible_part(I),_,_).
                    when(possible_part_b(I), click, call, add_assumption(include(I))) :- elem(possible_part(I),_,_).

    % +++++++ ENUMERATIONS AND ATTRIBUTES

    %  Part container for all its attributes
    elem(attrs_container(I), container, part_container(I))                            :- included_part(I).
    attr(attrs_container(I), order, 2)                                                :- included_part(I).
    attr(attrs_container(I), heigth, 50)                                              :- included_part(I).
    attr(attrs_container(I), class, ("align-items-start";"d-inline-flex";"flex-row")) :- included_part(I).

        % Part container for Numeric Enumerations
        elem(num_attrs_container(I), container, attrs_container(I))                           :- included_part(I).
        attr(num_attrs_container(I), order, 1)                                                :- included_part(I).
        attr(num_attrs_container(I), heigth, 50)                                              :- included_part(I).
        attr(num_attrs_container(I), class, ("align-items-start";"d-inline-flex";"flex-col")) :- included_part(I).

        %  Part container for all discrete attributes
        elem(dis_attrs_container(I), container, attrs_container(I))                           :- included_part(I).
        attr(dis_attrs_container(I), order, 2)                                                :- included_part(I).
        attr(dis_attrs_container(I), heigth, 50)                                              :- included_part(I).
        attr(dis_attrs_container(I), class, ("align-items-start";"d-inline-flex";"flex-row")) :- included_part(I).


            % Container per discrete attribute
            % If we want to make it general then this should alsobe work if the parent is an attribute
            elem(discrete_container(I), container, dis_attrs_container(P))       :- discrete_main_attr(I), parent(I,P).
            attr(discrete_container(I), class, ("mx-3";"my-1";"px-2";"rounded")) :- discrete_main_attr(I).
            attr(discrete_container(I), class, ("d-inline-flex";"flex-col"))     :- discrete_main_attr(I).
            attr(discrete_container(I), class, ("bg-secondary";"bg-opacity-10")) :- discrete_main_attr(I).
            attr(discrete_container(I), order, N) :- discrete_main_attr(I), #count{I':discrete_main_attr(I'), I'>I}=N.


                elem(discrete_main_attr(I), container, discrete_container(I)) :- elem(discrete_container(I),_,_).
                attr(discrete_main_attr(I), order, 1)                         :- elem(discrete_container(I),_,_).
                elem(discrete_sub_attr(I), container, discrete_container(I))  :- elem(discrete_container(I),_,_).
                attr(discrete_sub_attr(I), order, 2)                          :- elem(discrete_container(I),_,_).


                % Container for title and options of enumerations and attributes
                elem(attr_value(I), container, discrete_sub_attr(P))   :- included_attr(I,_), parent(I,P), included_attr(P,discrete).
                elem(attr_value(I), container, discrete_main_attr(I))  :- included_attr(I,discrete), parent(I,P), included_part(P).
                elem(attr_value(I), container, num_attrs_container(P)) :- included_attr(I,integer), parent(I,P), included_part(P).
                attr(attr_value(I), class, ("d-inline-flex";"flex-row";"justify-content-between")) :- included_attr(I,_).

                    % Title for dropdown
                    elem(attr_value_title(I), container, attr_value(I))            :- included_attr(I,_).
                    attr(attr_value_title(I), class, ("d-inline-flex";"flex-row")) :- included_attr(I,_).
                    attr(attr_value_title(I), width, 190)                          :- included_attr(I,_).

                        elem(attr_value_l(I), label, attr_value_title(I)) :- included_attr(I,_).
                        attr(attr_value_l(I), label, @name(I))            :- included_attr(I,_).
                        attr(attr_value_l(I), order, 1)                   :- included_attr(I,_).
                        attr(attr_value_l(I), class, ("fst-italic"))      :- included_attr(I,_).
                        attr(attr_value_l(I), class, ("h6";"fw-medium"))  :- discrete_main_attr(I).
                        attr(attr_value_l(I), class, ("h7";"px-4";"fst-italic";"fw-light")) :- included_attr(I,_), not discrete_main_attr(I).

                        % Added type to title only for discrete enumerations
                        elem(attr_value_t(I), label, attr_value_title(I))           :- discrete_main_attr(I).
                        attr(attr_value_t(I), label, @format("({0})",T))            :- discrete_main_attr(I), type(I,T).
                        attr(attr_value_t(I), class, ("px-1";"fw-lighter";"small")) :- discrete_main_attr(I).
                        attr(attr_value_t(I), order, 2)                             :- discrete_main_attr(I).

                    % Container with dropdown
                    elem(attr_value_title_o(I), container, attr_value(I)) :- included_attr(I,_).
                    attr(attr_value_title_o(I), order, 3)                 :- included_attr(I,_).
                    attr(attr_value_title_o(I), class, "p-1")             :- included_attr(I,_).

                        elem(attr_value_title_o_dd(I), dropdown_menu, attr_value_title_o(I)) :- included_attr(I,_).
                        attr(attr_value_title_o_dd(I), selected, V)                          :- included_value(I,V).
                        % attr(attr_value_title_o_dd(I), selected, V) :- included_value(I,V), _clinguin_browsing.


                        % attr(attr_value_title_o_dd(I), class, ("fw-bold")) :- included_attr(I,_), value(I,V), _clinguin_browsing, not _all(value(I,V)).
                        % attr(attr_value_title_o_dd(I), class, ("opacity-50")) :- included_value(I,V), not _clinguin_browsing.
                        % attr(attr_value_title_o_dd(I), class, ("btn-secondary")) :- discrete_main_attr(I), not included_value(I,_).
                        % attr(attr_value_title_o_dd(I), class, ("btn-primary")) :- included_attr(I,_), not discrete_main_attr(I),  not included_value(I,_).
                        % attr(attr_value_title_o_dd(I), class, ("border-0";"btn-outline-secondary")) :- discrete_main_attr(I), included_value(I,_).
                        % attr(attr_value_title_o_dd(I), class, ("border-0";"btn-outline-primary")) :- not discrete_main_attr(I),  included_value(I,_).
                        % attr(attr_value_title_o_dd(I), class, ("btn-danger")) :- _clinguin_mus(value(I,V)).


                        attr(attr_value_title_o_dd(I), class, ("disabled")) :- included_attr(I,_), _clinguin_browsing.
                        attr(attr_value_title_o_dd(I), class, ("fw-bold"))  :- included_attr(I,_), _clinguin_browsing, not _all(value(I,_)).
                        attr(attr_value_title_o_dd(I), class, ("fw-light";"opacity-50")) :- included_value(I,V), _all(value(I,V)),not _clinguin_assume(value(I,V),true).
                        attr(attr_value_title_o_dd(I), class, ("btn-secondary")) :- included_attr(I,discrete), not included_value(I,_).
                        attr(attr_value_title_o_dd(I), class, ("btn-secondary")) :- included_attr(I,discrete), _clinguin_assume(value(I,_),true).
                        attr(attr_value_title_o_dd(I), class, ("btn-primary")) :- included_attr(I,integer),  not included_value(I,_).
                        attr(attr_value_title_o_dd(I), class, ("btn-primary")) :- included_attr(I,integer), _clinguin_assume(value(I,_),true).
                        attr(attr_value_title_o_dd(I), class, ("border-0";"btn-outline-secondary")) :- included_attr(I,discrete), included_value(I,_), not _clinguin_assume(value(I,_),true).
                        attr(attr_value_title_o_dd(I), class, ("border-0";"btn-outline-primary"))  :- included_attr(I,integer),  included_value(I,_), not _clinguin_assume(value(I,_),true).
                        attr(attr_value_title_o_dd(I), class, ("btn-danger")) :- _clinguin_mus(value(I,V)).




                            option((I,V),invalid):- included_attr(I,_), domain(T,V), type(I,T), not _any(value(I,V)).
                            option((I,V),valid):- included_attr(I,_), _any(value(I,V)), not _clinguin_assume(value(I,_),true).

                            elem(attr_value_title_o_ddi(I,V), dropdown_menu_item, attr_value_title_o_dd(I)) :- option((I,V),_).
                            attr(attr_value_title_o_ddi(I,V), label, V) :- option((I,V),_).
                            when(attr_value_title_o_ddi(I,V), click, call, add_assumption(value(I,V))) :- option((I,V),_).
                            attr(attr_value_title_o_ddi(I,V), class, ("text-danger")) :- option((I,V),invalid).

                            elem(attr_value_title_o_ddi(I,remove), dropdown_menu_item, attr_value_title_o_dd(I)) :- included_attr(I,_).
                            attr(attr_value_title_o_ddi(I,remove), icon, "fa-ban") :- included_attr(I,_).
                            attr(attr_value_title_o_ddi(I,remove), class, "text-info") :- included_attr(I,_).
                            when(attr_value_title_o_ddi(I,remove), click, call, remove_assumption_signature(value(I,any))) :- included_attr(I,_).





    % +++++++ Messages for explanation
    elem(message_unsat(C),message,window)      :- _clinguin_mus(constraint(C,("boolean";"table"))).
    attr(message_unsat(C),title,"Explanation") :- _clinguin_mus(constraint(C,("boolean";"table"))).
    attr(message_unsat(C),type,"error")        :- _clinguin_mus(constraint(C,("boolean";"table"))).
    attr(message_unsat(C),message,M)           :- _clinguin_mus(constraint(C,("boolean";"table"))) , explanation(I,M), C=(I,_).

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

        % elem(menu_bar_clear, button, menu_bar).
        % attr(menu_bar_clear, label, "Clear").
        % attr(menu_bar_clear, icon, "fa-trash").
        % attr(menu_bar_clear, class, "btn-outline-danger").
        % attr(menu_bar_clear, class, "border-0").
        % when(menu_bar_clear, click, call, clear_assumptions).


        elem(menu_bar_download, button, menu_bar).
        attr(menu_bar_download, label, "Download").
        attr(menu_bar_download, icon, "fa-download").
        when(menu_bar_download, click, call, download("#show . #show include(I) : include(I), type(I,T), part(T).#show value(X,V) : value(X,V), type(X,T), integer(T). #show value(X,V) : value(X,V), type(X,T), discrete(T).", "coom_solution.lp")).


        elem(menu_bar_select, button, menu_bar).
        attr(menu_bar_select, label, "Pick current solution").
        attr(menu_bar_select, icon, "fa-hand-pointer").
        when(menu_bar_select, click, call, select("#show . #show include(I) : include(I), type(I,T), part(T). #show value(X,V) : value(X,V), type(X,T), integer(T). #show value(X,V) : value(X,V), type(X,T), discrete(T).")).

        elem(menu_bar_next, button, menu_bar).
        attr(menu_bar_next, label, "Find next solution").
        attr(menu_bar_next, icon, "fa-forward-step").
        when(menu_bar_next, click, call, next_solution).
