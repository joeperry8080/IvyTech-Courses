--character format samples
select
    to_char(1975.5, '$99,999.00') as sample_currency,
    sysdate as sydate_db_fmt,
    to_char(sysdate, 'DD-MON-YYYY') as sysdate_date_fmt,
    to_char(sysdate, 'HH:MI AM') as sydate_hr_mi,
    to_char(sysdate, 'HH24:MI') as sydate_hr24_mi,
    cast(sysdate as timestamp with local time zone)
from
    dual;