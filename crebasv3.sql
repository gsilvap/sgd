drop database tp2;
create database tp2;

use tp2;


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

load data infile "D:/DBTP21000cartoes/CARREGAMENTO" into table CARREGAMENTO fields terminated by "|" lines terminated by "\r\n";
load data infile "D:/DBTP21000cartoes/CARTAO" into table CARTAO fields terminated by "|" lines terminated by "\r\n";
load data infile "D:/DBTP21000cartoes/OPERADOR" into table OPERADOR fields terminated by "|" lines terminated by "\r\n";
load data infile "D:/DBTP21000cartoes/TITULO" into table TITULO fields terminated by "|" lines terminated by "\r\n";
load data infile "D:/DBTP21000cartoes/VALIDACAO" into table VALIDACAO fields terminated by "|" lines terminated by "\r\n";
load data infile "D:/DBTP21000cartoes/VIAGEM" into table VIAGEM fields terminated by "|" lines terminated by "\r\n";
load data infile "D:/DBTP21000cartoes/PASSE" into table PASSE fields terminated by "|" lines terminated by "\r\n";

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
