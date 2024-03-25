
% Auxiliaries
sinstance(I):-_all(instance(I,S)), structure(S).
sinstance(I):-instance(I,S), structure(S), _clinguin_browsing.
assumed_sinstance(I):- sinstance(I), _clinguin_assume(instance(I,_)), not instance(I,":root").
einstance(I):-_all(instance(I,E)), enumeration(E).
einstance(I):-instance(I,E), enumeration(E), _clinguin_browsing.
ainstance(I):-_all(instance(I,N)), not enumeration(N), not  structure(N).
ainstance(I):-instance(I,N), not enumeration(N), not  structure(N), _clinguin_browsing.
eorainstance(I):-einstance(I).
eorainstance(I):-ainstance(I).
pos_sinstance(I):-_any(instance(I,S)), structure(S).

cons(I,(C,N)):-_all(constraint(I,(C,N))).

% For debugging
% attr(E,class,("border-1";"border";"border-dark")):- elem(E, container, _).

% Window
elem(w, window, root).

% Container per structre instance
elem(icontainer(()), container, w).

    % Title
    elem(ititle(I), container, icontainer(I)) :- sinstance(I).
    attr(ititle(I), order, 1) :- sinstance(I).
    attr(ititle(I), class, ("d-flex";"flex-row")) :- sinstance(I).
    
        elem(ititle_l(I), label, ititle(I)) :- sinstance(I).
        attr(ititle_l((F,(P,C))), label,F) :- sinstance((F,(P,C))), instance((F,(P,C)),S).
        attr(ititle_l(I), class, ("h4")) :- sinstance(I), instance(I,S).
        attr(ititle_l(I), order, 1) :- sinstance(I), instance(I,S).

        elem(ititle_t(I), label, ititle(I)) :- sinstance(I).
        attr(ititle_t((F,(P,C))), label,  @format("({0})",S)) :- sinstance((F,(P,C))), instance((F,(P,C)),S).
        attr(ititle_t(I), class, ("m-2";"fw-lighter")) :- sinstance(I), instance(I,S).
        attr(ititle_t(I), order, 2) :- sinstance(I), instance(I,S).

        
        elem(ititle_bc(I), container, ititle(I)) :- assumed_sinstance(I).
        attr(ititle_bc((F,(P,C))), class,  ("ms-auto")) :- assumed_sinstance((F,(P,C))), instance((F,(P,C)),S).
        attr(ititle_bc((F,(P,C))), order,  3) :- assumed_sinstance((F,(P,C))), instance((F,(P,C)),S).
            elem(ititle_b(I), button, ititle_bc(I)) :- assumed_sinstance(I).
            attr(ititle_b((F,(P,C))), icon,  "fa-xmark") :- assumed_sinstance((F,(P,C))), instance((F,(P,C)),S).
            when(ititle_b(I), click,  call, remove_assumption(instance(I,S))) :- assumed_sinstance(I), instance(I,S).
            % Remove options
            when(ititle_b(I), click,  call, remove_assumption_signature(val((F,(I,C)),any))) :- assumed_sinstance(I), einstance((F,(I,C))).
            % Remove attr
            when(ititle_b(I), click,  call, remove_assumption_signature(val((F',((F,(I,C)),C')),any))) :- assumed_sinstance(I), einstance((F,(I,C))), ainstance((F',((F,(I,C)),C'))).


    % Enumerations 
    elem(ienumerations(I), container, icontainer(I)) :- sinstance(I).
    attr(ienumerations(I), order, 2) :- sinstance(I).
    attr(ienumerations(I), heigth, 50) :- sinstance(I).
    attr(ienumerations(I), class, ("d-flex";"flex-row")) :- sinstance(I).
    attr(ienumerations(P), class, ("m-3")) :- sinstance(P), einstance((F,(P,C))).

        % Container per enumeration instance
        elem(eicontainer((F,(P,C))), container, ienumerations(P)) :- einstance((F,(P,C))).
        attr(eicontainer(I), class, ("m-2";"p-2";"rounded")) :- einstance(I).
        attr(eicontainer(I), class, ("d-flex";"flex-col")) :- einstance(I).
        attr(eicontainer(I), class, ("bg-secondary";"bg-opacity-25")) :- einstance(I).
        attr(eicontainer(I), background_color, "#D9D4F0") :- einstance(I).
        attr(eicontainer((F,(P,C))), order, N) :- einstance((F,(P,C))), #count{(F',(P,C')):einstance((F',(P,C'))), F'>F}=N.


            % Container per enumeration for the title and one for each attribute
            elem(eititle((F,(P,C))), container, eicontainer(P)) :- ainstance((F,(P,C))).
            elem(eititle(I), container, eicontainer(I)) :- einstance(I).
            attr(eititle(I), order, 1) :- einstance(I).
            attr(eititle(I), order, 2) :- ainstance(I).
            attr(eititle(I), class, ("d-flex";"flex-row")) :- eorainstance(I).
            attr(eititle(I), class, ("align-self-end")) :- ainstance(I).
            
                elem(eititle_l(I), label, eititle(I)) :- eorainstance(I).
                attr(eititle_l((F,(P,C))), label, F) :- eorainstance((F,(P,C))), instance((F,(P,C)),S).
                attr(eititle_l((F,(P,C))), class, "h6") :- einstance((F,(P,C))), instance((F,(P,C)),S).
                attr(eititle_l((F,(P,C))), class, ("fst-italic";"fw-light")) :- ainstance((F,(P,C))), instance((F,(P,C)),S).
                attr(eititle_l((F,(P,C))), order, 1) :- eorainstance((F,(P,C))), instance((F,(P,C)),S).

                elem(eititle_t(I), label, eititle(I)) :- einstance(I).
                attr(eititle_t((F,(P,C))), label, @format("({0})",S)) :- einstance((F,(P,C))), instance((F,(P,C)),S).
                attr(eititle_t((F,(P,C))), class, ("fw-lighter";"small")) :- einstance((F,(P,C))), instance((F,(P,C)),S).
                attr(eititle_t((F,(P,C))), order, 2) :- einstance((F,(P,C))), instance((F,(P,C)),S).
                

                elem(eioption(I), container, eititle(I)) :- eorainstance(I).
                attr(eioption(I), order, 3) :- eorainstance(I).
                
                    elem(eioption_dd(I), dropdown_menu, eioption(I)) :- eorainstance(I).
                    attr(eioption_dd(I), selected, V) :- eorainstance(I), _all(val(I,V)), not _clinguin_browsing.
                    attr(eioption_dd(I), selected, V) :- eorainstance(I), val(I,V), _clinguin_browsing.
                    attr(eioption_dd(I), class, ("opacity-75";"btn-outline-dark")) :- eorainstance(I), _all(val(I,V)), not _clinguin_assume(val(I,V)), _any(val(I,V')), V'!=V.
                    attr(eioption_dd(I), class, ("opacity-50")) :- eorainstance(I), _all(val(I,V)), not _clinguin_assume(val(I,V)), #false: _any(val(I,V')),V'!=V.
                    attr(eioption_dd(I), class, ("btn-danger")) :- _clinguin_muc(val(I,V)).
                    
                        option((I,V),invalid):- einstance(I), option(T,V), instance(I,T), not _any(val(I,V)).
                        option(((A,(I,0)),V),invalid):- ainstance((A,(I,0))), attr_value(T,_,A,V), instance(I,T), not _any(val((A,(I,0)),V)).
                        option((I,V),valid):- eorainstance(I), _any(val(I,V)).

                        elem(eioption_ddi(I,V), dropdown_menu_item, eioption_dd(I)) :- option((I,V),_).
                        attr(eioption_ddi(I,V), label, V) :- option((I,V),_).
                        when(eioption_ddi(I,V), click, call, add_assumption(val(I,V))) :- option((I,V),_).
                        attr(eioption_ddi(I,V), class, ("text-danger")) :- option((I,V),invalid).

                        elem(eioption_ddi(I,remove), dropdown_menu_item, eioption_dd(I)) :- eorainstance(I).
                        attr(eioption_ddi(I,remove), icon, "fa-ban") :- eorainstance(I).
                        attr(eioption_ddi(I,remove), class, "text-info") :- eorainstance(I).
                        when(eioption_ddi(I,remove), click, call, remove_assumption_signature(val(I,any))) :- eorainstance(I).
                

    % Features 
    elem(ifeatures(I), container, icontainer(I)) :- sinstance(I).
    attr(ifeatures(I), order, 5) :- sinstance(I).
    attr(ifeatures(I), class, ("d-flex";"flex-col")) :- sinstance(I).
    % attr(ifeatures(I), background_color, white) :- sinstance(I).
    attr(ifeatures(I), class, ("m-3")) :- sinstance(I), sinstance((F,(I,C))).

        % Container per structre instance
        elem(icontainer((F,(P,C))), container, ifeatures(P)) :- sinstance((F,(P,C))), sinstance(P).
        attr(icontainer(I), class, ("m-2";"p-2")) :- sinstance(I).
        % attr(icontainer(I), background_color, "#98B3EA") :- sinstance(I).
        % attr(icontainer(I), background_color, white) :- sinstance(I).
        attr(icontainer(I), class, ("bg-primary";"bg-opacity-10")) :- sinstance(I).
        attr(icontainer(I), class, ("d-flex";"flex-col";"border";"border-dark";"border-2";"rounded")) :- sinstance(I).

    % Add
    elem(iadd(I), container, icontainer(I)) :- sinstance(I).
    attr(iadd(I), order, 4) :- sinstance(I).
    attr(iadd(I), class, ("d-flex";"flex-row")) :- sinstance(I).
    % attr(iadd(I), background_color, white) :- sinstance(I).
    attr(iadd(I), class, ("m-3")) :- sinstance(I), sinstance((F,(I,C))).

        % Container per structre instance
        % elem(iposf((F,(P,C))), container, iadd(P)) :- pos_sinstance((F,(P,C))), sinstance(P), not sinstance((F,(P,C))).
        elem(iposf((F,(P,C))), container, iadd(P)) :- pos_sinstance((F,(P,C))), sinstance(P), not sinstance((F,(P,C))), #false: pos_sinstance((F,(P,C'))), not sinstance((F,(P,C'))), C'<C.

            elem(iposf_l(I), button, iposf(I)) :- elem(iposf(I),_,_).
            attr(iposf_l((F,(P,C))), label, F) :- elem(iposf((F,(P,C))),_,_).
            attr(iposf_l(I), icon, "fa-add") :- elem(iposf(I),_,_).
            attr(iposf_l(I), class, ("bg-primary";"bg-opacity-50")) :- elem(iposf(I),_,_).
            when(iposf_l(I), click, call, add_assumption(instance(I,S))) :- elem(iposf(I),_,_), _any(instance(I,S)).


        % attr(iposf(I), class, ("m-2";"p-2")) :- sinstance(I).
        % % attr(iposf(I), background_color, "#98B3EA") :- sinstance(I).
        % % attr(iposf(I), background_color, white) :- sinstance(I).
        % attr(iposf(I), class, ("bg-primary";"bg-opacity-10")) :- sinstance(I).
        % attr(iposf(I), class, ("d-flex";"flex-col";"border";"border-dark";"border-2";"rounded")) :- sinstance(I).

    % Constraints 
    elem(icons(I), container, icontainer(I)) :- sinstance(I).
    attr(icons(I), order, 3) :- sinstance(I).
    attr(icons(I), heigth, 50) :- sinstance(I).
    attr(icons(I), class, ("d-flex";"flex-row")) :- sinstance(I).
    attr(icons(I), class, ("m-3")) :- sinstance(I), cons(I,C).


        elem(icons(I,C), container, icons(I)) :- cons(I,C).
        attr(icons(I,C), class, "bg-warning") :- cons(I,C).
        attr(icons(I,C), class, ("m-2";"p-2";"rounded")) :- cons(I,C).
        attr(icons(I,C), class, ("d-flex";"flex-col";"align-items-start")) :- cons(I,C).
        attr(icons(I,C), class, ("bg-warning";"bg-opacity-25")) :- cons(I,C).
        attr(icons(I,C), class, ("bg-danger";"bg-opacity-50")) :- cons(I,C), _clinguin_muc(behavior(C)).
        
            % Require Labels 
            elem(icons_lr(I,C), label, icons(I,C)) :- cons(I,C).
            attr(icons_lr(I,C), label, S) :- cons(I,C), require(C, S).

            % Condition Labels 
            elem(icons_lc(I,C), label, icons(I,C)) :- cons(I,C).
            attr(icons_lc(I,C), label, @concat("if ",S)) :- cons(I,C), condition(C, S).
            attr(icons_lc(I,C), class, ("fw-light";"opacity-75")) :- cons(I,C), condition(C, S).

            % Table Labels 
            elem(icons_table(I,C), container, icons(I,C)) :- cons(I,C), combinations(C,_,_).
            attr(icons_table(I,C), class, ("d-flex";"flex-row")) :- cons(I,C), combinations(C,_,_).
            
                elem(icons_table_col(I,C,Col), container,icons_table(I,C)) :- cons(I,C), combinations(C,Col,_).
                attr(icons_table_col(I,C,Col), order, Col) :- cons(I,C), combinations(C,Col,_).
                attr(icons_table_col(I,C,Col), class, ("d-flex";"flex-col")) :- cons(I,C), combinations(C,Col,_).

                    allow(C,(Col,-1),Name):-cons(I,C), combinations(C,Col,Name).
                    elem(icons_table_cell(I,C,Col,Row), label,icons_table_col(I,C,Col)) :- cons(I,C), allow(C,(Col,Row),Name).
                    attr(icons_table_cell(I,C,Col,Row), label,Name) :- cons(I,C), allow(C,(Col,Row),Name).
                    attr(icons_table_cell(I,C,Col,Row), order,Row+1) :- cons(I,C), allow(C,(Col,Row),Name).
                    attr(icons_table_cell(I,C,Col,Row), class,("border";"border-dark";"border-1")) :- cons(I,C), allow(C,(Col,Row),Name).
                    attr(icons_table_cell(I,C,Col,Row), class,("fw-lighter")) :- cons(I,C), allow(C,(Col,Row),Name), Row>=0.


    %%%%%%%%%%%%%%%%%%%%%%%%
    % Menu bar
    %%%%%%%%%%%%%%%%%%%%%%%%

    elem(menu_bar, menu_bar, w).
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
        when(menu_bar_download, click, call, download("#show .#show instance(I,S) : instance(I,S), structure(S). #show val(X,V) : val(X,V), instance(X,Type), option(Type,_). #show val(X,V) : val(X,V), instance(X,Attr), attr_value(_,_,Attr,_).", "coom_solution.lp")).


        elem(menu_bar_select, button, menu_bar).
        attr(menu_bar_select, label, "Select solution").
        attr(menu_bar_select, icon, "fa-hand-pointer").
        when(menu_bar_select, click, call, select).

        elem(menu_bar_next, button, menu_bar).
        attr(menu_bar_next, label, "Next").
        attr(menu_bar_next, icon, "fa-forward-step").
        when(menu_bar_next, click, call, next_solution).