

from faker import Factory
from random import *
import datetime

fake = Factory.create('it_IT')


datavenda = fake.date_time_this_year()

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

data = datetime.datetime(datavenda.year-10, datavenda.month, datavenda.day, datavenda.hour, datavenda.minute, datavenda.second)
datanascimento = fake.date_time_between(start_date="-40y", end_date=data)

print(valor)
print(ultimoCarregamento)
print(estado)
print(bi)
print(nome)
print(nif)
print(profissao)
print(estadocivil)
print(telemovel)
print(morada)
print(datavenda)
print(datanascimento)