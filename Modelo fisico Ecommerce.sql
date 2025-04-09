-- Criando modelo físico do projeto de E-commerce

CREATE DATABASE Ecommerce;
USE Ecommerce;

-- Criando as tabelas de clientes (PJ e PF)

CREATE TABLE IF NOT EXISTS ClientePF(
	idClientePF INT AUTO_INCREMENT NOT NULL,
    Nome VARCHAR(45) NOT NULL,
    CPF VARCHAR(14) NOT NULL UNIQUE,
    Endereco VARCHAR(45) NOT NULL,
    DataNascimento DATE NOT NULL,
    CONSTRAINT pk_idclientepf_cliente PRIMARY KEY(idClientePF)
);
 
CREATE TABLE IF NOT EXISTS ClientePJ(
	idClientePJ INT AUTO_INCREMENT NOT NULL,
    Nome VARCHAR(45) NOT NULL,
    CNPJ VARCHAR(14) NOT NULL UNIQUE,
    Endereco VARCHAR(45) NOT NULL,
    CONSTRAINT pk_idclientepj_cliente PRIMARY KEY(idClientePJ)
);

-- Criando a tabela de produto

CREATE TABLE IF NOT EXISTS Produto(
	idProduto INT AUTO_INCREMENT NOT NULL,
    Nome VARCHAR(45) NOT NULL,
    Categoria VARCHAR(14) NOT NULL,
    PrecoUnitario FLOAT NOT NULL,
    CustoUnitario FLOAT NOT NULL,
    CONSTRAINT pk_idprod_produto PRIMARY KEY(idProduto),
    CONSTRAINT check_categoria_produto CHECK(Categoria IN ('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos'))
);

-- Criando a tabela fornecedor

CREATE TABLE IF NOT EXISTS Fornecedor(
	idFornecedor INT AUTO_INCREMENT NOT NULL,
    NomeFornecedor VARCHAR(45) NOT NULL,
    CNPJ VARCHAR(14) NOT NULL,
    Endereco VARCHAR(45) NOT NULL,
    CONSTRAINT PK_idfornecedor_fornecedor PRIMARY KEY(idFornecedor),
    CONSTRAINT unique_cnpj_fornecedor UNIQUE(CNPJ)
);
 
-- Criando a tabela Estoque

CREATE TABLE IF NOT EXISTS Estoque(
	idEstoque INT AUTO_INCREMENT NOT NULL,
    Local VARCHAR(45) NOT NULL,
    CONSTRAINT pk_idestoque_estoque PRIMARY KEY(idEstoque)
);

-- Criando a tabela Terceiro (vendedor)

CREATE TABLE IF NOT EXISTS Terceiro_Vendedor(
	idTerceiro INT AUTO_INCREMENT NOT NULL,
    Nome VARCHAR(45) NOT NULL,
    DataNascimento DATE NOT NULL,
    Endereco VARCHAR(45) NOT NULL,
    CPF VARCHAR(14) NOT NULL,
    CONSTRAINT pk_idterceiro_terceiro PRIMARY KEY(idTerceiro),
    CONSTRAINT unique_cpf_terceiro UNIQUE(CPF)
); 
 
-- Criando a tabela pedido

CREATE TABLE IF NOT EXISTS Pedido(
	idPedido INT AUTO_INCREMENT NOT NULL,
    idClientePF INT,
    idClientePJ INT,
    DataPedido DATETIME NOT NULL,
    DataEstimada DATETIME NOT NULL,
    DataEntrega DATETIME,
    ValorTotal FLOAT NOT NULL,
    Quantidade INT NOT NULL CHECK(Quantidade > 0),
    Frete FLOAT NOT NULL CHECK(Frete >= 0),
    FormaDePagamento VARCHAR(45) NOT NULL,
    StatusEntrega VARCHAR(45) NOT NULL,
    CodRastreio VARCHAR(13) NOT NULL,
    CONSTRAINT pk_idpedido_pedido PRIMARY KEY(idPedido),
    CONSTRAINT fk_idclientepf_cliente FOREIGN KEY(idClientePF) REFERENCES ClientePF(idClientePF),
    CONSTRAINT fk_idclientepj_cliente FOREIGN KEY(idClientePJ) REFERENCES ClientePJ(idClientePJ),
    CONSTRAINT check_status_pedido CHECK(StatusEntrega IN ('Entregue', 'Não Entregue', 'Cancelado')),
    CONSTRAINT check_formas_pagamento_pedido CHECK(FormaDePagamento IN ('Débito', 'Crédito', 'PIX', 'Boleto Bancário'))
); 

-- Criando as tabelas auxiliares/tabelas N:N

-- Criando a tabela de Produto/pedido

CREATE TABLE IF NOT EXISTS Produto_Pedido(
	idPedido INT NOT NULL,
    idProduto INT NOT NULL,
    CONSTRAINT pk_idpedido_idproduto_produto_pedido PRIMARY KEY(idPedido, idProduto),
    CONSTRAINT fk_idpedido_produto_pedido FOREIGN KEY(idPedido) REFERENCES Pedido(idPedido),
    CONSTRAINT fk_idproduto_produto_pedido FOREIGN KEY(idProduto) REFERENCES Produto(idProduto)
);
 
-- Criando a tabela Quantidade em estoque

CREATE TABLE IF NOT EXISTS QuantidadeEmEstoque(
	idProduto INT NOT NULL,
    idEstoque INT NOT NULL,
    Quantidade INT NOT NULL CHECK(Quantidade > 0),
    CONSTRAINT pk_idproduto_idestoque_quantidadeemestoque PRIMARY KEY(idProduto, idEstoque),
    CONSTRAINT fk_idproduto_quantidadeemestoque FOREIGN KEY(idProduto) REFERENCES Produto(idProduto),
    CONSTRAINT fk_idestoque_quantidadeemestoque FOREIGN KEY(idEstoque) REFERENCES Estoque(idEstoque)
);
 
-- Criando a tabela de Disponibilizando um produto

CREATE TABLE IF NOT EXISTS DisponibilizandoUmProduto(
	idProduto INT NOT NULL,
    idFornecedor INT NOT NULL,
    CONSTRAINT pk_idproduto_idfornecedor_dispo_produto PRIMARY KEY(idProduto, idFornecedor),
    CONSTRAINT fk_idproduto_dispo_produto FOREIGN KEY(idProduto) REFERENCES Produto(idProduto),
    CONSTRAINT fk_idfornecedor_dispo_produto FOREIGN KEY(idFornecedor) REFERENCES Fornecedor(idFornecedor)
);
 
-- Criando a tabela Produto por vendedor

CREATE TABLE IF NOT EXISTS ProdutoPorVendedor(
	idProduto INT NOT NULL,
    idTerceiro INT NOT NULL,
    CONSTRAINT pk_idproduto_idterceiro_produtoporvendedor PRIMARY KEY(idProduto, idTerceiro),
    CONSTRAINT fk_idproduto_produtoporvendedor FOREIGN KEY(idProduto) REFERENCES Produto(idProduto),
    CONSTRAINT fk_idterceiro_produtoporvendedor FOREIGN KEY(idTerceiro) REFERENCES Terceiro_Vendedor(idTerceiro)
);
 
 -- Persistindo dados nas tabelas(principais)
 
INSERT INTO ClientePF(Nome, CPF, Endereco, DataNascimento)
VALUES
('Ana Beatriz Silva', '123.456.789-10', 'Rua das Palmeiras, 123 - São Paulo/SP', '1990-05-12'),
('Carlos Eduardo Lima', '234.567.890-21', 'Av. Brasil, 456 - Rio de Janeiro/RJ', '1985-08-30'),
('Fernanda Oliveira', '345.678.901-32', 'Rua das Acácias, 789 - Belo Horizonte/MG', '1993-11-25'),
('João Pedro Martins', '456.789.012-43', 'Av. Getúlio Vargas, 321 - Porto Alegre/RS', '1988-02-14'),
('Mariana Costa Souza', '567.890.123-54', 'Rua João XXIII, 654 - Salvador/BA', '1995-09-08'),
('Lucas Henrique Rocha', '678.901.234-65', 'Av. Dom Pedro I, 147 - Curitiba/PR', '1991-12-01'),
('Patrícia Mendes Ferreira', '789.012.345-76', 'Rua Amazonas, 258 - Recife/PE', '1987-07-19'),
('Ricardo Almeida Nunes', '890.123.456-87', 'Rua do Comércio, 963 - Manaus/AM', '1994-04-03'),
('Juliana Ramos Duarte', '901.234.567-98', 'Av. Independência, 159 - Brasília/DF', '1992-10-17'),
('Thiago Santos Ribeiro', '012.345.678-09', 'Rua das Flores, 753 - Florianópolis/SC', '1989-06-22'),
('Larissa Gomes Andrade', '111.222.333-44', 'Rua das Hortênsias, 112 - Campinas/SP', '1996-03-18'),
('Bruno César Farias', '222.333.444-55', 'Av. das Nações, 788 - Fortaleza/CE', '1986-01-11'),
('Natália Pires Rocha', '333.444.555-66', 'Rua do Sol, 452 - Vitória/ES', '1997-08-09'),
('Felipe Moura Barros', '444.555.666-77', 'Av. Central, 199 - João Pessoa/PB', '1984-12-27'),
('Isabela Nogueira Pinto', '555.666.777-88', 'Rua Frei Caneca, 305 - Maceió/AL', '1990-04-15'),
('Matheus Lima Tavares', '666.777.888-99', 'Av. das Árvores, 870 - Belém/PA', '1993-02-06'),
('Camila Duarte Souza', '777.888.999-00', 'Rua 7 de Setembro, 120 - Teresina/PI', '1991-11-13'),
('André Luiz Santana', '888.999.000-11', 'Rua Dom Pedro II, 666 - Goiânia/GO', '1989-09-05'),
('Renata Carvalho Melo', '999.000.111-22', 'Av. Afonso Pena, 400 - Campo Grande/MS', '1992-07-01'),
('Gabriel Torres Monteiro', '000.111.222-33', 'Rua Sete Lagoas, 321 - São Luís/MA', '1995-05-29');


INSERT INTO ClientePJ(Nome, CNPJ, Endereco)
VALUES
('Alpha Tech Soluções LTDA', '12345678000190', 'Av. Paulista, 1000 - São Paulo/SP'),
('Beta Logística e Transportes LTDA', '23456789000101', 'Rua das Andorinhas, 450 - Campinas/SP'),
('Gamma Comércio de Alimentos LTDA', '34567890000112', 'Av. Dom Pedro II, 1234 - Belo Horizonte/MG'),
('Delta Consultoria Empresarial LTDA', '45678901000123', 'Rua XV de Novembro, 987 - Curitiba/PR'),
('Epsilon Engenharia e Construções LTDA', '56789012000134', 'Rua Amazonas, 1111 - Manaus/AM'),
('Zeta Produtos Naturais ME', '67890123000145', 'Rua Independência, 321 - Porto Alegre/RS'),
('Eta Indústria Têxtil S.A.', '78901234000156', 'Av. das Nações, 600 - Salvador/BA'),
('Theta Energia Renovável LTDA', '89012345000167', 'Rua do Sol, 222 - Fortaleza/CE'),
('Iota Sistemas de Informação LTDA', '90123456000178', 'Av. Brasil, 909 - Recife/PE'),
('Kappa Cosméticos e Perfumaria ME', '01234567000189', 'Rua das Flores, 800 - Florianópolis/SC'),
('Lambda Telecomunicações LTDA', '11122133000110', 'Av. das Araucárias, 75 - Brasília/DF'),
('Mu Comércio de Bebidas LTDA', '22233244000121', 'Rua Boa Vista, 654 - São Luís/MA'),
('Nu Design e Criação LTDA', '33344355000132', 'Av. Tiradentes, 777 - Vitória/ES'),
('Xi Representações Comerciais LTDA', '44455466000143', 'Rua da Liberdade, 128 - Goiânia/GO'),
('Omicron Digital Solutions LTDA', '55566577000154', 'Av. das Palmeiras, 321 - Campo Grande/MS'),
('Pi Assessoria Contábil LTDA', '66677688000165', 'Rua 13 de Maio, 999 - João Pessoa/PB'),
('Rho Educacional e Treinamentos LTDA', '77788799000176', 'Av. Getúlio Vargas, 456 - Maceió/AL'),
('Sigma Eventos Corporativos LTDA', '88899800000187', 'Rua da Alegria, 100 - Teresina/PI'),
('Tau Indústria de Calçados LTDA', '99900911000198', 'Av. Industrial, 555 - Belém/PA'),
('Upsilon Soluções Médicas LTDA', '00011122000109', 'Rua Central, 123 - Natal/RN');

INSERT INTO Estoque(Local)
VALUES
('Centro de Distribuição - São Paulo/SP'),
('Depósito Regional - Belo Horizonte/MG'),
('Armazém Norte - Manaus/AM'),
('Unidade de Estoque - Curitiba/PR'),
('Galpão Logístico - Salvador/BA');
 
INSERT INTO Fornecedor(NomeFornecedor, CNPJ, Endereco)
VALUES
('Forbras Indústria de Plásticos LTDA', '12001001000110', 'Rua das Indústrias, 1200 - São Paulo/SP'),
('Distribuidora Almeida e Filhos LTDA', '23112223000121', 'Av. das Nações, 300 - Fortaleza/CE'),
('Tecfer Componentes Eletrônicos LTDA', '34223334000132', 'Rua Eletrônica, 987 - Curitiba/PR'),
('FarmaVida Produtos Farmacêuticos LTDA', '45334445000143', 'Av. Brasil, 159 - Rio de Janeiro/RJ'),
('EcoAgro Insumos Agrícolas LTDA', '56445556000154', 'Estrada Rural, km 12 - Goiânia/GO'),
('MetalMinas Siderúrgica LTDA', '67556667000165', 'Rua do Aço, 200 - Belo Horizonte/MG'),
('Madeireira Santa Cruz ME', '78667778000176', 'Rua das Árvores, 444 - Porto Velho/RO'),
('Alfa Papelaria e Escritório LTDA', '89778889000187', 'Av. Central, 321 - Recife/PE'),
('Super Embalagens LTDA', '90889900000198', 'Rua do Comércio, 150 - Salvador/BA'),
('Luminá Eletrônicos e Iluminação LTDA', '01990011000109', 'Av. Luzes, 789 - Florianópolis/SC');

INSERT INTO Produto(Nome, Categoria, PrecoUnitario, CustoUnitario)
VALUES
('Smartphone X100', 'Eletrônico', 1899.90, 1350.00),
('Notebook Ultrafino Z', 'Eletrônico', 3499.99, 2750.00),
('Fone Bluetooth MaxSound', 'Eletrônico', 299.90, 180.00),
('Câmera Digital AlphaShot', 'Eletrônico', 1249.00, 950.00),
('Smartwatch FitLife', 'Eletrônico', 499.00, 320.00),
('Jaqueta Corta-Vento Unissex', 'Vestimenta', 219.90, 120.00),
('Camiseta Algodão Premium', 'Vestimenta', 59.90, 28.00),
('Tênis Esportivo Runner Pro', 'Vestimenta', 349.00, 210.00),
('Calça Jeans Slim Fit', 'Vestimenta', 149.90, 90.00),
('Boné Aba Reta Urban', 'Vestimenta', 79.90, 40.00),
('Boneca Interativa Luísa', 'Brinquedos', 129.90, 75.00),
('Carrinho Controle Remoto', 'Brinquedos', 179.90, 110.00),
('Jogo de Blocos Criativos', 'Brinquedos', 89.90, 50.00),
('Pelúcia Gigante Urso', 'Brinquedos', 199.90, 120.00),
('Quebra-cabeça 1000 peças', 'Brinquedos', 69.90, 35.00),
('Chocolate Amargo 70%', 'Alimentos', 14.90, 8.00),
('Biscoito Integral de Aveia', 'Alimentos', 9.90, 4.50),
('Suco Natural de Laranja 1L', 'Alimentos', 7.90, 3.80),
('Café Gourmet Torrado 500g', 'Alimentos', 22.90, 12.00),
('Mix de Castanhas 250g', 'Alimentos', 29.90, 17.00),
('Tablet VisionPad 10', 'Eletrônico', 1149.90, 850.00),
('Mouse Gamer RGB', 'Eletrônico', 159.90, 90.00),
('Camiseta Esportiva DryFit', 'Vestimenta', 74.90, 40.00),
('Tênis Casual Street', 'Vestimenta', 289.90, 170.00),
('Kit Miniaturas Animais', 'Brinquedos', 59.90, 30.00),
('Massinha de Modelar Atóxica', 'Brinquedos', 39.90, 20.00),
('Achocolatado em Pó 400g', 'Alimentos', 11.90, 6.00),
('Granola com Frutas 500g', 'Alimentos', 18.90, 10.00),
('Teclado Mecânico Lumino', 'Eletrônico', 319.90, 220.00),
('HD Externo 1TB', 'Eletrônico', 399.90, 300.00);

INSERT INTO Terceiro_Vendedor(Nome, DataNascimento, Endereco, CPF)
VALUES
('Lucas Ferreira da Silva', '1990-05-12', 'Rua das Palmeiras, 120 - São Paulo/SP', '123.456.789-01'),
('Ana Carolina Souza Lima', '1985-08-22', 'Av. Central, 450 - Belo Horizonte/MG', '234.567.890-12'),
('Rafael Oliveira Mendes', '1992-03-30', 'Rua das Flores, 89 - Curitiba/PR', '345.678.901-23'),
('Juliana Castro Moreira', '1989-11-05', 'Travessa dos Lírios, 15 - Porto Alegre/RS', '456.789.012-34'),
('Bruno Martins Rocha', '1995-07-18', 'Rua João Pessoa, 300 - Salvador/BA', '567.890.123-45'),
('Camila Ribeiro Andrade', '1991-02-09', 'Av. Brasil, 1234 - Recife/PE', '678.901.234-56'),
('Pedro Henrique Lopes', '1987-12-14', 'Rua São João, 500 - Fortaleza/CE', '789.012.345-67'),
('Larissa Almeida Farias', '1993-06-27', 'Rua Dom Pedro II, 210 - Belém/PA', '890.123.456-78'),
('Felipe Moura Teixeira', '1990-09-01', 'Rua da Independência, 321 - Goiânia/GO', '901.234.567-89'),
('Mariana Duarte Pires', '1986-10-16', 'Av. das Nações, 88 - Brasília/DF', '012.345.678-90'),
('Carlos Eduardo Pinto', '1994-01-25', 'Rua Santo Amaro, 410 - Campo Grande/MS', '112.233.445-56'),
('Natália Gomes Bezerra', '1992-04-07', 'Av. Atlântica, 1200 - Natal/RN', '223.344.556-67'),
('Tiago Lima Nascimento', '1988-08-08', 'Rua das Acácias, 33 - João Pessoa/PB', '334.455.667-78'),
('Priscila Rocha Tavares', '1991-03-19', 'Rua Amazonas, 77 - Manaus/AM', '445.566.778-89'),
('Rodrigo Figueiredo Ramos', '1990-06-11', 'Rua Santa Rosa, 99 - Vitória/ES', '556.677.889-90'),
('Débora Silva Martins', '1987-05-03', 'Av. Getúlio Vargas, 150 - Florianópolis/SC', '667.788.990-01'),
('Gustavo Correia Dias', '1993-11-27', 'Rua Independente, 170 - Teresina/PI', '778.899.001-12'),
('Tatiane Barbosa Lopes', '1995-07-09', 'Rua Cruzeiro do Sul, 450 - Aracaju/SE', '889.900.112-23'),
('Marcelo Azevedo Brito', '1989-10-13', 'Rua Miguel Arraes, 600 - Maceió/AL', '990.011.223-34'),
('Isabela Fernandes Leite', '1996-12-22', 'Rua Santa Luzia, 278 - Palmas/TO', '101.112.131-41');

INSERT INTO Pedido(idClientePF, idClientePJ, DataPedido, DataEstimada, DataEntrega, ValorTotal, Quantidade, Frete, FormaDePagamento, StatusEntrega, CodRastreio)
VALUES
(NULL, 14, '2025-01-27', '2025-02-05', '2025-02-05', 512.97, 7, 100.86, 'Débito', 'Entregue', 'MMHA9TRMJ4V67'),
(NULL, 2, '2025-01-10', '2025-01-17', '2025-01-21', 1736.43, 6, 130.0, 'Crédito', 'Cancelado', 'VZDWAJ6FSWON0'),
(NULL, 19, '2025-04-25', '2025-04-30', '2025-04-30', 384.43, 9, 60.01, 'Débito', 'Entregue', '84PDTDVE8BA3E'),
(7, NULL, '2025-04-25', '2025-05-04', '2025-05-09', 2516.25, 7, 92.42, 'PIX', 'Entregue', 'YJXBO4WEN8RZ4'),
(NULL, 1, '2025-02-11', '2025-02-20', '2025-02-21', 271.56, 1, 63.3, 'PIX', 'Entregue', 'VFBFQQVY6K0O1'),
(9, NULL, '2025-02-02', '2025-02-11', '2025-02-11', 1501.06, 5, 97.39, 'Boleto Bancário', 'Entregue', 'KSE9VPIDZNHUE'),
(NULL, 11, '2025-04-25', '2025-05-01', '2025-05-03', 2440.19, 7, 94.94, 'PIX', 'Entregue', 'XT4EGTXAUV3WX'),
(6, NULL, '2025-01-08', '2025-01-15', '2025-01-15', 579.38, 9, 139.98, 'PIX', 'Cancelado', 'QKUJ0Y63RO3N7'),
(NULL, 20, '2025-03-06', '2025-03-14', '2025-03-14', 799.11, 7, 72.64, 'Boleto Bancário', 'Entregue', '0J3RPHSRT12X4'),
(NULL, 3, '2025-01-17', '2025-01-22', '2025-01-22', 1231.16, 8, 13.3, 'Crédito', 'Entregue', 'X7ZL1TEBNK1PZ'),
(5, NULL, '2025-02-24', '2025-03-03', '2025-03-08', 1389.93, 7, 30.14, 'PIX', 'Entregue', '7PM2F47MC8JFL'),
(8, NULL, '2025-03-21', '2025-03-29', '2025-03-29', 135.23, 2, 112.45, 'Débito', 'Cancelado', 'MZK55EXTPF07Y'),
(NULL, 17, '2025-02-13', '2025-02-19', '2025-02-24', 1532.63, 3, 138.31, 'Crédito', 'Entregue', 'M5H1A0DFB0BE1'),
(10, NULL, '2025-03-02', '2025-03-09', '2025-03-13', 1547.66, 5, 45.38, 'Crédito', 'Entregue', 'QNOESWWAZZXL1'),
(11, NULL, '2025-01-22', '2025-01-27', '2025-01-27', 957.61, 1, 108.86, 'Débito', 'Entregue', 'BCRXTKOBU6Y0J'),
(NULL, 8, '2025-01-30', '2025-02-05', '2025-02-05', 2805.38, 8, 143.92, 'Boleto Bancário', 'Cancelado', '73QUP4UO57NNT'),
(NULL, 10, '2025-01-06', '2025-01-11', '2025-01-14', 1101.55, 7, 14.53, 'Débito', 'Não entregue', 'NBW4G3DMB4Y8F'),
(4, NULL, '2025-02-21', '2025-02-28', '2025-02-28', 732.32, 5, 38.99, 'Crédito', 'Cancelado', 'YV60JJNZG1RIU'),
(18, NULL, '2025-02-09', '2025-02-15', '2025-02-15', 185.91, 1, 43.19, 'PIX', 'Cancelado', 'MEXZQ3MLOEN4Q'),
(NULL, 9, '2025-03-18', '2025-03-26', '2025-03-31', 1296.86, 5, 41.44, 'Débito', 'Entregue', 'HMI9OY8NW1T0V'),
(NULL, 4, '2025-02-17', '2025-02-26', '2025-02-26', 2244.91, 8, 50.29, 'PIX', 'Entregue', 'KQFPBIXSKOGIR'),
(NULL, 5, '2025-01-27', '2025-02-01', '2025-02-04', 174.87, 2, 34.74, 'PIX', 'Cancelado', 'Q2U9M1L35I0MW'),
(NULL, 7, '2025-02-15', '2025-02-25', '2025-02-27', 100.88, 2, 84.67, 'Débito', 'Não entregue', 'WPR1QJ3GMGYA4'),
(NULL, 6, '2025-02-02', '2025-02-09', '2025-02-09', 296.42, 9, 107.24, 'Boleto Bancário', 'Entregue', 'T3C1JESCTHBRW'),
(NULL, 13, '2025-01-25', '2025-01-30', '2025-02-02', 2675.1, 8, 81.89, 'Crédito', 'Entregue', 'YH5G8SP5O7Q5G'),
(3, NULL, '2025-03-17', '2025-03-25', '2025-03-25', 2850.91, 4, 20.71, 'Crédito', 'Cancelado', 'DAW6L8XCL39AZ'),
(12, NULL, '2025-04-13', '2025-04-21', '2025-04-21', 1406.61, 7, 45.68, 'PIX', 'Entregue', 'XPPNPM3HDNNPL'),
(NULL, 16, '2025-01-30', '2025-02-07', '2025-02-09', 1041.37, 6, 128.01, 'Crédito', 'Entregue', 'H7MW2ZQKY8ZPY'),
(NULL, 18, '2025-01-22', '2025-01-27', '2025-01-31', 1205.46, 9, 22.63, 'Crédito', 'Entregue', '5C3QKRGUZ1ZOM'),
(13, NULL, '2025-04-08', '2025-04-16', '2025-04-16', 2955.94, 10, 108.67, 'PIX', 'Entregue', '1UMHXNC18SWKZ');

 -- Persistindo dados nas tabelas(complementares)
 
 INSERT INTO Produto_Pedido (idPedido, idProduto)
VALUES
(1, 3),
(1, 8),
(1, 15),
(2, 5),
(2, 17),
(3, 9),
(3, 12),
(4, 1),
(4, 23),
(5, 7),
(5, 14),
(5, 25),
(6, 2),
(6, 4),
(7, 6),
(7, 19),
(8, 10),
(9, 11),
(9, 16),
(10, 3),
(10, 28),
(11, 13),
(12, 5),
(12, 22),
(12, 27),
(13, 20),
(14, 1),
(14, 17),
(15, 8),
(16, 30),
(17, 6),
(17, 29),
(18, 18),
(18, 21),
(19, 24),
(20, 9),
(20, 26),
(21, 2),
(21, 13),
(22, 7),
(22, 14),
(23, 11),
(24, 4),
(24, 15),
(25, 19),
(25, 20),
(26, 10),
(27, 1),
(28, 23),
(28, 12),
(29, 16),
(30, 6),
(30, 30);

INSERT INTO ProdutoPorVendedor (idProduto, idTerceiro)
VALUES
(1, 3),
(1, 8),
(2, 1),
(2, 10),
(3, 5),
(3, 7),
(4, 2),
(5, 6),
(5, 14),
(6, 11),
(7, 4),
(7, 19),
(8, 9),
(9, 3),
(9, 12),
(10, 16),
(11, 1),
(12, 8),
(13, 6),
(14, 13),
(15, 5),
(15, 20),
(16, 7),
(17, 2),
(17, 17),
(18, 4),
(19, 18),
(20, 10),
(21, 3),
(22, 1),
(22, 11),
(23, 15),
(24, 6),
(25, 14),
(26, 19),
(26, 2),
(27, 12),
(28, 9),
(28, 5),
(29, 16),
(30, 8),
(30, 20);

INSERT INTO DisponibilizandoUmProduto (idProduto, idFornecedor)
VALUES
(1, 2),
(1, 5),
(2, 3),
(3, 1),
(3, 6),
(4, 4),
(5, 2),
(5, 8),
(6, 7),
(7, 1),
(7, 9),
(8, 6),
(9, 5),
(10, 3),
(11, 2),
(11, 4),
(12, 10),
(13, 8),
(14, 6),
(15, 7),
(16, 1),
(17, 3),
(18, 4),
(19, 9),
(20, 2),
(21, 5),
(22, 6),
(23, 7),
(24, 10),
(25, 3),
(26, 1),
(27, 9),
(28, 8),
(29, 4),
(30, 10);

INSERT INTO QuantidadeEmEstoque (idProduto, idEstoque, Quantidade)
VALUES
(1, 1, 250),
(1, 3, 120),
(2, 2, 340),
(3, 1, 85),
(4, 4, 190),
(5, 5, 410),
(6, 2, 75),
(7, 3, 300),
(8, 1, 280),
(9, 5, 100),
(10, 4, 330),
(11, 1, 225),
(12, 2, 150),
(13, 3, 275),
(14, 5, 200),
(15, 4, 90),
(16, 2, 470),
(17, 3, 360),
(18, 5, 130),
(19, 1, 400),
(20, 4, 245),
(21, 5, 310),
(22, 3, 180),
(23, 1, 105),
(24, 2, 210),
(25, 5, 490),
(26, 4, 170),
(27, 3, 300),
(28, 2, 90),
(29, 1, 230),
(30, 4, 275);

-- Criando QUERIES!!!

-- ANÁLISE FINANCEIRA
-- Qual o total faturado?
SELECT ROUND(SUM(ValorTotal), 2) FROM Pedido; -- Resposta: 38.610.09

-- Qual o total de produtos vendidos?
SELECT SUM(Quantidade) FROM Pedido; -- Resposta: 175

-- Qual a média de valor do FRETE?
SELECT ROUND(AVG(Frete), 2) FROM Pedido; -- Resposta: 75.55

-- Qual o ticket médio das vendas?
SELECT ROUND(SUM(ValorTotal)/COUNT(*), 2) FROM Pedido; -- Resposta: 1287,00

-- Em qual mês ocorreu a maior quantidade de vendas? E qual mês faturou mais?
SELECT 
	MONTH(DataEntrega) AS 'Mês',
    SUM(Quantidade) AS 'Total vendas',
    ROUND(SUM(ValorTotal), 2) AS 'Total faturado'
FROM Pedido
GROUP BY MONTH(DataEntrega)
ORDER BY MONTH(DataEntrega); -- Mês que mais vendeu = 1, Mês que mais faturou = Maio

-- Qual a forma de pagamento mais usada?
SELECT 
	FormaDePagamento,
	COUNT(*) AS 'Total'
FROM Pedido
GROUP BY FormaDePagamento
ORDER BY COUNT(*) DESC; -- Resposta: PIX (usado 10 vezes)

-- Quais vendas que tiveram o frete com valor maior que 100 reais? Desconsiderar os pedidos cancelados!
SELECT * 
FROM Pedido 
WHERE Frete > 100 AND StatusEntrega <> 'Cancelado';

-- ANÁLISE PRODUTOS
-- Qual categoria de produto que mais faturou?
SELECT 
	Pr.Categoria,
    ROUND(SUM(P.ValorTotal), 2) AS 'Total Faturado'
FROM Pedido AS P
LEFT JOIN Produto_Pedido AS PrPe
	ON P.idPedido = PrPe.idPedido
		LEFT JOIN Produto as Pr
			ON PrPe.idProduto = Pr.idProduto
GROUP BY Pr.Categoria
ORDER BY SUM(P.ValorTotal) DESC; -- Resposta: Eletrônico (22360,18 Reais)

-- Qual foi o produto mais vendido? E qual foi o que mais faturou?
SELECT 
	Pr.Nome,
    ROUND(SUM(P.ValorTotal), 2) AS 'Total Faturado',
    COUNT(*) AS 'Total De Vendas'
FROM Pedido AS P
LEFT JOIN Produto_Pedido AS PrPe
	ON P.idPedido = PrPe.idPedido
		LEFT JOIN Produto as Pr
			ON PrPe.idProduto = Pr.idProduto
GROUP BY Pr.Nome
ORDER BY SUM(P.ValorTotal) DESC; -- Resposta: Produto mais vendido e que mais faturou foi: Jaqueta Corta-Vento Unissex (total vendas = 3, total faturado = 6497,68)


-- ANÁLISE DE CLIENTES
-- Qual tipo de cliente que fez mais pedidos (PF ou PJ)?
SELECT 
 COUNT(idClientePF) AS 'Total Cliente PF',
 COUNT(idClientePJ) AS 'Total Cliente PJ'
FROM Pedido; -- Resposta: Cliente PJ (18 Vendas)


-- Qual o intervalo de idade dos clientes PF (pessoa física)?
SELECT
	DISTINCT(TIMESTAMPDIFF(YEAR, DataNascimento, CURDATE())) AS Idade
FROM ClientePF
ORDER BY Idade ASC; -- Resposta: (27, 29, 31, 32, 33, 34, 35, 37, 39, 40)


-- ANÁLISE DE ESTOQUE
-- Quais categorias de produtos que tem maior número de estoque? Desconsidere no seu resumo a categoria de ALIMENTOS. 

SELECT 
	Categoria,
    SUM(Quantidade) AS 'Total em Estoque'
FROM Produto AS Pr
LEFT JOIN QuantidadeEmEstoque AS QE
	ON Pr.idProduto = QE.idProduto
GROUP BY Categoria
HAVING Categoria <> 'Alimentos'
ORDER BY SUM(Quantidade) DESC;

-- -- Em qual cidade temos a maior quantidade de produtos em estoque? Depois faça o mesmo resumo mas dividindo por categoria também!

SELECT
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(local, '/', 1), '-', -1)) AS 'Estado',
    SUM(QE.Quantidade) AS 'Total em Estoque'
FROM Estoque AS E
LEFT JOIN QuantidadeEmEstoque AS QE
	ON E.idEstoque = QE.idEstoque
GROUP BY TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(local, '/', 1), '-', -1))
ORDER BY SUM(QE.Quantidade) DESC; -- Resposta: Salvador (1640 unidades)

--

SELECT
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(local, '/', 1), '-', -1)) AS Cidade,
	SUM(CASE WHEN P.Categoria = 'Eletrônico' THEN QE.Quantidade ELSE 0 END) AS Eletronico,
    SUM(CASE WHEN P.Categoria = 'Alimentos' THEN QE.Quantidade ELSE 0 END) AS Alimentos,
    SUM(CASE WHEN P.Categoria = 'Brinquedos' THEN QE.Quantidade ELSE 0 END) AS Brinquedos,
    SUM(CASE WHEN P.Categoria = 'Vestimenta' THEN QE.Quantidade ELSE 0 END) AS Vestimenta
FROM Estoque AS E
	LEFT JOIN QuantidadeEmEstoque AS QE 
		ON E.idEstoque = QE.idEstoque
			LEFT JOIN Produto AS P 
				ON QE.idProduto = P.idProduto
GROUP BY Cidade
ORDER BY Cidade;


