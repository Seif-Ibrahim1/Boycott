:-consult(data).


% 3
getItemsInOrderById(CustName,OrderId,Items) :-
    customer(CustID,CustName),
    order(CustID,OrderId,Items).

% 4
getLength([], 0).
getLength([Begin|End] , Count) :-
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

