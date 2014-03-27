drop database tp2;
create database tp100cartoes;

use tp100cartoes;

alter table CARREGAMENTO drop foreign key FK_REFERENCE_7;
alter table PASSE drop foreign key FK_INHERITANCE_1;
alter table TITULO drop foreign key FK_INHERITANCE_2;
alter table VALIDACAO drop foreign key FK_REFERENCE_6;
alter table VALIDACAO drop foreign key FK_RELATIONSHIP_10;
alter table VALIDACAO drop foreign key FK_RELATIONSHIP_9;

truncate CARREGAMENTO;
truncate CARTAO;
truncate OPERADOR;
truncate PASSE;
truncate TITULO;
truncate VALIDACAO;
truncate VIAGEM;

/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     20/03/2014 14:33:38                          */
/*==============================================================*/


drop table if exists CARREGAMENTO;

drop table if exists CARTAO;

drop table if exists OPERADOR;

drop table if exists PASSE;

drop table if exists TITULO;

drop table if exists VALIDACAO;

drop table if exists VIAGEM;

/*==============================================================*/
/* Table: CARREGAMENTO                                          */
/*==============================================================*/
create table CARREGAMENTO
(
   IDCARREGAMENTO       int not null,
   IDCARTAO             int,
   DATA                 timestamp not null,
   NVIAGENS             int not null,
   VALOR                int not null,
   MAQUINA              int not null,
   primary key (IDCARREGAMENTO)
);

/*==============================================================*/
/* Table: CARTAO                                                */
/*==============================================================*/
create table CARTAO
(
   IDCARTAO             int not null,
   DATAVENDA            timestamp,
   primary key (IDCARTAO)
);

/*==============================================================*/
/* Table: OPERADOR                                              */
/*==============================================================*/
create table OPERADOR
(
   IDOPERADOR           int not null,
   NOME                 char(50) not null,
   NIF                  int not null,
   CAPITALSOCIAL        int not null,
   primary key (IDOPERADOR)
);

/*==============================================================*/
/* Table: PASSE                                                 */
/*==============================================================*/
create table PASSE
(
   IDCARTAO             int not null,
   VALOR                int,
   ULTIMOCARREGAMENTO   timestamp,
   ESTADO               bool,
   BI                   int not null,
   NOME                 char(50) not null,
   NIF                  int not null,
   PROFISSAO            char(60) not null,
   ESTADOCIVIL          char(25) not null,
   TELEMOVEL            char(40) not null,
   MORADA               char(255) not null,
   DATANASCIMENTO       timestamp not null,
   primary key (IDCARTAO)
);

/*==============================================================*/
/* Table: TITULO                                                */
/*==============================================================*/
create table TITULO
(
   IDCARTAO             int not null,
   NVIAGENS             int,
   primary key (IDCARTAO)
);

/*==============================================================*/
/* Table: VALIDACAO                                             */
/*==============================================================*/
create table VALIDACAO
(
   IDCARTAO             int not null,
   IDVALIDACAO          int not null,
   IDOPERADOR           int not null,
   IDVIAGEM             int not null,
   DATA                 timestamp not null,
   primary key (IDCARTAO, IDVALIDACAO, IDOPERADOR, IDVIAGEM)
);

/*==============================================================*/
/* Table: VIAGEM                                                */
/*==============================================================*/
create table VIAGEM
(
   ID                   int not null,
   LOCALENTRADA         char(50),
   primary key (ID)
);

load data infile "D:/DBTP/VIAGEM" into table VIAGEM fields terminated by "|" lines terminated by "\r\n";
load data infile "D:/DBTP/OPERADOR" into table OPERADOR fields terminated by "|" lines terminated by "\r\n";
load data infile "D:/DBTP/CARTAO" into table CARTAO fields terminated by "|" lines terminated by "\r\n";
load data infile "D:/DBTP/TITULO" into table TITULO fields terminated by "|" lines terminated by "\r\n";
load data infile "D:/DBTP/PASSE" into table PASSE fields terminated by "|" lines terminated by "\r\n";
load data infile "D:/DBTP/CARREGAMENTO" into table CARREGAMENTO fields terminated by "|" lines terminated by "\r\n";
load data infile "D:/DBTP/VALIDACAO" into table VALIDACAO fields terminated by "|" lines terminated by "\r\n";

alter table CARREGAMENTO add constraint FK_REFERENCE_7 foreign key (IDCARTAO)
      references CARTAO (IDCARTAO) on delete restrict on update restrict;

alter table PASSE add constraint FK_INHERITANCE_1 foreign key (IDCARTAO)
      references CARTAO (IDCARTAO) on delete restrict on update restrict;

/*alter table TITULO add constraint FK_INHERITANCE_1 foreign key (IDCARTAO)*/
/*      references CARTAO (IDCARTAO) on delete restrict on update restrict;*/
alter table TITULO add constraint FK_INHERITANCE_2 foreign key (IDCARTAO)
      references CARTAO (IDCARTAO) on delete restrict on update restrict;

alter table VALIDACAO add constraint FK_REFERENCE_6 foreign key (IDCARTAO)
      references CARTAO (IDCARTAO) on delete restrict on update restrict;

alter table VALIDACAO add constraint FK_RELATIONSHIP_10 foreign key (IDVIAGEM)
      references VIAGEM (ID) on delete restrict on update restrict;

alter table VALIDACAO add constraint FK_RELATIONSHIP_9 foreign key (IDOPERADOR)
      references OPERADOR (IDOPERADOR) on delete restrict on update restrict;


/*
select * from validacao;

LEFT JOIN T2 ON T2.A=T1.A
*/
select v2.IDVALIDACAO, v2.IDVIAGEM, v.IDVIAGEM 
from validacao v, validacao v2 
where v2.IDVIAGEM = v.IDVIAGEM 
group by v.IDVALIDACAO;


drop PROCEDURE lucrosViagem;

/* divisao das receitas da viagem com o id = 1*/
DELIMITER $$
CREATE PROCEDURE lucrosViagem(in idviagem int)
BEGIN 
	select * from (select IDOPERADOR, count(*)*2/ (
		select count(*) from validacao INNER JOIN viagem on validacao.IDVIAGEM = idviagem group by validacao.IDVIAGEM) Receitas
	from validacao 
	INNER JOIN viagem on validacao.IDVIAGEM = idviagem group by validacao.IDOPERADOR) cenas;
END;
$$ DELIMITER ;

drop PROCEDURE lucrosViagemOperador;

/* test */
DELIMITER $$
CREATE PROCEDURE lucrosViagemOperador(in idviagem int, in idoperador int)
BEGIN 
	select receitas from (select IDOPERADOR, count(*)*2/ (
		select count(*) from validacao INNER JOIN viagem on validacao.IDVIAGEM = idviagem group by validacao.IDVIAGEM) Receitas
	from validacao  
	INNER JOIN viagem on validacao.IDVIAGEM = idviagem where idoperador = validacao.idoperador group by validacao.IDOPERADOR) cenas;
END;
$$ DELIMITER ;

select idoperador, nome from operador;


drop PROCEDURE lucros;

call lucros();

DELIMITER $$
CREATE PROCEDURE lucros()
BEGIN 
	declare counter INT default 0;
	declare idviagemaux INT;
	declare idoperadoraux INT;
	declare nomeaux CHAR(50);
	declare lucroaux float;

	DECLARE done INT default false;
	
	declare viagemCursor Cursor for select id from viagem;
	declare operadorCursor Cursor for select idoperador, nome from operador;
	declare continue handler for not found set done := true;
	
	drop temporary table if exists lucros;

	create temporary table lucros 
	(
	   IDOPERADOR           int,
	   NOME                 char(50),
	   LUCRO                float default 0,
		primary key (IDOPERADOR)
	) ENGINE = MEMORY;

	open operadorCursor;

	operadorLoop1 : loop

		fetch operadorCursor into idoperadoraux , nomeaux ;
      
		if done then
			set done := false;
			leave operadorLoop1;
		end if;
    
		insert into lucros (idoperador, nome, lucro) values (idoperadoraux, nomeaux, 0);

	end loop operadorLoop1;
    
	close operadorCursor;

	#select * from lucros;

	open operadorCursor;
	select count(viagemCursor);
	operadorLoop : loop
		
		fetch operadorCursor into idoperadoraux , nomeaux ;

		if done then
			leave operadorLoop;
		end if;
	
		open viagemCursor;
		SELECT FOUND_ROWS(); 
		viagemLoop : loop
		
			fetch viagemCursor into idviagemaux;
			#select idviagemaux;
			#set counter := counter + 1;

			if done then
				set done := false;
				leave viagemLoop;
			end if;
			
			select receitas into lucroaux from (select IDOPERADOR, count(*)*2/ (
				select count(*) from validacao INNER JOIN viagem on validacao.IDVIAGEM = idviagemaux group by validacao.IDVIAGEM) Receitas
			from validacao  
			INNER JOIN viagem on validacao.IDVIAGEM = idviagemaux where validacao.idoperador = idoperadoraux group by validacao.IDOPERADOR) cenas;
			
			if lucroaux is not null then
				update lucros set lucro = lucro + lucroaux where idoperador = idoperadoraux;
				#select * from lucros;
			end if;

		end loop viagemLoop;
		
		close viagemCursor;

	end loop operadorLoop;
		
	close operadorCursor;
	
	#select counter;

	select * from lucros;

END;
$$ DELIMITER ;




call lucrosViagem(2);
call lucrosViagemOperador(2,3);


DELIMITER $$
CREATE PROCEDURE sumLucrosViagem(out lucrosTable int)
BEGIN 
	
		select * from (call lucrosViagem(1)) as cenas;
END;
$$ DELIMITER ;

CREATE TEMPORARY TABLE foo call lucrosViagem(1);




select IDOPERADOR, count(*)*2/ (select count(*) from validacao
INNER JOIN viagem on validacao.IDVIAGEM = viagem.ID where IDVIAGEM = 2 group by IDVIAGEM) Receitas
 from validacao
INNER JOIN viagem on validacao.IDVIAGEM = viagem.ID where IDVIAGEM = 2 group by IDOPERADOR;

select * from validacao left JOIN viagem on validacao.IDVIAGEM = viagem.ID right JOIN viagem on validacao.IDVIAGEM = viagem.ID group by IDVIAGEM;

select * from validacao where IDVIAGEM = 1;

select * from validacao where IDVIAGEM = 2;

select IDOPERADOR from operador;
