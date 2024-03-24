:-consult(data).
:- dynamic item/3.
:- dynamic alternative/2.
:- dynamic boycott_company/2.

% 1
append_to_list([], L, L).
append_to_list([H|T], L, [H|R]) :- append_to_list(T, L, R).

list_member(X,[X|_]).
list_member(X,[_|TAIL]) :- list_member(X,TAIL).

get_customer_orders(CustID, L, L2) :-
    order(CustID, OrderID, Items),
    \+ list_member(order(CustID, OrderID, Items), L),
    append_to_list([order(CustID, OrderID, Items)], L, L1),
    get_customer_orders(CustID, L1, L2), !.

get_customer_orders(_, L, L).

list_orders(CustName, L) :-
    customer(CustID, CustName),
    get_customer_orders(CustID, [], L).

% 2
countOrdersOfCustomer(CustName,Count) :-
    list_orders(CustName, L),
    getLength(L, Count).

% 3
getItemsInOrderById(CustName,OrderId,Items) :-
    customer(CustID,CustName),
    order(CustID,OrderId,Items), !.

% 4
getLength([], 0).
getLength([_|End] , Count) :-
    getLength(End ,Length),
    Count is Length + 1.

getNumOfItems(CustName, OrderId, Count) :-
    getItemsInOrderById(CustName, OrderId, Items),
    getLength(Items, Count).

% 5
calcPriceOfOrder(CustName, OrderId, TotalPrice) :-
    getItemsInOrderById(CustName, OrderId, Items),
    calcTotalPrice(Items, TotalPrice).

calcTotalPrice([], 0).
calcTotalPrice([Item|Rest], TotalPrice) :-
    item(Item, _, Price),
    calcTotalPrice(Rest, Remaining),
    TotalPrice is Price + Remaining.

% 6
isBoycott(Name) :-
   boycott_company(Name, _);
   (
     item(Name, Company, _),
     boycott_company(Company, _)
   ).

% 7
whyToBoycott(Name, Justification) :-
item(Name, Company, _) -> boycott_company(Company, Justification)
;boycott_company(Name, Justification).

% 8
removeBoycottItemsFromAnOrder(CustName, OrderId, NewList) :-
    getItemsInOrderById(CustName, OrderId, Items),
    removeBoycottItems(Items, [], NewList).

removeBoycottItems([], L, L).  
removeBoycottItems([H|T], L, L2) :-
    isBoycott(H) -> removeBoycottItems(T, L, L2) ; 
    append_to_list([H], L, L1), removeBoycottItems(T, L1, L2).

% 9
replaceBoycottItemsFromAnOrder(UserName, OrderId, NewList) :-
    getItemsInOrderById(UserName, OrderId, Items),
    replaceItems(Items, NewList).

replaceItems([], []).
replaceItems([Item|Rest], [NewItem|NewRest]) :-
    (
    isBoycott(Item) ->
        (
        alternative(Item, Alternative) ->
            NewItem = Alternative
        ;
            NewItem = none
        )
    ;
        NewItem = Item
    ),
    replaceItems(Rest, NewRest).

% 10
calcPriceAfterReplacingBoycottItemsFromAnOrder(UserName, OrderId, NewList, TotalPrice) :-
    replaceBoycottItemsFromAnOrder(UserName, OrderId, NewList),
    calcTotalPrice(NewList, TotalPrice).

% 11
getTheDifferenceInPriceBetweenItemAndAlternative(Item, AltItem, DiffPrice) :-
    item(Item,_,Price1) ,
    alternative(Item, AltItem) ,
    item(AltItem,_,Price2),
    DiffPrice is Price1 - Price2.

% 12
add_item(ItemName, CompanyName, Price) :-
    assert(item(ItemName, CompanyName, Price)).

remove_item(ItemName, CompanyName, Price) :-
    retract(item(ItemName, CompanyName, Price)).

add_boyycott(CompanyName, Justification) :-
    assert(boycott_company(CompanyName, Justification)).

remove_boycott(CompanyName, Justification) :-
    retract(boycott_company(CompanyName, Justification)).

add_alternative(Item, AltItem) :-
    assert(alternative(Item, AltItem)).

remove_alternative(Item, AltItem) :-
    retract(alternative(Item, AltItem)).