create or replace procedure transfer(
   sender int,
   receiver int, 
   amount dec
)
language plpgsql    
as $$
begin
    -- subtracting the amount from the sender's account 
    update accounts 
    set balance = balance - amount 
    where id = sender;

    -- adding the amount to the receiver's account
    update accounts 
    set balance = balance + amount 
    where id = receiver;

    commit;
end;$$;


insert into accounts(name, balance)
values('Raju', 10000);
insert into accounts(name, balance)
values('Nikhil', 10000);

CREATE   PROCEDURE get_upper_string(param1_name varying(40))
LANGUAGE plpgsql
AS $$
BEGIN
	SELECT UPPER(param1_name)
END;
$$;


create or replace procedure get_upper(
   param1_name varchar
)
language plpgsql    
as $$
begin
   
	SELECT UPPER(param1_name);
   
   -- commit;
end;$$;



CALL get_upper('dhandapani');