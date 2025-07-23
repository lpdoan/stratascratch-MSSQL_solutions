with sender_info as
(select user_id_sender, date
from fb_friend_requests
where action = 'sent'),

 accepted_receiver_info as
(select user_id_sender, date
from fb_friend_requests
where action = 'accepted'),

-- we will use a left join, because we need all the sender invite dates, and matched records from the accepted receivers, matching on key column user_id_sender
acceptance_dates as (
select s.user_id_sender, s.date as sent_date, r.date as accepted_date
from sender_info s
left join accepted_receiver_info r
on s.user_id_sender = r.user_id_sender)

select *
from acceptance_dates

select sent_date, cast(count(accepted_date) as decimal)  / cast(count(sent_date) as decimal) as acceptance_rate
from acceptance_dates
group by sent_date
