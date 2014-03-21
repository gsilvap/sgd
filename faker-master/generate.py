#!/usr/bin/env python
# -*- coding: utf-8 -*-

from datetime import datetime
from faker import Factory
from random import *
fake = Factory.create('it_IT')

operadores = ['Metro do Porto', 'STCP', 'CP', 'Resende', 'ES - Espirito Santo', 'Maia Transportes', 'MGC Transportes', 'A. Nogueira da Costa, Lda', 'Auto-Viação Pacense', 'Valpi Grupo', 'ETG Empresa de Transportes Gondomarense, Lda']

estacoes = ['Senhor de Matosinhos', 'Mercado', 'Brito Capelo', 'Matosinhos Sul', 'Câmara de Matosinhos', 'Parque Real', 'Pedro Hispano', 'Estádio do Mar', 'Vasco da Gama', 'Póvoa de Varzim', 'São Brás', 'Portas Fronhas', 'Alto do Pega', 'Vila do Conde', 'Santa Clara', 'Azurara', 'Árvore', 'Varziela', 'Espaço Natureza', 'Mindelo', 'Modivas Centro', 'Modivas Sul', 'Vilar do Pinheiro', 'Lidador', 'Pedras Rubras', 'ISMAI', 'Castêlo da Maia', 'Mandim', 'Zona Industrial', 'Fórum da Maia', 'Parque da Maia', 'Custió', 'Araújo', 'Pias', 'Cândido dos Reis', 'Santo Ovídio', 'D. João II', 'João de Deus', 'Câmara de Gaia', 'General Torres', 'Jardim do Morro', 'São Bento', 'Aliados', 'Trindade', 'Faria Guimarães', 'Marquês', 'Combatentes', 'Salgueiros', 'Pólo Universitário', 'IPO', 'Hospital de São João', 'Aeroporto', 'Botica', 'Contumil', 'Nasoni', 'Nau Vitória', 'Levada', 'Rio Tinto', 'Campainha', 'Baguim', 'Carreira', 'Venda Nova', 'Fânzeres', 'Trindade', 'Senhora da Hora', 'Sete Bicas', 'Viso', 'Ramalde', 'Francos', 'Casa da Música', 'Carolina Michaëlis', 'Lapa', 'Bolhão', 'Campo 24 de Agosto', 'Heroísmo', 'Campanhã', 'Estádio do Dragão', 'Fonte do Cuco', 'Verdes', 'Crestins', 'Esposade', 'Custóias', 'Batalha', 'Ribeira']


fcartao = open('D:/DBTP2/cartao', 'w')
fpasse = open('D:/DBTP2/passe', 'w')
ftitulo = open('D:/DBTP2/titulo', 'w')
fcarregamento = open('D:/DBTP2/carregamento', 'w')
fviagem = open('D:/DBTP2/viagem', 'w')
fvalidacao = open('D:/DBTP2/validacao', 'w')
foperador = open('D:/DBTP2/operador', 'w')

for i in range(len(operadores)):
  foperador.write(str(i+1)+'|'+str(operadores[i])+'|'+str(fake.random_int(min=299999999, max=999999999))+'|'+str(fake.random_int(min=5000, max=50000))+'\n')

#gerar viagens
#for i in range():
#  foperador.write(str(i+1)+'|'+str(operadores[i])+'|'+str(fake.random_int(min=299999999, max=999999999))+'|'+str(fake.random_int(min=5000, max=50000))+'\n')

for i in range(0,20):
  idcartao = str(i+1)
  datavenda = fake.date_time_this_year()

  fcartao.write(idcartao+'|'+str(datavenda)+'\n')

  # por cada 10 cartoes gerados, um é passe
  if i %10 == 0:
    valor = fake.random_int(min=5, max=60)
    ultimoCarregamento = fake.date_time_between(start_date="-10y", end_date=datavenda)
    estado = choice(['true', 'false'])
    bi = fake.random_int(min=99999999, max=999999999)
    nome = fake.name()
    nif = fake.random_int(min=99999999, max=299999999)
    profissao = fake.job()
    estadocivil = choice(['casado', 'solteiro', 'viuvo'])
    telemovel = fake.phone_number()
    morada = fake.address()

    #Pelo menos 10 anos mais novo do que a data de compra
    data = datetime(datavenda.year-10, datavenda.month, datavenda.day, datavenda.hour, datavenda.minute, datavenda.second)
    datanascimento = fake.date_time_between(start_date="-40y", end_date=data)
    fpasse.write(str(idcartao)+'|'+str(valor)+'|'+str(ultimoCarregamento)+'|'+str(estado)+'|'+str(bi)+'|'+str(nome)+'|'+str(nif)+'|'+str(profissao)+'|'+str(estadocivil)+'|'+str(telemovel)+'|'+str(morada)+'|'+str(datanascimento)+'\n')

    # gerar as validaçoes
    # gerar os carregamentos

  # os restantes sao titulos
  else:
    nviagens = randint(1,20)
    viagensGastas = 20 - nviagens

    # gerar as validaçoes
    #for i in range (viagensGastas):

    # gerar os carregamentos


    ftitulo.write(str(idcartao)+'|'+str(nviagens)+'\n')

fcartao.close()
fpasse.close()
ftitulo.close()
fcarregamento.close()
fviagem.close()
fvalidacao.close()
foperador.close()