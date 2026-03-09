create trigger gyldig_instruktør_update
before update on Gruppetime
for each row
when (
	exists (
		select 1
		from Gruppetime g
		join Aktivitet a1 on g.aktivitet_navn = a1.navn
		join Aktivitet a2 on new.aktivitet_navn = a2.navn	
		where new.tidspunkt < datetime(g.tidspunkt, '+' || a1.lengde_min || ' minutes')
		and g.tidspunkt < datetime(new.tidspunkt, '+' || a2.lengde_min || ' minutes')
		and g.instruktørID = new.instruktørID
		and g.id != old.id
	)	
)
begin
select RAISE(ABORT, 'instruktøren er opptatt');
end;

create trigger gyldig_instruktør_insert
before insert on Gruppetime
for each row
when (
	exists (
		select 1
		from Gruppetime g
		join Aktivitet a1 on g.aktivitet_navn = a1.navn
		join Aktivitet a2 on new.aktivitet_navn = a2.navn	
		where new.tidspunkt < datetime(g.tidspunkt, '+' || a1.lengde_min || ' minutes')
		and g.tidspunkt < datetime(new.tidspunkt, '+' || a2.lengde_min || ' minutes')
		and g.instruktørID = new.instruktørID
	)	
)
begin
select RAISE(ABORT, 'instruktøren er opptatt');
end;

create trigger ingen_pk_endring_booking
before update of gruppetimeID, brukerID on Booking
for each row
begin
select RAISE(ABORT, 'du kan ikke endre brukerID eller gruppetimeID i booking');
end;

create trigger bruker_opptatt
before insert on Booking
for each row
when (
	exists (
		select 1
		from Booking b
		join Gruppetime g1 on b.gruppetimeID = g1.id
		join Gruppetime g2 on new.gruppetimeID = g2.id
		join Aktivitet a1 on g1.aktivitet_navn = a1.navn
		join Aktivitet a2 on g2.aktivitet_navn = a2.navn
		where b.brukerID = new.brukerID
		and b.avmeldt_tidspunkt is null
		and g2.tidspunkt < datetime(g1.tidspunkt, '+' || a1.lengde_min || ' minutes')
		and g1.tidspunkt < datetime(g2.tidspunkt, '+' || a2.lengde_min || ' minutes')
	)
)
begin
select RAISE(ABORT, 'brukeren er opptatt da');
end;

create trigger sen_avmelding_insert
after insert on Booking
for each row
when (
	new.avmeldt_tidspunkt is not null
	and new.avmeldt_tidspunkt > (
	select datetime(tidspunkt, '-1 hour') 
	from Gruppetime 
	where id = new.gruppetimeID 
	)
)
begin
insert into prikk(brukerID, grunn)
select new.brukerID, 'sen avmelding';
end;

create trigger ulovlige_endringer_oppmøte
before update of avmeldt_tidspunkt on Booking
for each row
when (
	old.avmeldt_tidspunkt is not null 
	and new.avmeldt_tidspunkt is not null
)
begin
select RAISE(ABORT, 'avmeldt_tidspunkt må endres til eller fra null');
end;

create trigger sen_avmelding_update
after update of avmeldt_tidspunkt on Booking
for each row
when (
	old.avmeldt_tidspunkt is null
	and
	new.avmeldt_tidspunkt > (
	select datetime(tidspunkt, '-1 hour') 
	from Gruppetime 
	where id = new.gruppetimeID 
	)
)
begin
insert into prikk(brukerID, grunn)
select new.brukerID, 'sen avmelding';
end;

create trigger ingen_oppdatering_deltatt
before update on Deltatt
for each row
begin
select RAISE(ABORT, 'ingen oppdateringer tillatt, slett raden istedenfor');
end;

create trigger sent_oppmøte
after insert on Deltatt
for each row
when (
	new.oppmøtt_tidspunkt > (
	select datetime(tidspunkt, '-5 minutes') 
	from Gruppetime 
	where id = new.gruppetimeID 
	)
)
begin
insert into prikk(brukerID, grunn)
select new.brukerID, 'sent oppmøte';
end;
