:-consult(data). % load the data
:- dynamic item/3. 
:- dynamic alternative/2.
:- dynamic boycott_company/2.

% 1 
% append an item to a list 
append_to_list([], L, L). % base case
append_to_list([H|T], L, [H|R]) :- append_to_list(T, L, R). % recursive case

% check if an item is in a list
list_member(X,[X|_]). % base case
list_member(X,[_|T]) :- list_member(X,T). % recursive case

% helper to get all orders of a customer by ID
get_customer_orders(CustID, L, L2) :-
    order(CustID, OrderID, Items), % get order 
    \+ list_member(order(CustID, OrderID, Items), L), % if the order is not in the list
    append_to_list([order(CustID, OrderID, Items)], L, L1), % add the order
    get_customer_orders(CustID, L1, L2), !. % get the next order

get_customer_orders(_, L, L). % base case

% get all orders of a customer
list_orders(CustName, L) :-
    customer(CustID, CustName), % get customer ID 
    get_customer_orders(CustID, [], L). % call helper to get orders


% 2
% count the number of orders of a customer
countOrdersOfCustomer(CustName,Count) :-
    list_orders(CustName, L), % get all orders in a list
    getLength(L, Count). % get the length of the list


% 3
% get all items in an order by ID
getItemsInOrderById(CustName,OrderId,Items) :-
    customer(CustID,CustName), % get the ID of the customer
    order(CustID,OrderId,Items), !. % get the items in the order

% 4
% get the length of a list
getLength([], 0). % base case
getLength([_|End] , Count) :- % recursive case
    getLength(End ,Length),
    Count is Length + 1.

% get the number of items in an order
getNumOfItems(CustName, OrderId, Count) :-
    getItemsInOrderById(CustName, OrderId, Items), % get the items list
    getLength(Items, Count). %  get the length of the list

% 5
% calculate the price of an order
calcPriceOfOrder(CustName, OrderId, TotalPrice) :-
    getItemsInOrderById(CustName, OrderId, Items), % get the items list
    calcTotalPrice(Items, TotalPrice). % call helper to calculate the total price

% helper to calculate the total price of a list of items
calcTotalPrice([], 0). % base case
calcTotalPrice([Item|Rest], TotalPrice) :-
    item(Item, _, Price), % get the price of the item
    calcTotalPrice(Rest, Remaining), % get the total price of the rest of the items
    TotalPrice is Price + Remaining. % calculate the total price

% 6
% check if an item or its company is boycotted
isBoycott(Name) :-
   boycott_company(Name, _); % if the company is boycotted
   (
     item(Name, Company, _), % get the company of the item
     boycott_company(Company, _) % check if the company is boycotted
   ).

% 7
% get the justification of boycotting an item or its company
whyToBoycott(Name, Justification) :-
item(Name, Company, _) -> boycott_company(Company, Justification) % get the justification of boycotting
;boycott_company(Name, Justification). 

% 8
% remove boycotted items from an order
removeBoycottItemsFromAnOrder(CustName, OrderId, NewList) :-
    getItemsInOrderById(CustName, OrderId, Items), % get the items list
    removeBoycottItems(Items, [], NewList). % call helper to remove boycotted items

% helper to remove boycotted items from a list
removeBoycottItems([], L, L).   % base case
removeBoycottItems([H|T], L, L2) :- % recursive case
    isBoycott(H) -> removeBoycottItems(T, L, L2) ;  % if boycotted remove it
    append_to_list([H], L, L1), removeBoycottItems(T, L1, L2).  % else add it

% 9
% replace boycotted items in an order with their alternatives
replaceBoycottItemsFromAnOrder(UserName, OrderId, NewList) :-
    getItemsInOrderById(UserName, OrderId, Items), % get the items list
    replaceItems(Items, NewList). % call helper to replace boycotted items

% helper to replace boycotted items in a list
replaceItems([], []). % base case
replaceItems([Item|Rest], [NewItem|NewRest]) :-
    (
    isBoycott(Item) -> % if boycotted
        (
        alternative(Item, Alternative) -> % if there is an alternative add it
            NewItem = Alternative 
        ;
            NewItem = none
        )
    ;
        NewItem = Item
    ),
    replaceItems(Rest, NewRest).

% 10
% calculate the price of an order after replacing boycotted items
calcPriceAfterReplacingBoycottItemsFromAnOrder(UserName, OrderId, NewList, TotalPrice) :-
    replaceBoycottItemsFromAnOrder(UserName, OrderId, NewList), % replace boycotted items
    calcTotalPrice(NewList, TotalPrice). % calculate the total price

% 11
% get the difference in price between an item and its alternative
getTheDifferenceInPriceBetweenItemAndAlternative(Item, AltItem, DiffPrice) :-
    item(Item,_,Price1) , % get the price of the item
    alternative(Item, AltItem) , % get the alternative item
    item(AltItem,_,Price2), % get the price of the alternative item
    DiffPrice is Price1 - Price2. % calculate the difference in price

% 12
% add an item to the database
add_item(ItemName, CompanyName, Price) :-
    assert(item(ItemName, CompanyName, Price)). 

% remove an item from the database
remove_item(ItemName, CompanyName, Price) :-
    retract(item(ItemName, CompanyName, Price)).

% add a company to the boycott list
add_boyycott(CompanyName, Justification) :-
    assert(boycott_company(CompanyName, Justification)).

% remove a company from the boycott list
remove_boycott(CompanyName, Justification) :-
    retract(boycott_company(CompanyName, Justification)).

% add an alternative item to an item
add_alternative(Item, AltItem) :-
    assert(alternative(Item, AltItem)).

% remove an alternative item from an item
remove_alternative(Item, AltItem) :-
    retract(alternative(Item, AltItem)).