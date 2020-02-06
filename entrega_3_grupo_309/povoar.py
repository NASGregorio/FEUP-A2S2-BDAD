import hashlib
from faker import Faker

faker = Faker('en-US')

def generate_email(nome, word):
    appendees = [ 'gmail.com', 'hotmail.com', 'fe.up.pt', 'yahoo.com']
    return nome.replace(' ', '').lower()+'.'+word.lower()+'@'+appendees[faker.pyint() % len(appendees)] 
def generate_trivial(table, func=None, custo=True):
    if func == None:
        if not custo:
            return 'INSERT INTO ' + table + '(nome) VALUES(\''+faker.sentence().replace(' ', '').lower()+'\');'
        return 'INSERT INTO ' + table + '(nome, custo_hora) VALUES(\''+faker.sentence().replace(' ', '').lower()+'\', ' + str(1.0) + ');'

    if not custo:
        return 'INSERT INTO ' + table + '(nome) VALUES(\''+func()+'\');'

    return 'INSERT INTO ' + table + '(nome, custo_hora) VALUES(\''+func()+'\', ' + str(1.0)+ ');'

all_bdad = []
clientes = []
gpu = []
so = []
pais = []
cidade = []
backend = []
rede = []
tipo_disco = []
tarifario = []
servicos = []
armazenamento = []
armazenamento_servico = []
app = []
vps = []
instancia_virtual = []
instancia_virtual_servico = []
transferencias = []
sessao = []
cc = []


graficas_marca = ['Nvidia', 'AMD', 'Intel']
graficas = ['Radeon', 'GTX', 'RTX', 'HD', 'Quadro', 'Wx']

def generate_os():
    if faker.pyint()%2:
        return 'Windows ' + faker.city().split()[0] + ' ' + str(faker.pyint()%20 + 1)
    return 'Linux ' + faker.color_name() + ' ' + str(faker.pyint()%10 + 1)

languages = ['Python', 'NodeJS', 'Ruby', 'Erlang', 'Haskell', 'Go', 'Elixir', 'FORTRAN', 'COBOL',
        'BrainFuck', 'PHP', 'Perl', 'Scala', 'Java', 'Clojure', 'Groovy', 'Kotlin', 'C#', 'VB', 'F#',
        'CoffeeScript', 'LISP']

def generate_backend():
    return languages[faker.pyint()%len(languages)] + ' ' + str(faker.pyint()%10 + 1) + '.' + str(faker.pyint()%10 + 1)

def gerar_gpu():
    return 'INSERT INTO GPU(vendor, modelo, version, custo_hora) VALUES (\'' + graficas_marca[faker.pyint()%len(graficas_marca)] + '\', \'' + graficas[faker.pyint()%len(graficas)] + '\', ' + str((faker.pyint() % 9 + 1) * 10) + str(faker.pyint() % 10 * 10) + ', {});'.format(abs(round(faker.pyfloat()%12.0+0.1, 2)))


def gerar_so():
    cur_nome = generate_os().split()
    return 'INSERT INTO SistemaOperativo(nome, flavor, version, custo_hora) VALUES (\'' + cur_nome[0] + '\', \'' + cur_nome[1] + '\', ' + str(faker.pyint()%10 + 1) + ', ' + str(abs(round(faker.pyfloat()%2.0 + 0.1, 2))) + ');'


merda1 = []
def gerar_backend():
    u1, u2, u3, u4 = languages[faker.pyint()%len(languages)], str(faker.pyint()%10), str(faker.pyint()%10), str(abs(round(faker.pyfloat()%2.0 + 0.1, 2)))

    while (u1, u2, u3) in merda1:
        u3 = str(int(u3) + 1)
    merda1.append((u1,u2,u3))
    return 'INSERT INTO Backend(nome, major, minor, custo_hora) VALUES (\'' + u1 + '\', ' + u2 + ', ' + u3 + ', ' + u4 + ');'

for _ in range(40):
    gpu.append(gerar_gpu())

for _ in range(50):
    so.append(gerar_so())

pais = [generate_trivial('Pais', faker.country, custo=False) for i in range(30)]

for _ in range(100):
    backend.append(gerar_backend())

backend = list(dict.fromkeys(backend))

rede_nomes = ['Visa', 'Visa Electron', 'MasterCard', 'AmericanExpress', 'Discover', 'UnionPay', 'JCB',
        'Maestro', 'Shazam', 'Plus', 'Pulse', 'Accel']
for rede_nome in rede_nomes:
    rede.append('INSERT INTO Rede(nome) VALUES(\''+ rede_nome + '\');')

pais = list(dict.fromkeys(pais))
gpu = list(dict.fromkeys(gpu))

#gera cidades
for i,pai in enumerate(pais):
    
    for _ in range(5 + (faker.pyint()%20)):
        cidade.append('INSERT INTO Cidade(nome, pais) VALUES(\'' + 
        faker.city() + '\', '+
        str(i+1) + ');')

cidade = list(dict.fromkeys(cidade))

#gera clientes
for _ in range(5000):
    nome = faker.name()
    email = generate_email(nome, faker.word())
    clientes.append('INSERT INTO Cliente VALUES (\'' +
            email + '\',' +
            ' \'' + nome + '\',' 
            ' \'' + faker.sha256() + '\',' +
            ' \'' + faker.phone_number() + '\',' +
            ' \'' + faker.address().replace('\n', ' ') + '\',' +
            str(faker.pyint() % 200) 
            + ');')
    for _ in range(faker.pyint()%5 + 1):
        namero = []
        for _ in range(16):
            namero.append(str(faker.pyint()%10))
        namero = ''.join(namero)
        cc.append(
                'INSERT INTO CC VALUES (\'' + namero + '\', \'' + faker.name() + '\', ' + str(abs(faker.pyint()%100)) + ', ' + str(faker.pyint()%len(rede) + 1) + ', ' + str(abs(faker.pyint()) + 1) + ', \'' + email + '\');'
                )


clientes = list(dict.fromkeys(clientes))

merda = []
#gera servicos
for _ in range(12000):
    asdf = clientes[faker.pyint() % len(clientes)][29:].split(',')[0]
    fasdf = str(faker.pyint())
    if (asdf, fasdf) in merda:
        continue
    merda.append((asdf, fasdf))
    servicos.append('INSERT INTO Servico(cliente, data_inicio, data_cancelamento, cidade) VALUES (\'' +
            asdf + ', ' + 
            fasdf + ', ' +
            (str(int(fasdf)+faker.pyint()) if faker.pyint()%3 is not 0 else 'NULL') + ', ' +
            str(faker.pyint() % len(cidade) + 1) +
            ');')

#gera tipos de disco
for _ in range(90):
    tipo_disco.append('INSERT INTO TipoDeDisco(nome, capacidade, custo_mensal, custo_gb_escrito) VALUES (\'' +
            faker.first_name() + '\', ' + 
            str(round(abs(faker.pyfloat())%9.0+1.0, 1)) + ', ' +
            ' \'' + str(round(abs(faker.pyfloat())%50.0+5.0, 2)) + '\',' +
            ' \'' + str(round(abs(faker.pyfloat())%0.5+0.1, 2)) +
            '\');')


#Tarifario(id_tarifario, limite_tb, custo_base, custo_gb_extra)
#gera tarifario
for _ in range(200):
    tarifario.append('INSERT INTO Tarifario(limite_tb, custo_base, custo_gb_extra) VALUES (\'' +
            str(round((faker.pyfloat()%9 + 1) * 10, 1))+ '\', ' + 
            ' \'' + str(round(abs(faker.pyfloat())%25.0+5.0, 2)) + '\',' +
            ' \'' + str(round(abs(faker.pyfloat())%0.5+0.1, 2)) +
            '\');')

used_servicos = 0
#gera armazenamento
for _ in range(4000):
    tipo = faker.pyint()%len(tipo_disco) + 1
    tarifa = faker.pyint()%len(tarifario) + 1
    if used_servicos == len(servicos):
        break
    cur_servico = used_servicos + 1
    armazenamento.append('INSERT INTO Armazenamento(custo_fixo, servico, tarifario, tipo_disco, custo_variavel) VALUES (' +
            '((SELECT custo_base FROM Tarifario WHERE id_tarifario={}) + (SELECT custo_mensal FROM TipoDeDisco WHERE id_disco={}))'.format(tarifa, tipo) + ', ' + 
            str(cur_servico) + ', ' +
            str(tarifa) + ', ' +
            str(tipo) + ', ' +
            str(1.0) +
            ');')
    armazenamento_servico.append(cur_servico)
    used_servicos += 1

used_armazenamento = 0
#gera InstanciaVirtual
for _ in range(8000):
    if used_servicos == len(servicos):
        break
    if used_armazenamento == len(armazenamento):
        break
    cur_servico = used_servicos + 1
    instancia_virtual.append('INSERT INTO InstanciaVirtual(custo_arranque, custo_hora, servico, armazenamento) VALUES (' +
            str(round(faker.pyfloat()%0.3+0.1, 1)) + ', ' +
            str(round(faker.pyfloat()%0.2+0.1, 1)) + ', ' +
            str(cur_servico) + ', ' + 
            str(armazenamento_servico[used_armazenamento]) + 
            ');')
    instancia_virtual_servico.append(cur_servico)
    used_servicos += 1
    used_armazenamento += 1

instancia_virtual = list(dict.fromkeys(instancia_virtual))
instancia_virtual_servico = list(dict.fromkeys(instancia_virtual_servico))

used_instancias = 0
#gera apps
for _ in range(4000):
    if used_instancias == len(instancia_virtual):
        break
    app.append('INSERT INTO App VALUES (' +
            str(instancia_virtual_servico[used_instancias]) + ', ' + 
            str(faker.pyint()%8+1) + ', ' +
            str(faker.pyint()%len(backend)+1) +
            ');')
    used_instancias += 1

so = list(dict.fromkeys(so))
#gera vps
for _ in range(4000):
    if used_instancias == len(instancia_virtual_servico):
        break

    num_cores = faker.pyint()%6+1
    num_ram = num_cores*8
    num_cores += faker.pyint()%3
    placa = faker.pyint()%(len(gpu)+1)
    if placa == 0:
        placa = 'NULL'

    vps.append('INSERT INTO VPS VALUES (' +
            str(instancia_virtual_servico[used_instancias]) + ', ' + 
            str(num_cores) + ', ' +
            str(num_ram) + ', ' +
            str(faker.pyint()%len(so) + 1) + ', ' +
            str(placa)+
            ');')
    used_instancias += 1


#gera transferencias
for _ in range(4000):
    arma = armazenamento_servico[faker.pyint()%len(armazenamento_servico)]
    transferencias.append('INSERT INTO Transferencia VALUES (\'' +
            faker.word() + '\', ' + 
            str(abs(faker.pyint()) + 1) + ', ' +
            str(faker.pyint()%2) + ', ' + 
            '(SELECT data_inicio FROM Servico WHERE id_serv={}) + {} , '.format(arma, abs(faker.pyint())) +
            str(arma) +
            ');')

#gera sessoes   
for _ in range(2000):
    arma = instancia_virtual_servico[faker.pyint()%len(instancia_virtual_servico)]
    primeiro_add = abs(faker.pyint())
    segundo_add = abs(faker.pyint())
    if faker.pyint()%2 == 0:
        sessao.append('INSERT INTO Sessao VALUES (' +
            str(arma) + ', ' + 
            '(SELECT data_inicio FROM Servico WHERE id_serv={}) + {} , '.format(arma, primeiro_add) +
            '(SELECT data_inicio FROM Servico WHERE id_serv={}) + {}'.format(arma, primeiro_add+segundo_add) +
            ');')
    else:
        sessao.append('INSERT INTO Sessao(ins, data_abertura) VALUES (' +
            str(arma) + ', ' + 
            '(SELECT data_inicio FROM Servico WHERE id_serv={}) + {} '.format(arma, primeiro_add) +
            ');')

all_bdad.append(so)
all_bdad.append(gpu)
all_bdad.append(pais)
all_bdad.append(cidade)
all_bdad.append(backend)
all_bdad.append(rede)
all_bdad.append(clientes)
all_bdad.append(tipo_disco)
all_bdad.append(tarifario)
all_bdad.append(servicos)
all_bdad.append(armazenamento)
all_bdad.append(instancia_virtual)
all_bdad.append(app)
all_bdad.append(vps)
all_bdad.append(transferencias)
all_bdad.append(sessao)
all_bdad.append(cc)

for l in all_bdad:
    l = list(dict.fromkeys(l))
    l.sort()
    for linha in l:
        print(linha)
