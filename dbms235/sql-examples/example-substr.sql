/*
substr example 1:
    start from position 5
    include next 5 charactors
*/    
SELECT SUBSTR('Joe Perry Teacher',5,5) "LastName"
     FROM DUAL;
/*
substr example 2:
    start from position 5
    go to end
*/ 
SELECT SUBSTR('Joe Perry',5) "LastName"
     FROM DUAL;
     
/*
substr example 3:
    start from last position and go back 5
    concat a period
*/ 
SELECT SUBSTR('Joe Perry',-5,1) || '.' "LastInitial"
     FROM DUAL;
     
/*
further reading:
https://docs.oracle.com/en/database/oracle/oracle-database/21/sqlrf/SUBSTR.html#GUID-C8A20B57-C647-4649-A379-8651AA97187E
*/