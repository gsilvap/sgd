drop PROCEDURE lucros;

DELIMITER $$
CREATE PROCEDURE lucros()
BEGIN 
	declare counterOperadores INT default 0;
	declare counterViagens INT default 0;
	declare counterUpdates INT default 0;
	declare idviagemaux INT;
	declare idoperadoraux INT;
	declare nomeaux CHAR(50);
	declare lucroaux float;

	DECLARE done INT default false;
	
	declare viagemCursor Cursor for select id from viagem;
	declare operadorCursor Cursor for select idoperador, nome from operador;
	declare continue handler for not found set done := true;
	
	drop temporary table if exists lucro;

	create temporary table lucro
	(
	   IDOPERADOR_LUCROS           int,
	   NOME_LUCROS                 char(50),
	   LUCRO_LUCROS                float default 0,
		primary key (IDOPERADOR_LUCROS)
	) ENGINE = MEMORY;

	open operadorCursor;

	operadorLoop1 : loop

		fetch operadorCursor into idoperadoraux , nomeaux ;
      
		if done then
			set done := false;
			leave operadorLoop1;
		end if;
    
		insert into lucro (IDOPERADOR_LUCROS, NOME_LUCROS, LUCRO_LUCROS) values (idoperadoraux, nomeaux, 0);

	end loop operadorLoop1;
    
	close operadorCursor;

	#select * from lucros;

	open operadorCursor;
	#select count(viagemCursor);
	operadorLoop : loop

		#set counterOperadores := counterOperadores + 1;
		
		fetch operadorCursor into idoperadoraux , nomeaux ;

		if done then
			leave operadorLoop;
		end if;
	
		open viagemCursor;
		
		viagemLoop : loop
		
			fetch viagemCursor into idviagemaux;
			#select idviagemaux;
			
			if done then
				leave viagemLoop;
			end if;     

			set lucroaux := null;

			select receitas into lucroaux from (select IDOPERADOR, count(*)*2/ (
				select count(*) from validacao INNER JOIN viagem on validacao.IDVIAGEM = idviagemaux group by validacao.IDVIAGEM) Receitas
			from validacao  
			INNER JOIN viagem on validacao.IDVIAGEM = idviagemaux where validacao.idoperador = idoperadoraux group by validacao.IDOPERADOR) cenas;
			
			#set counterViagens := counterViagens + 1;

			if lucroaux is not null then

				update lucro set lucro_LUCROS = lucro_LUCROS + lucroaux where idoperador_LUCROS = idoperadoraux;
				#set counterUpdates := counterUpdates + 1;
			end if;

			set done := false;
				
		end loop viagemLoop;
		set done := false;
			
		close viagemCursor;

	end loop operadorLoop;
		
	close operadorCursor;
	
	#select counterOperadores, counterViagens, counterUpdates;

	select IDOPERADOR_LUCROS "ID Operador", NOME_LUCROS "Nome", LUCRO_LUCROS "Receitas" from lucro;
	select * from (select sum(LUCRO_LUCROS) "Receitas aproximadas" from lucro) somaLucros, (select count(*)*2 "Receitas reais" from viagem) valorreal;

END;
$$ DELIMITER ;

call lucros();

#select count(*)*2 from viagem;
#select count(*) from validacao;