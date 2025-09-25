create or replace procedure addnewbranch(
		branch_name varchar, 
		city varchar, 
		ifsc_code varchar   
)
language plpgsql    
as $$
begin

    INSERT INTO bankbranches 
		(
			branch_name, 
			city, 
			ifsc_code
		) 
		VALUES
			(branch_name, city, ifsc_code);

    commit;
end;$$;
/*
	call addnewbranch ('Anna Nagar', 'Chennai', 'ICIC0000395')
*/
create or replace procedure transfer(
   sender int,
   receiver int, 
   amount dec
)
language plpgsql    
as $$
begin
    -- subtracting the amount from the sender's account 
    update bankaccounts 
    set balance = balance - amount 
    where account_id = sender;

    -- adding the amount to the receiver's account
    update bankaccounts 
    set balance = balance + amount 
    where account_id = receiver;

    commit;
end;$$;

/*
	call transfer(1, 2, 1000);
*/


