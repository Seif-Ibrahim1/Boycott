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