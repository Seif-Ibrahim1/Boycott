:-consult(data).


% 3
getItemsInOrderById(CustName,OrderId,Items) :-
    customer(CustID,CustName),
    order(CustID,OrderId,Items).

% 4
getLength([], 0).
getLength([_|End] , Count) :-
    getLength(End ,Length),
    Count is Length + 1.

getNumOfItems(CustName, OrderId, Count) :-
    getItemsInOrderById(CustName, OrderId, Items),
    getLength(Items, Count).


% 7
whyToBoycott(Name, Justification) :-
    item(Name, Company, _) -> boycott_company(Company, Justification)
    ;boycott_company(Name, Justification).