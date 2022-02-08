--sample grouping function
select
    case
        when grouping (vendor_state) = 1 then '=========='
        else vendor_state
    end as vendor_state,
    case
        when grouping (vendor_city) = 1 then '=========='
        else vendor_city
    end as vendor_city,
    count(*) as qty_vendors
from
    vendors
where
    vendor_state in ('IA', 'NJ')
group by
    rollup (vendor_state, vendor_city)
order by
    vendor_state desc,
    vendor_city desc;
    
--sample rank and dense_rank
select
    rank() over(order by invoice_total) as rank,
    dense_rank() over(order by invoice_total) as dense_rank,
    invoice_total,
    invoice_number
from    
    invoices;