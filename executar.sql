create database tp100cartoes;
use tp100cartoes;

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


load data infile "D:/DBTP2New/DBTP100cartoes/VIAGEM" into table VIAGEM fields terminated by "|" lines terminated by "\r\n";
load data infile "D:/DBTP2New/DBTP100cartoes/OPERADOR" into table OPERADOR fields terminated by "|" lines terminated by "\r\n";
load data infile "D:/DBTP2New/DBTP100cartoes/CARTAO" into table CARTAO fields terminated by "|" lines terminated by "\r\n";
load data infile "D:/DBTP2New/DBTP100cartoes/TITULO" into table TITULO fields terminated by "|" lines terminated by "\r\n";
load data infile "D:/DBTP2New/DBTP100cartoes/PASSE" into table PASSE fields terminated by "|" lines terminated by "\r\n";
load data infile "D:/DBTP2New/DBTP100cartoes/CARREGAMENTO" into table CARREGAMENTO fields terminated by "|" lines terminated by "\r\n";
load data infile "D:/DBTP2New/DBTP100cartoes/VALIDACAO" into table VALIDACAO fields terminated by "|" lines terminated by "\r\n";

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