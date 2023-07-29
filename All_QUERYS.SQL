------------------------------------------------------------
-- CRIAÇÃO DO BANCO DE DADOS PARA O CENÁRIO DE E-COMMERCE --
------------------------------------------------------------
CREATE DATABASE Ecommerce; ---------------------------------
USE Ecommerce; ---------------------------------------------
------------------------------------------------------------
------------------------------------------------------------
SHOW TABLES;
SHOW DATABASES;
DROP DATABASE ECOMMERCE;
-- CLIENTE -------------------------------------------------
CREATE TABLE CUSTOMER(
	idCustomer INT AUTO_INCREMENT PRIMARY KEY,
    Fname VARCHAR(10),
    Minit CHAR(3),
    Lname VARCHAR(20),
	CPF CHAR(11),
    Address VARCHAR(30),
	CONSTRAINT UNIQUE_CLIENT_CPF UNIQUE(CPF)
);
DESCRIBE CUSTOMER;
------------------------------------------------------------
-- PRODUTO -------------------------------------------------
------------------------------------------------------------
CREATE TABLE PRODUCT(
	idProduto INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(10) NOT NULL,
    Classification_kids BOOL DEFAULT FALSE, -- Se for TRUE, o produto será para crianças
    Category ENUM("Eletrônico","Vestimenta","Brinquedos","Alimentos","Móveis") NOT NULL,
    Avaliação FLOAT DEFAULT 0,
    Size VARCHAR(10) -- Dimensão do produto
);
------------------------------------------------------------
-- PAGAMENTO -----------------------------------------------
------------------------------------------------------------
CREATE TABLE PAYMENTS(
	idcustomer INT,
    idPayment INT,
    typePayment ENUM("Boleto","Pix","Dinheiro","Cartão de débito","Cartão de crédito"),
    limitAvailable FLOAT,
    PRIMARY KEY(idCustomer, idpayment)
);
DROP TABLE PAYMENTS;
------------------------------------------------------------
-- PEDIDO --------------------------------------------------
------------------------------------------------------------
DROP TABLE ORDERS;
CREATE TABLE ORDERS(
	 idOrder INT AUTO_INCREMENT PRIMARY KEY,
     idOrderCustomer INT,
     OrderStatus ENUM("CANCELADO","CONFIRMADO","EM PROCESSAMENTO") DEFAULT "EM PROCESSAMENTO",
	 OrderDescription varchar(255),
     SendValue FLOAT DEFAULT 10,
     PaymentCash BOOL DEFAULT FALSE,
     -- CONSTRAINT FK_ORDERS_PAYMENTS FOREIGN KEY (idOrderCustomer) REFERENCES PAYMENTS(idCustomer),
     CONSTRAINT FK_ORDERS_CUSTOMER FOREIGN KEY (idOrderCustomer) REFERENCES CUSTOMER(idCustomer)
);
-- CONSTRAINT FK_ORDERS_PAYMENTS FOREIGN KEY (idOrderCustomer) REFERENCES PAYMENTS(idCustomer),
------------------------------------------------------------
-- ESTOQUE -------------------------------------------------
------------------------------------------------------------
CREATE TABLE ESTOQUE(
      idProdStorage INT AUTO_INCREMENT PRIMARY KEY,
	  StorageLocation VARCHAR(255),
      Quantity INT DEFAULT 0
);
------------------------------------------------------------
-- FORNECEDOR ----------------------------------------------
------------------------------------------------------------
CREATE TABLE SUPPLIER(
      idSupplier INT AUTO_INCREMENT PRIMARY KEY,
      SocialName VARCHAR(50) NOT NULL,
      CNPJ CHAR(15) NOT NULL,
      Contact CHAR(11) NOT NULL,
      CONSTRAINT UNIQUE_SUPPLIER UNIQUE(CNPJ)
);
------------------------------------------------------------
-- VENDEDOR ------------------------------------------------
------------------------------------------------------------
CREATE TABLE SELLER(
	idSeller INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(200) NOT NULL,
    AbsName VARCHAR(255),
    CNPJ CHAR(15),
    CPF CHAR(9),
    Location VARCHAR(255),
    Contact CHAR(11) NOT NULL,
    CONSTRAINT UNIQUE_CNPJ_SELLER UNIQUE (CNPJ),
    CONSTRAINT UNIQUE_CPF_SELLER UNIQUE (CPF)
);
DROP TABLE SELLER;
------------------------------------------------------------
-- PRODUTO VENDEDOR ----------------------------------------
------------------------------------------------------------
CREATE TABLE PRODUCTSELLER(
	idPSeller INT,
    idProduct INT,
    prodQuantity INT DEFAULT 1,
    PRIMARY KEY(idPSeller, idProduct),
    CONSTRAINT FK_PRODUCT_SELLER FOREIGN KEY (idPSeller) REFERENCES SELLER(idSeller),
    CONSTRAINT FK_PRODUCT_PRODUCT FOREIGN KEY (idProduct) REFERENCES PRODUCT(idProduto)
);
DESCRIBE PRODUCTSELLER;
------------------------------------------------------------
-- ORDEM PRODUTO -------------------------------------------
------------------------------------------------------------
CREATE TABLE PRODUCTORDER(
	idPOproduct INT,
    idPOorder INT,
    poQuantity INT DEFAULT 1,
    poStatus ENUM("Disponível","Sem Estoque") DEFAULT "Disponível",
    PRIMARY KEY (idPOproduct, idPOorder),
    CONSTRAINT FK_PRODUCT_SELLER_ORDER FOREIGN KEY (idPOproduct) REFERENCES PRODUCT(idProduto),
    CONSTRAINT FK_PRODUCT_PRODUCT_ORDER FOREIGN KEY (idPOorder) REFERENCES ORDERS(idOrder)
);
------------------------------------------------------------
-- ESTOQUE LOCALIZAÇÃO -------------------------------------
------------------------------------------------------------
CREATE TABLE STORAGELOCATION(
	idLproduct INT,
    idLstorage INT,
    Location VARCHAR(255) NOT NULL,
    PRIMARY KEY (idLproduct,idLstorage),
    CONSTRAINT FK_STORAGE_LOCATION_PRODUCT FOREIGN KEY (idLproduct) REFERENCES PRODUCT(idProduto),
    CONSTRAINT FK_STORAGE_LOCATION_STORAGE FOREIGN KEY (idLstorage) REFERENCES ESTOQUE(idProdStorage)
);
------------------------------------------------------------
-- PRODUTO FORNECEDOR --------------------------------------
------------------------------------------------------------
CREATE TABLE PRODUCTSUPPLIER(
	idPsSupplier INT,
    idPsProduct INT,
    Quantity INT NOT NULL,
    PRIMARY KEY (idPsSupplier,idPsProduct),
    CONSTRAINT FK_PRODUCT_SUPPLIER_SUPPLIER FOREIGN KEY(idPsSupplier) REFERENCES SUPPLIER(idSupplier),
    CONSTRAINT FK_PRODUCT_SUPPLIER_PRODUCT FOREIGN KEY(idPsProduct) REFERENCES PRODUCT(idProduto)
);
DROP TABLE PRODUCTSUPPLIER;
SHOW TABLES;
SHOW DATABASES;
USE INFORMATION_SCHEMA;
SHOW TABLES;
USE INFORMATION_SCHEMA;
SHOW TABLES;
DESCRIBE REFERENTIAL_CONSTRAINTS;
SELECT * FROM REFERENTIAL_CONSTRAINTS WHERE constraint_schema = 'ecommerce';
USE ECOMMERCE;
DESCRIBE CUSTOMER;

INSERT INTO CUSTOMER(Fname,Minit,Lname,CPF,Address)
values('Maria','M','Silva',12346789,'Rua Silva 29, Recife'),
      ('Matheus','C','Alves',03467389,'Rua Firmino 200,Rio de Janeiro'),
      ('Pedro','A','Cabral',20346624,'Rua Santos 20,São Paulo')
      
INSERT INTO PRODUCT(Pname,Classification_kids,Category,Avaliação,Size)
VALUES('Headphone',TRUE,'Eletrônico','4',NULL),
('Mouse',TRUE,'Eletrônico','5',NULL),
('Mesa',FALSE,'Móveis','4',NULL);

INSERT INTO ORDERS(idOrderCustomer,OrderStatus,OrderDescription,SendValue,PaymentCash)
VALUES(1 , DEFAULT , 'COMPRA VIA APLICATIVO', NULL , 1),
(2 , DEFAULT , 'COMPRA VIA APLICATIVO' , 50 , 0),
(3 , 'Confirmado' , NULL , NULL , 0)
DELETE FROM ORDERS WHERE idOrderCustomer in (1,2,3);
SELECT * FROM ORDERS
INSERT INTO PRODUCTORDER(idPOproduct,idPOorder,poQuantity,poStatus)
VALUES(1,5,2,NULL),(2,5,1,NULL),(3,6,1,NULL)

INSERT INTO STORAGELOCATION(idLproduct,idLstorage,Location)
VALUES(1,2,'RJ'),(2,6,'GO');