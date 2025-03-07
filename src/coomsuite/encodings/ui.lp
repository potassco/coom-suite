% TODO: FIx recursive removal of attributes when removing object
#script(python)
from clingo.symbol import Function
def name(a):
    name = str(a).split(".")[-1].split("[")[0]
    return Function(name, [])
#end.

% Auxiliaries
% sinstance(I):-_all(instance(I,S)), structure(S).
sinstance(I):-_all(include(I)), type(I,T), part(T).
sinstance(I):-include(I), type(I,T), part(T), _clinguin_browsing.
sinstance("root"):-_all(type(I,T)).
% sinstance(I):-instance(I,S), structure(S), _clinguin_browsing.
assumed_sinstance(I):- sinstance(I), _clinguin_assume(include(I),true), I!="root".
% TODO are enumerations optional?
einstance(I):-_all(include(I)), type(I,T), discrete(T), sinstance(P), parent(I,P).
einstance(I):-_all(include(I)), type(I,T), integer(T), sinstance(P), parent(I,P).
einstance(I):-include(I), type(I,T), discrete(T), sinstance(P), parent(I,P),_clinguin_browsing.
einstance(I):-include(I), type(I,T), integer(T), sinstance(P), parent(I,P),_clinguin_browsing.
% einstance(I):-instance(I,E), enumeration(E), _clinguin_browsing.
ainstance(I):-einstance(P),  _all(include(I)), parent(I,P).
ainstance(I):-einstance(P),  include(I), parent(I,P), _clinguin_browsing.
% ainstance(I):-instance(I,N), not enumeration(N), not  structure(N), _clinguin_browsing.
eainstance(I):-einstance(I).
eainstance(I):-ainstance(I).
pos_sinstance(I):-_any(include(I)), type(I,T), part(T), not sinstance(I).

% cons(I,(C,N)):-_all(constraint(I,(C,N))).

% FOR THIS WOULD NEED TO USE SET
% single_instance((I,(I',0))):-sinstance((I,(I',0))), not sinstance((I,(I',1))).
has_larger_instance(I):-sinstance(I), sinstance(I'), set(P,I), set(P,I'), I'>I.

% sub_type(I,(I',(I,C))):-_all(instance(I,_)), _all(instance((I',(I,C)),_)).
%             sub_type(I,I''):- sub_type(I,I'), sub_type(I',I'').
%             sub_type(I,I):- _all(instance(I,_)).

% For debugging
% attr(E,class,("border-1";"border";"border-dark")):- elem(E, container, _).

% Window
elem(window, window, root).

% Container per structre instance
elem(icontainer("root"), container, window):-sinstance(I).
% elem(icontainer((I)), container, w):-sinstance(I).
% attr(icontainer((I)), class, ("border")):-sinstance(I).

    % Title
    elem(ititle(I), container, icontainer((I))) :- sinstance(I).
    attr(ititle(I), order, 1) :- sinstance(I).
    attr(ititle(I), class, ("d-inline-flex";"flex-row";"p-3")) :- sinstance(I).

        elem(ititle_l(I), label, ititle(I)) :- sinstance(I).
        attr(ititle_l(I), label,@name(I)) :- sinstance(I).
        % attr(ititle_l((F,(P,C))), label,@concat("",F," [",C,"]")) :- sinstance((F,(P,C))), instance((F,(P,C)),S), not single_instance((F,(P,C))).
    %     attr(ititle_l((F,(P,C))), label,F) :- sinstance((F,(P,C))), instance((F,(P,C)),S), single_instance((F,(P,C))).
        attr(ititle_l(I), class, ("h4")) :- sinstance(I).
        attr(ititle_l(I), order, 1) :- sinstance(I).

        elem(ititle_t(I), label, ititle(I)) :- sinstance(I).
        attr(ititle_t(I), label,  @format("({0})",T)) :- sinstance(I), type(I,T).
        attr(ititle_t(I), class, ("px-1";"m-1";"fw-lighter")) :- sinstance(I).
        attr(ititle_t(I), order, 2) :- sinstance(I).


        elem(ititle_bc(I), container, ititle(I)) :- sinstance(I).
        attr(ititle_bc(I), class,  ("ms-auto")) :- sinstance(I).
        attr(ititle_bc(I), order,  3) :- sinstance(I).
            %Remove
            elem(ititle_b(I), button, ititle_bc(I)) :- sinstance(I).
            attr(ititle_b(I), icon,  "fa-trash") :- sinstance(I).
            attr(ititle_b(I), class,  ("border-0")) :- sinstance(I).
            attr(ititle_b(I), class,  ("btn-outline-danger";"border-0")) :- assumed_sinstance(I), not has_larger_instance(I).
            attr(ititle_b(I), class,  ("btn-outline-info";"disabled")) :- sinstance(I), not assumed_sinstance(I).
            attr(ititle_b(I), tooltip,  "Can't remove inferred object") :- sinstance(I), not assumed_sinstance(I).
            attr(ititle_b(I), class,  ("btn-outline-info";"disabled")) :- sinstance(I), has_larger_instance(I).
            attr(ititle_b(I), tooltip, @format("Remove other {} first",T)) :- type(I,T), sinstance(I), has_larger_instance(I).

            child_remove(I,I):-assumed_sinstance(I),not has_larger_instance(I).
            child_remove(I,I''):-child_remove(I, I'),parent(I'',I').

            child_assumption(I,include(I')):-child_remove(I,I').
            child_assumption(I,value(I',any)):-child_remove(I,I'), eainstance(I').

            when(ititle_b(I), click,  call, remove_assumption_signature(A)) :- child_remove(I,I), child_assumption(I, A).

            % when(ititle_b(I), click,  call, remove_assumption(include(I))) :- assumed_sinstance(I), not has_larger_instance(I).
            % when(ititle_b(I), click,  call, remove_assumption_signature(value(I',any))) :- assumed_sinstance(I), not has_larger_instance(I), parent(I',I), eainstance(I').
            % when(ititle_b(I), click,  call, remove_assumption_signature(value(I',any))) :- assumed_sinstance(I), not has_larger_instance(I), parent(E,I),parent(I',E), einstance(E), ainstance(I').
            % % Remove sub instance
            % when(ititle_b(I), click,  call, remove_assumption(include(I'))) :- assumed_sinstance(I), parent(I',I), sinstance(I').


    % % Enumerations
    elem(ienumerations(I), container, icontainer(I)) :- sinstance(I).
    attr(ienumerations(I), order, 2) :- sinstance(I).
    attr(ienumerations(I), heigth, 50) :- sinstance(I).
    attr(ienumerations(I), class, ("align-items-start";"d-inline-flex";"flex-row")) :- sinstance(I).
    % attr(ienumerations(I), class, ("m-3")) :- einstance(I), parent(I,P).

        %  Discrete enumerations
        elem(idenumerations(I), container, ienumerations(I)) :- sinstance(I).
        attr(idenumerations(I), order, 2) :- sinstance(I).
        attr(idenumerations(I), heigth, 50) :- sinstance(I).
        attr(idenumerations(I), class, ("align-items-start";"d-inline-flex";"flex-row")) :- sinstance(I).

        % % Numeric Enumerations
        elem(inenumerations(I), container, ienumerations(I)) :- sinstance(I).
        attr(inenumerations(I), order, 1) :- sinstance(I).
        attr(inenumerations(I), heigth, 50) :- sinstance(I).
        attr(inenumerations(I), class, ("align-items-start";"d-inline-flex";"flex-col")) :- sinstance(I).

            % Container per enumeration instance
            elem(eicontainer(I), container, idenumerations(P)) :- einstance(I), parent(I,P), type(I,T), discrete(T).
            elem(eicontainer(I), container, inenumerations(P)) :- einstance(I), parent(I,P), type(I,T), integer(T).
            attr(eicontainer(I), class, ("mx-3";"my-1";"px-2";"rounded")) :- einstance(I).
            % attr(eicontainer(I), class, ("px-3";"pr-2")) :- einstance(I).
            attr(eicontainer(I), class, ("d-inline-flex";"flex-col")) :- einstance(I).
            attr(eicontainer(I), class, ("bg-secondary";"bg-opacity-10")) :- einstance(I), type(I,T), discrete(T).
            % attr(eicontainer(I), class, ("bg-warning";"bg-opacity-25")) :- einstance(I), type(I,T), integer(T).
            % attr(eicontainer(I), class, "w-25") :- einstance(I).
            % attr(eicontainer(I), background_color, "#D9D4F0") :- einstance(I).
            attr(eicontainer(I), order, N) :- einstance(I), #count{I':einstance(I'), I'>I}=N.


                % Container per enumeration for the title and one for each attribute
                elem(eititle(I), container, eicontainer(E)) :- ainstance(I), parent(I,E).
                elem(eititle(I), container, eicontainer(I)) :- einstance(I).
                attr(eititle(I), order, 1) :- einstance(I).
                attr(eititle(I), order, 2) :- ainstance(I).
                attr(eititle(I), class, ("d-inline-flex";"flex-row";"justify-content-between")) :- eainstance(I).
                % attr(eititle(I), class, ("align-self-end")) :- einstance(I).

                    elem(eititle_n(I), container, eititle(I)) :- eainstance(I).
                    attr(eititle_n(I), class, ("d-inline-flex";"flex-row")) :- eainstance(I).
                    attr(eititle_n(I), width, 200) :- eainstance(I).

                        elem(eititle_l(I), label, eititle_n(I)) :- eainstance(I).
                        attr(eititle_l(I), label, @name(I)) :- eainstance(I).
                        attr(eititle_l(I), class, "h6") :- einstance(I).
                        attr(eititle_l(I), class, "h7") :- ainstance(I).
                        attr(eititle_l(I), class, ("fst-italic";"fw-medium")) :- einstance(I), type(I,T), discrete(T).
                        attr(eititle_l(I), class, ("px-4";"fst-italic";"fw-light")) :- ainstance(I).
                        attr(eititle_l(I), class, ("fst-italic";"fw-light")) :- einstance(I), type(I,T), integer(T).
                        attr(eititle_l(I), order, 1) :- eainstance(I).

                        elem(eititle_t(I), label, eititle_n(I)) :- einstance(I),type(I,T), discrete(T).
                        attr(eititle_t(I), label, @format("({0})",T)) :- einstance(I), type(I,T), discrete(T).
                        attr(eititle_t(I), class, ("px-1";"fw-lighter";"small")) :- einstance(I),type(I,T), discrete(T).
                        attr(eititle_t(I), order, 2) :- einstance(I),type(I,T), discrete(T).


                    elem(eioption(I), container, eititle(I)) :- eainstance(I).
                    attr(eioption(I), order, 3) :- eainstance(I).
                    attr(eioption(I), class, "p-1") :- eainstance(I).

                        elem(eioption_dd(I), dropdown_menu, eioption(I)) :- eainstance(I).
                        attr(eioption_dd(I), selected, V) :- eainstance(I), _all(value(I,V)), not _clinguin_browsing.
                        attr(eioption_dd(I), selected, V) :- eainstance(I), value(I,V), _clinguin_browsing.
                        % attr(eioption_dd(I), selected, V) :- _clinguin_mus(value(I,V)).
                        % attr(eioption_dd(I), class, ("opacity-75";"btn-outline-dark")) :- eainstance(I), _all(value(I,V)), not _clinguin_assume(value(I,V),true), _any(value(I,V')), V'!=V.

                        inferred_value(I,V):-eainstance(I), _all(value(I,V)), not _clinguin_assume(value(I,V),true).
                        inferred_value(I,V):-eainstance(I), value(I,V), _clinguin_browsing.
                        attr(eioption_dd(I), class, ("fw-bold")) :- eainstance(I), value(I,V), _clinguin_browsing, not _all(value(I,V)).
                        attr(eioption_dd(I), class, ("opacity-50")) :- inferred_value(I,V), not _clinguin_browsing.
                        attr(eioption_dd(I), class, ("btn-secondary")) :- einstance(I), type(I,T), discrete(T), not inferred_value(I,_).
                        attr(eioption_dd(I), class, ("btn-primary")) :- ainstance(I), type(I,T), not inferred_value(I,_).
                        attr(eioption_dd(I), class, ("btn-primary")) :- eainstance(I), type(I,T), integer(T), not inferred_value(I,_).
                        attr(eioption_dd(I), class, ("border-0";"btn-outline-secondary")) :- einstance(I), type(I,T), discrete(T), inferred_value(I,_).
                        attr(eioption_dd(I), class, ("border-0";"btn-outline-primary")) :- ainstance(I), type(I,T), inferred_value(I,_).
                        attr(eioption_dd(I), class, ("border-0";"btn-outline-primary")) :- eainstance(I), type(I,T), integer(T), inferred_value(I,_).
                        attr(eioption_dd(I), class, ("btn-danger")) :- _clinguin_mus(value(I,V)).

                            option((I,V),invalid):- eainstance(I), domain(T,V), type(I,T), not _any(value(I,V)), not _clinguin_assume(value(I,_),true).
                            option((I,V),valid):- eainstance(I), _any(value(I,V)), not _clinguin_assume(value(I,_),true).

                            elem(eioption_ddi(I,V), dropdown_menu_item, eioption_dd(I)) :- option((I,V),_).
                            attr(eioption_ddi(I,V), label, V) :- option((I,V),_).
                            when(eioption_ddi(I,V), click, call, add_assumption(value(I,V))) :- option((I,V),_).
                            % when(eioption_ddi(I,V), click, call, (remove_assumption_signature(value(I,any)),add_assumption(value(I,V)))) :- option((I,V),_).
                            attr(eioption_ddi(I,V), class, ("text-danger")) :- option((I,V),invalid).

                            elem(eioption_ddi(I,remove), dropdown_menu_item, eioption_dd(I)) :- eainstance(I).
                            attr(eioption_ddi(I,remove), icon, "fa-ban") :- eainstance(I).
                            attr(eioption_ddi(I,remove), class, "text-info") :- eainstance(I).
                            when(eioption_ddi(I,remove), click, call, remove_assumption_signature(value(I,any))) :- eainstance(I).


    % Features
    elem(ifeatures(I), container, icontainer(I)) :- sinstance(I).
    % TODO Alternative as a collapse
    % attr(ifeatures(I), label, "Elements") :- sinstance(I).
    % attr(ifeatures(I), order, 5) :- sinstance(I).
    attr(ifeatures(I), order, 5) :- sinstance(I).
    attr(ifeatures(I), class, ("d-inline-flex";"flex-col")) :- sinstance(I).
    % attr(ifeatures(I), background_color, white) :- sinstance(I).
    % attr(ifeatures(I), class, ("m-3")) :- sinstance(I).

        % Container per structre instance
        elem(icontainer(I), container, ifeatures(P)) :- sinstance(I), parent(I,P).
        % attr(icontainer(I), order, C) :- sinstance(I).
        attr(icontainer(I), class, ("m-3";"p-3")) :- sinstance(I).
        attr(icontainer(I), width, ("85%")) :- sinstance(I).
        % attr(icontainer(I), background_color, "#98B3EA") :- sinstance(I).
        % attr(icontainer(I), background_color, white) :- sinstance(I).

        attr(icontainer(I), class, ("shadow")) :- sinstance(I).
        attr(icontainer(I), class, ("bg-info";"bg-opacity-10")) :- sinstance(I).
        attr(icontainer(I), class, ("bd-highlight";"d-inline-flex";"flex-col";"rounded")) :- sinstance(I).
        attr(icontainer(I), class, ("border";"border-dark";"border-1")) :- sinstance(I).

    % % Add
    elem(iadd(I), container, icontainer(I)) :- sinstance(I).
    attr(iadd(I), order, 4) :- sinstance(I).
    attr(iadd(I), class, ("mx-2";"d-inline-flex";"flex-row")) :- sinstance(I).
    % attr(iadd(I), background_color, white) :- sinstance(I).
    % attr(iadd(I), class, ("m-2")) :- sinstance(I).

        % Container per structre instance
        % elem(iposf((F,(P,C))), container, iadd(P)) :- pos_sinstance((F,(P,C))), sinstance(P), not sinstance((F,(P,C))).
        elem(iposf(I), container, iadd(P)) :- pos_sinstance(I), parent(I,P), not sinstance(I), #false: pos_sinstance(I'), set(X,I), set(X,I'), I'<I.

            elem(iposf_l(I), button, iposf(I)) :- elem(iposf(I),_,_).
            attr(iposf_l(I), label, @name(I)) :- elem(iposf(I),_,_).
            attr(iposf_l(I), icon, "fa-circle-plus") :- elem(iposf(I),_,_).
            % attr(iposf_l(I), class, ("btn-primary";"bg-opacity-50")) :- elem(iposf(I),_,_).
            attr(iposf_l(I), class, ("btn-outline-dark";"border-0")) :- elem(iposf(I),_,_).
            when(iposf_l(I), click, call, add_assumption(include(I))) :- elem(iposf(I),_,_).


        % attr(iposf(I), class, ("m-2";"p-2")) :- sinstance(I).
        % % attr(iposf(I), background_color, "#98B3EA") :- sinstance(I).
        % % attr(iposf(I), background_color, white) :- sinstance(I).
        % attr(iposf(I), class, ("bg-primary";"bg-opacity-10")) :- sinstance(I).
        % attr(iposf(I), class, ("d-inline-flex";"flex-col";"border";"border-dark";"border-2";"rounded")) :- sinstance(I).

    % % Constraints
    % elem(icons(I), container, icontainer(I)) :- sinstance(I).
    % attr(icons(I), order, 3) :- sinstance(I).
    % attr(icons(I), heigth, 50) :- sinstance(I).
    % attr(icons(I), class, ("d-inline-flex";"flex-row")) :- sinstance(I).
    % attr(icons(I), class, ("m-3")) :- sinstance(I), cons(I,C).


    %     elem(icons(I,C), container, icons(I)) :- cons(I,C).
    %     attr(icons(I,C), class, "bg-warning") :- cons(I,C).
    %     attr(icons(I,C), class, ("m-2";"p-2";"rounded")) :- cons(I,C).
    %     attr(icons(I,C), class, ("d-inline-flex";"flex-col";"align-items-start")) :- cons(I,C).
    %     attr(icons(I,C), class, ("bg-warning";"bg-opacity-25")) :- cons(I,C).
    %     attr(icons(I,C), class, ("bg-danger";"bg-opacity-50")) :- cons(I,C), _clinguin_mus(behavior(C)).

    %         % Require Labels
    %         elem(icons_lr(I,C), label, icons(I,C)) :- cons(I,C).
    %         attr(icons_lr(I,C), label, S) :- cons(I,C), require(C, S).
    %         attr(icons_lr(I,C), order, 2) :- cons(I,C), require(C, S).

    %         % Condition Labels
    %         elem(icons_lc(I,C), label, icons(I,C)) :- cons(I,C).
    %         attr(icons_lc(I,C), label, @concat("","if ",S)) :- cons(I,C), condition(C, S).
    %         attr(icons_lc(I,C), class, ("fw-light";"opacity-75")) :- cons(I,C), condition(C, S).
    %         attr(icons_lc(I,C), order, 1) :- cons(I,C), condition(C, S).

    %         % Table Labels
    %         elem(icons_table(I,C), container, icons(I,C)) :- cons(I,C), combinations(C,_,_).
    %         attr(icons_table(I,C), class, ("d-inline-flex";"flex-row")) :- cons(I,C), combinations(C,_,_).

    %             elem(icons_table_col(I,C,Col), container,icons_table(I,C)) :- cons(I,C), combinations(C,Col,_).
    %             attr(icons_table_col(I,C,Col), order, Col) :- cons(I,C), combinations(C,Col,_).
    %             attr(icons_table_col(I,C,Col), class, ("d-inline-flex";"flex-col")) :- cons(I,C), combinations(C,Col,_).

    %                 allow(C,(Col,-1),Name):-cons(I,C), combinations(C,Col,Name).
    %                 elem(icons_table_row(I,C,Col,Row), container,icons_table_col(I,C,Col)) :- cons(I,C), allow(C,(Col,Row),Name).
    %                 attr(icons_table_row(I,C,Col,Row), class,("d-inline-flex";"flex-row")) :- cons(I,C), allow(C,(Col,Row),Name).
    %                 attr(icons_table_row(I,C,Col,Row), order,Row+1) :- cons(I,C), allow(C,(Col,Row),Name).
    %                 attr(icons_table_row(I,C,Col,Row), class,("border";"border-dark";"border-1")) :- cons(I,C), allow(C,(Col,Row),Name).

    %                     % elem(icons_table_cell(I,C,Col,Row), label,icons_table_row(I,C,Col,Row)) :- cons(I,C), allow(C,(Col,Row),Name).
    %                     % attr(icons_table_cell(I,C,Col,Row), label,Name) :- cons(I,C), allow(C,(Col,Row),Name).
    %                     % attr(icons_table_cell(I,C,Col,Row), class,("fw-lighter")) :- cons(I,C), allow(C,(Col,Row),Name), Row>=0.

    %                     elem(icons_table_cell(I,C,Col,Row,Name), label,icons_table_row(I,C,Col,Row)) :- cons(I,C), allow(C,(Col,Row),Name).
    %                     attr(icons_table_cell(I,C,Col,Row,Name), label,Name) :- cons(I,C), allow(C,(Col,Row),Name).
    %                     attr(icons_table_cell(I,C,Col,Row,Name), class,("fw-lighter";"p-1")) :- cons(I,C), allow(C,(Col,Row),Name), Row>=0.


    elem(message_unsat(ID), message, window):-_clinguin_mus(constraint(ID,"boolean")).
    attr(message_unsat(ID), title, "Explanation"):-_clinguin_mus(constraint(ID,"boolean")).
    attr(message_unsat(ID), type, "error"):-_clinguin_mus(constraint(ID,"boolean")).
    attr(message_unsat((I,M)), message, M):-_clinguin_mus(constraint((I,M),"boolean")).

    %%%%%%%%%%%%%%%%%%%%%%%%
    % Menu bar
    %%%%%%%%%%%%%%%%%%%%%%%%

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
