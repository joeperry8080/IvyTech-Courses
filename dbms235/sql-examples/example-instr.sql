/*
instr example 1:
    start from position 1
    search for "Tech" and return position the word starts
    INSTR([column or 'data to search'],'[pattern]',position,occurance)
    
    position = where to start looking
    occurance = if more than one occurance of word, which one to choose?
*/    
SELECT 
    INSTR('Ivy Tech Community College School of Information Technology','Tech', 1, 1) "Instring"
FROM DUAL;

/*
instr example 2:
    start from position 1
    search for second occurance of "Tech" and return position the word starts
    INSTR('[data to search]','[pattern]',position,occurance)
*/ 
SELECT 
    INSTR('Ivy Tech Community College School of Information Technology','Tech', 1, 2) "Instring"
FROM DUAL;
     
/*
further reading:
https://docs.oracle.com/en/database/oracle/oracle-database/21/sqlrf/INSTR.html#GUID-47E3A7C4-ED72-458D-A1FA-25A9AD3BE113
*/