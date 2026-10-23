drop database if exists laboratorio_gestionale_universitario;
create database laboratorio_gestionale_universitario;
use laboratorio_gestionale_universitario;

create table docenti (
    id           int auto_increment primary key,
    nome         varchar(50) not null,
    cognome      varchar(50) not null,
    dipartimento varchar(80) not null
);

create table corsi_accademici (
    id           int auto_increment primary key,
    titolo_corso varchar(100) not null,
    docente_id   int          not null,
    ore_corso    int          not null,
    foreign key (docente_id) references docenti(id)
);

--  -------------------------------------------------------------------------------------
delimiter $$

create procedure assegna_corso_docente(
	in p_titolo varchar(100),
	in p_ore int,
	in p_docente int,
	out p_esito varchar(100)
)
begin
	declare exit handler for sqlexception
	begin
		rollback;
		set p_esito = 'ERRORE: Errore interno, transazione annullata.';
	end;

	start transaction;
	if p_ore <= 0 then
		rollback;
		set p_esito = 'ERRORE: Le ore devono essere > 0.';
	elseif not exists (select 1 from docenti where id = p_docente) then
		rollback;
		set p_esito = 'ERRORE: Docente non trovato.';
	else
		insert into corsi_accademici (titolo_corso, ore_corso, docente_id) values
			(p_titolo, p_ore, p_docente);
		commit;
		set p_esito = 'SUCCESSO: Corso assegnato correttamente.';
	end if;
end $$

delimiter ;
--  -------------------------------------------------------------------------------------

insert into docenti values
    (1, 'Anna',     'Ferrari',   'Informatica'),
    (2, 'Marco',    'Santini',   'Matematica'),
    (3, 'Lucia',    'Colombo',   'Fisica');

insert into corsi_accademici values
    (1, 'Basi di Dati Avanzate',     1, 60),
    (2, 'Reti di Calcolatori',       1, 48),
    (3, 'Algebra Lineare',           2, 72),
    (4, 'Analisi Matematica I',      2, 80);

