#Sistema para Empresa de Transporte Rodoviario
# EMILY DAMACENO, HILARY SOUZA, THAUANY CELESTINO.
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
        Select concat('O estado ', NomeEst, ' foi inserido com sucesso!') as CONFIRMAÇÃO; 
    ELSE
        Select concat('O estado ', NomeEst,' já existe! Digite outro estado.') as ALERTA; 
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
			Select concat('A Cidade ', CidNome, ' foi inserida com sucesso!') as CONFIRMAÇÃO;
		ELSE
			Select 'O estado inserido não existe!' as ALERTA;
		END IF;
    ELSE
			Select concat('A cidade ', CidNome, ' já existe! Digite outra cidade.') as ALERTA;
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


#TAREFA 3
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
			Select 'O Endereço foi salvo com sucesso!' as CONFIRMAÇÃO;
	ELSE
			Select 'A cidade fornecida não existe!' as ALERTA;
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


# TAREFA 4
# AÇÃO: Inserir Sexo
DELIMITER $$ 
Create Procedure InserirSexo (nomeSex varchar(255))
BEGIN
   declare sexo_teste varchar(200);
   set sexo_teste = (Select nome_sex from Sexo where nome_sex = nomeSex);

   IF nomeSex <> '' then 	#1ª VERIFICAÇÃO 
	 IF sexo_teste is null then 	#2ª VERIFICAÇÃO
        Insert into Sexo (nome_sex) values (nomeSex);
			Select concat('O Sexo ', nomeSex, ' foi inserido com sucesso!') AS CONFIRMAÇÃO;
     ELSE
			Select concat('Sexo ', nomeSex, ' já existe! Digite outro sexo.') AS ALERTA;
	 END IF;
	ELSE
			Select 'Preencha o campo Sexo!' AS ALERTA;
	END IF;

END 
$$ DELIMITER ;

#CHAMADA
Call InserirSexo('Feminino');
Call InserirSexo('Masculino');


# TAREFA 5 
#AÇÃO: Inserir Telefone
DELIMITER $$
Create procedure InserirTelefone ( celular varchar(100), casa varchar(200), trabalho varchar(100))
BEGIN 

	IF ( celular <> '' ) then	 # 1º VERIFICAÇÃO
		Insert into telefone values (null, celular, casa, trabalho);
			Select 'Os contatos foram salvos com secesso!' as CONFIRMAÇÃO;
	ELSE 
			Select 'Preencha o campo Celular!' as ALERTA;
	END IF;
END;
$$ DELIMITER ;

#CHAMADA
Call InserirTelefone ('21369874123' , '7456662666', '96666478787');
Call InserirTelefone ('55166456664', '555454555', '5122233121');
Call InserirTelefone ('25455665444', '99741288988', '555198878774');
Call InserirTelefone ('35655455654', '545565552365', '458962315847');
Call InserirTelefone ('56984712340', '31788970214', '11023074986');


# TAREFA 6
# AÇÃO: Inserir Cliente
DELIMITER $$
Create Procedure InserirCliente (Nome varchar(200), EstadoCivil varchar(200), CPF varchar(200),
RG varchar(200), DataNasc date, Sexo_fk int, Endereco_fk int, Telefone_fk int
)
BEGIN

declare sexo_teste int;
declare endereco_teste int;
declare telefone_teste int;

set sexo_teste = (Select id_sex from Sexo where (id_sex = Sexo_fk));
set endereco_teste = (Select id_end from Endereço where (id_end = Endereco_fk));
set telefone_teste = (Select id_tel from Telefone where (id_tel = Telefone_fk));

	IF (sexo_teste is not null) then 	#1ª VERIFICAÇÃO
		IF (endereco_teste is not null) then  #2ª VERIFICAÇÃO
			IF (telefone_teste is not null) then  #3ª VERIFICAÇÃO
					Insert into Cliente (nome_cli, estadocivil_cli, cpf_cli, rg_cli, datanasc_cli, id_sex_fk, id_end_fk, id_tel_fk) 
					values (Nome, EstadoCivil, CPF, RG, DataNasc, Sexo_fk, Endereco_fk, Telefone_fk);
					Select concat('O Cliente ', Nome, ' foi salvo com sucesso!') as CONFIRMAÇÃO;
			ELSE 
				Select 'O telefone informado não existe' as ALERTA;
			END IF;
		ELSE
			Select 'O endereço informado não existe' as ALERTA;
		END IF;
	ELSE
		Select 'O sexo informado não existe!' as ALERTA;
	END IF;
END;
$$ DELIMITER ;
 
#CHAMADA
Call InserirCliente('Fernanda Martins', 'Solteira', '55566677788', 'RG13579', '1993-07-20', 2, 6, 6);
Call InserirCliente('Ricardo Santos', 'Casado', '77788899900', 'RG24680', '1979-11-03', 1, 7, 7);
Call InserirCliente('Juliana Pereira', 'Casada', '22233344455', 'RG98765', '1988-04-15', 2, 8, 8);
Call InserirCliente('Gustavo Almeida', 'Solteiro', '88899900011', 'RG23456', '1991-12-08', 1, 9, 9);
Call InserirCliente('Larissa Silva', 'Divorciada', '11112223334', 'RG87654', '1987-10-25', 2, 10, 10);


# TAREFA 7
# AÇÃO: Inserir Departamento
DELIMITER $$
Create Procedure InserirDepartamento (nome varchar(300), descricao varchar(400))
BEGIN

 IF ( nome <> '') then	 # 1º VERIFICAÇÃO
	IF ( descricao <> '') then 	# 2º VERIFICAÇÃO
		Insert into departamento values (null, nome, descricao);
		Select concat('O Departamento ', nome,' foi inserido com sucesso!') as CONFIRMAÇÃO;
    ELSE
		Select 'Peencha o campo Descrição!'  as ALERTA;
	END IF;
ELSE
		Select 'Peencha o campo Nome!'  as ALERTA;
END IF;
END;
$$ DELIMITER ;
 
#CHAMADA
Call InserirDepartamento('Vendas de Passagens', 'Responsável por atrair passageiros, promover destinos, definir preços de passagens e gerenciar estratégias de marketing e vendas.');  
Call InserirDepartamento('Operações', 'Responsável por planejar e coordenar as operações diárias da frota de ônibus.');
Call InserirDepartamento('Finanças e Contabilidade', 'Lida com todas as questões financeiras da empresa, incluindo controle de despesas, orçamento e contabilidade.');

# TAREFA 8
# AÇÃO: Inserir Funcionário
DELIMITER $$
Create Procedure InserirFuncionario ( Nome varchar (200), CPF varchar(200), RG varchar (200), DataNasc date,
Salario double, Funcao varchar (50), Sexo_fk int, Departamento_fk int, Endereco_fk int, Telefone_fk int
)
BEGIN
	declare sexo_teste int;
	declare departamento_teste int;
	declare endereco_teste int;
	declare telefone_teste int;
	declare vendaDEP_teste int;

	set sexo_teste = (Select id_sex from Sexo where (id_sex = Sexo_fk));
	set departamento_teste = (Select id_dep from Departamento where (id_dep = Departamento_fk));
	set endereco_teste = (Select id_end from Endereço where (id_END = Endereco_fk));
	set telefone_teste = (Select id_tel from Telefone where (id_tel = Telefone_fk));
	set vendaDEP_teste = (Select id_dep from Departamento where (nome_dep LIKE 'Vendas de Passagens'));

IF (sexo_teste is not null) then  # 1º VERIFICAÇÃO
    IF (departamento_teste is not null) then # 2º VERIFICAÇÃO
        IF (endereco_teste is not null) then # 3º VERIFICAÇÃO
            IF (telefone_teste is not null) then # 4º VERIFICAÇÃO
                IF (Funcao LIKE 'Vendedor') then # 5º VERIFICAÇÃO
                    IF (Departamento_fk <> vendaDEP_teste) then # 5.1º VERIFICAÇÃO
                        Select 'Um Vendedor só pode ser inserido no departamento de Vendas de Passagens' as ALERTA;
                    ELSE
                        Insert into Funcionario (nome_func, cpf_func, rg_func, datanasc_func, salário_func, função_func, id_sex_fk, id_dep_fk, id_end_fk, id_tel_fk) 
                        values (Nome, CPF, RG, DataNasc, Salario, Funcao, Sexo_fk, Departamento_fk, Endereco_fk, Telefone_fk);
                        Select concat('O Funcionário ', Nome ,' foi salvo com sucesso!') as CONFIRMAÇÃO;
                    END IF;
                ELSE
                    Insert into Funcionario (nome_func, cpf_func, rg_func, datanasc_func, salário_func, função_func, id_sex_fk, id_dep_fk, id_end_fk, id_tel_fk) 
                    values (Nome, CPF, RG, DataNasc, Salario, Funcao, Sexo_fk, Departamento_fk, Endereco_fk, Telefone_fk);
                    Select concat('O Funcionário ', Nome ,' foi salvo com sucesso!') as CONFIRMAÇÃO;
                END IF;
            ELSE 
                Select 'O telefone informado não existe' as ALERTA;
            END IF;
        ELSE 
            Select 'O endereço informado não existe' as ALERTA;
        END IF;
    ELSE 
        Select 'O departamento informado não existe' as ALERTA;
    END IF;
ELSE 
    Select 'O sexo informado não existe' as ALERTA;
END IF;

END;
$$ DELIMITER ;

#CHAMADA
Call InserirFuncionario ('Pedro Souza', '555.666.777-88', '55.666.777-8', '1999-10-11', 3200.00, 'Motorista', 1, 2, 5, 5);
Call InserirFuncionario ('Ana Pereira', '666.777.888-99', '66.777.888-9', '2000-11-12', 2900.00, 'Atendente', 2, 3, 2, 3);
Call InserirFuncionario ('Marcos Silva', '777.888.999-00', '77.888.999-0', '2001-12-13', 3100.00, 'Controlador', 1, 1, 7, 5);
Call InserirFuncionario ('Isabel Santos', '888.999.000-11', '88.999.000-1', '2002-01-14', 2800.00, 'Limpeza', 2, 1, 1, 2);

# TAREFA 9
# AÇÃO: Inserir Onibus
DELIMITER $$
Create Procedure InserirOnibus (Modelo varchar(200), Marca varchar(200),Placa varchar(200), Tipo varchar(200)
)
BEGIN
	IF ((Modelo = 'Amazon Bus Premium' and Tipo = 'Executive') or (Modelo = 'Amazon Bus Leito' and Tipo = 'Confort')) then  # 1º VERIFICAÇÃO
		Insert into Onibus (modelo_oni, marca_oni, placa_oni, tipo_oni) values (Modelo, Marca, Placa, Tipo);
			Select concat('O Ônibus foi salvo com sucesso!') as CONFIRMAÇÃO;
	ELSE
		Select 'Digite um modelo e tipo de ônibus válidos: "Amazon Bus Premium e Executive" ou "Amazon Bus Leito  e Confort".' as ALERTA;
    END IF;
END;
$$ DELIMITER ;

#CHAMADA
Call InserirOnibus ('Amazon Bus Leito', 'Volvo', 'DEF-5678', 'Executive');
Call InserirOnibus ('Amazon Bus Premium', 'Iveco', 'MNO-9012', 'Executive');
Call InserirOnibus ('Amazon Bus Leito', 'MAN', 'PQR-3456', 'Confort');
Call InserirOnibus ('Amazon Bus Premium', 'MercedesBenz', 'ABC-1234', 'Executive');

# TAREFA 10
# AÇÃO: Inserir Poltrona
DELIMITER $$
Create Procedure InserirPoltronas(Onibusfk int)
BEGIN
 declare tipo_teste varchar(100);
 declare contador int;
 declare limite int;

 select tipo_oni into tipo_teste from Onibus where id_oni = Onibusfk;
    
 IF (tipo_teste LIKE 'Executive' OR tipo_teste LIKE 'Confort') then # 1º VERIFICAÇÃO
	IF tipo_teste = 'Executive' then
		set limite = 48;
	ELSE
		set limite = 58;
	END IF;

	set contador = 1;
	WHILE contador <= limite DO
		Insert into Poltrona (número_pol, situação_pol, id_oni_fk) values (contador, 'Livre', Onibusfk);
		set contador = contador + 1;
	END WHILE;
		select 'As poltronas do ônibus foram inseridas com sucesso!' AS CONFIRMAÇÃO;
ELSE
	select 'Digite um tipo de ônibus válido: "Executive" ou "Confort".' AS ALERTA;
END IF;
END;
$$
DELIMITER ;

#CHAMADA
Call InserirPoltronas (1);
Call InserirPoltronas (2);
Call InserirPoltronas (3);
Call InserirPoltronas (4);
