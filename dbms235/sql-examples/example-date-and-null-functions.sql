--update existing table values
update invoices 
set invoice_due_date = null 
where invoice_id in (81,114);

select
    invoice_id,
    payment_date, 
    invoice_due_date,
    coalesce(payment_date, 
                invoice_due_date, to_date('01-JAN-1900')) as due_date_2,
    --list date invoice paid or mark unpaid
    nvl(to_char(payment_date), 'Unpaid') as paid_date,
    --payment_date null = unpaid, not null = paid
    nvl2(payment_date, 'Paid', 'Unpaid') as payment_status_desc
from
    invoices
order by
    due_date_2;
    
--set update back to where it was
rollback;