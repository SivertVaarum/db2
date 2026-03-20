insert into Prikk(brukerID, grunn)
select brukerID, 'ikke møtt til gruppetime'
from IkkeMøtt
where gruppetimeID = :gruppetimeID
