-- ============================================
-- PROJETO: SISTEMA DE GESTAO OMNICHANNEL
-- ETAPA 2: POVOAMENTO INICIAL (DML)
-- ============================================

USE omnichannel_db;

-- 1. CLIENTES: 5 REGISTROS
INSERT INTO clientes
(nome, cpf, email, telefone, data_cadastro)
VALUES
('Ana Silva', '11111111111', 'ana@email.com',
 '81999990001', '2026-01-10 09:00:00'),
('Bruno Santos', '22222222222', 'bruno@email.com',
 '81999990002', '2026-01-11 10:30:00'),
('Carla Oliveira', '33333333333', 'carla@email.com',
 '81999990003', '2026-01-12 11:00:00'),
('Diego Souza', '44444444444', 'diego@email.com',
 '81999990004', '2026-01-13 14:00:00'),
('Eduarda Lima', '55555555555', 'eduarda@email.com',
 '81999990005', '2026-01-14 15:30:00');

-- 2. LOJAS: 5 REGISTROS
INSERT INTO lojas (nome, tipo, cidade, uf)
VALUES
('Loja Recife Centro', 'Fisica', 'Recife', 'PE'),
('Loja Salvador Shopping', 'Fisica', 'Salvador', 'BA'),
('Loja Fortaleza Norte', 'Fisica', 'Fortaleza', 'CE'),
('E-commerce VarejoOmni', 'Online', 'Recife', 'PE'),
('Loja Natal Centro', 'Fisica', 'Natal', 'RN');

-- 3. PRODUTOS: 5 REGISTROS
INSERT INTO produtos
(nome, categoria, preco, estoque_atual)
VALUES
('Notebook Lenovo', 'Informatica', 3200.00, 20),
('Smartphone Samsung', 'Telefonia', 1800.00, 35),
('Fone Bluetooth', 'Acessorios', 150.00, 50),
('Monitor LG 24', 'Informatica', 850.00, 15),
('Teclado Mecanico', 'Acessorios', 280.00, 40);

-- 4. PEDIDOS: 5 REGISTROS
-- Os IDs referenciados correspondem aos registros acima
INSERT INTO pedidos
(data_pedido, id_cliente, id_loja, valor_total, status)
VALUES
('2026-02-01 10:00:00', 1, 4, 3200.00, 'Concluido'),
('2026-02-02 11:30:00', 2, 1, 1800.00, 'Concluido'),
('2026-02-03 14:15:00', 3, 4, 300.00, 'Concluido'),
('2026-02-04 16:00:00', 4, 2, 850.00, 'Pendente'),
('2026-02-05 17:20:00', 5, 3, 560.00, 'Concluido');

-- 5. ITENS DOS PEDIDOS: 5 REGISTROS
INSERT INTO itens_pedido
(id_pedido, id_produto, quantidade, preco_unitario)
VALUES
(1, 1, 1, 3200.00),
(2, 2, 1, 1800.00),
(3, 3, 2, 150.00),
(4, 4, 1, 850.00),
(5, 5, 2, 280.00);

-- 6. AUDITORIA DE PRECOS: 5 REGISTROS
-- Registros iniciais para demonstracao do historico
INSERT INTO auditoria_preco
(id_produto, preco_antigo, preco_novo, data_alteracao, usuario)
VALUES
(1, 3100.00, 3200.00, '2026-01-20 09:00:00', 'admin'),
(2, 1750.00, 1800.00, '2026-01-21 10:00:00', 'admin'),
(3, 140.00, 150.00, '2026-01-22 11:00:00', 'gerente'),
(4, 800.00, 850.00, '2026-01-23 12:00:00', 'gerente'),
(5, 260.00, 280.00, '2026-01-24 13:00:00', 'admin');

-- ============================================
-- CONFERENCIA DOS DADOS
-- ============================================

SELECT * FROM clientes;
SELECT * FROM lojas;
SELECT * FROM produtos;
SELECT * FROM pedidos;
SELECT * FROM itens_pedido;
SELECT * FROM auditoria_preco;

USE omnichannel_db;

SELECT 'clientes' AS tabela, COUNT(*) AS total
FROM clientes
UNION ALL
SELECT 'lojas', COUNT(*) FROM lojas
UNION ALL
SELECT 'produtos', COUNT(*) FROM produtos
UNION ALL
SELECT 'pedidos', COUNT(*) FROM pedidos
UNION ALL
SELECT 'itens_pedido', COUNT(*) FROM itens_pedido
UNION ALL
SELECT 'auditoria_preco', COUNT(*) FROM auditoria_preco;