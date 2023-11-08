#Sistema para Empresa de Transporte Rodoviario

create database bd_rodoviaria_2;
use bd_rodoviaria_2;

create table Estado (
id_est int not null primary key auto_increment,
nome_est varchar (200) not null,
sigla_est varchar (2)
);

create table Cidade (
id_cid int not null primary key auto_increment,
nome_cid varchar (200) not null,
id_est_fk int,
foreign key (id_est_fk) references Estado (id_est)
);

create table Endereço (
id_end integer not null primary key auto_increment,
rua_end varchar (300) not null,
numero_end integer,
bairro_end varchar (100),
cep_end varchar (100),
id_cid_fk int not null,
foreign key (id_cid_fk) references Cidade (id_cid)
); 

create table Sexo (
id_sex int not null primary key auto_increment,
nome_sex varchar (100) not null
);

create table Telefone (
id_tel int not null primary key auto_increment,
celular_tel varchar (100),
casa_tel varchar (100),
trabalho_tel varchar (100)
);

create table Cliente (
id_cli integer not null primary key auto_increment,
nome_cli varchar (200) not null,
estadocivil_cli varchar (50),
cpf_cli varchar (20) not null,
rg_cli varchar (30),
datanasc_cli date,
id_sex_fk integer not null,
id_end_fk integer not null,
id_tel_fk integer not null,
foreign key (id_sex_fk) references Sexo (id_sex),
foreign key (id_end_fk) references Endereço (id_end),
foreign key (id_tel_fk) references Telefone (id_tel)
);

create table Departamento (
id_dep integer not null primary key auto_increment,
nome_dep varchar (100),
descrição_dep varchar (300)
);

create table Funcionario (
id_func integer not null primary key auto_increment,
nome_func varchar (200) not null,
cpf_func varchar (20) not null,
rg_func varchar (20),
datanasc_func date,
salário_func double not null,
função_func varchar (50) not null,
id_sex_fk integer not null,
id_dep_fk integer not null,
id_end_fk integer not null,
id_tel_fk integer not null,
foreign key (id_sex_fk) references Sexo (id_sex),
foreign key (id_dep_fk) references Departamento (id_dep),
foreign key (id_end_fk) references Endereço (id_end),
foreign key (id_tel_fk) references Telefone (id_tel)
);

create table onibus (
id_oni integer not null primary key auto_increment,
modelo_oni varchar (100) not null,
marca_oni varchar (100),
placa_oni varchar (50),
tipo_oni varchar (100)
);

create table Poltrona(
id_pol integer not null primary key auto_increment,
número_pol integer not null,
situação_pol varchar (100) not null,
id_oni_fk integer not null,
foreign key (id_oni_fk) references Onibus (id_oni)
);

create table Trecho_Viagem (
id_tre integer not null primary key auto_increment,
data_part_tre date not null,
data_cheg_tre date not null,
horário_part_tre time not null,
horário_cheg_tre time not null,
distancia_tre float,
tarifa_tre float,
id_cid_origem_fk int not null,
id_cid_destino_fk int not null,
id_oni_fk int not null,
foreign key (id_cid_origem_fk) references Cidade (id_cid),
foreign key (id_cid_destino_fk) references Cidade (id_cid),
foreign key (id_oni_fk) references Onibus (id_oni)
);

create table Passagem (
id_pas integer not null primary key auto_increment,
data_pas date,
valor_pas float,
id_cli_fk integer not null,
id_func_fk integer not null,
id_tre_fk integer not null,
poltrona_pas integer,
foreign key (id_cli_fk) references Cliente (id_cli),
foreign key (id_func_fk) references Funcionario (id_func),
foreign key (id_tre_fk) references Trecho_Viagem (id_tre)
);

create table Caixa (
id_caixa integer not null primary key auto_increment,
dataabertura_caixa date not null,
datafechamento_caixa date,
saldoinicial_caixa double not null,
valorcréditos_caixa double,
valordébitos_caixa double,
saldofinal_caixa double,
id_func_fk int not null,
foreign key (id_func_fk) references Funcionario (id_func)
);

create table Recebimentos (
id_receb integer not null primary key auto_increment,
data_receb date,
valor_receb double,
formapag_receb varchar (100),
id_caixa_fk integer not null,
id_pas_fk integer not null,
foreign key (id_caixa_fk) references Caixa (id_caixa),
foreign key (id_pas_fk) references Passagem (id_pas)
);

#INICIE A PARTIR DAQUI SUA LISTA DE EXERCÍCIOS

# TAREFA 1
# AÇÃO: Inserir Estado.
DELIMITER $$
Create Procedure InserirEstado(NomeEst varchar(300), Sigla varchar(300))
BEGIN
    Declare teste_nome varchar(200);
	Set teste_nome = (Select nome_est From Estado Where nome_est = NomeEst);
    
	IF (teste_nome is null) then  #1º VERIFICAÇÃO 
        Insert Into Estado (nome_est, sigla_est) values (NomeEst, Sigla);
        Select concat('O estado ', NomeEst, ' foi inserido com sucesso!') as Confirmação; 
    ELSE
        Select concat('O estado ', NomeEst,' já existe! Digite outro estado.') as Alerta; 
    END IF;
    
END 
$$ DELIMITER ;

#CHAMADA 
Call InserirEstado('Rondônia', 'RO');
Call InserirEstado('Mato Grosso', 'MT');
Call InserirEstado('Acre', 'AC');
Call InserirEstado('Amazonas', 'AM');
Call InserirEstado('Mato Grosso do Sul', 'MS');
Call InserirEstado('Pará', 'PA');
Call InserirEstado('Tocantins', 'TO');
Call InserirEstado('Roraima', 'RR');
Call InserirEstado('Amapá', 'AP');
Call InserirEstado('Maranhão', 'MA');


# TAREFA 2
# AÇÃO: Inserir Cidade.
DELIMITER $$
Create Procedure InserirCidade (CidNome varchar(200), estado_fk int)
BEGIN
	Declare teste_nome varchar(300); 
	Declare teste_fk int;
	Set teste_nome = (Select nome_cid From Cidade Where (nome_cid = CidNome));
	Set teste_fk = (Select id_est From Estado Where (id_est = estado_fk));

	IF (teste_nome is null) then 	  #1º VERIFICAÇÃO    
		IF (teste_fk is not null) then		 #2º VERIFICAÇÃO
			Insert into Cidade (nome_cid, id_est_fk) values (CidNome, estado_fk);
			Select concat('A Cidade ', CidNome, ' foi inserida com sucesso!') as Confirmação;
		ELSE
			Select 'O código do estado informado não existe na tabela estado.' as Alerta;
		END IF;
    ELSE
			Select concat('A cidade ', CidNome, ' já existe! Digite outra cidade.') as Alerta;
    END IF;
    
END;
$$ DELIMITER ;

#CHAMADA
#RO
Call InserirCidade('Presidente Médice', 1);
Call InserirCidade('Ji-Paraná', 1);
Call InserirCidade('Cacoal', 1);
Call InserirCidade('Costa Marques', 1);
Call InserirCidade('Ariquemes', 1);
Call InserirCidade('Vilhena', 1);
Call InserirCidade('Rolim de Moura', 1);
Call InserirCidade('Ouro Preto do Oeste', 1);
Call InserirCidade('Rolim de Moura', 1);
Call InserirCidade('Alvorada', 1);

#MT
Call InserirCidade('Cuiabá', 2);
Call InserirCidade('Várzea Grande', 2);
Call InserirCidade('Rondonópolis', 2);

#AC
Call InserirCidade('Rio Branco', 3);
Call InserirCidade('Cruzeiro do Sul', 3);

#AM
Call InserirCidade('Manaus', 4);
Call InserirCidade('Itacoatiara', 4);
Call InserirCidade('Parintins', 4);

#MS
Call InserirCidade('Campo Grande', 5);
Call InserirCidade('Dourados', 5);


#Tarefa 3
#AÇÃO: Inserir Endereço
DELIMITER $$
Create Procedure InserirEndereço (
   Rua varchar (300),
   Numero int,
   Bairro varchar (100),
   Cep varchar (100),
   cidade_fk int
)
BEGIN
declare teste_fk int;
set teste_fk = (Select id_cid from Cidade where (id_cid = cidade_fk));

	IF (teste_fk is not null) then   # 1ª VERIFICAÇÃO
		Insert into Endereço (rua_end, numero_end, bairro_end, cep_end, id_cid_fk) 
		values (Rua, Numero, Bairro, CEP, cidade_fk);
			Select 'O Endereço foi salvo com sucesso!' as Confirmação;
	ELSE
			Select 'O código da cidade informado não existe na tabela cidade' as Alerta;
    END IF;

END;
$$ DELIMITER ;

#CHAMADA
Call InserirEndereço('Rua das Flores', 123, 'Bairro Jardim', '34567-890', 1);
Call InserirEndereço('Avenida Brasil', 456, 'Centro', '34567-891', 2);
Call InserirEndereço('Travessa da Paz', 789, 'Bairro Novo', '34567-892', 3);
Call InserirEndereço('Rua dos Pássaros', 321, 'Bairro Velho', '34567-893', 4);
Call InserirEndereço('Alameda das Árvores', 654, 'Bairro Industrial', '34567-894', 5);
Call InserirEndereço('Rua da Alegria', 987, 'Bairro Comercial', '34567-895', 6);
Call InserirEndereço('Avenida do Sol', 135, 'Bairro Solar', '34567-896', 7);
Call InserirEndereço('Travessa da Amizade', 246, 'Bairro da Estação', '34567-897', 8);
Call InserirEndereço('Rua dos Sonhos', 579, 'Bairro da Colina', '34567-898', 9);
Call InserirEndereço('Alameda da Esperança', 864, 'Bairro do Lago', '34567-899', 10);


# Tarefa 4
# AÇÃO: Inserir Sexo
DELIMITER $$ 
Create Procedure InserirSexo (nomeSex varchar(255))
BEGIN
   declare sexo_teste varchar(200);
   set sexo_teste = (Select nome_sex from Sexo where nome_sex = nomeSex);

   IF nomeSex <> '' then 	#1ª VERIFICAÇÃO 
	 IF sexo_teste is null then 	#2ª VERIFICAÇÃO
        Insert into Sexo (nome_sex) values (nomeSex);
			Select concat('O Sexo ', nomeSex, ' foi inserido com sucesso!') AS Confirmação;
     ELSE
			Select concat('Sexo ', nomeSex, ' já existe! Digite outro sexo.') AS Alerta;
	 END IF;
	ELSE
			Select 'O campo Sexo não pode ser vazio!' AS Alerta;
	END IF;

END 
$$ DELIMITER ;

#CHAMADA
Call InserirSexo('Feminino');
Call InserirSexo('Masculino');


