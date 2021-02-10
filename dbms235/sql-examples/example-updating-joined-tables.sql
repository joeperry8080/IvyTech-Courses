insert into mgs_address_type
values(1,'Billing Address');

insert into mgs_address_type
values(2,'Shipping Address');

update mgs_addresses
set address_type_id = null;

commit;


select
    cust.customer_id,
    cust.email_address,
    cust.last_name,
    cust.first_name,
    bill.address_id as bill_address_id,
    bill.address_type_id as bill_type_addr,
    bill.line1 as bill_line1,
    bill.line2 as bill_line2,
    bill.city as bill_city,
    bill.state as bill_state,
    bill.zip_code as bill_zip,
    ship.address_id as ship_address_id,
    ship.address_type_id as ship_type_addr,
    ship.line1 as ship_line1,
    ship.line2 as ship_line2,
    ship.city as ship_city,
    ship.state as ship_state,
    ship.zip_code as ship_zip_code
from
    mgs_customers cust
    join mgs_addresses ship --shipping address
        on cust.customer_id = ship.customer_id
        and cust.shipping_address_id = ship.address_id
    join mgs_addresses bill --billing address
        on cust.customer_id = bill.customer_id
        and cust.billing_address_id = bill.address_id
where
    -- filter any address that has the same shipping and billing address
    bill.address_id <> ship.address_id;

--update billing addresses
update
    (
	select
    cust.customer_id,
    cust.email_address,
    cust.last_name,
    cust.first_name,
    bill.address_id as bill_address_id,
    bill.address_type_id as bill_type_addr,
    bill.line1 as bill_line1,
    bill.line2 as bill_line2,
    bill.city as bill_city,
    bill.state as bill_state,
    bill.zip_code as bill_zip,
    ship.address_id as ship_address_id,
    ship.address_type_id as ship_type_addr,
    ship.line1 as ship_line1,
    ship.line2 as ship_line2,
    ship.city as ship_city,
    ship.state as ship_state,
    ship.zip_code as ship_zip_code
from
    mgs_customers cust
    join mgs_addresses ship --shipping address
        on cust.customer_id = ship.customer_id
        and cust.shipping_address_id = ship.address_id
    join mgs_addresses bill --billing address
        on cust.customer_id = bill.customer_id
        and cust.billing_address_id = bill.address_id
where
    -- filter any address that has the same shipping and billing address
    ship.address_id <> bill.address_id
	)
set
    bill_type_addr = 1
where
    bill_type_addr is null;
    
--update shipping addresses
update
    (
	select
    cust.customer_id,
    cust.email_address,
    cust.last_name,
    cust.first_name,
    bill.address_id as bill_address_id,
    bill.address_type_id as bill_type_addr,
    bill.line1 as bill_line1,
    bill.line2 as bill_line2,
    bill.city as bill_city,
    bill.state as bill_state,
    bill.zip_code as bill_zip,
    ship.address_id as ship_address_id,
    ship.address_type_id as ship_type_addr,
    ship.line1 as ship_line1,
    ship.line2 as ship_line2,
    ship.city as ship_city,
    ship.state as ship_state,
    ship.zip_code as ship_zip_code
from
    mgs_customers cust
    join mgs_addresses ship --shipping address
        on cust.customer_id = ship.customer_id
        and cust.shipping_address_id = ship.address_id
    join mgs_addresses bill --billing address
        on cust.customer_id = bill.customer_id
        and cust.billing_address_id = bill.address_id
where
    -- filter any address that has the same shipping and billing address
    ship.address_id <> bill.address_id
	)
set
    ship_type_addr = 2
where
    ship_type_addr is null;