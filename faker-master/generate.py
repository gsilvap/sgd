from datetime import datetime
from faker import Factory
from random import *
fake = Factory.create('it_IT')

operadores = ['Metro do Porto', 'STCP', 'CP', 'Resende', 'ES - Espirito Santo', 'Maia Transportes', 'MGC Transportes', 'A. Nogueira da Costa, Lda', 'Auto-Viacao Pacense', 'Valpi Grupo', 'ETG Empresa de Transportes Gondomarense, Lda']
estacoes = ['Senhor de Matosinhos', 'Mercado', 'Brito Capelo', 'Matosinhos Sul', 'Camara de Matosinhos', 'Parque Real', 'Pedro Hispano', 'Estadio do Mar', 'Vasco da Gama', 'Povoa de Varzim', 'Sao Bras', 'Portas Fronhas', 'Alto do Pega', 'Vila do Conde', 'Santa Clara', 'Azurara', 'Arvore', 'Varziela', 'Espaco Natureza', 'Mindelo', 'Modivas Centro', 'Modivas Sul', 'Vilar do Pinheiro', 'Lidador', 'Pedras Rubras', 'ISMAI', 'Castelo da Maia', 'Mandim', 'Zona Industrial', 'Forum da Maia', 'Parque da Maia', 'Custio', 'Araujo', 'Pias', 'Candido dos Reis', 'Santo Ovidio', 'D. Joao II', 'Joao de Deus', 'Camara de Gaia', 'General Torres', 'Jardim do Morro', 'Sao Bento', 'Aliados', 'Trindade', 'Faria Guimaraes', 'Marques', 'Combatentes', 'Salgueiros', 'Polo Universitario', 'IPO', 'Hospital de Sao Joao', 'Aeroporto', 'Botica', 'Contumil', 'Nasoni', 'Nau Vitoria', 'Levada', 'Rio Tinto', 'Campainha', 'Baguim', 'Carreira', 'Venda Nova', 'Fanzeres', 'Trindade', 'Senhora da Hora', 'Sete Bicas', 'Viso', 'Ramalde', 'Francos', 'Casa da Musica', 'Carolina Michaelis', 'Lapa', 'Bolhao', 'Campo 24 de Agosto', 'Heroismo', 'Campanha', 'Estadio do Dragao', 'Fonte do Cuco', 'Verdes', 'Crestins', 'Esposade', 'Custoias', 'Batalha', 'Ribeira']

#operadores = ['Metro do Porto', 'STCP', 'CP', 'Resende', 'ES - Espirito Santo', 'Maia Transportes', 'MGC Transportes', 'A. Nogueira da Costa, Lda', 'Auto-Viação Pacense', 'Valpi Grupo', 'ETG Empresa de Transportes Gondomarense, Lda']
#estacoes = ['Senhor de Matosinhos', 'Mercado', 'Brito Capelo', 'Matosinhos Sul', 'Câmara de Matosinhos', 'Parque Real', 'Pedro Hispano', 'Estádio do Mar', 'Vasco da Gama', 'Póvoa de Varzim', 'São Brás', 'Portas Fronhas', 'Alto do Pega', 'Vila do Conde', 'Santa Clara', 'Azurara', 'Árvore', 'Varziela', 'Espaço Natureza', 'Mindelo', 'Modivas Centro', 'Modivas Sul', 'Vilar do Pinheiro', 'Lidador', 'Pedras Rubras', 'ISMAI', 'Castêlo da Maia', 'Mandim', 'Zona Industrial', 'Fórum da Maia', 'Parque da Maia', 'Custió', 'Araújo', 'Pias', 'Cândido dos Reis', 'Santo Ovídio', 'D. João II', 'João de Deus', 'Câmara de Gaia', 'General Torres', 'Jardim do Morro', 'São Bento', 'Aliados', 'Trindade', 'Faria Guimarães', 'Marquês', 'Combatentes', 'Salgueiros', 'Pólo Universitário', 'IPO', 'Hospital de São João', 'Aeroporto', 'Botica', 'Contumil', 'Nasoni', 'Nau Vitória', 'Levada', 'Rio Tinto', 'Campainha', 'Baguim', 'Carreira', 'Venda Nova', 'Fânzeres', 'Trindade', 'Senhora da Hora', 'Sete Bicas', 'Viso', 'Ramalde', 'Francos', 'Casa da Música', 'Carolina Michaëlis', 'Lapa', 'Bolhão', 'Campo 24 de Agosto', 'Heroísmo', 'Campanhã', 'Estádio do Dragão', 'Fonte do Cuco', 'Verdes', 'Crestins', 'Esposade', 'Custóias', 'Batalha', 'Ribeira']

path = 'D:/DBTP2/'

fcartao = open(path + 'cartao', 'w')
fpasse = open(path + 'passe', 'w')
ftitulo = open(path + 'titulo', 'w')
fcarregamento = open(path + 'carregamento', 'w')
fviagem = open(path + 'viagem', 'w')
fvalidacao = open(path + 'validacao', 'w')
foperador = open(path + 'operador', 'w')

idcarregamento = 1
idviagem = 1
idvalidacao = 1

for i in range(len(operadores)):
  seed()
  foperador.write(str(i+1)+'|'+str(operadores[i])+'|'+str(fake.random_int(min=299999999, max=999999999))+'|'+str(fake.random_int(min=5000, max=50000))+'\n')

#gerar viagens
#for i in range(10000000):
#  seed()
#  fviagem.write(str(i+1)+'|'+str(choice(estacoes))+'\n')

cartoes = 500000
#cartoes = 800000
print('cartoes \t'+str(cartoes))
for i in range(0,cartoes):
  seed()
  idcartao = str(i+1)
  datavenda = fake.date_time_this_year()

  fcartao.write(idcartao+'|'+str(datavenda)+'\n')

  # passes
  if i %10 == 0:
    valor = fake.random_int(min=5, max=60)
    ultimoCarregamento = fake.date_time_between(start_date="-10y", end_date=datavenda)
    estado = choice(['0', '1'])
    bi = fake.random_int(min=99999999, max=999999999)
    nome = fake.name()
    nif = fake.random_int(min=99999999, max=299999999)
    profissao = fake.job()
    estadocivil = choice(['casado', 'solteiro', 'viuvo'])
    telemovel = fake.phone_number()
    morada = fake.city()

    #Pelo menos 10 anos mais novo do que a data de compra
    data = datetime(datavenda.year-10, datavenda.month, datavenda.day, datavenda.hour, datavenda.minute, datavenda.second)
    datanascimento = fake.date_time_between(start_date="-40y", end_date=data)
    fpasse.write(str(idcartao)+'|'+str(valor)+'|'+str(ultimoCarregamento)+'|'+str(estado)+'|'+str(bi)+'|'+str(nome)+'|'+str(nif)+'|'+str(profissao)+'|'+str(estadocivil)+'|'+str(telemovel)+'|'+str(morada)+'|'+str(datanascimento)+'\n')

    # gerar os carregamentos
    for j in range(randint(2,10)):
      seed()
      nviagens = 62
      valor = nviagens * 2
      datacarregamento = fake.date_time_between(start_date=datavenda, end_date="+1y")
      maquina = randint(1,1000)

      fcarregamento.write(str(idcarregamento)+'|'+
                    str(idcartao)+'|'+
                    str(datacarregamento)+'|'+
                    str(nviagens)+'|'+
                    str(valor)+'|'+
                    str(maquina)+'\n')
      idcarregamento += 1

      # gerar as viagens
      for k in range(nviagens):
        seed()

        localentrada = choice(estacoes)

        fviagem.write(str(idviagem)+'|'+
                      str(localentrada)+'\n')

        # gerar as validaçoes
        for m in range (randint(1,5)):
          seed()
          idoperador = randint(1,len(operadores))
          datavalidacao = fake.date_time_between(start_date=datacarregamento, end_date="+1y")

          fvalidacao.write(str(idcartao)+'|'+
                    str(idvalidacao)+'|'+
                    str(idoperador)+'|'+
                    str(idviagem)+'|'+
                    str(datavalidacao)+'\n')
          idvalidacao += 1

        idviagem += 1

  # titulos
  else:
    nviagens = randint(1,20)
    viagensGastas = randint(nviagens,nviagens+5) - nviagens

    ftitulo.write(str(idcartao)+'|'+str(nviagens)+'\n')

    # gerar os carregamentos
    for j in range(randint(2,10)):
      seed()
      valor = nviagens * 2
      datacarregamento = fake.date_time_between(start_date=datavenda, end_date="+1y")
      maquina = randint(1,1000)

      fcarregamento.write(str(idcarregamento)+'|'+
                    str(idcartao)+'|'+
                    str(datacarregamento)+'|'+
                    str(nviagens)+'|'+
                    str(valor)+'|'+
                    str(maquina)+'\n')
      idcarregamento += 1

      # gerar as viagens
      for k in range(nviagens):
        seed()

        localentrada = choice(estacoes)

        fviagem.write(str(idviagem)+'|'+
                      str(localentrada)+'\n')

        # gerar as validaçoes
        for m in range (randint(1,5)):
          seed()
          idoperador = randint(1,len(operadores))
          datavalidacao = fake.date_time_between(start_date=datacarregamento, end_date="+1y")

          fvalidacao.write(str(idcartao)+'|'+
                    str(idvalidacao)+'|'+
                    str(idoperador)+'|'+
                    str(idviagem)+'|'+
                    str(datavalidacao)+'\n')
          idvalidacao += 1

        idviagem += 1



fcartao.close()
fpasse.close()
ftitulo.close()
fcarregamento.close()
fviagem.close()
fvalidacao.close()
foperador.close()


print('carregamentos \t'+str(idcarregamento))
print('viagens \t\t'+str(idviagem))
print('validacoes \t'+str(idvalidacao))

#varias validaçoes, da mesma viagem, do mesmo operador