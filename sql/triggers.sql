-- Gruppetime

create trigger gruppetime_kollisjon_update
before update on Gruppetime
for each row
when (
	exists (
		select 1
		from SalOpptatt s
		join Aktivitet a on new.aktivitet_navn = a.navn
		where new.tidspunkt < s.sluttidspunkt
		and s.starttidspunkt < datetime(new.tidspunkt, '+' || a.lengde_min || ' minutes')
		and s.senter_navn = new.senter_navn
		and s.sal_navn = new.sal_navn
		and not ( -- samme rad
			s.starttidspunkt = old.tidspunkt 
			and s.sal_navn = old.sal_navn
			and s.senter_navn = old.senter_navn
		)
	)	
)
begin
select RAISE(ABORT, 'salen er opptatt');
end;

create trigger gruppetime_kollisjon_insert
before insert on Gruppetime
for each row
when (
	exists (
		select 1
		from SalOpptatt s
		join Aktivitet a on new.aktivitet_navn = a.navn
		where new.tidspunkt < s.sluttidspunkt
		and s.starttidspunkt < datetime(new.tidspunkt, '+' || a.lengde_min || ' minutes')
		and s.senter_navn = new.senter_navn
		and s.sal_navn = new.sal_navn
	)	
)
begin
select RAISE(ABORT, 'salen er opptatt');
end;

create trigger gyldig_instruktør_update
before update on Gruppetime
for each row
when (
	exists (
		select 1
		from GruppetimeSlutt g
		join Aktivitet a on new.aktivitet_navn = a.navn	
		where new.tidspunkt < g.sluttidspunkt
		and g.starttidspunkt < datetime(new.tidspunkt, '+' || a.lengde_min || ' minutes')
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
		from GruppetimeSlutt g
		join Aktivitet a on new.aktivitet_navn = a.navn	
		where new.tidspunkt < g.sluttidspunkt
		and g.starttidspunkt < datetime(new.tidspunkt, '+' || a.lengde_min || ' minutes')
		and g.instruktørID = new.instruktørID
	)	
)
begin
select RAISE(ABORT, 'instruktøren er opptatt');
end;

-- Reservasjon
create trigger reservasjon_kollisjon_update
before update on Reservasjon
for each row
when (
	exists (
		select 1
		from SalOpptatt s
		where new.starttidspunkt < s.sluttidspunkt
		and s.starttidspunkt < new.sluttidspunkt
		and s.senter_navn = new.senter_navn
		and s.sal_navn = new.sal_navn
		and not ( -- samme rad
			s.starttidspunkt = old.starttidspunkt 
			and s.sal_navn = old.sal_navn
			and s.senter_navn = old.senter_navn
		)
	)	
)
begin
select RAISE(ABORT, 'salen er opptatt');
end;

create trigger reservasjon_kollisjon_insert
before insert on Reservasjon
for each row
when (
	exists (
		select 1
		from SalOpptatt s
		where new.starttidspunkt < s.sluttidspunkt
		and s.starttidspunkt < new.sluttidspunkt
		and s.senter_navn = new.senter_navn
		and s.sal_navn = new.sal_navn
	)	
)
begin
select RAISE(ABORT, 'salen er opptatt');
end;

-- Booking

create trigger ingen_pk_endring_booking
before update of gruppetimeID, brukerID on Booking
for each row
begin
select RAISE(ABORT, 'du kan ikke endre brukerID eller gruppetimeID i booking');
end;

create trigger bruker_utestengt
before insert on Booking
for each row
when (
	new.brukerID in (
		select brukerID
		from Utestengt
	)
)
begin
select RAISE(ABORT, 'brukeren er utestengt');
end;

create trigger bruker_opptatt
before insert on Booking
for each row
when (
	exists (
		select 1
		from Booking b
		join GruppetimeSlutt g1 on b.gruppetimeID = g1.id
		join GruppetimeSlutt g2 on new.gruppetimeID = g2.id
		where b.brukerID = new.brukerID
		and b.avmeldt_tidspunkt is null
		and g2.starttidspunkt < g1.sluttidspunkt
		and g1.starttidspunkt < g2.sluttidspunkt
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
values (new.brukerID, 'sen avmelding');
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
values (new.brukerID, 'sen avmelding');
end;

-- Deltatt

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
values (new.brukerID, 'sent oppmøte');
end;
