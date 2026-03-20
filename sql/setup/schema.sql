create table Senter(
	navn varchar(50),
	gateadresse varchar(100) unique not null,
	åpningstid time not null,
	stengetid time not null,
	primary key(navn),
	check (stengetid > åpningstid)
);

create table Bemannet (
	senter_navn varchar(50), 
	ukedag smallint check (ukedag between 0 and 6),
	startidspunkt time,
	sluttidspunkt time not null,
	primary key (senter_navn, ukedag, startidspunkt),
	foreign key (senter_navn) references Senter(navn),
	check (sluttidspunkt > startidspunkt)
);

create table Fasilitet (
	navn varchar(50),
	senter_navn varchar(50),
	primary key (navn, senter_navn),
	foreign key (senter_navn) references Senter(navn)
);

create table Sal (
	navn varchar(50),
	senter_navn varchar(50), 
	kapasitet int check(kapasitet > 0),
	primary key (navn, senter_navn),
	foreign key (senter_navn) references Senter(navn)
);

create table Sykkel (
	senter_navn varchar(50),
	sal_navn varchar(50),
	nr int check(nr > 0),
	bodybikebluetooth bool not null default false,
	primary key (senter_navn, sal_navn, nr),
	foreign key (sal_navn, senter_navn) references Sal(navn, senter_navn)
);

create table Tredemølle (
	senter_navn varchar(50),
	sal_navn varchar(50),
	nr int check(nr > 0),
	produsent varchar(50),
	maksimal_hastighet int check(maksimal_hastighet > 0), 
	maksimal_stigning int check (maksimal_stigning >= 0), 
	primary key(senter_navn, sal_navn, nr),
	foreign key (sal_navn, senter_navn) references Sal(navn, senter_navn)
);

create table Bruker (
	id integer primary key,
	fornavn varchar(50) not null,
	etternavn varchar(50) not null,
	epost varchar(254) not null unique, -- max chars allowed in email
	mobilnr varchar(20) -- ex: '+49 909 85 323'
);

create table Besøk (
	brukerID int,
	tid timestamp default CURRENT_TIMESTAMP,
	senter_navn varchar(50) not null,
	primary key (brukerID, tid),
	foreign key (brukerID) references Bruker(id),
	foreign key (senter_navn) references Senter(navn)
);

-- endret for db2, lagt til id slik at prikker ikke kolliderer lenger
create table Prikk (
	id integer primary key,
	brukerID int not null,
	tidspunkt timestamp default CURRENT_TIMESTAMP not null,
	grunn varchar(255),
	foreign key (brukerID) references Bruker(id)
);

-- dette er manuell utestengelse
create table Utestengelse (
	brukerID int,
	gitt timestamp default CURRENT_TIMESTAMP,
	slutt timestamp not null,
	grunn varchar(255),
	primary key (brukerID, gitt),
	foreign key (brukerID) references Bruker(id),
	check (slutt > gitt)
);

create table Aktivitet (
	navn varchar(50),
	beskrivelse text,
	lengde_min int check(lengde_min > 0),
	primary key (navn)
);

create table Gruppetime (
	id integer primary key,
	aktivitet_navn varchar(50) not null, 
	tidspunkt timestamp not null,
	senter_navn varchar(50) not null,
	sal_navn varchar(50) not null,
	instruktørID int not null,
	foreign key (aktivitet_navn) references Aktivitet(navn),
	foreign key (sal_navn, senter_navn) references Sal(navn, senter_navn),
	foreign key (instruktørID) references Bruker(id),
	unique(instruktørID, tidspunkt),
	unique(senter_navn, sal_navn, tidspunkt)
);

create table Booking (
	gruppetimeID int, 
	brukerID int,
	påmeldt_tidspunkt timestamp not null default CURRENT_TIMESTAMP,
	avmeldt_tidspunkt timestamp,
	primary key (gruppetimeID, brukerID),
	foreign key (gruppetimeID) references Gruppetime(id),
	foreign key (brukerID) references Bruker(id)
);

create table Deltatt (
	gruppetimeID int, 
	brukerID int,
	oppmøtt_tidspunkt timestamp default CURRENT_TIMESTAMP,
	primary key (gruppetimeID, brukerID),
	foreign key (gruppetimeID, brukerID) references Booking(gruppetimeID, brukerID), -- nytt for db2 
	-- DB1
	--foreign key (gruppetimeID) references Gruppetime(id),
	--foreign key (brukerID) references Bruker(id),
	unique(brukerID, oppmøtt_tidspunkt)
);

create table Idrettslag (
	navn varchar(50),
	primary key (navn)
);

create table IdrettslagMedlemskap (
	brukerID int,
	idrettslag_navn varchar(50),
	primary key (brukerID, idrettslag_navn),
	foreign key (brukerID) references Bruker(id),
	foreign key (idrettslag_navn) references Idrettslag(navn)
);

create table Gruppe (
	idrettslag_navn varchar(50),
	navn varchar(50),
	primary key (idrettslag_navn, navn),
	foreign key (idrettslag_navn) references Idrettslag(navn)
);

create table GruppeMedlemskap (
	brukerID int,
	idrettslag_navn varchar(50),
	gruppe_navn varchar(50),
	primary key (brukerID, idrettslag_navn, gruppe_navn),
	foreign key (brukerID, idrettslag_navn) references IdrettslagMedlemskap(brukerID, idrettslag_navn),
	foreign key (gruppe_navn, idrettslag_navn) references Gruppe(navn, idrettslag_navn)
);

create table Reservasjon (
	senter_navn varchar(50),
	sal_navn varchar(50),
	starttidspunkt timestamp,
	sluttidspunkt timestamp not null,
	idrettslag_navn varchar(50) not null,
	gruppe_navn varchar(50),
	primary key (senter_navn, sal_navn, starttidspunkt),
	foreign key (sal_navn, senter_navn) references Sal(navn, senter_navn),
	foreign key (idrettslag_navn) references Idrettslag(navn),
	foreign key (gruppe_navn, idrettslag_navn) references Gruppe(navn, idrettslag_navn),
	check (sluttidspunkt > starttidspunkt)
);

create view Utestengt as 
	select brukerID
	from Prikk
	where datetime(tidspunkt, '+30 days') > CURRENT_TIMESTAMP
	group by brukerID
	having count(*) >= 3 

	union

	select brukerID
	from Utestengelse
	where slutt > CURRENT_TIMESTAMP
;

-- nytt for DB2

create view GruppeTimeSlutt as
select g.id, g.aktivitet_navn, g.tidspunkt as starttidspunkt, 
	datetime(g.tidspunkt, '+' || a.lengde_min || ' minutes') as sluttidspunkt, 
	g.senter_navn, g.sal_navn, g.instruktørID
from Gruppetime G
join Aktivitet a on g.aktivitet_navn = a.navn
;

create view SalOpptatt as

select senter_navn, sal_navn, starttidspunkt, sluttidspunkt
from Reservasjon

union all

select senter_navn, sal_navn, starttidspunkt, sluttidspunkt
from GruppetimeSlutt
;

-- viser alle som ikke har meldt seg av og fjerner ventelisten
create view GruppetimeDeltakere as
select b.gruppetimeID, b.brukerID
from Booking b
join Gruppetime g on b.gruppetimeID = g.id
join Sal s on (g.senter_navn = s.senter_navn and g.sal_navn = s.sal_navn) 
where b.avmeldt_tidspunkt is null
and s.kapasitet > (
	select count(*) -- antall som har meldt seg på før
	from Booking b2
	where b2.avmeldt_tidspunkt is null
	and b2.gruppetimeID = b.gruppetimeID
	and (
		b2.påmeldt_tidspunkt < b.påmeldt_tidspunkt -- meldt seg på før
		or (b2.påmeldt_tidspunkt = b.påmeldt_tidspunkt and b2.brukerID < b.brukerID) -- meldt seg på samtidig, går på brukerID
	)
);

-- viser alle på ventelisten
create view Venteliste as
select b.gruppetimeID, b.brukerID
from Booking b 
where b.avmeldt_tidspunkt is null
and not exists (
	select 1 
	from GruppetimeDeltakere g 
	where g.gruppetimeID = b.gruppetimeID
	and g.brukerID = b.brukerID
);

-- ikke møtt enda
create view IkkeMøtt as
select brukerID, gruppetimeID
from GruppetimeDeltakere g
where not exists (
	select 1
	from Deltatt d
	where d.gruppetimeID = g.gruppetimeID
	and d.brukerID = g.brukerID
);

create view MVP as
WITH månedsteller AS (
    SELECT b.id,
           b.fornavn || ' ' || b.etternavn AS navn,
           COUNT(*) AS antall,
		   STRFTIME('%Y-%m', d.oppmøtt_tidspunkt) as årmåned
    FROM Bruker b
    JOIN Deltatt d ON b.id = d.brukerID
    GROUP BY b.id, b.fornavn, b.etternavn, årmåned
)
SELECT mt.navn, mt.antall, mt.årmåned
FROM månedsteller as mt
WHERE mt.antall = (SELECT MAX(m.antall) FROM månedsteller as m WHERE mt.årmåned = m.årmåned);

