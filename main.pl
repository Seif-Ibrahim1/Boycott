:-consult(data).


% 3
getItemsInOrderById(CustName,OrderId,Items) :-
    customer(CustID,CustName),
    order(CustID,OrderId,Items).