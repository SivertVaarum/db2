create domain name_type as varchar(50);
create domain pos_int as integer
check (value > 0);

create table Senter(
	navn name_type,
	gateadresse varchar(100) unique not null,
	åpningstid time not null,
	stengetid time not null,
	primary key(navn),
	check (stengetid > åpningstid)
);

create table Bemannet (
	senter_navn name_type, 
	ukedag smallint check (ukedag between 0 and 6),
	startidspunkt time,
	sluttidspunkt time not null,
	primary key (senter_navn, ukedag, startidspunkt),
	foreign key (senter_navn) references Senter(navn),
	check (sluttidspunkt > startidspunkt)
);

create table Fasilitet (
	navn name_type,
	senter_navn name_type,
	primary key (navn, senter_navn),
	foreign key (senter_navn) references Senter(navn)
);

create table Sal (
	navn name_type,
	senter_navn name_type, 
	kapasitet pos_int,
	primary key (navn, senter_navn),
	foreign key (senter_navn) references Senter(navn)
);

create table Sykkel (
	senter_navn name_type,
	sal_navn name_type,
	nr pos_int,
	bodybikebluetooth bool not null default false,
	primary key (senter_navn, sal_navn, nr),
	foreign key (sal_navn, senter_navn) references Sal(navn, senter_navn)
);

create table Tredemølle (
	senter_navn name_type,
	sal_navn name_type,
	nr pos_int,
	produsent name_type,
	maksimal_hastighet pos_int, 
	maksimal_stigning int check (maksimal_stigning >= 0), 
	primary key(senter_navn, sal_navn, nr),
	foreign key (sal_navn, senter_navn) references Sal(navn, senter_navn)
);

create table Bruker (
	id int,
	fornavn name_type not null,
	etternavn name_type not null,
	epost varchar(254) not null unique, -- max chars allowed in email
	mobilnr varchar(20), -- ex: '+49 909 85 323'
	primary key (id)
);

create table Besøk (
	brukerID int,
	tid timestamp default CURRENT_TIMESTAMP,
	senter_navn name_type not null,
	primary key (brukerID, tid),
	foreign key (brukerID) references Bruker(id),
	foreign key (senter_navn) references Senter(navn),
);

create table Prikk (
	brukerID int,
	tidspunkt timestamp default CURRENT_TIMESTAMP,
	grunn varchar(255),
	primary key (brukerID, tidspunkt),
	foreign key (brukerID) references Bruker(id)
);

create table Utestengelse (
	brukerID int,
	gitt timestamp default CURRENT_TIMESTAMP,
	slutt timestamp not null,
	grunn varchar(255),
	primary key (brukerID, gitt),
	foreign key (brukerID) references Bruker(id),
	check (slutt > gitt)
);

create view Utestengt as (
	select brukerID
	from Prikk
	where TIMESTAMPDIFF(DAY, tidspunkt, CURRENT_TIMESTAMP) < 30
	group by brukerID
	having count(*) >= 3 

	union

	select brukerID
	from Utestengelse
	where slutt > CURRENT_TIMESTAMP
);

create table Aktivitet (
	navn name_type,
	beskrivelse text,
	lengde_min pos_int,
	primary key (navn)
);

create table Gruppetime (
	id int,
	aktivitet_navn name_type not null, 
	tidspunkt timestamp not null,
	senter_navn name_type not null,
	sal_navn name_type not null,
	instruktørID int not null,
	primary key (id),
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
	foreign key (gruppetimeID) references Gruppetime(id),
	foreign key (brukerID) references Bruker(id),
	unique(brukerID, oppmøtt_tidspunkt)
);

create table Idrettslag (
	navn name_type,
	primary key (navn)
);

create table IdrettslagMedlemskap (
	brukerID int,
	idrettslag_navn name_type,
	primary key (brukerID, idrettslag_navn),
	foreign key (brukerID) references Bruker(id),
	foreign key (idrettslag_navn) references Idrettslag(navn)
);

create table Gruppe (
	idrettslag_navn name_type,
	navn name_type,
	primary key (idrettslag_navn, navn),
	foreign key (idrettslag_navn) references Idrettslag(navn)
);

create table GruppeMedlemskap (
	brukerID int,
	idrettslag_navn name_type,
	gruppe_navn name_type,
	primary key (brukerID, idrettslag_navn, gruppe_navn),
	foreign key (brukerID, idrettslag_navn) references IdrettslagMedlemskap(brukerID, idrettslag_navn),
	foreign key (gruppe_navn, idrettslag_navn) references Gruppe(navn, idrettslag_navn)
);

create table Reservasjon (
	senter_navn name_type,
	sal_navn name_type,
	starttidspunkt timestamp,
	sluttidspunkt timestamp not null,
	idrettslag_navn name_type not null,
	gruppe_navn name_type,
	primary key (senter_navn, sal_navn, starttidspunkt),
	foreign key (sal_navn, senter_navn) references Sal(navn, senter_navn),
	foreign key (idrettslag_navn) references Idrettslag(navn),
	foreign key (gruppe_navn, idrettslag_navn) references Gruppe(navn, idrettslag_navn),
	check (sluttidspunkt > starttidspunkt)
);
