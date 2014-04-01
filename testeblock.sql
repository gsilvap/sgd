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
	
	declare operadorCursor Cursor for select idoperador, nome from operador;
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

	#select * from lucros;

	open operadorCursor;
	#select count(viagemCursor);
	operadorLoop : loop

		set counterOperadores := counterOperadores + 1;
		
		fetch operadorCursor into idoperadoraux , nomeaux ;

		if done then
			leave operadorLoop;
		end if;
		
		Nblock: begin
		declare viagemCursor Cursor for select distinct id from viagem, validacao where validacao.IDVIAGEM = viagem.id and validacao.IDOPERADOR = idoperadoraux;
		open viagemCursor;
		
		viagemLoop : loop
		
			fetch viagemCursor into idviagemaux;
			#select idviagemaux;
			
			if done then
				leave viagemLoop;
			end if;     

			#set lucroaux := null;

			select * into lucroaux from (select count(*)*2/(select count(*) from validacao where idviagem = idviagemaux) from validacao where idviagem = idviagemaux and idoperador = idoperadoraux) receitas;
			update lucro set lucro = lucro + lucroaux where idoperador = idoperadoraux;
			
			#set counterViagens := counterViagens + 1;

			#if lucroaux is not null then
			#set counterUpdates := counterUpdates + 1;
			#end if;

			set done := false;
				
		end loop viagemLoop;
		
		close viagemCursor;
		end Nblock;

		set done := false;
	end loop operadorLoop;
		
	close operadorCursor;
	
	select counterOperadores, counterViagens, counterUpdates;

	select IDOPERADOR "ID Operador", NOME "Nome", LUCRO "Receitas" from lucro;
	select * from (select sum(LUCRO) "Receitas aproximadas" from lucro) somaLucros, (select count(*)*2 "Receitas reais" from viagem) valorreal;

END;
$$ DELIMITER ;

call lucros();

select id from viagem, validacao where validacao.IDVIAGEM = viagem.id and validacao.IDOPERADOR = 1;



call lucrosViagem(2);
call lucrosViagemOperador(2,1);

select *  from viagem where id = 2;

select count(*) from viagem where ID = 2 group by ID;

select count(*) from validacao where idviagem = 2;

select count(*)*2/(select count(*) from validacao where idviagem = 2) from validacao where idviagem = 2 and idoperador = 1;


select * from validacao where idviagem = 2;
select * from validacao where idviagem = 2 and idoperador = 1;

select count(*) from validacao INNER JOIN viagem on validacao.IDVIAGEM = 2 group by validacao.IDVIAGEM;

#select count(*)*2 from viagem;
#select count(*) from validacao;