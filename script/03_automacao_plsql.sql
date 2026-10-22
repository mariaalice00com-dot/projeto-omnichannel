-- ============================================
-- PROJETO: SISTEMA DE GESTAO OMNICHANNEL
-- ETAPA 3: PROCEDURE E TRIGGER
-- MySQL 8.0
-- ============================================

USE omnichannel_db;

-- Remove as rotinas anteriores para permitir recriacao
DROP PROCEDURE IF EXISTS sp_registrar_venda;
DROP TRIGGER IF EXISTS trg_auditoria_preco;

DELIMITER $$

-- ============================================
-- 1. PROCEDURE PARA REGISTRAR UMA VENDA
-- ============================================

CREATE PROCEDURE sp_registrar_venda(
    IN p_id_cliente INT,
    IN p_id_loja INT,
    IN p_id_produto INT,
    IN p_quantidade INT
)
BEGIN
    DECLARE v_preco DECIMAL(10,2);
    DECLARE v_estoque INT;
    DECLARE v_id_pedido INT;
    DECLARE v_existe INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_quantidade IS NULL OR p_quantidade <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Quantidade deve ser maior que zero';
    END IF;

    START TRANSACTION;

    -- Confere se cliente existe
    SELECT COUNT(*) INTO v_existe
    FROM clientes
    WHERE id_cliente = p_id_cliente;

    IF v_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cliente nao encontrado';
    END IF;

    -- Confere se loja existe
    SELECT COUNT(*) INTO v_existe
    FROM lojas
    WHERE id_loja = p_id_loja;

    IF v_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Loja nao encontrada';
    END IF;

    -- Consulta o produto e bloqueia sua linha
    SELECT preco, estoque_atual
    INTO v_preco, v_estoque
    FROM produtos
    WHERE id_produto = p_id_produto
    FOR UPDATE;

    IF v_estoque < p_quantidade THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Estoque insuficiente';
    END IF;

    -- Cria o pedido
    INSERT INTO pedidos (
        id_cliente,
        id_loja,
        valor_total,
        status
    )
    VALUES (
        p_id_cliente,
        p_id_loja,
        v_preco * p_quantidade,
        'Concluido'
    );

    SET v_id_pedido = LAST_INSERT_ID();

    -- Registra o item vendido
    INSERT INTO itens_pedido (
        id_pedido,
        id_produto,
        quantidade,
        preco_unitario
    )
    VALUES (
        v_id_pedido,
        p_id_produto,
        p_quantidade,
        v_preco
    );

    -- Atualiza o estoque
    UPDATE produtos
    SET estoque_atual = estoque_atual - p_quantidade
    WHERE id_produto = p_id_produto;

    COMMIT;

    SELECT
        v_id_pedido AS id_pedido,
        p_id_cliente AS id_cliente,
        p_id_produto AS id_produto,
        p_quantidade AS quantidade,
        v_preco AS preco_unitario,
        v_preco * p_quantidade AS valor_total,
        'Concluido' AS status_venda;
END$$

-- ============================================
-- 2. TRIGGER DE AUDITORIA DE PRECOS
-- ============================================

CREATE TRIGGER trg_auditoria_preco
AFTER UPDATE ON produtos
FOR EACH ROW
BEGIN
    IF NOT (OLD.preco <=> NEW.preco) THEN
        INSERT INTO auditoria_preco (
            id_produto,
            preco_antigo,
            preco_novo,
            data_alteracao,
            usuario
        )
        VALUES (
            NEW.id_produto,
            OLD.preco,
            NEW.preco,
            NOW(),
            USER()
        );
    END IF;
END$$

DELIMITER ;

-- ============================================
-- 3. TESTE DA VENDA
-- Use IDs existentes no banco
-- ============================================

CALL sp_registrar_venda(1, 4, 3, 2);

-- Conferir o pedido criado
SELECT *
FROM pedidos
ORDER BY id_pedido DESC
LIMIT 1;

-- Conferir o item do pedido
SELECT *
FROM itens_pedido
ORDER BY id_pedido DESC
LIMIT 1;

-- Conferir o estoque do produto 3
SELECT id_produto, nome, estoque_atual
FROM produtos
WHERE id_produto = 3;

-- ============================================
-- 4. TESTE DA AUDITORIA DE PRECOS
-- ============================================

UPDATE produtos
SET preco = preco + 10.00
WHERE id_produto = 3;

-- Conferir o historico de auditoria
SELECT *
FROM auditoria_preco
WHERE id_produto = 3
ORDER BY id_auditoria DESC;
