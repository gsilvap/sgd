drop PROCEDURE lucros;

DELIMITER $$
CREATE PROCEDURE lucros()
BEGIN 
	declare counterOperadores INT default 0;
	declare counterViagens INT default 0;
	declare counterUpdates INT default 0;
	declare idviagemaux INT;
	declare idoperadoraux INT;
	declare counter INT;
	declare nomeaux varchar(50);
	declare lucroaux float;

	DECLARE done INT default false;
	
	declare operadorCursor Cursor for select idoperador, nome from operador;
	declare viagemCursor Cursor for select id from viagem;

	declare continue handler for not found set done := true;
	
	drop temporary table if exists lucro;
	create temporary table lucro
	(
	   IDOPERADOR           int,
	   NOME                 char(50),
	   LUCRO 				float default 0,
		primary key (IDOPERADOR)
	) ENGINE = MEMORY;

	open operadorCursor;
	operadorLoop1 : loop
		fetch operadorCursor into idoperadoraux , nomeaux ;
		if done then
			set done := false;
			leave operadorLoop1;
		end if;
		insert into lucro (IDOPERADOR, NOME, LUCRO) values (idoperadoraux, nomeaux, 0);
	end loop operadorLoop1;
	close operadorCursor;

	open viagemCursor;
	viagemLoop : loop
		fetch viagemCursor into idviagemaux;

		select count(*) into counter from validacao where idviagem = idviagemaux;

		if done then
			leave viagemLoop;
		end if;
		
		Nblock: begin
		declare operadorCursor2 Cursor for select distinct idOperador from validacao where validacao.IDVIAGEM = idviagemaux;
		open operadorCursor2;
		
		operadorLoop : loop
		
			fetch operadorCursor2 into idoperadoraux;
			if done then
				leave operadorLoop;
			end if;

			select count(*)*2/(counter) into lucroaux from validacao where idviagem = idviagemaux and idoperador = idoperadoraux;
			update lucro set lucro = lucro + lucroaux where idoperador = idoperadoraux;

			set done := false;
				
		end loop operadorLoop;
		
		close operadorCursor2;
		end Nblock;

		set done := false;
	end loop viagemLoop;
		
	close viagemCursor;
	
	select IDOPERADOR "ID Operador", NOME "Nome", LUCRO "Receitas" from lucro;
	select * from (select sum(LUCRO) "Receitas aproximadas" from lucro) somaLucros, (select count(*)*2 "Receitas reais" from viagem) valorreal;

END;
$$ DELIMITER ;

call lucros();