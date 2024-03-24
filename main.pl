:-consult(data).


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
    count_items_in_list(L, Count).

count_items_in_list([], 0). 

count_items_in_list([H|T], Count) :-
    count_items_in_list(T, Count1),
    Count is Count1 + 1.

% 3
getItemsInOrderById(CustName,OrderId,Items) :-
    customer(CustID,CustName),
    order(CustID,OrderId,Items). 