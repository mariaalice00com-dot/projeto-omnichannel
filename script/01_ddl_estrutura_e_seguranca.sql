-- ============================================
-- PROJETO: SISTEMA DE GESTAO OMNICHANNEL
-- ETAPA 1: ESTRUTURA E SEGURANCA
-- MySQL 8.0
-- ============================================

CREATE DATABASE IF NOT EXISTS omnichannel_db;

USE omnichannel_db;

-- 1. TABELA DE CLIENTES
CREATE TABLE IF NOT EXISTS clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    email VARCHAR(120) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2. TABELA DE LOJAS
CREATE TABLE IF NOT EXISTS lojas (
    id_loja INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    tipo ENUM('Fisica', 'Online') NOT NULL,
    cidade VARCHAR(80) NOT NULL,
    uf CHAR(2) NOT NULL
);

-- 3. TABELA DE PRODUTOS
CREATE TABLE IF NOT EXISTS produtos (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    categoria VARCHAR(80) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    estoque_atual INT NOT NULL DEFAULT 0,
    CONSTRAINT chk_preco CHECK (preco >= 0),
    CONSTRAINT chk_estoque CHECK (estoque_atual >= 0)
);

-- 4. TABELA DE PEDIDOS
CREATE TABLE IF NOT EXISTS pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    data_pedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_cliente INT NOT NULL,
    id_loja INT NOT NULL,
    valor_total DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    status ENUM('Pendente', 'Concluido', 'Cancelado')
        NOT NULL DEFAULT 'Pendente',
    CONSTRAINT chk_valor_total CHECK (valor_total >= 0),
    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES clientes(id_cliente),
    CONSTRAINT fk_pedido_loja
        FOREIGN KEY (id_loja)
        REFERENCES lojas(id_loja)
);

-- 5. TABELA DE ITENS DO PEDIDO
CREATE TABLE IF NOT EXISTS itens_pedido (
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (id_pedido, id_produto),
    CONSTRAINT chk_item_quantidade CHECK (quantidade > 0),
    CONSTRAINT chk_item_preco CHECK (preco_unitario >= 0),
    CONSTRAINT fk_item_pedido
        FOREIGN KEY (id_pedido)
        REFERENCES pedidos(id_pedido),
    CONSTRAINT fk_item_produto
        FOREIGN KEY (id_produto)
        REFERENCES produtos(id_produto)
);

-- 6. TABELA DE AUDITORIA DE PRECOS
CREATE TABLE IF NOT EXISTS auditoria_preco (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    id_produto INT NOT NULL,
    preco_antigo DECIMAL(10,2) NOT NULL,
    preco_novo DECIMAL(10,2) NOT NULL,
    data_alteracao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(288) NOT NULL,
    CONSTRAINT fk_auditoria_produto
        FOREIGN KEY (id_produto)
        REFERENCES produtos(id_produto)
);

-- FIM DA ESTRUTURA

USE omnichannel_db;

SHOW TABLES;

CREATE USER 'atendente_omni'@'%'
IDENTIFIED BY 'Troque_Esta_Senha_2026!';

GRANT SELECT ON omnichannel_db.produtos
TO 'atendente_omni'@'%';

GRANT SELECT ON omnichannel_db.clientes
TO 'atendente_omni'@'%';
SHOW GRANTS FOR 'atendente_omni'@'%';
