INSERT INTO Aktivitet (navn, beskrivelse, lengde_min) VALUES
('Spin 4x4', 'En forutsigbar intervalltime: 4 stående intervaller på 4 minutter hver, med ca 2 minutter aktiv pause mellom hvert drag. God oppvarming og nedsykling inkludert.', 45),
('Spin45', 'En variert spinningtime med 2-3 arbeidsperioder som passer for alle. Perfekt for deg som er ny på spinning! Du styrer intensiteten selv, og vi bruker takta til å tråkke oss gjennom timen.', 45),
('Spin 8x3', 'En forutsigbar intervalltime med 8 intervaller på 3 minutter hver, der du sitter og står annethvert drag. 90-120 sek pause mellom hvert intervall. God oppvarming og nedsykling inkludert.', 55),
('Spin60', 'En variert spinningtime som er noe mer utfordrende enn Spin45 med lengre varighet og tidvis høyere tempo. Du styrer likevel intensiteten selv, og timen passer alle som liker å tråkke i takt! Timen inneholder 2-4 arbeidsperioder med variert løype.', 60);

INSERT INTO Bruker (id, fornavn, etternavn, epost, mobilnr) VALUES
(1, 'Eirin', 'Hansen', 'eirin.hansen@sit.no', '90000001'),
(2, 'Siri', 'Moe Lund', 'siri.moe.lund@sit.no', '90000002'),
(3, 'Jorunn', 'Berg Bakke', 'jorunn.berg.bakke@sit.no', '90000003'),
(4, 'Ramona', 'Lien Solberg', 'ramona.lien.solberg@sit.no', '90000004'),
(5, 'Trine', 'Rønning', 'trine.ronning@sit.no', '90000005'),
(6, 'Nora', 'Dahl', 'nora.dahl@sit.no', '90000006'),
(7, 'Håkon', 'Wold', 'haakon.wold@sit.no', '90000007'),
(8, 'Hanne', 'Haug', 'hanne.haug@sit.no', '90000008'),
(9, 'Ada', 'Johansen Røe', 'ada.johansen.roe@sit.no', '90000009'),
(10, 'Sindre', 'Kvam Strand', 'sindre.kvam.strand@sit.no', '90000010'),
(11, 'Kaja', 'Sveen', 'kaja.sveen@sit.no', '90000011'),
(12, 'Amalie', 'Moen Hegge', 'amalie.moen.hegge@sit.no', '90000012'),
(13, 'Johnny', 'Normann', 'johnny@stud.ntnu.no', '90000013');

INSERT INTO Senter (navn, gateadresse, åpningstid, stengetid) VALUES
('Øya treningssenter', 'Vangslundsgate 2, Trondheim', '05:00', '23:59'),
('Dragvoll', 'Loholt allé 81, Trondheim', '05:00', '23:59');

INSERT INTO Sal (navn, senter_navn, kapasitet) VALUES
('Sykkelsal', 'Øya treningssenter', 38),
('Dragvoll Spinningsal', 'Dragvoll', 20);

INSERT INTO Gruppetime (id, aktivitet_navn, tidspunkt, senter_navn, sal_navn, instruktørID) VALUES
(1, 'Spin 4x4', '2026-03-16 07:00:00', 'Øya treningssenter', 'Sykkelsal', 1),
(2, 'Spin 4x4', '2026-03-16 16:30:00', 'Dragvoll', 'Dragvoll Spinningsal', 2),
(3, 'Spin45', '2026-03-16 16:30:00', 'Øya treningssenter', 'Sykkelsal', 3),
(4, 'Spin 8x3', '2026-03-16 17:40:00', 'Øya treningssenter', 'Sykkelsal', 4),
(5, 'Spin60', '2026-03-16 19:00:00', 'Øya treningssenter', 'Sykkelsal', 5),

(6, 'Spin 8x3', '2026-03-17 07:00:00', 'Øya treningssenter', 'Sykkelsal', 6),
(7, 'Spin60', '2026-03-17 18:30:00', 'Øya treningssenter', 'Sykkelsal', 7),
(8, 'Spin 4x4', '2026-03-17 19:45:00', 'Øya treningssenter', 'Sykkelsal', 8),

(9, 'Spin60', '2026-03-18 16:15:00', 'Øya treningssenter', 'Sykkelsal', 6),
(10, 'Spin45', '2026-03-18 16:30:00', 'Dragvoll', 'Dragvoll Spinningsal', 9),
(11, 'Spin 4x4', '2026-03-18 17:30:00', 'Øya treningssenter', 'Sykkelsal', 10),
(12, 'Spin45', '2026-03-18 18:30:00', 'Øya treningssenter', 'Sykkelsal', 11),
(13, 'Spin 8x3', '2026-03-18 19:30:00', 'Øya treningssenter', 'Sykkelsal', 12),
(14, 'Spin 4x4', '2001-01-01 00:00:15', 'Øya treningssenter', 'Sykkelsal', 1);

INSERT INTO Besøk (brukerID, tid, senter_navn) VALUES 
(13, '2003-01-01 07:00:00', 'Øya treningssenter'),
(13, '2026-17-03 10:41:00', 'Øya treningssenter');

INSERT INTO Booking VALUES 
(1, 13, '2000-01-01 00:00:00', NULL),
(2, 13, '2000-01-01 00:00:00', NULL),
(14, 13, '2001-01-01 00:00:01', NULL),

(1, 1, '2026-03-16 06:30:00', NULL),
(1, 2, '2026-03-16 06:31:00', NULL),
(1, 3, '2026-03-16 06:32:00', NULL),

(4, 1, '2026-03-16 17:00:00', NULL),
(4, 2, '2026-03-16 17:01:00', NULL),

(5, 2, '2026-03-16 18:30:00', NULL),
(5, 3, '2026-03-16 18:31:00', NULL);

INSERT INTO Deltatt (gruppetimeID, brukerID, oppmøtt_tidspunkt) VALUES 
(1, 13, '2026-03-16 06:50:00'),
(2, 13, '2026-03-16 06:20:00'),
(14, 13,'2001-01-01 00:00:01'),

(1, 1, '2026-03-16 06:50:00'),
(1, 2, '2026-03-16 06:51:00'),
(1, 3, '2026-03-16 06:52:00'),

(4, 1, '2026-03-16 17:40:00'),
(4, 2, '2026-03-16 17:41:00'),

(5, 2, '2026-03-16 19:00:00'),
(5, 3, '2026-03-16 19:01:00');
